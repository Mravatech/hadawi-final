import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/search_result_shimmer.dart';
import 'package:hadawi_app/styles/text_styles/text_styles.dart';

class SearchResultContainer extends StatelessWidget {
  const SearchResultContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<VisitorsCubit, VisitorsState, List<OccasionEntity>>(
      selector: (state) => context.read<VisitorsCubit>().searchOccasionsList,
      builder: (context, searchOccasionsList) {
        if (searchOccasionsList.isEmpty) {
          return const Center(child: Text("No results found"));
        }
        return Container(
          // padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: searchOccasionsList.length,
              itemBuilder: (context, index) {
                final occasion = searchOccasionsList[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OccasionDetails(
                          occasionId: occasion.occasionId,
                          fromHome: true,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: occasion.giftImage[0],
                            height: MediaQuery.sizeOf(context).width * 0.15,
                            width: MediaQuery.sizeOf(context).width * 0.22,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const SearchResultShimmer(),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/money_bag.png',
                              height: MediaQuery.sizeOf(context).width * 0.05,
                              width: MediaQuery.sizeOf(context).width * 0.22,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                          SizedBox(width: MediaQuery.sizeOf(context).width * 0.03),
                        Expanded(
                          child: Text(
                            occasion.occasionName,
                            style: TextStyles.textStyle18Medium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
