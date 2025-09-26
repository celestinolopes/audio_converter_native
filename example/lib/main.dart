import 'dart:async';

import 'package:audio_converter_native/audio_converter_native.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Converter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AudioConverterExample(),
    );
  }
}

class AudioConverterExample extends StatefulWidget {
  const AudioConverterExample({super.key});

  @override
  State<AudioConverterExample> createState() => _AudioConverterExampleState();
}

class _AudioConverterExampleState extends State<AudioConverterExample> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  String? _recordingPath;
  String? _convertedPath;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isConverting = false;
  String _status = 'Pronto para gravar';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _status = 'Permissão concedida - Pronto para gravar';
      });
    } else {
      setState(() {
        _status = 'Permissão negada - Não é possível gravar';
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final cacheDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${cacheDir.path}/recording_$timestamp.aac';

        await _recorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _status = 'Gravando...';
        });
      } else {
        _showSnackBar('Permissão de microfone negada', isError: true);
      }
    } catch (e) {
      _showSnackBar('Erro ao iniciar gravação: $e', isError: true);
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();

      setState(() {
        _isRecording = false;
        _recordingPath = path;
        _status = 'Gravação concluída';
      });

      _showSnackBar('Gravação salva: ${path?.split('/').last}');
    } catch (e) {
      setState(() {
        _isRecording = false;
        _status = 'Erro na gravação';
      });
      _showSnackBar('Erro ao parar gravação: $e', isError: true);
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath == null) return;

    try {
      if (_isPlaying) {
        await _player.stop();
        setState(() {
          _isPlaying = false;
          _status = 'Reprodução pausada';
        });
      } else {
        await _player.play(DeviceFileSource(_recordingPath!));
        setState(() {
          _isPlaying = true;
          _status = 'Reproduzindo gravação original';
        });

        _player.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
            _status = 'Reprodução concluída';
          });
        });
      }
    } catch (e) {
      _showSnackBar('Erro na reprodução: $e', isError: true);
    }
  }

  Future<void> _playConverted() async {
    if (_convertedPath == null) return;

    try {
      if (_isPlaying) {
        await _player.stop();
        setState(() {
          _isPlaying = false;
          _status = 'Reprodução pausada';
        });
      } else {
        await _player.play(DeviceFileSource(_convertedPath!));
        setState(() {
          _isPlaying = true;
          _status = 'Reproduzindo arquivo convertido';
        });

        _player.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
            _status = 'Reprodução concluída';
          });
        });
      }
    } catch (e) {
      _showSnackBar('Erro na reprodução: $e', isError: true);
    }
  }

  Future<void> _convertToWAV() async {
    if (_recordingPath == null) {
      _showSnackBar('Nenhuma gravação disponível', isError: true);
      return;
    }

    setState(() {
      _isConverting = true;
      _status = 'Convertendo para WAV...';
    });

    try {
      final result = await AudioConverterService.instance.convertToWAV(
        inputPath: _recordingPath!,
        sampleRate: 44100,
        channels: 2,
      );

      setState(() {
        _isConverting = false;
        _convertedPath = result.outputPath;
        _status = result.success ? 'Conversão concluída' : 'Erro na conversão';
      });

      if (result.success) {
        _showSnackBar(
            'Arquivo convertido: ${result.outputPath?.split('/').last}');
      } else {
        _showSnackBar('Erro na conversão: ${result.error}', isError: true);
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _status = 'Erro na conversão';
      });
      _showSnackBar('Erro na conversão: $e', isError: true);
    }
  }

  Future<void> _convertToMP3() async {
    if (_recordingPath == null) {
      _showSnackBar('Nenhuma gravação disponível', isError: true);
      return;
    }

    setState(() {
      _isConverting = true;
      _status = 'Convertendo para MP3...';
    });

    try {
      final result = await AudioConverterService.instance.convertToMP3(
        inputPath: _recordingPath!,
        bitrate: 128,
        sampleRate: 44100,
      );

      setState(() {
        _isConverting = false;
        _convertedPath = result.outputPath;
        _status = result.success ? 'Conversão concluída' : 'Erro na conversão';
      });

      if (result.success) {
        _showSnackBar(
            'Arquivo convertido: ${result.outputPath?.split('/').last}');
      } else {
        _showSnackBar('Erro na conversão: ${result.error}', isError: true);
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _status = 'Erro na conversão';
      });
      _showSnackBar('Erro na conversão: $e', isError: true);
    }
  }

  Future<void> _shareFile() async {
    String? fileToShare;
    String fileType;

    if (_convertedPath != null) {
      fileToShare = _convertedPath;
      fileType = 'convertido';
    } else if (_recordingPath != null) {
      fileToShare = _recordingPath;
      fileType = 'original';
    } else {
      _showSnackBar('Nenhum arquivo para compartilhar', isError: true);
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(fileToShare!)],
        text: 'Arquivo de áudio $fileType compartilhado',
      );
      _showSnackBar('Compartilhando arquivo $fileType...');
    } catch (e) {
      _showSnackBar('Erro ao compartilhar: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Converter Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.info, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botões de gravação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    label: Text(_isRecording ? 'Parar' : 'Gravar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.red : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _recordingPath != null ? _playRecording : null,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Pausar' : 'Reproduzir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botões de conversão
            const Text(
              'Conversão:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isConverting || _recordingPath == null
                        ? null
                        : _convertToWAV,
                    icon: _isConverting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.transform),
                    label: const Text('Para WAV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isConverting || _recordingPath == null
                        ? null
                        : _convertToMP3,
                    icon: _isConverting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.audiotrack),
                    label: const Text('Para MP3'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botões de reprodução e compartilhamento
            if (_convertedPath != null) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _playConverted,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reproduzir Convertido'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareFile,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Informações dos arquivos
            if (_recordingPath != null || _convertedPath != null) ...[
              const Text(
                'Arquivos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_recordingPath != null)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.audiotrack, color: Colors.blue),
                    title: const Text('Gravação Original'),
                    subtitle: Text(_recordingPath!.split('/').last),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
              if (_convertedPath != null)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.transform, color: Colors.orange),
                    title: const Text('Arquivo Convertido'),
                    subtitle: Text(_convertedPath!.split('/').last),
                    trailing:
                        const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
