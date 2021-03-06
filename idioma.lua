--[[
	Mod MyMenu para Minetest
	Copyright (C) 2017 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Mudar idioma
  ]]

-- Algoritimo de tradução
local S, NS, SS, SNS = dofile(minetest.get_modpath("mymenu").."/lib/intllib.lua")

-- Algoritimo para pegar idioma com "mylang"
local getlang, setlang = dofile(minetest.get_modpath(minetest.get_current_modname()).."/lib/mylang.lua")

-- Tabela de idiomas selecionaveis ISO 639
local tb_idiomas = {
	["English"] = "en",
	["Portugues"] = "pt",
	["Espanol"] = "es",
	["Italiano"] = "it",
	["Deutsch"] = "de",
	["Nederlands"] = "nl",
	["Français"] = "fr",
}
-- Tabela de codigos com o numero
tb_idiomas_code = {}
do
	local i = 1
	for name,code in pairs(tb_idiomas) do
		tb_idiomas_code[code] = i
		i = i + 1
	end
end
-- String de idiomas em sequencia
local st_idiomas = ""
for name,code in pairs(tb_idiomas) do
	if st_idiomas ~= "" then st_idiomas = st_idiomas .. "," end
	st_idiomas = st_idiomas .. name
end


-- Acessar menu de seleção de idiomas
local acessar_menu_idiomas = function(player)
	local name = player:get_player_name()
	local lang = getlang(name) or "en" -- não pode ser nulo
	
	-- Idioma salvo
	local idioma_st = ""
	
	-- Idioma selecionado
	local idioma_sel = "1"
	if lang then
		if tb_idiomas_code[lang] then
			idioma_sel = tonumber(tb_idiomas_code[lang])
		else
			-- mostra idioma salvo
			idioma_st = lang..","
		end
	end
	
	local formspec = "size[5,5]"
		..default.gui_bg
		..default.gui_bg_img
		.."label[0,0;"..SS(lang, "Escolha seu idioma").."]"
		.."dropdown[0.125,1;5,5;idioma;"..idioma_st..st_idiomas..";"..(idioma_sel).."]"
		.."button_exit[0,4.3;3,1;voltar;"..SS(lang, "Voltar").."]"
	
	minetest.show_formspec(name, "mymenu:idiomas", formspec)
end

-- Receptor de botoes do menu de idiomas
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "mymenu:idiomas" then
		if not fields.quit and fields.idioma ~= "" and tb_idiomas[fields.idioma] then
			setlang(player:get_player_name(), tb_idiomas[fields.idioma])
			sfinv.set_player_inventory_formspec(player) -- Atualiza o inventario
			acessar_menu_idiomas(player)
			return
		end
	end
end)



-- Registrar metodo de tradução instantanea
mymenu.register_tr(SS)

-- Registrar botao
mymenu.register_button("mymenu:abrir_menu", "Idioma")

-- Receber botao do inventario
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields["mymenu:abrir_menu"] then
		acessar_menu_idiomas(player)
	end
end)

-- Traduções em separado
S("Idioma")
