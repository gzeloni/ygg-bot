import 'package:nyxx/nyxx.dart';

class Token {
  final String type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() => 'Token($type, $value)';
}

typedef CommandAction = void Function(List<Token> tokens,
    Map<String, String> flags, INyxxWebsocket bot, IMessageReceivedEvent event);

class Lexer {
  final String input;
  int position = 0;

  Lexer(this.input);

  List<Token> tokenize() {
    final tokens = <Token>[];

    while (!isEndOfFile()) {
      final currentChar = input[position];
      final isFlag = (currentChar == '-');
      final pattern = isFlag ? r'-[a-zA-Z]+' : r'[^- ]+';
      final token = extract(pattern);
      tokens.add(Token(isFlag ? 'FLAG' : 'TOKEN', token));
    }

    return tokens;
  }

  String extract(String pattern) {
    final endPosition = input.indexOf(' ', position + 1);
    final extracted = endPosition != -1
        ? input.substring(position, endPosition)
        : input.substring(position);
    position += extracted.length + 1;
    return extracted;
  }

  bool isEndOfFile() => position >= input.length;
}

class CommandInterpreter {
  final Map<String, CommandAction> commands;

  CommandInterpreter(this.commands);

  void executeCommand(
      String input, INyxxWebsocket bot, IMessageReceivedEvent event) {
    final lexer = Lexer(input);
    final tokens = lexer.tokenize();

    final command = tokens.isNotEmpty ? tokens[0].value : '';

    if (commands.containsKey(command)) {
      final commandAction = commands[command];
      final flags = extractFlags(tokens);
      commandAction!(tokens, flags, bot, event);
    } else {
      print('Comando não reconhecido: $command');
    }
  }

  Map<String, String> extractFlags(List<Token> tokens) {
    final flags = <String, String>{};
    String? currentFlag;

    for (var i = 1; i < tokens.length; i++) {
      final token = tokens[i];
      if (token.type == 'FLAG') {
        currentFlag = token.value.substring(1);
        flags[currentFlag] = '';
      } else if (currentFlag != null) {
        flags[currentFlag] = token.value;
        currentFlag = null;
      }
    }

    return flags;
  }
}
