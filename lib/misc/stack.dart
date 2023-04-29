class Stack<T> extends Iterable<T> {
  final List<T> _list = [];

  Stack({T? initial}) {
    if (initial == null) return;
    _list.add(initial);
  }

  void push(T val) => _list.add(val);
  T pop() => _list.removeLast();
  T peek() => _list.last;
  void replace(T val) {
    pop();
    push(val);
  }

  @override
  Iterator<T> get iterator => _list.iterator;

}
