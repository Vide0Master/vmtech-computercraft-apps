-- Initialize graphics
term.setBackgroundColor(colors.white)
term.clear()
term.setTextColor(colors.gray)
term.setCursorPos(1, 1)

local function drawProgressBar(percent)
    local w, h = term.getSize()
    local barWidth = 30
    local progress = math.floor(barWidth * percent)

    -- Center text
    term.setCursorPos((w - #"Loading APPMANAGER.lua") / 2, h / 2 - 2)
    write("Loading APPMANAGER.lua")

    -- Draw progress bar
    term.setCursorPos((w - barWidth) / 2, h / 2)
    term.write("[")
    term.setBackgroundColor(colors.lightGray)
    term.write((" "):rep(progress))
    term.setBackgroundColor(colors.white)
    term.write((" "):rep(barWidth - progress))
    term.write("]")
end

local function main()
    local url = "https://raw.githubusercontent.com/Vide0Master/vmtech-computercraft-apps/refs/heads/main/APPMANAGER.lua"
    local file_path = "APPMANAGER.lua"

    -- Initial draw
    drawProgressBar(0)

    -- Download file
    local response = http.get(url)
    if not response then
        term.setCursorPos(1, 20)
        term.setTextColor(colors.red)
        print("Connection error!")
        return
    end

    local content = response.readAll()
    response.close()

    -- Save with progress
    local file = fs.open(file_path, "w")
    if not file then
        term.setBackgroundColor(colors.black)
        term.clear()
        error("Failed to open file for writing: " .. file_path)
    end

    local total = #content
    local written = 0

    for i = 1, total, 100 do
        local chunk = content:sub(i, math.min(i + 99, total))
        file.write(chunk)
        written = written + #chunk
        drawProgressBar(math.min(written / total, 1))
    end

    file.close()

    -- Launch
    term.clear()
    shell.run(file_path:match("(.+)%..+$"))
end

main()
