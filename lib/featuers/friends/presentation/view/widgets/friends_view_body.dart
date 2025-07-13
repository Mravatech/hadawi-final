import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/friends/presentation/controller/friends_cubit.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/followers_screen.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/following_request_screen.dart';
import 'package:hadawi_app/featuers/friends/presentation/view/following_screen.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';

class FriendsViewBody extends StatefulWidget {
  const FriendsViewBody({super.key});

  @override
  State<FriendsViewBody> createState() => _FriendsViewBodyState();
}

class _FriendsViewBodyState extends State<FriendsViewBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Color(0xFF8B7BA8),
            unselectedLabelColor: Colors.grey[400],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: Color(0xFF8B7BA8),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(horizontal: 16),
            isScrollable: true,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('following').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('followers').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('requests').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              BlocProvider(
                create: (context) => FriendsCubit(getIt(), getIt(), getIt(), getIt()),
                child: FollowingScreen(),
              ),
              BlocProvider(
                create: (context) => FriendsCubit(getIt(), getIt(), getIt(), getIt()),
                child: FollowersScreen(),
              ),
              BlocProvider(
                create: (context) => FriendsCubit(getIt(), getIt(), getIt(), getIt()),
                child: FollowingRequestScreen(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
