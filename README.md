# Fresh RSS Reader

Fresh RSS Reader is a rewritten version of the EAF RSS Reader module, aiming to provide a more reasonable and stable implementation while maintaining compatibility with the parent project EAF and Doom Emacs.

## Overview

- **Purpose**: Rewrite to address the original version no longer being maintained, improve architecture and interaction model, and enhance stability
- **Runtime**: Based on EAF (QWebEngine + Python bridge), not switching to an independent frontend
- **Compatibility**: Designed to load as a module, with key bindings coordinated with Doom Emacs style, and theme/configuration integration approach natural

## Core Features

- **Feed Management**: Add/remove feeds, display feed list and basic information
- **Article Reading**: Display article list, open articles for reading
- **Read Marking**: Mark articles as read, status reflected in the list
- **OPML Import/Export**: Support importing feed list from OPML, exporting current list
- **Interaction Model**: List + detail in same view, support fullscreen detail, return to list via shortcut keys
- **State Management**: Lightweight centralized state module (Vue 3 Composition API), extensible to Pinia later

## Tech Stack

- **Frontend**: Vue 3 + Composition API (`<script setup>`) + Vite
- **Backend**: Python (EAF Buffer system, inheriting from `BrowserBuffer`)
- **Communication**:
  - Python ↔ JavaScript: via QWebChannel (`pyqtSlot` / `eval_js_function`)
  - Python ↔ Elisp: via `eval_in_emacs` / `@interactive`
- **Build**: Vite, output placed in `dist/`, loaded by Python

## Project Structure

```
fresh-rss-reader/
├── buffer.py                     # Python backend (AppBuffer)
├── eaf-fresh-rss-reader.el       # Elisp config, key bindings, module registration
├── package.json                  # Frontend dependencies and scripts
├── vite.config.js                # Vite configuration
├── index.html                    # Entry HTML
├── src/
│   ├── main.js                   # Vue 3 entry
│   ├── App.vue                   # Root component (view switching)
│   ├── state/useAppState.js      # Centralized state module
│   ├── components/               # FeedList / ArticleList / ArticleView etc.
│   ├── services/qweb.js          # QWebChannel wrapper
│   └── styles/main.css           # Basic styles
└── dist/                         # Build output
```

## Usage

1. Place the module in the EAF application directory
2. Load `eaf-fresh-rss-reader` in Emacs configuration
3. Start the application: `M-x eaf-open-fresh-rss-reader`

### Common Shortcuts (Draft)

- `f`: Open current article
- `q`: Return to list (primary return command)
- `j` / `k`: Next article / Previous article
- `n` / `p`: Next feed / Previous feed
- `F`: Toggle fullscreen / inline
- `m`: Mark current article as read

> Key bindings are registered via Elisp `defcustom` and configurable, designed to avoid conflicts with common Doom Emacs Evil keys.

## Documentation

- Design Clarifications: `doc/design-clarifications.md`
- Architecture Design: `doc/architecture.md`
- Implementation Phases: `doc/implementation-phases.md`
- Style Guide: `doc/style-guide.md`

## Status

- Currently in architecture design and phased planning stage
- Future implementation following phases: frontend skeleton → views and data flow → reading flow and return path → data refresh and storage → OPML and management features → theme adaptation and compatibility finalization

## License

Follows GNU GPL v3 or later (consistent with EAF project).
