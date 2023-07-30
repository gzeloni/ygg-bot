import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:ygg_bot/config/config.dart';
import 'package:ygg_bot/models/log_function.dart';
import 'package:intl/intl.dart';

class Queries {
  static final url = Config.getUrl();
  static void userInfo(String? email, IChatContext context) async {
    if (!isValidEmail(email)) {
      await context.respond(
          MessageBuilder.content('Você precisa fornecer um email válido!'));
      return;
    }

    final url = Config.getUrl();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query':
            '{ user(email: "$email") { username characters { name lv currentHp currentSp } isActive lastLogin } }'
      }),
    );

    if (response.statusCode != 200) {
      await context.respond(MessageBuilder.content(
          'Falha na solicitação: ${response.statusCode}'));
      return;
    }

    final data = jsonDecode(response.body);
    final userData = data['data']['user'];
    DateTime now = DateTime.parse(userData['lastLogin']);
    DateFormat formatter = DateFormat('hh:mm - dd/MM/yyyy');
    String formatted = formatter.format(now);
    final embed = EmbedBuilder(
      author: EmbedAuthorBuilder(
        iconUrl:
            'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
        name: 'Ygg Bot',
      ),
      title: '- User Info -',
      description:
          'Name: ${userData['username']} \nCharacter Name: ${userData['characters'][0]['name']} \nCharacter lvl: ${userData['characters'][0]['lv']} \nCurrent HP: ${userData['characters'][0]['currentHp']} \nCurrent SP: ${userData['characters'][0]['currentSp']} \nOnline: ${userData['isActive']} \nLast Login: $formatted',
      footer: EmbedFooterBuilder(
        iconUrl:
            'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
      ),
    );
    await context.respond(MessageBuilder.embed(embed));
  }

  static void skills(IChatContext context) async {
    final url = Config.getUrl();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query':
            '{ skills { name spCost power range description classes epCost } }'
      }),
    );

    if (response.statusCode != 200) {
      await context.respond(MessageBuilder.content(
          'Falha na solicitação: ${response.statusCode}'));
      return;
    }

    final data = jsonDecode(response.body);
    List<dynamic> skills = data['data']['skills'];
    Duration duration = Duration(minutes: 2);
    int i = 0;

    try {
      while (i >= 0 && i < skills.length) {
        var skill = skills[i];
        var options = await context.getConfirmation(
          MessageBuilder.embed(EmbedBuilder(
            author: EmbedAuthorBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
              name: 'Ygg Bot',
            ),
            title: '- Skills -',
            description:
                'Name: ${skill['name']} \nSP Cost: ${skill['spCost']} \nPower: ${skill['power']} \nRange: ${skill['range']} \nDescription: ${skill['description']} \nEP Cost: ${skill['epCost']}',
            footer: EmbedFooterBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
            ),
          )),
          values: {true: 'Anterior', false: 'Próximo'},
          styles: {true: ButtonStyle.secondary, false: ButtonStyle.primary},
          level: ResponseLevel.public,
          timeout: duration,
          authorOnly: true,
        );
        if (options == true && i != 0) {
          i--;
        } else {
          i++;
        }
      }
    } catch (e) {
      logError(e, 'errors/errors.log');
    }
  }

  static void items(IChatContext context) async {
    final url = Config.getUrl();
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query':
            '{ items { name kind effect { targetAttributes duration value condition  } count description buyPrice sellPrice } }'
      }),
    );

    if (response.statusCode != 200) {
      await context.respond(MessageBuilder.content(
          'Falha na solicitação: ${response.statusCode}'));
      return;
    }

    final data = jsonDecode(response.body);
    List<dynamic> items = data['data']['items'];
    Duration duration = Duration(minutes: 2);
    int i = 0;

    try {
      while (i >= 0 && i < items.length) {
        var item = items[i];
        String name = item['name'] ?? 'NaN';
        String kind = item['kind'] ?? 'NaN';
        dynamic itemDuration =
            item['effect'] != null ? item['effect']['duration'] ?? 0 : 'NaN';
        dynamic value =
            item['effect'] != null ? item['effect']['value'] ?? 0.0 : 'NaN';
        dynamic condition =
            item['effect'] != null ? item['effect']['condition'] ?? 0 : 'NaN';
        int count = item['count'] ?? 0;

        var options = await context.getConfirmation(
          MessageBuilder.embed(EmbedBuilder(
            author: EmbedAuthorBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
              name: 'Ygg Bot',
            ),
            title: '- Skills -',
            description:
                'Name: $name \nKind: $kind \nDuration: $itemDuration \nValue: $value \nCondition: $condition \nCount: $count \nDescription: ${item['description']} \nBuy Price: ${item['buyPrice']} \nSell Price: ${item['sellPrice']}',
            footer: EmbedFooterBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
            ),
          )),
          values: {true: 'Anterior', false: 'Próximo'},
          styles: {true: ButtonStyle.secondary, false: ButtonStyle.primary},
          level: ResponseLevel.public,
          timeout: duration,
          authorOnly: true,
        );
        if (options == true && i != 0) {
          i--;
        } else {
          i++;
        }
      }
    } catch (e) {
      logError(e, 'errors/errors.log');
    }
  }

  static bool isValidEmail(String? email) {
    return email != null && email.contains('@');
  }
}
