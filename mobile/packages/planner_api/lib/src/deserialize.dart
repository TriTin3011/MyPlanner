import 'package:planner_api/src/model/area_summary_dto.dart';
import 'package:planner_api/src/model/avatar_dto.dart';
import 'package:planner_api/src/model/backup_dto.dart';
import 'package:planner_api/src/model/count_dto.dart';
import 'package:planner_api/src/model/create_year_item_request.dart';
import 'package:planner_api/src/model/current_user_dto.dart';
import 'package:planner_api/src/model/day_note_dto.dart';
import 'package:planner_api/src/model/day_progress_dto.dart';
import 'package:planner_api/src/model/deadline_dto.dart';
import 'package:planner_api/src/model/goal_board_dto.dart';
import 'package:planner_api/src/model/goal_card_dto.dart';
import 'package:planner_api/src/model/goal_dto.dart';
import 'package:planner_api/src/model/goal_step_dto.dart';
import 'package:planner_api/src/model/google_login_request.dart';
import 'package:planner_api/src/model/habit_day_count_dto.dart';
import 'package:planner_api/src/model/habit_dto.dart';
import 'package:planner_api/src/model/habit_highlight_dto.dart';
import 'package:planner_api/src/model/habit_log_dto.dart';
import 'package:planner_api/src/model/habit_month_dto.dart';
import 'package:planner_api/src/model/habit_month_row_dto.dart';
import 'package:planner_api/src/model/health_dto.dart';
import 'package:planner_api/src/model/import_result_dto.dart';
import 'package:planner_api/src/model/login_request.dart';
import 'package:planner_api/src/model/login_response.dart';
import 'package:planner_api/src/model/materialize_request.dart';
import 'package:planner_api/src/model/move_backlog_request.dart';
import 'package:planner_api/src/model/problem_details.dart';
import 'package:planner_api/src/model/recurring_task_dto.dart';
import 'package:planner_api/src/model/register_request.dart';
import 'package:planner_api/src/model/reorder_request.dart';
import 'package:planner_api/src/model/reorder_tasks_request.dart';
import 'package:planner_api/src/model/reorder_year_items_request.dart';
import 'package:planner_api/src/model/save_goal_request.dart';
import 'package:planner_api/src/model/save_goal_step_request.dart';
import 'package:planner_api/src/model/save_habit_request.dart';
import 'package:planner_api/src/model/save_note_request.dart';
import 'package:planner_api/src/model/save_recurring_request.dart';
import 'package:planner_api/src/model/save_task_request.dart';
import 'package:planner_api/src/model/save_year_meta_request.dart';
import 'package:planner_api/src/model/seed_request.dart';
import 'package:planner_api/src/model/set_done_request.dart';
import 'package:planner_api/src/model/stats_dto.dart';
import 'package:planner_api/src/model/stats_goal_area_dto.dart';
import 'package:planner_api/src/model/stats_goal_status_dto.dart';
import 'package:planner_api/src/model/stats_goals_dto.dart';
import 'package:planner_api/src/model/stats_habit_dto.dart';
import 'package:planner_api/src/model/stats_heatmap_day_dto.dart';
import 'package:planner_api/src/model/stats_hero_dto.dart';
import 'package:planner_api/src/model/stats_kpis_dto.dart';
import 'package:planner_api/src/model/stats_trend_dto.dart';
import 'package:planner_api/src/model/stats_week_point_dto.dart';
import 'package:planner_api/src/model/stats_weekday_dto.dart';
import 'package:planner_api/src/model/subtask_dto.dart';
import 'package:planner_api/src/model/subtask_input.dart';
import 'package:planner_api/src/model/task_dto.dart';
import 'package:planner_api/src/model/today_dashboard_dto.dart';
import 'package:planner_api/src/model/today_habit_dto.dart';
import 'package:planner_api/src/model/update_profile_request.dart';
import 'package:planner_api/src/model/update_year_item_request.dart';
import 'package:planner_api/src/model/validation_problem_details.dart';
import 'package:planner_api/src/model/week_dashboard_dto.dart';
import 'package:planner_api/src/model/week_delete_result_dto.dart';
import 'package:planner_api/src/model/week_note_dto.dart';
import 'package:planner_api/src/model/week_progress_dto.dart';
import 'package:planner_api/src/model/year_dashboard_dto.dart';
import 'package:planner_api/src/model/year_meta_dto.dart';
import 'package:planner_api/src/model/year_month_dto.dart';
import 'package:planner_api/src/model/year_plan_item_dto.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AreaSummaryDto':
          return AreaSummaryDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AvatarDto':
          return AvatarDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BackupDto':
          return BackupDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CountDto':
          return CountDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateYearItemRequest':
          return CreateYearItemRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CurrentUserDto':
          return CurrentUserDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DayNoteDto':
          return DayNoteDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DayProgressDto':
          return DayProgressDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeadlineDto':
          return DeadlineDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeadlineKind':
          
          
        case 'GoalBoardDto':
          return GoalBoardDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoalCardDto':
          return GoalCardDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoalDto':
          return GoalDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoalStatus':
          
          
        case 'GoalStepDto':
          return GoalStepDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoogleLoginRequest':
          return GoogleLoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitDayCountDto':
          return HabitDayCountDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitDto':
          return HabitDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitHighlightDto':
          return HabitHighlightDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitLogDto':
          return HabitLogDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitMonthDto':
          return HabitMonthDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HabitMonthRowDto':
          return HabitMonthRowDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HealthDto':
          return HealthDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ImportResultDto':
          return ImportResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LifeArea':
          
          
        case 'LoginRequest':
          return LoginRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LoginResponse':
          return LoginResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MaterializeRequest':
          return MaterializeRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MoveBacklogRequest':
          return MoveBacklogRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProblemDetails':
          return ProblemDetails.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecurringTaskDto':
          return RecurringTaskDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RegisterRequest':
          return RegisterRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReorderRequest':
          return ReorderRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReorderTasksRequest':
          return ReorderTasksRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReorderYearItemsRequest':
          return ReorderYearItemsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveGoalRequest':
          return SaveGoalRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveGoalStepRequest':
          return SaveGoalStepRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveHabitRequest':
          return SaveHabitRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveNoteRequest':
          return SaveNoteRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveRecurringRequest':
          return SaveRecurringRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveTaskRequest':
          return SaveTaskRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SaveYearMetaRequest':
          return SaveYearMetaRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SeedRequest':
          return SeedRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SetDoneRequest':
          return SetDoneRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsDto':
          return StatsDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsGoalAreaDto':
          return StatsGoalAreaDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsGoalStatusDto':
          return StatsGoalStatusDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsGoalsDto':
          return StatsGoalsDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsHabitDto':
          return StatsHabitDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsHeatmapDayDto':
          return StatsHeatmapDayDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsHeroDto':
          return StatsHeroDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsKpisDto':
          return StatsKpisDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsTrendDto':
          return StatsTrendDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsWeekPointDto':
          return StatsWeekPointDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatsWeekdayDto':
          return StatsWeekdayDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubtaskDto':
          return SubtaskDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubtaskInput':
          return SubtaskInput.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TaskDto':
          return TaskDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TaskTag':
          
          
        case 'TodayDashboardDto':
          return TodayDashboardDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TodayHabitDto':
          return TodayHabitDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateProfileRequest':
          return UpdateProfileRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateYearItemRequest':
          return UpdateYearItemRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationProblemDetails':
          return ValidationProblemDetails.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeekDashboardDto':
          return WeekDashboardDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeekDeleteResultDto':
          return WeekDeleteResultDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeekNoteDto':
          return WeekNoteDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WeekProgressDto':
          return WeekProgressDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'YearDashboardDto':
          return YearDashboardDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'YearMetaDto':
          return YearMetaDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'YearMonthDto':
          return YearMonthDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'YearPlanItemDto':
          return YearPlanItemDto.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }