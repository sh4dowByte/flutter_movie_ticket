import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_booking_app/widget/widget.dart';

import '../core/exceptions/empty_data_exception.dart';

class AppError<T> extends StatelessWidget {
  final T error;
  final StackTrace? stackTrace;
  final Function()? onReload;
  const AppError(this.error, {super.key, this.stackTrace, this.onReload});

  @override
  Widget build(BuildContext context) {
    if (error is EmptyDataException) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
              width: 200,
              imageUrl:
                  "https://img.icons8.com/?size=480&id=lj7F2FvSJWce&format=png"),
          const SizedBox(height: 20),
          Center(child: Text('$error')),
          if (onReload != null) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: AppButton(
                text: 'Reload',
                onTap: onReload,
              ),
            ),
          ],
        ],
      );
    }

    return Center(child: Text('$error'));
  }
}
