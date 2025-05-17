import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/firends_states.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/friends_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/default_app_bar_widget.dart';
import 'package:hadawi_app/widgets/default_button.dart';
import 'package:hadawi_app/widgets/toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FollowingRequestScreen extends StatefulWidget {
  const FollowingRequestScreen({super.key});

  @override
  State<FollowingRequestScreen> createState() => _FollowingRequestScreenState();
}

class _FollowingRequestScreenState extends State<FollowingRequestScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      if(mounted){
        context.read<FriendsCubit>().getFollowing(userId: UserDataFromStorage.uIdFromStorage);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: defaultAppBarWidget(appBarTitle:AppLocalizations.of(context)!.translate('followRequests').toString()),
      body: BlocConsumer<FriendsCubit, FriendsStates>(
        listener: (context, state) {
          if(state is AcceptFollowRequestErrorState){
            customToast(title: state.message, color: ColorManager.error);
          }
          if(state is RejectFollowRequestErrorState){
            customToast(title: state.message, color: ColorManager.error);
          }
        },
        builder: (context, state) {
          var cubit = context.read<FriendsCubit>();
          return ModalProgressHUD(
            inAsyncCall: state is AcceptFollowRequestLoadingState || state is RejectFollowRequestLoadingState,
            child: state is GetFollowingLoadingState? const Center(child: CircularProgressIndicator()):
            cubit.followersRequest.isNotEmpty? ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: cubit.followersRequest.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 0,);
              },
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).height*0.02,
                    vertical: MediaQuery.sizeOf(context).height*0.01
                ),
                height:  MediaQuery.sizeOf(context).height*0.13,
                decoration: BoxDecoration(
                  color: ColorManager.gray,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: CircleAvatar(
                          radius: 23,
                          child: Image(
                            image: const AssetImage(AssetsManager.userIcon),
                          ),),
                      ),

                      SizedBox(width: MediaQuery.sizeOf(context).height*0.02,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cubit.followersRequest[index].userName,style:TextStyles.textStyle18Medium.copyWith(
                                color: ColorManager.black
                            )),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: DefaultButton(
                                    buttonText: AppLocalizations.of(context)!.translate('follow').toString(),
                                    onPressed: () async {
                                      cubit.acceptFollowRequest(
                                          userId: UserDataFromStorage.uIdFromStorage,
                                          followerId: cubit.followersRequest[index].userId,
                                        userName: cubit.followersRequest[index].userName,
                                      );
                                    },
                                    buttonColor: ColorManager.primaryBlue,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.sizeOf(context).height*0.02,),
                                Expanded(
                                  child: DefaultButton(
                                    buttonText: AppLocalizations.of(context)!.translate('decline').toString(),
                                    onPressed: () async {
                                      cubit.rejectFollowRequest(
                                          userId: UserDataFromStorage.uIdFromStorage,
                                          followerId: cubit.followersRequest[index].userId
                                      );
                                    },
                                    buttonColor: ColorManager.error,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.sizeOf(context).height*0.02,),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text(AppLocalizations.of(context)!.translate('noFollowRequests').toString(),style: TextStyles.textStyle18Medium.copyWith(color: ColorManager.black),)),
              ],
            ),
          );
        },

      )
    );
  }
}
