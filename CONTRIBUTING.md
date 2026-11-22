# Quy ước đóng góp

Tài liệu này quy định cách đặt tên nhánh, viết commit message và mở pull request cho MyPlanner (Mầm). Quy ước dựa trên [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/), là chuẩn mà phần lớn dự án mã nguồn mở và nhiều công ty đang dùng (Angular, Vue, Electron, Nx, nhiều team .NET).

## 1. Thiết lập một lần sau khi clone

```powershell
git config core.hooksPath .githooks        # bật hook kiểm tra commit message
git config commit.template .gitmessage     # mở sẵn khung gợi ý khi chạy `git commit` không có -m
git config pull.rebase true                # pull bằng rebase, lịch sử không có merge commit thừa
```

Hook `.githooks/commit-msg` chặn commit có header sai định dạng và in ra lý do. Muốn bỏ qua trong trường hợp đặc biệt thì dùng `git commit --no-verify`, nhưng không nên lạm dụng.

## 2. Cấu trúc commit message

```
<type>(<scope>): <subject>
                                   ← một dòng trống
<body: vì sao thay đổi, thay đổi gì ở mức ý tưởng>
                                   ← một dòng trống
<footer: BREAKING CHANGE, Refs, Closes>
```

Chỉ dòng đầu (header) là bắt buộc. Body và footer thêm khi thay đổi cần giải thích.

### 2.1 Header

| Phần | Quy tắc |
|------|---------|
| `type` | Bắt buộc, chữ thường, chọn trong bảng 2.2 |
| `scope` | Không bắt buộc nhưng nên có, chữ thường, chọn trong bảng 2.3 |
| `!` | Đặt ngay trước dấu `:` khi thay đổi phá vỡ tương thích, ví dụ `feat(api)!: ...` |
| `subject` | Tiếng Anh, thể mệnh lệnh (`add`, `fix`, `remove`, không viết `added`, `adds`), chữ đầu viết thường, không có dấu chấm cuối |
| Độ dài | Cả header tối đa 72 ký tự, nên giữ dưới 50 |

Mẹo kiểm tra thể mệnh lệnh: câu "If applied, this commit will **&lt;subject&gt;**" phải đọc trôi chảy. Ví dụ "If applied, this commit will *add weekly note autosave*".

### 2.2 Type

| Type | Khi nào dùng | Ảnh hưởng phiên bản (SemVer) |
|------|--------------|------------------------------|
| `feat` | Thêm tính năng mà người dùng hoặc client API thấy được | minor |
| `fix` | Sửa lỗi hành vi | patch |
| `perf` | Tăng hiệu năng, hành vi không đổi | patch |
| `refactor` | Đổi cấu trúc code, hành vi không đổi, không sửa lỗi | không |
| `test` | Thêm hoặc sửa test | không |
| `docs` | Chỉ đổi tài liệu (README, CONTRIBUTING, comment XML) | không |
| `style` | Định dạng, khoảng trắng, dấu chấm phẩy; không đổi logic (không phải CSS) | không |
| `build` | Hệ thống build, package, dependency (`.csproj`, `package.json`, Vite config) | không |
| `ci` | Pipeline CI/CD (GitHub Actions…) | không |
| `chore` | Việc lặt vặt không thuộc nhóm trên: `.gitignore`, script dev, cấu hình editor | không |
| `revert` | Hoàn tác một commit trước | tuỳ commit gốc |

Đổi giao diện bằng CSS/Tailwind là `feat` (nếu thêm thứ mới) hoặc `fix` (nếu sửa hiển thị sai), không phải `style`.

### 2.3 Scope của dự án này

| Nhóm | Scope |
|------|-------|
| Backend theo tầng | `core`, `dal`, `bll`, `api`, `backend` (đụng nhiều tầng hoặc cấu hình chung) |
| Database | `db` (migration, cấu hình EF) |
| Frontend chung | `frontend`, `ui` (component dùng chung, token CSS), `i18n` |
| Theo màn hình | `today`, `week`, `habits`, `recurring`, `goals`, `year`, `stats`, `settings` |
| Khác | `deps`, `desktop`, `mobile`, `deploy`, `auth` |

Một tính năng đi xuyên BE và FE cho một màn hình thì dùng scope màn hình, ví dụ `feat(year): ...`. Nếu thay đổi lớn, tách thành commit BE và commit FE riêng (xem mục 3).

### 2.4 Body

- Cách header một dòng trống, mỗi dòng tối đa 72 ký tự.
- Trả lời **vì sao** và **thay đổi gì ở mức ý tưởng**. Diff đã cho thấy **thế nào**, không chép lại diff.
- Có thể dùng gạch đầu dòng `-`.
- Viết tiếng Anh cho đồng bộ với header.

### 2.5 Footer

| Footer | Ý nghĩa |
|--------|---------|
| `BREAKING CHANGE: <mô tả>` | Thay đổi phá vỡ tương thích, kèm hướng dẫn chuyển đổi. Bắt buộc khi header có `!` |
| `Refs: #12` | Liên quan tới issue 12 |
| `Closes: #12` hoặc `Fixes: #12` | GitHub tự đóng issue 12 khi commit vào nhánh mặc định |
| `Co-authored-by: Tên <email>` | Ghi nhận người cùng viết (pair programming) |

## 3. Commit thế nào là "đúng cỡ" (atomic commit)

Một commit là **một thay đổi logic trọn vẹn**:

1. **Một mục đích.** Không gộp "thêm tính năng năm" với "sửa lỗi lịch tuần" vào một commit. Nếu header phải dùng chữ "and" để nối hai việc khác nhau, nên tách.
2. **Build và test vẫn xanh** sau mỗi commit, để `git bisect` và `git revert` dùng được.
3. **Không lẫn rác:** không có file debug, `console.log` tạm, file sinh tự động ngoài ý muốn, file bí mật.
4. **Đủ nhỏ để review** trong vài phút. Tính năng lớn chia theo tầng: `feat(core)` → `feat(bll)` → `feat(api)` → `feat(year)` (FE).

Công cụ hỗ trợ tách commit:

```powershell
git add -p                      # chọn từng đoạn (hunk) để stage
git diff --staged               # xem lại đúng những gì sắp commit
git commit --amend              # sửa commit cuối khi CHƯA push
git commit --fixup <sha>        # tạo commit sửa cho một commit cũ
git rebase -i --autosquash main # gộp các fixup vào commit gốc trước khi mở PR
```

Chỉ viết lại lịch sử (`amend`, `rebase`, `reset`) trên commit **chưa push** hoặc trên nhánh cá nhân. Nhánh dùng chung như `main` thì không bao giờ `push --force`.

## 4. Đặt tên nhánh

```
<type>/<mô-tả-ngắn-kebab-case>
```

Ví dụ: `feat/year-plan-board`, `fix/week-drag-drop-order`, `chore/gitignore-docs`, `docs/contributing`. Có hệ thống issue thì thêm số: `feat/42-year-plan-board`.

Luồng làm việc (GitHub Flow): `main` luôn chạy được → tạo nhánh từ `main` → commit nhỏ → push → mở pull request → review, CI xanh → merge (squash hoặc rebase) → xoá nhánh.

## 5. Pull request

- Tiêu đề PR theo đúng định dạng header commit, vì khi **squash merge** tiêu đề PR trở thành commit message trên `main`.
- Mô tả gồm: *Vì sao*, *Thay đổi chính*, *Cách kiểm tra* (lệnh test, ảnh chụp 375px và 1440px nếu đổi UI), *Ảnh hưởng API* (web, WPF, Flutter có cần cập nhật không).
- PR nhỏ, một mục đích. Trên 400 dòng thay đổi thì cân nhắc tách.

## 6. Ví dụ

Tốt:

```
feat(year): add 12-month board with drag-and-drop reordering
```

```
fix(week): keep task order when moving between days

Moving a task to another day appended it with order 0, so it jumped
to the top and collided with the first task of the target day.
The service now assigns max(order) + 1 in the target day.

Fixes: #31
```

```
feat(api)!: require today query parameter on dashboard endpoints

Server clock is UTC, so "today" was wrong for users in UTC+7 before
7am. Clients now send their local date.

BREAKING CHANGE: GET /api/dashboard/* returns 400 without ?today=.
Web, WPF and Flutter clients must pass the local date (YYYY-MM-DD).
```

```
refactor(bll): move deadline merging into YearBoard domain function
```

```
build(deps): bump @tanstack/react-query to 5.62.0
```

```
revert: feat(stats): add streak heatmap

This reverts commit 1a2b3c4. The heatmap query times out on large
accounts; it will come back behind a paginated endpoint.
```

Chưa tốt và cách sửa:

| Chưa tốt | Vấn đề | Sửa thành |
|----------|--------|-----------|
| `update` | Không có type, không nói gì | `fix(today): show backlog count after moving tasks` |
| `Fixed bug.` | Thì quá khứ, chữ hoa, dấu chấm, không rõ lỗi gì | `fix(habits): stop counting future days as missed` |
| `feat: add year page and fix week bug and update deps` | Ba việc một commit | Tách thành ba commit |
| `feat(Year): Added Year Page` | Scope và subject viết hoa, thì quá khứ | `feat(year): add year plan page` |
| `wip` | Commit tạm lọt lên nhánh chung | Gộp bằng `--fixup` và `rebase --autosquash` trước khi push |
