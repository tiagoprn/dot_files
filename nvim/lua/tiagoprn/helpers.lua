local command = vim.api.nvim_command

local Job = require("plenary.job")

local M = {}

local open_mode = "split" -- or tabedit, vsplit...

function M.readLines(file)
	local f = io.open(file, "r")
	local lines = f:read("*all")
	f:close()
	return lines
end

function M.get_file_exists(full_file_path)
	local file_exists = vim.fn.findfile(full_file_path)
	if file_exists == nil or file_exists == "" then
		-- vim.notify("full_file_path: " .. full_file_path .. " DOES NOT exist!")
		return false
	else
		-- vim.notify("full_file_path: " .. full_file_path .. " exists!")
		return true
	end
end

function M.writeLine(file, line)
	local f = io.open(file, "a")
	io.output(f)
	io.write(line .. "\n")
	io.close(f)
end

function M.writeLines(file, lines)
	local f = io.open(file, "w")
	io.output(f)

	-- print('Writing processed lines to file...')
	for key, value in ipairs(lines) do
		-- print(key..value..'(type: '..type(value)..')')
		io.write(value .. "\n")
	end

	io.close(f)
end

function M.linuxCommand(commandName, args)
	Job:new({
		command = commandName,
		args = args,
		on_exit = function(j, return_val)
			-- print(return_val)
			if return_val == 0 then
				print('[scratchpad] Command "' .. commandName .. '" successfully executed.')
			end
			print(j:result())
		end,
	}):sync() -- or start()
end

function M.createTimestampedFileWithSnippet(directoryPath, exCommandsFile)
	local currentDate = os.date("%Y-%m-%d-%H%M%S")
	local suffix = math.random(100, 999)
	local fileName = currentDate .. "-" .. suffix .. ".md"
	local timestampedFile = directoryPath .. "/" .. fileName

	M.linuxCommand("mkdir", { "-p", directoryPath })

	local vimOpenFileCommand = open_mode .. timestampedFile
	command(vimOpenFileCommand)

	local vimExCommands = "source " .. exCommandsFile
	command(vimExCommands)
end

function M.createAlternativeFormatTimestampedFileWithSnippet(directoryPath, exCommandsFile)
	local currentDate = os.date("%Y-%m-%d-%H-%M-%S")
	local fileName = currentDate .. ".md"
	local timestampedFile = directoryPath .. "/" .. fileName
	local vimOpenFileCommand = open_mode .. timestampedFile
	command(vimOpenFileCommand)

	local vimExCommands = "source " .. exCommandsFile
	command(vimExCommands)
end

function M.createSluggedFileWithSnippet(directoryPath, exCommandsFile, slug, post_name)
	local fileName = slug .. ".md"
	local fullFilePath = directoryPath .. "/" .. fileName

	M.linuxCommand("mkdir", { "-p", directoryPath })

	M.writeLine(fullFilePath, post_name)

	local vimOpenFileCommand = open_mode .. fullFilePath
	command(vimOpenFileCommand)

	local vimExCommands = "source " .. exCommandsFile
	command(vimExCommands)
end

function M.slugify(phrase)
	local charmap = {
		[" "] = "-",
		["/"] = "-",
	}

	for k, _ in pairs(charmap) do
		phrase = phrase:gsub(tostring(k), charmap[k])
	end

	local emptify = "!?'=\""
	for i = 1, #emptify do
		local char = emptify:sub(i, i)
		phrase = phrase:gsub(char, "")
	end

	return string.lower(phrase)
end

function M.string_split(str, pattern)
	-- USAGE:
	-- local str = "abc,123,hello,ok"
	-- local list = string_split(str, ",")
	-- for _, s in ipairs(list) do
	--   print(tostring(s))
	-- end
	--
	local result = {}
	string.gsub(str, "[^" .. pattern .. "]+", function(w)
		table.insert(result, w)
	end)
	return result
end

function M.set(list)
	-- Builds the equivalent of a python's set.
	-- USAGE:
	-- local helpers = require("tiagoprn.helpers")
	-- local items = helpers.set({ "apple", "orange", "pear", "banana" })
	-- if items["orange"] then
	--   print("Orange is on the items!")
	-- else
	--   print("Orange is NOT on the items!")
	-- end

	local set = {}
	for _, value in ipairs(list) do
		set[value] = true
	end
	return set
end

function M.search_on_list(all_items, search_items)
	local set_items = M.set(all_items)
	local found_elements = {}
	for _, element in ipairs(search_items) do
		if set_items[element] then
			table.insert(found_elements, element)
		end
	end
	return found_elements
end

function M.current_window_number()
	return vim.api.nvim_win_get_number(0)
end

return M
