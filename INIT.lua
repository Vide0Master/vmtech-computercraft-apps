term.setBackgroundColor(colors.white)
term.clear()
term.setTextColor(colors.gray)
term.setCursorPos(1, 1)

--progress bar
local function drawProgressBar(percent)
    local w, h = term.getSize()
    local barWidth = 30
    local progress = math.floor(barWidth * percent)

    term.setCursorPos((w - #"Loading APPMANAGER.lua") / 2, h / 2 - 2)
    write("Loading APPMANAGER.lua")

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
    local file_path = "/rom/APPMANAGER.lua"

    drawProgressBar(0)

    local response = http.get(url)
    if not response then
        term.setCursorPos(1, 20)
        term.setTextColor(colors.red)
        print("Connection error!")
        return
    end

    local content = response.readAll()
    response.close()

    local file = fs.open(file_path, "w")
    local total = #content
    local written = 0

    for i = 1, total, 100 do
        file.write(content:sub(i, i + 99))
        written = written + 100
        drawProgressBar(math.min(written / total, 1))
    end

    file.close()

    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1, 1)
    shell.run(file_path)
end

main()
