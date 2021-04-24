local modpath = minetest.get_modpath("mcl_circularsaw").. DIR_DELIM

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
	{"slab", 	2,  nil			  },
	{"stair",	1,  nil			  },
	{"halfslope",	1,  { 0, 0,  0, 16, 1, 16 },
			    { 0, 1,  2, 16, 1, 14  },
			    { 0, 2,  4, 16,  1, 12  },
			    {0, 3, 6, 16, 1, 10},
			    {0, 4, 8, 16, 1, 8},
			    {0, 5, 10, 16, 1, 6},
			    {0, 6, 12, 16, 1, 4},
			    {0, 7, 14, 16, 1, 2}},
	{"halfslope_outercorner",	1,  { 0, 0,  0, 16, 1, 16 },
			    { 2, 1,  2, 14, 1, 14},
			    { 4, 2,  4, 12,  1, 12},
			    {6, 3, 6, 10, 1, 10},
			    {8, 4, 8, 8, 1, 8},
			    {10, 5, 10, 6, 1, 6},
			    {12, 6, 12, 4, 1, 4},
			    {14, 7, 14, 2, 1, 2}},
	{"halfslope_innercorner",	1,  { 0, 0,  0, 16, 1, 16 },
			    {0, 1, 2, 16, 1, 14},
			    {2, 1, 0, 14, 1, 16},
			    {0, 2, 4, 16, 1, 12},
			    {4, 2, 0, 12, 1, 16},
			    {0, 3, 6, 16, 1, 10},
			    {6, 3, 0, 10, 1, 16},
			    {0, 4, 8, 16, 1, 8},
			    {8, 4, 0, 8, 1, 16},
			    {0, 5, 10, 16, 1, 6},
			    {10, 5, 0, 6, 1, 16},
			    {0, 6, 12, 16, 1, 4},
			    {12, 6, 0, 4, 1, 16},
			    {0, 7, 14, 16, 1, 2},
			    {14, 7, 0, 2, 1, 16}},
	{"halfslope2",	1,  { 0, 0,  0, 16, 9, 16 },
	            {0, 9, 2, 16, 1, 14},
	            {0, 10, 4, 16, 1, 12},
	            {0, 11, 6, 16, 1, 10},
	            {0, 12, 8, 16, 1, 8},
	            {0, 13, 10, 16, 1, 6},
	            {0, 14, 12, 16, 1, 4},
	            {0, 15, 14, 16, 1, 2}},
	{"halfslope2_outercorner",	1,  { 0, 0,  0, 16, 9, 16 },
	            {2, 9, 2, 14, 1, 14},
	            {4, 10, 4, 12, 1, 12},
	            {6, 11, 6, 10, 1, 10},
	            {8, 12, 8, 8, 1, 8},
	            {10, 13, 10, 6, 1, 6},
	            {12, 14, 12, 4, 1, 4},
	            {14, 15, 14, 2, 1, 2}},
	{"halfslope2_innercorner",	1,  { 0, 0,  0, 16, 9, 16 },
	            {0, 9, 2, 16, 1, 14},
	            {2, 9, 0, 14, 1, 16},
	            {0, 10, 4, 16, 1, 12},
	            {4, 10, 0, 12, 1, 16},
	            {0, 11, 6, 16, 1, 10},
	            {6, 11, 0, 10, 1, 16},
	            {0, 12, 8, 16, 1, 8},
	            {8, 12, 0, 8, 1, 16},
	            {0, 13, 10, 16, 1, 6},
	            {10, 13, 0, 6, 1, 16},
	            {0, 14, 12, 16, 1, 4},
	            {12, 14, 0, 4, 1, 16},
	            {0, 15, 14, 16, 1, 2},
	            {14, 15, 0, 2, 1, 16}},
	{"slope",	1,  { 0, 0,  0, 16, 1, 16 },
			    { 0, 1,  1, 16,  1, 15  },
			    {0, 2, 2, 16, 1, 14},
			    {0, 3, 3, 16, 1, 13},
			    {0, 4, 4, 16, 1, 12},
			    {0, 5, 5, 16, 1, 11},
			    {0, 6, 6, 16, 1, 10},
			    {0, 7, 7, 16, 1, 9},
			    {0, 8, 8, 16, 1, 8},
			    {0, 9, 9, 16, 1, 7},
			    {0, 10, 10, 16, 1, 6},
			    {0, 11, 11, 16, 1, 5},
			    {0, 12, 12, 16, 1, 4},
			    {0, 13, 13, 16, 1, 3},
			    {0, 14, 14, 16, 1, 2},
			    {0, 15, 15, 16, 1, 1}},
	{"slope_outercorner", 1, {0, 0, 0, 16, 1, 16},
	            {1, 1, 1, 15, 1, 15},
	            {2, 2, 2, 14, 1, 14},
	            {3, 3, 3, 13, 1, 13},
	            {4, 4, 4, 12, 1, 12},
	            {5, 5, 5, 11, 1, 11},
	            {6, 6, 6, 10, 1, 10},
	            {7, 7, 7, 9, 1, 9},
	            {8, 8, 8, 8, 1, 8},
	            {9, 9, 9, 7, 1, 7},
	            {10, 10, 10, 6, 1, 6},
	            {11, 11, 11, 5, 1, 5},
	            {12, 12, 12, 4, 1, 4},
	            {13, 13, 13, 3, 1, 3},
	            {14, 14, 14, 2, 1, 2},
	            {15, 15, 15, 1, 1, 1}},
	{"slope_innercorner",	1,  { 0, 0, 0, 16, 1, 16 },
	            {0, 1, 1, 16, 1, 15},
	            {1, 1, 0, 15, 1, 16},
	            {2, 2, 0, 14, 1, 16},
	            {0, 2, 2, 16, 1, 14},
	            {0, 3, 3, 16, 1, 13},
	            {3, 3, 0, 13, 1, 16},
	            {0, 4, 4, 16, 1, 12},
	            {4, 4, 0, 12, 1, 16},
	            {0, 5, 5, 16, 1, 11},
	            {5, 5, 0, 11, 1, 16},
	            {0, 6, 6, 16, 1, 10},
	            {6, 6, 0, 10, 1, 16},
	            {0, 7, 7, 16, 1, 9},
	            {7, 7, 0, 9, 1, 16},
	            {0, 8, 8, 16, 1, 8},
	            {8, 8, 0, 8, 1, 16},
	            {0, 9, 9, 16, 1, 7},
	            {9, 9, 0, 7, 1, 16},
	            {0, 10, 10, 16, 1, 6},
	            {10, 10, 0, 6, 1, 16},
	            {0, 11, 11, 16, 1, 5},
	            {11, 11, 0, 5, 1, 16},
	            {0, 12, 12, 16, 1, 4},
	            {12, 12, 0, 4, 1, 16},
	            {0, 13, 13, 16, 1, 3},
	            {13, 13, 0, 3, 1, 16},
	            {0, 14, 14, 16, 1, 2},
	            {14, 14, 0, 2, 1, 16},
	            {0, 15, 15, 16, 1, 1},
	            {15, 15, 0, 1, 1, 16}},
	{"pyramid",	1,  { 0, 0,  0, 16, 1, 16 },
			    { 1, 1,  1, 14,  1, 14  },
			    {2, 2, 2, 12, 1, 12},
			    {3, 3, 3, 10, 1, 10},
			    {4, 4, 4, 8, 1, 8},
			    {5, 5, 5, 6, 1, 6},
			    {6, 6, 6, 4, 1, 4},
			    {7, 7, 7, 2, 1, 2}},
	{"spike",	1,  { 0, 0,  0, 16, 2, 16 },
			    { 1, 2,  1, 14,  2, 14  },
			    {2, 4, 2, 12, 2, 12},
			    {3, 6, 3, 10, 2, 10},
			    {4, 8, 4, 8, 2, 8},
			    {5, 10, 5, 6, 2, 6},
			    {6, 12, 6, 4, 2, 4},
			    {7, 14, 7, 2, 2, 2}},
	{"Triangular_Prism",	1,  {0, 0, 0, 16, 1, 16},
	            {0, 1, 1, 16, 1, 14},
	            {0, 2, 2, 16, 1, 12},
	            {0, 3, 3, 16, 1, 10},
	            {0, 4, 4, 16, 1, 8},
	            {0, 5, 5, 16, 1, 6},
	            {0, 6, 6, 16, 1, 4},
	            {0, 7, 7, 16, 1, 2}},
}

function workbench:get_output(inv, input, name)
	local output = {}
	for _, n in pairs(self.defs) do
		local count = min(n[2] * input:get_count(), input:get_stack_max())
		local item = name.."_"..n[1]
		if not n[3] then item = "mcl_stairs:"..n[1].."_"..name:match(":(.*)") end
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
	  mcl_formspec.get_itemslot_bg(1.5,1.5,1,1)..
      mcl_formspec.get_itemslot_bg(4,0,5,4)..
	  [[image[2.7,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]
	   image[0.5,1.5;1,1;workbench_saw.png]
	   list[context;input;1.5,1.5;1,1;]
	   list[context;forms;4,0;5,4;] ]],
}

function workbench:set_formspec(meta, id)
	meta:set_string("formspec", "size[9,8;]"..
	         "list[current_player;main;0,4.25;9,3;9]"..
	         "list[current_player;main;0,7.25;9,1;]"..
			formspecs[id]..mcl_formspec.get_itemslot_bg(0,4.25,9,4)..
			"listring[current_player;main]"..
			"listring[context;input]"
			)
end

function workbench.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("input", 1)
	inv:set_size("forms", 5*4)

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
	description = "Circular Saw",
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
		groups.not_in_craft_guide = 1

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
		
		if not minetest.registered_nodes["mcl_stairs:stair_"..node:match(":(.*)")] then
			mcl_stairs.register_stair_and_slab(node:match(":(.*)"), node,
			groups,
			tiles,
	        def.description.." Stair",
	        def.description.." Slab",
	        def.sounds, 2, 2,
	        "Double "..def.description.." Slab")
		end

		minetest.register_node(":"..node.."_"..d[1], {
			description = def.description.." "..d[1]:gsub("^%l", string.upper),
			use_texture_alpha = true,
			stack_max = 64,
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
		
		minetest.register_node(":technic:cracked_stone_"..d[1], {
			description = def.description.." "..d[1]:gsub("^%l", string.upper),
			use_texture_alpha = true,
			stack_max = 64,
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			sounds = def.sounds,
			tiles = {"technic_cracked_stone.png"},
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

---------------------------------------------------------------
-------------------- Override items----------------------------
---------------------------------------------------------------

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

--
-- Concrete
--

minetest.override_item("mcl_stairs:stair_concrete_"..colour[1], {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_concrete_"..colour[1], {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Glass
--

minetest.override_item("mcl_stairs:stair_glass_"..colour[4], {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_microslab", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_nanoslab", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_micropanel", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_thinstair", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_cube", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_panel", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:slab_glass_"..colour[4], {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_halfslope2", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_slope", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_halfslope", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_microslab", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_nanoslab", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_micropanel", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
    sunlight_propagates = true,
    _mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_thinstair", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_cube", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_panel", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:slab_glass", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_halfslope2", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_slope", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_halfslope", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

--
-- Stone
--

minetest.override_item("mcl_stairs:slab_stone_rough", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_stone_rough", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_andesite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_andesite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_granite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_granite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_diorite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_diorite", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_cobble", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_cobble", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_mossycobble", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_mossycobble", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_brick_block", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_brick_block", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_sandstone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_sandstone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_sandstonesmooth2", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_sandstonesmooth2", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_redsandstone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_redsandstone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_redsandstonesmooth2", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_redsandstonesmooth2", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_stonebrick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_stonebrick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_quartzblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_quartzblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_quartz_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_quartz_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_nether_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_nether_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_red_nether_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_red_nether_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_end_bricks", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_end_bricks", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_purpur_block", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_purpur_block", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_prismarine", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_prismarine", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_prismarine_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_prismarine_brick", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_prismarine_dark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_prismarine_dark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_andesite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_andesite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_granite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_granite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_diorite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_diorite_smooth", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_stonebrickmossy", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_stonebrickmossy", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_lapisblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_lapisblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_goldblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_goldblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_ironblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_ironblock", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_stonebrickcracked", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_stonebrickcracked", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_cracked_stone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_cracked_stone", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Trees
--
-- Stairs
--

minetest.override_item("mcl_stairs:stair_tree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_jungletree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_acaciatree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_sprucetree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_birchtree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_darktree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Slabs
--

minetest.override_item("mcl_stairs:slab_tree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_jungletree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_acaciatree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_sprucetree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_birchtree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_darktree", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Woods
--
-- Stairs
--

minetest.override_item("mcl_stairs:stair_wood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_junglewood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_acaciawood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_sprucewood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_birchwood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_darkwood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Slabs
--

minetest.override_item("mcl_stairs:slab_wood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_junglewood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_acaciawood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_sprucewood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_birchwood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_darkwood", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Bark
--
-- Stairs
--

minetest.override_item("mcl_stairs:stair_tree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_jungletree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_acaciatree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_sprucetree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_birchtree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:stair_darktree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

--
-- Slabs
--

minetest.override_item("mcl_stairs:slab_tree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_jungletree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_acaciatree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_sprucetree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_birchtree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

minetest.override_item("mcl_stairs:slab_darktree_bark", {
	groups = {not_in_creative_inventory = 1, not_in_craft_guide = 1},
})

end
