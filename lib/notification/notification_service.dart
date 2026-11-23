
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../home/task_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'kwajak_assignment_channel';

  // 알림 초기화
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // 콰작은 한국 사용자 기준으로 설정
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(settings: settings);

    // Android 13 이상 알림 권한 요청
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  // 과제 하나의 알림 ID 두 개를 생성
  static int _dayBeforeId(Assignment task) {
    return task.notificationId * 2;
  }

  static int _hourBeforeId(Assignment task) {
    return task.notificationId * 2 + 1;
  }

  // 과제 알림 예약
  static Future<void> scheduleTask(Assignment task) async {
    // 기존 알림 먼저 취소
    await cancelTask(task);

    // 완료된 과제는 알림 예약하지 않음
    if (task.completed) return;

    final now = DateTime.now();

    // 마감 하루 전
    final dayBefore = task.deadline.subtract(
      const Duration(days: 1),
    );

    // 마감 1시간 전
    final hourBefore = task.deadline.subtract(
      const Duration(hours: 1),
    );

    // 하루 전 알림
    if (dayBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _dayBeforeId(task),
        title: '📚 콰작! 과제 마감 하루 전',
        body: '${task.title} 과제 제출이 내일입니다! 미리 준비해 보세요.',
        scheduledDate: dayBefore,
      );
    }

    // 1시간 전 알림
    if (hourBefore.isAfter(now)) {
      await _scheduleNotification(
        id: _hourBeforeId(task),
        title: '⏰ 콰작! 마감 1시간 전',
        body: '${task.title} 과제 제출까지 1시간 남았습니다!',
        scheduledDate: hourBefore,
      );
    }
  }

  // 실제 알림 예약
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final scheduledTime = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        '콰작 과제 알림',
        channelDescription: '과제 마감기한을 알려주는 알림입니다.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // 과제에 해당하는 알림 모두 취소
  static Future<void> cancelTask(Assignment task) async {
    await _notifications.cancel(id: _dayBeforeId(task));
    await _notifications.cancel(id: _hourBeforeId(task));
  }

  // 과제 목록 전체 알림 복구
  static Future<void> rescheduleAll(List<Assignment> tasks) async {
    for (final task in tasks) {
      await scheduleTask(task);
    }
  }
}
