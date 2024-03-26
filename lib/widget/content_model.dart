class OnboardingContent{
  String image;
  String title;
  String description;
  OnboardingContent({required this.description, required this.image, required this.title});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      description: 'Pick your vegies from our menu\n              More than 35 times',
      image: "images/screen1.png", 
      title: 'Select from Our\n      Best menu'),
  OnboardingContent(
      description: 'You can pay on delivery and\n   Card payment is available',
      image: "images/screen2.png",
      title: 'Easy and Online Payment'),
  OnboardingContent(
      description: 'Deliver your vegies at your Doorstep',
      image: "images/screen3.png",
      title: 'Quick Delivery at\n   Your Doorstep')
];