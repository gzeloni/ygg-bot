import "package:nyxx/nyxx.dart";
import "package:nyxx_commands/nyxx_commands.dart";
import "package:ygg_bot/models/graphql/queries.dart";

class SlashCommands {
  static const Converter<String> nonEmptyStringConverter =
      CombineConverter(stringConverter, filterInput);
  static const Map<String, dynamic> choices = {
    'Skill': 'skill',
    'Items': 'items',
    'Status': 'status',
    'MP': 'mp'
  };
  List<ChatCommand> chatCommands = [
    ChatCommand(
      'ping',
      'Checks if the bot is online',
      id('ping', (IChatContext context) {
        context.respond(MessageBuilder.content('pong!'));
      }),
    ),
    ChatCommand(
        'user',
        'Returns the username and some stats',
        id('user', (
          IChatContext context,
          @UseConverter(nonEmptyStringConverter) String email,
        ) {
          Queries.userInfo(email, context);
        }),
        options: CommandOptions(defaultResponseLevel: ResponseLevel.private)),
    ChatCommand(
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
        options: CommandOptions(defaultResponseLevel: ResponseLevel.public))
  ];

  CommandsPlugin commands = CommandsPlugin(
    prefix: (message) => '<<',
    options: CommandsOptions(
      logErrors: true,
    ),
  );

  void slashCommands() {
    for (ChatCommand command in chatCommands) {
      commands.addCommand(command);
    }
  }

  static String? filterInput(String input, IContextData context) {
    if (input.isNotEmpty) {
      return input;
    }
    return null;
  }
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
