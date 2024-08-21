import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imagegenrator/utilities/dimens.dart';

class imageview extends StatefulWidget {
  final image;

  const imageview({super.key, this.image});

  @override
  State<imageview> createState() => _imageviewState();
}

class _imageviewState extends State<imageview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            width: double.infinity,
            imageUrl: widget.image,
            placeholder: (context, url) => const Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
