import 'package:asood/core/models/market_model.dart';
import 'package:asood/core/router/app_routers.dart';
import 'package:asood/features/market/presentation/widgets/share_store.dart';
import 'package:asood/features/vendor/presentation/bloc/workspace/workspace_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constants.dart';
import 'custom_button.dart';

// -------------------------------------------------------
// کارت فروشگاه با ۹ وضعیت و ۶ دکمه مدیریتی طبق PDF
// وضعیت‌ها:
// ۱. پرداخت شده
// ۲. پرداخت نشده
// ۳. در دست ایجاد، پرداخت نشده
// ۴. در دست ایجاد، پرداخت شده
// ۵. در صف انتشار، پرداخت شده
// ۶. عدم انتشار، پرداخت شده
// ۷. منتشر شده
// ۸. نیاز به ویرایش، پرداخت شده
// ۹. غیر فعال
// دکمه‌های مدیریتی:
// ۱. پیش نمایش (نمای مشتری)
// ۲. ویرایش (مدیریت)
// ۳. اشتراک گذاری
// ۴. انتشار
// ۵. پرداخت اشتراک
// ۶. غیر فعال
// -------------------------------------------------------

class StoreCard extends StatefulWidget {
  const StoreCard({
    super.key,
    required this.market,
    required this.index,
    this.menuVisibility = true,
    required this.bloc,
  });
  final MarketModel market;
  final int index;
  final bool menuVisibility;
  final WorkspaceBloc bloc;

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool isMenuVisible = false;

  // ترجمه وضعیت‌های فروشگاه به فارسی طبق PDF
  String shopStatus(String? status) {
    switch (status) {
      case 'paid':
        return 'پرداخت شده';
      case 'unpaid':
        return 'پرداخت نشده';
      case 'draft':
        return 'در دست ایجاد، پرداخت نشده';
      case 'draft_paid':
        return 'در دست ایجاد، پرداخت شده';
      case 'queue':
        return 'در صف انتشار، پرداخت شده';
      case 'not_published':
        return 'عدم انتشار، پرداخت شده';
      case 'published':
        return 'منتشر شده';
      case 'needs_editing':
        return 'نیاز به ویرایش، پرداخت شده';
      case 'inactive':
        return 'غیر فعال';
      default:
        return 'نامشخص';
    }
  }

  // رنگ نشانگر وضعیت
  Color statusColor(String? status) {
    switch (status) {
      case 'published':
        return Colors.green;
      case 'paid':
        return Colors.blue;
      case 'queue':
        return Colors.orange;
      case 'needs_editing':
        return Colors.red;
      case 'inactive':
        return Colors.grey;
      case 'not_published':
        return Colors.redAccent;
      default:
        return Colors.amber;
    }
  }

  // دیالوگ انتشار: منتشر شود / عدم انتشار طبق PDF
  void _showPublishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          height: Dimensions.height * 0.2,
          child: Column(
            children: [
              Text(
                'وضعیت انتشار',
                style: TextStyle(
                  color: Colora.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.width * 0.05,
                ),
              ),
              const Divider(color: Colora.primaryColor),
              Text(
                'آیا می‌خواهید دفترکار مجازی شما منتشر شود و یا از حالت انتشار خارج شود؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colora.primaryColor,
                  fontSize: Dimensions.width * 0.035,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // منتشر شود
                  _dialogButton(
                    label: 'منتشر شود',
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.bloc.add(
                        PublishMarket(marketId: widget.market.id ?? ""),
                      );
                    },
                  ),
                  // عدم انتشار
                  _dialogButton(
                    label: 'عدم انتشار',
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.bloc.add(
                        UnPublishMarket(marketId: widget.market.id ?? ""),
                      );
                    },
                  ),
                  // بعدا
                  _dialogButton(
                    label: 'بعدا',
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width * 0.03,
          vertical: Dimensions.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colora.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colora.scaffold,
            fontSize: Dimensions.width * 0.03,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ردیف اطلاعات فروشگاه
        IgnorePointer(
          ignoring: !widget.menuVisibility,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isMenuVisible = !isMenuVisible;
              });
            },
            child: Container(
              height: Dimensions.height * 0.14,
              width: Dimensions.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colora.lightBlue,
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  // لوگو فروشگاه
                  Container(
                    width: Dimensions.width * 0.25,
                    height: Dimensions.height * 0.2,
                    margin: EdgeInsets.symmetric(
                      vertical: Dimensions.height * 0.003,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colora.scaffold,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.market.logoImg.toString() != 'null'
                              ? CachedNetworkImage(
                                  imageUrl: widget.market.logoImg.toString(),
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.withOpacity(0.2),
                                        highlightColor:
                                            Colors.black.withOpacity(0.2),
                                        direction: ShimmerDirection.rtl,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : SvgPicture.asset(
                                  'assets/images/logo_svg.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colora.lightBlue,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Dimensions.width * 0.02),

                  // اطلاعات: نام، دسته شغلی، وضعیت، تاریخ، شناسه
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // نام کسب و کار
                      SizedBox(
                        width: Dimensions.width * 0.65,
                        child: Text(
                          widget.market.name.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: ATextStyle.lightBold15.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width * 0.65,
                        child: const Divider(thickness: 1),
                      ),
                      SizedBox(
                        width: Dimensions.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // دسته شغلی
                            Text(
                              widget.market.subCategoryTitle.toString(),
                              overflow: TextOverflow.fade,
                              style: ATextStyle.light12.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            // وضعیت فروشگاه
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width * 0.02,
                                vertical: Dimensions.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(widget.market.status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                shopStatus(widget.market.status),
                                style: ATextStyle.light12.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.height * 0.01),
                      SizedBox(
                        width: Dimensions.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // تاریخ ایجاد
                            Text(
                              "تاریخ: ${widget.market.createdAt}",
                              style: ATextStyle.light12.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            // شناسه کسب و کار
                            Text(
                              "شناسه: ${widget.market.businessId}",
                              style: ATextStyle.light12.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ۶ دکمه مدیریتی طبق PDF
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              SizeTransition(sizeFactor: animation, child: child),
          child: isMenuVisible
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ۱. پیش نمایش (نمای مشتری)
                          CustomButton(
                            width: 110,
                            onPress: () {
                              context.push(
                                AppRoutes.storeDetail,
                                extra: widget.market,
                              );
                            },
                            text: "پیش نمایش",
                          ),
                          // ۲. ویرایش (مدیریت)
                          CustomButton(
                            width: 110,
                            onPress: () {
                              context.push(
                                AppRoutes.marketPreview,
                                extra: widget.market,
                              );
                            },
                            text: "ویرایش",
                          ),
                          // ۳. اشتراک گذاری
                          CustomButton(
                            width: 110,
                            onPress: () {
                              ShareStore.share(
                                widget.market.businessId.toString(),
                              );
                            },
                            text: "اشتراک گذاری",
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ۴. انتشار
                          CustomButton(
                            width: 110,
                            onPress: () => _showPublishDialog(context),
                            text: "انتشار",
                          ),
                          // ۵. پرداخت اشتراک
                          CustomButton(
                            width: 110,
                            onPress: () {
                              // هدایت به درگاه پرداخت حق اشتراک طبق PDF
                              context.push(
                                AppRoutes.payment,
                                extra: {
                                  'amount': 0.0,
                                  'targetContent': 'subscription',
                                  'targetId': widget.market.id ?? '',
                                },
                              );
                            },
                            text: "پرداخت اشتراک",
                          ),
                          // ۶. غیر فعال
                          CustomButton(
                            width: 110,
                            onPress: () {
                              widget.bloc.add(
                                DeactivateMarket(marketId: widget.market.id ?? ""),
                              );
                            },
                            text: "غیر فعال",
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
