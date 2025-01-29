import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultShimmer extends StatelessWidget {
  const SearchResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
