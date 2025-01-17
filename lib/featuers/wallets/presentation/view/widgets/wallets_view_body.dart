import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';

class WalletsViewBody extends StatelessWidget {
  const WalletsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          Image(
            height:  MediaQuery.sizeOf(context).height*0.05,
            width:  MediaQuery.sizeOf(context).height*0.05,
            image: AssetImage(AssetsManager.logoWithoutBackground),
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // المبالغ بالمحفظة
          RowDataWidget(image: '', title: 'المبالغ بالمحفظة'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // المبالغ المسحوبه
          RowDataWidget(image: '', title: 'المبالغ المسحوبه'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // البيانات البنكيه
          RowDataWidget(image: '', title: 'البيانات البنكيه'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

        ],
      ),
    );
  }
}
