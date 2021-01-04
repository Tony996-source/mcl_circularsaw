local workbench = {}
WB = {}
screwdriver = screwdriver or {}
local min, ceil = math.min, math.ceil

-- Nodes allowed to be cut
-- Only the regular, solid blocks without metas or explosivity can be cut
local nodes = {}
for node, def in pairs(minetest.registered_nodes) do
	if (def.drawtype == "normal" or def.drawtype:sub(1,5) == "glass") and
	   (def.groups.pickaxey or def.groups.axey or def.groups.handy) and
	   not def.on_construct and
	   not def.after_place_node and
	   not def.on_rightclick and
	   not def.on_blast and
	   not def.allow_metadata_inventory_take and
	   not (def.groups.not_in_creative_inventory == 1) and
	   not (def.groups.not_cuttable == 1) and
	   not def.mesecons and
	   def.description and
	   def.description ~= "" and
	   def.light_source == 0
	then
		nodes[#nodes+1] = node
	end
end

-- Optionally, you can register custom cuttable nodes in the workbench
WB.custom_nodes_register = {
	-- "default:leaves",
}

setmetatable(nodes, {
	__concat = function(t1, t2)
		for i=1, #t2 do
			t1[#t1+1] = t2[i]
		end
		return t1
	end
})

nodes = nodes..WB.custom_nodes_register

-- Nodeboxes definitions
workbench.defs = {
	-- Name       Yield   X  Y   Z  W   H  L
	{"nanoslab",	16, { 0, 0,  0, 8,  1, 8  }},
	{"micropanel",	16, { 0, 0,  0, 16, 1, 8  }},
	{"microslab",	8,  { 0, 0,  0, 16, 1, 16 }},
	{"thinstair",	8,  { 0, 7,  0, 16, 1, 8  },
			    { 0, 15, 8, 16, 1, 8  }},
	{"cube", 	4,  { 0, 0,  0, 8,  8, 8  }},
	{"panel",	4,  { 0, 0,  0, 16, 8, 8  }},
	{"slab", 	2,  {0, 0, 0, 16, 8, 16}},
	{"doublepanel", 2,  { 0, 0,  0, 16, 8, 8  },
			    { 0, 8,  8, 16, 8, 8  }},
	{"halfstair",	2,  { 0, 0,  0, 8,  8, 16 },
			    { 0, 8,  8, 8,  8, 8  }},
	{"outerstair",	1,  { 0, 0,  0, 16, 8, 16 },
			    { 0, 8,  8, 8,  8, 8  }},
	{"stair",	1,  {0, 0, 0, 16, 8, 16},
					{0, 8, 8, 16, 8, 8}},
	{"innerstair",	1,  { 0, 0,  0, 16, 8, 16 },
			    { 0, 8,  8, 16, 8, 8  },
			    { 0, 8,  0, 8,  8, 8  }}
}

function workbench:get_output(inv, input, name)
	local output = {}
	for _, n in pairs(self.defs) do
		local count = min(n[2] * input:get_count(), input:get_stack_max())
		local item = name.."_"..n[1]
		output[#output+1] = item.." "..count
	end
	inv:set_list("forms", output)
end

-- Thanks to kaeza for this function
function workbench:pixelbox(size, boxes)
	local fixed = {}
	for _, box in pairs(boxes) do
		-- `unpack` has been changed to `table.unpack` in newest Lua versions
		local x, y, z, w, h, l = unpack(box)
		fixed[#fixed+1] = {
			(x / size) - 0.5,
			(y / size) - 0.5,
			(z / size) - 0.5,
			((x + w) / size) - 0.5,
			((y + h) / size) - 0.5,
			((z + l) / size) - 0.5
		}
	end
	return {type="fixed", fixed=fixed}
end

local formspecs = {
	-- Main formspec
	"label[0,0;Circular Saw]"..
	  mcl_formspec.get_itemslot_bg(1.5,1,1,1)..
      mcl_formspec.get_itemslot_bg(4,0,4,3)..
	  [[image[2.7,1;1,1;gui_furnace_arrow_bg.png^[transformR270]
	   image[0.5,1;1,1;workbench_saw.png]
	   list[context;input;1.5,1;1,1;]
	   list[context;forms;4,0;4,3;] ]],
}

function workbench:set_formspec(meta, id)
	meta:set_string("formspec", "size[9,7;]list[current_player;main;0,3.25;9,4;]"..
			formspecs[id]..mcl_formspec.get_itemslot_bg(0,3.25,9,4))
end

function workbench.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("input", 1)
	inv:set_size("forms", 4*3)

	meta:set_string("infotext", "Circular Saw")
	workbench:set_formspec(meta, 1)
end

function workbench.fields(pos, _, fields)
	local meta = minetest.get_meta(pos)
end

function workbench.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("input")
end

function workbench.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if(listname == "input" and minetest.registered_nodes[stackname.."_cube"]) then
		return stack:get_count()
	end
	return 0
end

function workbench.on_put(pos, listname, _, stack)
	local inv = minetest.get_meta(pos):get_inventory()
	if listname == "input" then
		local input = inv:get_stack("input", 1)
		workbench:get_output(inv, input, stack:get_name())
end
end

function workbench.on_take(pos, listname, index, stack, player)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1)
	local inputname = input:get_name()
	local stackname = stack:get_name()

	if listname == "input" then
		if stackname == inputname then
			workbench:get_output(inv, input, stackname)
		else
			inv:set_list("forms", {})
		end
	elseif listname == "forms" then
		local fromstack = inv:get_stack(listname, index)
		if not fromstack:is_empty() and fromstack:get_name() ~= stackname then
			local player_inv = player:get_inventory()
			if player_inv:room_for_item("main", fromstack) then
				player_inv:add_item("main", fromstack)
			end
		end

		input:take_item(ceil(stack:get_count() / workbench.defs[index][2]))
		inv:set_stack("input", 1, input)
		workbench:get_output(inv, input, inputname)
	end
end

minetest.register_node("mcl_circularsaw:circularsaw", {
	description = "Work Bench",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.4375, -0.0625, 0, 0.4375, 0.1875, 0},
			{-0.375, 0.1875, 0, 0.375, 0.3125, 0},
			{-0.3125, 0.3125, 0, 0.3125, 0.375, 0},
			{-0.1875, 0.375, 0, 0.1875, 0.4375, 0},
		},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {pickaxey=2},
	tiles = {"stonecutter_top.png",
		"stonecutter_bottom.png",
		"stonecutter_side.png",
		"stonecutter_side.png",
		"stonecutter_front.png",
		"stonecutter_front.png"},
	on_rotate = screwdriver.rotate_simple,
	stack_max = 64,
	sounds = mcl_sounds.node_sound_stone_defaults(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
	can_dig = workbench.dig,
	on_timer = workbench.timer,
	on_construct = workbench.construct,
	on_receive_fields = workbench.fields,
	on_metadata_inventory_put = workbench.on_put,
	on_metadata_inventory_take = workbench.on_take,
	allow_metadata_inventory_put = workbench.put,
	allow_metadata_inventory_move = workbench.move
})

minetest.register_craft({
	output = "mcl_circularsaw:circularsaw",
	recipe = {
	    {"",               "mcl_core:iron_ingot", ""},
		{"mcl_core:stone", "mcl_core:stone",      "mcl_core:stone"},
		{"mcl_core:stone", "mcl_core:stone",      "mcl_core:stone"}
	}
})

for _, d in pairs(workbench.defs) do
for i=1, #nodes do
	local node = nodes[i]
	local def = minetest.registered_nodes[node]

	if d[3] then
		local groups = {}
		local tiles
		groups.not_in_creative_inventory = 1

		for k, v in pairs(def.groups) do
			if k ~= "wood" and k ~= "stone" and k ~= "level" then
				groups[k] = v
			end
		end

		if def.tiles then
			if #def.tiles > 1 and not (def.drawtype:sub(1,5) == "glass") then
				tiles = def.tiles
			else
				tiles = {def.tiles[1]}
			end
		else
			tiles = {def.tile_images[1]}
		end

		minetest.register_node(":"..node.."_"..d[1], {
			description = def.description.." "..d[1]:gsub("^%l", string.upper),
			use_texture_alpha = true,
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			sounds = def.sounds,
			tiles = tiles,
			groups = groups,
			_mcl_blast_resistance = 2,
	        _mcl_hardness = 2,
			-- `unpack` has been changed to `table.unpack` in newest Lua versions.
			node_box = workbench:pixelbox(16, {unpack(d, 3)}),
			sunlight_propagates = true,
			on_place = minetest.rotate_node
		})
	end
end
end

local colour = {
--     Node          dye       Description    Glass Colour
	{"white",      "white",      "White",      "white"},
	{"silver",     "grey",       "Silver",     "silver"},
	{"grey",       "dark_grey",  "Grey",       "gray"},
	{"black",      "black",      "Black",      "black"},
	{"purple",     "violet",     "Purple",     "purple"},
	{"blue",       "blue",       "Blue",       "blue"},
	{"cyan",       "cyan",       "Cyan",       "cyan"},
	{"green",      "dark_green", "Green",      "green"},
	{"lime",       "green",      "Lime",       "lime"},
	{"yellow",     "yellow",     "Yellow",     "yellow"},
	{"brown",      "brown",      "Brown",      "brown"},
	{"orange",     "orange",     "Orange",     "orange"},
	{"red",        "red",        "Red",        "red"},
	{"magenta",    "magenta",    "Magenta",    "magenta"},
	{"pink",       "pink",       "Pink",       "pink"},
    {"light_blue", "lightblue",  "Light Blue", "light_blue"},
}

for _, colour in pairs(colour) do

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_stair", {
	description = colour[3] .. (" Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_stair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_microslab", {
	description = colour[3] .. (" Micro Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_microslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_nanoslab", {
	description = colour[3] .. (" Nano Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_nanoslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_micropanel", {
	description = colour[3] .. (" Micro Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_micropanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_thinstair", {
	description = colour[3] .. (" Thin Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_thinstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_cube", {
	description = colour[3] .. (" Cube"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_cube",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_panel", {
	description = colour[3] .. (" Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_panel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_slab", {
	description = colour[3] .. (" Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_slab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_doublepanel", {
	description = colour[3] .. (" Double Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_doublepanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_halfstair", {
	description = colour[3] .. (" Half Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_halfstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_outerstair", {
	description = colour[3] .. (" Outer Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_outerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_innerstair", {
	description = colour[3] .. (" Inner Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_innerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})
end

minetest.override_item("mcl_core:glass_stair", {
	description = ("Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_stair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_microslab", {
	description = ("Micro Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_microslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_nanoslab", {
	description = ("Nano Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_nanoslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_micropanel", {
	description = ("Micro Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_micropanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_thinstair", {
	description = ("Thin Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_thinstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_cube", {
	description = ("Cube"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_cube",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_panel", {
	description = ("Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_panel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_slab", {
	description = ("Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_slab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_doublepanel", {
	description = ("Double Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_doublepanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_halfstair", {
	description = ("Half Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_halfstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_outerstair", {
	description = ("Outer Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_outerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_innerstair", {
	description = ("Inner Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_innerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

