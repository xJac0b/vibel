import 'package:injecteo/injecteo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class SetAudioSourceUseCase {
  const SetAudioSourceUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<void> call(List<SongModel> songs) async =>
      await _audioPlayerRepository.setAudioSource(songs);
}
