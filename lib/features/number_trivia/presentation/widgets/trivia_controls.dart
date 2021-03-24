import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_clean_architecture_resocoder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Digite um Numero',
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text('Buscar'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).accentColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: Text('Número Aleatório'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).accentColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    controller.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
