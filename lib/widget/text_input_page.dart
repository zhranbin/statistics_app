
import 'package:flutter/material.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../provider/theme_provider.dart';
import '../utils/my_route.dart';
import '../utils/my_toast.dart';
import 'my_app_bar.dart';
import 'my_button.dart';

class TextInputPage extends StatefulWidget {
  final String? title;
  final String? placeholder;
  final String? text;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  // 提示文本，会显示在输入框下方
  final String? hintText;
  final bool isPassword;


  const TextInputPage({super.key, this.title, this.placeholder, this.text, this.maxLength, this.keyboardType, this.maxLines, this.hintText, this.isPassword = false});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {

  TextEditingController controller = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    controller.text = widget.text ?? "";
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: MyAppBar(
        title: widget.title ?? "输入",
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: controller,
                onChanged: (text){},
                maxLength: widget.maxLength,
                maxLines: widget.isPassword ? 1 : widget.maxLines,
                keyboardType: widget.keyboardType,
                autofocus: false, ///  自动获取焦点
                obscureText: widget.isPassword,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textColor,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16, bottom: 6),
                  hintText: widget.placeholder ?? "请输入",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: theme.textGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if(widget.hintText != null) Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Text(widget.hintText ?? "", style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: (){
                if (controller.text.isEmpty) {
                  MyToast.show("请输入内容");
                  return;
                }
                MyRoute.pop(context: context, result: controller.text);
              },
              child: MyButton.gradientColorButton(
                text: "确认",
                colors: [theme.primaryColor, theme.secondaryColor],
                textColor: theme.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ).height(48).addPadding(EdgeInsets.symmetric(horizontal: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
