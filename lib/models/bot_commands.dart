import 'package:nyxx/nyxx.dart';
// import 'package:ygg_bot/models/graphql/queries.dart';
import 'package:ygg_bot/models/log_function.dart';

class BotCommands {
  static void commands(INyxxWebsocket bot) {
    // Listener for when a message is received
    bot.eventsWs.onMessageReceived.listen(
      (event) async {
        final content = event.message.content;

        if (event.message.author.bot) {
          // Ignore messages sent by bots
          return;
        }

        if (content.startsWith('y.help') && content.length <= 7) {
          // Respond with a help message
          final embed = EmbedBuilder(
            author: EmbedAuthorBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
              name: 'Ygg Bot',
            ),
            title: '- HELP -',
            description: "Under Development \n My PREFIX is \"y.\"",
            footer: EmbedFooterBuilder(
              iconUrl:
                  'https://cdn.discordapp.com/avatars/1129595664066691093/dc42349d840a8e79253da833a1c0d771.png?size=256',
              text: 'For more information, gzeloni',
            ),
          );

          try {
            await event.message.channel
                .sendMessage(MessageBuilder.embed(embed));
          } catch (e) {
            sendEmbedMessageErrorHandler(e, event, bot);
          }
        }

        if (content.startsWith('y.ping') && content.length <= 7) {
          // Respond with a pong message
          try {
            await event.message.channel
                .sendMessage(MessageBuilder.content('Pong!'));
          } catch (e) {
            sendEmbedMessageErrorHandler(e, event, bot);
          }
        }
      },
    );

    bot.eventsWs.onSelfMention.listen(
      (event) async {
        final content = event.message.content;
        if (content.startsWith('<') && content.length == 21) {
          // Respond with a help message when the bot is mentioned
          try {
            await event.message.channel.sendMessage(
                MessageBuilder.content("Digite y.help para ver meus comandos"));
          } catch (e) {
            sendEmbedMessageErrorHandler(e, event, bot);
          }
        } else {
          // Respond with a random text message
          try {
            await event.message.channel.sendMessage(
                MessageBuilder.content("Digite y.help para ver meus comandos"));
          } catch (e) {
            sendEmbedMessageErrorHandler(e, event, bot);
          }
        }
      },
    );
  }
}
