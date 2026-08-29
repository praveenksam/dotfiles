# Friendly tool-call labels in chat

## Context

`MessageList.tsx` currently renders AI tool-invocation parts as a raw badge showing the literal tool name (e.g. `str_replace_editor`), which means nothing to a non-technical user. We want a human-readable message instead (e.g. "Creating Card.jsx" / "Editing Card.jsx"), pulled into its own component with tests, per the user's request.

Confirmed via exploration: the tool-invocation badge is rendered in exactly one place (`src/components/chat/MessageList.tsx:77-93`), there's no existing badge/pill component to reuse in `src/components/ui/`, and the two tool names in play are `str_replace_editor` (`src/lib/tools/str-replace.ts`, args: `{command: "view"|"create"|"str_replace"|"insert"|"undo_edit", path, ...}`) and `file_manager` (`src/lib/tools/file-manager.ts`, args: `{command: "rename"|"delete", path, new_path}`).

## Approach

Create `src/components/chat/ToolCallBadge.tsx`:
- Props: `toolName: string`, `args: any`, `state: string`, `result?: any` (mirrors `part.toolInvocation` fields already used in MessageList).
- Helper `getFileName(path)` — basename via `path.split("/").filter(Boolean).pop()`.
- Helper `getToolMessage(toolName, args)`:
  - `str_replace_editor`: `create` → "Creating {file}", `str_replace`/`insert` → "Editing {file}", `view` → "Viewing {file}", `undo_edit` → "Reverting {file}".
  - `file_manager`: `delete` → "Deleting {file}", `rename` → "Renaming {file} to {newFile}".
  - Any other/unrecognized case (including missing path, e.g. empty args) → fall back to the raw `toolName` string, so existing behavior is preserved when args are absent.
- Render: same visual shell as today (`inline-flex ... bg-neutral-50 rounded-lg text-xs font-mono border`), green dot when `state === "result" && result`, `Loader2` spinner otherwise. Only the label text changes from `toolName` to the friendly message.

Update `src/components/chat/MessageList.tsx`:
- Replace the inline `tool-invocation` case body (lines ~77-93) with `<ToolCallBadge key={partIndex} toolName={tool.toolName} args={tool.args} state={tool.state} result={tool.state === "result" ? tool.result : undefined} />`.
- Remove now-unused inline JSX/logic for that case.

Add `src/components/chat/__tests__/ToolCallBadge.test.tsx` (vitest + Testing Library, following the existing pattern in `MessageList.test.tsx`) covering:
- `str_replace_editor` + `create` → "Creating Card.jsx"
- `str_replace_editor` + `str_replace` → "Editing Card.jsx"
- `str_replace_editor` + `insert` → "Editing Card.jsx"
- `str_replace_editor` + `view` → "Viewing Card.jsx"
- `file_manager` + `delete` → "Deleting Card.jsx"
- `file_manager` + `rename` (path + new_path) → "Renaming Card.jsx to Button.jsx"
- Unrecognized toolName/args → falls back to raw tool name
- `state === "result"` with a result → green-dot indicator shown, spinner absent
- non-`result` state → spinner (`Loader2`, `.animate-spin`) shown, green dot absent

`src/components/chat/__tests__/MessageList.test.tsx` should not need changes — its existing tool-invocation test uses `args: {}` with no `path`, which falls through to the raw-toolName fallback, so the existing assertion (`screen.getByText("str_replace_editor")`) still holds.

## Verification

- `npx vitest run src/components/chat/__tests__/ToolCallBadge.test.tsx src/components/chat/__tests__/MessageList.test.tsx` — all passing.
- `npm test` — full suite still green (no regressions elsewhere).
