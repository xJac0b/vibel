import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class GetCurrentIndexUseCase {
  const GetCurrentIndexUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  int? call() => _audioPlayerRepository.currentIndex;
}
