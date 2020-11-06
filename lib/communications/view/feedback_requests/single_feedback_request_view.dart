import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/font_sizes.dart';
import 'package:Dia/shared/view/utils/theme.dart';
import 'package:flutter/material.dart';

class FeedbackRequestWidget extends StatefulWidget {
  final FeedbackRequest request;
  final Function(bool) onFinish;

  FeedbackRequestWidget({@required this.request, @required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return FeedbackRequestWidgetState();
  }
}


class FeedbackRequestWidgetState extends State<FeedbackRequestWidget> {
  String _answer;
  TextEditingController _controller;
  String _validationError;

  CommunicationsServices _services = CommunicationsServices();

  bool get isFreeAnswer {
    return widget.request.options == null;
  }

  @override
  void initState() {
    if(isFreeAnswer)
      _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(widget.request.title, style: TextStyle(fontSize: smallSize(context))),
          SizedBox(height: 16),
          Text(widget.request.text, style: TextStyle(fontSize: smallSize(context))),
          SizedBox(height: 12),
          if(!isFreeAnswer)
            for(String option in widget.request.options)
              RadioListTile(
                value: option,
                groupValue: _answer,
                title: Text(option),
                onChanged: (currentUser) {
                  setState(() {
                    _answer = option;
                  });
                },
                selected: option == _answer,
                activeColor: DiaTheme.primaryColor,
              ),
          if(isFreeAnswer)
            TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: bigSize(context), fontWeight: FontWeight.w300),
              controller: _controller,
              keyboardType: widget.request.answerTypeHint == AnswerTypeHint.NUMERICAL ? TextInputType.number : TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _answer = value;
                });
              },
            ),
          if(isFreeAnswer && _validationError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Text(_validationError, style: TextStyle(color: Colors.red)),
            ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                child: Text('Ignore'),
                onPressed: () async {
                  await _services.ignoreFeedbackRequest(widget.request);
                  widget.onFinish(false);
                },
              ),
              SizedBox(width: 16),
              FlatButton(
                child: Text('Ok'),
                onPressed: _answer == null ? null : () async {
                  try {
                    await _services.attendFeedbackRequest(widget.request, _answer);
                    widget.onFinish(true);
                  } on BackendBadRequest catch (err) {
                    // Validation errors
                    setState(() {
                      _validationError = err.toString();
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
