import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myplanner/data/repositories/planning_repository.dart';
import 'package:myplanner/domain/models/habit.dart';
import 'package:myplanner/domain/values/calendar_date.dart';
import 'package:myplanner/features/habits/habits_providers.dart';

/// Repository giả: giữ "dữ liệu server" trong bộ nhớ, cho test chặn `setDone` bằng Completer.
class FakeHabitRepository implements HabitRepository {
  FakeHabitRepository(this.server);
  Set<CalendarDate> server;
  Completer<void>? gate;
  int monthCalls = 0;

  @override
  Future<HabitMonth> month(String month, CalendarDate today) async {
    monthCalls++;
    return HabitMonth(
      month: month,
      from: CalendarDate(2026, 11, 1),
      to: CalendarDate(2026, 11, 30),
      percent: 0,
      habits: [
        HabitRow(
          id: 'h1',
          title: 'Đọc sách',
          order: 0,
          startDate: CalendarDate(2026, 11, 1),
          percent: 0,
          currentStreak: 0,
          longestStreak: 0,
          doneDates: {...server},
        ),
      ],
      days: const [],
    );
  }

  @override
  Future<void> setDone(String habitId, CalendarDate date, bool done) async {
    await gate?.future;
    done ? server.add(date) : server.remove(date);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final first = CalendarDate(2026, 11, 1);
  final day = CalendarDate(2026, 11, 5);

  ProviderContainer makeContainer(FakeHabitRepository repo) {
    final c = ProviderContainer(overrides: [habitRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(c.dispose);
    return c;
  }

  test('tick hiện ngay trên màn trước khi API trả về (optimistic)', () async {
    final repo = FakeHabitRepository({})..gate = Completer<void>();
    final c = makeContainer(repo);
    c.listen(habitMonthProvider(first), (_, _) {});
    await c.read(habitMonthProvider(first).future);

    final pending = c.read(habitMonthProvider(first).notifier).toggle('h1', day, true);

    // API vẫn đang chờ, nhưng state đã có ngày vừa tick.
    expect(c.read(habitMonthProvider(first)).value!.habits.single.doneDates, contains(day));
    expect(repo.server, isEmpty);

    repo.gate!.complete();
    await pending;
    expect(repo.server, contains(day));
  });

  test('ghi xong thì nạp lại từ backend để số liệu khớp server', () async {
    final repo = FakeHabitRepository({});
    final c = makeContainer(repo);
    c.listen(habitMonthProvider(first), (_, _) {});
    await c.read(habitMonthProvider(first).future);
    expect(repo.monthCalls, 1);

    await c.read(habitMonthProvider(first).notifier).toggle('h1', day, true);
    await c.read(habitMonthProvider(first).future);

    expect(repo.monthCalls, 2);
    expect(c.read(habitMonthProvider(first)).value!.habits.single.doneDates, {day});
  });
}
