import 'package:stack_trace/stack_trace.dart';
import "package:path/path.dart";

bool verbose = false;
Stopwatch _timer;
bool fail;

start() {
  _timer = new Stopwatch();
  fail = false;
}

end() {
  if (fail) {
    print("Fail\t${_timer.elapsedMilliseconds / 1000}s");
  }
}

class T {
  T();
  List<String> errors = [];
  error(Object object) {
    final frame = Trace.current().frames[1];
    final file = basename(frame.uri.toString());
    final line = frame.line;
    errors.add("$file:$line: $object");
    fail = true;
  }
}

typedef F(T t);

run(String name, F f) async {
  if (verbose) {
    print("=== Run: $name\n");
  }
  final timer = new Stopwatch();
  timer.start();
  final t = T();
  await f(t);
  final elapsed = "(${timer.elapsedMilliseconds / 1000}s)";
  if (t.errors.length == 0) {
    if (verbose) {
      print("--- PASS: $name $elapsed\n");
    }
  } else {
    print("--- FAIL: $name $elapsed\n");
    for (var err in t.errors) {
      print("\t$err\n");
    }
  }
}
