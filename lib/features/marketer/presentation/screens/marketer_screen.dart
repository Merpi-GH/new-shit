import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/widgets/appbar/default_appbar.dart';
import 'package:flutter/material.dart';

/// صفحه «همکاری در فروش» طبق مستندات آسود (صفحه ۱۶-۱۷ PDF)
/// نمایش بانک کالاهای بازاریاب: کالاهایی که فروشندگان با
/// تیک «فروش از طریق بازارياب» علامت زده‌اند و درصد تخفیف/کمیسیون
/// برای بازارياب در نظر گرفته‌اند.
class MarketerScreen extends StatefulWidget {
  const MarketerScreen({super.key});

  @override
  State<MarketerScreen> createState() => _MarketerScreenState();
}

class _MarketerScreenState extends State<MarketerScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _affiliateProducts = [];

  @override
  void initState() {
    super.initState();
    _loadAffiliateProducts();
  }

  Future<void> _loadAffiliateProducts() async {
    // ⚠️ MOCK DATA — این بخش به API واقعی وصل نیست.
    // وقتی endpoint بانک کالای بازاریاب آمد، این تابع را با
    // فراخوانی واقعی جایگزین کنید (به BACKEND_NEEDS.md مراجعه شود).
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _affiliateProducts.addAll([
          {'name': 'دریل شارژی ۲۰ ولت', 'commission': 8, 'price': 1250000},
          {'name': 'مته‌سری ۱۰۰ تکه صنعتی', 'commission': 12, 'price': 480000},
          {'name': 'سری پیچ‌گوشتی برقی', 'commission': 6, 'price': 690000},
        ]);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colora.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Dimensions.height * 0.12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _affiliateProducts.isEmpty
                        ? _buildEmptyState()
                        : _buildProductList(),
              ),
              const NewAppBar(title: 'همکاری در فروش'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 64,
              color: Colora.scaffold,
            ),
            const SizedBox(height: 16),
            const Text(
              'در حال حاضر کالایی برای همکاری در فروش موجود نیست',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colora.scaffold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'فروشندگانی که گزینه «فروش از طریق بازاریاب» را برای کالای خود فعال کرده‌اند، در این بخش نمایش داده می‌شوند.\n'
              'با معرفی این کالاها به مشتریان و ارسال لینک، در صورت خرید، کمیسیون مشخص‌شده به کیف پول شما واریز می‌شود.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colora.scaffold, fontSize: 13, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _affiliateProducts.length,
      itemBuilder: (context, index) {
        final item = _affiliateProducts[index];
        final price = (item['price'] as int?) ?? 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colora.primaryColor,
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            title: Text(
              item['name']?.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text('${price.toString().replaceAllMapped(
                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  )} تومان'),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'کمیسیون ${item['commission'] ?? 0}٪',
                      style: const TextStyle(color: Colors.green, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.share, color: Colora.primaryColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('لینک "${item['name']}" کپی شد (نمونه)')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
