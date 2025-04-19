# CC:Tweaked VMTech apps loader

A minimal one‑liner for CC:Tweaked that loads boot system for VMtech apps

```lua
load(http.get("https://raw.githubusercontent.com/Vide0Master/vmtech-computercraft-apps/refs/heads/main/INIT.lua").readAll())()
```