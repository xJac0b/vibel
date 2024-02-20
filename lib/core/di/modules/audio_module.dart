import 'package:injecteo/injecteo.dart';
import 'package:just_audio/just_audio.dart';

@externalModule
abstract class AudioModule {
  @singleton
  AudioPlayer get audioPlayer => AudioPlayer();
}
