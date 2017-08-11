--[[
	Mod MyMenu para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Menu pessoal
  ]]

local modpath = minetest.get_modpath("mymenu")

-- Algoritimo de tradução
local S, NS, SS, SNS = dofile(modpath.."/lib/intllib.lua")

-- Algoritimo para pegar idioma com "mylang"
local getlang = dofile(minetest.get_modpath(minetest.get_current_modname()).."/lib/mylang.lua")

-- Tabela global
mymenu = {}

-- Metodos de tradução registrados
local tr = {}

-- Registrar metodo de tradução
mymenu.register_tr = function(func)

	if not func then
		minetest.log("error", "[MyMenu] Metodo de tradução nulo (em mymenu.register_tr)")
		return false
	elseif type(func) ~= "function" then
		minetest.log("error", "[MyMenu] Metodo de tradução invalido ("..type(func).."?) (em mymenu.register_tr)")
		return false
	end
	
	tr[minetest.get_current_modname()] = func
	return true
end


-- Registrar botao
local buttons = {}
mymenu.register_button = function(field, label)
	buttons[minetest.get_current_modname()] = {
		field = field,
		label = label,
	}
	
	if not tr[minetest.get_current_modname()] then
		tr[minetest.get_current_modname()] = function(lang, string)
			return string
		end
	end
end


-- Pegar formspec com botoes
local get_formbuttons = function(player)
	local f = "" -- formspec
	local lang = getlang(player:get_player_name())
	do
		local c = 0 -- botoes contados
		for mod,data in pairs(buttons) do
			local fl = data.field..";"..tr[mod](lang, data.label)
			if c == 0 then f = f .. "button[0,0;4,1;"..fl.."]"
			elseif c == 1 then f = f .. "button[0,1;4,1;"..fl.."]"
			elseif c == 2 then f = f .. "button[0,3;4,1;"..fl.."]"
			elseif c == 3 then f = f .. "button[0,4;4,1;"..fl.."]"
			elseif c == 4 then f = f .. "button[4,0;4,1;"..fl.."]"
			elseif c == 5 then f = f .. "button[4,1;4,1;"..fl.."]"
			elseif c == 6 then f = f .. "button[4,3;4,1;"..fl.."]"
			elseif c == 7 then f = f .. "button[4,4;4,1;"..fl.."]"
			end
			c = c + 1
		end
	end
	return f
end


-- Registrar aba de configurações pessoais
sfinv.register_page("mymenu:menu", {
	title = "Config",
	get = function(self, player, context)
		
		return sfinv.make_formspec(player, context, 
			get_formbuttons(player) .. [[
			listring[current_player;main]
			listring[current_player;craft]
			image[0,4.75;1,1;gui_hb_bg.png]
			image[1,4.75;1,1;gui_hb_bg.png]
			image[2,4.75;1,1;gui_hb_bg.png]
			image[3,4.75;1,1;gui_hb_bg.png]
			image[4,4.75;1,1;gui_hb_bg.png]
			image[5,4.75;1,1;gui_hb_bg.png]
			image[6,4.75;1,1;gui_hb_bg.png]
			image[7,4.75;1,1;gui_hb_bg.png]
		]], true)
	end
})

-- Criar botao de idiomas
dofile(modpath.."/idioma.lua")
