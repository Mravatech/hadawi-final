import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_states.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/size_config/app_size_config.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_card.dart';
import 'package:intl/intl.dart';

class MyMoneyWidget extends StatefulWidget {
  const MyMoneyWidget({super.key});

  @override
  State<MyMoneyWidget> createState() => _MyMoneyWidgetState();
}

class _MyMoneyWidgetState extends State<MyMoneyWidget> {
  @override
  void initState() {
    super.initState();
    context.read<VisitorsCubit>().getMyPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.translate("myContributions").toString(),
            style: TextStyles.textStyle18Bold
                .copyWith(color: ColorManager.primaryBlue),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.replace(AppRouter.home);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child:
              Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.height * 0.02),
        child: BlocConsumer<VisitorsCubit, VisitorsState>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = context.read<VisitorsCubit>();
                return cubit.myPaymentsList.isEmpty?
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsManager.noData),
                      Text(
                        AppLocalizations.of(context)!
                            .translate('noOccasions')
                            .toString(),
                        style: TextStyles.textStyle18Bold
                            .copyWith(
                            color: ColorManager.primaryBlue),
                      ),
                    ],
                  ),
                ) :
                ListView.separated(
                  separatorBuilder: (_,__)=> SizedBox(height: SizeConfig.height*0.02,),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 5,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding:const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryBlue,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.gray.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.myPaymentsList[index].occasionName,style:  TextStyles.textStyle18Bold.copyWith(
                                color: ColorManager.white
                          ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02,
                          ),
                          Row(
                            children: [
                              Text(
                                cubit.myPaymentsList[index].paymentAmount.toString(),
                                style:  TextStyles.textStyle18Bold.copyWith(
                                    color: ColorManager.white
                              ),
                              ),
                              Spacer(),
                              Text(
                                DateFormat('yyyy-MM-dd').format(DateTime.parse(cubit.myPaymentsList[index].paymentDate)),style:  TextStyles.textStyle18Bold.copyWith(
                                    color: ColorManager.gray
                              ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: cubit.myPaymentsList.length,
                );
              },
            ),

      ),
    );
  }
}
