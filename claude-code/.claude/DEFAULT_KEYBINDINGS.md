# Claude CLI Default Keybindings Reference

## Chat Context (Main Input)

| Action                | Default Keybinding           | Description                           |
|-----------------------|------------------------------|---------------------------------------|
| `chat:cancel`         | Escape                       | Cancel current input                  |
| `chat:clearInput`     | Ctrl+L                       | Clear input / Force screen redraw     |
| `chat:clearScreen`    | Cmd+K                        | Clear screen (press twice for /clear) |
| `chat:killAgents`     | Ctrl+X Ctrl+K                | Kill all background subagents         |
| `chat:cycleMode`      | Shift+Tab*                   | Cycle permission modes                |
| `chat:modelPicker`    | Meta+P                       | Open model picker                     |
| `chat:fastMode`       | Meta+O                       | Toggle fast mode                      |
| `chat:thinkingToggle` | Meta+T                       | Toggle extended thinking              |
| `chat:submit`         | **Enter**                    | Submit message                        |
| `chat:newline`        | **Ctrl+J**                   | Insert newline without submitting     |
| `chat:undo`           | Ctrl+_, Ctrl+Shift+-         | Undo last action                      |
| `chat:externalEditor` | Ctrl+G, Ctrl+X Ctrl+E        | Open in external editor               |
| `chat:stash`          | Ctrl+S                       | Stash current prompt                  |
| `chat:imagePaste`     | Ctrl+V (Alt+V on Win/WSL)    | Paste image from clipboard            |

\*On Windows without VT mode: Meta+M

## App/Global Actions

| Action                 | Default | Description              |
|------------------------|---------|--------------------------|
| `app:interrupt`        | Ctrl+C  | Cancel current operation |
| `app:exit`             | Ctrl+D  | Exit Claude Code         |
| `app:toggleTodos`      | Ctrl+T  | Toggle task list         |
| `app:toggleTranscript` | Ctrl+O  | Toggle verbose transcript|

## History Actions

| Action             | Default | Description           |
|--------------------|---------|----------------------|
| `history:search`   | Ctrl+R  | Open history search  |
| `history:previous` | Up      | Previous history item|
| `history:next`     | Down    | Next history item    |

## Autocomplete Context

| Action                  | Default | Description         |
|-------------------------|---------|---------------------|
| `autocomplete:accept`   | Tab     | Accept suggestion   |
| `autocomplete:dismiss`  | Escape  | Dismiss menu        |
| `autocomplete:previous` | Up      | Previous suggestion |
| `autocomplete:next`     | Down    | Next suggestion     |

## Your Custom Configuration

Currently in `~/.claude/keybindings.json`:

```json
{
  "context": "Chat",
  "bindings": {
    "enter": "chat:newline",        // Enter adds newline (custom)
    "ctrl+j": null,                  // Ctrl+J disabled (custom)
    "ctrl+s": "chat:submit",         // Ctrl+S submits (custom)
    "tab": "chat:cycleMode",         // Tab cycles modes
    "shift+tab": null                // Shift+Tab disabled (custom)
  }
}
```

## Reserved Shortcuts (Cannot be rebound)

- **Ctrl+C** - Hardcoded interrupt/cancel
- **Ctrl+D** - Hardcoded exit
- **Ctrl+M** - Identical to Enter in terminals
- **Caps Lock** - Not delivered to terminal apps

## Terminal Multiplexer Conflicts

- **Ctrl+B** - tmux prefix (press twice to send through)
- **Ctrl+A** - GNU screen prefix
- **Ctrl+Z** - Unix process suspend (SIGTSTP)

## Documentation

Full docs: https://code.claude.com/docs/en/keybindings
Schema: https://www.schemastore.org/claude-code-keybindings.json
