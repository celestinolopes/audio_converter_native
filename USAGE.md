# Como Usar o Audio Converter Native

## 🚀 Instalação

### 1. Adicionar ao pubspec.yaml

```yaml
dependencies:
  audio_converter_native: ^1.0.0
```

### 2. Executar flutter pub get

```bash
flutter pub get
```

## 📱 Configuração por Plataforma

### Android

Adicione as permissões no `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS

Adicione a permissão no `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to microphone to record audio.</string>
```

## 💻 Uso Básico

### 1. Importar o package

```dart
import 'package:audio_converter_native/audio_converter_native.dart';
```

### 2. Converter áudio para WAV

```dart
final result = await AudioConverterService.instance.convertToWAV(
  inputPath: '/path/to/input.aac',
  sampleRate: 44100,
  channels: 2,
);

if (result.success) {
  print('Conversão bem-sucedida: ${result.outputPath}');
  print('Duração: ${result.duration}ms');
} else {
  print('Erro na conversão: ${result.error}');
}
```

### 3. Converter para outros formatos

```dart
// Para MP3
final mp3Result = await AudioConverterService.instance.convertToMP3(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);

// Para AAC
final aacResult = await AudioConverterService.instance.convertToAAC(
  inputPath: '/path/to/input.wav',
  bitrate: 128,
  sampleRate: 44100,
);
```

## 🎯 Exemplo Completo

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
  String _status = 'Pronto';

  Future<void> _convertAudio() async {
    if (_inputPath == null) return;

    setState(() {
      _isConverting = true;
      _status = 'Convertendo...';
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
        _status = result.success ? 'Conversão concluída' : 'Erro na conversão';
      });

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo convertido: ${result.outputPath}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${result.error}')),
        );
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _status = 'Erro na conversão';
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
                : Text('Converter para WAV'),
            ),
            if (_outputPath != null) ...[
              SizedBox(height: 20),
              Text('Arquivo convertido: ${_outputPath!.split('/').last}'),
            ],
          ],
        ),
      ),
    );
  }
}
```

## 🔧 Operações Avançadas

### Extrair áudio de vídeo

```dart
final result = await AudioConverterService.instance.extractAudioFromVideo(
  videoPath: '/path/to/video.mp4',
  outputPath: '/path/to/audio.aac',
  format: AudioFormat.aac,
  bitrate: 128,
);
```

### Cortar áudio

```dart
final result = await AudioConverterService.instance.trimAudio(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/trimmed.wav',
  startTime: Duration(seconds: 30),
  duration: Duration(seconds: 10),
);
```

### Aplicar fade

```dart
final result = await AudioConverterService.instance.applyFade(
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/faded.wav',
  fadeIn: Duration(milliseconds: 500),
  fadeOut: Duration(milliseconds: 1000),
);
```

### Comando personalizado

```dart
final result = await AudioConverterService.instance.executeCommand(
  command: '-i "input.wav" -c:a libmp3lame -b:a 320k output.mp3',
  inputPath: '/path/to/input.wav',
  outputPath: '/path/to/output.mp3',
);
```

## 📊 Obter informações do arquivo

```dart
final mediaInfo = await AudioConverterService.instance.getMediaInfo('/path/to/audio.wav');

if (mediaInfo['success']) {
  print('Tamanho: ${mediaInfo['fileSize']} bytes');
  print('Duração: ${mediaInfo['duration']}ms');
  print('Formato: ${mediaInfo['format']}');
}
```

## ✅ Verificar disponibilidade

```dart
final isAvailable = await AudioConverterService.instance.isAvailable();
print('Conversor disponível: $isAvailable');

final version = await AudioConverterService.instance.getVersion();
print('Versão: $version');
```

## 🎨 Integração com Gravação

```dart
import 'package:record/record.dart';

class AudioRecorderWithConverter {
  final AudioRecorder _recorder = AudioRecorder();
  
  Future<String?> recordAndConvert() async {
    // Gravar áudio
    final cacheDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final recordingPath = '${cacheDir.path}/recording_$timestamp.aac';
    
    await _recorder.start(RecordConfig(), path: recordingPath);
    // ... aguardar gravação ...
    await _recorder.stop();
    
    // Converter para WAV
    final result = await AudioConverterService.instance.convertToWAV(
      inputPath: recordingPath,
    );
    
    return result.success ? result.outputPath : null;
  }
}
```

## 🚨 Notas Importantes

1. **Conversão Real**: O package usa o áudio realmente gravado, não simulação
2. **Sem Dependências Externas**: Não precisa do FFmpeg Kit
3. **Cache Directory**: Arquivos convertidos são salvos no cache do dispositivo
4. **Duração Estimada**: Baseada no tamanho do arquivo (AAC 128kbps)
5. **Cross-Platform**: Funciona em Android e iOS

## 🐛 Solução de Problemas

### Arquivo não encontrado
- Verifique se o arquivo de entrada existe
- Confirme se o caminho está correto
- Verifique permissões de acesso

### Erro de conversão
- Verifique se o diretório de saída pode ser criado
- Confirme se há espaço suficiente no cache
- Verifique permissões de escrita

### Problemas de build
```bash
flutter clean
flutter pub get
cd ios && pod install  # Para iOS
```

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a documentação completa no README.md
2. Execute o app de exemplo
3. Abra uma issue no repositório
