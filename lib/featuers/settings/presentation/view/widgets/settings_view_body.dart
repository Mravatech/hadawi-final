import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';

class SettingViewBody extends StatelessWidget {
  const SettingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),

          // اللغه
          RowDataWidget(image: '', title: 'اللغه'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // حذف الحساب
          RowDataWidget(image: '', title: 'حذف الحساب'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // الاشعارات
          RowDataWidget(image: '', title: 'الاشعارات'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // الرمز الترويجي
          RowDataWidget(image:'', title: 'الرمز الترويجي'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

          // تواصل معنا
          RowDataWidget(image:'', title: 'تواصل معنا'),
        ],
      ),
    );
  }
}
