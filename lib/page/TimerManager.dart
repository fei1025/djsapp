import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

class TimerManager {
  int counter ;
  final StreamController<int> _controller = StreamController<int>.broadcast();
  Timer? _timer;
  VoidCallback? timerFinishCallback;
  TimerManager(this.counter);



  Stream<int> get stream => _controller.stream;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
        counter--;
        _controller.add(counter); // 发送更新
      } else {
        _timer?.cancel();
        _controller.close();
        timerFinishCallback?.call();
      }
    });
  }
  void stopTimer() {
    _timer?.cancel();
    _controller.close();
  }
}
