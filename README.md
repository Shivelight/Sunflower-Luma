# 🌻

#### How to install

1. Download [latest release](https://github.com/Shivelight/Sunflower-Luma/releases).
2. Extract to any folder.
3. Run `1_get_steam_dir.cmd` or set `steam_path.txt` manually.
4. Run `2_generate_shortcut.cmd`. This will generate `Steam (GreenLuma)` shortcut you may pin to start menu.
5. (Optional) Run `3_add_cleanup_on_startup.cmd`. This will add a startup task to the Windows Task Scheduler to clean up the leftover `user32.dll` (from previous GreenLuma launch) caused by an unexpected shutdown. You can remove the task at any time by running `3b_remove_cleanup_on_startup.cmd`.

#### Launching GreenLuma

1. Launch `Steam (GreenLuma)` from start menu.
2. (Optional) Run `DeleteSteamAppCache` ONLY if you are having problems unlocking games or DLC.
3. Refresh the AppList. Next time you launch, only refresh if you have installed a new game or DLC from the Family Library. Read more below.
4. Downloads are blocked by GreenLuma. Launch Steam without GreenLuma to download new games and DLC.
5. **GreenLuma is automatically removed** after exiting Steam.

#### AppList

The AppList is automatically generated and contains all games and DLC installed from your Family Library. This ensures the owner has priority access to their shared licenses.

tl;dr: It's for unlocking or bypassing a legitimate copy without occupying the license.

#### Credits

- `user32SF.dll`: GreenLuma 2026 1.7.8 by Steam006
- `DeleteSteamAppCache.exe`: GreenLuma 2026 1.7.8 by Steam006

#### Sunflower?

It's our Steam Family name.
