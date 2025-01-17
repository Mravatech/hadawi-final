import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';

class FriendsViewBody extends StatelessWidget {
  const FriendsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [

          SizedBox(height: MediaQuery.sizeOf(context).height*0.07,),

          // اصدقاء اتابعهم
          RowDataWidget(image: '', title: 'اصدقاء اتابعهم'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // الاصدقاء يتابعوني
          RowDataWidget(image: '', title: 'اصدقاء يتابعوني'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // طلبات الصداقه
          RowDataWidget(image: '', title: 'طلبات المتابعه'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // الاصدقاء المشاركين بهديتي
          RowDataWidget(image: '', title: 'الاصدقاء المشاركين بهديتي'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // دعوه اصدقاء
          RowDataWidget(image: '', title: 'دعوه اصدقاء'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

        ],
      ),
    );
  }
}
