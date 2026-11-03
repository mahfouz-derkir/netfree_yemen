class APNInfo {
  final String title;
  final String apn;
  final String user;
  final String password;
  final String type;
  final String verifiedDate;
  final String note;

  const APNInfo({
    required this.title,
    required this.apn,
    required this.user,
    required this.password,
    required this.type,
    required this.verifiedDate,
    required this.note,
  });
}

class OfficialOffer {
  final String title;
  final String description;
  final String codeOrUrl;
  final bool isUrl;
  final String note;

  const OfficialOffer({
    required this.title,
    required this.description,
    required this.codeOrUrl,
    required this.isUrl,
    required this.note,
  });
}

class AppData {
  static const List<APNInfo> yemenMobileAPNs = [
    APNInfo(
      title: "إعدادات فورجي (Yemen Mobile 4G LTE)",
      apn: "ymdata",
      user: "ymdata",
      password: "ymdata",
      type: "default,supl",
      verifiedDate: "أكتوبر 2026",
      note: "مخصصة لتفعيلات شرائح 4G في مختلف المحافظات.",
    ),
    APNInfo(
      title: "إعدادات ثري جي (Yemen Mobile 3G CDMA)",
      apn: "#777",
      user: "ymobile",
      password: "ymobile",
      type: "default",
      verifiedDate: "أكتوبر 2026",
      note: "تستخدم للهواتف والشرايح القديمة أو تغطية 3G.",
    ),
  ];

  static const List<OfficialOffer> officialOffers = [
    OfficialOffer(
      title: "استعلام رصيد باقات الإنترنت",
      description: "معرفة الرصيد المتبقي من البيانات عبر الخدمة الذاتية.",
      codeOrUrl: "*181#",
      isUrl: false,
      note: "اتصال مباشر مجاني لمشتركي يمن موبايل.",
    ),
    OfficialOffer(
      title: "البوابة الإلكترونية الرسمية ليمن موبايل",
      description: "استعراض العروض والباقات التنافسية الرسمية المحدثة.",
      codeOrUrl: "https://www.yemenmobile.com.ye",
      isUrl: true,
      note: "تأكد من فتح الرابط في المتصفح الرسمي.",
    ),
  ];
}
