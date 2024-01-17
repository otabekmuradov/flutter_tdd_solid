import '../../domain/entities/number_trivia.dart';

class NumberTriviaDto extends NumberTrivia {
  const NumberTriviaDto({
    required int number,
    required String text,
  }) : super(number: number, text: text);

  factory NumberTriviaDto.fromJson(Map<String, dynamic> json) {
    return NumberTriviaDto(
      number: (json['number'] as num).toInt(),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
