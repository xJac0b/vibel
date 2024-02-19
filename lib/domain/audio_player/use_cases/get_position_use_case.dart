import 'package:injecteo/injecteo.dart';
import 'package:vibel/domain/audio_player/audio_player_repository.dart';

@inject
class GetPositionUseCase {
  const GetPositionUseCase(this._audioPlayerRepository);

  final AudioPlayerRepository _audioPlayerRepository;

  Future<Duration?> call() async => await _audioPlayerRepository.getPosition();
}
