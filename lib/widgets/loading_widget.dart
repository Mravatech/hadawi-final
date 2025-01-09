import 'package:flutter/cupertino.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class LoadingAnimationWidget extends StatefulWidget {
  final double? size;
  final Color? color;
  final double? paddingTop;

  const LoadingAnimationWidget({Key? key,this.size, this.color,this.paddingTop,}) : super(key: key);


  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget> {

  normalLoading({double? size,double? paddingTop,Color? color,}){

    return Container(
      margin: EdgeInsets.only(top: paddingTop ?? 0),
      width: size ?? MediaQuery.sizeOf(context).height * 0.075,
      height: size ?? MediaQuery.sizeOf(context).height * 0.075,
      child:CupertinoActivityIndicator(
        radius: size ?? MediaQuery.sizeOf(context).height * 0.02,
        color:color?? ColorManager.lightGrey,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return normalLoading(size:widget.size,paddingTop: widget.paddingTop );
  }
}