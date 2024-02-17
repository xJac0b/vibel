import 'package:audioplayers/audioplayers.dart';
import 'package:injecteo/injecteo.dart';

@externalModule
abstract class AudioModule {
  @singleton
  AudioPlayer get audioPlayer => AudioPlayer();
}
