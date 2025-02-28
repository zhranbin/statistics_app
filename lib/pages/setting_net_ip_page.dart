import 'package:flutter/material.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';
import 'package:statistics_app/widget/my_app_bar.dart';

import '../utils/my_shared_preferences.dart';

class SettingNetIpPage extends StatefulWidget {
  const SettingNetIpPage({super.key});

  @override
  State<SettingNetIpPage> createState() => _SettingNetIpPageState();
}

class _SettingNetIpPageState extends State<SettingNetIpPage> {
  // 输入框Controller
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNetIp();
  }

  _loadNetIp() async {
    _textEditingController.text = await MySharedPreferences.getLocalServerIP() ?? "http://";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "设置网络IP",),
      body: Column(
        children: [
          // 网络IP输入框
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ).margin(EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
          Spacer(),
          ElevatedButton(
            onPressed: () async {
              // 保存网络IP
              await MySharedPreferences.setLocalServerIP(_textEditingController.text);
              // 返回
              Navigator.pop(context);
            },
            child: Text('保存'),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20)
        ],
      ),
    );
  }
}
