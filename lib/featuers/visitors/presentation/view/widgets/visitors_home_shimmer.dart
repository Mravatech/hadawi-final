import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VisitorsHomeShimmer extends StatelessWidget {
  const VisitorsHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: mediaQuery.height * 0.05,
              width: mediaQuery.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.02,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                   child: Container(
                    height: mediaQuery.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
              itemCount: 6,
            ),
          )
        ],
      ),
    );
  }
}
