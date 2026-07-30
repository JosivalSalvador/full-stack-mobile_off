// Roda uma vez apos clonar o repo: dart run tool/install_hooks.dart
import 'dart:io';

void main() {
  final config = Process.runSync(
    'git',
    ['config', 'core.hooksPath', '.githooks'],
  );
  if (config.exitCode != 0) {
    stderr.writeln('Erro ao configurar core.hooksPath: ${config.stderr}');
    exit(1);
  }

  if (!Platform.isWindows) {
    Process.runSync(
      'chmod',
      ['+x', '.githooks/pre-commit', '.githooks/pre-push'],
    );
  }

  stdout.writeln('Hooks instalados: pre-commit e pre-push ativos.');
}
