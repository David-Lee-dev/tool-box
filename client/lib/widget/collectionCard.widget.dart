import 'dart:async';

import 'package:client/model/metaData.model.dart';
import 'package:client/util/TopRightClipper.util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CollcetionCard extends StatefulWidget {
  final Metadata data;

  const CollcetionCard({
    super.key,
    required this.data,
  });

  @override
  State<CollcetionCard> createState() => _CollcetionCardState();
}

class _CollcetionCardState extends State<CollcetionCard> {
  bool showImage = false;
  bool imageLoadedOnce = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      if (mounted) {
        setState(() {
          showImage = true;
        });
      }
    });
    super.initState();
  }

  bool _isCollected() {
    return widget.data.cards != null && widget.data.cards!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TopRightClipper(clipSize: 37),
          child: _isCollected()
              ? _buildCardContent()
              : ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]),
                  child: _buildCardContent(),
                ),
        ),
        if (_isCollected())
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ' No. ${widget.data.cards![0].seq}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: widget.data.cards!.length > 1
                      ? Colors.amber.shade300
                      : const Color.fromRGBO(255, 213, 79, 0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: widget.data.cards!.length > 1
                      ? Colors.black54
                      : const Color.fromRGBO(0, 0, 1, 0),
                  size: 20,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Container _buildCardContent() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.0, -1.0),
          end: Alignment(1.0, 2.0),
          colors: [Color(0xff5c5ae4), Color(0xffDE4981)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 28),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: const Color(0xff364458),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FutureBuilder<void>(
                future: _loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      imageLoadedOnce) {
                    return Image.network(
                      widget.data.imageUrl,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Shimmer.fromColors(
                      baseColor: const Color(0xff051732),
                      highlightColor: const Color(0xFF3F3F3F),
                      period: const Duration(milliseconds: 500),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Text(''),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadImage() async {
    if (!imageLoadedOnce) {
      final image = NetworkImage(widget.data.imageUrl);
      final completer = Completer<void>();
      image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (info, _) {
                if (mounted) {
                  setState(() {
                    imageLoadedOnce = true;
                  });
                }
                completer.complete();
              },
              onError: (error, stackTrace) {
                completer.completeError(error, stackTrace);
              },
            ),
          );
      return completer.future;
    }
    return Future.value();
  }
}
