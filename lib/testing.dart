import 'package:stack_trace/stack_trace.dart';
import "package:path/path.dart";

bool verbose = false;
int count = 0;
int errorCount = 0;

class T {
  T();
  List<String> errors = [];
  error(Object object) {
    final frame = Trace.current().frames[1];
    final file = basename(frame.uri.toString());
    final line = frame.line;
    errors.add("    $file:$line: $object");
    errorCount += 1;
  }
}

typedef Test(T t);

run(String name, Test f) async {
  count += 1;
  final t = T();
  var run = "";
  if (verbose) {
    run = "\n=== Run: $name";
  }

  final stopwatch = new Stopwatch();
  stopwatch.start();
  await f(t);
  final elapsed = "(${stopwatch.elapsedMilliseconds / 1000}s)";
  if (t.errors.length == 0) {
    if (verbose) {
      print("$run\n--- PASS: $name $elapsed");
    }
  } else {
    print("$run\n--- FAIL: $name $elapsed\n${t.errors.join("\n")}");
  }
}
