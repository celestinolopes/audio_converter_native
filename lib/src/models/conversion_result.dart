/// Resultado de uma operação de conversão de áudio
class ConversionResult {
  /// Indica se a conversão foi bem-sucedida
  final bool success;

  /// Mensagem de saída ou erro
  final String message;

  /// Duração do áudio em milissegundos
  final int duration;

  /// Código de retorno da operação
  final int returnCode;

  /// Mensagem de erro (se houver)
  final String? error;

  /// Caminho do arquivo de saída (se bem-sucedido)
  final String? outputPath;

  const ConversionResult({
    required this.success,
    required this.message,
    required this.duration,
    required this.returnCode,
    this.error,
    this.outputPath,
  });

  /// Cria um resultado de sucesso
  factory ConversionResult.success({
    required String message,
    required int duration,
    required String outputPath,
  }) {
    return ConversionResult(
      success: true,
      message: message,
      duration: duration,
      returnCode: 0,
      outputPath: outputPath,
    );
  }

  /// Cria um resultado de erro
  factory ConversionResult.error({
    required String message,
    required String error,
    int returnCode = -1,
  }) {
    return ConversionResult(
      success: false,
      message: message,
      duration: 0,
      returnCode: returnCode,
      error: error,
    );
  }

  @override
  String toString() {
    return 'ConversionResult(success: $success, message: $message, duration: ${duration}ms, returnCode: $returnCode, error: $error, outputPath: $outputPath)';
  }
}
