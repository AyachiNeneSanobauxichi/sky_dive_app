import "package:flutter/material.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 和 AI 一起写的对话页（v2 占位）。
///
/// 真正的对话（流式生成、追问改写、保存成稿）要等
/// `agent/service/story/story.api.md` 定稿——不知道消息结构与流式协议时先写一版
/// 聊天界面，契约来了必然重写。
///
/// [source] 是从哪个入口进来的：文本 / 语音 / 灵感。三种入口的**开场方式不一样**
/// （直接打字 / 按住说话 / 带着选中的灵感开场），所以占位文案也按来源分开写——
/// 这样这条参数是真的在用，而不是一个被忽略的入参。
// TODO(story): 接 story.api.md 后换成真实对话页（流式用 core/network/sse，
//   失败保留残篇，见 references/09-theming-ui.md）；语音输入还需要录音权限与波形。
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.source, this.seed});

  final ChatSource source;

  /// 从故事页带过来的草稿。有它就说明用户已经写了开头，占位文案要把这段话读回来
  /// ——不然用户会怀疑自己写的东西丢了。
  final String? seed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storyChatTitle)),
      body: HappyAuroraBackground(
        child: HappyEmptyState(
          icon: switch (source) {
            ChatSource.text => LucideIcons.pencilLine,
            ChatSource.voice => LucideIcons.mic,
            ChatSource.inspiration => LucideIcons.lightbulb,
          },
          title: l10n.storyChatEmptyTitle,
          description: switch ((source, seed)) {
            // 带着草稿进来：先把它原样读回去，再说页面还没就绪。
            (_, final String draft) when draft.isNotEmpty =>
              l10n.storyChatEmptyBodySeed(draft),
            (ChatSource.voice, _) => l10n.storyChatEmptyBodyVoice,
            (ChatSource.inspiration, _) => l10n.storyChatEmptyBodyInspiration,
            _ => l10n.storyChatEmptyBodyText,
          },
          actionLabel: l10n.storyChatEmptyAction,
          onAction: () => HappyToast.info(context, l10n.commonComingSoon),
        ),
      ),
    );
  }
}
