import 'package:coding_helper_cross_platform/src/services/forum/CommunityService.dart';
import 'package:coding_helper_cross_platform/src/i18n/i18n.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumCommunitySearch.dart';
import 'package:coding_helper_cross_platform/src/pages/forum/ForumOverviewPage.dart';
import 'package:coding_helper_forum_api/coding_helper_forum_api.dart';
import 'package:flutter/material.dart';

class ForumCommunityPage extends StatelessWidget {
  const ForumCommunityPage({Key? key, required this.communityName})
      : super(key: key);

  final String communityName;

  @override
  Widget build(BuildContext context) {
    final t = getTranslation(context, 'message.forum');
    final ft = getTranslation(context, 'forum');
    final communityService = CommunityService.getInstance();

    return Scaffold(
      appBar: AppBar(
        title: Text(ft("title")),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15).copyWith(bottom: 0),
          child: LayoutBuilder(
              builder: (context, constraints) => FutureBuilder<Community?>(
                future: communityService
                    .getCommunityByName(communityName),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    throw t("posts-not-loaded");
                  }
                  
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return PaddedWidgetList(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Container(
                            height: constraints.maxHeight * 0.4,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.15),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0))
                              ],
                            ),
                            child: LayoutBuilder(
                              builder: (context, innerConstraints) =>
                                  Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: innerConstraints
                                                .maxHeight *
                                            0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withOpacity(0.25),
                                          borderRadius:
                                              const BorderRadius
                                                      .vertical(
                                                  top:
                                                      Radius.circular(
                                                          10)),
                                        ),
                                      ),
                                      Container(
                                        height: innerConstraints
                                                .maxHeight *
                                            0.5,
                                        decoration:
                                            const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.vertical(
                                                  bottom:
                                                      Radius.circular(
                                                          10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets
                                                  .symmetric(
                                              vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            right:
                                                                15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed:
                                                              () {},
                                                          child:
                                                              const Text(
                                                            "Join",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal:
                                                                35)
                                                        .copyWith(
                                                            bottom:
                                                                5),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .name,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal:
                                                            35),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .description,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets
                                                            .symmetric(
                                                        horizontal:
                                                            35),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                        "Tags: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Wrap(
                                                      alignment:
                                                          WrapAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .end,
                                                      children: snapshot
                                                              .data
                                                              ?.categories
                                                              .map((tag) =>
                                                                  TagChip(category: tag))
                                                              .toList() ??
                                                          [],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: (innerConstraints.maxHeight *
                                            0.5) -
                                        45,
                                    left: 30,
                                    height: 90,
                                    width: 90,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        ...((snapshot.data?.posts
                                .map((e) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 20),
                                    child: ForumPostCard(post: e)))
                                .toList()) ??
                            []),
                      ]);
                },
              ))),
    );
    ;
  }
}
