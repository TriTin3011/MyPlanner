import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { api } from '../../api/client'
import { keys } from '../../api/keys'
import type { AvatarDto, CurrentUserDto } from '../../api/types'
import { useSession } from './session'

// Link ảnh sống một giờ. Làm mới sau 30 phút để link đang hiển thị luôn còn hạn.
const REFRESH_MS = 30 * 60 * 1000
const UPLOAD_TIMEOUT_MS = 30_000

export function useCurrentUser() {
  const token = useSession((s) => s.token)
  const userName = useSession((s) => s.userName)
  return useQuery({
    queryKey: keys.me,
    queryFn: async () => {
      const me = (await api.get<CurrentUserDto>('/auth/me')).data
      // Đồng bộ khi tên được đổi ở thiết bị khác. So theo tài khoản vì token đổi mỗi lần tự gia hạn.
      if (useSession.getState().userName === userName) useSession.setState({ displayName: me.displayName ?? null })
      return me
    },
    enabled: Boolean(token),
    staleTime: REFRESH_MS,
    refetchInterval: REFRESH_MS,
  })
}

// Server trả link mới nên ghi thẳng vào cache: avatar ở sidebar đổi ngay, không cần gọi lại /me.
function useAvatarResult() {
  const queryClient = useQueryClient()
  return ({ avatarUrl }: AvatarDto) => {
    queryClient.setQueryData<CurrentUserDto>(keys.me, (current) =>
      current ? { ...current, avatarUrl } : current,
    )
  }
}

export function useUpdateDisplayName() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (displayName: string) =>
      (await api.patch<CurrentUserDto>('/profile', { displayName })).data,
    onSuccess: (me) => {
      queryClient.setQueryData(keys.me, me)
      useSession.setState({ displayName: me.displayName ?? null })
    },
  })
}

export function useUploadAvatar() {
  const onSuccess = useAvatarResult()
  return useMutation({
    mutationFn: async (file: File) => {
      const form = new FormData()
      form.append('file', file)
      return (await api.put<AvatarDto>('/profile/avatar', form, { timeout: UPLOAD_TIMEOUT_MS })).data
    },
    onSuccess,
  })
}

export function useDeleteAvatar() {
  const onSuccess = useAvatarResult()
  return useMutation({
    mutationFn: async () => (await api.delete<AvatarDto>('/profile/avatar')).data,
    onSuccess,
  })
}
