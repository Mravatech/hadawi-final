import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/widgets/occasions_card.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/widgets/default_button_with_image.dart';


class OthersOccasions extends StatelessWidget {
  const OthersOccasions({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.gray,
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "قائمة المناسبات المسجلة للأخرين",
              style: TextStyles.textStyle18Bold
                  .copyWith(color: ColorManager.primaryBlue),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(
                  image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(SizeConfig.height * 0.02),
          child: Column(
            children: [
              DefaultButtonWithImage(
                buttonText: "مشاركة القائمة",
                image: AssetsManager.shareIcon,
                onTap: () {},
              ),

              SizedBox(
                height: SizeConfig.height * 0.02,
              ),

              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.9,

                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return OccasionCard(
                      onTap: () {},
                      forOthers: true,
                      occasionName: "عيد ميلاد",
                      personName: "محمد ممدوح",
                      imageUrl:
                          "https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=",
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
