import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/data/models/complete_occasion_model.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/open_image.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';

class OccasionCard extends StatefulWidget {
  final CompleteOccasionModel occasionEntity;
  final bool isOrders;

  const OccasionCard({
    super.key,
    required this.occasionEntity,
    this.isOrders = true
  });

  @override
  State<OccasionCard> createState() => _OccasionCardState();
}

class _OccasionCardState extends State<OccasionCard>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  int get _imageCount =>
      widget.occasionEntity.imagesUrl2?.isNotEmpty == true ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<VisitorsCubit, VisitorsState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: widget.isOrders
                      ? screenSize.height * 0.42
                      : screenSize.height * 0.37,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.gray.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: ColorManager.gray.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Image Section
                      Expanded(
                        flex: 7,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Main Images
                              PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemCount: _imageCount,
                                itemBuilder: (context, index) {
                                  final imageUrl = index == 0
                                      ? widget.occasionEntity.imagesUrl
                                      : widget.occasionEntity.imagesUrl2;

                                  return GestureDetector(
                                    onTap: () {
                                      customPushNavigator(
                                          context,
                                          ImageViewerScreen(imageUrl: imageUrl ?? '')
                                      );
                                    },
                                    child: Hero(
                                      tag: 'occasion_${widget.occasionEntity.occasionId}_$index',
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: ColorManager.gray.withOpacity(0.1),
                                          child: const Center(
                                            child: CupertinoActivityIndicator(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            color: ColorManager.gray.withOpacity(0.1),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported_outlined,
                                                  color: ColorManager.gray,
                                                  size: 40,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Image not available',
                                                  style: TextStyle(
                                                    color: ColorManager.gray,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Price Badge
                              Positioned(
                                top: 16,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorManager.red,
                                        ColorManager.red.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorManager.red.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_offer_outlined,
                                        color: ColorManager.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.occasionEntity.finalPrice.toInt()}',
                                        style: TextStyles.textStyle18Bold.copyWith(
                                          color: ColorManager.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Image Indicators (if multiple images)
                              if (_imageCount > 1)
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(_imageCount, (index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _currentImageIndex == index
                                                ? ColorManager.white
                                                : ColorManager.white.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Content Section
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.occasionEntity.title?.toString() ?? 'No Title',
                                style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.primaryBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          widget.occasionEntity.des.toString() ?? 'No Description',
                          style: TextStyles.textStyle18Regular.copyWith(
                            color: ColorManager.black,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 15),

                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}