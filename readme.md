# CC:Tweaked One‑Line INIT.lua Loader

A minimal one‑liner for CC:Tweaked that fetches **INIT.lua** from your GitHub repository and executes it immediately.

```lua
load(http.get("https://raw.githubusercontent.com/YourUser/YourRepo/main/INIT.lua").readAll())()
```