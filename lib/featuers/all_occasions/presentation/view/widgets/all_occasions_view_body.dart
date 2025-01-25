import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/my_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/others_occasions.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';

class AllOccasionsViewBody extends StatelessWidget {
  const AllOccasionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height*0.07,),

          // المناسبات المسحله جديثا
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MyOccasions()));
            },
              child: RowDataWidget(image: '', title: 'المناسباتى المسحله جديثا')
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // المناسبات المسحله لاخر
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>OthersOccasions()));
            },
            child: RowDataWidget(image: '', title: 'المناسبات المسحله لاخر'),
          ),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // المناسبات المسحله سابقا
          RowDataWidget(image: '', title: 'المناسبات المسحله سابقا'),

          SizedBox(height: MediaQuery.sizeOf(context).height*0.045,),

          // المناسبات المغلقه
          RowDataWidget(image: '', title: 'المناسبات المغلقه'),
        ],
      ),
    );
  }
}
