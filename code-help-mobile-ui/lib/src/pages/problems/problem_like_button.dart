import 'package:flutter/material.dart';

import '../../services/codehelp/index.dart';

class ProblemLikeButton extends StatefulWidget {
  final String id;

  const ProblemLikeButton({required this.id, super.key});

  @override
  State<ProblemLikeButton> createState() => _ProblemLikeButtonState();
}

class _ProblemLikeButtonState extends State<ProblemLikeButton> {
  final problemsService = const ProblemsService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: problemsService.isLiked(widget.id),
        builder: (context, snapshot) {
          return IconButton(
            onPressed: () {
              problemsService
                  .toggleLike(widget.id)
                  .whenComplete(() => setState(() {}));
            },
            icon: snapshot.hasData && snapshot.data!
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_outline),
          );
        });
  }
}
