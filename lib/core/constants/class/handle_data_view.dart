import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../view/widget/sharedwidget/buttons/custom_button.dart';
import 'status_request.dart';

// تعريف حالة عرض معالجة البيانات
class HandlingDataView extends StatefulWidget {
  const HandlingDataView({
    super.key,
    required this.statusRequest,
    required this.widget,
  });

  final STATUSREQUEST statusRequest;
  final Widget widget;

  @override
  State<HandlingDataView> createState() => _HandlingDataViewState();
}

class _HandlingDataViewState extends State<HandlingDataView> {
  late STATUSREQUEST currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.statusRequest;
  }

  @override
  void didUpdateWidget(HandlingDataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statusRequest != widget.statusRequest) {
      currentStatus = widget.statusRequest;
    }
  }

  // بناء الرسوم المتحركة لوتي
  Widget _buildLottieAnimation(String assetPath, {bool showRetry = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            assetPath,
            width: 250,
            height: 250,
          ),
          if (showRetry) ...[
            const SizedBox(height: 20),
            CustomButton(
              text: "Try Again",
              onPressed: () {
                setState(() {
                  currentStatus = STATUSREQUEST.none;
                });
              },
              width: 200,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (currentStatus) {
      case STATUSREQUEST.loading:
        return _buildLottieAnimation('assets/images/lottie/loading.json');
      case STATUSREQUEST.offlinefailer:
        return _buildLottieAnimation('assets/images/lottie/offline.json',
            showRetry: true);
      case STATUSREQUEST.failure:
        return _buildLottieAnimation('assets/images/lottie/nodata.json',
            showRetry: true);
      case STATUSREQUEST.servicefailer:
        return _buildLottieAnimation('assets/images/lottie/server.json',
            showRetry: true);
      default:
        return widget.widget;
    }
  }
}