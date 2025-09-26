/// Formatos de áudio suportados
enum AudioFormat {
  /// Formato WAV
  wav,

  /// Formato AAC
  aac,

  /// Formato MP3
  mp3,

  /// Formato M4A
  m4a,

  /// Formato OGG
  ogg,
}

/// Extensão para AudioFormat
extension AudioFormatExtension on AudioFormat {
  /// Retorna a extensão do arquivo
  String get extension {
    switch (this) {
      case AudioFormat.wav:
        return 'wav';
      case AudioFormat.aac:
        return 'aac';
      case AudioFormat.mp3:
        return 'mp3';
      case AudioFormat.m4a:
        return 'm4a';
      case AudioFormat.ogg:
        return 'ogg';
    }
  }

  /// Retorna o nome do codec
  String get codec {
    switch (this) {
      case AudioFormat.wav:
        return 'pcm_s16le';
      case AudioFormat.aac:
        return 'aac';
      case AudioFormat.mp3:
        return 'libmp3lame';
      case AudioFormat.m4a:
        return 'aac';
      case AudioFormat.ogg:
        return 'libvorbis';
    }
  }

  /// Retorna o MIME type
  String get mimeType {
    switch (this) {
      case AudioFormat.wav:
        return 'audio/wav';
      case AudioFormat.aac:
        return 'audio/aac';
      case AudioFormat.mp3:
        return 'audio/mpeg';
      case AudioFormat.m4a:
        return 'audio/mp4';
      case AudioFormat.ogg:
        return 'audio/ogg';
    }
  }
}
