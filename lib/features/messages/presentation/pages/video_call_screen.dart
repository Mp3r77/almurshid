import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoCallScreen extends StatefulWidget {
  final String participantName;
  final String profileImageUrl;

  const VideoCallScreen({
    super.key,
    required this.participantName,
    required this.profileImageUrl,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background / Video Stream Placeholder
            _isVideoOff
                ? Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.profileImageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),

            // Top Info
            Positioned(
              top: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    widget.participantName,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جاري الاتصال...',
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // My Self-View Camera Placeholder
            if (!_isVideoOff)
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white54, size: 40),
                  ),
                ),
              ),

            // Bottom Controls
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    color: _isMuted ? Colors.white : Colors.white24,
                    iconColor: _isMuted ? Colors.black : Colors.white,
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),
                  _CallButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    iconColor: Colors.white,
                    size: 70,
                    iconSize: 35,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _CallButton(
                    icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                    color: _isVideoOff ? Colors.white : Colors.white24,
                    iconColor: _isVideoOff ? Colors.black : Colors.white,
                    onTap: () {
                      setState(() {
                        _isVideoOff = !_isVideoOff;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.size = 55,
    this.iconSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: iconSize),
        ),
      ),
    );
  }
}
