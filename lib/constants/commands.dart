import 'package:nyxx/nyxx.dart';
import 'package:ygg_bot/models/lexer.dart';

typedef CommandAction = void Function(List<Token> tokens,
    Map<String, String> flags, INyxxWebsocket bot, IMessageReceivedEvent event);

final commandMap = {
  'y.wiki': (tokens, flags, bot, event) async {
    print('Comando y.wiki executado com os seguintes tokens: $tokens');
    print('Flags: $flags');
    try {
      await event.message.channel.sendMessage(MessageBuilder.content(
          'Comando y.wiki executado com os seguintes tokens: $tokens'));
    } catch (e) {
      print(e);
    }
  },
};
