-- The functions here were extrated from mind.nvim plugin's creator (phaazon) at:
--    https://github.com/phaazon/config/blob/master/nvim/lua/pkg/mind.lua
-- , at "config.keybindings" key.

local mind = require("mind")
local mind_commands = require("mind.commands")
local mind_node = require("mind.node")

local M = {}

function M.mind_custom_create_node_index_on_main_tree()
	-- phaazon dot_files repo key = "<leader>mc",
	mind.wrap_main_tree_fn(function(args)
		mind_commands.create_node_index(args.get_tree(), mind_node.MoveDir.INSIDE_END, args.save_tree, args.opts)
	end)
end

function M.mind_custom_initialize_smart_project_tree()
	-- phaazon dot_files repo key = "<leader>mi",
	vim.notify("initializing project tree")
	mind.wrap_smart_project_tree_fn(function(args)
		local tree = args.get_tree()

		local _, tasks = mind_node.get_node_by_path(tree, "/Tasks", true)
		tasks.icon = "陼"

		local _, backlog = mind_node.get_node_by_path(tree, "/Tasks/Backlog", true)
		backlog.icon = " "

		local _, on_going = mind_node.get_node_by_path(tree, "/Tasks/On-going", true)
		on_going.icon = " "

		local _, done = mind_node.get_node_by_path(tree, "/Tasks/Done", true)
		done.icon = " "

		local _, cancelled = mind_node.get_node_by_path(tree, "/Tasks/Cancelled", true)
		cancelled.icon = " "

		local _, notes = mind_node.get_node_by_path(tree, "/Notes", true)
		notes.icon = " "

		args.save_tree()
	end)
end

function M.mind_custom_copy_node_link_index_on_smart_project_tree()
	-- phaazon dot_files repo key = "<leader>ml",
	mind.wrap_smart_project_tree_fn(function(args)
		mind_commands.copy_node_link_index(args.get_tree(), nil, args.opts)
	end)
end

function M.mind_custom_copy_node_link_index_on_main_tree()
	-- phaazon dot_files repo key = "<leader>Ml",
	mind.wrap_main_tree_fn(function(args)
		mind_commands.copy_node_link_index(args.get_tree(), nil, args.opts)
	end)
end

function M.mind_custom_open_data_index_on_smart_project_tree()
	-- phaazon dot_files repo key = "<leader>ms",
	mind.wrap_smart_project_tree_fn(function(args)
		mind_commands.open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
	end)
end

function M.mind_custom_open_data_index_on_main_project_tree()
	-- phaazon dot_files repo key = "<leader>Ms",
	mind.wrap_main_tree_fn(function(args)
		mind_commands.open_data_index(args.get_tree(), args.data_dir, args.save_tree, args.opts)
	end)
end
