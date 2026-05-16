
class EventMessage{
  int what = 0;
  dynamic data;

  EventMessage(this.what, {this.data});
}

mixin IEvent{
  bool onEvent(EventMessage msg);
}

