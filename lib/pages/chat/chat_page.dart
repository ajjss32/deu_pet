import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  final StreamChatClient client;
  final Channel channel;

  const ChannelPage({
    Key? key,
    required this.client,
    required this.channel,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  }) : super(key: key);

  final int? initialScrollIndex;
  final double? initialAlignment;
  final bool highlightInitialMessage;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  FocusNode? _focusNode;
  final StreamMessageInputController _messageInputController =
      StreamMessageInputController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatThemeData(
      ownMessageTheme: StreamMessageThemeData(
        messageBackgroundColor: const Color(0xFF4A55CF),
        messageTextStyle: const TextStyle(color: Colors.white),
        messageBorderColor: const Color(0xFF434CB8),
      ),
      otherMessageTheme: StreamMessageThemeData(
        messageBackgroundColor: Colors.grey[100],
        messageTextStyle: const TextStyle(color: Colors.black),
        messageBorderColor: Colors.grey[200],
      ),
    );

    final petImage = widget.channel.extraData['pet_image'] as String?;
    
    final otherMember = widget.channel.state!.members.firstWhere(
      (member) => member.user?.id != widget.client.state.currentUser?.id,
      orElse: () => widget.channel.state!.members.first,
    );
    
    final lastActive = widget.channel.lastMessageAt ??
        DateTime.now().subtract(const Duration(days: 1));

    String formatLastSeen(DateTime date, String? name) {
      Duration difference = DateTime.now().difference(date);
      if (difference.inMinutes < 1) {
        return "${name ?? 'Usuário'} está online agora";
      } else if (difference.inHours < 1) {
        return "${name ?? 'Usuário'} visto por último há ${difference.inMinutes} min";
      } else if (difference.inDays < 1) {
        return "${name ?? 'Usuário'} visto por último há ${difference.inHours}h";
      } else {
        return "${name ?? 'Usuário'} visto por último há ${difference.inDays}d";
      }
    }

    return StreamChatTheme(
      data: theme,
      child: StreamChannel(
        channel: widget.channel,
        child: Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          appBar: AppBar(
            backgroundColor: Colors.grey[200],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF434CB8), width: 3),
                  ),
                  child: petImage != null && petImage.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(petImage),
                        )
                      : StreamChannelAvatar(channel: widget.channel),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.channel.name ?? 'Chat',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      formatLastSeen(lastActive, otherMember.user?.name),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    StreamMessageListView(
                      initialScrollIndex: widget.initialScrollIndex ?? 0,
                      initialAlignment: widget.initialAlignment ?? 0.0,
                      highlightInitialMessage: widget.highlightInitialMessage,
                      messageFilter: defaultFilter,
                      messageBuilder: (context, details, messages, defaultMessage) {
                        return defaultMessage.copyWith(
                          onReplyTap: _reply,
                          bottomRowBuilderWithDefaultWidget: (context, message, defaultWidget) {
                            return defaultWidget.copyWith(
                              deletedBottomRowBuilder: (context, message) {
                                return const StreamVisibleFootnote();
                              },
                            );
                          },
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        color: theme.colorTheme.appBg.withOpacity(.9),
                        child: StreamTypingIndicator(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          style: theme.textTheme.footnote.copyWith(
                            color: theme.colorTheme.textLowEmphasis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamMessageInput(
                focusNode: _focusNode,
                messageInputController: _messageInputController,
                onQuotedMessageCleared: _messageInputController.clearQuotedMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool defaultFilter(Message m) {
    final currentUser = widget.client.state.currentUser;
    if (currentUser == null || m.user == null) {
      return false;
    }
    final isMyMessage = m.user!.id == currentUser.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }
}
