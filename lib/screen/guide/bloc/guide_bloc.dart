import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'guide_event.dart';

part 'guide_state.dart';

class HotGuideBloc extends GuideBloc {
  HotGuideBloc(Keylol client) : super(client, 'hot');
}

class DigestGuideBloc extends GuideBloc {
  DigestGuideBloc(Keylol client) : super(client, 'digest');
}

class NewThreadGuideBloc extends GuideBloc {
  NewThreadGuideBloc(Keylol client) : super(client, 'newthread');
}

class NewGuideBloc extends GuideBloc {
  NewGuideBloc(Keylol client) : super(client, 'new');
}

class SofaGuideBloc extends GuideBloc {
  SofaGuideBloc(Keylol client) : super(client, 'sofa');
}

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  final Keylol _client;
  final String _type;

  GuideBloc(this._client, this._type) : super(const GuideInitial()) {
    on<GuideRefreshed>(_onGuideRefreshed);
    on<GuideFetched>(_onGuideFetched);
  }

  Future<void> _onGuideRefreshed(
    GuideRefreshed event,
    Emitter<GuideState> emit,
  ) async {
    try {
      final guide = await _client.guide(_type, 1);
      final threads = guide.list;
      emit(state.copyWith(
        status: GuideStatus.success,
        threads: threads,
        page: 1,
        hasReachMax: 1 >= guide.count,
      ));
    } catch (e, stack) {
      logger.e('加载导读列表失败 type: $_type', e, stack);
      emit(state.copyWith(status: GuideStatus.failure));
    }
  }

  Future<void> _onGuideFetched(
    GuideFetched event,
    Emitter<GuideState> emit,
  ) async {
    if (state.hasReachMax) {
      return;
    }
    try {
      final page = state.page + 1;
      final guide = await _client.guide(_type, page);
      final threads = guide.list;
      emit(state.copyWith(
        status: GuideStatus.success,
        threads: state.threads..addAll(threads),
        page: page,
        hasReachMax: page < guide.count,
      ));
    } catch (e, stack) {
      logger.e('加载导读列表失败 type: $_type', e, stack);
      emit(state.copyWith(status: GuideStatus.failure));
    }
  }
}
