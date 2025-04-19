local function main()
    local url = "https://raw.githubusercontent.com/Vide0Master/vmtech-computercraft-apps/refs/heads/main/APPMANAGER.lua"
    local file_path = "APPMANAGER.lua"

    print("Downloading APPMANAGER.lua...")
    local response = http.get(url)
    if not response then
        print("Error: Connection failed")
        return
    end

    local content = response.readAll()
    response.close()

    print("Writing file...")
    local file = fs.open(file_path, "w")
    if not file then
        print("Error: Cannot write to " .. file_path)
        return
    end

    file.write(content)
    file.close()

    print("Launching APPMANAGER...")
    shell.setDir('./')
    shell.run(file_path)
end

main()
