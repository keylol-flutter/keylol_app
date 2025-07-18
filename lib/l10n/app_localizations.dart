import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('zh')];

  /// No description provided for @title.
  ///
  /// In zh, this message translates to:
  /// **'Keylol Flutter'**
  String get title;

  /// No description provided for @networkError.
  ///
  /// In zh, this message translates to:
  /// **'连接出错了，请稍后重试~'**
  String get networkError;

  /// No description provided for @notLoginError.
  ///
  /// In zh, this message translates to:
  /// **'请登录后查看~'**
  String get notLoginError;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @homePageDrawerHeader.
  ///
  /// In zh, this message translates to:
  /// **'Keylol Flutter'**
  String get homePageDrawerHeader;

  /// No description provided for @homePageDrawerListTileHome.
  ///
  /// In zh, this message translates to:
  /// **'主页'**
  String get homePageDrawerListTileHome;

  /// No description provided for @homePageDrawerListTileHistory.
  ///
  /// In zh, this message translates to:
  /// **'历史'**
  String get homePageDrawerListTileHistory;

  /// No description provided for @homePageDrawerListTileFavorite.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get homePageDrawerListTileFavorite;

  /// No description provided for @homePageDrawerListTileNewThread.
  ///
  /// In zh, this message translates to:
  /// **'发新帖'**
  String get homePageDrawerListTileNewThread;

  /// No description provided for @homePageDrawerListTileSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get homePageDrawerListTileSettings;

  /// No description provided for @homePageDrawerListTileLoginout.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get homePageDrawerListTileLoginout;

  /// No description provided for @homeBottomBarDestinationIndex.
  ///
  /// In zh, this message translates to:
  /// **'聚焦'**
  String get homeBottomBarDestinationIndex;

  /// No description provided for @homeBottomBarDestinationGuide.
  ///
  /// In zh, this message translates to:
  /// **'导读'**
  String get homeBottomBarDestinationGuide;

  /// No description provided for @homeBottomBarDestinationForum.
  ///
  /// In zh, this message translates to:
  /// **'版块'**
  String get homeBottomBarDestinationForum;

  /// No description provided for @homeBottomBarDestinationNotice.
  ///
  /// In zh, this message translates to:
  /// **'通知'**
  String get homeBottomBarDestinationNotice;

  /// No description provided for @indexPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'聚焦'**
  String get indexPageTitle;

  /// No description provided for @guidePageTitle.
  ///
  /// In zh, this message translates to:
  /// **'导读'**
  String get guidePageTitle;

  /// No description provided for @guidePageTabHot.
  ///
  /// In zh, this message translates to:
  /// **'最新热门'**
  String get guidePageTabHot;

  /// No description provided for @guidePageTabDigest.
  ///
  /// In zh, this message translates to:
  /// **'最新精华'**
  String get guidePageTabDigest;

  /// No description provided for @guidePageTabNewThread.
  ///
  /// In zh, this message translates to:
  /// **'最新发表'**
  String get guidePageTabNewThread;

  /// No description provided for @guidePageTabNew.
  ///
  /// In zh, this message translates to:
  /// **'最新回复'**
  String get guidePageTabNew;

  /// No description provided for @guidePageTabSofa.
  ///
  /// In zh, this message translates to:
  /// **'抢沙发'**
  String get guidePageTabSofa;

  /// No description provided for @forumIndexPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'版块'**
  String get forumIndexPageTitle;

  /// No description provided for @noticePageTitle.
  ///
  /// In zh, this message translates to:
  /// **'通知'**
  String get noticePageTitle;

  /// No description provided for @forumPageTabAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get forumPageTabAll;

  /// No description provided for @forumPageFilterHeats.
  ///
  /// In zh, this message translates to:
  /// **'热门'**
  String get forumPageFilterHeats;

  /// No description provided for @forumPageFilterHot.
  ///
  /// In zh, this message translates to:
  /// **'热帖'**
  String get forumPageFilterHot;

  /// No description provided for @forumPageFilterDigest.
  ///
  /// In zh, this message translates to:
  /// **'精华'**
  String get forumPageFilterDigest;

  /// No description provided for @forumPageOrderByNull.
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get forumPageOrderByNull;

  /// No description provided for @forumPageOrderByDateline.
  ///
  /// In zh, this message translates to:
  /// **'发帖时间'**
  String get forumPageOrderByDateline;

  /// No description provided for @forumPageOrderByReplies.
  ///
  /// In zh, this message translates to:
  /// **'回复'**
  String get forumPageOrderByReplies;

  /// No description provided for @forumPageOrderByViews.
  ///
  /// In zh, this message translates to:
  /// **'查看'**
  String get forumPageOrderByViews;

  /// No description provided for @forumPageThreadWrapper1.
  ///
  /// In zh, this message translates to:
  /// **'置顶'**
  String get forumPageThreadWrapper1;

  /// No description provided for @forumPageThreadWrapper3.
  ///
  /// In zh, this message translates to:
  /// **'置顶'**
  String get forumPageThreadWrapper3;

  /// No description provided for @loginPageLoginWithPassword.
  ///
  /// In zh, this message translates to:
  /// **'使用密码登录'**
  String get loginPageLoginWithPassword;

  /// No description provided for @loginPageLoginWithSms.
  ///
  /// In zh, this message translates to:
  /// **'使用手机验证码登录'**
  String get loginPageLoginWithSms;

  /// No description provided for @loginPageInputLabelUsername.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get loginPageInputLabelUsername;

  /// No description provided for @loginPageInputUsernameEmpty.
  ///
  /// In zh, this message translates to:
  /// **'用户名不能为空'**
  String get loginPageInputUsernameEmpty;

  /// No description provided for @loginPageInputLabelPassword.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get loginPageInputLabelPassword;

  /// No description provided for @loginPageInputPasswordEmpty.
  ///
  /// In zh, this message translates to:
  /// **'密码不能为空'**
  String get loginPageInputPasswordEmpty;

  /// No description provided for @loginPageInputLabelPhone.
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get loginPageInputLabelPhone;

  /// No description provided for @loginPageInputPhoneEmpty.
  ///
  /// In zh, this message translates to:
  /// **'手机号不能为空'**
  String get loginPageInputPhoneEmpty;

  /// No description provided for @loginPageInputLabelSmsCode.
  ///
  /// In zh, this message translates to:
  /// **'短信验证码'**
  String get loginPageInputLabelSmsCode;

  /// No description provided for @loginPageInputSmsCodeEmpty.
  ///
  /// In zh, this message translates to:
  /// **'短信验证码不能为空'**
  String get loginPageInputSmsCodeEmpty;

  /// No description provided for @loginPageInputLabelSecCode.
  ///
  /// In zh, this message translates to:
  /// **'验证码'**
  String get loginPageInputLabelSecCode;

  /// No description provided for @loginPageInputSecCodeEmpty.
  ///
  /// In zh, this message translates to:
  /// **'验证码不能为空'**
  String get loginPageInputSecCodeEmpty;

  /// No description provided for @loginPageLoginButton.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get loginPageLoginButton;

  /// No description provided for @loginPageError.
  ///
  /// In zh, this message translates to:
  /// **'登录失败，请稍后重试~'**
  String get loginPageError;

  /// No description provided for @threadPageFloor.
  ///
  /// In zh, this message translates to:
  /// **'楼'**
  String get threadPageFloor;

  /// No description provided for @threadPageMenuAddFavorite.
  ///
  /// In zh, this message translates to:
  /// **'添加到收藏'**
  String get threadPageMenuAddFavorite;

  /// No description provided for @threadPageMenuRemoveFavorite.
  ///
  /// In zh, this message translates to:
  /// **'取消收藏'**
  String get threadPageMenuRemoveFavorite;

  /// No description provided for @threadPageMenuOpenInBrowser.
  ///
  /// In zh, this message translates to:
  /// **'在浏览器中打开'**
  String get threadPageMenuOpenInBrowser;

  /// No description provided for @threadPageComment.
  ///
  /// In zh, this message translates to:
  /// **'点评'**
  String get threadPageComment;

  /// No description provided for @threadAddFavoriteDescription.
  ///
  /// In zh, this message translates to:
  /// **'收藏备注'**
  String get threadAddFavoriteDescription;

  /// No description provided for @threadAddFavoriteConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get threadAddFavoriteConfirm;

  /// No description provided for @threadAddFavoriteCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get threadAddFavoriteCancel;

  /// No description provided for @spacePageFriends.
  ///
  /// In zh, this message translates to:
  /// **'好友数'**
  String get spacePageFriends;

  /// No description provided for @spacePageFriendsTab.
  ///
  /// In zh, this message translates to:
  /// **'好友'**
  String get spacePageFriendsTab;

  /// No description provided for @spacePageThreads.
  ///
  /// In zh, this message translates to:
  /// **'主题数'**
  String get spacePageThreads;

  /// No description provided for @spacePageThreadsTab.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get spacePageThreadsTab;

  /// No description provided for @spacePagePosts.
  ///
  /// In zh, this message translates to:
  /// **'回复数'**
  String get spacePagePosts;

  /// No description provided for @spacePagePostsTab.
  ///
  /// In zh, this message translates to:
  /// **'回复'**
  String get spacePagePostsTab;

  /// No description provided for @spacePageSign.
  ///
  /// In zh, this message translates to:
  /// **'个人签名'**
  String get spacePageSign;

  /// No description provided for @spacePageMedals.
  ///
  /// In zh, this message translates to:
  /// **'勋章'**
  String get spacePageMedals;

  /// No description provided for @spacePageActivity.
  ///
  /// In zh, this message translates to:
  /// **'活跃概况'**
  String get spacePageActivity;

  /// No description provided for @spacePageActivityGroup.
  ///
  /// In zh, this message translates to:
  /// **'用户组'**
  String get spacePageActivityGroup;

  /// No description provided for @spacePageActivityOnlineTime.
  ///
  /// In zh, this message translates to:
  /// **'在线时间'**
  String get spacePageActivityOnlineTime;

  /// No description provided for @spacePageActivityOnlineTimeUnit.
  ///
  /// In zh, this message translates to:
  /// **'小时'**
  String get spacePageActivityOnlineTimeUnit;

  /// No description provided for @spacePageActivityRegDate.
  ///
  /// In zh, this message translates to:
  /// **'注册时间'**
  String get spacePageActivityRegDate;

  /// No description provided for @spacePageActivityLastVisit.
  ///
  /// In zh, this message translates to:
  /// **'最后访问'**
  String get spacePageActivityLastVisit;

  /// No description provided for @spacePageActivityLastActivity.
  ///
  /// In zh, this message translates to:
  /// **'上次活动'**
  String get spacePageActivityLastActivity;

  /// No description provided for @spacePageActivityLastPost.
  ///
  /// In zh, this message translates to:
  /// **'上次发表'**
  String get spacePageActivityLastPost;

  /// No description provided for @spacePageStatistics.
  ///
  /// In zh, this message translates to:
  /// **'统计信息'**
  String get spacePageStatistics;

  /// No description provided for @spacePageStatisticsAttachSize.
  ///
  /// In zh, this message translates to:
  /// **'已用空间'**
  String get spacePageStatisticsAttachSize;

  /// No description provided for @spacePageStatisticsCredits.
  ///
  /// In zh, this message translates to:
  /// **'积分'**
  String get spacePageStatisticsCredits;

  /// No description provided for @spacePageStatisticsCredits1.
  ///
  /// In zh, this message translates to:
  /// **'体力'**
  String get spacePageStatisticsCredits1;

  /// No description provided for @spacePageStatisticsCredits1Unit.
  ///
  /// In zh, this message translates to:
  /// **'点'**
  String get spacePageStatisticsCredits1Unit;

  /// No description provided for @spacePageStatisticsCredits3.
  ///
  /// In zh, this message translates to:
  /// **'蒸汽'**
  String get spacePageStatisticsCredits3;

  /// No description provided for @spacePageStatisticsCredits3Unit.
  ///
  /// In zh, this message translates to:
  /// **'克'**
  String get spacePageStatisticsCredits3Unit;

  /// No description provided for @spacePageStatisticsCredits4.
  ///
  /// In zh, this message translates to:
  /// **'动力'**
  String get spacePageStatisticsCredits4;

  /// No description provided for @spacePageStatisticsCredits4Unit.
  ///
  /// In zh, this message translates to:
  /// **'点'**
  String get spacePageStatisticsCredits4Unit;

  /// No description provided for @spacePageStatisticsCredits6.
  ///
  /// In zh, this message translates to:
  /// **'积分'**
  String get spacePageStatisticsCredits6;

  /// No description provided for @spacePageStatisticsCredits8.
  ///
  /// In zh, this message translates to:
  /// **'可用改名次数'**
  String get spacePageStatisticsCredits8;

  /// No description provided for @settingsPageCommon.
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsPageCommon;

  /// No description provided for @settingsPageDynamicColorEnabled.
  ///
  /// In zh, this message translates to:
  /// **'使用动态配色'**
  String get settingsPageDynamicColorEnabled;

  /// No description provided for @settingsPageThemeColor.
  ///
  /// In zh, this message translates to:
  /// **'主题颜色'**
  String get settingsPageThemeColor;

  /// No description provided for @settingsPageLog.
  ///
  /// In zh, this message translates to:
  /// **'日志'**
  String get settingsPageLog;

  /// No description provided for @settingsPageAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsPageAbout;

  /// No description provided for @aboutPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get aboutPageTitle;

  /// No description provided for @aboutPageDescription.
  ///
  /// In zh, this message translates to:
  /// **'使用Flutter编写的keylol.com第三方客户端'**
  String get aboutPageDescription;

  /// No description provided for @aboutPageLicense.
  ///
  /// In zh, this message translates to:
  /// **'License'**
  String get aboutPageLicense;

  /// No description provided for @aboutPageGithub.
  ///
  /// In zh, this message translates to:
  /// **'Github'**
  String get aboutPageGithub;

  /// No description provided for @logPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'日志'**
  String get logPageTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
