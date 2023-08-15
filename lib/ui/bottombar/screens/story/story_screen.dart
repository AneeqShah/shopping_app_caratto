import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class StoryScreen extends StatefulWidget {
  var stories;

   StoryScreen({
    super.key,
     this.stories,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  PageController? _pageController;
  AnimationController? _animController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    _loadStory(animateToPage: false);


    _animController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController!.stop();
        _animController!.reset();
        // setState(() {
        //   if (_currentIndex + 1 < widget.stories!.length) {
        //     _currentIndex += 1;
        //     _loadStory(story: widget.stories![_currentIndex]);
        //   } else {
        //     // Out of bounds - loop story // You can also
        //     Navigator.of(context).pop();
        //     _currentIndex = 0;
        //     _loadStory(story: widget.stories![_currentIndex]);
        //   }
        // });
      }
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _animController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        // onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 1,
              itemBuilder: (context, i) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.stories["imageUrl"],
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: screenHeight / 8,
                        left: screenWidth / 10,
                        right: screenWidth / 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                        widget.stories["title"],
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.stories["description"],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        204, 255, 255, 255)),
                                child: const Text(
                                  'Look',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );


                return const SizedBox.shrink();
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      AnimatedBar(
                        animController: _animController!,
                        position: 1,
                        currentIndex: _currentIndex,
                      ),
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: const CachedNetworkImageProvider(
                            "https://images.freeimages.com/365/images/istock/previews/9730/97305669-avatar-icon-of-girl-in-a-baseball-cap.jpg",
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Expanded(
                          child: Text(
                            "Carato",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _onTapDown(TapDownDetails details) {
  //   final double screenWidth = MediaQuery.of(context).size.width;
  //   final double dx = details.globalPosition.dx;
  //   if (dx < screenWidth / 3) {
  //     setState(() {
  //       if (_currentIndex - 1 >= 0) {
  //         _currentIndex -= 1;
  //         _loadStory(story: widget.stories![_currentIndex]);
  //       }
  //     });
  //   } else if (dx > 2 * screenWidth / 3) {
  //     setState(() {
  //       if (_currentIndex + 1 < widget.stories!.length) {
  //         _currentIndex += 1;
  //         _loadStory(story: widget.stories![_currentIndex]);
  //       } else {
  //         // Out of bounds - loop story // You can also
  //         Navigator.of(context).pop();
  //         _currentIndex = 0;
  //         _loadStory(story: widget.stories![_currentIndex]);
  //       }
  //     });
  //   } else {
  //     // if (story.media == MediaType.video) {
  //     //   if (_videoController!.value.isPlaying) {
  //     //     _videoController!.pause();
  //     //     _animController!.stop();
  //     //   } else {
  //     //     _videoController!.play();
  //     //     _animController!.forward();
  //     //   }
  //     // }
  //   }
  // }

  void _loadStory({ bool animateToPage = true}) {
    _animController!.stop();
    _animController!.reset();
    _animController!.duration = const Duration(seconds: 10);
    _animController!.forward();
    if (animateToPage) {
      _pageController!.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    required this.animController,
    required this.position,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}
