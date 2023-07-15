import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:ygg_bot/config/config.dart';

class Queries {
  String queryName;
  IMessageReceivedEvent event;
  INyxxWebsocket bot;
  Queries({required this.queryName, required this.bot, required this.event});

  void query() async {
    String url = Config.getUrl();
    //GraphQL queries
    final Map<String, String> queries = {
      'skills':
          '{ skills { skillId name spCost power range description classes epCost  } } '
    };

    // Verify if the queryName exists
    if (!queries.containsKey(queryName)) {
      await event.message.channel
          .sendMessage(MessageBuilder.content('Opção inválida!'));
      return;
    }

    final String query = queries[queryName]!;

    // POST
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query': query,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      await event.message.channel
          .sendMessage(MessageBuilder.content(data.toString()));
    } else {
      await event.message.channel.sendMessage(MessageBuilder.content(
          'Falha na solicitação: ${response.statusCode}'));
    }
  }
}
