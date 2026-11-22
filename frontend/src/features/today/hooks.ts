import { queryOptions, useMutation, useQuery, useQueryClient, type QueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import { addDays } from '../../lib/dates'
import type {
  CountDto,
  DayNoteDto,
  DayProgressDto,
  MaterializeRequest,
  MoveBacklogRequest,
  ReorderTasksRequest,
  SaveNoteRequest,
  SaveTaskRequest,
  TaskDto,
  TaskTag,
  TodayDashboardDto,
} from '../../api/types'

interface ToggleTaskInput {
  id: string
  done: boolean
}

interface CreateTaskInput {
  title: string
  date: string
}

interface UpdateTaskTitleInput {
  task: TaskDto
  title: string
}

interface UpdateSubtaskInput {
  task: TaskDto
  subtaskId: string
  done: boolean
}

interface ToggleHabitInput {
  habitId: string
  date: string
  done: boolean
}

// Phần có thể đổi của một Task khi gọi PUT. Subtask mới chưa có id thì gửi id = null, BE sẽ cấp id.
export interface TaskPatch {
  title?: string
  date?: string
  tags?: TaskTag[]
  subtasks?: { id: string | null; title: string; done: boolean }[]
}

// PUT là "thay toàn bộ": phải gửi đủ mọi trường, nếu không BE hiểu là xoá (vd mất tag, mất bước con).
// Hàm thuần này ghép trạng thái hiện tại với phần thay đổi, mọi mutation sửa Task đều đi qua đây.
export function toSaveTaskRequest(task: TaskDto, patch: TaskPatch = {}): SaveTaskRequest {
  return {
    title: patch.title ?? task.title,
    date: patch.date ?? task.date,
    tags: patch.tags ?? task.tags,
    subtasks: (patch.subtasks ?? task.subtasks).map((s) => ({ id: s.id, title: s.title, done: s.done })),
  }
}

// Mọi thay đổi Task ảnh hưởng tới dashboard (vòng %, lịch), danh sách task và thống kê.
async function invalidateTaskViews(queryClient: QueryClient) {
  await Promise.all([
    queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
    queryClient.invalidateQueries({ queryKey: keys.tasks.all }),
    queryClient.invalidateQueries({ queryKey: keys.stats.all }),
  ])
}

function useTaskMutation<TInput, TResult>(mutationFn: (input: TInput) => Promise<TResult>) {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn,
    onSuccess: () => invalidateTaskViews(queryClient),
  })
}

export async function getTodayDashboard(date: string) {
  const response = await api.get<TodayDashboardDto>('/dashboard/today', {
    params: { date },
  })
  return response.data
}

export function todayDashboardQueryOptions(date: string) {
  return queryOptions({
    queryKey: keys.dashboard.today(date),
    queryFn: () => getTodayDashboard(date),
  })
}

export function useTodayDashboard(date: string) {
  return useQuery(todayDashboardQueryOptions(date))
}

// Số liệu theo ngày (xong/tổng/%/cờ hạn) do BE tính: dùng chung cho biểu đồ và lịch.
export async function getDayProgress(from: string, to: string) {
  const response = await api.get<DayProgressDto[]>('/dashboard/days', { params: { from, to } })
  return response.data
}

// `enabled` cho phép khối biểu đồ gọi hook vô điều kiện (luật của hook) nhưng chỉ tải khi cần.
export function useDayProgress(from: string, to: string, enabled = true) {
  return useQuery({
    queryKey: keys.dashboard.days(from, to),
    queryFn: () => getDayProgress(from, to),
    enabled: enabled && Boolean(from && to),
  })
}

export async function toggleTask({ id, done }: ToggleTaskInput) {
  const response = await api.patch<TaskDto>(`/tasks/${id}/done`, { done })
  return response.data
}

export function useToggleTask() {
  return useTaskMutation(toggleTask)
}

export async function createTask({ title, date }: CreateTaskInput) {
  const request: SaveTaskRequest = { title, date, tags: null, subtasks: null }
  const response = await api.post<TaskDto>('/tasks', request)
  return response.data
}

export function useCreateTask() {
  return useTaskMutation(createTask)
}

export async function saveTask({ task, patch }: { task: TaskDto; patch: TaskPatch }) {
  const response = await api.put<TaskDto>(`/tasks/${task.id}`, toSaveTaskRequest(task, patch))
  return response.data
}

// Mutation chung cho menu ⋯: đổi tag, thêm bước con, đổi ngày.
export function useSaveTask() {
  return useTaskMutation(saveTask)
}

export function updateTaskTitle({ task, title }: UpdateTaskTitleInput) {
  return saveTask({ task, patch: { title } })
}

export function useUpdateTaskTitle() {
  return useTaskMutation(updateTaskTitle)
}

export function updateSubtask({ task, subtaskId, done }: UpdateSubtaskInput) {
  const subtasks = task.subtasks.map((s) => (s.id === subtaskId ? { ...s, done } : s))
  return saveTask({ task, patch: { subtasks } })
}

export function useUpdateSubtask() {
  return useTaskMutation(updateSubtask)
}

export async function toggleHabit({ habitId, date, done }: ToggleHabitInput) {
  if (done) {
    await api.put(`/habit-logs/${habitId}/${date}`)
  } else {
    await api.delete(`/habit-logs/${habitId}/${date}`)
  }
}

export function useToggleHabit() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: toggleHabit,
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
        queryClient.invalidateQueries({ queryKey: keys.habits }),
        queryClient.invalidateQueries({ queryKey: keys.stats.all }),
      ])
    },
  })
}

interface SaveDayNoteInput {
  date: string
  content: string
}

export async function saveDayNote({ date, content }: SaveDayNoteInput) {
  const request: SaveNoteRequest = { content }
  const response = await api.put<DayNoteDto>(`/notes/day/${date}`, request)
  return response.data
}

export function useSaveDayNote() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: saveDayNote,
    onSuccess: async (_data, variables) => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: keys.notes.day(variables.date) }),
        queryClient.invalidateQueries({ queryKey: keys.dashboard.all }),
      ])
    },
  })
}

export async function moveBacklogToToday(today: string) {
  const request: MoveBacklogRequest = { today }
  const response = await api.post<CountDto>('/tasks/move-backlog-to-today', request)
  return response.data
}

export function useMoveBacklogToToday() {
  return useTaskMutation(moveBacklogToToday)
}

export async function deleteTask(id: string) {
  await api.delete(`/tasks/${id}`)
}

export function useDeleteTask() {
  return useTaskMutation(deleteTask)
}

interface MoveTaskToDateInput {
  task: TaskDto
  date: string
}

export function moveTaskToDate({ task, date }: MoveTaskToDateInput) {
  return saveTask({ task, patch: { date } })
}

export function useMoveTaskToDate() {
  return useTaskMutation(moveTaskToDate)
}

export async function reorderTasks(request: ReorderTasksRequest) {
  await api.put('/tasks/reorder', request)
}

// Đổi thứ tự việc hôm nay. Dùng optimistic update: sửa cache ngay để danh sách không "nhảy về chỗ cũ"
// trong lúc chờ mạng, lỗi thì trả lại bản cũ (rollback), xong thì refetch để khớp với BE.
export function useReorderTodayTasks(today: string) {
  const queryClient = useQueryClient()
  const queryKey = keys.dashboard.today(today)

  return useMutation({
    mutationFn: (ids: string[]) => reorderTasks({ date: today, ids }),
    onMutate: async (ids) => {
      await queryClient.cancelQueries({ queryKey })
      const previous = queryClient.getQueryData<TodayDashboardDto>(queryKey)
      if (previous) {
        const byId = new Map(previous.tasks.map((t) => [t.id, t]))
        const tasks = ids.map((id) => byId.get(id)).filter((t): t is TaskDto => t !== undefined)
        queryClient.setQueryData<TodayDashboardDto>(queryKey, { ...previous, tasks })
      }
      return { previous }
    },
    onError: (_error, _ids, context) => {
      if (context?.previous) queryClient.setQueryData(queryKey, context.previous)
    },
    onSettled: () => invalidateTaskViews(queryClient),
  })
}

// Sinh Task từ các việc lặp lại cho hôm nay..+7 ngày (BE bỏ qua ngày đã có hoặc đã xoá).
export async function materializeRecurring(today: string) {
  const to = addDays(today, 7)
  const request: MaterializeRequest = { from: today, to, today }
  const response = await api.post<CountDto>('/recurring/materialize', request)
  return response.data
}

export function useMaterializeRecurring() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: materializeRecurring,
    onSuccess: async (result) => {
      if (result.count > 0) await invalidateTaskViews(queryClient)
    },
  })
}

export async function getTasksRange(from: string, to: string) {
  const response = await api.get<TaskDto[]>('/tasks', {
    params: { from, to },
  })
  return response.data
}

export function useTasksRange(from: string, to: string) {
  return useQuery({
    queryKey: keys.tasks.range(from, to),
    queryFn: () => getTasksRange(from, to),
    enabled: Boolean(from && to),
  })
}
