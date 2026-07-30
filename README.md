# keymory_off

Base reutilizável para apps Flutter offline-first, com um exemplo funcional
completo: destravar um cofre local usando biometria do dispositivo.

Este não é um produto final, é uma base. A ideia é que ela sirva de ponto de
partida para qualquer app Flutter que precise rodar 100% localmente, sem
depender de servidor: banco de dados local já configurado, autenticação
biométrica funcional, internacionalização, tema, roteamento e CI/CD prontos,
tudo testado.

A feature `unlock` existente serve como exemplo de referência: mostra o
padrão completo de camadas (`domain` → `data` → `presentation`) que qualquer
feature nova neste projeto deve seguir.

## O que já funciona

### Vault local (SQLite via Drift)

O banco fica em `keymory.sqlite`, dentro do diretório de documentos do app
(via `path_provider`), aberto em background com
`NativeDatabase.createInBackground` para não travar a UI na inicialização.

O schema é escrito com a abordagem SQL-first do Drift: em vez de definir
tabelas como classes Dart (o caminho "Dart-first", com `Table` e
`@DataClassName`), o projeto escreve SQL puro num arquivo `.drift` e deixa o
`drift_dev` gerar o código Dart a partir dele. Essa ligação é feita em
`app_database.dart`:

```dart
@DriftDatabase(include: {'tables/vault_metadata.drift'})
class AppDatabase extends _$AppDatabase {
  ...
}
```

Existe uma única tabela hoje, `vault_metadata`, definida assim em
`tables/vault_metadata.drift`:

```sql
CREATE TABLE vault_metadata (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  salt TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at INTEGER NOT NULL
);
```

Essa tabela guarda no máximo uma linha (sempre `id = 1`, com
`insertOnConflictUpdate`): existe apenas um vault por dispositivo, então não
há necessidade de múltiplas linhas nem de uma chave estrangeira para
relacionar com outra coisa. Nunca a senha em texto puro, só o salt e o hash.

O `build.yaml` já habilita o módulo `fts5` do SQLite para o Drift:

```yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          sql:
            dialect: sqlite
            options:
              modules:
                - fts5
```

Isso deixa o gerador de código pronto para reconhecer sintaxe de tabelas
virtuais `fts5` assim que uma existir, mas nenhuma tabela usa isso ainda: a
única tabela do projeto (`vault_metadata`) guarda salt, hash e timestamp,
nada que faça sentido buscar por texto. O módulo está aqui para quando
alguma feature futura precisar de busca full-text local (por exemplo, um
gerenciador de senhas com nome de site, login e notas pesquisáveis).

### Derivação de chave com Argon2id

`KeyDerivation`, em `domain/services`, usa o pacote `cryptography` com estes
parâmetros:

- `parallelism`: 4
- `memory`: 19456 KB (aproximadamente 19 MB)
- `iterations`: 2
- `hashLength`: 32 bytes

Esses valores seguem o mínimo recomendado pela OWASP para Argon2id. O salt é
gerado com `Random.secure()`, 16 bytes aleatórios, um por vault. A senha
nunca é comparada em texto puro: `verifyPassword` deriva o hash da senha
recebida com o mesmo salt armazenado e compara os dois hashes.

### Desbloqueio via biometria do sistema

`UnlockWithBiometrics`, em `domain/usecases`, usa o pacote `local_auth` para
dois passos:

1. Confirma que o dispositivo suporta autenticação local
   (`isDeviceSupported`).
2. Dispara o prompt nativo do sistema (`authenticate`), que aceita digital,
   reconhecimento facial ou o PIN/senha do dispositivo, dependendo do que
   estiver configurado no aparelho.

Toda falha vira uma `UnlockFailedException` carregando um `UnlockFailureReason`
tipado (sem hardware biométrico, muitas tentativas erradas, autenticação
cancelada, etc). O usecase não sabe nada sobre banco de dados nem sobre a
chave de criptografia, só responde "o dispositivo confirmou que é o dono?".

### Estado da tela como AsyncValue

O provider Riverpod `Unlock` (`unlock_provider.dart`, gerado com
`riverpod_generator`) expõe o estado da tela como um `AsyncValue<bool>`: o
`bool` embrulhado é `false` enquanto travado e `true` assim que destravado,
o que permite à UI distinguir "ainda não tentou" de "destravou com
sucesso" — do contrário os dois cairiam no mesmo `AsyncData`. Durante a
tentativa o estado vira `AsyncLoading`; em caso de falha vira `AsyncError`
carregando uma `UnlockFailedException`.

`UnlockFailedException`, em `domain/usecases`, guarda um `UnlockFailureReason`
tipado — enum em `domain/models` com os valores `noHardware`,
`tooManyAttempts`, `cancelled` e `unknown`. A UI lê esse `reason` para
decidir a mensagem de erro certa, em vez de depender de uma string solta
vinda da camada de domínio. O provider expõe também o método `unlock()`,
que a UI chama diretamente.

### Internacionalização

Inglês e português, via arquivos `.arb` em `lib/l10n` (`app_en.arb` e
`app_pt.arb`), com `flutter gen-l10n` gerando as classes de acesso. Cobre os
textos da tela de unlock: título, rótulo do botão, mensagem de
"autenticando", falha e "biometria indisponível". As classes geradas
(`app_localizations*.dart`) ficam versionadas no repositório junto com o
código gerado do Drift/Riverpod — nenhuma delas é gitignorada.

### Tema

`AppTheme`, em `core/theme`, gera temas claro e escuro a partir de uma única
seed color (`Colors.indigo`), usando a paleta tonal do Material 3
(`ColorScheme.fromSeed`). Não há cores nem estilos hardcoded fora daqui.

### Roteamento

`go_router`, com uma única rota hoje (`/unlock`, tela inicial). Novas
features adicionam suas rotas em `app_router.dart`.

### Logging

`AppLogger`, em `core/logging`, centraliza `info`, `warning` e `error` sobre
`dart:developer`, com níveis numéricos padrão (800/900/1000). Por
contrato, nenhum chamador deve passar senha, chave derivada ou token para
`message` ou `data`, apenas o que é seguro aparecer em log de depuração.

### Hooks de Git (local)

O projeto versiona seus próprios git hooks em `.githooks/`, fora do padrão
`.git/hooks` (que não é versionado). Cada dev que clona o repositório ativa
os hooks uma vez, rodando o instalador em Dart puro, sem depender de nenhum
pacote pub.dev:

```bash
dart run tool/install_hooks.dart
```

Isso configura `core.hooksPath` para apontar para `.githooks/` e marca os
dois scripts como executáveis. Os dois detectam automaticamente se o
projeto está usando FVM (checando se o comando `fvm` existe e se `.fvmrc`
está presente) e usam `fvm flutter`/`fvm dart` nesse caso, caindo para o
Flutter/Dart global caso contrário.

**`pre-commit`**, disparado a cada `git commit`: roda `dart format` só nos
arquivos `.dart` staged (ignorando os gerados — `*.g.dart` e
`lib/l10n/app_localizations*.dart`), re-adiciona o resultado ao commit, e
roda `flutter analyze` no projeto inteiro. Se o analyzer encontrar
qualquer problema, o commit é bloqueado. Se nenhum `.dart` estiver staged,
o hook não faz nada.

**`pre-push`**, disparado a cada `git push`: regenera `flutter gen-l10n` e
`dart run build_runner build --delete-conflicting-outputs` — os mesmos
dois passos de geração de código que o CI roda — e compara o resultado
contra o que já está commitado. Qualquer diferença indica que o código
gerado ficou desatualizado em relação ao que motivou a geração (schema do
Drift, providers do Riverpod ou arquivos `.arb`): o push é bloqueado, a
diferença é exibida, os comandos corretos são sugeridos, e o working
directory é restaurado ao estado do último commit (o `git checkout` age
só sobre esses arquivos gerados, nada mais é tocado). Passando por essa
checagem, roda `flutter test`; qualquer teste falhando também bloqueia o
push.

Nenhum dos dois hooks tem efeito fora da máquina local: não commitam, não
fazem push, não alteram histórico e não têm nenhuma interação com o
GitHub. Em caso de emergência, ambos podem ser pulados com
`git commit --no-verify` / `git push --no-verify`.

### CI (integração contínua)

`.github/workflows/ci.yml` roda a cada push em `dev`:

1. Instala dependências (`flutter pub get`).
2. Gera localizações (`flutter gen-l10n`).
3. Gera código de Drift e Riverpod (`dart run build_runner build`).
4. Checa formatação (`dart format --set-exit-if-changed`).
5. Roda o analyzer (`flutter analyze`).
6. Roda os testes (`flutter test`).

Se tudo passar, um segundo job abre automaticamente um Pull Request de `dev`
para `main` via GitHub CLI, mas só se ainda não existir um PR aberto entre
essas branches (evita duplicar).

### CD (build de release)

`.github/workflows/build-apk.yml` roda a cada push em `main` ou em uma tag
`v*`: decodifica o keystore a partir do secret em base64, monta
`key.properties` dinamicamente, gera um `.apk` assinado
(`--target-platform android-arm64`, com o número de build vindo de
`github.run_number`) e publica como artifact. Se o disparo foi por uma tag,
cria também uma Release no GitHub com notas geradas automaticamente.

Merge em `main` sozinho não publica Release — só gera o artifact do build.
Decidir se e quando vira Release é manual: você escolhe a versão e empurra
a tag (`git tag vX.Y.Z && git push origin vX.Y.Z`) quando quiser.

## O que está instalado mas ainda não implementado

Duas dependências já estão no `pubspec.yaml`, reservadas para quando o
projeto for além deste exemplo:

- `flutter_secure_storage`: hoje a biometria só confirma "é o dono do
  aparelho", ela ainda não libera nem guarda nenhuma chave de criptografia
  de verdade depois do desbloqueio. Essa lib é onde essa chave passaria a
  ser persistida com segurança, fora do banco SQLite.
- `flutter_validators`: só fará sentido quando existir uma tela de criação
  de vault (com senha mestra nova), que ainda não foi construída.

## Estrutura do projeto

```
lib/
├── core/                        # Infraestrutura compartilhada por qualquer feature
│   ├── database/                   # Acesso ao banco local (Drift, SQL-first)
│   ├── logging/                    # Registro de evento/erro, nunca loga dado sensível
│   ├── router/                     # Definição de rotas (go_router)
│   ├── theme/                      # Cores e tipografia (Material 3)
│   ├── utils/                      # Funções auxiliares puras
│   └── widgets/                    # Componentes visuais reutilizáveis entre features
│
├── features/
│   └── unlock/                     # Feature de exemplo, molde para as próximas
│       ├── domain/                    # Regra de negócio pura, sem Flutter nem banco
│       │   ├── models/                   # Tipos de domínio
│       │   ├── services/                 # Lógica auxiliar de domínio
│       │   └── usecases/                 # Uma ação = uma classe
│       ├── data/                      # Única camada que fala com core/database
│       └── presentation/              # UI e state management
│           ├── controllers/              # State management (Riverpod)
│           ├── screens/                  # Telas completas
│           └── widgets/                  # Widgets específicos da feature
│
└── l10n/                        # Traduções (.arb) e classes geradas

test/
├── core/                        # Espelha lib/core/, arquivo a arquivo
└── features/
    └── unlock/                     # Espelha lib/features/unlock/, arquivo a arquivo
```

Cada arquivo com lógica dentro de `lib/core` e `lib/features` tem seu par de
teste no mesmo caminho relativo dentro de `test/`. As únicas exceções são
arquivos sem lógica própria a testar: `main.dart` e `app_theme.dart` (só
monta `ThemeData`).

Os nomes concretos de cada classe do exemplo (`UnlockFailureReason`,
`KeyDerivation`, `VaultRepository`, etc.) estão descritos na seção
"O que já funciona" acima, não repetidos aqui: esta árvore mostra o
formato que qualquer feature nova segue, não o conteúdo específico da
que já existe.

Fora dessa árvore, na raiz do projeto (ao lado de `pubspec.yaml`), ficam
`.githooks/` (os scripts `pre-commit`/`pre-push`) e `tool/`
(`install_hooks.dart`, o instalador desses hooks) — ver seção "Hooks de
Git (local)" acima.

## Criando uma feature nova

A pasta `unlock/` é o molde. Para criar outra feature, replique a mesma
estrutura de três camadas (`domain/data/presentation`), mantendo:

- `domain` sem nenhum `import` de Flutter, Drift ou qualquer infraestrutura,
  só lógica de negócio pura, testável isoladamente.
- `data` como a única camada que fala com `core/database`.
- `presentation` como a única camada que conhece widgets e Riverpod.

## Rodando o projeto

Este projeto usa [FVM](https://fvm.app) para gerenciar a versão do Flutter.
O `.fvmrc` aponta hoje para o canal `stable`, não uma versão fixa.

```bash
fvm flutter pub get
fvm flutter gen-l10n
dart run build_runner build
fvm flutter run
```

## Rodando os testes

```bash
fvm flutter test
```

Se os hooks locais estiverem instalados, esse comando já roda
automaticamente a cada `git push` (ver seção "Hooks de Git (local)"
acima).

## Analisando o código

```bash
fvm flutter analyze
```

O lint é rigoroso (`very_good_analysis`), qualquer aviso deve ser corrigido
antes de commitar. Se os hooks locais estiverem instalados, esse comando já
roda automaticamente a cada `git commit` (ver seção "Hooks de Git (local)"
acima).

## Biometria no Android

Habilitar a biometria no Android exige três ajustes nativos além do código
Dart, todos já aplicados neste projeto:

- `MainActivity.kt` estende `FlutterFragmentActivity`, não `FlutterActivity`
  (`local_auth` depende de uma `FragmentActivity` para exibir o prompt do
  sistema).
- `AndroidManifest.xml` declara a permissão `android.permission.USE_BIOMETRIC`.
- `styles.xml` (tema claro, em `values/`) usa
  `Theme.AppCompat.DayNight.NoActionBar` como parent, em vez do tema padrão
  gerado pelo `flutter create`.

iOS e macOS exigem a chave `NSFaceIDUsageDescription` no `Info.plist`, ainda
pendente neste projeto (confirmado: não está em nenhum dos dois arquivos
hoje).

## CI/CD

- `ci.yml`: roda a cada push em `dev`, descrito em detalhe acima.
- `build-apk.yml`: roda a cada push em `main` (ou tag `v*`), descrito em
  detalhe acima.

O build de release exige quatro secrets configurados no repositório
(`Settings > Secrets and variables > Actions`):

| Secret | Descrição |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Keystore `.jks` convertido para base64 |
| `ANDROID_KEYSTORE_PASSWORD` | Senha do keystore |
| `ANDROID_KEY_ALIAS` | Alias da chave dentro do keystore |
| `ANDROID_KEY_PASSWORD` | Senha do alias |

O keystore de assinatura nunca é gerado nem usado localmente, todo `.apk` de
release nasce exclusivamente via CI. Tanto o `.gitignore` da raiz quanto o
de `android/` protegem `key.properties` e qualquer `*.jks`/`*.keystore` de
ir parar no repositório por engano.