import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void goto(Widget page,BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page,));
}

void gotoAndRemove(Widget page,BuildContext context){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page,));
}
void gotoAndRemoveAll(Widget page,BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page,),(route) => false,);
}

void showNotificationn(String message , String title, BuildContext context, {bool isError = false}){
toastification.show(
  context: context, // optional if you use ToastificationWrapper
  type: isError ? ToastificationType.error : ToastificationType.success,
  style: ToastificationStyle.fillColored,
  autoCloseDuration: const Duration(seconds: 5),
  title: Text(title),
  // you can also use RichText widget for title and description parameters
  description: RichText(text:  TextSpan(text: message)),
  alignment: Alignment.topRight,
  direction: TextDirection.ltr,
  animationDuration: const Duration(milliseconds: 300),
  
  icon:  Icon( isError ? Icons.dangerous : Icons.check),
  showIcon: true, // show or hide the icon
  primaryColor: isError ? Colors.red : Colors.green,
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(
      color: Color(0x07000000),
      blurRadius: 16,
      offset: Offset(0, 16),
      spreadRadius: 0,
    )
  ],
  showProgressBar: true,
  closeButton: ToastCloseButton(
    showType: CloseButtonShowType.onHover,
    buttonBuilder: (context, onClose) {
      return OutlinedButton.icon(
        onPressed: onClose,
        icon: const Icon(Icons.close, size: 20),
        label: const Text('Close'),
      );
    },
  ),
  closeOnClick: false,
  pauseOnHover: true,
  dragToClose: true,
  applyBlurEffect: true,
  callbacks: ToastificationCallbacks(
    onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
    onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
    onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
    onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
  ),
);
}


