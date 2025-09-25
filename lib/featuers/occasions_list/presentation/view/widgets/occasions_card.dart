import 'package:flutter/material.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/utiles/helper/occasion_type_mapper.dart';

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
      child: Container(
        height: SizeConfig.height * 0.2,
        width: SizeConfig.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(SizeConfig.height * 0.018),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top section with white background
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.height * 0.018),
                    topRight: Radius.circular(SizeConfig.height * 0.018),
                  ),
                ),
                child: Center(
                  child: _buildGiftBoxIcon(),
                ),
              ),
            ),
            // Bottom section with light gray background
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.height * 0.018),
                    bottomRight: Radius.circular(SizeConfig.height * 0.018),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // English occasion name
                      Text(
                        OccasionTypeMapper.getEnglishName(occasionName),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1),
                      // Arabic occasion name
                      Text(
                        OccasionTypeMapper.getArabicName(occasionName),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Shari",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftBoxIcon() {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          // Gift box base (dark gray)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Purple ribbon/bow
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFF8B7BA8).withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Vertical ribbon
          Positioned(
            top: 8,
            left: 18,
            child: Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFF8B7BA8).withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
