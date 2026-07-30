import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/app/app.dart";
import "package:happy_os/shared/utils/index.dart";

Future<void> main() async {
  // 异步初始化前需先绑定 Flutter engine。
  WidgetsFlutterBinding.ensureInitialized();

  // 加载 .env 环境配置；文件缺失/未注册时不致命，Env 会回退到默认值。
  try {
    await dotenv.load();
  } catch (e) {
    AppLogger.w("dotenv 加载失败，使用 Env 默认配置：$e");
  }

  // 全局兜底：Flutter 框架错误与其余未捕获异步异常统一记日志，避免静默崩溃。
  FlutterError.onError = (details) =>
      AppLogger.e("FlutterError", details.exception, details.stack);
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e("Uncaught", error, stack);
    return true;
  };

  // ProviderScope：Riverpod 根容器，为 controller/provider 提供作用域。
  runApp(const ProviderScope(child: HappyApp()));
}
