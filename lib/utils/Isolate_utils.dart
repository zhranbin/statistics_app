import 'dart:async';
import 'dart:isolate';

/// Isolate封装函数
Future<T?> runInIsolate<T>(Function(dynamic) task, {dynamic data}) async {
  // 创建一个接收端口
  final receivePort = ReceivePort();
  try {
    // 启动一个新的 Isolate，并将任务和接收端口的发送端口传入
    await Isolate.spawn(_isolateEntry, [task, data, receivePort.sendPort]);
    // 等待任务完成后，接收结果
    final result = await receivePort.first as T;
    return result;
  } catch (e) {
    // throw Exception('Error while running isolate: $e');
    print('Error while running isolate: $e');
    return null;
  } finally {
    // 关闭接收端口
    receivePort.close();
  }
}

/// Isolate入口函数
void _isolateEntry(List<dynamic> args) {
  final task = args[0] as Function;
  final message = args[1];
  final sendPort = args[2] as SendPort;
  // 执行任务，并将结果发送回主线程
  final result = task(message);
  sendPort.send(result);
}

