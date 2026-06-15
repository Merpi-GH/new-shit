import 'package:asood/core/constants/constants.dart';
import 'package:asood/core/helper/snack_bar_util.dart';
import 'package:asood/core/helper/validators.dart';
import 'package:asood/core/http_client/api_status.dart';
import 'package:asood/core/router/app_routers.dart';
import 'package:asood/core/widgets/custom_button.dart';
import 'package:asood/core/widgets/custom_textfield.dart';
import 'package:asood/core/widgets/radio_button.dart';
import 'package:asood/features/create_workspace/presentation/bloc/create_workspace_bloc.dart';
import 'package:asood/features/create_workspace/presentation/widgets/simple_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// -------------------------------------------------------
// گام سوم: تکمیل اطلاعات پایه طبق PDF
// فیلدها:
// - انتخاب قالب (شرکتی / فروشگاهی)
// - شناسه کسب و کار (انگلیسی، منحصربه‌فرد)
// - نام کسب و کار
// - توضیحات
// - شعار تبلیغاتی
// - کد معرف
// - دسته‌بندی مشاغل
// -------------------------------------------------------

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sloganController = TextEditingController();
  final TextEditingController _idCodeController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  late CreateWorkSpaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CreateWorkSpaceBloc>();
    _bloc.add(ChangeWorkspaceTabView(activeTabIndex: 0));
    _bloc.add(
      ChangeSelectedCategory(
        selectedCategoryName: 'انتخاب شغل',
        activeCategoryId: '',
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessIdController.dispose();
    _descriptionController.dispose();
    _sloganController.dispose();
    _idCodeController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _bloc.state.marketType.isNotEmpty &&
        _bloc.state.activeCategoryId.isNotEmpty) {
      _bloc.add(
        CreateMarket(
          businessId: _businessIdController.text.trim(),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          slogan: _sloganController.text.trim(),
          idCode: _idCodeController.text.trim(),
          marketType: _bloc.state.marketType,
          subCategory: _bloc.state.activeCategoryId,
        ),
      );
    } else {
      showSnackBar(context, "لطفا تمامی فیلدهای لازم را پر نمایید.");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CreateWorkSpaceBloc, CreateWorkSpaceState>(
      builder: (context, state) {
        final bool isShop = state.marketType == "shop";
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.khorisontal,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // تصویر بنر بالا
                Container(
                  height: Dimensions.height * 0.25,
                  width: Dimensions.width,
                  padding: EdgeInsets.only(bottom: Dimensions.height * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colora.primaryColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Assets.images.toolsThatYouShouldHave.image(
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // فرم اطلاعات پایه
                Container(
                  width: Dimensions.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                  margin: EdgeInsets.only(bottom: Dimensions.height * 0.04),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colora.primaryColor,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ۱. انتخاب قالب: شرکتی یا فروشگاهی
                        const SimpleTitle(title: 'انتخاب قالب :'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            radioButton(
                              title: "فروشگاهی",
                              value: "shop",
                              groupValue: state.marketType,
                              onChanged: (value) {
                                _bloc.add(SetMarketType(marketType: value!));
                              },
                            ),
                            radioButton(
                              title: "شرکتی",
                              value: "company",
                              groupValue: state.marketType,
                              onChanged: (value) {
                                _bloc.add(SetMarketType(marketType: value!));
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        // ۲. شناسه کسب و کار (انگلیسی، منحصربه‌فرد)
                        CustomTextField(
                          controller: _businessIdController,
                          isRequired: true,
                          text: "شناسه کسب و کار *",
                          validator: Validators.simpleFieldEmpty,
                          keyboardType: TextInputType.visiblePassword,
                        ),

                        const SizedBox(height: 7),

                        // ۳. نام کسب و کار
                        CustomTextField(
                          isRequired: true,
                          controller: _nameController,
                          text: isShop ? "نام کسب و کار *" : "نام شرکت *",
                          validator: Validators.simpleFieldEmpty,
                        ),

                        const SizedBox(height: 7),

                        // ۴. توضیحات
                        CustomTextField(
                          isRequired: true,
                          controller: _descriptionController,
                          text: "توضیحات",
                          maxLine: 6,
                          validator: Validators.simpleFieldEmpty,
                        ),

                        const SizedBox(height: 7),

                        // ۵. شعار تبلیغاتی
                        CustomTextField(
                          isRequired: true,
                          controller: _sloganController,
                          text: "شعار تبلیغاتی",
                          validator: Validators.simpleFieldEmpty,
                        ),

                        const SizedBox(height: 7),

                        // ۶. کد ملی / شناسه ملی
                        CustomTextField(
                          maxLength: isShop ? 10 : 11,
                          keyboardType: TextInputType.number,
                          controller: _idCodeController,
                          text: isShop ? "کد ملی *" : "شناسه ملی *",
                          validator: isShop
                              ? Validators.iranianNationalCodeValidator
                              : Validators.companyValidation,
                        ),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "کد ملی صرفاً جهت تخصیص آگهی به شما می‌باشد",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // ۷. کد معرف (referral)
                        CustomTextField(
                          controller: _referralCodeController,
                          text: "کد معرف (اختیاری)",
                        ),

                        const SizedBox(height: 7),

                        // ۸. دسته‌بندی مشاغل
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: Dimensions.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.twenty,
                            ),
                            color: Colora.scaffold,
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              final result = await context.push(
                                AppRoutes.jobManagement,
                              );
                              if (result is Map<String, String>) {
                                _bloc.add(
                                  ChangeSelectedCategory(
                                    selectedCategoryName:
                                        result['selectedCategoryName'] ?? '',
                                    activeCategoryId:
                                        result['selectedCategoryId'] ?? '',
                                  ),
                                );
                              }
                            },
                            child: Text(
                              state.selectedCategoryName,
                              style: const TextStyle(
                                color: Colora.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // دکمه بعدی
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomButton(
                              onPress: _submit,
                              text: state.status == CWSStatus.loading
                                  ? null
                                  : "بعدی",
                              color: Colors.white,
                              textColor: Colora.primaryColor,
                              height: 40,
                              width: 100,
                              btnWidget: state.status == CWSStatus.loading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.height * 0.1),
              ],
            ),
          ),
        );
      },
    );
  }
}
