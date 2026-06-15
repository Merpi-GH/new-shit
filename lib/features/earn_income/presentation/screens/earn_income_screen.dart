import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/router/app_routers.dart';
import 'package:asood/core/widgets/appbar/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// صفحه «کسب درآمد از آسود» طبق مستندات PDF (مقدمه پروژه):
/// راه‌های کسب درآمد در آسود را به کاربر معرفی می‌کند:
/// ایجاد دفتر کار/فروشگاه، همکاری در فروش، استعلام بها، ثبت آگهی
class EarnIncomeScreen extends StatelessWidget {
  const EarnIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'ایجاد دفتر کار مجازی و فروشگاه',
        'desc': 'با ساخت فروشگاه آنلاین، کالا و خدمات خود را به فروش برسانید.',
        'icon': Icons.store_mall_directory_rounded,
        'route': AppRoutes.createWorkSpace,
      },
      {
        'title': 'همکاری در فروش (بازاریابی)',
        'desc': 'با معرفی کالاهای دیگر فروشگاه‌ها، از هر فروش کمیسیون دریافت کنید.',
        'icon': Icons.person_rounded,
        'route': AppRoutes.marketer,
      },
      {
        'title': 'استعلام بها',
        'desc': 'با پاسخ‌گویی به درخواست‌های استعلام بهای کاربران، فروش انجام دهید.',
        'icon': Icons.price_change_rounded,
        'route': AppRoutes.inquiryRequests,
      },
      {
        'title': 'ثبت آگهی',
        'desc': 'کالا یا خدمات خود را در بخش آگهی‌ها نیز نمایش دهید تا دید بیشتری داشته باشید.',
        'icon': Icons.ads_click_rounded,
        'route': null,
      },
    ];

    return Container(
      color: Colora.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Dimensions.height * 0.12),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: ListTile(
                        leading: Icon(
                          item['icon'] as IconData,
                          color: Colora.primaryColor,
                          size: 32,
                        ),
                        title: Text(
                          item['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item['desc'] as String,
                            style: const TextStyle(fontSize: 12, height: 1.6),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_back_ios, size: 16),
                        onTap: () {
                          final route = item['route'] as String?;
                          if (route != null) {
                            context.push(route);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('به زودی اضافه می‌شود')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const NewAppBar(title: 'کسب درآمد از آسود'),
            ],
          ),
        ),
      ),
    );
  }
}
