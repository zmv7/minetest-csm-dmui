local history = ""
local abon = ""
local in_dmui
local function update_fs()
	local plist = core.get_player_names()
	if not plist then plist = ""
	else plist = table.concat(plist,",") end
	in_dmui = true
	core.show_formspec("dmui","size[16,9]" ..
		"field[0.3,8.3;15.7,1;msg;Message:;]" ..
		"field_close_on_enter[msg;false]" ..
		"field[0.3,7.3;4.1,1;abon;SendTo:;"..abon.."]" ..
		"field_close_on_enter[abon;false]" ..
		"button[15.5,8;0.7,1;send;>]" ..
		"box[0,0;15.9,6.8;#000]" ..
		"textarea[0.3,0;16.1,7.9;;;"..history.."]" ..
		"dropdown[4.6,7.1;4,1;plist;"..plist..";1]" ..
		"button[4,7;0.7,1;select;<]" ..
		"button[14,7;2.1,1;clear;Clear]")
end
core.register_chatcommand("dmui", {
	description = "Open DM UI",
	func = function(param)
		update_fs()
end})
core.register_on_receiving_chat_message(function(msg)
	msg = core.strip_colors(msg)
	local prefix = msg:match("DM from ") or msg:match("PM from ")
	if prefix then
		history = history..msg:gsub(prefix,"").."\n"
		if in_dmui == true then update_fs() end
	end
end)
core.register_on_formspec_input(function(formname,fields)
	if formname ~= "dmui" then return end
	if fields.abon then abon = fields.abon end
	if fields.quit then in_dmui = false end
	if fields.msg ~= "" and (fields.key_enter_field == "msg" or fields.send) then
		core.run_server_chatcommand("msg",fields.abon.." "..fields.msg)
		update_fs()
	elseif fields.clear then
		history = ""
		update_fs()
	elseif fields.select then
		abon = fields.plist
		update_fs()
	end
end)
