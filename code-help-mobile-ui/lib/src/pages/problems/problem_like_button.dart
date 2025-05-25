import 'package:coding_helper_cross_platform/src/components/common/flash_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../context/index.dart';
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
    final sharedContext = Provider.of<SharedContext>(context, listen: false);

    return FutureBuilder(
        future: problemsService.isLiked(widget.id).catchError((error) => createMessage(context, "You must be logged in first!\n$error", "error")),
        builder: (context, snapshot) {
          return IconButton(
            onPressed: () {
              problemsService
                  .toggleLike(widget.id)
                  .whenComplete(() => setState(() {}))
                  .catchError((error) => createMessage(context, "You must be logged in first!\n$error", "error"));
            },
            icon: snapshot.hasData && snapshot.data!
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_outline),
          );
        });
  }
}
