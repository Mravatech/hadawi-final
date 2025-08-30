import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/generated/assets.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class OccasionCard extends StatelessWidget {
  final String occasionName;
  final String personName;
  final String imageUrl;
  final bool forOthers;
  final Function () onTap;

  const OccasionCard({
    super.key,
    required this.occasionName,
    required this.personName,
    required this.imageUrl,
    required this.forOthers,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.018),
        ),
        child: SizedBox(
          height: SizeConfig.height * 0.2,
          width: SizeConfig.height * 0.2,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(SizeConfig.height * 0.01)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: SizeConfig.height * 0.13,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(Assets.imagesLightLogo,
                  fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.height * 0.018),
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      occasionName,
                      style: TextStyles.textStyle18Bold.copyWith(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    Visibility(
                      visible: forOthers,
                      child: Text(
                        personName,
                        style: TextStyles.textStyle12Bold.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
