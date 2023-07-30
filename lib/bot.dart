import "package:nyxx/nyxx.dart";
import "package:ygg_bot/config/config.dart";
import "package:ygg_bot/models/bot_commands.dart";
import "package:ygg_bot/models/slash_commands.dart";

void yggBot() {
  final commands = SlashCommands();
  // Create Nyxx bot instance with necessary intents
  final bot = NyxxFactory.createNyxxWebsocket(
      Config.getDiscordToken(),
      GatewayIntents.allUnprivileged |
          GatewayIntents.allPrivileged |
          GatewayIntents.messageContent)
    ..registerPlugin(Logging())
    ..registerPlugin(commands.commands);

  commands.slashCommands();
  // Listener for when the bot is ready
  bot.eventsWs.onReady.listen((event) {
    print("Ready!");
  });

  // Register commands for the bot
  BotCommands.commands(bot);

  // Connect the bot to Discord
  bot.connect();
}
