import 'package:drivedoctor/constants/onboarddata.dart';
import 'package:drivedoctor/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    Key? key,
  }) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _onboardController;

  int _pageIndex = 0;

  @override
  void initState() {
    _onboardController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _onboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: onboarddata.length,
                      controller: _onboardController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) => OnboardingContent(
                        image: onboarddata[index].image,
                        title: onboarddata[index].title,
                        description: onboarddata[index].description,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        onboarddata.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: DotIndicator(isActive: index == _pageIndex),
                        ),
                      ),
                      const Spacer(),
                      if (_pageIndex < onboarddata.length - 1)
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              _onboardController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.blue.shade800,
                              elevation: 5,
                              shadowColor: Colors.blue.shade800,
                            ),
                            child: SvgPicture.asset(
                              'assets/arrow_right.svg',
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 60,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement sign in logic
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              backgroundColor: Colors.blue.shade800,
                              elevation: 5,
                              shadowColor: Colors.blue.shade800,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
    this.activeWidth = 25.0,
  }) : super(key: key);

  final bool isActive;
  final double activeWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 12,
        width: isActive ? activeWidth : 12,
        decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade900 : Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(12))));
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 40,
        ),
        Image.asset(
          image,
          height: 230,
        ),
        const SizedBox(
          height: 40,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: defaultText,
        ),
        const Spacer(),
      ],
    );
  }
}
