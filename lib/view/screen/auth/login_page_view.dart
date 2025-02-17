import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/controllers/authcontroller/login_page_controller.dart';
import 'package:manadeebapp/core/constants/class/handle_data_view.dart';
import 'package:manadeebapp/core/constants/class/status_request.dart';
import 'package:manadeebapp/view/widget/sharedwidget/buttons/custom_button.dart';
import 'package:manadeebapp/view/widget/sharedwidget/forms/custom_textform.dart';
import '../../../core/function/vailderinput.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginPageController(
      loginRepositories: Get.find(),
      myServices: Get.find(),
    ));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('1'.tr, style: theme.textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: GetBuilder<LoginPageController>(
        init: controller,
        builder: (controller) => HandlingDataView(
          statusRequest: controller.state,
          widget: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Authheroimage(
                      //   image: "assets/images/auth/login.png",
                      // ),
                      // const SizedBox(height: 32),
                      Card(
                        elevation: 0,
                        color: theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.dividerColor.withOpacity(0.1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: controller.formkey,
                            child: Column(
                              children: [
                                Text(
                                  "2".tr,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "3".tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                TextFormFieldCustom(
                                  label: '4'.tr,
                                  hint: "5".tr,
                                  controller: controller.emailController,
                                  validator: (value) =>
                                      vailder(value!, 8, 30, 'email'),
                                  suffixIcon: Icon(Icons.email_outlined,
                                      color: theme.colorScheme.primary),
                                ),
                                const SizedBox(height: 16),
                                TextFormFieldCustom(
                                  label: "6".tr,
                                  hint: "7".tr,
                                  controller: controller.passwordController,
                                  initiallyObscured: true,
                                  validator: (value) =>
                                      vailder(value!, 8, 15, "password"),
                                ),
                                const SizedBox(height: 24),
                                CustomButton(
                                  text: "1".tr,
                                  onPressed: () => controller.login(),
                                  width: double.infinity,
                                  height: 55,
                                  elevation: 2,
                                  isLoading: controller.state == STATUSREQUEST.loading
                                ),
                                const SizedBox(height: 16),
                                // TextButton(
                                //   onPressed: () {},
                                //   child: Text(
                                //     "Forgot Password?",
                                //     style: theme.textTheme.bodyMedium?.copyWith(
                                //       color: theme.colorScheme.primary,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
