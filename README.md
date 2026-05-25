# 勤怠くん — Kintai-kun

![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Ruby on Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Hotwire](https://img.shields.io/badge/hotwire-%23000000.svg?style=for-the-badge)
![i18n](https://img.shields.io/badge/i18n-EN%20%2F%20JP-%232C3E50.svg?style=for-the-badge)

> *Attendance, the Japanese way.*

**[🖼️ INSERT: Landing page or dashboard screenshot]**

---

## What is Kintai-kun?

勤怠 (*Kintai*) is the standard Japanese HR term for attendance management. Every company in Japan — from a five-person startup to a listed corporation — runs a kintai system. This app is built around that reality.

Kintai-kun is a full-stack attendance and workforce management platform built with Ruby on Rails. It lets employees clock in and out, tracks overtime, surfaces burnout risk through smart alerts, and gives administrators a clean oversight dashboard — all wrapped in a bilingual Japanese/English interface designed to feel like a product a Tokyo tech team would actually use.

The overtime alert system is not cosmetic. Japan's Work Style Reform Act (働き方改革関連法, 2019) legally caps overtime at 45 hours per month. 過労死 (*karoshi*) — death from overwork — is a documented and recognized social crisis in Japan. These realities shaped the product decisions in this app, and that context is visible in the UI.

---

## Try It Live

**[🔗 LIVE LINK: https://kintai-kun-web.onrender.com]**

No sign-up needed. On the login page, use the one-click demo buttons to instantly authenticate as either an Admin or Employee account and explore the full platform.

> The app is hosted on Render's free tier. If it takes 30–50 seconds to load on first visit, the server is waking up from inactivity. Subsequent requests are instant.

---

## Features

### 打刻 — Clock In / Clock Out
One-tap punch system with an optional memo at clock-out. The dashboard status orb pulses green when clocked in and goes still when idle. Clock-in events are tagged with GPS coordinates via the browser Geolocation API, giving administrators verifiable location context for every record.

**[🖼️ INSERT: Dashboard showing status orb + clock in/out button]**

### 残業アラート — Overtime Alert System
Two-tier automated alert system:

- **Level 1** — fires when a user exceeds 8 hours in a single day
- **Level 2** — fires when a user has logged overtime on 3 or more days in the current week, with a contextual tooltip referencing Japan's Work Style Reform Act

Neither level is dismissible. They exist because the data warrants them.

**[🖼️ INSERT: Dashboard showing Level 2 zangyō alert banner]**

### 勤怠ヒートマップ — Work Rhythm Heatmap
A GitHub-style contribution grid spanning the past 12 weeks. Each cell represents one day, colored by hours worked. Overtime days render in a distinct terracotta tone, making burnout patterns visible at a glance without reading a single number.

**[🖼️ INSERT: Heatmap section of dashboard]**

### 勤怠履歴 — Work Log History
Paginated table of all attendance records with month filtering, bilingual column headers, overtime row highlighting, and memo display. Overtime entries are visually distinguished with a 残業 pill tag.

**[🖼️ INSERT: Work log history table]**

### CSVエクスポート — CSV Export
One-click export of attendance records for any selected month. Column headers are bilingual. The filename format (`kintai_[name]_[YYYY-MM].csv`) matches Japanese payroll workflow conventions.

### PDFタイムシート — PDF Timesheet Export
Dynamically generated, fully localized printable timesheets powered by Prawn. Zero external OS-level dependencies. Designed to match the kind of document a Japanese HR department would recognize and accept.

### 管理者ダッシュボード — Admin Dashboard
A strictly namespaced admin interface (`/admin`) isolated from employee-facing routes. Admins see aggregate stats across all users, a searchable employee directory, work mode indicators, and can drill into any user's full attendance history. Administrator access is enforced at the controller level — role mismatch redirects immediately.

**[🖼️ INSERT: Admin dashboard with user directory]**

### 位置情報 — Geolocation Verification
Clock-in and clock-out events capture GPS coordinates via the browser Geolocation API, handled by a Stimulus controller. Administrators can verify employee locations through clickable Google Maps links directly in the admin user detail view.

### 言語切替 — Bilingual Interface (EN / JP)
Full Rails I18n implementation across every page, label, flash message, and alert. Language preference is persisted per user in the database and synced to the session on login. The UI reflows correctly for both scripts — Japanese text density is accounted for in the layout system.

**[🖼️ INSERT: Side-by-side or toggled EN/JP view]**

### プロフィール設定 — Profile & Settings
Tab-based settings page covering personal information, work schedule (Fixed Hours vs Flex Hours with conditional time inputs), language preference, and password management — all without page reloads, powered by Stimulus.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.2 |
| Framework | Ruby on Rails 8.1 |
| Database | PostgreSQL |
| Frontend | Hotwire (Turbo + Stimulus) |
| Styling | Tailwind CSS |
| Authentication | Devise |
| Pagination | Kaminari |
| PDF Generation | Prawn |
| Geolocation | Browser Geolocation API + Google Maps |
| Internationalization | Rails I18n (EN / JA) |
| Deployment | Render |

---

## Architecture

The application follows Rails conventions strictly — fat models, thin controllers, shared logic in helpers and concerns. The admin namespace is fully isolated from the employee-facing interface at both the routing and controller level.

```
kintai-kun/
├── app/
│   ├── controllers/
│   │   ├── admin/                  # Isolated admin namespace
│   │   ├── application_controller.rb
│   │   ├── dashboard_controller.rb
│   │   └── punches_controller.rb   # Clock in / clock out logic
│   ├── models/
│   │   ├── user.rb                 # Auth, roles, associations, scopes
│   │   └── work_log.rb             # Duration, overtime, geolocation
│   ├── views/
│   │   ├── admin/
│   │   ├── dashboard/
│   │   └── shared/                 # Navbar, flash, alerts, heatmap
│   └── javascript/
│       └── controllers/            # Stimulus: geolocation, tabs, tooltips
├── config/
│   ├── locales/
│   │   ├── en.yml
│   │   └── ja.yml
│   └── routes.rb
└── db/
    └── schema.rb
```

**[📊 INSERT: ERD diagram showing User → WorkLog relationship]**

---

## Local Setup

### Prerequisites
- Ruby 3.2+
- Node.js
- PostgreSQL running locally

### Steps

```bash
# Clone
git clone https://github.com/Ravisankar-S/Kintai-Kun.git
cd Kintai-Kun

# Install dependencies
bundle install
npm install

# Database
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# Start
bin/dev
```

App runs at `http://localhost:3000`

---

## What's Next

- **PWA support** — service workers and web manifest for home screen installation on iOS and Android, enabling native-like mobile clock-ins
- **Slack / Teams webhooks** — automated notifications when users clock in, and weekly 残業 digest reports posted directly to HR channels

---

## Cultural Note

This project was built while learning Ruby on Rails and studying Japanese workplace culture. The feature decisions — the overtime alert levels, the karoshi tooltip, the CSV format, the HR vocabulary throughout — are grounded in real research into how Japanese companies manage attendance and why it matters. That context is the difference between a CRUD app and a product with a point of view.

---

## 日本語

**勤怠くん**は、Ruby on Railsで構築された勤怠管理プラットフォームです。従業員の出退勤記録、残業アラート（働き方改革関連法に基づく）、管理者ダッシュボード、CSVエクスポート、PDFタイムシート生成、位置情報確認、日英バイリンガルUIを搭載しています。

ポートフォリオプロジェクトとして、日本の職場文化と勤怠管理の実態を学びながら開発しました。


---

made with ❤ by [Ravi](https://www.linkedin.com/in/ravisankar-cs/)