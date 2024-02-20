import 'package:just_audio/just_audio.dart';

extension LoopModeX on LoopMode {
  LoopMode next() => this == LoopMode.all
      ? LoopMode.off
      : LoopMode.values[LoopMode.values.indexOf(this) + 1];
}
