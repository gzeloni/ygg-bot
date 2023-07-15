import "package:nyxx/nyxx.dart";
import "package:ygg_bot/config/config.dart";
import "package:ygg_bot/models/bot_commands.dart";

void yggBot() {
  // Create Nyxx bot instance with necessary intents
  final bot = NyxxFactory.createNyxxWebsocket(
      Config.getDiscordToken(),
      GatewayIntents.allUnprivileged |
          GatewayIntents.allPrivileged |
          GatewayIntents.messageContent)
    ..registerPlugin(Logging());

  // Listener for when the bot is ready
  bot.eventsWs.onReady.listen((event) {
    print("Ready!");
  });

  // Register commands for the bot
  BotCommands.commands(bot);

  // Connect the bot to Discord
  bot.connect();
}
