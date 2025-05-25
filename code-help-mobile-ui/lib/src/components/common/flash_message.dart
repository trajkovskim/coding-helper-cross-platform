import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:flutter/material.dart';

class FlashMessage extends StatelessWidget {
  final String message;
  final String type;

  final Map<String, Color> types = const {
    "error": Colors.red,
    "info": Colors.blue,
  };

  final Map<String, String> titleByType = const {
    "error": "error",
    "info": "info",
  };

  const FlashMessage({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(16),
      height: 105,
      decoration: BoxDecoration(
        color: types[type],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t(titleByType[type]!), style: Theme.of(context).textTheme.titleLarge),
                Text(message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

createMessage(BuildContext context, String message, String type) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
    FlashMessage(message: message, type: type),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 5),
      dismissDirection: DismissDirection.startToEnd,
      elevation: 0)
  );
}