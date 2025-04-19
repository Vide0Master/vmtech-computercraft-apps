-- Initialize graphics
term.setBackgroundColor(colors.white)
term.clear()
term.setTextColor(colors.gray)
term.setCursorPos(1, 1)

local function drawProgressBar(percent, text)
    local w, h = term.getSize()
    local barWidth = 30
    local progress = math.floor(barWidth * percent)
    
    -- Center text
    term.setCursorPos((w - #text)/2, h/2 - 2)
    write(text)
    
    -- Draw progress bar
    term.setCursorPos((w - barWidth)/2, h/2)
    term.write("[")
    term.setBackgroundColor(colors.lightGray)
    term.write((" "):rep(progress))
    term.setBackgroundColor(colors.white)
    term.write((" "):rep(barWidth - progress))
    term.write("]")
end

local function getFloppyDrives()
    local drives = {}
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "drive" then
            table.insert(drives, name)
        end
    end
    return drives
end

local function selectDrive(drives)
    if #drives == 0 then return nil end
    if #drives == 1 then return drives[1] end
    
    term.setBackgroundColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
    print("Select floppy drive:")
    
    for i, drive in ipairs(drives) do
        print(string.format("%d. %s", i, drive))
    end
    
    while true do
        term.write("> ")
        local input = tonumber(read())
        if input and input >= 1 and input <= #drives then
            return drives[input]
        end
    end
end

local function main()
    -- Detect floppy drives
    local drives = getFloppyDrives()
    if #drives == 0 then
        term.setBackgroundColor(colors.black)
        term.clear()
        error("No floppy drives found!")
    end
    
    -- Select target drive
    local selectedDrive = selectDrive(drives)
    local mountPath = peripheral.getMountPath(selectedDrive)
    local file_path = fs.combine(mountPath, "APPMANAGER.lua")
    
    -- Check write capability
    if peripheral.call(selectedDrive, "isDiskReadOnly") then
        term.setBackgroundColor(colors.black)
        term.clear()
        error("Floppy is read-only!")
    end
    
    -- Start download process
    drawProgressBar(0, "Downloading APPMANAGER.lua")
    
    local url = "https://raw.githubusercontent.com/Vide0Master/vmtech-computercraft-apps/refs/heads/main/APPMANAGER.lua"
    local response = http.get(url)
    if not response then
        term.setCursorPos(1, 20)
        term.setTextColor(colors.red)
        print("Connection error!")
        return
    end
    
    local content = response.readAll()
    response.close()
    
    -- Write to floppy
    local file = fs.open(file_path, "w")
    if not file then
        term.setBackgroundColor(colors.black)
        term.clear()
        error("Failed to open floppy for writing")
    end
    
    local total = #content
    local written = 0
    
    for i = 1, total, 100 do
        local chunk = content:sub(i, math.min(i + 99, total))
        file.write(chunk)
        written = written + #chunk
        drawProgressBar(math.min(written/total, 1), "Writing to "..selectedDrive)
    end
    
    file.close()
    
    -- Completion message
    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1, 1)
    print("Successfully wrote to:")
    print(" "..selectedDrive)
    print("Path: "..file_path)
    print("Press any key to run")
    os.pullEvent("key")
    shell.run(file_path)
end

main()