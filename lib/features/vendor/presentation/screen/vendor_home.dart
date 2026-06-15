import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/helper/snack_bar_util.dart';
import 'package:asood/core/http_client/api_status.dart';
import 'package:asood/core/router/app_routers.dart';
import 'package:asood/core/widgets/appbar/default_appbar.dart';
import 'package:asood/features/vendor/presentation/bloc/workspace/workspace_bloc.dart';
import 'package:asood/features/vendor/presentation/widgets/dashboard_carousel.dart';
import 'package:asood/features/vendor/presentation/widgets/item_box_with_title.dart';
import 'package:asood/features/vendor/presentation/widgets/simple_itembox.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

// -------------------------------------------------------
// منوی اصلی طبق مستندات PDF آسود
// خدمات کسب و کار: ایجاد دفتر کار، کسب درآمد از آسود،
// همکاری در فروش، استعلام بهاء، ثبت آگهی، کارت ویزیت
// خدمات جانبی: امور مالی و کیف پول، سامانه پیام کوتاه،
// داشبورد خریدار، داشبورد فروشنده، راهنمای صوتی،
// اشتراک گذاری، علاقه مندی، پشتیبانی، تنظیمات
// -------------------------------------------------------

Map dummyData = {
  // بخش خدمات کسب و کار
  "firstMenu": [
    {
      "title": "ایجاد دفتر کار",
      "image": const Icon(Icons.work_rounded, size: 60, color: Colors.white),
      "page": AppRoutes.createWorkSpace,
    },
    {
      "title": "کسب درآمد از آسود",
      "image": const Icon(Icons.attach_money_rounded, size: 60, color: Colors.white),
      "page": AppRoutes.earnIncome,
    },
    {
      "title": "همکاری در فروش",
      "image": const Icon(Icons.person_rounded, size: 60, color: Colors.white),
      "page": AppRoutes.marketer,
    },
    {
      "title": "استعلام بهاء",
      "image": const Icon(Icons.price_change_rounded, size: 60, color: Colors.white),
      "page": AppRoutes.inquiryRequests,
    },
    {
      "title": "ثبت آگهی",
      "image": const Icon(Icons.ads_click_rounded, size: 60, color: Colors.white),
      "page": null,
    },
    {
      "title": "کارت ویزیت",
      "image": const Icon(Icons.card_membership_rounded, size: 60, color: Colors.white),
      "page": AppRoutes.business,
    },
  ],
  // بخش خدمات جانبی
  "secondMenu": [
    {
      "title": "امور مالی و کیف پول",
      "image": const Icon(Iconsax.bank, size: 60, color: Colors.white),
      "page": AppRoutes.finance,
    },
    {
      "title": "سامانه پیام کوتاه",
      "image": const Icon(Iconsax.message5, size: 60, color: Colors.white),
      "page": AppRoutes.panelInbox,
    },
    {
      "title": "داشبورد خریدار",
      "image": const Icon(Iconsax.buy_crypto5, size: 60, color: Colors.white),
      "page": AppRoutes.customerDashboard,
    },
    {
      "title": "داشبورد فروشنده",
      "image": const Icon(Icons.sell, size: 60, color: Colors.white),
      "page": AppRoutes.vendorDashboard,
    },
    {
      "title": "راهنمای صوتی",
      "image": const Icon(Iconsax.info_circle5, size: 60, color: Colors.white),
      "page": null,
    },
    {
      "title": "اشتراک گذاری",
      "image": const Icon(Iconsax.share5, size: 60, color: Colors.white),
      "page": null,
    },
    {
      "title": "علاقه مندی",
      "image": const Icon(Iconsax.heart5, size: 60, color: Colors.white),
      "page": AppRoutes.bookmarks,
    },
    {
      "title": "پشتیبانی",
      "image": const Icon(Iconsax.personalcard5, size: 60, color: Colors.white),
      "page": null,
    },
    {
      "title": "تنظیمات",
      "image": const Icon(Iconsax.setting, size: 60, color: Colors.white),
      "page": null,
    },
  ],
};

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen>
    with SingleTickerProviderStateMixin {
  late WorkspaceBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<WorkspaceBloc>(context);
    bloc.add(LoadStores());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colora.primaryColor,
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              SizedBox(
                height: Dimensions.height,
                width: Dimensions.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.only(top: Dimensions.seven),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: Dimensions.height * 0.12),

                              // بخش تبلیغات: نمایش فیلم و تیزر تبلیغاتی
                              const DashboardCarouselWidget(),

                              // خدمات کسب و کار
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.khorisontal,
                                ),
                                child: DashboardServicesWidget(),
                              ),

                              // خدمات جانبی
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.khorisontal,
                                ),
                                child: DashboardAdditionalWidget(),
                              ),

                              SizedBox(height: Dimensions.height * 0.15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // هدر - AppBar
              const NewAppBar(title: 'home'),
            ],
          ),

          // منوی زیرین طبق PDF:
          // راهنمای صوتی | لیست فروشگاه | ورود به فروشگاه والد | پیامرسان | پروفایل
          bottomNavigationBar: Stack(
            children: [
              CustomPaint(
                size: Size(Dimensions.width, Dimensions.height * 0.15),
                painter: CurvedPainter(),
              ),

              // آیکون‌های منوی زیرین
              SizedBox(
                height: Dimensions.height * 0.11,
                width: Dimensions.width,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // پروفایل
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.width * 0.05),
                        child: InkWell(
                          onTap: () => context.push(AppRoutes.vendorProfile),
                          child: _bottomNavItem(Iconsax.personalcard),
                        ),
                      ),
                      // پیامرسان
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.width * 0.025),
                        child: InkWell(
                          onTap: () => context.push(AppRoutes.shoppingCart),
                          child: _bottomNavItemLarge(Iconsax.message),
                        ),
                      ),
                      // لیست فروشگاه (ورود به فروشگاه والد)
                      _bottomNavItemCenter(Iconsax.home),
                      // ورود به فروشگاه والد
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.width * 0.025),
                        child: _bottomNavItemLarge(Iconsax.shop),
                      ),
                      // راهنمای صوتی
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.width * 0.05),
                        child: InkWell(
                          onTap: () => context.push(AppRoutes.business),
                          child: _bottomNavItem(Iconsax.info_circle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // برچسب‌های زیر آیکون‌ها
              Positioned(
                bottom: 0,
                width: Dimensions.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bottomNavLabel('پروفایل', Dimensions.width * 0.05),
                    _bottomNavLabel('پیامرسان', Dimensions.width * 0.025),
                    _bottomNavLabel('خانه', 0),
                    _bottomNavLabel('فروشگاه', Dimensions.width * 0.025),
                    _bottomNavLabel('راهنما', Dimensions.width * 0.05),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon) {
    return Container(
      width: Dimensions.width * 0.15,
      height: Dimensions.width * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Colora.primaryColor,
        border: Border.all(color: Colora.scaffold, width: 6),
      ),
      child: Center(child: Icon(icon, color: Colora.scaffold)),
    );
  }

  Widget _bottomNavItemLarge(IconData icon) {
    return Container(
      width: Dimensions.width * 0.175,
      height: Dimensions.width * 0.175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Colora.primaryColor,
        border: Border.all(color: Colora.scaffold, width: 6),
      ),
      child: Center(child: Icon(icon, color: Colora.scaffold)),
    );
  }

  Widget _bottomNavItemCenter(IconData icon) {
    return Container(
      width: Dimensions.width * 0.2,
      height: Dimensions.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Colora.primaryColor,
        border: Border.all(color: Colora.scaffold, width: 6),
      ),
      child: Center(child: Icon(icon, color: Colora.scaffold)),
    );
  }

  Widget _bottomNavLabel(String label, double topPadding) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: SizedBox(
        width: Dimensions.width * 0.18,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colora.scaffold,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// بخش خدمات جانبی
// -------------------------------------------------------
class DashboardAdditionalWidget extends StatelessWidget {
  const DashboardAdditionalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Deco.kshadow,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: Dimensions.height * 0.46,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "امکانات:",
                  style: ATextStyle.lightBlue16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height * .45,
              width: Dimensions.width * .7,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                shrinkWrap: true,
                cacheExtent: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ...List.generate(
                    dummyData["secondMenu"].length,
                    (index) => FittedBox(
                      child: ItemBoxTitle(
                        onTap: () {
                          final page = dummyData["secondMenu"][index]["page"];
                          if (index == 5) {
                            // اشتراک گذاری
                            launchUrl(Uri.parse('https://asoud.ir/'));
                          } else if (page != null) {
                            context.push(page);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'به زودی اضافه می‌شود',
                              backgroundColor: Colora.primaryColor,
                              textColor: Colors.white,
                            );
                          }
                        },
                        title: dummyData["secondMenu"][index]["title"],
                        child: dummyData["secondMenu"][index]["image"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// بخش خدمات کسب و کار
// -------------------------------------------------------
class DashboardServicesWidget extends StatelessWidget {
  const DashboardServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Deco.kshadow,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: MediaQuery.of(context).size.height * 0.41,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "کسب و کار:",
                  style: ATextStyle.lightBlue16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            BlocConsumer<WorkspaceBloc, WorkspaceState>(
              listener: (context, state) {
                if (state.status == CWSStatus.failure) {
                  showSnackBar(
                    context,
                    "مشکلی در بارگذاری پیش آمده , مجدد تلاش کنید!",
                  );
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: Dimensions.height * .4,
                  width: Dimensions.width * .8,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    cacheExtent: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 15,
                    children: [
                      ...List.generate(
                        dummyData["firstMenu"].length,
                        (index) => SimpleItemBox(
                          onTap: () {
                            // اگر ایجاد دفتر کار: اگر لیست خالی بود برو ایجاد، وگرنه نمایش لیست
                            if (index == 0) {
                              if (state.storesList.isEmpty) {
                                context.push(AppRoutes.createWorkSpace);
                              } else {
                                context.push(AppRoutes.markets);
                              }
                            } else {
                              final page = dummyData["firstMenu"][index]["page"];
                              if (page != null) {
                                context.push(page);
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'به زودی اضافه می‌شود',
                                  backgroundColor: Colora.primaryColor,
                                  textColor: Colors.white,
                                );
                              }
                            }
                          },
                          title: dummyData["firstMenu"][index]["title"],
                          child: dummyData["firstMenu"][index]["image"],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
