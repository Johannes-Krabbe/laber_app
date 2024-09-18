import 'dart:async';
import 'package:laber_app/api/repositories/message_repository.dart';
import 'package:laber_app/isar.dart';
import 'package:laber_app/store/repositories/outgoing_message_repository.dart';
import 'package:laber_app/store/types/outgoing_message.dart';
import 'package:laber_app/utils/interval_executer.dart';

const maxRetries = 3;
const sendinInterval = Duration(seconds: 1);
const retryInterval = Duration(seconds: 10);

class MessageSendService {
  StreamSubscription<void>? _outgoingMessageSubscription;
  IntervalExecutor? _retryIntervalExecutor;
  IntervalExecutor? _sendIntervalExecutor;

  Future<void> start() async {
    // watch database
    /*
    final isar = await getIsar();
    _outgoingMessageSubscription = isar.outgoingMessages.watchLazy().listen(
      (_) async {
        final pendnig = await OutgoingMessageRepository.getPending();
        if (pendnig.isEmpty) return;
        print('Sending ${pendnig.length} pending messages');
        for (final message in pendnig) {
          await sendMessage(message);
        }
      },
    );
    */

    _sendIntervalExecutor = IntervalExecutor(
      interval: sendinInterval,
      callback: () async {
        final pendnig = await OutgoingMessageRepository.getPending();
        if (pendnig.isEmpty) return;
        print('Sending ${pendnig.length} pending messages');
        for (final message in pendnig) {
          await sendMessage(message);
        }
      },
    );

    _sendIntervalExecutor?.start();

    // retry failed messages with interval
    _retryIntervalExecutor = IntervalExecutor(
      interval: retryInterval,
      callback: () async {
        final retryable = await OutgoingMessageRepository.getRetryable();
        if (retryable.isEmpty) return;
        print('Retrying ${retryable.length} retryable messages');
        for (final message in retryable) {
          await sendMessage(message);
        }
      },
    );

    _retryIntervalExecutor?.start();
  }

  Future<void> stop() async {
    await _outgoingMessageSubscription?.cancel();
    _retryIntervalExecutor?.stop();
    _sendIntervalExecutor?.stop();
  }

  Future<void> sendMessage(OutgoingMessage message) async {
    final messageRepository = MessageRepository();
    try {
      final messagePostRes = await messageRepository.postNew(message);
      if (messagePostRes.status != 201) {
        throw Exception(
            'Failed to send message: ${messagePostRes.status} ${messagePostRes.body?.message}');
      }
      await handleSuccess(message);
    } catch (e) {
      print('Failed to send message: $e');
      await handleFailed(message);
    }
  }

  Future<void> handleFailed(OutgoingMessage message) async {
    message.retryCount = message.retryCount + 1;

    if (message.retryCount >= maxRetries) {
      message
        ..status = OutgoingStatus.failed
        ..failedAt = DateTime.now();
    } else {
      message.status = OutgoingStatus.retrying;
    }

    final isar = await getIsar();
    await isar.writeTxn(() async {
      await isar.outgoingMessages.put(message);
    });
  }

  Future<void> handleSuccess(OutgoingMessage message) async {
    final isar = await getIsar();
    message
      ..status = OutgoingStatus.sent
      ..sentAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.outgoingMessages.put(message);
    });
  }
}
