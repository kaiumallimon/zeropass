import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeropass/core/constants/app_assets.dart';
import 'package:zeropass/core/constants/app_strings.dart';
import 'package:zeropass/data/local_db/local_db_service.dart';
import 'package:zeropass/presentation/pages/welcome/widgets/pageview_navigator.dart';
import 'package:zeropass/shared/widgets/custom_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: PageView.builder(
          itemCount: 4,

          itemBuilder: (context, index) {
            return Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // logo
                  Image.asset(AppAssets.logo, width: 50, height: 50),

                  // titles and subtitles
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: _getTitle(index).first,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: _getTitle(index)[1],
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextSpan(
                              text: _getTitle(index).last,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // subtitle
                      Wrap(
                        children: [
                          Text(
                            _getSubtitle(index),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // buttons row
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WelcomePageNavigator(theme: theme, index: index),

                          Row(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Swipe',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(.5),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Register',
                              isBordered: true,
                              onPressed: () async {
                                await LocalDatabaseService.setWelcomeShown(
                                  true,
                                );

                                if (context.mounted) {
                                  context.go('/register');
                                }
                              },
                              height: 45,
                            ),
                          ),

                          Expanded(
                            child: CustomButton(
                              text: 'Login',
                              height: 45,

                              onPressed: () async {
                                await LocalDatabaseService.setWelcomeShown(
                                  true,
                                );

                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Returns the titles for the welcome page based on the index.
  List<String> _getTitle(index) {
    switch (index) {
      case 0:
        return [
          AppStrings.welcome1Title1,
          AppStrings.welcome1Title2,
          AppStrings.welcome1Title3,
        ];
      case 1:
        return [
          AppStrings.welcome2Title1,
          AppStrings.welcome2Title2,
          AppStrings.welcome2Title3,
        ];
      case 2:
        return [
          AppStrings.welcome3Title1,
          AppStrings.welcome3Title2,
          AppStrings.welcome3Title3,
        ];
      case 3:
        return [
          AppStrings.welcome4Title1,
          AppStrings.welcome4Title2,
          AppStrings.welcome4Title3,
        ];
      default:
        return [];
    }
  }

  /// Returns the subtitle for the welcome page based on the index.
  String _getSubtitle(index) {
    switch (index) {
      case 0:
        return AppStrings.welcome1Subtitle;
      case 1:
        return AppStrings.welcome2Subtitle;
      case 2:
        return AppStrings.welcome3Subtitle;
      case 3:
        return AppStrings.welcome4Subtitle;
      default:
        return '';
    }
  }
}
