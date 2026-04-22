import 'package:flutter/material.dart';

class ChatbotButton extends StatelessWidget {
  final VoidCallback onTap;

  const ChatbotButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: const Color(0xFF2DBE7F),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: const Icon(
            Icons.chat,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}