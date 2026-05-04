import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerBubble extends StatefulWidget {
  final String audioPath;
  final bool isSentByMe;
  final ColorScheme colorScheme;

  const AudioPlayerBubble({
    super.key,
    required this.audioPath,
    required this.isSentByMe,
    required this.colorScheme,
  });

  @override
  State<AudioPlayerBubble> createState() => _AudioPlayerBubbleState();
}

class _AudioPlayerBubbleState extends State<AudioPlayerBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.setSourceDeviceFile(widget.audioPath);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isSentByMe
        ? widget.colorScheme.onPrimary
        : widget.colorScheme.onSurface;

    final iconColor = widget.isSentByMe
        ? widget.colorScheme.onPrimary
        : widget.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: iconColor,
            size: 32,
          ),
          onPressed: () async {
            if (_isPlaying) {
              await _audioPlayer.pause();
            } else {
              File file = File(widget.audioPath);
              if (await file.exists()) {
                await _audioPlayer.play(DeviceFileSource(widget.audioPath));
              }
            }
          },
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor:
                  widget.isSentByMe ? Colors.white : widget.colorScheme.primary,
              inactiveTrackColor: widget.isSentByMe
                  ? Colors.white38
                  : widget.colorScheme.primaryContainer,
              thumbColor: iconColor,
            ),
            child: Slider(
              min: 0,
              max: _duration.inSeconds.toDouble() > 0
                  ? _duration.inSeconds.toDouble()
                  : 1,
              value: _position.inSeconds.toDouble().clamp(
                    0.0,
                    _duration.inSeconds.toDouble() > 0
                        ? _duration.inSeconds.toDouble()
                        : 1,
                  ),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
              },
            ),
          ),
        ),
        Text(
          _formatDuration(_duration),
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
