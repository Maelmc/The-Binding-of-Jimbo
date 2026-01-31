local function load_file(file, load_item)
  if file.init then
    file.init()
  end
  if file.list then
    for _, item in ipairs(file.list) do
      if file.config_key then
        item.agar_config_key = file.config_key
        if not agarmons_config[item.agar_config_key] then
          item.no_collection = true
        end
      end
      load_item(item)
    end
  end
end

local function load_directory(path, load_item, options)
  options = options or {}
  local files = NFS.getDirectoryItems(SMODS.current_mod.path .. path)

  for _, file_path in ipairs(files) do
    local file_type = NFS.getInfo(SMODS.current_mod.path .. path .. '/' .. file_path).type

    if file_type == "directory" then
      load_directory(path .. '/' .. file_path, load_item, options)
    elseif file_type ~= "symlink" then
      local file = assert(SMODS.load_file(path .. '/' .. file_path))()

      if type(file) == 'table' and file.can_load ~= false then
        if options.pre_load then options.pre_load(file) end
        load_file(file, load_item)
        if options.post_load then options.post_load(file) end
      end
    end
  end
end

return load_directory