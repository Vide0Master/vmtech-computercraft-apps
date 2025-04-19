
local url = "https://raw.githubusercontent.com/Vide0Master/vmtech-computercraft-apps/refs/heads/main/APPMANAGER.lua"
local file_path = "/rom/APPMANAGER.lua"

local response = http.get(url)
if not response then
    print("Ошибка подключения к GitHub")
    return
end

local content = response.readAll()
response.close()

local file = fs.open(file_path, "w")
file.write(content)
file.close()

print("Файл сохранён в "..file_path)

-- Запускаем сохранённый файл
shell.run(file_path)