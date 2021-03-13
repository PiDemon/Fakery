minetest.register_craftitem("fakery:diamond", {
	description = "Diamond",
	inventory_image = "default_diamond.png",
})
minetest.register_craftitem("fakery:mese", {
	description = "Mese Crystal",
	inventory_image = "default_mese_crystal.png",
})
if minetest.get_modpath("moreores") then
	minetest.register_craftitem("fakery:mithril", {
		description = "Mithril Ingot",
		inventory_image = "moreores_mithril_ingot.png",
	})
end
if minetest.get_modpath("cloud_items") then
	minetest.register_craftitem("fakery:cloud", {
		description = "Cloud Ingot",
		inventory_image = "cloud_items_cloud_ingot.png",
	})
end
if minetest.get_modpath("lavastuff") then
	minetest.register_craftitem("fakery:lava", {
		description = "Lava Ingot",
		inventory_image = "lavastuff_ingot.png",
	})
end
if minetest.get_modpath("overpowered") then
	minetest.register_craftitem("fakery:op", {
		description = "OP Alloy Ingot",
		inventory_image = "overpowered_ingot.png",
	})
end
--formspecs
if minetest.get_modpath("basic_materials") then
	fake_item = "basic_materials:plastic_sheet"
else
	fake_item = "default:steel_ingot"
end
local function get_formspec_bench()
	if fake_item == "basic_materials:plastic_sheet" then
	return "size[10,10]"..
		"image[4.5,2;1,1;sfinv_crafting_arrow.png]"..
		"list[context;metal;2,1.5;1,1;1]"..
		"image[2,1.5;1,1;fakery_plastic.png]"..
		"list[context;dye;2,2.5;1,1;1]"..
		"image[2,2.5;1,1;fakery_dye.png]"..
		"list[context;dest;7,2;1,1;1]"..
		"list[current_player;main;1,5;8,4;]"
	else
    return "size[10,10]"..
		"image[4.5,2;1,1;sfinv_crafting_arrow.png]"..
		"list[context;metal;2,1.5;1,1;1]"..
		"image[2,1.5;1,1;fakery_ingot.png]"..
		"list[context;dye;2,2.5;1,1;1]"..
		"image[2,2.5;1,1;fakery_dye.png]"..
		"list[context;dest;7,2;1,1;1]"..
		"list[current_player;main;1,5;8,4;]"
	end
end
local function get_formspec_working()
	return "size[10,10]"..
		"label[4,2;Forgery in process...]"..
		"list[current_player;main;1,5;8,4;]"
end
--workbench
local function register_recipe(dye,metal,result,pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local timer = minetest.get_node_timer(pos)
		if inv:contains_item("dye", dye) == true and inv:contains_item("metal", metal) == true and inv:is_empty("dest") then
			inv:remove_item("dye", dye)
			inv:remove_item("metal", metal)
			local dye_s = inv:get_stack("dye", 2)
			local metal_s = inv:get_stack("metal", 2)
			inv:set_stack("dye", 2, dye_s)
			inv:set_stack("metal", 2, metal_s)
			inv:set_stack("dest", 2, result)
			meta:set_string("formspec", get_formspec_working())
			timer:start(7)
		end
end
local function craft(pos)
	register_recipe("dye:yellow",fake_item,"fakery:mese",pos)
	register_recipe("dye:cyan",fake_item,"fakery:diamond",pos)
	if minetest.get_modpath("moreores") then register_recipe("dye:blue",fake_item,"fakery:mithril",pos) end
	if minetest.get_modpath("cloud_items") then register_recipe("dye:white",fake_item,"fakery:cloud",pos) end
	if minetest.get_modpath("lavastuff") then register_recipe("dye:red",fake_item,"fakery:lava",pos) end
	if minetest.get_modpath("overpowered") then register_recipe("dye:green",fake_item,"fakery:op",pos) end
end
minetest.register_node("fakery:table", {
		description = "Forgery Workbench",
		tiles = {"fakery_bench_top.png", "fakery_bench_top.png", "fakery_bench_side.png", "fakery_bench_side.png","fakery_bench_side.png", "fakery_bench_side.png"},
		groups = {oddly_breakable_by_hand = 1},
		on_construct = function(pos, node)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("dye", 2*1)
			inv:set_size("metal", 2*1)
			inv:set_size("dest", 2*1)
			meta:set_string("formspec", get_formspec_bench())
		end,
		on_timer = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			meta:set_string("formspec", get_formspec_bench())
			return false
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			craft(pos)
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			craft(pos)
		end,
		on_metadata_inventory_move = function(pos, listname, index, stack, player)
			craft(pos)
		end	
})
minetest.register_craft({
		output = "fakery:table",
		recipe = {
			{"default:sword_steel", "default:pick_steel", "default:axe_steel"},
			{"default:desert_sandstone_block", "default:bronzeblock", "default:desert_sandstone_block"},
			{"default:desert_sandstone_block", "default:bronzeblock", "default:desert_sandstone_block"}
		}
})
