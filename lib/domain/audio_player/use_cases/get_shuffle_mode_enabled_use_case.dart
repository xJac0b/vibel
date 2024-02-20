import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class GetShuffleModeEnabledUseCase {
  const GetShuffleModeEnabledUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  bool call() => _audioPlayerRepository.shuffleModeEnabled;
}
