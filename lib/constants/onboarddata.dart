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
    title: 'Welcome to DriveDoctor!',
    description: 'Have you ever wonder why life is such a menace to drivers?',
  ),
  OnboardData(
    image: 'assets/brake.png',
    title: 'No more hassle!',
    description:
        'With DriveDoctor, you can search for spare parts and look for nearby marketplace',
  ),
  OnboardData(
    image: 'assets/battery.png',
    title: 'Join Us Now',
    description: "Please give a try.",
  ),
];
