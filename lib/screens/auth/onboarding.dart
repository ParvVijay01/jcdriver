import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';
import 'package:jcdriver/utilities/constants/images.dart';
import 'package:jcdriver/utilities/constants/sizes.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final List<Map<String, String>> images = [
    {
      'title': 'Effortless Order Management',
      'description':
          'Stay updated with real-time delivery requests, track orders seamlessly, and manage your tasks efficiently—all in one place.',
    },
    {
      'title': 'Optimized Routes, Faster Deliveries',
      'description':
          'Navigate smarter with AI-powered route optimization, saving time and fuel while ensuring on-time deliveries.',
    },
    {
      'title': 'Stay Connected, Stay Informed',
      'description':
          'Receive real-time updates, customer instructions, and notifications to keep your deliveries on track.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: IKSizes.container,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: Stack(children: [
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(0),
                                  right: Radius.circular(50)),
                              color: Theme.of(context).canvasColor),
                        ),
                      ),
                      Image.asset(IKImages.onboardingImg, fit: BoxFit.cover)
                    ]),
                  ),
                  RotatedBox(
                      quarterTurns: 1,
                      child: Text('JC RIDER'.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge?.merge(
                              const TextStyle(
                                  fontSize: 90,
                                  color: IKColors.light,
                                  fontWeight: FontWeight.bold))))
                ],
              )),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: Swiper(
                    itemBuilder: (context, index) {
                      final title = images[index]['title']!;
                      final description = images[index]['description']!;

                      return Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.merge(
                                      TextStyle(fontWeight: FontWeight.bold)),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.merge(TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.color,
                                      fontSize: 15)),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      );
                    },
                    // indicatorLayout: PageIndicatorLayout.COLOR,

                    autoplay: true,
                    itemCount: images.length,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      size: 6,
                      activeSize: 8,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? IKColors.background
                          : Color.fromARGB(47, 0, 0, 0),
                      activeColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? IKColors.card
                              : IKColors.secondary,
                      space: 4,
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).textTheme.titleMedium?.color,
                      side: const BorderSide(color: IKColors.secondary),
                      foregroundColor: Theme.of(context).cardColor),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
