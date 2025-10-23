import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:ui';

class VideoBackground extends StatefulWidget {
  final Widget child;
  final VideoPlayerController controller;

  const VideoBackground({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground>
    with SingleTickerProviderStateMixin {
  late ChewieController _chewieController;
  bool _isInitialized = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (!widget.controller.value.isInitialized) {
        await widget.controller.initialize();
      }

      widget.controller.setLooping(true);
      widget.controller.play();

      _chewieController = ChewieController(
        videoPlayerController: widget.controller,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
      );

      if (mounted) {
        setState(() => _isInitialized = true);
        _fadeController.forward(); 
      }
    } catch (e) {
      debugPrint("Gagal load video background: $e");
      setState(() => _isInitialized = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    if (_isInitialized) _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isInitialized)
          FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: widget.controller.value.size.width,
                  height: widget.controller.value.size.height,
                  child: Chewie(controller: _chewieController),
                ),
              ),
            ),
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF977DFF), Color(0xFF0033FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.5,
              ),
            ),
          ),

       
        if (_isInitialized)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

        widget.child,
      ],
    );
  }
}
