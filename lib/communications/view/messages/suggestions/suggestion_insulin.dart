import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/user_data/model/entities.dart';
import 'package:Dia/user_data/view/shared/insulin_injection_editor.dart';
import 'package:flutter/material.dart';

class InsulinSuggestionWidget extends StatefulWidget {
  final Suggestion suggestion;
  final bool isIgnored;

  InsulinSuggestionWidget(this.suggestion, this.isIgnored);

  @override
  State<StatefulWidget> createState() {
    return InsulinSuggestionWidgetState();
  }
}

class InsulinSuggestionWidgetState extends State<InsulinSuggestionWidget> {
  TextEditingController _controller;
  InsulinInjection _insulinInjection;

  @override
  void initState() {
    /*
    if suggestion is not editable, _finalInsulinInjection == _insulinInjection
    and we cannot clear _finalInsulinInjection


    El funcionamiento es como sigue. Se muestra el elemento como sería en el timeline
    Aparecerá un botón para editarlo en caso de ser editable.



    Y cómo manejas cancelable. ????


     */
    _insulinInjection = widget.suggestion.userDataEntity as InsulinInjection;
    _controller = TextEditingController(text: _insulinInjection.units.toString());
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(widget.suggestion.details),
        ),
        InsulinInjectionEditorWidget(
          externalController: _controller,
          insulinInjectionForEdition: widget.suggestion.userDataEntity as InsulinInjection,
          selfCloseCallback: (reload, [insulinInjection]) {
            if(insulinInjection == null) {
              setState(() {
                insulinInjection.reset();
              });
            }
          },
        ),
        // TODO if _finalInsulinInjection != null hay que mostrar el elemento con posibilidad de limpiarlo, si es editable, claro.
      ],
    );
  }
}
