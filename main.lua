local url = arg[1]
local output_folder = arg[2] or "output"

local c = require("component")
local fs = require("filesystem")
local http = require("http")

function save_image(url, output_folder)
    local path = output_folder .. "/" .. url:match("[^/]+$")
    if not fs.exists(path) then
        local data, response = http.request(url)
        if response.code == 200 then
            local file = fs.open(path, "w")
            file.write(data)
            file.close()
        end
    end
end

function download_page(url)
    local respbody = {}
    local options = {
      url = url,
      sink = ltn12.sink.table(respbody),
      redirect = true
    }
      local response = nil
  
    if url:starts('https') then
      options.redirect = false
      response = {https.request(options)}
    else
      response = {http.request(options)}
    end
  
    local code = response[2]
    local headers = response[3]
    local status = response[4]
  
    if code ~= 200 then return nil end
  
    local filepath = download_path..'/'..string.match(url, "/([^/]+)$")
    print("Saving to "..filepath)

    local file = io.open(filepath, "w+")
    file:write(table.concat(respbody))
    file:close()
    return filepath
end


function get_images(url)
    local html = http.request(url)
    local images = {}
    for img in html:gmatch("<img[^>]+src=\"([^\"]+)\"") do
        images[#images + 1] = img
    end
    return images
end




