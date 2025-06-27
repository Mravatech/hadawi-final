import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/closed_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/my_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/others_occasions.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/past_occasions.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/view/my_occasions_list.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/profile_row_widget.dart';
import 'package:hadawi_app/featuers/profile/presentation/view/widgets/row_data_widget.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';

class AllOccasionsViewBody extends StatefulWidget {
  const AllOccasionsViewBody({super.key});

  @override
  State<AllOccasionsViewBody> createState() => _AllOccasionsViewBodyState();
}

class _AllOccasionsViewBodyState extends State<AllOccasionsViewBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                    AppLocalizations.of(context)!.translate('newEvents').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('lastEvents').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('closedOccasions').toString(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('deleteEvents').toString(),
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
              MyOccasions(),
              OthersOccasions(),
              PastOccasions(),
              ClosedOccasions(),
            ],
          ),
        ),
      ],
    );
  }
}
