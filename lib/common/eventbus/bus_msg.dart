
class EventMessage{
  int what = 0;
  dynamic data;
}


mixin IEvent{
  bool onEvent(EventMessage msg);
}

