import 'package:deu_pet/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatelessWidget {
  final StreamChatClient client;

  const ChannelListPage({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
      data: StreamChatThemeData.light(),
      child: Scaffold(
        backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
        body: StreamChannelListView(
          controller: StreamChannelListController(
            client: client,
            filter: Filter.in_(
              'members',
              [client.state.currentUser!.id],
            ),
            limit: 30,
          ),
          emptyBuilder: (context) {
            return Center(
              child: Text(
                'NENHUM MATCH REALIZADO',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          },
          itemBuilder: (context, channels, index, defaultTile) {
            final channel = channels[index];

            final otherMember = channel.state!.members.firstWhere(
              (member) => member.user?.id != client.state.currentUser?.id,
              orElse: () => channel.state!.members.first,
            );

            final petImage = channel.extraData['pet_image'] as String?;

            final isFirstItem = index == 0;

            return Column(
              children: [
                if (isFirstItem) Divider(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreamChannel(
                          channel: channel,
                          child: ChannelPage(client: client, channel: channel),
                        ),
                      ),
                    );
                  },
                  child: StreamChannelListTile(
                    channel: channel,
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color(0xFF434CB8), width: 3),
                      ),
                      child: (petImage != null && petImage.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(petImage),
                            )
                          : StreamChannelAvatar(channel: channel),
                    ),
                    title: Text(
                      channel.name ?? otherMember.user?.name ?? 'Nome do Canal',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: defaultTile.subtitle,
                    trailing: defaultTile.trailing,
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
