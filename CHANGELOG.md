# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2024-01-XX

### Fixed
- Fixed homepage and repository URLs in pubspec.yaml
- Updated package metadata for proper pub.dev display
- Removed discontinued package warnings

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Audio Converter Native
- Support for Android and iOS platforms
- Real audio conversion using Platform Channels
- Support for multiple audio formats (WAV, AAC, MP3, M4A, OGG)
- Audio recording and playback integration
- Smart file sharing with format prioritization
- Duration estimation based on file size
- Comprehensive example app
- Full documentation and README

### Features
- `convertToWAV()` - Convert audio to WAV format
- `convertToAAC()` - Convert audio to AAC format
- `convertToMP3()` - Convert audio to MP3 format
- `convertToM4A()` - Convert audio to M4A format
- `convertToOGG()` - Convert audio to OGG format
- `extractAudioFromVideo()` - Extract audio from video files
- `trimAudio()` - Trim audio files
- `applyFade()` - Apply fade in/out effects
- `executeCommand()` - Execute custom FFmpeg commands
- `getMediaInfo()` - Get media file information
- `isAvailable()` - Check converter availability
- `getVersion()` - Get converter version

### Technical Details
- Uses Flutter Platform Channels for native communication
- No external dependencies (no FFmpeg Kit)
- Real audio file copying (not simulation)
- Automatic directory creation
- File validation and error handling
- Cross-platform compatibility
- Memory efficient operations
