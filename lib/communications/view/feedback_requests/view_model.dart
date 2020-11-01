import 'package:Dia/communications/controller/services.dart';
import 'package:Dia/communications/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/src/widgets/framework.dart';


class FeedbackRequestsViewModel extends DiaViewModel {
  final CommunicationsServices _services = CommunicationsServices();
  List<FeedbackRequest> _feedbackRequests;

  FeedbackRequestsViewModel(State<StatefulWidget> state) : super(state);
  
  List<FeedbackRequest> get feedbackRequests {
    if(_feedbackRequests == null) {
      refreshFeedbackRequests();
      return [];
    }
    return _feedbackRequests;
  }

  Future<void> refreshFeedbackRequests() async {
    _feedbackRequests = await _services.getUnattendedFeedbackRequests();
    notifyChanges();
  }

}
