import { beforeEach } from 'vitest'
import i18n, { applyLanguage } from '../i18n'
import { useSettings } from '../store/settings'

// jsdom có navigator.language = 'en-US' nên detectLanguage() sẽ chọn 'en'.
// Các test hiện có kiểm tra chữ tiếng Việt, nên ép ngôn ngữ về 'vi' trước mỗi test.
useSettings.setState({ language: 'vi' })
applyLanguage('vi')

beforeEach(async () => {
  useSettings.setState({ language: 'vi' })
  if (i18n.language !== 'vi') {
    await i18n.changeLanguage('vi')
  }
})
