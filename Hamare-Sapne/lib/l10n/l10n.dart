import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @getStartedPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedPageTitle;

  /// No description provided for @welcomeToSageTurtle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sage Turtle'**
  String get welcomeToSageTurtle;

  /// No description provided for @expertiseHelp.
  ///
  /// In en, this message translates to:
  /// **'Where your expertise helps transform lives. Connect with clients easily and manage your appointments efficiently.'**
  String get expertiseHelp;

  /// No description provided for @manageYourPractice.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Practice'**
  String get manageYourPractice;

  /// No description provided for @intuitiveDashboard.
  ///
  /// In en, this message translates to:
  /// **'Use our intuitive dashboard to schedule sessions, tracks client progress, and manage your appointments with flexibility.'**
  String get intuitiveDashboard;

  /// No description provided for @expandYourReach.
  ///
  /// In en, this message translates to:
  /// **'Expand Your Reach'**
  String get expandYourReach;

  /// No description provided for @largerClientBase.
  ///
  /// In en, this message translates to:
  /// **'Connect with a larger client base. Increase your visibility in the therapy community.'**
  String get largerClientBase;

  /// No description provided for @loginPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sage Turtle'**
  String get loginPageTitle;

  /// No description provided for @loginPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalise your journey by signing up.'**
  String get loginPageSubTitle;

  /// No description provided for @therapistLogin.
  ///
  /// In en, this message translates to:
  /// **'Therapist Login'**
  String get therapistLogin;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @termAndCondition.
  ///
  /// In en, this message translates to:
  /// **'I agree to Sage Turtle\'s terms & conditions and acknowledge the privacy policy'**
  String get termAndCondition;

  /// No description provided for @otpPageTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Page'**
  String get otpPageTitle;

  /// No description provided for @enterTheSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 Digit code sent to'**
  String get enterTheSixDigitCode;

  /// No description provided for @resendOtpIn.
  ///
  /// In en, this message translates to:
  /// **'Resent OTP in'**
  String get resendOtpIn;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePageTitle;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @totalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get totalEarning;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointment'**
  String get upcomingAppointments;

  /// No description provided for @appointmentDetailPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetailPageTitle;

  /// No description provided for @scheduledAppointment.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Appointment'**
  String get scheduledAppointment;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @appointmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Appointment Status'**
  String get appointmentStatus;

  /// No description provided for @paymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Payment Info'**
  String get paymentInfo;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @viewNote.
  ///
  /// In en, this message translates to:
  /// **'View Note'**
  String get viewNote;

  /// No description provided for @locationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a location'**
  String get locationPageTitle;

  /// No description provided for @searchYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Search your location hear'**
  String get searchYourLocation;

  /// No description provided for @deviceLocationNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Device Location Not Enabled'**
  String get deviceLocationNotEnabled;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @notificationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationPageTitle;

  /// No description provided for @messagesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesPageTitle;

  /// No description provided for @goLive.
  ///
  /// In en, this message translates to:
  /// **'Go Live'**
  String get goLive;

  /// No description provided for @liveChatTab.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChatTab;

  /// No description provided for @messageTab.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageTab;

  /// No description provided for @findClient.
  ///
  /// In en, this message translates to:
  /// **'Find Client'**
  String get findClient;

  /// No description provided for @recentChats.
  ///
  /// In en, this message translates to:
  /// **'Recent Chats'**
  String get recentChats;

  /// No description provided for @bookAppointmentPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointmentPageTitle;

  /// No description provided for @bookAppointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookAppointmentDate;

  /// No description provided for @enterDate.
  ///
  /// In en, this message translates to:
  /// **'Enter Date'**
  String get enterDate;

  /// No description provided for @bookAppointmentDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get bookAppointmentDuration;

  /// No description provided for @bookAppointmentMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get bookAppointmentMorning;

  /// No description provided for @bookAppointmentAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get bookAppointmentAfternoon;

  /// No description provided for @bookAppointmentEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get bookAppointmentEvening;

  /// No description provided for @notSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Slot Available'**
  String get notSlotsAvailable;

  /// No description provided for @appointmentType.
  ///
  /// In en, this message translates to:
  /// **'Appointment Type'**
  String get appointmentType;

  /// No description provided for @appointmentTypeInPerson.
  ///
  /// In en, this message translates to:
  /// **'In-Person'**
  String get appointmentTypeInPerson;

  /// No description provided for @appointmentTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get appointmentTypeVideo;

  /// No description provided for @appointmentTypeCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get appointmentTypeCall;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client\'s name'**
  String get clientName;

  /// No description provided for @searchAndSelectClient.
  ///
  /// In en, this message translates to:
  /// **'Search ad select Client'**
  String get searchAndSelectClient;

  /// No description provided for @earningsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsPageTitle;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @earningRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get earningRevenue;

  /// No description provided for @insightsTotalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get insightsTotalEarning;

  /// No description provided for @receivedAmount.
  ///
  /// In en, this message translates to:
  /// **'Received Amount'**
  String get receivedAmount;

  /// No description provided for @dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get dueAmount;

  /// No description provided for @earningAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get earningAppointments;

  /// No description provided for @earningLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get earningLiveChat;

  /// No description provided for @transactionTotalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get transactionTotalEarning;

  /// No description provided for @transactionAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get transactionAppointments;

  /// No description provided for @transactionLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get transactionLiveChat;

  /// No description provided for @transactionBillingHistory.
  ///
  /// In en, this message translates to:
  /// **'Billing History'**
  String get transactionBillingHistory;

  /// No description provided for @transactionSearchPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Search Payment History'**
  String get transactionSearchPaymentHistory;

  /// No description provided for @sessionsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsPageTitle;

  /// No description provided for @sessionMyAppointmentTab.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get sessionMyAppointmentTab;

  /// No description provided for @sessionUpcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get sessionUpcomingTab;

  /// No description provided for @sessionCompletedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sessionCompletedTab;

  /// No description provided for @sessionCancelledTab.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get sessionCancelledTab;

  /// No description provided for @sessionClientTab.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get sessionClientTab;

  /// No description provided for @sessionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sessionSearch;

  /// No description provided for @myAccountPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccountPageTitle;

  /// No description provided for @myAccountProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get myAccountProfile;

  /// No description provided for @myAccountCalender.
  ///
  /// In en, this message translates to:
  /// **'Calender'**
  String get myAccountCalender;

  /// No description provided for @myAccountConsultationPricing.
  ///
  /// In en, this message translates to:
  /// **'Consultation Pricing'**
  String get myAccountConsultationPricing;

  /// No description provided for @myAccountNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get myAccountNotification;

  /// No description provided for @myAccountPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get myAccountPrivacyPolicy;

  /// No description provided for @myAccountTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get myAccountTermsAndConditions;

  /// No description provided for @myAccountLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get myAccountLogout;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// No description provided for @personalInfoTab.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfoTab;

  /// No description provided for @expertiseTab.
  ///
  /// In en, this message translates to:
  /// **'Expertise'**
  String get expertiseTab;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @calendarPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Calender'**
  String get calendarPageTitle;

  /// No description provided for @calendarMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get calendarMonday;

  /// No description provided for @calendarTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get calendarTuesday;

  /// No description provided for @calendarWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get calendarWednesday;

  /// No description provided for @calendarThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get calendarThursday;

  /// No description provided for @calendarFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get calendarFriday;

  /// No description provided for @calendarSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get calendarSaturday;

  /// No description provided for @calendarSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get calendarSunday;

  /// No description provided for @noTimeSlotsFound.
  ///
  /// In en, this message translates to:
  /// **'No Time Slots Found'**
  String get noTimeSlotsFound;

  /// No description provided for @consultationPricingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation Pricing'**
  String get consultationPricingPageTitle;

  /// No description provided for @mins30.
  ///
  /// In en, this message translates to:
  /// **'30 Mins'**
  String get mins30;

  /// No description provided for @mins45.
  ///
  /// In en, this message translates to:
  /// **'45 Mins'**
  String get mins45;

  /// No description provided for @mins60.
  ///
  /// In en, this message translates to:
  /// **'60 Mins'**
  String get mins60;

  /// No description provided for @notificationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPageTitle;

  /// No description provided for @appointmentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Appointment Alerts'**
  String get appointmentAlerts;

  /// No description provided for @notifiesAboutNewAppointments.
  ///
  /// In en, this message translates to:
  /// **'Notifies about new appointments, any rescheduling, or cancellations by clients.'**
  String get notifiesAboutNewAppointments;

  /// No description provided for @progressAlerts.
  ///
  /// In en, this message translates to:
  /// **'Progress Alerts'**
  String get progressAlerts;

  /// No description provided for @updatesOnClientCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Updates on clients check-ins, goal achievements, or other significant changes in their therapy progress'**
  String get updatesOnClientCheckIn;

  /// No description provided for @administrativeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Administrative Notifications'**
  String get administrativeNotifications;

  /// No description provided for @importantUpdatesAboutChanges.
  ///
  /// In en, this message translates to:
  /// **'Important updates about changes in app policy, privacy updates, or new features available i the app.'**
  String get importantUpdatesAboutChanges;

  /// No description provided for @consultationRequests.
  ///
  /// In en, this message translates to:
  /// **'Consultation Requests'**
  String get consultationRequests;

  /// No description provided for @alertWhenTheyReceive.
  ///
  /// In en, this message translates to:
  /// **'Alert when they receive new consultation requests form potential clients'**
  String get alertWhenTheyReceive;

  /// No description provided for @privacyPolicyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyPageTitle;

  /// No description provided for @privacyPolicyIntroduction.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacyPolicyIntroduction;

  /// No description provided for @thisMobileApplication.
  ///
  /// In en, this message translates to:
  /// **'1. This mobile application / website is owned, operated and made available by Enso Innovation Lab Pvt. Ltd. (“Company”, “we” or “us” or “our”), and includes our successors-in-interest and assignees as determined by us, at our sole discretion and without requiring any prior notice or intimation to You. “user”, “you”, “your” or other similar terminology are all in reference to you as the user of the Platform as a recipient of our products, Services and resources for the remainder of this document.'**
  String get thisMobileApplication;

  /// No description provided for @thisPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'2. This privacy policy (“Privacy Policy”) together with the terms and for the use of the Platform, available at Terms and Conditions (the “Terms”), outlines the Platform\'s privacy practices regarding the collection, use and safeguard of your information through use of the Platform and the Services offered thereupon.'**
  String get thisPrivacyPolicy;

  /// No description provided for @atEnsoInnovation.
  ///
  /// In en, this message translates to:
  /// **'3. At Enso Innovation Lab, we are committed to respecting the privacy and confidentiality of the information that you entrust us with. Our Privacy Policy outlines the policies and procedures regarding the collection, use and disclosure of Personal Information from users. Please review this Privacy Policy carefully. In order to guarantee privacy to the client, we maintain the client’s anonymity and work in accordance with confidentiality policies to ensure that all personal and health information received is maintained and transmitted through a highly secure environment. It is recommended that you do not use the website, mobile application(s) or the related Services if any of the terms of this Privacy Policy are not in accordance with the applicable laws of your country.'**
  String get atEnsoInnovation;

  /// No description provided for @privacyPolicyNatureOfService.
  ///
  /// In en, this message translates to:
  /// **'2. Nature of service'**
  String get privacyPolicyNatureOfService;

  /// No description provided for @ensoInnovationLab.
  ///
  /// In en, this message translates to:
  /// **'1. Enso Innovation Lab is an online wellness platform that delivers \n(a) emotional wellness services to individuals and organisations through certified psychologists and/or therapists and \n(b) psychiatric consultation services by psychiatrists, connecting users to such Wellness Professionals (“Platform”). The services include, but are not restricted to, corporate wellness programs through which employees of organisations avail various products and Services. Enso Innovation Lab offerings may include/are:'**
  String get ensoInnovationLab;

  /// No description provided for @onlineFaceToFaceProfessionals.
  ///
  /// In en, this message translates to:
  /// **'* Online, face-to-face and online chat based consultation with expert Wellness Professionals (who have been authorised by Enso Innovation Lab to use the Platform for delivering their Services)'**
  String get onlineFaceToFaceProfessionals;

  /// No description provided for @onlineFaceToFacePsychiatrists.
  ///
  /// In en, this message translates to:
  /// **'* Online, face-to-face and online chat based consultation and diagnostic services by psychiatrists on the Platform which may include the prescription of medication or such other treatment if determined necessary by the psychiatrist'**
  String get onlineFaceToFacePsychiatrists;

  /// No description provided for @periodicSelfAssessments.
  ///
  /// In en, this message translates to:
  /// **'Periodic self-assessments and psychological tests'**
  String get periodicSelfAssessments;

  /// No description provided for @workshopsAndWebinars.
  ///
  /// In en, this message translates to:
  /// **'* Workshops and/or webinars delivered by trained Wellness Professionals\''**
  String get workshopsAndWebinars;

  /// No description provided for @selfHelpTools.
  ///
  /// In en, this message translates to:
  /// **'* Self-help tools, content and programs through a range of channels including, but not restricted to websites, mobile applications and emails'**
  String get selfHelpTools;

  /// No description provided for @guideChatPacks.
  ///
  /// In en, this message translates to:
  /// **'* Guide chat packs where in clients may be able to exchange encrypted private messages with their Wellness Professional in addition to online consultation.'**
  String get guideChatPacks;

  /// No description provided for @collectivelyReferred.
  ///
  /// In en, this message translates to:
  /// **'* collectively referred to as the “Services”.'**
  String get collectivelyReferred;

  /// No description provided for @privacyPolicyConsent.
  ///
  /// In en, this message translates to:
  /// **'3. Consent'**
  String get privacyPolicyConsent;

  /// No description provided for @byUsingThePlatForm.
  ///
  /// In en, this message translates to:
  /// **'1. By using the Platform, providing us your Personal Information or by making use of the features provided by the platform or by making a payment to Enso Innovation Lab, you hereby provide your consent to \n(a) the use of the Services and \n(b) the collection, storage, processing, disclosure and transfer of your Personal Information in accordance with the provisions of this Privacy Policy.'**
  String get byUsingThePlatForm;

  /// No description provided for @youAcknowledgeThatYou.
  ///
  /// In en, this message translates to:
  /// **'2. You acknowledge that you are providing your Personal Information out of your free will, either directly to Enso Innovation Lab or through a third-party or your organisation. You have the option to not provide us the Personal Information sought to be collected. You will also have an option to withdraw your consent at any point, provided such withdrawal of consent is intimated to us in writing to support@ensolab.in Notwithstanding this, if you are accessing the Platform through a third-party or your organisation, you will have an option to withdraw your consent at any point, provided you explicitly inform the third party or your organisation about such withdrawal of consent in writing, who would then inform us to take the appropriate action.'**
  String get youAcknowledgeThatYou;

  /// No description provided for @ifYouDoNotProvide.
  ///
  /// In en, this message translates to:
  /// **'3. If you do not provide us with your Personal Information or if you withdraw the consent at any point in time, we shall have the option to not fulfill the purposes for which the said Personal Information was sought and we may restrict your use of the Platform.'**
  String get ifYouDoNotProvide;

  /// No description provided for @privacyPolicyPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'4. Personal Information'**
  String get privacyPolicyPersonalInformation;

  /// No description provided for @toEnableYouToEngage.
  ///
  /// In en, this message translates to:
  /// **'1. To enable you to engage with our Services, we will use personal information about yourself - provided directly to us or to a third party or your organisation - to contact or identify you, such as your name, phone number, emergency contact number, gender, occupation, hometown, personal interests, your email address, reason(s) for cancelling an appointment with a healthcare professional, medical history and any other information that the Wellness Professional might require from you. We also collect information you provide from responses, in-app inputs, assessments or the feedback you send to us. If you communicate with us by email or phone, any information provided in such communication may be collected as personal information (“Personal Information”).'**
  String get toEnableYouToEngage;

  /// No description provided for @theMainReasonWeCollect.
  ///
  /// In en, this message translates to:
  /// **'2. The main reason we collect this Personal Information is to provide you a smooth, efficient and customised experience. The collection of Personal Information also enables the user to create an account and profile that can be used to interact with our wellness professionals. You may change some of the information that you provide through your account page at the website or profile details for the mobile application(s).'**
  String get theMainReasonWeCollect;

  /// No description provided for @weMayUseYourPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'3. We may use your Personal Information to: \n*Identify and reach you, \n*Resolve service and billing problems via telephone or email. \n*Assist you in scheduling appointments, remind you of upcoming or follow-up appointments, as well as cancelled appointments. \n*Generate prescriptions as issued by the psychiatrist engaged by you on the Platform \n*Provide you with further information, products and services and newsletters. \n*Better understand users’ needs and interests. \n*Personalise your experience. \n*Run statistical research (such research will only use your information in an anonymous way and cannot be linked back to you) \n*Detect and protect us against error, fraud, and other criminal activity. \n*Make disclosures as may be required under applicable law. \n*Improve our website, mobile application(s) in order to better serve you. \n*Allow us to better service you in responding to your customer service requests. \n*Run a contest, promotion, survey or other site, mobile application feature. \nQuickly process your transactions.'**
  String get weMayUseYourPersonalInfo;

  /// No description provided for @yourInformationIsUsedBy.
  ///
  /// In en, this message translates to:
  /// **'4. Your information is used by the Wellness Professionals and our app algorithms to better assess your condition and provide you with the most suitable counselling service, consultation, medical diagnosis and treatment service or digital experience. Your Personal Information is held safe by the Wellness Professional working with you and not normally shared with other Wellness Professionals. However, in certain situations, in furtherance of the Services, Wellness Professionals may discuss and share information provided by you in a strictly anonymized manner, with other Wellness Professionals and/or other personnel of the Company. Further, there may be certain occasions when Enso Innovation Lab and/or Wellness Professionals use third-party tools to tailor the counselling sessions, consultation, medical diagnosis and treatment services and in-app experience. In both such cases, only minimal information as required is shared with others.'**
  String get yourInformationIsUsedBy;

  /// No description provided for @weAreDedicatedToMaintaining.
  ///
  /// In en, this message translates to:
  /// **'5. We are dedicated to maintaining the privacy and integrity of your Personal Information. If you decide at any time that you no longer wish to receive certain communications from us, you can inform us by writing to support@ensolab.in'**
  String get weAreDedicatedToMaintaining;

  /// No description provided for @ensoInnovationLabShall.
  ///
  /// In en, this message translates to:
  /// **'6. Enso Innovation Lab shall, subject to the Terms and this Privacy Policy, undertake best efforts to ensure that all communication between the user and Enso Innovation Lab and / or the Wellness Professional within the ambit of Services, are kept confidential, to the extent required under compliance with applicable laws and any applicable guidelines of professional practice applicable to the relevant Wellness Professional.'**
  String get ensoInnovationLabShall;

  /// No description provided for @privacyPolicyUpdatingPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'5. Updating Personal Information'**
  String get privacyPolicyUpdatingPersonalInformation;

  /// No description provided for @ifYourPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'1. If your Personal Information changes, or if you need to update or correct your Personal Information or have any grievance with respect to the processing or use of your Personal Information, for any reason, you may send updates and corrections to us at support@ensolab.in and we will take all reasonable efforts to incorporate the changes within a reasonable period of time. If you provide your Personal Information to a third-party platform from which you are using our Services, Enso Innovation Lab may not be able to make any changes to the same and you will have to contact the third-party platform in order to update your Personal Information. \n2. If your Personal Information is stored as part of your profile on the Platform, you can update your Personal Information from our website or mobile application(s). You agree that the Company will not be responsible for any failure of the user to update its Personal Information. \n3. Some Personal Information, such as your answers to online assessments cannot be updated or deleted once submitted. If you would like us to remove your records from our system, please contact us at support@ensolab.in and we will attempt to accommodate your request if we do not have any legal obligation to retain such information. \n4. Please note that we are required to retain certain information in keeping with professional standards or by law for record maintaining purposes (including but not limited to payment history, feedback, client information, etc.), so we will continue to store this information for a pre-specified period of time as per applicable laws, even if you delete your account. There may also be residual information that will remain within our databases and other records, which, irrespective of any efforts by us to delete information, will not be removed from them.'**
  String get ifYourPersonalInformation;

  /// No description provided for @privacyPolicyCookies.
  ///
  /// In en, this message translates to:
  /// **'6. Cookies'**
  String get privacyPolicyCookies;

  /// No description provided for @weUseCookiesToCollectInformation.
  ///
  /// In en, this message translates to:
  /// **'1. We use “cookies” to collect information and smoothen your experience on the Platform. A cookie is a small data file that we transfer to your device’s hard disk for record-keeping purposes. We use cookies for two purposes. First, we may utilise persistent cookies to save your user credentials for future logins to the Services. Second, we may utilise session ID cookies to enable certain features of the Services, to better understand how you interact with the Services and to monitor aggregate usage by users of the Services and online traffic routing on the Services. Unlike persistent cookies, session cookies are deleted from your computer when you log off from the Services and then close your browser. \n2. We may work with third parties that place or read cookies on your browser to improve your user experience. In such cases, by using the third party services through the Platform, you consent to their Privacy Policy and terms of use and agree not to hold Enso Innovation Lab liable for any issues arising from such use. \n3. You can instruct your browser, by changing its options, to stop accepting cookies or to prompt you before accepting a cookie from the websites you visit. If you do not accept cookies, however, you may not be able to use all features or functionalities of the Platform.'**
  String get weUseCookiesToCollectInformation;

  /// No description provided for @privacyPolicyLogData.
  ///
  /// In en, this message translates to:
  /// **'7. Log Data'**
  String get privacyPolicyLogData;

  /// No description provided for @whenYouVisitThePlatform.
  ///
  /// In en, this message translates to:
  /// **'When you visit the Platform, our servers automatically record information that your browser or mobile application sends (“Log Data”). This Log Data may include information such as your computer’s Internet Protocol (“IP”) address, browser type, device name, operating system version, configuration of the app when accessing the Platform, the webpage you were visiting before you came to our Services, pages of the Platform and Services that you visit, the time spent on those pages, information you search for on our Services, access times and dates, and other statistics. We use this information to analyse trends, administer the site, track your location, gather broad demographic information for aggregate use, increase user-friendliness and tailor our Services to better suit your needs.'**
  String get whenYouVisitThePlatform;

  /// No description provided for @privacyPolicyConfidentiality.
  ///
  /// In en, this message translates to:
  /// **'8. Confidentiality'**
  String get privacyPolicyConfidentiality;

  /// No description provided for @ensoInnovationLabMaintains.
  ///
  /// In en, this message translates to:
  /// **'1. Enso Innovation Lab maintains the confidentiality of information disclosed during personal consultation. Any information shared with Enso Innovation Lab is confidential and not shared with anyone, including your organization, with certain exceptions where confidentiality may be breached. The case where confidentiality will be breached is if: \n*The Wellness Professional or Enso Innovation Lab perceives there to be a serious and/or significant and/or imminent risk of harm to the health or safety of another living being or the public or self. \n*disclosure is required by law. \n*you file a private healthcare claim and the insurer requires information. \n2. Except for the reasons outlined above, the Personal Information shared on Enso Innovation Lab will only be shared with others after permission has been granted by you orally or by way of email/letter/fax. All staff members of Enso Innovation Lab, including all Enso Innovation Lab professionals, employees, contracted professionals or trainees, are required to follow this confidentiality policy.'**
  String get ensoInnovationLabMaintains;

  /// No description provided for @privacyPolicyPartyDisclosure.
  ///
  /// In en, this message translates to:
  /// **'9. Party Disclosure'**
  String get privacyPolicyPartyDisclosure;

  /// No description provided for @ensoInnovationLabDoesNotSell.
  ///
  /// In en, this message translates to:
  /// **'Enso Innovation Lab does not sell or trade your Personal Information to third parties unless we provide you with advance notice. This however does not apply to any storage or transfer to and from server/website hosting partners and other parties who assist us in operating the Platform, conducting our business, or servicing you. We may also release your information when we believe release is appropriate to comply with the law, enforce our site policies, mobile application policies, or protect ours or others’ rights, property, or safety. However, visitor information that is not personally identifiable may be provided to other parties for marketing, advertising, or other uses.'**
  String get ensoInnovationLabDoesNotSell;

  /// No description provided for @privacyPolicySecurity.
  ///
  /// In en, this message translates to:
  /// **'10. Security'**
  String get privacyPolicySecurity;

  /// No description provided for @weEmployAdministrative.
  ///
  /// In en, this message translates to:
  /// **'1. We employ administrative, physical, and technical measures designed to safeguard and protect information under our control from unauthorised access, use, and disclosure. When we collect, maintain, access, use, or disclose your Personal Information, we will do so using systems and processes consistent with industry standards in information privacy and security. In keeping with professional standards, Wellness Professionals might be required to maintain records of both online and offline sessions. \n2. In spite of the security measures undertaken by us, we strongly discourage you from posting your personally identifiable information in forums, comments or any other publicly accessible places on the Platform. Enso Innovation Lab shall not be held responsible for use or misuse of any information pertaining to or shared by the User with relation to its Services. The User will not hold Enso Innovation Lab liable for any issue related to data storage and/or security. \n3. It is your responsibility to ensure the privacy and security of your email account and phone messages so they cannot be accessed by third-party. Enso Innovation Lab will use one or both of these channels to communicate with you regarding a range of information related to your psychological wellness. Enso Innovation Lab shall not be liable for any breach in confidentiality, should your email or text messages be accessed by a third-party, with or without your consent. \n4. By using the Application, You accept the inherent security implications of data transmission over the internet. Therefore, the use of the Application will be at Your own risk and we assume no liability for any disclosure of information due to errors in transmission, unauthorised third party access or other acts of third-parties or acts or omissions beyond our reasonable control and You agree not to hold us responsible for any breach of security. \n5. In the event we become aware of any breach of the security of Your information, we will promptly notify You and take appropriate action to the best of our ability to remedy such a breach.'**
  String get weEmployAdministrative;

  /// No description provided for @privacyPolicyChangesToPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'11. Changes to Privacy Policy'**
  String get privacyPolicyChangesToPrivacyPolicy;

  /// No description provided for @weAreObligatedToProtectYourInformation.
  ///
  /// In en, this message translates to:
  /// **'1. We are obligated to protect Your information in accordance with applicable laws, and regulations. \n2. This Privacy Policy is subject to modification based on changes in the business, legal and regulatory requirements and will be updated online. We will make all efforts to communicate any significant changes to this Privacy Policy to You. You are encouraged to periodically visit this page to review the Privacy Policy and any changes to it. Your continued use of the Application or the Services thereunder following the posting of any amendment to this Privacy Policy shall constitute Your acceptance of such amendment.'**
  String get weAreObligatedToProtectYourInformation;

  /// No description provided for @privacyPolicyGrievanceRedressal.
  ///
  /// In en, this message translates to:
  /// **'12. Grievance Redressal'**
  String get privacyPolicyGrievanceRedressal;

  /// No description provided for @ifYouHaveAnyGrievance.
  ///
  /// In en, this message translates to:
  /// **'1.If you have any grievance with respect to the Platform or Services, including any discrepancies and grievances with respect to processing of information, you can contact our Grievance Officer at: support@ensolab.in \n2. The Grievance Officer shall redress your grievances in a time bound manner not exceeding 1 (one) month from the date of receipt of grievance. Except where required by law, the Company cannot ensure a response to questions or comments regarding topics unrelated to this policy or the Company\'s privacy practices.'**
  String get ifYouHaveAnyGrievance;

  /// No description provided for @termsAndConditionsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsPageTitle;

  /// No description provided for @termIntroduction.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get termIntroduction;

  /// No description provided for @thisMobileApplicationWebsiteIsOwned.
  ///
  /// In en, this message translates to:
  /// **'1. This mobile application / website is owned, operated and made available by Enso Lab Innovation Pvt. Ltd. (“Company”, “we” or “us” or “our”), and includes our successors-in-interest and assignees as determined by us, at our sole discretion and without requiring any prior notice or intimation to You. “user”, “you”, “your” or other similar terminology are all in reference to you as the user of the Platform as a recipient of our products, Services and resources for the remainder of this document.\n'**
  String get thisMobileApplicationWebsiteIsOwned;

  /// No description provided for @pleaseReadTheseTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'2. Please read these Terms and Conditions (“Terms”), along with the Privacy Policy available at [Privacy Policy] and all other rules and policies made available or published on the Application as they shall govern Your use of the Application and the services provided thereunder.\n'**
  String get pleaseReadTheseTermsAndConditions;

  /// No description provided for @yourUseOfTheService.
  ///
  /// In en, this message translates to:
  /// **'3. Your use of the Services is subject to these terms and conditions contained herein.\n'**
  String get yourUseOfTheService;

  /// No description provided for @theseTermsAndConditionsAreAnElectronic.
  ///
  /// In en, this message translates to:
  /// **'4. These Terms and Conditions are an electronic record as per the Information Technology Act, 2000 (as amended / re-enacted) and the rules made thereunder (“IT Act”) and is published in accordance with the provisions of Rule 3 (1) of the Information Technology (Intermediaries Guidelines) Rules, 2011, which mandates publishing of rules and regulations, privacy policy and terms and conditions for access or usage of any application. This electronic record is generated by a computer system.\n'**
  String get theseTermsAndConditionsAreAnElectronic;

  /// No description provided for @termAcceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'2. Acceptance of Terms'**
  String get termAcceptanceOfTerms;

  /// No description provided for @byDownloadingAndByRegistering.
  ///
  /// In en, this message translates to:
  /// **'1. By downloading and/or by registering or signing up for these Services, or otherwise having access to, receiving, and/or using the Application, you acknowledge that You have read, understood and consented to be governed and bound by these Terms and Conditions and the Privacy Policy. If You do not accept or agree to any part of these Terms and Conditions or the Privacy Policy, your usage of the Services will be terminated.\n'**
  String get byDownloadingAndByRegistering;

  /// No description provided for @weReserveTheRightTo.
  ///
  /// In en, this message translates to:
  /// **'2. We reserve the right to (i) accept or reject the request of the user(s) to create an account, (ii) terminate the account of registered User(s) for unauthorized use, or (iii) refuse the Services offered through this digital Platform due to non-availability of Services.\n'**
  String get weReserveTheRightTo;

  /// No description provided for @termNatureOfService.
  ///
  /// In en, this message translates to:
  /// **'3. Nature of Service'**
  String get termNatureOfService;

  /// No description provided for @ensoInnovationLabIsAWellness.
  ///
  /// In en, this message translates to:
  /// **'1. Enso Innovation lab is a wellness platform that delivers (a) emotional wellness services to individuals and organisations through certified psychologists and/or therapists and (b) psychiatric consultation services by psychiatrists, connecting users to such Wellness Professionals. The services include, but are not restricted to, corporate wellness programs through which employees of organisations avail various products and Services. The offerings may include/are:'**
  String get ensoInnovationLabIsAWellness;

  /// No description provided for @onlineFaceToFaceAndOnlineChatWellness.
  ///
  /// In en, this message translates to:
  /// **'* Online, face-to-face and online chat based consultation with expert Wellness Professionals (who have been authorised by Enso Innovation Lab to use the Platform for delivering their Services)'**
  String get onlineFaceToFaceAndOnlineChatWellness;

  /// No description provided for @onlineFaceToFaceAndOnlineChatDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'* Online, face-to-face and online chat based consultation and diagnostic services by psychiatrists on the Platform which may include the prescription of medication or such other treatment if determined necessary by the psychiatrist;'**
  String get onlineFaceToFaceAndOnlineChatDiagnostic;

  /// No description provided for @periodicSelfAssessmentsAnd.
  ///
  /// In en, this message translates to:
  /// **'* Periodic self-assessments and psychological tests'**
  String get periodicSelfAssessmentsAnd;

  /// No description provided for @workshopsAndWebinarsDelivered.
  ///
  /// In en, this message translates to:
  /// **'* Workshops and/or webinars delivered by trained Wellness Professionals'**
  String get workshopsAndWebinarsDelivered;

  /// No description provided for @selfHelpToolsContentAndProgrammes.
  ///
  /// In en, this message translates to:
  /// **'* Self-help tools, content and programmes through a range of channels including, but not restricted to websites, mobile applications and emails'**
  String get selfHelpToolsContentAndProgrammes;

  /// No description provided for @guideChatPacsWhereInClients.
  ///
  /// In en, this message translates to:
  /// **'* Guide chat packs where in clients may be able to exchange encrypted private messages with their Wellness Professional in addition to online consultation.'**
  String get guideChatPacsWhereInClients;

  /// No description provided for @collectivelyReferredToUs.
  ///
  /// In en, this message translates to:
  /// **'Collectively referred to as the “Services”. \n\t\t\t\t\t“Wellness Professional”, shall for the purposes of these Terms mean (a) a trained and certified psychologist, (b) therapist or (c) psychiatrist that is a registered medical practitioner.'**
  String get collectivelyReferredToUs;

  /// No description provided for @youAgreeAndAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'2. You agree and acknowledge that Enso Innovation Lab acts solely as an intermediary between you and the Wellness Professional, transmitting the details of your booking to you and to the Wellness Professional. \n3. Enso Innovation Lab reserves the right to add or remove products and Services from its overall offerings without prior notification.'**
  String get youAgreeAndAcknowledge;

  /// No description provided for @termOccurrenceOfEmergencyEvents.
  ///
  /// In en, this message translates to:
  /// **'4. Occurrence of Emergency Events'**
  String get termOccurrenceOfEmergencyEvents;

  /// No description provided for @youAcknowledgeThatEnso.
  ///
  /// In en, this message translates to:
  /// **'1. You acknowledge that Enso Innovation Lab is not obligated to deal with medical or psychological emergencies. In such cases, you are recommended to obtain in-person medical intervention is the most appropriate form of help. \n2. If you feel you are experiencing any of these difficulties, or if you are considering or contemplating suicide or feel that you are a danger to yourself or to others, we would urge you to seek help at the nearest hospital or emergency room where you can connect with a psychiatrist, social worker, counsellor or therapist in person. The same applies in-case of any medical or psychological health emergency. We recommend you to involve a close family member or a friend who can offer support. \n3. The Platform and the Services are for non-emergency purposes only. Do not attempt to access emergency care through the Platform. \n4. The Services are not intended to support or carry emergency or time-critical calls or communications to any type of hospital, law enforcement agency, medical care unit, or any other kind of emergency or time-critical service. \n5. The Company is not and shall not be treated as an emergency care provider at any point in time. In the event of an emergency, the Company shall not, and will not be obligated to provide any emergency services, including any medication, ambulance services, medical advice, etc. If Company becomes aware of or contemplates an emergency, Company may, at its sole discretion, (a) inform the emergency contact (as identified by you) of the occurrence, or possibility of occurrence of such emergency, and/or (b) intimate your healthcare provider (as identified by you) of the occurrence, or possibility of occurrence of such emergency and/or (c) any other third party as the Company may deem necessary to contact which may include but not be limited to a user’s family members, ambulance service, hospital or any other health service provider.\n'**
  String get youAcknowledgeThatEnso;

  /// No description provided for @termDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'5. Disclaimer'**
  String get termDisclaimer;

  /// No description provided for @ensoInnovationLabDoesNotGuarantee.
  ///
  /// In en, this message translates to:
  /// **'1. Enso Innovation Lab does not guarantee that you will be accepted as a registered user at Enso Innovation Lab, or as a client by a Wellness Professionals on our Platform. It is clarified that a registered user shall mean any user that has registered on the Platform to avail the Services and/or products available on the Platform. \n2. Enso Innovation Lab is a platform that connects the user and the Wellness Professional. The Services is dependent on the information provided by the user to the Wellness Professional and Enso Innovation Lab does not promise any outcomes based on counselling, therapy or the psychiatry services. \n3. Enso Innovation Lab does not guarantee the availability of the same Wellness Professional over any period of time. From the moment at which you book your appointment, Enso Innovation Lab acts solely as an intermediary between you and the Wellness Professional, transmitting the details of your booking to you and to the Wellness Professional. \n4. Counselling or consultations will take place at a frequency agreed between you and your Wellness Professional. We cannot guarantee that sessions will always take place with a particular frequency or on the same day of the week but will make every effort to meet your requirements. \n5. The Wellness Professional might determine that online counselling or consultations are not appropriate for some or all of your treatment needs and accordingly may elect to not provide such counselling or consultation to you and/or may suggest alternative steps to be taken by you. Similarly, the Wellness Professional shall be at the liberty to decide that additional help is needed for the user and shall choose to bring in an additional Wellness Professional. \n6. While Enso Innovation Lab makes all efforts to verify the credentials of every Wellness Professional registered with it, you understand that Enso Innovation Lab is only an intermediary that connects you with a Wellness Professional and Enso Innovation Lab is not responsible for any misrepresentation/fraudulent credentials or claims by a Wellness Professional. \n7. Enso Innovation Lab does not assume any responsibility for the actions, advice or any other information provided by a Wellness Professional through the Platform or otherwise. Enso Innovation Lab shall not be held liable for any damage/ loss/ liability caused to the user by a Wellness Professional, either directly or indirectly. \n8. Enso Innovation Lab does not assume any responsibility for any medication prescribed by a Wellness Professional or the outcome or side effects on the user as a result of consumption of such medication. \n9. Enso Innovation Lab does not assume any responsibility for any medication prescribed by a Wellness Professional or the outcome or side effects on the user as a result of consumption of such med Enso Innovation Lab does not endorse or influence control over any particular branch of medicine, theory, opinion, viewpoint or position on any topic. No warranty, guarantee, or conditions of any kind are created or offered on information or advice or suggestion, whether expressed and/ or implied, in oral and/ or written via any communication medium, obtained by you from Enso Innovation Lab or through any service and/ or resource and/ or information that Enso Innovation Lab provides, except for those expressly outlined in these Terms.ication. \n10. The Services, including content, on both the Enso Innovation Lab Platform and third-party platforms, are provided for general information only and should not be relied upon or used as the sole basis for making decisions without consulting primary, more accurate, more complete or timelier sources of information. We are not responsible if information made available on the Enso Innovation Lab and third-party platforms is not accurate, complete or current and any reliance on the Services, including content, on the Enso Innovation Lab and third-party platforms is at your own risk. \n11. This Platform may contain certain information or content which has undergone change since the time it was published. You understand that information or content on the Platform may not necessarily be current and may be updated, and you understand that we will not be liable for any delay in updating or changing such information and/or content. We reserve the right to modify the contents of this Platform at any time, but we have no obligation to update any information on our Platform. You agree that it is your responsibility to monitor changes to our Platform. The content that the user downloads or otherwise obtains through the use of our Services and/ or resources and/ or information is done at their own discretion and risk, and the user is solely responsible for any damage to their computer or other devices for any loss of data or information that may result from the download of such content. \n12. We reserve the right to modify or terminate any portion of the Platform or the Services offered by the Company for any reason, without notice and without liability to the user or any third-party. \n13. The Company does not warrant that the functions contained in content, information and materials on the Platform and / or Services, including, without limitation any third-party sites or Services linked to the Platform and / or Services will be uninterrupted, timely or error-free, that the defects will be rectified, or that the Platform or the servers that make such content, information and materials available are free of viruses or other harmful components. \n14. We will endeavour to make sure all information is delivered in an accurate and correct manner. However, any material downloaded or otherwise obtained through the Platform and / or Services are accessed at your own risk, and you will be solely responsible for any damage or loss of data that results from such download to your computer system. \n15. At Enso Innovation Lab, we believe it is unethical for our counsellors to have dual relationships with current or former clients. You agree and acknowledge that until such time as you cease to be a registered user of the Platform, you will not contact a Wellness Professional through any medium except through the Platform.\n'**
  String get ensoInnovationLabDoesNotGuarantee;

  /// No description provided for @termTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'6. Terms of Use'**
  String get termTermsOfUse;

  /// No description provided for @duringTheCourseOfYour.
  ///
  /// In en, this message translates to:
  /// **'During the course of your use of the Platform and/or Services, it is expressly stated, understood and agreed by you (user) that you (user) shall abide by the following terms of use. \n* You represent and warrant that you are 18 years of age or older, not otherwise incompetent to contract under the Indian Contract Act, 1872 and that your use of the Platform shall not violate any applicable law or regulation; \n* You represent, warrant and covenant that all registration information you submit - either to us directly or through your organisation - is truthful and accurate and that you agree to maintain the accuracy of such information; \n* Your use of the Platform is solely for your personal and non-commercial use. Any use of this Platform or its content other than for personal purposes is prohibited. \n* Your personal and non-commercial use of this Platform shall be subjected to the following restrictions: \n* You shall not modify any content of the Platform; \n* You shall not decompile, reverse engineer, or disassemble the content; \n* You shall not delete or modify any content of the Platform and / or Services, including but not limited to, legal notices, disclaimers or proprietary notices such as copyright or trademark symbols, logos, that you do not own or have express permission to modify; \n* You shall not use the Platform and / or Services in any way that is unlawful, or harms the Company, the or any other person or entity, as determined in the Company’s sole discretion. \n* You shall not reproduce, duplicate, copy, sell, resell or exploit any portion of the Services, use of the Services, or access to the Services or any contents on the Platform through which the Service is provided, without express written permission by Enso Innovation Lab. \n* You shall not post, submit, upload, distribute, or otherwise transmit or make available any software or other computer files that contain a virus or other harmful component, or otherwise impair or damage the Platform and / or Services or any connected network, or otherwise interfere with any person or entity’s use of the Platform and / or the Services. \n* You acknowledge that when you access a link that leaves the Platform, the site you enter into is not controlled by the Company and different terms of use and privacy policies may apply. By accessing links to other sites, you acknowledge that the Company is not responsible for those sites. The Company reserves the right to disable links from third-party sites to the Platform, although the Company is under no obligation to do so. \n* You take responsibility to check the technical specifications required (including but not limited to a stable internet connection, a working videocam and a working speaker to enable you to hear the communication from the Wellness Professional) before making a booking for a session or before availing any of the other digital offerings. \n* You may not host, display, upload, modify, publish, transmit, update or share any information that: \n* belongs to another person and to which you do not have any right to; \n* deceives or misleads the addressee about the origin of such messages or communicates any information which is grossly offensive or menacing in nature; and \n* threatens the unity, integrity, defense, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting any other nation.\n'**
  String get duringTheCourseOfYour;

  /// No description provided for @termIntellectualPropertyAndContent.
  ///
  /// In en, this message translates to:
  /// **'7. Intellectual Property & Content'**
  String get termIntellectualPropertyAndContent;

  /// No description provided for @theCompanyIsTheSoleOwner.
  ///
  /// In en, this message translates to:
  /// **'1. The Company is the sole owner or lawful licensee of all the rights of the Platform its content. For the purpose of this clause, the content on the Platform includes its design, layout, text, images, graphics, sound, video, etc. as well as non-superficially visual functional elements. The title, ownership and intellectual property rights in the Platform and its content shall remain with the Company, its affiliates or licensors of the content, as the case may be. \n2. Trademark: ‘Enso Innovation Lab’ and related icons and logos are registered trademarks or trademarks pending registration in the name of the Company in various jurisdictions and the same is protected under applicable trademark and other intellectual property laws. The unauthorized copying, modification, use or publication of these marks is strictly prohibited and shall be subject to appropriate legal proceedings against the unauthorized user. \n3. Copyright: All content on the Platform is the copyright of the Company except the third-party content and links to third party websites on the Platform, if any. \n4. You agree and acknowledge that copying any content published by us on the Platform for any commercial purpose or for the purpose of earning profit will be a violation of the Company’s intellectual property rights and will be deemed a breach of these Terms. \n5. The information, content and material on the Platform and/or Service is provided on an “as is” and “as available” basis. The Company and all its subsidiaries, affiliates, officers, employees, agents and partners, if any, disclaim all warranties of any kind, either express or implied, including but not limited to, implied warranties on merchantability, fitness for a particular purpose and non-infringement; \n6. The content and material on the Platform are not medical advice and do not constitute an opinion, medical advice, or diagnosis or treatment of any particular condition \n7. The Company does not warrant that (i) the functions contained in any content and material on the Platform including, without limitation any third party sites or services linked to the Platform and/or that the Service will be uninterrupted, timely or error-free, (ii) the defects will be rectified, or that the Platform or the servers that make such content, information and materials available are free of viruses or other harmful components; \n8. Any material downloaded or otherwise obtained through the Website is accessed at your own risk, and you will be solely responsible for any damage or loss of data that results from such download to your computer system; \n'**
  String get theCompanyIsTheSoleOwner;

  /// No description provided for @termPaymentAndRefunds.
  ///
  /// In en, this message translates to:
  /// **'8. Payment and Refunds'**
  String get termPaymentAndRefunds;

  /// No description provided for @byUsingThePlatform.
  ///
  /// In en, this message translates to:
  /// **'1. By using the Platform, the user agrees to pay all applicable fees and charges upfront to Enso Innovation Lab and also authorises us to automatically deduct all applicable charges and fees from the payments made as and when such features are accessed on our Platform. Further, the user agrees to be responsible for any telephone charges and/ or internet Service fees that may be incurred in accessing the Services. \n2. For more information on payment methods, charges and fees, the user shall refer to the Payment section on the Platform. \n3. All cancellations and refunds will be handled as per the Cancellation and Refund Policy. \n4. Enso Innovation Lab reserves the right to change any or all parts of the Cancellation & Refund Policy without notice or liability to the user or any third-party. \n'**
  String get byUsingThePlatform;

  /// No description provided for @termIndemnity.
  ///
  /// In en, this message translates to:
  /// **'9. Indemnity'**
  String get termIndemnity;

  /// No description provided for @youHerebyAgreeToIndemnify.
  ///
  /// In en, this message translates to:
  /// **'You hereby agree to indemnify, defend and hold the Company, the Company’s agents, affiliates, representatives, authorized users, employees and assigns harmless from and against any and all losses, damages, liabilities and costs arising from your use of the Platform or Services and / or the violation of these Terms and/or Privacy Policy by you.\n'**
  String get youHerebyAgreeToIndemnify;

  /// No description provided for @termLimitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'10. Limitation of Liability'**
  String get termLimitationOfLiability;

  /// No description provided for @youAcknowledgeAndUndertakeThat.
  ///
  /// In en, this message translates to:
  /// **'1. You acknowledge and undertake that you are accessing the Platform and using the Services at your own risk and are using your best and prudent judgment before entering into any transactions through the Platform. \n2. To the fullest extent permitted by law, under no circumstances will the Company be liable to you or any other person or entity for any direct, indirect, incidental, special, remote or consequential damages, including but not limited to damages, goodwill, data or other intangible losses, resulting from any circumstances, including: \na. the use or the inability to use the Services; \nb. unauthorized access to or alteration of your transmissions or data; \nc. misinterpretation of the Information, or any other content provided on the Platform or by a Wellness Professional; \nd. the unauthorized use of the Platform; \ne. lack of disclosure, or incorrect disclosure by you, of any relevant information which would alter the Services provided by a Wellness Professional; \nf. lack of disclosure, or incorrect disclosure by you, of any medical history or pre-existing health conditions. For the purposes of this clause, the term “medical history” shall mean a comprehensive personal record of the information relating to your health, including information about allergies, childhood illnesses, adult illnesses, psychiatric illnesses, accidents and injuries, surgeries, immunizations, results of physical exams and tests, information about medicines taken and health habits, such as diet and exercise, smoking, alcohol and recreational drug consumption, current and previous prescription–only medicine regimes, current and recent over-the-counter regimes, and any other factors which may be relevant in determining your overall state of health.\n'**
  String get youAcknowledgeAndUndertakeThat;

  /// No description provided for @termDisclaimerOnWarranties.
  ///
  /// In en, this message translates to:
  /// **'11. Disclaimer on Warranties'**
  String get termDisclaimerOnWarranties;

  /// No description provided for @youUnderstandAndAgreeThatAnyInteractions.
  ///
  /// In en, this message translates to:
  /// **'1. You understand and agree that any interactions and associated issues with a Wellness Professional on the Platform, is strictly between you and the Wellness Professional. You shall not hold Enso Innovation Lab and/or the Wellness Professional responsible for any such interactions and associated issues. Enso Innovation Lab and/or the Wellness Professional is not responsible for any outcome between you and the Wellness Professional you interact with. If you decide to engage with a Wellness Professional to provide psychological wellness or psychiatry services to you, you do so at your own discretion and risk. The Services and content, and all materials, information, products and Services included therein, are provided on an “as is” and “as available” basis without warranties of any kind. \n2. Enso Innovation Lab and its licensors and affiliates expressly disclaim all warranties of any kind, express, implied, or statutory, relating to the Services and content. \n3. In addition, Enso Innovation Lab and its licensors and affiliates disclaim any warranties regarding security, accuracy, reliability, timeliness and performance of the Services or that the Services will be error-free or that any errors will be corrected. No advice or information provided to you by breakthrough will create any warranty that is not expressly stated in these Terms and Conditions.'**
  String get youUnderstandAndAgreeThatAnyInteractions;

  /// No description provided for @continueButtonText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButtonText;

  /// No description provided for @verifyButtonText.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButtonText;

  /// No description provided for @bookASessionButtonText.
  ///
  /// In en, this message translates to:
  /// **'Book a Session'**
  String get bookASessionButtonText;

  /// No description provided for @livechatButtonText.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get livechatButtonText;

  /// No description provided for @joinNowButtonText.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get joinNowButtonText;

  /// No description provided for @cancelAppointmentButtonText.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointmentButtonText;

  /// No description provided for @proceedButtonText.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceedButtonText;

  /// No description provided for @saveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonText;

  /// No description provided for @closeButtonText.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButtonText;

  /// No description provided for @reBookButtonText.
  ///
  /// In en, this message translates to:
  /// **'Re-Book'**
  String get reBookButtonText;

  /// No description provided for @cancelledButtonText.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledButtonText;

  /// No description provided for @addMoreButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMoreButtonText;

  /// No description provided for @filterCloseButtonText.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get filterCloseButtonText;

  /// No description provided for @filterApplyButtonText.
  ///
  /// In en, this message translates to:
  /// **'APPLY'**
  String get filterApplyButtonText;

  /// No description provided for @filterClearAllButtonText.
  ///
  /// In en, this message translates to:
  /// **'CLEAR ALL'**
  String get filterClearAllButtonText;

  /// No description provided for @filterDateRangeLast1Months.
  ///
  /// In en, this message translates to:
  /// **'Last 1 month'**
  String get filterDateRangeLast1Months;

  /// No description provided for @filterDateRangeLast3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get filterDateRangeLast3Months;

  /// No description provided for @filterDateRangeLast6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get filterDateRangeLast6Months;

  /// No description provided for @filterDateRangeLast1Year.
  ///
  /// In en, this message translates to:
  /// **'Last 1 year'**
  String get filterDateRangeLast1Year;

  /// No description provided for @filterPayStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get filterPayStatusSuccess;

  /// No description provided for @filterPayStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterPayStatusPending;

  /// No description provided for @filterPayStatusFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get filterPayStatusFailure;

  /// No description provided for @filterTypeAppointInPerson.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get filterTypeAppointInPerson;

  /// No description provided for @filterTypeAppointAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get filterTypeAppointAudio;

  /// No description provided for @filterTypeAppointVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get filterTypeAppointVideo;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get noDataFound;

  /// No description provided for @appointmentId.
  ///
  /// In en, this message translates to:
  /// **'Appointment ID'**
  String get appointmentId;

  /// No description provided for @clientId.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get clientId;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In-Person'**
  String get inPerson;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
