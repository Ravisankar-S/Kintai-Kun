# Kintai-kun (勤怠くん)

![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Ruby on Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Hotwire](https://img.shields.io/badge/hotwire-%23000000.svg?style=for-the-badge&logo=hotwire&logoColor=white)
![I18n](https://img.shields.io/badge/i18n-localization-%232C3E50.svg?style=for-the-badge)

> **[🖼️ SCREENSHOT PLACEHOLDER 1: Hero/Landing Page]**  
> *Instruction: Insert a high-res screenshot of the landing page or the main dashboard here to immediately hook the reader with the authentic Japanese SaaS UI/UX aesthetic.*

## Executive Summary & Core Value Proposition

**Kintai-kun** is a high-fidelity, enterprise-grade Attendance, Overtime (Zangyo), and Work-Log Tracking application. It is engineered with an authentic "Japanese SaaS UI/UX" aesthetic, prioritizing minimalist design, extreme clarity, and zero-friction interaction. 

Built on Ruby on Rails 8.1, the application serves as a comprehensive system for employees to effortlessly log hours while providing management with robust oversight capabilities. From real-time overtime analytics to multi-tier alerts and a strictly isolated administrative namespace, Kintai-kun elegantly balances employee wellbeing with administrative compliance.

---

## 🏗️ Key Architectural Highlights

### 1. Fully Localized Navigation & UI System (I18n Framework)
The application architecture is deeply integrated with Rails I18n, supporting seamless context-switching between English (`:en`) and Japanese (`:ja`) via a session-backed controller toggle. The Tailwind CSS layouts are structurally designed to scale and reflow gracefully, accommodating the visual density differences between Kanji, Hiragana, Katakana, and standard English prose without breaking components.

### 2. Advanced Time Analytics Dashboard
A real-time processing engine powers the core dashboard, calculating daily hours worked, rolling weekly tracking, and automated threshold detections for overtime (Zangyo).

> **[🖼️ SCREENSHOT PLACEHOLDER 2: Main Dashboard]**  
> *Instruction: Insert a screenshot of the main user dashboard showing the real-time clock, current status orb, and the weekly hours summary.*

### 3. Multi-tier Smart Alert System
Engineered to proactively monitor employee burnout, the system features a dynamic threshold alerting mechanism:
- **Level 1 Alert:** Fires when daily recorded work hours breach the 8-hour (480 minutes) threshold.
- **Level 2 Alert:** A complex dynamic trigger that fires when an employee records more than 3 days of overtime within a single rolling week, signaling a critical need for intervention.

### 4. Activity Heatmap
A custom 12-week GitHub-style contribution grid visualizes time-allocation intensity. It utilizes customized branding color scales (e.g., a soft red `#FF6B6B` gradient) to instantly highlight overtime patterns, providing managers and users an at-a-glance burnout risk assessment.

> **[🖼️ SCREENSHOT PLACEHOLDER 3: Heatmap]**  
> *Instruction: Insert a screenshot specifically focusing on the GitHub-style contribution heatmap.*

### 5. Enterprise Work-Log Management
The application handles complex tabular data using robust server-side pagination (via Kaminari). Each record supports rich-text annotations through a dedicated "Memo" field. Furthermore, a highly optimized CSV processing endpoint allows for the secure, bulk export of employee attendance records for payroll processing.

### 6. Administrative Isolation (Namespacing)
Security and concern separation are strictly enforced via a `namespace :admin` routing layout. The worker-facing profile interfaces are fully decoupled from the back-office monitoring panels (`/admin/users`, `/admin/dashboard`), ensuring that domain logic remains isolated and authorization boundaries are respected.

> **[🖼️ SCREENSHOT PLACEHOLDER 4: Admin Panel]**  
> *Instruction: Insert a screenshot of the Admin Dashboard showing the user directory and the overtime monitoring tables.*

---

## 📂 System Directory Tree / Codebase Blueprint

The application strictly adheres to "Fat Models, Thin Controllers" principles, leveraging standard Rails 8.1 paradigms to maintain a highly maintainable and readable codebase.

```text
kintai-kun/
├── app/
│   ├── controllers/
│   │   ├── admin/             # Strictly isolated back-office controllers
│   │   ├── application_controller.rb
│   │   ├── dashboard_controller.rb
│   │   └── punches_controller.rb # Core business logic for clock in/out
│   ├── models/
│   │   ├── user.rb            # Fat model handling authentication & scopes
│   │   └── work_log.rb        # Encapsulates duration & Zangyo calculations
│   ├── views/
│   │   ├── admin/             # Separated layout for administrative interfaces
│   │   ├── dashboard/         # Real-time analytics views
│   │   └── shared/            # Reusable UI components (Navbar, Flash, Toasts)
│   └── javascript/
│       └── controllers/       # Hotwire Stimulus controllers for interactive UI
├── config/
│   ├── locales/               # Comprehensive en.yml and ja.yml I18n dictionaries
│   └── routes.rb              # Namespaced and resourceful routing definitions
└── db/
    └── schema.rb              # PostgreSQL schema with enforced constraints
```

> **[📊 DIAGRAM PLACEHOLDER: Entity Relationship Diagram]**  
> *Instruction: Consider adding an ERD diagram here showing the 1-to-Many relationship between Users and WorkLogs to demonstrate database architecture.*

---

## 🚀 Getting Started (Local Development)

### Prerequisites
- **Ruby:** 3.2.x
- **Node.js / Bun:** For asset compiling
- **PostgreSQL:** Running locally

### Frictionless Demo Evaluation
To respect recruiters' and reviewers' time, this application does **not** require manual credential hunting. 
Navigate to the `/auth` route (Sign In page), where you will find an **In-App Quick-Fill / Auto-Population** mechanism directly on the login card. Click any of the available demo accounts (Admin or Employee) to instantly populate credentials and securely authenticate into the dashboard with a single click.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Ravisankar-S/Kintai-Kun.git
   cd Kintai-Kun
   ```

2. **Install Ruby dependencies:**
   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies:**
   ```bash
   bun install
   # or yarn install / npm install depending on your package manager
   ```

4. **Setup the Database:**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

5. **Boot the Application:**
   ```bash
   bin/dev
   ```
   *The application will be running at `http://localhost:3000`.*

---

## 🗺️ Future Scaling Roadmap

As Kintai-kun evolves, the following architectural enhancements are prioritized for the next major release:
- **Progressive Web App (PWA):** Implement service workers and a web manifest to allow users to "Install" Kintai-kun directly to their iOS/Android home screens for true native-like mobile clock-ins.
- **Geolocation Verification:** Integrate browser Geolocation APIs to tag clock-in events with coordinates, preventing fraudulent off-site attendance logging.
- **Slack/Teams Integration:** Webhook triggers to automatically notify channels when specific users clock in, or to post weekly Zangyo digest reports directly to HR Slack channels.
- **Exporting to PDF:** Expand the current CSV export functionality to generate formatted, printable PDF timesheets using wicked_pdf or grover.
