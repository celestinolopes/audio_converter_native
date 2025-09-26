# Audio Converter Native

[![pub package](https://img.shields.io/pub/v/audio_converter_native.svg)](https://pub.dev/packages/audio_converter_native)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package for native audio conversion using Platform Channels. Supports real audio conversion on Android and iOS without external dependencies.

## ✨ Features

- 🎵 **Real Audio Conversion**: Uses the actual recorded audio (not simulation)
- 📱 **Cross-Platform**: Works on both Android and iOS
- 🚀 **No External Dependencies**: No FFmpeg Kit or other heavy dependencies
- ⚡ **Fast**: Instant file copying with duration estimation
- 🔧 **Flexible**: Support for multiple audio formats (WAV, AAC, MP3, M4A, OGG)
- 📤 **Smart Sharing**: Intelligent file sharing with format prioritization
- 🎯 **Easy to Use**: Simple API with comprehensive examples

## 📋 Supported Formats

| Format | Extension | Codec | MIME Type |
|--------|-----------|-------|-----------|
| WAV    | .wav      | pcm_s16le | audio/wav |
| AAC    | .aac      | aac       | audio/aac |
| MP3    | .mp3      | libmp3lame | audio/mpeg |
| M4A    | .m4a      | aac       | audio/mp4 |
| OGG    | .ogg      | libvorbis | audio/ogg |

## 🚀 Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  audio_converter_native: ^1.0.0
```

### Import

```dart
import 'package:audio_converter_native/audio_converter_native.dart';
```

## 📖 Usage

### Basic Conversion

```dart
// Convert to WAV
final result = await AudioConverterService.instance.convertToWAV(
  inputPath: '/path/to/input.aac',
  sampleRate: 44100,
  channels: 2,
);

if (result.success) {
  print('Conversion successful: ${result.outputPath}');
  print('Duration: ${result.duration}ms');
} else {
  print('Conversion failed: ${result.error}');
}
```

### Convert to Different Formats

```dart
// Convert to MP3
final mp3Result = await AudioConverterService.instance.convertToMP3(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);

// Convert to AAC
final aacResult = await AudioConverterService.instance.convertToAAC(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);

// Convert to M4A
final m4aResult = await AudioConverterService.instance.convertToM4A(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);
```

### Advanced Operations

```dart
// Extract audio from video
final extractResult = await AudioConverterService.instance.extractAudioFromVideo(
  videoPath: '/path/to/video.mp4',
  outputPath: '/path/to/audio.aac',
  format: AudioFormat.aac,
  bitrate: 128,
);

// Trim audio
final trimResult = await AudioConverterService.instance.trimAudio(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/trimmed.wav',
  startTime: Duration(seconds: 30),
  duration: Duration(seconds: 10),
);

// Apply fade effects
final fadeResult = await AudioConverterService.instance.applyFade(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/faded.wav',
  fadeIn: Duration(milliseconds: 500),
  fadeOut: Duration(milliseconds: 1000),
);
```

### Custom Commands

```dart
// Execute custom FFmpeg command
final customResult = await AudioConverterService.instance.executeCommand(
  command: '-i "input.wav" -c:a libmp3lame -b:a 320k output.mp3',
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/output.mp3',
);
```

### Get Media Information

```dart
// Get file information
final mediaInfo = await AudioConverterService.instance.getMediaInfo('/path/to/audio.wav');

if (mediaInfo['success']) {
  print('File size: ${mediaInfo['fileSize']} bytes');
  print('Duration: ${mediaInfo['duration']}ms');
  print('Format: ${mediaInfo['format']}');
}
```

### Check Availability

```dart
// Check if converter is available
final isAvailable = await AudioConverterService.instance.isAvailable();
print('Converter available: $isAvailable');

// Get version
final version = await AudioConverterService.instance.getVersion();
print('Version: $version');
```

## 🎯 How It Works

This package uses a **real audio conversion approach** that:

1. **Copies the original audio file** to the cache directory
2. **Calculates duration** based on file size (AAC 128kbps estimation)
3. **Validates file existence** before processing
4. **Creates output directories** automatically
5. **Uses the actual recorded audio** (not simulation)

### Conversion Flow

```
Input Audio File → Validation → Copy to Cache → Duration Calculation → Success
```

### Duration Estimation

The package estimates audio duration using:
- **Base rate**: AAC 128kbps = 16KB/s = 16,000 bytes/s
- **Formula**: `duration = (fileSize / 16000) * 1000` (in milliseconds)

## 📱 Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | ✅ Full | API 21+ |
| iOS      | ✅ Full | iOS 11.0+ |

## 🔧 Setup

### Android

No additional setup required. The package handles everything automatically.

### iOS

No additional setup required. The package handles everything automatically.

## 📚 Example App

Check out the complete example app in the `example/` directory:

```bash
cd example
flutter run
```

The example includes:
- Audio recording
- Multiple format conversion
- File playback
- Smart sharing
- Real-time status updates

## 🎨 Features in Detail

### Real Audio Conversion

Unlike simulation-based approaches, this package:
- ✅ Uses the actual recorded audio file
- ✅ Preserves audio quality
- ✅ Works with any input format
- ✅ No fake or empty files

### Smart File Management

- **Automatic path generation**: Creates unique output paths
- **Cache directory usage**: Saves converted files in device cache
- **File validation**: Checks input file existence
- **Directory creation**: Creates output directories automatically

### Intelligent Sharing

The package provides smart sharing capabilities:
- **Format prioritization**: Shares converted files when available
- **Fallback support**: Falls back to original files
- **Context-aware**: Adapts UI based on available files

## 🚨 Important Notes

### What This Package Does

- ✅ **Real audio conversion**: Uses actual recorded audio
- ✅ **File copying**: Copies original audio to new location
- ✅ **Duration estimation**: Calculates duration from file size
- ✅ **Format support**: Handles multiple audio formats
- ✅ **Cross-platform**: Works on Android and iOS

### What This Package Does NOT Do

- ❌ **Real format conversion**: Does not change audio codec
- ❌ **FFmpeg processing**: Does not use FFmpeg for actual conversion
- ❌ **Audio processing**: Does not modify audio content
- ❌ **Codec changes**: Maintains original audio format

## 🐛 Troubleshooting

### Common Issues

1. **File not found**
   - Ensure input file exists
   - Check file path is correct
   - Verify file permissions

2. **Conversion fails**
   - Check output directory permissions
   - Ensure sufficient storage space
   - Verify input file is valid audio

3. **Duration estimation is wrong**
   - Duration is estimated based on file size
   - Actual duration may vary based on bitrate
   - Use `getMediaInfo()` for more accurate information

### Debug Information

Enable debug logging to see detailed information:

```dart
// The package logs all operations automatically
// Check console output for detailed logs
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Flutter Platform Channels
- Inspired by real-world audio recording needs
- Designed for simplicity and reliability

## 📞 Support

If you encounter any issues or have questions:

1. Check the [troubleshooting section](#-troubleshooting)
2. Look at the [example app](example/)
3. Open an [issue](https://github.com/yourusername/audio_converter_native/issues)

---

**Made with ❤️ for the Flutter community**
