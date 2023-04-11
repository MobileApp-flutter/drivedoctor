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
        body: SafeArea(
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
              SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        _onboardController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        'link svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ))),
            ],
          )
        ],
      ),
    )));
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 12,
        width: 4,
        decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade900 : Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(12))));
  }
}

class OnboardData {
  final String image, title, description;

  OnboardData({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardData> onboarddata = [
  OnboardData(
    image: 'assets/garage.png',
    title: 'hi1',
    description: 'hello',
  ),
  OnboardData(
    image: 'asset',
    title: 'hi2',
    description: 'hello',
  ),
  OnboardData(
    image: 'asset',
    title: 'hi3',
    description: 'hello',
  ),
];

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
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
