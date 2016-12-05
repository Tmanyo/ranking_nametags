staff = {
     host = {},
     headadmin = {},
     admins = {},
     mods = {}
}

local f, err = io.open(minetest.get_worldpath() .. "/staff", "r")
if f == nil then
     local f, err = io.open(minetest.get_worldpath() .. "/staff", "w")
     f:write(minetest.serialize(staff))
     f:close()
end

function save_table_data()
     local data = staff
     local f, err = io.open(minetest.get_worldpath() .. "/staff", "w")
     if err then
          return err
     end
     f:write(minetest.serialize(data))
     f:close()
end

function read_table_data()
     local f, err = io.open(minetest.get_worldpath() .. "/staff", "r")
     local data = minetest.deserialize(f:read("*a"))
     f:close()
          return data
end

minetest.register_chatcommand("set_staff", {
     func = function(name, param)
          minetest.show_formspec(name, "chat_enhancements:staff_sheet",
               "size[8,8]" ..
               "field[1,1;5,1;host;Host:;]" ..
               "field[1,2.5;5,1;headadmin;Head Admin:;]" ..
               "field[1,4;5,1;admins;Admins:;]" ..
               "field[1,5.5;5,1;mods;Moderators:;]" ..
               "button_exit[1,7;2,1;exit;Close]")
     end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "chat_enhancements:staff_sheet" then
          staff.host = fields.host
          staff.headadmin = fields.headadmin
          staff.admins = fields.admins
          staff.mods = fields.mods
          save_table_data()
     end
end)

minetest.register_on_joinplayer(function(player)
     staff = read_table_data()
     local playername = player:get_player_name()
	for k, v in pairs(staff) do
     	if staff.host == playername then
          	player:set_nametag_attributes({
               	color = {r = 255, g = 0, b = 0}
          	})
     	end
		local headadmins = minetest.serialize(staff.headadmin)
		if string.match(headadmins, playername) then
			player:set_nametag_attributes({
				color = {r = 0, g = 0, b = 255}
			})
		end
		local admins = minetest.serialize(staff.admins)
		if string.match(admins, playername) then
			player:set_nametag_attributes({
				color = {r = 0, g = 255, b = 0}
			})
		end
		local moderators = minetest.serialize(staff.mods)
		if string.match(moderators, playername) then
			player:set_nametag_attributes({
				color = {r = 255, g = 165, b = 0}
			})
		end
	end
end)
