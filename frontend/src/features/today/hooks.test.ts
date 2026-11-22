import { afterEach, describe, expect, it, vi } from 'vitest'
import type { components } from '../../api/schema'
import {
  createTask,
  deleteTask,
  getTasksRange,
  moveBacklogToToday,
  saveDayNote,
  todayDashboardQueryOptions,
  toggleHabit,
  toggleTask,
  updateSubtask,
  updateTaskTitle,
} from './hooks'

const { get, patch, post, put, del } = vi.hoisted(() => ({
  get: vi.fn(),
  patch: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  del: vi.fn(),
}))

vi.mock('../../api/client', () => ({ api: { get, patch, post, put, delete: del } }))

type TodayDashboardDto = components['schemas']['TodayDashboardDto']
type TaskDto = components['schemas']['TaskDto']

afterEach(() => {
  get.mockReset()
  patch.mockReset()
  post.mockReset()
  put.mockReset()
  del.mockReset()
})

describe('todayDashboardQueryOptions', () => {
  it('loads the requested local date from the today dashboard endpoint', async () => {
    const dashboard: TodayDashboardDto = {
      date: '2026-11-22',
      percent: 38,
      tasksDone: 3,
      tasksTotal: 10,
      habitsDone: 3,
      habitsTotal: 6,
      tasks: [],
      backlog: [],
      habits: [],
      note: null,
    }
    get.mockResolvedValueOnce({ data: dashboard })

    const options = todayDashboardQueryOptions('2026-11-22')
    const result = await options.queryFn?.({} as never)

    expect(options.queryKey).toEqual(['dashboard', 'today', '2026-11-22'])
    expect(result).toEqual(dashboard)
    expect(get).toHaveBeenCalledWith('/dashboard/today', {
      params: { date: '2026-11-22' },
    })
  })
})

describe('toggleTask', () => {
  it('sends the requested completion state to the task endpoint', async () => {
    const task: TaskDto = {
      id: '11111111-1111-1111-1111-111111111111',
      title: 'Ôn từ vựng',
      date: '2026-11-22',
      originalDate: null,
      done: true,
      doneAt: '2026-11-22T09:00:00Z',
      tags: ['important'],
      subtasks: [],
      recurringId: null,
      order: 1,
      createdAt: '2026-11-20T08:00:00Z',
      updatedAt: '2026-11-22T09:00:00Z',
    }
    patch.mockResolvedValueOnce({ data: task })

    const result = await toggleTask({ id: task.id, done: true })

    expect(result).toEqual(task)
    expect(patch).toHaveBeenCalledWith(`/tasks/${task.id}/done`, { done: true })
  })
})

describe('createTask', () => {
  it('creates a plain task for the requested date', async () => {
    const task: TaskDto = {
      id: '55555555-5555-5555-5555-555555555555',
      title: 'Viết báo cáo',
      date: '2026-11-22',
      originalDate: null,
      done: false,
      doneAt: null,
      tags: [],
      subtasks: [],
      recurringId: null,
      order: 8,
      createdAt: '2026-11-22T10:00:00Z',
      updatedAt: '2026-11-22T10:00:00Z',
    }
    post.mockResolvedValueOnce({ data: task })

    const result = await createTask({ title: 'Viết báo cáo', date: '2026-11-22' })

    expect(result).toEqual(task)
    expect(post).toHaveBeenCalledWith('/tasks', {
      title: 'Viết báo cáo',
      date: '2026-11-22',
      tags: null,
      subtasks: null,
    })
  })
})

describe('updateTaskTitle', () => {
  it('updates the title without dropping the task tags or subtasks', async () => {
    const task: TaskDto = {
      id: '66666666-6666-6666-6666-666666666666',
      title: 'Viết báo cáo',
      date: '2026-11-22',
      originalDate: null,
      done: false,
      doneAt: null,
      tags: ['urgent', 'important'],
      subtasks: [
        { id: '77777777-7777-7777-7777-777777777777', title: 'Thu thập số liệu', done: true },
      ],
      recurringId: null,
      order: 8,
      createdAt: '2026-11-22T10:00:00Z',
      updatedAt: '2026-11-22T10:00:00Z',
    }
    const updated = { ...task, title: 'Viết báo cáo tuần' }
    put.mockResolvedValueOnce({ data: updated })

    const result = await updateTaskTitle({ task, title: 'Viết báo cáo tuần' })

    expect(result).toEqual(updated)
    expect(put).toHaveBeenCalledWith(`/tasks/${task.id}`, {
      title: 'Viết báo cáo tuần',
      date: '2026-11-22',
      tags: ['urgent', 'important'],
      subtasks: [
        {
          id: '77777777-7777-7777-7777-777777777777',
          title: 'Thu thập số liệu',
          done: true,
        },
      ],
    })
  })
})

describe('updateSubtask', () => {
  it('updates one subtask without changing the rest of the task', async () => {
    const task: TaskDto = {
      id: '88888888-8888-8888-8888-888888888888',
      title: 'Hoàn thiện tính năng',
      date: '2026-11-22',
      originalDate: null,
      done: false,
      doneAt: null,
      tags: ['important'],
      subtasks: [
        { id: '99999999-9999-9999-9999-999999999991', title: 'Viết test', done: true },
        { id: '99999999-9999-9999-9999-999999999992', title: 'Viết code', done: false },
      ],
      recurringId: null,
      order: 8,
      createdAt: '2026-11-22T10:00:00Z',
      updatedAt: '2026-11-22T10:00:00Z',
    }
    const updated: TaskDto = {
      ...task,
      subtasks: [task.subtasks[0], { ...task.subtasks[1], done: true }],
    }
    put.mockResolvedValueOnce({ data: updated })

    const result = await updateSubtask({
      task,
      subtaskId: '99999999-9999-9999-9999-999999999992',
      done: true,
    })

    expect(result).toEqual(updated)
    expect(put).toHaveBeenCalledWith(`/tasks/${task.id}`, {
      title: 'Hoàn thiện tính năng',
      date: '2026-11-22',
      tags: ['important'],
      subtasks: [
        { id: '99999999-9999-9999-9999-999999999991', title: 'Viết test', done: true },
        { id: '99999999-9999-9999-9999-999999999992', title: 'Viết code', done: true },
      ],
    })
  })
})

describe('toggleHabit', () => {
  it('calls PUT /habit-logs/{habitId}/{date} when done is true', async () => {
    put.mockResolvedValueOnce({ data: undefined })

    await toggleHabit({
      habitId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      date: '2026-11-22',
      done: true,
    })

    expect(put).toHaveBeenCalledWith('/habit-logs/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/2026-11-22')
  })

  it('calls DELETE /habit-logs/{habitId}/{date} when done is false', async () => {
    del.mockResolvedValueOnce({ data: undefined })

    await toggleHabit({
      habitId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      date: '2026-11-22',
      done: false,
    })

    expect(del).toHaveBeenCalledWith('/habit-logs/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/2026-11-22')
  })
})

describe('saveDayNote', () => {
  it('calls PUT /notes/day/{date} with content in body', async () => {
    const noteDto = {
      date: '2026-11-22',
      content: 'Hôm nay học tốt',
      updatedAt: '2026-11-22T10:00:00Z',
    }
    put.mockResolvedValueOnce({ data: noteDto })

    const result = await saveDayNote({
      date: '2026-11-22',
      content: 'Hôm nay học tốt',
    })

    expect(result).toEqual(noteDto)
    expect(put).toHaveBeenCalledWith('/notes/day/2026-11-22', {
      content: 'Hôm nay học tốt',
    })
  })
})

describe('moveBacklogToToday', () => {
  it('calls POST /tasks/move-backlog-to-today with today in body', async () => {
    post.mockResolvedValueOnce({ data: { count: 5 } })

    const result = await moveBacklogToToday('2026-11-22')

    expect(result).toEqual({ count: 5 })
    expect(post).toHaveBeenCalledWith('/tasks/move-backlog-to-today', { today: '2026-11-22' })
  })
})

describe('deleteTask', () => {
  it('calls DELETE /tasks/{id}', async () => {
    del.mockResolvedValueOnce({ data: undefined })

    await deleteTask('task-123')

    expect(del).toHaveBeenCalledWith('/tasks/task-123')
  })
})

describe('getTasksRange', () => {
  it('calls GET /tasks with from and to params', async () => {
    get.mockResolvedValueOnce({ data: [] })

    const result = await getTasksRange('2026-11-01', '2026-11-30')

    expect(result).toEqual([])
    expect(get).toHaveBeenCalledWith('/tasks', {
      params: { from: '2026-11-01', to: '2026-11-30' },
    })
  })
})
