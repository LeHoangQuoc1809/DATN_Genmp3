import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../configs/device_size_config.dart';

class LoadingSearchTagDisplay extends StatefulWidget {
  const LoadingSearchTagDisplay({super.key});

  @override
  State<LoadingSearchTagDisplay> createState() =>
      _LoadingSearchTagDisplayState();
}

class _LoadingSearchTagDisplayState extends State<LoadingSearchTagDisplay> {
  List<int> _numbers = List.generate(10, (index) => index);

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(10.r);
    return Container(
      height: 500,
      padding: EdgeInsets.fromLTRB(
        15.w,
        0.h,
        15.w,
        0.h,
      ),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              bottom: 15.h,
            ),
            height: 80.h,
            child: Stack(
              children: [
                Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(168, 162, 162, 0.4),
                  highlightColor: const Color.fromRGBO(168, 162, 162, 0.3),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(radius),
                    ),
                    padding: EdgeInsets.all(10.sp),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: const Color.fromRGBO(168, 162, 162, 0.4),
                  highlightColor: const Color.fromRGBO(168, 162, 162, 0.3),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(
                      15.w,
                      5.h,
                      5.w,
                      5.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.r)),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 26.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.r)),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Add spacing between containers
                              Container(
                                height: 16.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
