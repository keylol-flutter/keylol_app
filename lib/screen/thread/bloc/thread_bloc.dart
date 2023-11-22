import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';

part 'thread_event.dart';

part 'thread_state.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  final Keylol _client;
  final FavoriteRepository _favoriteRepository;
  final String _tid;

  ThreadBloc(this._client, this._favoriteRepository, this._tid)
      : super(ThreadInitial()) {
    on<ThreadRefreshed>(_onThreadRefreshed);
    on<ThreadFetched>(_onThreadFetched);
    on<ThreadReplied>(_onReplied);
    on<ThreadFavored>(_onThreadFavored);
    on<ThreadUnFavored>(_onThreadUnFavored);
  }

  Future<void> _onThreadRefreshed(
    ThreadRefreshed event,
    Emitter<ThreadState> emit,
  ) async {
    try {
      final viewThreadResp = await _client.viewThread(_tid, 1);
      final viewThread = viewThreadResp.variables;
      final thread = viewThread.thread;
      final poll = viewThread.specialPoll;

      final message = viewThreadResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: ThreadStatus.failure,
          thread: thread,
          message: message.messageStr,
          poll: poll,
        ));
        return;
      }

      final postList = viewThread.postList;
      final firstPost = postList.isNotEmpty ? postList[0] : null;
      final posts = postList.isNotEmpty ? postList.sublist(1) : <Post>[];
      final comments = viewThread.comments;

      var favored = false;
      try {
        favored = await _favoriteRepository.favored(_tid);
      } catch (e, stack) {
        logger.e('获取帖子是否收藏失败', e, stack);
      }

      emit(state.copyWith(
        status: ThreadStatus.success,
        thread: thread,
        favored: favored,
        firstPost: firstPost,
        page: 1,
        posts: posts,
        comments: comments,
        hasReachMax: posts.length >= thread.replies,
        poll: poll,
      ));
    } catch (e, stack) {
      logger.e('加载帖子失败', e, stack);
      emit(state.copyWith(status: ThreadStatus.failure));
    }
  }

  Future<void> _onThreadFetched(
    ThreadFetched event,
    Emitter<ThreadState> emit,
  ) async {
    if (state.hasReachMax) {
      return;
    }
    try {
      final page = state.page + 1;

      final viewThreadResp = await _client.viewThread(_tid, page);
      final message = viewThreadResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: ThreadStatus.failure,
          message: message.messageStr,
        ));
        return;
      }

      final viewThread = viewThreadResp.variables;
      final thread = viewThread.thread;
      final postList = viewThread.postList;
      final comments = viewThread.comments;
      final posts = state.posts;
      for (var post in postList) {
        if (!posts.any((p) => p.pid == post.pid)) {
          posts.add(post);
        }
      }

      emit(state.copyWith(
        status: ThreadStatus.success,
        thread: thread,
        page: page,
        posts: posts,
        comments: comments,
        hasReachMax: posts.length + 1 >= thread.replies,
      ));
    } catch (e, stack) {
      logger.e('加载帖子失败', e, stack);
      emit(state.copyWith(status: ThreadStatus.failure));
    }
  }

  Future<void> _onReplied(
    ThreadReplied event,
    Emitter<ThreadState> emit,
  ) async {
    try {
      final sendReplyResp = await _client.sendReply(
        event.formHash,
        _tid,
        event.message,
        event.aIds,
        event.post,
      );
      final message = sendReplyResp.message;

      var page = state.page;
      final posts = state.posts;
      var hasReachMax = false;
      var thread = state.thread;

      while (!hasReachMax) {
        final viewThreadResp = await _client.viewThread(_tid, ++page);
        final message = viewThreadResp.message;
        if (message != null) {
          emit(state.copyWith(
            status: ThreadStatus.failure,
            message: message.messageStr,
          ));
          return;
        }

        final viewThread = viewThreadResp.variables;
        thread = viewThread.thread;
        final postList = viewThread.postList;
        for (var post in postList) {
          if (post.position == state.firstPost?.position) {
            continue;
          }
          if (!posts.any((p) => p.pid == post.pid)) {
            posts.add(post);
          }
        }

        hasReachMax = posts.length + 1 >= thread.replies;
      }

      emit(state.copyWith(
        status: ThreadStatus.success,
        thread: thread,
        pid: posts[posts.length - 1].pid,
        page: page,
        posts: posts,
        hasReachMax: hasReachMax,
      ));
    } catch (e, stack) {
      logger.e('回复帖子失败', e, stack);
      emit(state.copyWith(status: ThreadStatus.failure));
    }
  }

  Future<void> _onThreadFavored(
    ThreadFavored event,
    Emitter<ThreadState> emit,
  ) async {
    await _favoriteRepository.add(_tid, event.description, event.formHash);

    final favored = await _favoriteRepository.favored(_tid);

    emit(state.copyWith(
      favored: favored,
    ));
  }

  Future<void> _onThreadUnFavored(
    ThreadUnFavored event,
    Emitter<ThreadState> emit,
  ) async {
    await _favoriteRepository.remove(_tid, event.formHash);

    final favored = await _favoriteRepository.favored(_tid);

    emit(state.copyWith(
      favored: favored,
    ));
  }
}
