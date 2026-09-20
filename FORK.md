# Personal fork

Personal build of [rxhanson/Rectangle](https://github.com/rxhanson/Rectangle), not meant for upstream.
The patches live on the `seven-eighths` branch on top of the official `v1.100` tag; `main` just tracks upstream.

## What it changes

Both changes keep a small panel app pinned to the left edge of the screen visible — Nook
(`com.wecouldbe.nook`) here. They reuse two actions that were otherwise unbound.

The bundle id is read from `UserDefaults`, so it can be pointed at another app without rebuilding:

```sh
defaults write com.knollsoft.Rectangle sidePanelBundleId -string "com.example.app"
```

| Action | Shortcut | Panel on the left of this screen | Otherwise |
|---|---|---|---|
| `lastThreeFourths` | ⌃⌥K | from the panel's right edge (+8pt) to the screen edge, full height | right 7/8 |
| `firstThreeFourths` | ⌃⌥M | two thirds of the screen width, starting at the panel's right edge (+8pt), full height | left 2/3 |

The panel frame is read through the accessibility API when the shortcut is pressed, so it follows
the panel's width and whichever display it is on.

Code:
- `Rectangle/WindowCalculation/LastThreeFourthsCalculation.swift`: K, plus the shared `sessionBoardFrame()`
- `Rectangle/WindowCalculation/FirstThreeFourthsCalculation.swift`: M (`calculateRect` only,
  since `landscapeRect` is also called by other calculations)

## Build, install and update

The full procedure, the settings plist and the pitfalls hit so far (code signing, accessibility
permission, LaunchServices picking up the build copy, the welcome dialog overwriting settings)
are in the dotfiles repo, `macos/README.md`. Short version for updating:

```sh
git fetch upstream --tags
git rebase --onto <new-tag> <current-base-tag> seven-eighths   # base is v1.100 today; git describe --tags --abbrev=0
# build and install as described in dotfiles
git push -f origin seven-eighths
```
