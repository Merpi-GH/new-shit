import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/router/app_routers.dart';
import 'package:asood/core/widgets/appbar/default_appbar.dart';
import 'package:asood/features/bank_card/screens/bank_card_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// صفحه امور مالی و کیف پول - طبق مستندات PDF آسود
class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: Dimensions.width * 0.9,
        height: Dimensions.height * 0.07,
        decoration: BoxDecoration(
          color: Colora.borderTag,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colora.backgroundDialog, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colora.scaffold, size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colora.scaffold,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colora.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: Dimensions.height * 0.12),
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.height * 0.02),

                      // کیف پول (اضافه شده طبق PDF)
                      _menuItem('کیف پول', Icons.account_balance_wallet, () {
                        context.push(AppRoutes.wallet);
                      }),

                      SizedBox(height: Dimensions.height * 0.015),

                      // لیست مشخصات بانکی
                      _menuItem('لیست مشخصات بانکی', Icons.credit_card, () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BankCardListScreen(),
                          ),
                        );
                      }),

                      SizedBox(height: Dimensions.height * 0.015),

                      // پرداخت‌ها
                      _menuItem('تاریخچه پرداخت‌ها', Icons.payment, () {
                        context.push(AppRoutes.payment, extra: {
                          'amount': 0.0,
                          'targetContent': 'history',
                          'targetId': '',
                        });
                      }),

                      SizedBox(height: Dimensions.height * 0.015),

                      // واریز و برداشت
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHalfButton('واریز', Icons.arrow_downward, () {}),
                          SizedBox(width: Dimensions.width * 0.04),
                          _buildHalfButton('برداشت', Icons.arrow_upward, () {}),
                        ],
                      ),

                      SizedBox(height: Dimensions.height * 0.015),

                      // آمار و داشبورد
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHalfButton('داشبورد', Icons.dashboard, () {}),
                          SizedBox(width: Dimensions.width * 0.04),
                          _buildHalfButton('آمار', Icons.bar_chart, () {}),
                        ],
                      ),

                      SizedBox(height: Dimensions.height * 0.02),
                    ],
                  ),
                ),
              ),
              const NewAppBar(title: 'امور مالی و کیف پول'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHalfButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: Dimensions.width * 0.43,
        height: Dimensions.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colora.backgroundDialog, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colora.backgroundDialog, size: 20),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: Colora.backgroundDialog,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
