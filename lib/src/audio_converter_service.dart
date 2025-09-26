import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'models/audio_format.dart';
import 'models/conversion_result.dart';

/// Serviço principal para conversão de áudio nativa
class AudioConverterService {
  static const MethodChannel _channel = MethodChannel('audio_converter_native');

  static AudioConverterService? _instance;

  /// Singleton instance
  static AudioConverterService get instance {
    _instance ??= AudioConverterService._internal();
    return _instance!;
  }

  AudioConverterService._internal();

  /// Executa um comando de conversão personalizado
  Future<ConversionResult> executeCommand({
    required String command,
    required String inputPath,
    required String outputPath,
  }) async {
    try {
      final Map<Object?, Object?> result =
          await _channel.invokeMethod('executeCommand', {
        'command': command,
        'inputPath': inputPath,
        'outputPath': outputPath,
      });

      // Converte o resultado para Map<String, dynamic>
      final Map<String, dynamic> resultMap = Map<String, dynamic>.from(result);

      return ConversionResult(
        success: resultMap['success'] ?? false,
        message: resultMap['output'] ?? '',
        duration: resultMap['duration'] ?? 0,
        returnCode: resultMap['returnCode'] ?? -1,
        error: resultMap['error'],
        outputPath: resultMap['success'] == true ? outputPath : null,
      );
    } on PlatformException catch (e) {
      return ConversionResult.error(
        message: 'Erro na execução do comando',
        error: e.message ?? 'Erro desconhecido',
        returnCode: e.code.hashCode,
      );
    } catch (e) {
      return ConversionResult.error(
        message: 'Erro geral na conversão',
        error: e.toString(),
      );
    }
  }

  /// Converte áudio para WAV
  Future<ConversionResult> convertToWAV({
    required String inputPath,
    String? outputPath,
    int sampleRate = 44100,
    int channels = 2,
  }) async {
    final output =
        outputPath ?? await _generateOutputPath(inputPath, AudioFormat.wav);

    final command =
        '-i "$inputPath" -ar $sampleRate -ac $channels -y "$output"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: output,
    );
  }

  /// Converte áudio para AAC
  Future<ConversionResult> convertToAAC({
    required String inputPath,
    String? outputPath,
    int bitrate = 128,
    int sampleRate = 44100,
  }) async {
    final output =
        outputPath ?? await _generateOutputPath(inputPath, AudioFormat.aac);

    final command =
        '-i "$inputPath" -c:a aac -b:a ${bitrate}k -ar $sampleRate -y "$output"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: output,
    );
  }

  /// Converte áudio para MP3
  Future<ConversionResult> convertToMP3({
    required String inputPath,
    String? outputPath,
    int bitrate = 128,
    int sampleRate = 44100,
  }) async {
    final output =
        outputPath ?? await _generateOutputPath(inputPath, AudioFormat.mp3);

    final command =
        '-i "$inputPath" -c:a libmp3lame -b:a ${bitrate}k -ar $sampleRate -y "$output"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: output,
    );
  }

  /// Converte áudio para M4A
  Future<ConversionResult> convertToM4A({
    required String inputPath,
    String? outputPath,
    int bitrate = 128,
    int sampleRate = 44100,
  }) async {
    final output =
        outputPath ?? await _generateOutputPath(inputPath, AudioFormat.m4a);

    final command =
        '-i "$inputPath" -c:a aac -b:a ${bitrate}k -ar $sampleRate -y "$output"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: output,
    );
  }

  /// Converte áudio para OGG
  Future<ConversionResult> convertToOGG({
    required String inputPath,
    String? outputPath,
    int bitrate = 128,
    int sampleRate = 44100,
  }) async {
    final output =
        outputPath ?? await _generateOutputPath(inputPath, AudioFormat.ogg);

    final command =
        '-i "$inputPath" -c:a libvorbis -b:a ${bitrate}k -ar $sampleRate -y "$output"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: output,
    );
  }

  /// Extrai áudio de um vídeo
  Future<ConversionResult> extractAudioFromVideo({
    required String videoPath,
    required String outputPath,
    AudioFormat format = AudioFormat.aac,
    int bitrate = 128,
  }) async {
    final command =
        '-i "$videoPath" -vn -c:a ${format.codec} -b:a ${bitrate}k -y "$outputPath"';

    return await executeCommand(
      command: command,
      inputPath: videoPath,
      outputPath: outputPath,
    );
  }

  /// Corta um áudio
  Future<ConversionResult> trimAudio({
    required String inputPath,
    required String outputPath,
    required Duration startTime,
    required Duration duration,
  }) async {
    final startSeconds = startTime.inSeconds;
    final durationSeconds = duration.inSeconds;

    final command =
        '-i "$inputPath" -ss $startSeconds -t $durationSeconds -c copy -y "$outputPath"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: outputPath,
    );
  }

  /// Aplica fade in/out
  Future<ConversionResult> applyFade({
    required String inputPath,
    required String outputPath,
    Duration? fadeIn,
    Duration? fadeOut,
  }) async {
    String command = '-i "$inputPath"';

    if (fadeIn != null) {
      command += ' -af "afade=t=in:d=${fadeIn.inMilliseconds / 1000.0}"';
    }

    if (fadeOut != null) {
      command += ' -af "afade=t=out:d=${fadeOut.inMilliseconds / 1000.0}"';
    }

    command += ' -y "$outputPath"';

    return await executeCommand(
      command: command,
      inputPath: inputPath,
      outputPath: outputPath,
    );
  }

  /// Obtém informações sobre um arquivo de mídia
  Future<Map<String, dynamic>> getMediaInfo(String filePath) async {
    try {
      final Map<Object?, Object?> result =
          await _channel.invokeMethod('getMediaInfo', {
        'filePath': filePath,
      });

      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      return {
        'success': false,
        'error': e.message ?? 'Erro ao obter informações',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Verifica se o conversor está disponível
  Future<bool> isAvailable() async {
    try {
      final bool result = await _channel.invokeMethod('isAvailable');
      return result;
    } catch (e) {
      return false;
    }
  }

  /// Obtém a versão do conversor
  Future<String> getVersion() async {
    try {
      final String result = await _channel.invokeMethod('getVersion');
      return result;
    } catch (e) {
      return 'Desconhecida';
    }
  }

  /// Gera um caminho de saída único no cache
  Future<String> _generateOutputPath(
      String inputPath, AudioFormat format) async {
    final cacheDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final inputName = inputPath.split('/').last.split('.').first;
    return '${cacheDir.path}/${inputName}_converted_$timestamp.${format.extension}';
  }
}
