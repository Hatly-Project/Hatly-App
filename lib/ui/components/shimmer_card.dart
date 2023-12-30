import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * .95,
          // height: MediaQuery.of(context).size.height * .29,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade400,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade400,
                              child: Container(
                                width: 150,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade400,
                                child: Container(
                                  width: 150,
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade400,
                          child: Container(
                            width: 90,
                            height: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 2,
                  color: Colors.grey[400],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade400,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                )),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade400,
                              child: Container(
                                width: 100,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .02,
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade400,
                              child: Container(
                                width: 60,
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade400,
                      child: Container(
                        width: 60,
                        height: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .045,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
