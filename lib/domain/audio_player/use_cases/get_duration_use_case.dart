import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class GetDurationUseCase {
  const GetDurationUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Duration? call() => _audioPlayerRepository.getDuration();
}
