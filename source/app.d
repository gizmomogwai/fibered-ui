import dlangui;
mixin APP_ENTRY_POINT;
import core.thread;
import std.concurrency;
import std.stdio;
import core.time;

class MyFiber : Fiber {
  Widget w;
  this(Widget w) {
    super(&run);
    this.w = w;
  }

  void run() {
    writeln("run");
    auto startTime = Clock.currTime;
    while (Clock.currTime - startTime < dur!("seconds")(2)) {
      w.text = w.text ~ ".";
      writeln("run.");
      Fiber.yield();
      writeln("after fiber");
    }
    writeln("finished");
    writeln(w.text);
    w.text = w.text ~ " Done";
  }
}

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {
  // create window
  Window window = Platform.instance.createWindow("My Window", null);
  // create some widget to show in window
  window.mainWidget = new Button().text("Hello world"d).textColor(0xFF0000); // red text
  window.mainWidget.click = delegate (Widget w) {
    writeln("test");
    new MyFiber(w).call();
    return true;
  };
  // show window
  window.show();
  // run message loop
  return Platform.instance.enterMessageLoop();
}
