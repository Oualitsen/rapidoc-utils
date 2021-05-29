import 'dart:math' as Math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rxdart/rxdart.dart';

class ImageViewRouteArgs {
  final List<String> images;
  final String? startBy;

  bool get valid => images.isNotEmpty;

  int get startIndex {
    if (startBy == null) {
      return 0;
    }

    int result = images.indexOf(startBy!);
    return result == -1 ? 0 : result;
  }

  ImageViewRouteArgs({required this.images, this.startBy});
}

class ImageViewRoute extends StatefulWidget {
  final ImageViewRouteArgs args;
  ImageViewRoute({Key? key, required this.args}) : super(key: key);

  @override
  _ImageViewRouteState createState() => _ImageViewRouteState();
}

class _ImageViewRouteState extends State<ImageViewRoute> with TickerProviderStateMixin {
  late TabController tabController;
  final BehaviorSubject<int> subject = BehaviorSubject();
  final BehaviorSubject<double> angleSubject = BehaviorSubject();
  final angles = <double>[];
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: widget.args.images.length, vsync: this, initialIndex: widget.args.startIndex);

    tabController.addListener(() {
      subject.add(tabController.index);
      angleSubject.add(angles[tabController.index]);
    });

    (widget.args.images).forEach((element) => angles.add(0));
    angleSubject.listen((value) {
      angles[tabController.index] = value;
    });
    subject.add(widget.args.startIndex);
    angleSubject.add(0);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    subject.close();
    angleSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.args.valid) {
      Navigator.of(context).pop();
    }

    return DefaultTabController(
      length: widget.args.images.length,
      initialIndex: widget.args.startIndex,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color.fromARGB(0xFF, 0xCC, 0xCC, 0xCC)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () {
                angleSubject.add(angles[tabController.index] - Math.pi / 2);
              },
            ),
            IconButton(
              icon: Icon(Icons.rotate_right),
              onPressed: () {
                angleSubject.add(angles[tabController.index] + Math.pi / 2);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: tabController,
              children: List<String>.generate(
                  widget.args.images.length, (index) => widget.args.images[index]).map((url) {
                return StreamBuilder<double>(
                    stream: angleSubject,
                    initialData: angleSubject.valueOrNull,
                    builder: (context, snapshot) {
                      return Transform.rotate(
                        angle: snapshot.data!,
                        child: PhotoView(
                          imageProvider: NetworkImage(url),
                        ),
                      );
                    });
              }).toList(),
            ),
            Positioned(
              right: 20,
              top: 20,
              bottom: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (tabController.index < tabController.length - 1) {
                        tabController.animateTo(tabController.index + 1);
                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              bottom: 20,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (tabController.index > 0) {
                        tabController.animateTo(tabController.index - 1);
                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              child: StreamBuilder<int>(
                  stream: subject,
                  initialData: subject.valueOrNull,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.args.images.map((url) {
                        return InkWell(
                          onTap: () {
                            tabController.animateTo(widget.args.images.indexOf(url));
                          },
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: widget.args.images.indexOf(url) == snapshot.data
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        );
                      }).toList(),
                    );
                  }),
              left: 10,
              right: 10,
              bottom: 10,
            )
          ],
        ),
      ),
    );
  }
}
