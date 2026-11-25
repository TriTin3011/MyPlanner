// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mầm';

  @override
  String get navToday => 'Today';

  @override
  String get navGoals => 'Goals';

  @override
  String get navHabits => 'Habits';

  @override
  String get navWeek => 'Week';

  @override
  String get navYear => 'Year';

  @override
  String get navStats => 'Stats';

  @override
  String get navMore => 'More';

  @override
  String get themeLabel => 'Color theme';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeOcean => 'Night ocean';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeNight => 'Night';

  @override
  String get languageLabel => 'Language';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get authTitle => 'Sign in';

  @override
  String get authSubtitle => 'Your plans are waiting here.';

  @override
  String get authUserName => 'Username';

  @override
  String get authPassword => 'Password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authSubmit => 'Sign in';

  @override
  String get authLogout => 'Sign out';

  @override
  String get authAccount => 'Account';

  @override
  String get authProfile => 'Profile';

  @override
  String get authDisplayName => 'Display name';

  @override
  String get authDisplayNameHint =>
      'Leave empty to use your username. Up to 50 characters.';

  @override
  String authLoginName(String name) {
    return 'Username: $name';
  }

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authRegisterSubtitle => 'Start growing your own plans.';

  @override
  String get authRegisterSubmit => 'Create account';

  @override
  String get authUserNameHint =>
      '3–64 characters: letters, digits, dot, dash, underscore.';

  @override
  String authPasswordHint(int count) {
    return 'At least $count characters.';
  }

  @override
  String get authNoAccount => 'No account yet?';

  @override
  String get authGoToRegister => 'Sign up';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authGoToLogin => 'Sign in';

  @override
  String get authOr => 'or';

  @override
  String get authGoogleContinue => 'Sign in with Google';

  @override
  String get authGoogleUnavailable =>
      'Google sign-in is not configured in this build.';

  @override
  String get authSessionExpired =>
      'Your session expired, please sign in again.';

  @override
  String get authAddPhoto => 'Add photo';

  @override
  String get authChangePhoto => 'Change photo';

  @override
  String get authRemovePhoto => 'Remove photo';

  @override
  String get authTakePhoto => 'Take photo';

  @override
  String get authPhotoHint => 'JPG, PNG or WebP, up to 5 MB';

  @override
  String get authPhotoTooLarge => 'Photos can be up to 5 MB.';

  @override
  String get errorNetwork =>
      'Can\'t reach the server. Check your connection and try again.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again later.';

  @override
  String errorTooMany(int seconds) {
    return 'Too many attempts. Wait $seconds seconds and try again.';
  }

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get saved => 'Saved';

  @override
  String get saving => 'Saving…';

  @override
  String get chartLine => 'Line';

  @override
  String get chartBar => 'Bar';

  @override
  String get chartTable => 'Table';

  @override
  String todayGreeting(String name) {
    return 'Hi $name!';
  }

  @override
  String todayProgress(int done, int total, int habitsDone, int habitsTotal) {
    return '$done/$total tasks · $habitsDone/$habitsTotal habits';
  }

  @override
  String get todayTasks => 'Today\'s tasks';

  @override
  String get todayTasksEmpty => 'No tasks yet. Add a small one to get started.';

  @override
  String get todayAddTask => 'Add task';

  @override
  String get todayTaskHint => 'Something to do…';

  @override
  String get todayHabits => 'Habits';

  @override
  String get todayHabitsEmpty => 'No habits yet. Add some in the Habits tab.';

  @override
  String get todayNote => 'Note';

  @override
  String get todayNoteHint => 'Write a few lines about today…';

  @override
  String get todayBacklog => 'Leftover tasks';

  @override
  String get todayBacklogMove => 'Move all to today';

  @override
  String todayBacklogMoved(int count) {
    return 'Moved $count tasks to today';
  }

  @override
  String get todayCalendar => 'Planning';

  @override
  String get todayCalendarMonth => 'Month';

  @override
  String get todayCalendarWeek => 'Week';

  @override
  String get todayRecent => 'Recent progress';

  @override
  String get todayRecurring => 'Recurring tasks';

  @override
  String get tagUrgent => 'Urgent';

  @override
  String get tagImportant => 'Important';

  @override
  String get taskEdit => 'Edit task';

  @override
  String get taskTitle => 'Task';

  @override
  String get taskDate => 'Date';

  @override
  String get taskTags => 'Tags';

  @override
  String get taskSubtasks => 'Subtasks';

  @override
  String get taskAddSubtask => 'Add subtask';

  @override
  String get taskMoveDate => 'Pick another day';

  @override
  String get taskMoveToday => 'Move to today';

  @override
  String get taskDelete => 'Delete task';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String taskLate(String date) {
    return 'Since $date';
  }

  @override
  String dayTasksTitle(String date) {
    return 'Tasks on $date';
  }

  @override
  String get reorderHint => 'Press and drag to reorder';

  @override
  String get recurringTitle => 'Recurring tasks';

  @override
  String get recurringEmpty => 'No recurring tasks yet.';

  @override
  String get recurringAdd => 'Add recurring task';

  @override
  String get recurringWeekdays => 'Repeat on';

  @override
  String get recurringActive => 'Active';

  @override
  String get recurringStart => 'Starting';

  @override
  String get recurringEveryday => 'Every day';

  @override
  String get weekdayShort1 => 'Mon';

  @override
  String get weekdayShort2 => 'Tue';

  @override
  String get weekdayShort3 => 'Wed';

  @override
  String get weekdayShort4 => 'Thu';

  @override
  String get weekdayShort5 => 'Fri';

  @override
  String get weekdayShort6 => 'Sat';

  @override
  String get weekdayShort7 => 'Sun';

  @override
  String get weekTitle => 'Weekly plan';

  @override
  String weekRange(int week, String from, String to) {
    return 'Week $week · $from – $to';
  }

  @override
  String get weekTasksDone => 'Tasks done';

  @override
  String get weekHabitPercent => 'Habits';

  @override
  String get weekTodayRemaining => 'Left today';

  @override
  String get weekProgress => 'Progress';

  @override
  String get weekRange1 => '1 week';

  @override
  String get weekRange4 => '4 weeks';

  @override
  String get weekRange12 => '12 weeks';

  @override
  String get weekNote => 'Weekly note';

  @override
  String get weekNoteHint => 'The most important thing this week…';

  @override
  String get weekDeadlines => 'Due this week';

  @override
  String get weekThis => 'This week';

  @override
  String get weekPrev => 'Previous week';

  @override
  String get weekNext => 'Next week';

  @override
  String get weekClear => 'Clear data for this week';

  @override
  String weekClearConfirm(String week) {
    return 'Delete all tasks, habit ticks and notes of week $week? This can\'t be undone.';
  }

  @override
  String weekCleared(int tasks, int logs) {
    return 'Deleted $tasks tasks, $logs habit ticks';
  }

  @override
  String get habitsTitle => 'Habit tracker';

  @override
  String get habitsMonthPercent => 'Month completion';

  @override
  String get habitsLongestStreak => 'Longest streak';

  @override
  String get habitsMostConsistent => 'Most consistent';

  @override
  String get habitsDaily => 'Daily completion';

  @override
  String get habitsAdd => 'Add habit';

  @override
  String get habitsName => 'Habit name';

  @override
  String get habitsEmpty => 'No habits yet. Add your first one.';

  @override
  String habitsDeleteConfirm(String name) {
    return 'Delete habit \"$name\" and all of its ticks?';
  }

  @override
  String habitsStreak(int count) {
    return '$count-day streak';
  }

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get goalsTitle => 'Goals & vision';

  @override
  String get goalsAll => 'All';

  @override
  String goalsDone(int done, int total) {
    return '$done/$total goals done';
  }

  @override
  String get goalsAdd => 'Add goal';

  @override
  String get goalsEmpty => 'No goals in this group.';

  @override
  String get goalsArea => 'Area';

  @override
  String get goalsStatus => 'Status';

  @override
  String get goalsStart => 'Start';

  @override
  String get goalsDeadline => 'Deadline';

  @override
  String get goalsReward => 'Reward';

  @override
  String get goalsWhy => 'Why it matters';

  @override
  String get goalsSteps => 'Steps';

  @override
  String get goalsAddStep => 'Add step';

  @override
  String get goalsStepDeadline => 'Step deadline';

  @override
  String goalsDaysLeft(int count) {
    return '$count days left';
  }

  @override
  String goalsOverdue(int count) {
    return '$count days overdue';
  }

  @override
  String get goalsBehind => 'Behind schedule';

  @override
  String goalsStepsProgress(int done, int total) {
    return '$done/$total steps';
  }

  @override
  String goalsDeleteConfirm(String name) {
    return 'Delete goal \"$name\"?';
  }

  @override
  String get goalsRadar => 'Balance across areas';

  @override
  String get statusNotStarted => 'Not started';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusDone => 'Done';

  @override
  String get areaHealth => 'Health';

  @override
  String get areaFinance => 'Finance';

  @override
  String get areaCareer => 'Career';

  @override
  String get areaGrowth => 'Personal growth';

  @override
  String get areaRelationship => 'Relationships';

  @override
  String get areaLearning => 'Learning';

  @override
  String get areaFamily => 'Family';

  @override
  String get areaHobby => 'Hobbies';

  @override
  String get yearTitle => 'Yearly plan';

  @override
  String get yearKeyword => 'Word of the year';

  @override
  String get yearKeywordHint => 'One word to guide the year';

  @override
  String get yearVision => 'Vision';

  @override
  String get yearVisionHint => 'Who do you want to be by the end of the year?';

  @override
  String yearDone(int done, int total) {
    return '$done/$total items this year';
  }

  @override
  String yearMonth(int month) {
    return 'Month $month';
  }

  @override
  String get yearAddItem => 'Add item for this month';

  @override
  String get yearMonthEmpty => 'Nothing yet.';

  @override
  String get yearDeadlines => 'Deadlines';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsRange4w => '4 weeks';

  @override
  String get statsRange8w => '8 weeks';

  @override
  String get statsRange12w => '12 weeks';

  @override
  String get statsRange6m => '6 months';

  @override
  String get statsRange1y => '1 year';

  @override
  String get statsCompletion => 'Completion rate';

  @override
  String statsDelta(String delta) {
    return '$delta points vs previous period';
  }

  @override
  String statsBestWeekday(String day) {
    return 'Best day: $day';
  }

  @override
  String get statsTasksDone => 'Tasks done';

  @override
  String get statsActivityStreak => 'Activity streak';

  @override
  String statsLongest(int count) {
    return 'longest $count';
  }

  @override
  String get statsHabit => 'Habits';

  @override
  String get statsTrend => 'Weekly trend';

  @override
  String get statsHeatmap => 'Activity calendar';

  @override
  String get statsWeekday => 'By weekday';

  @override
  String get statsHabits => 'Habit consistency';

  @override
  String get statsGoals => 'Goals';

  @override
  String statsAverage(int percent) {
    return 'Average $percent%';
  }

  @override
  String get statsEmpty => 'No data in this range.';

  @override
  String get habitsThisMonth => 'This month';

  @override
  String get habitsRename => 'Rename';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get goalsName => 'Goal name';

  @override
  String get goalsClearDeadline => 'Clear deadline';

  @override
  String get goalsDeadlineBeforeStart =>
      'Deadline must be after the start date.';

  @override
  String get yearThisYear => 'This year';

  @override
  String get yearProgress => 'Progress by month';

  @override
  String get yearCurrentMonth => 'This month';
}
