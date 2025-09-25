import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/firends_states.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/friends_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:hadawi_app/widgets/toast.dart';

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

          if (state is GetFollowingLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B7BA8)),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading requests...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B7BA8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (cubit.followersRequest.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color(0xFF8B7BA8).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        AssetsManager.noData,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.translate('noFollowRequests').toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B7BA8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'When someone wants to follow you, their request will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            physics: AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: cubit.followersRequest.length,
            itemBuilder: (context, index) {
              final request = cubit.followersRequest[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Handle user tap - show profile or actions
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            request.userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Wants to follow you',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    await cubit.acceptFollowRequest(
                                      userId: UserDataFromStorage.uIdFromStorage,
                                      followerId: request.userId,
                                      userName: request.userName,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF8B7BA8),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('follow').toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: TextButton(
                                  onPressed: () async {
                                    await cubit.rejectFollowRequest(
                                      userId: UserDataFromStorage.uIdFromStorage,
                                      followerId: request.userId,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('decline').toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }
}
