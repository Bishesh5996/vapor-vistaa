import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  Function()? _onShake;
  DateTime? _lastShakeTime;

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  Function(bool)? _onTilt;
  Function(String)? _onTabTilt;

  // Emulator fallback timers
  Timer? _emulatorShakeTimer;
  Timer? _emulatorTiltTimer;

  void initializeShakeDetector(Function() onShake) {
    _onShake = onShake;
    print('🔧 Initializing shake detector...');
    
    try {
      _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
        double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        
        if (acceleration > 15 && _isShakeValid()) {
          print('✅ SHAKE DETECTED! Acceleration: ${acceleration.toStringAsFixed(2)}');
          _lastShakeTime = DateTime.now();
          _onShake?.call();
        }
      });
    } catch (e) {
      print('⚠️ Physical sensors not available (emulator), using demo mode');
      _emulatorShakeTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        print('🎯 Demo shake triggered (emulator mode)');
        _onShake?.call();
      });
    }
  }

  void initializeTiltDetector(Function(bool) onTilt) {
    _onTilt = onTilt;
    print('🔧 Initializing tilt detector...');
    
    try {
      _gyroscopeSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
        double tiltIntensity = sqrt(event.x * event.x + event.y * event.y);
        bool isTilted = tiltIntensity > 2.0;
        _onTilt?.call(isTilted);
      });
    } catch (e) {
      print('⚠️ Physical sensors not available (emulator), using demo mode');
      bool demoTilted = false;
      _emulatorTiltTimer = Timer.periodic(Duration(seconds: 5), (timer) {
        demoTilted = !demoTilted;
        print('🎯 Demo tilt: $demoTilted (emulator mode)');
        _onTilt?.call(demoTilted);
      });
    }
  }

  /// 🆕 Tilt-based tab navigation (left/right)
  void initializeTabNavigation(Function(String direction) onTiltDirection) {
    _onTabTilt = onTiltDirection;
    print('🔧 Initializing tab navigation via gyroscope...');
    
    try {
      gyroscopeEvents.listen((GyroscopeEvent event) {
        if (event.y > 1.5) {
          print('➡️ Tilt detected: RIGHT');
          _onTabTilt?.call('right');
        } else if (event.y < -1.5) {
          print('⬅️ Tilt detected: LEFT');
          _onTabTilt?.call('left');
        }
      });
    } catch (e) {
      print('⚠️ Could not initialize tab navigation via sensors');
    }
  }

  bool _isShakeValid() {
    if (_lastShakeTime == null) return true;
    return DateTime.now().difference(_lastShakeTime!).inMilliseconds > 1500;
  }

  void dispose() {
    print('🔧 Disposing sensors...');
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _emulatorShakeTimer?.cancel();
    _emulatorTiltTimer?.cancel();
  }
}
