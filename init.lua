
local modpath = minetest.get_modpath("mcl_circularsaw").. DIR_DELIM

local circularsaw = {}
CS = {}
screwdriver = screwdriver or {}
local min, ceil = math.min, math.ceil

-- All Nodes allowed to be cut
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

setmetatable(nodes, {
	__concat = function(t1, t2)
		for i=1, #t2 do
			t1[#t1+1] = t2[i]
		end
		return t1
	end
})

nodes = nodes..CS

-- Nodeboxes definitions
circularsaw.defs = {
	-- Name       Yield   X  Y   Z  W   H  L
	{"nanoslab", 16, {0, 0, 0, 8, 1, 8}},

	{"micropanel", 16, {0, 0, 0, 16, 1, 8}},

	{"cube", 4, {4, 0, 4, 8, 8, 8}},

	{"panel", 4, {0, 0, 0, 16, 8, 8}},

	{"pole", 4, {4, 0, 4, 8, 16, 8}},

	{"slab_corner", 2, {0, 0, 0, 16, 1, 16},
	                   {0, 0, 15, 16, 16, 1}},

	{"microslab", 8, {0, 0, 0, 16, 1, 16}},

	{"halfslab", 4, {0, 0, 0, 16, 4, 16}},

	{"slab", 2, nil},

	{"three_quarter_slab", 1, {0, 0, 0, 16, 12, 16}},
	
	{"thickslab", 1, {0, 0, 0, 16, 15, 16}},

	{"thinstair", 8, {0, 7, 0, 16, 1, 8},
			         {0, 15, 8, 16, 1, 8}},

	{"stair", 1, nil},

	{"halfslope", 2, {0, 0, 0, 16, 1, 16},
			         {0, 1, 2, 16, 1, 14},
			         {0, 2, 4, 16,  1, 12},
			         {0, 3, 6, 16, 1, 10},
			         {0, 4, 8, 16, 1, 8},
			         {0, 5, 10, 16, 1, 6},
			         {0, 6, 12, 16, 1, 4},
			         {0, 7, 14, 16, 1, 2}},

	{"halfslope_outercorner", 1, {0, 0, 0, 16, 1, 16},
			                     {2, 1, 2, 14, 1, 14},
			                     {4, 2, 4, 12, 1, 12},
			                     {6, 3, 6, 10, 1, 10},
			                     {8, 4, 8, 8, 1, 8},
			                     {10, 5, 10, 6, 1, 6},
			                     {12, 6, 12, 4, 1, 4},
			                     {14, 7, 14, 2, 1, 2}},

	{"halfslope_outercorner_1", 8, {8, 0, 8, 8, 2, 8},
	                               {9, 2, 9, 7, 2, 7},
	                               {10, 4, 10, 6, 2, 6},
	                               {11, 6, 11, 5, 2, 5},
	                               {12, 8, 12, 4, 2, 4},
	                               {13, 10, 13, 3, 2, 3},
	                               {14, 12, 14, 2, 2, 2},
	                               {15, 14, 15, 1, 2, 1}},

	{"halfslope_innercorner", 1, {0, 0, 0, 16, 1, 16},
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

	{"halfslope_innercorner_1", 1, {8, 0, 0, 8, 2, 16},
	                               {0, 0, 8, 16, 2, 8},
	                               {9, 2, 0, 7, 2, 16},
	                               {0, 2, 9, 16, 2, 7},
	                               {10, 4, 0, 6, 2, 16},
	                               {0, 4, 10, 16, 2, 6},
	                               {11, 6, 0, 5, 2, 16},
	                               {0, 6, 11, 16, 2, 5},
	                               {12, 8, 0, 4, 2, 16},
	                               {0, 8, 12, 16, 2, 4},
	                               {13, 10, 0, 3, 2, 16},
	                               {0, 10, 13, 16, 2, 3},
	                               {14, 12, 0, 2, 2, 16},
	                               {0, 12, 14, 16, 2, 2},
	                               {15, 14, 0, 1, 2, 16},
	                               {0, 14, 15, 16, 2, 1}},

	{"halfslope2", 1, {0, 0, 0, 16, 9, 16},
	                  {0, 9, 2, 16, 1, 14},
	                  {0, 10, 4, 16, 1, 12},
	                  {0, 11, 6, 16, 1, 10},
	                  {0, 12, 8, 16, 1, 8},
	                  {0, 13, 10, 16, 1, 6},
	                  {0, 14, 12, 16, 1, 4},
	                  {0, 15, 14, 16, 1, 2}},

	{"halfslope2_outercorner", 1, {0, 0, 0, 16, 9, 16},
	                              {2, 9, 2, 14, 1, 14},
	                              {4, 10, 4, 12, 1, 12},
	                              {6, 11, 6, 10, 1, 10},
	                              {8, 12, 8, 8, 1, 8},
	                              {10, 13, 10, 6, 1, 6},
	                              {12, 14, 12, 4, 1, 4},
	                              {14, 15, 14, 2, 1, 2}},

	{"halfslope2_outercorner_1", 1, {0, 0, 0, 16, 2, 16},
	                                {1, 2, 1, 15, 2, 15},
	                                {2, 4, 2, 14, 2, 14},
	                                {3, 6, 3, 13, 2, 13},
	                                {4, 8, 4, 12, 2, 12},
	                                {5, 10, 5, 11, 2, 11},
	                                {6, 12, 6, 10, 2, 10},
	                                {7, 14, 7, 9, 2, 9}},

	{"halfslope2_innercorner", 1, {0, 0, 0, 16, 9, 16},
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

	{"halfslope2_innercorner_1", 1, {0, 0, 0, 16, 2, 16},
	                                {1, 2, 0, 15, 2, 16},
	                                {0, 2, 1, 16, 2, 15},
	                                {2, 4, 0, 14, 2, 16},
	                                {0, 4, 2, 16, 2, 14},
	                                {3, 6, 0, 13, 2, 16},
	                                {0, 6, 3, 16, 2, 13},
	                                {4, 8, 0, 12, 2, 16},
	                                {0, 8, 4, 16, 2, 12},
	                                {5, 10, 0, 11, 2, 16},
	                                {0, 10, 5, 16, 2, 11},
	                                {6, 12, 0, 10, 2, 16},
	                                {0, 12, 6, 16, 2, 10},
	                                {7, 14, 0, 9, 2, 16},
	                                {0, 14, 7, 16, 2, 9}},

	{"slope", 2, {0, 0, 0, 16, 1, 16},
			     {0, 1, 1, 16,  1, 15},
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

	{"slope_innercorner", 1, {0, 0, 0, 16, 1, 16},
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
	
	{"pyramid",	6, {0, 0, 0, 16, 1, 16},
			       {1, 1, 1, 14, 1, 14},
			       {2, 2, 2, 12, 1, 12},
			       {3, 3, 3, 10, 1, 10},
			       {4, 4, 4, 8, 1, 8},
			       {5, 5, 5, 6, 1, 6},
			       {6, 6, 6, 4, 1, 4},
			       {7, 7, 7, 2, 1, 2}},

	{"spike", 1, {0, 0, 0, 16, 2, 16},
			     {1, 2, 1, 14, 2, 14},
			     {2, 4, 2, 12, 2, 12},
			     {3, 6, 3, 10, 2, 10},
			     {4, 8, 4, 8, 2, 8},
			     {5, 10, 5, 6, 2, 6},
			     {6, 12, 6, 4, 2, 4},
			     {7, 14, 7, 2, 2, 2}},

	{"triangular_prism", 4, {0, 0, 0, 16, 1, 16},
	                        {0, 1, 1, 16, 1, 14},
	                        {0, 2, 2, 16, 1, 12},
	                        {0, 3, 3, 16, 1, 10},
	                        {0, 4, 4, 16, 1, 8},
	                        {0, 5, 5, 16, 1, 6},
	                        {0, 6, 6, 16, 1, 4},
	                        {0, 7, 7, 16, 1, 2}},

	{"triangular_prism_1", 4, {0, 0, 0, 16, 2, 16},
	                          {0, 2, 1, 16, 2, 14},
	                          {0, 4, 2, 16, 2, 12},
	                          {0, 6, 3, 16, 2, 10},
	                          {0, 8, 4, 16, 2, 8},
	                          {0, 10, 5, 16, 2, 6},
	                          {0, 12, 6, 16, 2, 4},
	                          {0, 14, 7, 16, 2, 2}},

	{"pillar", 1, {0, 0, 0, 16, 1, 16},
	              {2, 1, 2, 12, 2, 12},
	              {3, 3, 3, 10, 2, 10},
	              {4, 5, 4, 8, 11, 8}},

	{"hourglass", 1, {0, 0, 0, 16, 1, 16},
	                 {1, 1, 1, 14, 2, 14},
	                 {2, 3, 2, 12, 2, 12},
	                 {3, 5, 3, 10, 2, 10},
	                 {4, 7, 4, 8, 2, 8},
	                 {3, 9, 3, 10, 2, 10},
	                 {2, 11, 2, 12, 2, 12},
	                 {1, 13, 1, 14, 2, 14},
	                 {0, 15, 0, 16, 1, 16}},
}

function circularsaw:get_output(inv, input, name)
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
function circularsaw:pixelbox(size, boxes)
	local fixed = {}
	for _, box in pairs(boxes) do
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
	  mcl_formspec.get_itemslot_bg(0.5,2,1,1)..
      mcl_formspec.get_itemslot_bg(2,0,8,4)..
	   "image[0.5,1;1,1;workbench_saw.png]"..
	   "list[context;input;0.5,2;1,1;]"..
	   "list[context;forms;2,0;8,4;] ]]",
}

    -- Player Inventory
function circularsaw:set_formspec(meta, id)
	meta:set_string("formspec", "size[10,8;]"..
	         "list[current_player;main;0.5,4.25;9,3;9]"..
	         "list[current_player;main;0.5,7.25;9,1;]"..
			formspecs[id]..mcl_formspec.get_itemslot_bg(0.5,4.25,9,4)..
			"listring[current_player;main]"..
			"listring[context;input]"
			)
end

--------------------------------------------------------
------------------ Functions ---------------------------
--------------------------------------------------------

function circularsaw.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("input", 1)
	inv:set_size("forms", 8*4)

	meta:set_string("infotext", "Circular Saw")
	circularsaw:set_formspec(meta, 1)
end

function circularsaw.fields(pos, _, fields)
	local meta = minetest.get_meta(pos)
end

function circularsaw.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("input")
end

function circularsaw.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if(listname == "input" and minetest.registered_nodes[stackname.."_cube"]) then
		return stack:get_count()
	end
	return 0
end

function circularsaw.on_put(pos, listname, _, stack)
	local inv = minetest.get_meta(pos):get_inventory()
	if listname == "input" then
		local input = inv:get_stack("input", 1)
		circularsaw:get_output(inv, input, stack:get_name())
end
end

function circularsaw.on_take(pos, listname, index, stack, player)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1)
	local inputname = input:get_name()
	local stackname = stack:get_name()

	if listname == "input" then
		if stackname == inputname then
			circularsaw:get_output(inv, input, stackname)
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

		input:take_item(ceil(stack:get_count() / circularsaw.defs[index][2]))
		inv:set_stack("input", 1, input)
		circularsaw:get_output(inv, input, inputname)
	end
end

---------------------------------------------------------------------------
------------------------- Register Circular Saw ---------------------------
---------------------------------------------------------------------------

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
	can_dig = circularsaw.dig,
	on_timer = circularsaw.timer,
	on_construct = circularsaw.construct,
	on_receive_fields = circularsaw.fields,
	on_metadata_inventory_put = circularsaw.on_put,
	on_metadata_inventory_take = circularsaw.on_take,
	allow_metadata_inventory_put = circularsaw.put,
	allow_metadata_inventory_move = circularsaw.move
})

minetest.register_craft({
	output = "mcl_circularsaw:circularsaw",
	recipe = {
	    {"",               "mcl_core:iron_ingot", ""},
		{"mcl_core:stone", "mcl_core:stone",      "mcl_core:stone"},
		{"mcl_core:stone", "mcl_core:stone",      "mcl_core:stone"}
	}
})

for _, d in pairs(circularsaw.defs) do
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
		
		if minetest.registered_nodes["mcl_stairs:stair_"..node:match(":(.*)")] then
			mcl_stairs.register_stair_and_slab(node:match(":(.*)"), node,
			groups,
			tiles,
	        def.description.." Stair",
	        def.description.." Slab",
	        def.sounds, 2, 2,
	        "Double "..def.description.." Slab")
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

            mcl_stairs.register_stair_and_slab("glowstone", "mcl_nether:glowstone",
			groups,
			{"mcl_nether_glowstone.png"},
	        "Glowstone Stair",
	        "Glowstone Slab",
	        def.sounds, 2, 2,
	        "Double Glowstone Slab")

            mcl_stairs.register_stair_and_slab("stone_rough", "mcl_core:stone",
			groups,
			{"default_stone.png"},
	        "Stone Stair",
	        "Stone Slab",
	        def.sounds, 2, 2,
	        "Double Stone Slab")
		
		minetest.register_node(":"..node.."_"..d[1], {
			description = def.description.." "..d[1]:gsub("^%l", string.upper),
			stack_max = 64,
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			sounds = def.sounds,
			tiles = tiles,
			groups = groups,
			_mcl_blast_resistance = def._mcl_blast_resistance,
		    _mcl_hardness = def._mcl_hardness,
			node_box = circularsaw:pixelbox(16, {unpack(d, 3)}),
			sunlight_propagates = true,
			on_place = minetest.rotate_node
		})
		
		minetest.register_node(":mcl_nether:glowstone_"..d[1], {
			description = "Glowstone "..d[1]:gsub("^%l", string.upper),
			stack_max = 64,
			light_source = minetest.LIGHT_MAX,
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			sounds = def.sounds,
			tiles = {"mcl_nether_glowstone.png"},
			groups = groups,
			_mcl_blast_resistance = def._mcl_blast_resistance,
		    _mcl_hardness = def._mcl_hardness,
			node_box = circularsaw:pixelbox(16, {unpack(d, 3)}),
			sunlight_propagates = true,
			on_place = minetest.rotate_node
		})
		
if minetest.get_modpath("mcl_technic") then
		minetest.register_node(":mcl_technic:cracked_deepslate_"..d[1], {
			description = def.description.." "..d[1]:gsub("^%l", string.upper),
			stack_max = 64,
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			sounds = def.sounds,
			tiles = {"mcl_technic_cracked_deepslate.png"},
			groups = groups,
			_mcl_blast_resistance = def._mcl_blast_resistance,
		    _mcl_hardness = def._mcl_hardness,
			node_box = circularsaw:pixelbox(16, {unpack(d, 3)}),
			sunlight_propagates = true,
			on_place = minetest.rotate_node
		})
end
end
end
end

---------------------------------------------------------------
--------------------- Override items --------------------------
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

local shape = {
----- Node ------------------------ Description -----
	{"microslab",                  "Micro Slab"},
	{"slab_corner",                "Slab Corner"},
	{"nanoslab",                   "Nano Slab"},
	{"micropanel",                 "Micro Panel"},
	{"thinstair",                  "Thin Stair"},
	{"cube",                       "Cube"},
	{"panel",                      "Panel"},
	{"pole",                       "Pole"},
	{"slope",                      "Slope"},
	{"slope_innercorner",          "Slope Inner Corner"},
	{"slope_outercorner",          "Slope Outer Corner"},
	{"halfslope",                  "Half Slope"},
	{"halfslope_outercorner",      "Half Slope Outer Corner"},
	{"halfslope_outercorner_1",    "Half Slope Outer Corner 1"},
	{"halfslope_innercorner",      "Half Slope Inner Corner"},
	{"halfslope_innercorner_1",    "Half Slope Inner Corner 1"},
	{"halfslope2",                 "Half Slope"},
	{"halfslope2_outercorner",     "Half Slope2 Outer Corner"},
	{"halfslope2_outercorner_1",   "Half Slope2 Outer Corner 1"},
	{"halfslope2_innercorner",     "Half Slope2 Inner Corner"},
	{"halfslope2_innercorner_1",   "Half Slope2 Inner Corner 1"},
	{"pyramid",                    "pyramid"},
	{"spike",                      "spike"},
	{"triangular_prism",           "Triangular Prism"},
	{"halfslab",                   "Half Slab"},
	{"three_quarter_slab",         "Three Quarter Slab"},
	{"thickslab",                  "Thick Slab"},
	{"pillar",                     "pillar"},
	{"hourglass",                  "hourglass"},
	{"triangular_prism_1",         "triangular_prism_1"},
}

for _, colour in pairs(colour) do
for _, shape in pairs(shape) do

----------------------------------------------------------------------
---------------------------- Concrete --------------------------------
----------------------------------------------------------------------

minetest.override_item("mcl_stairs:stair_concrete_"..colour[1], {
	_mcl_blast_resistance = 1.8,
	_mcl_hardness = 1.8,
})

minetest.override_item("mcl_stairs:slab_concrete_"..colour[1], {
	_mcl_blast_resistance = 1.8,
	_mcl_hardness = 1.8,
})

minetest.override_item("mcl_colorblocks:concrete_"..colour[1].."_"..shape[1], {
	_mcl_blast_resistance = 1.8,
	_mcl_hardness = 1.8,
})
---------------------------------------------------------------------------
------------------------ Coloured Glass -----------------------------------
---------------------------------------------------------------------------

minetest.override_item("mcl_stairs:stair_glass_"..colour[4], {
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	use_texture_alpha = true,
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass_"..colour[4].."_inner", {
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	use_texture_alpha = true,
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass_"..colour[4].."_outer", {
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	use_texture_alpha = true,
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

minetest.override_item("mcl_stairs:slab_glass_"..colour[4].."_top", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_"..shape[1], {
	use_texture_alpha = true,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

-----------------------------------------------------------------
---------------------- Clear Glass ------------------------------
-----------------------------------------------------------------

minetest.override_item("mcl_stairs:stair_glass", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass_inner", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass_outer", {
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

minetest.override_item("mcl_stairs:slab_glass_top", {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_"..shape[1], {
	use_texture_alpha = true,
	tiles = {"coloured_glass_clear_framed.png"},
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})


end
end


minetest.override_item("mcl_stairs:slab_glowstone", {
    light_source = minetest.LIGHT_MAX,
    _mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glowstone", {
    light_source = minetest.LIGHT_MAX,
    _mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})
