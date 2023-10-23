import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* 
  Cette page est une page d'essai a nettoyer 

 */
const double kPadding = 14.0;

class OnBoardingItem {
  OnBoardingItem(this.imagePath, this.title, this.subtitle);

  final String imagePath;
  final String title;
  final String subtitle;
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late double currentIndexPage;
  late int pageLength;
  PageController _pageController = PageController();

  List<OnBoardingItem> onBoardingItemList = [
    OnBoardingItem(
      ImagePath.BEAUTIFUL_SITES,
      StringConst.ONBOARDING_TITLE_1,
      StringConst.LOREM_IPSUM_1,
    ),
    OnBoardingItem(
      ImagePath.TRIPS,
      StringConst.ONBOARDING_TITLE_2,
      StringConst.LOREM_IPSUM_1,
    ),
    OnBoardingItem(
      ImagePath.FRIENDSHIP_1,
      StringConst.ONBOARDING_TITLE_3,
      StringConst.LOREM_IPSUM_2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentIndexPage = 0;
    pageLength = onBoardingItemList.length;
  }

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = assignWidth(context: context, fraction: 1.0);
    double heightOfScreen = assignHeight(context: context, fraction: 1.0);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        height: heightOfScreen,
        width: widthOfScreen,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: _buildOnBoardingItems(onBoardingItemList),
              onPageChanged: (value) {
                setState(() => currentIndexPage = value.toDouble());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPadding, vertical: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildDotsIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOnBoardingItems(List<OnBoardingItem> onBoardingItemList) {
    List<Widget> items = [];

    for (int index = 0; index < onBoardingItemList.length; index++) {
      items.add(
        onBoardingItem(
          imagePath: onBoardingItemList[index].imagePath,
          title: onBoardingItemList[index].title,
          subtitle: onBoardingItemList[index].subtitle,
        ),
      );
    }
    return items;
  }

  Widget onBoardingItem({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    double widthOfScreen = assignWidth(context: context, fraction: 1.0);
    double heightOfScreen = assignHeight(context: context, fraction: 1.0);
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Image.asset(
          imagePath,
          width: widthOfScreen,
          height: heightOfScreen,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: Gradients.darkOverlayGradient,
          ),
        ),
        Container(
          height: heightOfScreen * 0.4,
          margin: EdgeInsets.only(top: heightOfScreen * 0.6),
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SpaceH8(),
              Text(
                subtitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDotsIndicator() {
    ThemeData theme = Theme.of(context);
    double widthOfScreen = assignWidth(context: context, fraction: 1.0);
    return Row(
      mainAxisAlignment:
          !isLastItem() ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        !isLastItem()
            ? Expanded(
                child: _buildControls(),
              )
            : Container(
                width: widthOfScreen - (kPadding * 2),
                height: Sizes.HEIGHT_56,
                child: Center(
                  child: CustomButton(
                    onPressed: () {
                      //AutoRouter.of(context).push(LoginScreenRoute());
                    },
                    title: StringConst.GET_STARTED,
                    borderRadius: Sizes.RADIUS_8,
                    textStyle: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
      ],
    );
  }

  bool isFirstItem() {
    return currentIndexPage > 0 && currentIndexPage < pageLength;
  }

  bool isLastItem() {
    return currentIndexPage == pageLength - 1;
  }

  Widget _buildControls() {
    return Row(
      children: [
        isFirstItem()
            ? Container(
                width: Sizes.WIDTH_56,
                height: Sizes.HEIGHT_56,
                child: CustomButton2(
                  onPressed: () => _slideBackwards(),
                  color: AppColors.lightGreen50,
                  iconColor: AppColors.accentColor,
                  borderRadius: Sizes.RADIUS_8,
                  icon: FeatherIcons.chevronLeft,
                ),
              )
            : Empty(),
        isFirstItem() ? Spacer() : Empty(),
        Container(
          height: assignHeight(context: context, fraction: 0.1),
          child: DotsIndicator(
            dotsCount: pageLength,
            position: currentIndexPage,
            decorator: DotsDecorator(
              color: AppColors.grey,
              activeColor: AppColors.white,
              size: Size(Sizes.SIZE_12, Sizes.SIZE_6),
              activeSize: Size(Sizes.SIZE_20, Sizes.SIZE_6),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(const Radius.circular(Sizes.RADIUS_8)),
              ),
              activeShape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(const Radius.circular(Sizes.RADIUS_8)),
              ),
              spacing: EdgeInsets.symmetric(horizontal: Sizes.SIZE_4),
            ),
          ),
        ),
        Spacer(),
        Container(
          width: Sizes.WIDTH_56,
          height: Sizes.HEIGHT_56,
          child: CustomButton2(
            onPressed: () => _slideForward(),
            borderRadius: Sizes.RADIUS_8,
            icon: FeatherIcons.chevronRight,
          ),
        ),
      ],
    );
  }

  void _slideBackwards() {
    if (currentIndexPage < (pageLength - 1) && currentIndexPage != 0) {
      setState(() {
        currentIndexPage -= 1.toDouble();
      });
      movePageViewer(currentIndexPage);
    }
  }

  void _slideForward() {
    if (currentIndexPage < pageLength - 1) {
      setState(() {
        currentIndexPage += 1.toDouble();
      });
      movePageViewer(currentIndexPage);
    }
  }

  void movePageViewer(double position) {
    _pageController.animateToPage(
      position.toInt(),
      duration: Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }
}

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

enum DisplayType {
  desktop,
  mobile,
}

const _desktopPortraitBreakpoint = 700.0;
const _desktopLandscapeBreakpoint = 1000.0;

/// Returns the [DisplayType] for the current screen. This app only supports
/// mobile and desktop layouts, and as such we only have one breakpoint.
DisplayType displayTypeOf(BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;
  final width = MediaQuery.of(context).size.width;

  if ((orientation == Orientation.landscape &&
          width > _desktopLandscapeBreakpoint) ||
      (orientation == Orientation.portrait &&
          width > _desktopPortraitBreakpoint)) {
    return DisplayType.desktop;
  } else {
    return DisplayType.mobile;
  }
}

/// Returns a boolean if we are in a display of [DisplayType.desktop]. Used to
/// build adaptive and responsive layouts.
bool isDisplayDesktop(BuildContext context) {
  return displayTypeOf(context) == DisplayType.desktop;
}

/// Returns a boolean if we are in a display of [DisplayType.desktop] but less
/// than [_desktopLandscapeBreakpoint] width. Used to build adaptive and responsive layouts.
bool isDisplaySmallDesktop(BuildContext context) {
  return isDisplayDesktop(context) &&
      MediaQuery.of(context).size.width < _desktopLandscapeBreakpoint;
}

double widthOfScreen(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double heightOfScreen(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double assignHeight({
  required BuildContext context,
  required double fraction,
  double additions = 0,
  double subs = 0,
}) {
  return (heightOfScreen(context) - (subs) + (additions)) * fraction;
}

double assignWidth({
  required BuildContext context,
  required double fraction,
  double additions = 0,
  double subs = 0,
}) {
  return (widthOfScreen(context) - (subs) + (additions)) * fraction;
}

class CustomButton extends StatelessWidget {
  CustomButton({
    this.title,
    this.onPressed,
    this.height = Sizes.HEIGHT_50,
    this.elevation = Sizes.ELEVATION_1,
    this.borderRadius = Sizes.RADIUS_24,
    this.color = AppColors.accentColor,
    this.borderSide = Borders.defaultPrimaryBorder,
    this.textStyle,
    this.icon,
  });

  final VoidCallback? onPressed;
  final double height;
  final double elevation;
  final double borderRadius;
  final String? title;
  final Color color;
  final BorderSide borderSide;
  final TextStyle? textStyle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide,
      ),
      height: height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon != null ? icon! : Container(),
          icon != null ? SpaceW8() : Container(),
          title != null
              ? Text(
                  title!,
                  style: textStyle,
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  CustomButton2({
    this.onPressed,
    this.height = Sizes.HEIGHT_56,
    this.elevation = Sizes.ELEVATION_1,
    this.borderRadius = Sizes.RADIUS_24,
    this.color = AppColors.accentColor,
    this.iconColor = AppColors.white,
    this.iconSize,
    this.borderSide = Borders.defaultPrimaryBorder,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final double height;
  final double elevation;
  final double borderRadius;
  final Color color;
  final Color? iconColor;
  final double? iconSize;
  final BorderSide borderSide;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide,
      ),
      height: height,
      color: color,
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}

class SpaceH8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.0,
    );
  }
}

class SpaceW8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8.0,
    );
  }
}

class Sizes {
  static const double HEIGHT_OF_BOTTOM_NAV_BAR = 64.0;
  static const double SAFE_AREA_MARGIN = 24.0;
  static const double SIZE_120 = 120.0;
  static const double SIZE_96 = 96.0;
  static const double SIZE_80 = 80.0;
  static const double SIZE_60 = 60.0;
  static const double SIZE_48 = 48.0;
  static const double SIZE_40 = 40.0;
  static const double SIZE_36 = 36.0;
  static const double SIZE_32 = 32.0;
  static const double SIZE_24 = 24.0;
  static const double SIZE_20 = 20.0;
  static const double SIZE_16 = 16.0;
  static const double SIZE_12 = 12.0;
  static const double SIZE_8 = 8.0;
  static const double SIZE_6 = 6.0;
  static const double SIZE_4 = 4.0;
  static const double SIZE_2 = 2.0;
  static const double SIZE_1 = 1.0;
  static const double SIZE_0 = 0.0;

  //TextSizes
  static const double TEXT_SIZE_96 = 96.0;
  static const double TEXT_SIZE_60 = 60.0;
  static const double TEXT_SIZE_50 = 50.0;
  static const double TEXT_SIZE_48 = 48.0;
  static const double TEXT_SIZE_44 = 44.0;
  static const double TEXT_SIZE_40 = 40.0;
  static const double TEXT_SIZE_36 = 36.0;
  static const double TEXT_SIZE_34 = 34.0;
  static const double TEXT_SIZE_32 = 32.0;
  static const double TEXT_SIZE_30 = 30.0;
  static const double TEXT_SIZE_28 = 28.0;
  static const double TEXT_SIZE_24 = 24.0;
  static const double TEXT_SIZE_22 = 22.0;
  static const double TEXT_SIZE_20 = 20.0;
  static const double TEXT_SIZE_18 = 18.0;
  static const double TEXT_SIZE_16 = 16.0;
  static const double TEXT_SIZE_14 = 14.0;
  static const double TEXT_SIZE_12 = 12.0;
  static const double TEXT_SIZE_10 = 10.0;
  static const double TEXT_SIZE_8 = 8.0;

  //IconSizes
  static const double ICON_SIZE_60 = 60.0;
  static const double ICON_SIZE_50 = 50.0;
  static const double ICON_SIZE_40 = 40.0;
  static const double ICON_SIZE_32 = 32.0;
  static const double ICON_SIZE_30 = 30.0;
  static const double ICON_SIZE_24 = 24.0;
  static const double ICON_SIZE_22 = 22.0;
  static const double ICON_SIZE_20 = 20.0;
  static const double ICON_SIZE_18 = 18.0;
  static const double ICON_SIZE_16 = 16.0;
  static const double ICON_SIZE_14 = 14.0;
  static const double ICON_SIZE_12 = 12.0;
  static const double ICON_SIZE_10 = 10.0;
  static const double ICON_SIZE_8 = 8.0;

  //Heights
  static const double HEIGHT_300 = 300.0;
  static const double HEIGHT_240 = 240.0;
  static const double HEIGHT_200 = 200.0;
  static const double HEIGHT_180 = 180.0;
  static const double HEIGHT_160 = 160.0;
  static const double HEIGHT_150 = 150.0;
  static const double HEIGHT_130 = 130.0;
  static const double HEIGHT_100 = 100.0;
  static const double HEIGHT_74 = 74.0;
  static const double HEIGHT_64 = 64.0;
  static const double HEIGHT_60 = 60.0;
  static const double HEIGHT_56 = 56.0;
  static const double HEIGHT_50 = 50.0;
  static const double HEIGHT_48 = 48.0;
  static const double HEIGHT_46 = 46.0;
  static const double HEIGHT_44 = 44.0;
  static const double HEIGHT_42 = 42.0;
  static const double HEIGHT_40 = 40.0;
  static const double HEIGHT_36 = 36.0;
  static const double HEIGHT_32 = 32.0;
  static const double HEIGHT_30 = 30.0;
  static const double HEIGHT_25 = 25.0;
  static const double HEIGHT_24 = 24.0;
  static const double HEIGHT_22 = 22.0;
  static const double HEIGHT_20 = 20.0;
  static const double HEIGHT_18 = 18.0;
  static const double HEIGHT_16 = 16.0;
  static const double HEIGHT_14 = 14.0;
  static const double HEIGHT_12 = 12.0;
  static const double HEIGHT_10 = 10.0;
  static const double HEIGHT_8 = 8.0;
  static const double HEIGHT_4 = 4.0;
  static const double HEIGHT_3 = 3.0;
  static const double HEIGHT_2 = 2.0;
  static const double HEIGHT_1 = 1.0;
  static const double HEIGHT_0 = 0.0;

  //Widths
  static const double WIDTH_300 = 300.0;
  static const double WIDTH_236 = 236.0;
  static const double WIDTH_200 = 200.0;
  static const double WIDTH_180 = 180.0;
  static const double WIDTH_170 = 170.0;
  static const double WIDTH_160 = 160.0;
  static const double WIDTH_150 = 150.0;
  static const double WIDTH_120 = 120.0;
  static const double WIDTH_100 = 100.0;
  static const double WIDTH_80 = 80.0;
  static const double WIDTH_74 = 74.0;
  static const double WIDTH_64 = 64.0;
  static const double WIDTH_60 = 60.0;
  static const double WIDTH_56 = 56.0;
  static const double WIDTH_50 = 50.0;
  static const double WIDTH_48 = 48.0;
  static const double WIDTH_44 = 44.0;
  static const double WIDTH_40 = 40.0;
  static const double WIDTH_36 = 36.0;
  static const double WIDTH_32 = 32.0;
  static const double WIDTH_30 = 30.0;
  static const double WIDTH_25 = 25.0;
  static const double WIDTH_24 = 24.0;
  static const double WIDTH_22 = 22.0;
  static const double WIDTH_20 = 20.0;
  static const double WIDTH_18 = 18.0;
  static const double WIDTH_16 = 16.0;
  static const double WIDTH_14 = 14.0;
  static const double WIDTH_12 = 12.0;
  static const double WIDTH_10 = 10.0;
  static const double WIDTH_8 = 8.0;
  static const double WIDTH_6 = 6.0;
  static const double WIDTH_4 = 4.0;
  static const double WIDTH_2 = 2.0;
  static const double WIDTH_1 = 1.0;
  static const double WIDTH_0 = 0.0;

  //Margins
  static const double MARGIN_200 = 200.0;
  static const double MARGIN_60 = 60.0;
  static const double MARGIN_48 = 48.0;
  static const double MARGIN_46 = 46.0;
  static const double MARGIN_44 = 44.0;
  static const double MARGIN_40 = 40.0;
  static const double MARGIN_36 = 36.0;
  static const double MARGIN_32 = 32.0;
  static const double MARGIN_30 = 30.0;
  static const double MARGIN_26 = 26.0;
  static const double MARGIN_24 = 24.0;
  static const double MARGIN_22 = 22.0;
  static const double MARGIN_20 = 20.0;
  static const double MARGIN_18 = 18.0;
  static const double MARGIN_16 = 16.0;
  static const double MARGIN_14 = 14.0;
  static const double MARGIN_12 = 12.0;
  static const double MARGIN_10 = 10.0;
  static const double MARGIN_8 = 8.0;
  static const double MARGIN_4 = 4.0;
  static const double MARGIN_0 = 0.0;

  //Paddings
  static const double PADDING_44 = 44.0;
  static const double PADDING_40 = 40.0;
  static const double PADDING_36 = 36.0;
  static const double PADDING_32 = 32.0;
  static const double PADDING_24 = 24.0;
  static const double PADDING_22 = 22.0;
  static const double PADDING_20 = 20.0;
  static const double PADDING_18 = 18.0;
  static const double PADDING_16 = 16.0;
  static const double PADDING_14 = 14.0;
  static const double PADDING_12 = 12.0;
  static const double PADDING_10 = 10.0;
  static const double PADDING_8 = 8.0;
  static const double PADDING_4 = 4.0;
  static const double PADDING_2 = 2.0;
  static const double PADDING_0 = 0.0;

  //Radius
  static const double RADIUS_80 = 80.0;
  static const double RADIUS_70 = 70.0;
  static const double RADIUS_60 = 60.0;
  static const double RADIUS_40 = 40.0;
  static const double RADIUS_32 = 32.0;
  static const double RADIUS_30 = 30.0;
  static const double RADIUS_24 = 24.0;
  static const double RADIUS_22 = 22.0;
  static const double RADIUS_20 = 20.0;
  static const double RADIUS_18 = 18.0;
  static const double RADIUS_16 = 16.0;
  static const double RADIUS_14 = 14.0;
  static const double RADIUS_12 = 12.0;
  static const double RADIUS_10 = 10.0;
  static const double RADIUS_8 = 8.0;
  static const double RADIUS_6 = 6.0;
  static const double RADIUS_4 = 4.0;
  static const double RADIUS_0 = 0.0;

  //Elevations
  static const double ELEVATION_16 = 16.0;
  static const double ELEVATION_14 = 14.0;
  static const double ELEVATION_12 = 12.0;
  static const double ELEVATION_10 = 10.0;
  static const double ELEVATION_8 = 8.0;
  static const double ELEVATION_6 = 6.0;
  static const double ELEVATION_4 = 4.0;
  static const double ELEVATION_2 = 2.0;
  static const double ELEVATION_1 = 1.0;
  static const double ELEVATION_0 = 0.0;
}

class AppColors {
  static const Color primaryColor = Color(0xFF58918E);
  static const Color secondaryColor = Color(0xFF1B5755);
  static const Color accentColor = Color(0xFF2762CB);
  static const Color accentColor40 = Color.fromRGBO(39, 98, 203, 0.4);

  static const Color primaryText = Color(0xFF1B5755);
  static const Color primaryText2 = Color(0xFF2F4858);
  static const Color primaryText3 = Color(0xFF326770);

  //Black
  static const Color black = Color(0xFF000000);
  static const Color black20 = Color(0xFF262626);
  static const Color black50 = Color(0xFF444655);
  static const Color black10 = Color.fromRGBO(36, 61, 72, 0.7);

  //White
  static const Color white = Color(0xFFFFFFFF);
  static const Color white20 = Color(0xFFF2F2F2);
  static const Color white50 = Color(0xFFFAFAFA);
  static const Color white60 = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color white100 = Color(0xFFFDFDFD);

  //grey
  static const Color grey = Color(0xFFA1A1A1);
  static const Color grey50 = Color(0xFFA8AABC);
  static const Color grey200 = Color(0xFF828282);

  //LightGreen
  static const Color lightGreen50 = Color(0xFFDAE8E7);
  static const Color lightGreen70 = Color(0xFFE3F1EE);

  //darkGreen
  static const Color darkGreen = Color(0xFF1F83A4);

  //Green
  static const Color green50 = Color(0xFF2CCCA6);
  static const Color green100 = Color(0xFF57D63F);

  //orange
  static const Color orange50 = Color(0xFFF35A2A);

  static const Color facebookBlue = Color(0xFF44619D);

  //Yellow
  static const Color yellow10 = Color(0xFFFFF7E6);
  static const Color yellow30 = Color(0xFFFFF1D4);
  static const Color yellow = Color(0xFFFBBA3E);
  static const Color deepYellow = Color(0xFFDFA01F);

  //purple
  static const Color purple = Color(0xFF8960BE);
  static const Color purple10 = Color(0xFFFDEEFF);

  //pink
  static const Color pink = Color(0xFFFF667A);
  static const Color pink10 = Color(0xFFFFE4E5);
}

class Borders {
  static const InputBorder defaultBorder = OutlineInputBorder(
//    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    borderSide: BorderSide(
      color: AppColors.white,
      width: 0.0,
      style: BorderStyle.none,
    ),
  );

  static customBorder({
    Color color = AppColors.white,
    double width = Sizes.WIDTH_1,
    BorderStyle style = BorderStyle.solid,
  }) {
    return BorderSide(
      color: color,
      width: width,
      style: style,
    );
  }

  static const BorderSide defaultPrimaryBorder =
      BorderSide(width: Sizes.WIDTH_0, style: BorderStyle.none);

  static const UnderlineInputBorder noBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      style: BorderStyle.none,
    ),
  );

  static customOutlineInputBorder({
    double borderRadius = Sizes.RADIUS_12,
    Color color = AppColors.primaryColor,
    double width = Sizes.WIDTH_1,
    BorderStyle style = BorderStyle.solid,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(
        color: color,
        width: width,
        style: style,
      ),
    );
  }

  static customUnderlineInputBorder({
    Color color = AppColors.primaryColor,
    double width = Sizes.WIDTH_1,
    BorderStyle style = BorderStyle.solid,
  }) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
        style: style,
      ),
    );
  }

  static const UnderlineInputBorder disabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.grey,
      width: Sizes.WIDTH_1,
      style: BorderStyle.solid,
    ),
  );
}

class StringConst {
  //strings
  static const String APP_NAME = "Roam";

  //OnBoarding
  static const String ONBOARDING_TITLE_1 =
      "Find new  places and explore  adventures";
  static const String ONBOARDING_TITLE_2 =
      "Meet new people with similar interest ";
  static const String ONBOARDING_TITLE_3 = "Share trip ideas with friends";
  static const String LOREM_IPSUM_1 =
      "Integer arcu, egestas at nunc. Pellentesque amet scelerisque in dui ut. Fringilla nulla proin nibh amet. Curabitur.";
  static const String LOREM_IPSUM_2 =
      "Ornare non in in varius velit laoreet. Aenean at ut non, duis ut ut condimentum urna. At integer pellentesque dapibus a. Ornare.";
  static const String GET_STARTED = "Get Started";
  static const String MEET_UP = "Meet Up";
  static const String MEET_UP_UI_KIT = "Meet Up UI-Kit";

  //Registration / Login
  static const String LOG_IN = "Log in";
  static const String SIGN_UP = "Sign up";

  //Select Interest
  static const String HELLO = "Hello ";
  static const String KRISTIN = "Kristin ";
  static const String INTEREST = "what do you love most about travelling?";
  static const String SELECT_5 = "Select 5 or more ";
  static const String NEXT = "Next";
  static const String FINISH = "Finish";
  static const String START_MY_TRIP = "Start my trip";
  static const String PARTY = "Party";
  static const String SOLO = "Solo";

  //Follow Friends
  static const String FOLLOW_FRIENDS =
      "Follow friends and travel enthusiast with similar interest as you";
  static const String FOLLOW = "Follow";
  static const String FOLLOWING = "Following";
  static const String TRAVELLERS_STARS = "travellers stars";

  static const String CODY = "Cody Fisher";
  static const String DARELL = "Darell Steward";
  static const String ESTHER = "Esther Howard";
  static const String HAWKINS = "Guy Hawkins";
  static const String JANE = "Jane Cooper";
  static const String LESLIE = "Leslie Alexander";

  //Interests
  static const String ADVENTURE = "Adventure";
  static const String BEACH = "Beach";
  static const String CULTURE = "Culture";
  static const String FOOD = "Food";
  static const String MOUNTAIN = "Mountain";
  static const String NATURE = "Nature";
  static const String PEOPLE = "People";
  static const String RESORT = "Resort";
  static const String URBAN = "Urban";

  //HomeScreen
  static const String PEOPLE_LIKES = "People liked this";
  static const String WILDLIFE = "Wildlife";
  static const String TRAVEL = "Travel the world in grand style";
  static const String ANIMALS = "Animals";
  static const String BEACHES = "Beaches";
  static const String MEALS = "Meals";
  static const String DISCOVER = "Discover";
  static const String SEE_ALL = "See all";
  static const String TRENDING_SIGHTS = "Trending Sites";
  static const String FOR_YOU = "For You";
  static const String MOST_VISITED = "Most Visited";
  static const String LIMA_CITY = "Lima City";
  static const String LIMA = "Lima";
  static const String PERU = "Peru";
  static const String HALONG_BAY = "Halong Bay";
  static const String VIETNAM = "Vietnam";
  static const String VATICAN_CITY = "Vatican City";
  static const String ITALY = "Italy";
  static const String RHODES = "Rhodes";
  static const String GREECE = "Greece";
  static const String BALI = "Regis, Bali";
  static const String INDONESIA = "Indonesia";

  static const String VENICE = "Venice";
  static const String HOI_ANN = "Hoi Ann";
  static const String VARANASI = "Varanasi";
  static const String BARRANCO = "Barranco";
  static const String MYKONO = "Mykono";
  static const String INDIA = "India";

  static const String CONTENT_RATING_1 = "2456 ratings";
  static const String CONTENT_RATING_2 = "5201 ratings";
  static const String CONTENT_RATING_3 = "1321 ratings";
  static const String CONTENT_RATING_4 = "459 ratings";
  static const String CONTENT_RATING_5 = "987 ratings";

  //DiscoverScreen
  static const String MY_TRIPS = "My Trips";
  static const String TRIP_COLLABORATORS = "Trip Collaborators";
  static const String ITALY_ADVENTURE = "Italy Adventure 2021";
  static const String DURATION = "09 Jan - 21 Jan";
  static const String TRIP_SUMMARY =
      "A vacation trip with friends to Bali Indonesia ro see the resorts, beaches etc.";
  static const String OLD_TRIP = "Old Trips";
  static const String PERU_BEACH = "Peru Beaches '19";
  static const String TOKYO = "Tokyo '15";
  static const String BALI_BEACHES = "Bali Beaches '15";
  static const String VIETNAM_19 = "Love Vietnam '19";
  static const String PARIS_FUN = "Parin Fun '17";

  static const String DURATION_1 = "3 months ago";
  static const String DURATION_2 = "6 months ago";
  static const String NEW_TRIP = "New Trip";

  //SavedPlaces Screen
  static const String SAVED_PLACES = "Saved Places";
  static const String PEOPLE_LIKED_THIS = "people liked this";
  static const String GREAT_WALL = "The Great Wall, China";
  static const String EIFFEL_TOWER = "Eiffel Tower";
  static const String STONE_HENGE = "Stonehenge, England";
  static const String NIAGARA_FALLS = "Niagara Falls, Canada";
  static const String BLACK_LAGOON = "The Black Lagoon, Iceland";
  static const String ATTRACTIONS = "Attractions";
  static const String HOTELS = "Hotel";
  static const String RECOMMENDED = "Recommended";

  //PlaceScreen
  static const String TEMPERATURE = "26";
  static const String CELSIUS = "°C";
  static const String MORE_OF = "More of";
  static const String PLACES_TO_EXPLORE = "Places to Explore";
  static const String EXPERIENCES = "Attractions & Experiences";
  static const String PHOTOGRAPHY_TAG = "Photography";
  static const String LUXURY_TAG = "Luxury";
  static const String NATURE_TAG = "Nature";
  static const String BREAKFAST_PLACES = "Places for breakfast";
  static const String RESORTS = "Resorts in Bali";
  static const String TANOH = "Tanah Lot";
  static const String TANOH_TEXT = "Island Templs with water views";
  static const String SACRED_MONKEY = "Sacred Monkey Sanctuary";
  static const String SACRED_MONKEY_TEXT = "Temple Complex with many monkeys";
  static const String GILI_ISLAND = "Gili Island";
  static const String GILI_ISLAND_TEXT = "Three tiny Island near sandy beaches";
  static const String SEE_MORE = "Want to see more?";
  static const String LETS_GO = "Let's go to ";

  //Profile Screen
  static const String PHOTO_STORIES = "My Photos & Stories";
  static const String JOURNEYS = "My Journeys";
  static const String FOLLOWERS = "Followers";
  static const String NO_OF_FOLLOWERS = "3.3K";
  static const String NO_OF_FOLLOWING = "456";
  static const String TRAVELS = "Travels";
  static const String NO_OF_TRAVELS = "34";
  static const String USER_NAME = "Kristin Watson";
  static const String USER_HANDLE = "@kristinthetraveller";
  static const String ABOUT_USER =
      "I’m a travel enthusiast. Always on the move, capturing memoeries all over the world. Follow for a follow back.";
  static const String THAILAND = "Thailand";
  static const String SEE_JOURNEYS = "See all journeys";
  static const String SUBTITLE_1 = "Island Temples with water views";
  static const String SUBTITLE_2 = "Beautiful scenes and luxurious places";
  static const String SUBTITLE_3 = "The strongest bridge around here";
  static const String KANCHANABURI = "Kanchanaburi";

  //Add Collaborators Screen
  static const String ADD_COLLABORATORS = "Add Friends as Collaborators";
  static const String TRIP_NAME = "Trip name";
  static const String DATE = "Date";
  static const String TRAVEL_WITH = "Travel with?";

  static const String HOWARD = "Esther Howard";
  static const String FISHER = "Cody Fisher";
  static const String COURTNEY = "Courtney Henry";
  static const String ANNETTE = "Annette Black";
  static const String ELEANOR = "Eleanor Pena";
  static const String JEROME = "Jerome Bell";

  //hint_text
  static const String FULL_NAME = "Full Name";
  static const String PASSWORD = "Password";
  static const String CONFIRM_PASSWORD = "Confirm Password";
  static const String EMAIL = "Email";

  static const String FULL_NAME_HINT_TEXT = "Eleanor Pena";
  static const String PASSWORD_HINT_TEXT = "********";
  static const String EMAIL_HINT_TEXT = "example@gmail.com";
  static const String SEARCH_HINT_TEXT = "Search for countries, places etc";
  static const String SEARCH_HINT_TEXT_2 = "Search for friends";
  static const String TRIP_HINT_TEXT = "Bali Adventure 2021";
  static const String DATE_HINT_TEXT = "09 Jan - 26 Jan";

  static const String FACEBOOK = "Facebook";
  static const String GOOGLE = "Google";
  static const String FORGOT_PASSWORD = "Forgot Password?";
  static const String ALREADY_HAVE_AN_ACCOUNT = "Already have an account? ";
  static const String DONT_HAVE_AN_ACCOUNT = "Don't have an account? ";
  static const String CREATE_ACCOUNT = "Create account";
  static const String OR = "or";
}

class Gradients {
  static const LinearGradient curvesGradient3 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF88CEBC),
      Color(0xFF69C7C6),
    ],
  );

  static const Gradient darkOverlayGradient = LinearGradient(
    begin: Alignment(0.51436, 1.07565),
    end: Alignment(0.51436, -0.03208),
    stops: [
      0,
      0.17571,
      1,
    ],
    colors: [
      Color.fromARGB(180, 60, 70, 85),
      Color.fromARGB(180, 60, 70, 85),
      Color.fromARGB(20, 45, 45, 45),
    ],
  );

  static const Gradient discoverCardOverlayGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromRGBO(27, 87, 85, 0.4),
      Color.fromRGBO(27, 87, 85, 0.4),
    ],
  );
}
