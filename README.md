# GogHub Anime TD — release

Upload `anime-td.lua` from this folder to a public GitHub repo (or Gist), copy its **Raw** URL, and share:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/c0nsir/gogrouter/main/anime-td.lua"))()
```

The UI icons are embedded in the file and written to `workspace/GogHub/AnimeTD/Assets` on first run.
To update: rebuild with `python build.py --release --url <raw-url>` and push the new `anime-td.lua`.
