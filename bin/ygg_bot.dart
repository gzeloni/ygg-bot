// This is a file containing a "clean" version of example.dart, with comments stripped for
// readability.
// This file is generated automatically by scripts/generate_clean_example and should not be edited
// manually; edit example.dart and run scripts/generate_clean_example.

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:ygg_bot/config/config.dart';
import 'package:ygg_bot/models/graphql/queries.dart';

void main() {
  INyxxWebsocket client = NyxxFactory.createNyxxWebsocket(
    Config.getDiscordToken(),
    GatewayIntents.allUnprivileged | GatewayIntents.guildMembers,
  );

  CommandsPlugin commands = CommandsPlugin(
    prefix: (message) => '!',
    options: CommandsOptions(
      logErrors: true,
    ),
  );

  client.registerPlugin(commands);

  client
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions());

  client.connect();

  ChatCommand ping = ChatCommand(
    'ping',
    'Checks if the bot is online',
    id('ping', (IChatContext context) {
      context.respond(MessageBuilder.content('pong!'));
    }),
  );

  commands.addCommand(ping);

  const Converter<String> nonEmptyStringConverter =
      CombineConverter(stringConverter, filterInput);
  const Map<String, dynamic> choices = {
    'Skill': 'skill',
    'Items': 'items',
    'Status': 'status',
    'MP': 'mp'
  };
  ChatCommand user = ChatCommand(
      'user',
      'Returns the username and some stats',
      id('user', (
        IChatContext context,
        @UseConverter(nonEmptyStringConverter) String email,
      ) {
        Queries.userInfo(email, context);
      }),
      options: CommandOptions(defaultResponseLevel: ResponseLevel.private));

  commands.addCommand(user);

  ChatCommand wiki = ChatCommand(
    'wiki',
    'This is the wiki! Choose one of the options.',
    id('wiki', (
      IChatContext context,
      @Choices(choices) String option,
    ) {
      if (option == 'skill') {
        Queries.skills(context);
      } else if (option == 'status') {
        context.respond(MessageBuilder.content('status'));
      } else if (option == 'mp') {
        context.respond(MessageBuilder.content('MP'));
      } else if (option == 'items') {
        Queries.items(context);
      }
    }),
    options: CommandOptions(defaultResponseLevel: ResponseLevel.public),
  );

  commands.addCommand(wiki);
}

enum Shape {
  triangle,
  square,
  pentagon,
}

enum Dimension {
  twoD,
  threeD,
}

String? filterInput(String input, IContextData context) {
  if (input.isNotEmpty) {
    return input;
  }
  return null;
}
