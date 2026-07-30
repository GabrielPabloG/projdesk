# 🚀 ProjDesk

> **Less friction. More code.**

ProjDesk is an intelligent workspace manager for WSL that removes the small interruptions between you and your code.

Every development session starts the same way:

* Open the terminal.
* Navigate to the project.
* Open the IDE.
* Start Docker.
* Remember which IDE this project uses.
* Remember the Docker command.
* Finally... start coding.

Those aren't difficult tasks.

They're just repetitive.

ProjDesk was built to eliminate that friction.

Instead of:

```bash
cd ~/projects/my-project
code .
docker compose up -d
```

you simply type:

```bash
pd my-project
```

and start building.

---

# ✨ Features

* 📂 Automatically create projects
* 📁 Jump into any workspace
* 💻 Open Visual Studio Code automatically
* 🤖 Detect Android projects and launch Android Studio
* 🐳 Start Docker Desktop only when needed
* 🚀 Docker Compose integration
* 🔨 One-command container rebuilds
* 📜 Container logs
* 🛑 Stop containers
* ⚡ Bash autocomplete
* 🧩 Modular architecture

---

# Philosophy

ProjDesk is built around one simple belief:

> **The fewer commands you have to remember, the faster you can create.**

Modern development isn't difficult because of programming.

It's difficult because of context switching.

Open this.

Launch that.

Navigate here.

Run this command.

Oops...

Wrong directory.

Forgot Docker.

Wrong IDE.

None of these tasks create value.

They simply delay the moment you begin writing code.

ProjDesk exists to remove those tiny interruptions from your daily workflow.

The goal isn't automation for the sake of automation.

The goal is to reduce cognitive load.

Instead of remembering *how* to start working, you simply start working.

---

# One Command

Backend project?

```bash
pd backend-api
```

Android project?

```bash
pd fit-tracker
```

Need to create a new Android project?

```bash
pd a fit-tracker
```

Docker containers?

```bash
pd up
```

Need to rebuild?

```bash
pd rebuild
```

Done for today?

```bash
pd down
```

One command.

One workspace.

One consistent workflow.

---

# Smart Workspace Detection

ProjDesk understands your workspace.

It automatically detects:

* Docker Compose projects
* Android (Gradle) projects
* Existing workspaces
* New workspaces

Instead of asking:

> "Which IDE should I open?"

ProjDesk asks:

> "What does this project need?"

The project decides.

Not you.

---

# Installation

Clone the repository:

```bash
git clone <repository-url> ~/.config/projdesk
```

Load ProjDesk from your shell:

```bash
source ~/.config/projdesk/init.sh
```

Reload Bash:

```bash
source ~/.bashrc
```

You're ready.

---

# Roadmap

* [x] Workspace navigation
* [x] Automatic project creation
* [x] VS Code integration
* [x] Android Studio integration
* [x] Android project detection
* [x] Docker Desktop integration
* [x] Docker Compose integration
* [x] Bash autocomplete

### Coming next

* [ ] Automatic language detection
* [ ] IntelliJ IDEA support
* [ ] PyCharm support
* [ ] WebStorm support
* [ ] Rider support
* [ ] Project templates
* [ ] Git repository initialization
* [ ] Plugin system
* [ ] `pd doctor`
* [ ] Interactive mode
* [ ] Workspace profiles

---

# Why "ProjDesk"?

A developer's desk should feel organized.

You shouldn't have to remember where your projects live, which IDE they use, or whether Docker needs to be running.

ProjDesk becomes your development desk.

Everything you need.

One command away.

---

# License

MIT

