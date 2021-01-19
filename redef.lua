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

minetest.override_item("mcl_stairs:stair_glass_" .. colour[4], {
	description = colour[3] .. (" Glass Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_stairs:stair_glass_" .. colour[4],
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_microslab", {
	description = colour[3] .. (" Glass Micro Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_microslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_nanoslab", {
	description = colour[3] .. (" Glass Nano Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_nanoslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_micropanel", {
	description = colour[3] .. (" Glass Micro Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_micropanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_thinstair", {
	description = colour[3] .. (" Glass Thin Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_thinstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_cube", {
	description = colour[3] .. (" Glass Cube"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_cube",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_panel", {
	description = colour[3] .. (" Glass Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_panel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:slab_glass_" .. colour[4], {
	description = colour[3] .. (" Glass Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_stairs:slab_glass_" .. colour[4],
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_doublepanel", {
	description = colour[3] .. (" Glass Double Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_doublepanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_halfstair", {
	description = colour[3] .. (" Glass Half Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_halfstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_outerstair", {
	description = colour[3] .. (" Glass Outer Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_outerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_" .. colour[4] .. "_innerstair", {
	description = colour[3] .. (" Glass Inner Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_" .. colour[1] .. ".png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_" .. colour[4] .. "_innerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:stair_glass", {
	description = ("Glass Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_stairs:stair_glass",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_microslab", {
	description = ("Glass Micro Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_microslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_nanoslab", {
	description = ("Glass Nano Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_nanoslab",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_micropanel", {
	description = ("Glass Micro Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_micropanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_thinstair", {
	description = ("Glass Thin Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_thinstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_cube", {
	description = ("Glass Cube"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_cube",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_panel", {
	description = ("Glass Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_panel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_stairs:slab_glass", {
	description = ("Glass Slab"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_stairs:slab_glass",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_doublepanel", {
	description = ("Glass Double Panel"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_doublepanel",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_halfstair", {
	description = ("Glass Half Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_halfstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_outerstair", {
	description = ("Glass Outer Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_outerstair",
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,
})

minetest.override_item("mcl_core:glass_innerstair", {
	description = ("Glass Inner Stair"),
	use_texture_alpha = true,
	drawtype = "nodebox",
	is_ground_content = false,
	tiles = {"coloured_glass_clear_framed.png"},
	paramtype = "light",
	sunlight_propagates = true,
	stack_max = 64,
	groups = {handy=1, glass=1, building_block=1, material_glass=1, not_in_creative_inventory = 1, not_in_craft_guide = 1},
	sounds = mcl_sounds.node_sound_glass_defaults(),
	drop = "mcl_core:glass_innerstair",
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
