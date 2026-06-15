import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/widgets/appbar/default_appbar.dart';
import 'package:flutter/material.dart';

/// صفحه ویرایش محصول - طبق مستندات PDF آسود
class EditProductDetail extends StatelessWidget {
  final String productId;
  final String marketId;

  const EditProductDetail({
    super.key,
    required this.productId,
    required this.marketId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colora.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const Center(
                child: Text(
                  'صفحه ویرایش محصول در حال توسعه است',
                  style: TextStyle(color: Colora.primaryColor),
                ),
              ),
              const NewAppBar(title: 'ویرایش محصول'),
            ],
          ),
        ),
      ),
    );
  }
}
