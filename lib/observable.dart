import 'package:flutter/widgets.dart';

class Observable<T> {
  Observable(T defaultValue) : _value = defaultValue;

  late T _value;
  T get value => _value;
  set value(T newValue) {
    _value = newValue;
    for (var listener in listeners) {
      listener.call();
    }
  }

  final List<VoidCallback> listeners = [];

  void addListener(VoidCallback listener) {
    listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    listeners.remove(listener);
  }
}

class Observer<T> extends StatefulWidget {
  final Observable<T> observes;
  final Widget Function(BuildContext context, T value) builder;

  const Observer({
    super.key,
    required this.observes,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => _ObserverState<T>();
}

class _ObserverState<T> extends State<Observer<T>> {
  late T value;
  late VoidCallback listener;

  @override
  void initState() {
    super.initState();
    value = widget.observes._value;
    _addListener();
  }

  @override
  void didUpdateWidget(Observer<T> oldWidget) {
    if (oldWidget.observes != widget.observes) {
      oldWidget.observes.removeListener(listener);
      value = widget.observes._value;
      _addListener();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.observes.removeListener(listener);
    super.dispose();
  }

  void _addListener() {
    listener = _valueChangesListener;
    widget.observes.addListener(listener);
  }

  void _valueChangesListener() => setState(() => value = widget.observes._value);

  @override
  Widget build(BuildContext context) => widget.builder(context, value);
}
