import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:review_app/features/reviews/presentation/widgets/user_profile_model.dart';
import 'package:review_app/main.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../utils/fonts.dart';
import '../../../authentication/data/repositories/users_repo.dart';
import '../../data/repositories/review_repo.dart';
import '../../domain/entities/upload_review.dart';
import '../../domain/entities/user.dart';
import '../widgets/image_shimmer.dart';
import '../widgets/review_model.dart';
import '../widgets/shadow.dart';
import '../widgets/tabs_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ScrollController _scrollController = ScrollController();
  bool lastStatus = true;
  double height = 200;

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor60,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: SafeArea(
              child: Container(
                alignment: Alignment.centerLeft,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Profile', style: MainFonts.pageTitleText()),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.transparentComponentColor,
                          borderRadius: BorderRadius.circular(3.0)),
                      padding: EdgeInsets.only(
                          top: 4, bottom: 4, left: 4.5, right: 4.5),
                      child: Text('#${1}',
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor30)),
                    )
                  ],
                ),
              ),
            )),
        body: DefaultTabController(
          length: 2,
          child: RefreshIndicator(
            onRefresh: () async {
              // _refresh();
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UserProfileModel(profileUrl: 'null', name: 'Jayesh18', username: 'username', rank: 1, points: 1, bio: 'I am flutter and android developer', gender: 'male',),
                    ]),
                  )
                ];
              },
              body: Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 52,
                          child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 2,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white,
                              tabs: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Tab(
                                      text: "    Post    ",
                                    ),
                                    SizedBox(height: 2)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Tab(
                                      text: "Comments",
                                    ),
                                    SizedBox(height: 2)
                                  ],
                                ),
                              ]),
                        ),
                        Container(
                          color: Colors.grey,
                          height: 0.3,
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [TweetsTab(), RepliesTab(), LikesTab()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
