# How to Use Audio Converter Native

## 🚀 Installation

### 1. Add to pubspec.yaml

```yaml
dependencies:
  audio_converter_native: ^1.0.0
```

### 2. Run flutter pub get

```bash
flutter pub get
```

## 📱 Platform Configuration

### Android

Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS

Add permission to `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone to record audio.</string>
```

## 💻 Basic Usage

### 1. Import the package

```dart
import 'package:audio_converter_native/audio_converter_native.dart';
```

### 2. Convert audio to WAV

```dart
final result = await AudioConverterService.instance.convertToWAV(
  inputPath: '/path/to/input.aac',
  sampleRate: 44100,
  channels: 2,
);

if (result.success) {
  print('Conversion successful: ${result.outputPath}');
  print('Duration: ${result.duration}ms');
} else {
  print('Conversion error: ${result.error}');
}
```

### 3. Convert to other formats

```dart
// To MP3
final mp3Result = await AudioConverterService.instance.convertToMP3(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);

// To AAC
final aacResult = await AudioConverterService.instance.convertToAAC(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);
```

## 🎯 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:audio_converter_native/audio_converter_native.dart';

class AudioConverterExample extends StatefulWidget {
  @override
  _AudioConverterExampleState createState() => _AudioConverterExampleState();
}

class _AudioConverterExampleState extends State<AudioConverterExample> {
  String? _inputPath;
  String? _outputPath;
  bool _isConverting = false;
  String _status = 'Ready';

  Future<void> _convertAudio() async {
    if (_inputPath == null) return;

    setState(() {
      _isConverting = true;
      _status = 'Converting...';
    });

    try {
      final result = await AudioConverterService.instance.convertToWAV(
        inputPath: _inputPath!,
        sampleRate: 44100,
        channels: 2,
      );

      setState(() {
        _isConverting = false;
        _outputPath = result.outputPath;
        _status = result.success ? 'Conversion completed' : 'Conversion error';
      });

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File converted: ${result.outputPath}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.error}')),
        );
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _status = 'Conversion error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Converter')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Status: $_status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConverting ? null : _convertAudio,
              child: _isConverting 
                ? CircularProgressIndicator()
                : Text('Convert to WAV'),
            ),
            if (_outputPath != null) ...[
              SizedBox(height: 20),
              Text('Converted file: ${_outputPath!.split('/').last}'),
            ],
          ],
        ),
      ),
    );
  }
}
```

## 🔧 Advanced Operations

### Extract audio from video

```dart
final result = await AudioConverterService.instance.extractAudioFromVideo(
  videoPath: '/path/to/video.mp4',
  outputPath: '/path/to/audio.aac',
  format: AudioFormat.aac,
  bitrate: 128,
);
```

### Trim audio

```dart
final result = await AudioConverterService.instance.trimAudio(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/trimmed.wav',
  startTime: Duration(seconds: 30),
  duration: Duration(seconds: 10),
);
```

### Apply fade

```dart
final result = await AudioConverterService.instance.applyFade(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/faded.wav',
  fadeIn: Duration(milliseconds: 500),
  fadeOut: Duration(milliseconds: 1000),
);
```

### Custom command

```dart
final result = await AudioConverterService.instance.executeCommand(
  command: '-i "input.wav" -c:a libmp3lame -b:a 320k output.mp3',
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/output.mp3',
);
```

## 📊 Get file information

```dart
final mediaInfo = await AudioConverterService.instance.getMediaInfo('/path/to/audio.wav');

if (mediaInfo['success']) {
  print('Size: ${mediaInfo['fileSize']} bytes');
  print('Duration: ${mediaInfo['duration']}ms');
  print('Format: ${mediaInfo['format']}');
}
```

## ✅ Check availability

```dart
final isAvailable = await AudioConverterService.instance.isAvailable();
print('Converter available: $isAvailable');

final version = await AudioConverterService.instance.getVersion();
print('Version: $version');
```

## 🎨 Recording Integration

```dart
import 'package:record/record.dart';

class AudioRecorderWithConverter {
  final AudioRecorder _recorder = AudioRecorder();
  
  Future<String?> recordAndConvert() async {
    // Record audio
    final cacheDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final recordingPath = '${cacheDir.path}/recording_$timestamp.aac';
    
    await _recorder.start(RecordConfig(), path: recordingPath);
    // ... wait for recording ...
    await _recorder.stop();
    
    // Convert to WAV
    final result = await AudioConverterService.instance.convertToWAV(
      inputPath: recordingPath,
    );
    
    return result.success ? result.outputPath : null;
  }
}
```

## 🚨 Important Notes

1. **Real Conversion**: The package uses actually recorded audio, not simulation
2. **No External Dependencies**: No need for FFmpeg Kit
3. **Cache Directory**: Converted files are saved in device cache
4. **Estimated Duration**: Based on file size (AAC 128kbps)
5. **Cross-Platform**: Works on Android and iOS

## 🐛 Troubleshooting

### File not found
- Check if the input file exists
- Confirm the path is correct
- Check access permissions

### Conversion error
- Check if the output directory can be created
- Confirm there's enough space in cache
- Check write permissions

### Build issues
```bash
flutter clean
flutter pub get
cd ios && pod install  # For iOS
```

## 📞 Support

For questions or issues:
1. Check the complete documentation in README.md
2. Run the example app
3. Open an issue in the repository
