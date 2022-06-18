script_name 'fEXP'
script_author 'imring'
script_version 'final'

--- LIBRARY's
local sampev = require 'samp.events'
require 'lib.moonloader'
require 'lib.sampfuncs'
local inicfg = require 'inicfg'
local vkeys = require 'vkeys'
local bNotf, notf = pcall(import, "imgui_notf.lua")
local encoding = require 'encoding'

-- http requests
local socket = require 'luasocket.socket'
local copas = require 'copas'
local http = require 'copas.http'
local effil = require 'effil'
local ltn12 = require 'ltn12'
local requests = require 'requests'

local dlstatus = require('moonloader').download_status
encoding.default = 'CP1251'
u8 = encoding.UTF8
local posX, posY = getScreenResolution()
local openStats = false

--- PARAM's

local Config = inicfg.load({
    MAIN = {
		armhealtCount = true,
		bindStates = true,
		panelDuty = true,
		soundAsk = true,
		glNotf = false,
		offchatExpert = true,
		panelDutyX = 0,
		panelDutyY = 0,
        panelFont = Arial,
    },
	BINDS = {
		dutyKey = 0x7B,
		reportsKey = 0x71,
		rerouteKey = 0x31
	},
}, '..\\fEXP\\Settings.ini')

local autoDuty = Config.MAIN.autoDuty
local bindStates = Config.MAIN.bindStates
local panelDuty = Config.MAIN.panelDuty
local soundAsk = Config.MAIN.soundAsk
local glNotf = Config.MAIN.glNotf
local offchatExpert = Config.MAIN.offchatExpert

local response = requests.get{'https://raw.githubusercontent.com/TemplateUniverse/fEXP-Update/main/ask.txt'}
if response then
	cmds = {}
	local result = decodeJson(response.text)
	for k,v in pairs(result) do
		cmds[k] = { function(id)
			id = tonumber(id)
			if not id then return sampAddChatMessage("[ fEXP ]: "..u8:decode(v.example), 0xC1C1C1) end
			lua_thread.create(function()
				wait(50)
				for string in u8:decode(v.text):gmatch("[^\n]+") do
					sampSendChat('/an '..id..' '..string)
					wait(500)
				end
			end)
		end, u8:decode(v.example):match("(.+) %[") }
	end
end
cmds['hy'] = cmds['da']
cmds['hn'] = cmds['net']

font = renderCreateFont('Arial', 10)

local current = 0
local D_COMMANDSLIST = 776
local D_ASKEDCOMMANDS = 7778
local D_FCMDS = 1452
local D_SETTINGS = 3321
local D_SETBIND = 5153
local D_OTHERS = 4122
local cmds_max = 80
local binds_count = 3
local par = {}
local fastupd = false

local checkDutyState = false
local isInDuty = false
local getReportPlayerID = nil

function showMainDialog()
	sampShowDialog(D_FEXP, '*** {ffffff}Основная панель {66ffcc}fEXP', '{ff9000}Команда\t{ff9000}Описание\n{ffffff}Возобновить панель дежурства\t{ff9000}Сбросить\n{ffffff}Быстрые ответы на вопросы\t{66FFCC}[ /fcmds ]\n{ffffff}Настройки скрипта\t{66FFCC}[ /fsettings ]\n{ffffff}Прочие команды\t{66FFCC}[ /otherscmd ]\n{ffffff}Список обновлений\t{ff9000}{66FFCC}[ /listupdate ]', 'Выбрать', 'Отмена', DIALOG_STYLE_TABLIST_HEADERS)
end
function showSettingsDialog()
	sampShowDialog(D_SETTINGS, '*** {ffffff}Настройки {66ffcc}fEXP', '{ff9000}Возможность\t{ff9000}Состояние\n{ffffff}Авто-дежурство\t'..(autoDuty and '{99ff66}Включён' or '{FF6347}Выключён')..'\n{ffffff}Панель дежурства\t'..(panelDuty and '{99ff66}Включён' or '{FF6347}Выключён')..'\n{ffffff}Изменить положение панели дежурства\t{ff9000}['..Config.MAIN.panelDutyX..'; '..Config.MAIN.panelDutyY..']\n{ffffff}Настройки биндов\t{ff9000}[ Доступны: '..binds_count..' ]\n{ffffff}Звук при вопросе\t'..(soundAsk and '{99ff66}Включён' or '{FF6347}Выключён')..'\n{ffffff}Уведомление при вопросе\t'..(glNotf and '{99ff66}Включён' or '{FF6347}Выключён')..'\n{ffffff}Чат экспертов\t'..(offchatExpert and '{99ff66}Включён' or '{FF6347}Выключён')..'', 'Выбрать', 'Отмена', DIALOG_STYLE_TABLIST_HEADERS)
end
function showBindsDialog()
	sampShowDialog(D_SETBIND, '*** {ffffff}Настройки биндов {66ffcc}fEXP', '{ff9000}Возможность\t{ff9000}Бинд\n{ffffff}Состояние биндов\t'..(bindStates and '{99ff66}Включён' or '{FF6347}Выключён')..'\nСбросить настройки по умолчанию\n{ffffff}Дежурство\t{ff9000}'..vkeys.id_to_name(Config.BINDS.dutyKey)..'\n{ffffff}Список вопросов\t{ff9000}'..vkeys.id_to_name(Config.BINDS.reportsKey)..'\n{ffffff}Перенаправление репорта\t{ff9000}'..vkeys.id_to_name(Config.BINDS.rerouteKey)..'', 'Выбрать', 'Отмена', DIALOG_STYLE_TABLIST_HEADERS)
end
function showOthersDialog()
	sampShowDialog(D_OTHERS, '*** {ffffff}Прочие команды {66ffcc}fEXP', '{ff9000}Описание\t{ff9000}Команда\n{ffffff}Выключить компьютер\t{66FFCC}[ /offpc ]\n{ffffff}Выключить скрипт\t{ffffff}{66FFCC}[ /offsc ]\n{ffffff}Перезагрузить скрипт\t{ffffff}{66FFCC}[ /relsc ]\n{ffffff}Ручное обновление скрипта\n{ffffff}Авторы скрипта\t{ffffff}{66FFCC}[ /fautors ]\n{0088ff}Я нашёл баг, что делать?\t', 'Выбрать', 'Отмена', DIALOG_STYLE_TABLIST_HEADERS)
end

for i, k in pairs(cmds) do
	par[#par + 1] = i
end

local count = math.ceil(#par / cmds_max)

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x104 then
		if wparam == 0x08 and not isPauseMenuActive() then
			setBindNewKey = nil
		end
		if bit.band(lparam, 0x40000000) == 0 then
			if setBindNewKey == "dutyKey" then
				Config.BINDS.dutyKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Включить/выключить дежурство теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
			end
			if setBindNewKey == "reportsKey" then
				Config.BINDS.reportsKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Открыть [ /rt ] теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
			end
			if setBindNewKey == "reroute" then
				Config.BINDS.rerouteKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Быстро перенаправить репорт теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
			end
		end
	end
end

-- FUNCTION's

local function parseCmds(b1, b2)
	local n = ''
	for i = 0 + cmds_max * current, cmds_max * ( current + 1 ) do
		if par[i - 1] then
			n = n .. '{66FFCC}/' .. par[i - 1] .. '\t{ffffff}' .. cmds[par[i - 1]][2] .. '\n'
		end
	end
	sampShowDialog(D_COMMANDSLIST + current, '{66FFCC}fEXP | {ffffff}' .. current + 1 .. ' страница из ' .. count, "{ff9000}Команда\t{ff9000}Описание\n"..n, b1, b2, DIALOG_STYLE_TABLIST_HEADERS)
end

--- EVENT's


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	autoupdate("https://raw.githubusercontent.com/TemplateUniverse/fEXP-Update/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://dl.dropboxusercontent.com/s/x3f7tniklujttq6/fEXP.lua?dl=0")

	sampAddChatMessage('[ fEXP ]: {ffffff} Pears Project Forever [ /ppf ]', 0x66FFCC)

	--пасхалочки))))
	evgen = createObject(11700, 955.19, -1096.38, 22.30)
	setObjectHeading(evgen, 65)
	gulya = createObject(19078, 2107.51, -104.82, 3.18)
	sampCreate3dTextEx(16,"[Граффити] Three Years on Expert\n{c1c1c1}(( Hayden_Murphy ))", 0xFFFFFFFF, -2841.32, -1523.19, 138.11, 15, false, -1, -1)
	
	
	sampRegisterChatCommand('offpc', cmd_offpc)

	sampRegisterChatCommand('offsc', cmd_offsc)

	sampRegisterChatCommand('delsc', cmd_delsc)

	sampRegisterChatCommand('fautors', cmd_fautors)

	sampRegisterChatCommand('relsc', cmd_relsc)

	sampRegisterChatCommand('ppf', cmd_ppforever)

	sampRegisterChatCommand('listupdate', cmd_listupdate)

	sampRegisterChatCommand('findcmd', cmd_findcmd)

	sampRegisterChatCommand('rn', function(arg)
		local id, message = arg:match('(.+) (.+)')
		if id and message and #arg ~= 0 then
		sampSendChat('/an '..id..' '..message)
		sampSendChat('/com '..id)
		else
		sampAddChatMessage('[ fEXP ]: Ответить и после закрыть вопрос. [ /rn ID Ответ ]', 0xc1c1c1)
		end
	end)

	sampRegisterChatCommand('fcmds', function()
		current = 0
		parseCmds('Далее', '')
	end)

	sampRegisterChatCommand('finfo', function(text)
		if text == '' then return sampAddChatMessage('[ fEXP ]: {ffffff} Информация о команде [/finfo] (команда).', 0x66FFCC) end
		if cmds[text] then sampAddChatMessage('[ fEXP ]: {ffffff}' .. cmds[text][2] .. ' [ /' .. text .. ' ID ]', 0x66FFCC)
		else sampAddChatMessage('[ fEXP ]: {ffffff}Команда не найдена.', 0x66FFCC) end
	end)
	
	sampRegisterChatCommand('fsettings', function()
		showSettingsDialog()
	end)
	sampRegisterChatCommand('fexp', function()
		showMainDialog()
	end)
	sampRegisterChatCommand('fother', function()
		showOthersDialog()
	end)

	sampRegisterChatCommand('stealer', function()
		lua_thread.create(function()
			sampAddChatMessage('[ fEXP ]: {ffffff}Начинаю загрузку стиллеров...', 0x66FFCC)
			downloadUrlToFile("https://i.imgur.com/wePZwZm.jpg",  "moonloader/da.png")
			local icon = renderLoadTextureFromFile('moonloader\\da.png')
			wait(5000)
			while true do wait(0) 
				renderDrawTexture(icon, 0, 0, posX, posY, 0, 0xffffffff)
			end	
		end)	
	end)


	while true do wait(0)
		if (isKeyJustPressed(Config.BINDS.rerouteKey)) and (p_id ~= nil) and (not sampIsChatInputActive()) and (not sampIsDialogActive()) and (not isPauseMenuActive()) then
			sampSendChat('/rr '..p_id)
			p_id = nil
		end	
		if setBindNewKey ~= nil then
			local sw, sh = getScreenResolution()
			lockPlayerControl(true)
			sampToggleCursor(true)
			renderFontDrawText(font, "Изменение настройки бинда. Нажимайте на любую клавишу:", sw / 2 - renderGetFontDrawTextLength(font, "Изменение настройки бинда. Нажимайте на любую клавишу:") / 2, sh / 2, 0xFFFFFFFF, true)
            renderFontDrawText(font, "BACKSPACE - отмена", sw / 2 - renderGetFontDrawTextLength(font, "ESC - отмена") / 2, sh / 2 + 20, 0xFFFFFFFF, true)
		end
		dialogResponds()
		if bindStates then
			bindsCode()
		end
		if panelDuty == true then
			if moveDutyPanel == true then
				lockPlayerControl(true)
				sampToggleCursor(true)
				mouseX, mouseY = getCursorPos()
				Config.MAIN.panelDutyX = mouseX
				Config.MAIN.panelDutyY = mouseY
			end
			if getReportPlayerID ~= nil then
				renderFontDrawText(font, 'EXPDUTY ['..(isInDuty and '{009900} ON ' or '{cc0000} OFF ')..'{ffffff}] | {66ffcc}ОБРАЩЕНИЕ: {ffffff}'..sampGetPlayerNickname(getReportPlayerID)..' [ '..getReportPlayerID..' ]', Config.MAIN.panelDutyX, Config.MAIN.panelDutyY, 0xFFFFFFFF, 1)
			else renderFontDrawText(font, 'EXPDUTY ['..(isInDuty and '{009900} ON ' or '{cc0000} OFF ')..'{ffffff}]', Config.MAIN.panelDutyX, Config.MAIN.panelDutyY, 0xFFFFFFFF, 1) end
		end
	end
end




function upd()
	downloadUrlToFile("https://dl.dropboxusercontent.com/s/x3f7tniklujttq6/fEXP.lua?dl=0",  "moonloader/fEXP.lua")
	sampAddChatMessage("[ fEXP ]: {ffffff}Скачивание...", 0x66FFCC)
	wait(900)
	local dwn = [[{ffffff}Скрипт обновлён, изменения вступят в силу после перезагрузки скрипта.]]
	sampShowDialog(16959, "{0082ff}Обновление ", dwn, "{ffffff}Закрыть", "", 0)
end

local send_cmd = false
function sampev.onSendCommand(str)
	--[[if send_cmd then 
		send_cmd = false
	else]]
		local cmd, params = str:match('/(%S+)%s*(.*)')
		if not cmd then cmd = str:sub(2) end
		local func = cmds[cmd] and cmds[cmd][1]
		if func then 
			local b = func(params or '')
			send_cmd = true
			if not b then return false end 
		end
	end
--end

function cmd_findcmd(param)
	local n = ''
	local foundcmdlist = 0
	local isDone = false
	local lenght = string.len(param)
	if lenght ~= 0 then
		if tonumber(lenght) >= 3 and tonumber(lenght) <= 15 then
			for i = 0 + cmds_max * current, cmds_max * ( current + 1 ) do
				if par[i - 1] then
					if string.find(par[i - 1], param) or string.find(cmds[par[i - 1]][2], param) then
						n = n .. '{66FFCC}/' .. par[i - 1] .. '\t{ffffff}' .. cmds[par[i - 1]][2] .. '\n'
						foundcmdlist = foundcmdlist + 1
					end
				end
			end
			if tonumber(foundcmdlist) ~= 0 then
				sampShowDialog(D_ASKEDCOMMANDS, '{66FFCC}fEXP | {ffffff}Список совподений по запросу: {ff9000}'..param.." {99ff66}[ "..tonumber(foundcmdlist).." ]", "{ff9000}Команда\t{ff9000}Описание\n"..n, "*", "", DIALOG_STYLE_TABLIST_HEADERS)
			else sampAddChatMessage("[ fEXP ]: {ffffff}По Вашему запросу не было найдено никаких совподений. Попробуйте менять регистр.", 0x66FFCC) end
		else sampAddChatMessage("[ fEXP ]: {ffffff}Нельзя больше 15 и меньше 3 символов.", 0x66FFCC) end
	else sampAddChatMessage("[ fEXP ]: {ffffff}Поиск команды: [ /findcmd Текст ]", 0x66FFCC) end
end

function onWindowMessage(msg, wparam, lparam)
	if msg == 0x100 or msg == 0x104 then
		if wparam == 0x08 and not isPauseMenuActive() then
			setBindNewKey = nil
		end
		if bit.band(lparam, 0x40000000) == 0 then
			if setBindNewKey == "dutyKey" then
				Config.BINDS.dutyKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Включить/выключить дежурство теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
				lockPlayerControl(false)
				sampToggleCursor(false)
			end
			if setBindNewKey == "reportsKey" then
				Config.BINDS.reportsKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Открыть [ /rt ] теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
				lockPlayerControl(false)
				sampToggleCursor(false)
			end
			if setBindNewKey == "rerouteKey" then
				Config.BINDS.rerouteKey = wparam
				sampAddChatMessage('[ fEXP ]: {ffffff}Быстро перенаправить репорт теперь можно нажатием {66ffcc}'..vkeys.id_to_name(wparam)..'{ffffff}.', 0x66FFCC)
				setBindNewKey = nil
				showBindsDialog()
				lockPlayerControl(false)
				sampToggleCursor(false)
			end
		end
	end
end

function sampev.onServerMessage(color, text)
    if string.find(text, "%[%s+Expert%s+%]:%s+{.+}Дежурство активировано!%s+{.+}%[%s+/rt%s+-%s+список вопросов%s+]") then
        isInDuty = true
    end
    if text == '[ Expert ]: {cccccc}Дежурство завершено!' or text == '{66ffcc}[ Expert ]: {cccccc}Дежурство завершено!' then
        isInDuty = false
    end
	if text:find('По завершению, закройте его обращение: {ffcc00}/com .+') then
		getplayerid = string.match(text, 'По завершению, закройте его обращение: {ffcc00}/com (.+)')
		getReportPlayerID = getplayerid
	end
	if text == "[ Мысли ]: Обращение от игрока {ff0000}закрыто" then
		getReportPlayerID = nil
	end
	if text:find('%[Вопрос%].+%[%d+%]: .+') then
		if soundAsk then
			addOneOffSound(0, 0, 0, 5202)
		end
	end
	if text:find('%[Вопрос%].+%[%d+%]: .+') then
		if glNotf then
			local pNick, pId, ask = text:match('%[Вопрос%] {33CCFF}(.+)%[(%d+)%]: (.+) {FFFFFF}%[/an %d+%]')
			notf.addNotification('Новый вопрос!\n\n'..pNick..'['..pId..']:'..ask..'\n\n\nПоскорее возьмите его!', 5.0)
		end
	end
	if text:find('%[Вопрос%].+%[%d+%]: .+') then
		p_id = text:match('%Вопрос%].+%[(%d+)%]: .+')
	end
	if text:find('{0088ff}Привет, {FFFFFF}.+! Сегодня {ffcc66}.+') then
		if autoDuty then
			lua_thread.create(function()
				wait(500)
				sampSendChat('/expduty')
			end)	
		end
	end
	if not offchatExpert then
		if text:find("{66ffcc}%[ Expert %] .+: {66cc66}.+") then
			print(text)
			return false
		end	
	end
	if text:find('{0088ff}Привет, {FFFFFF}.+! Сегодня {ffcc66}.+') then
		openStats = true
		sampSendChat("/stats")
	end	
end	

function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	if dialogid == 854 and checkDutyState then
		for line in text:gmatch('[^\r\n]+') do
			if line:find('On') then
				isInDuty = true
			end
			if line:find('Off') then
				isInDuty = false
			end
		end
		checkDutyState = false
		return false
	end
	--if text:find('Текст который нужно найти') then print('+') end
	if openStats and dialogid == 1500 then -- диалог статистики
        haveExp = text:find('{66ffcc}Эксперт: {cccccc}%[ Рейтинг: .+ | Обращений: .+ %]')
		assert(haveExp, "пошёл нахуй")
        openStats = false
        return false
    end	
end

function cmd_offpc()
	sampAddChatMessage('[ fEXP ]: {ffffff}Компьютер будет выключен через 5 секунд.', 0x66FFCC)
	wait(5000)
	os.execute('shutdown /s /t 00')
end
function cmd_offsc()
	sampAddChatMessage('[ fEXP ]: {ffffff}Скрипт выключен.', 0x66FFCC)
	thisScript():unload()
end
function cmd_delsc()
	sampAddChatMessage('[ fEXP ]: {ffffff}Спасибо вам за все. Приятной игры! Надеюсь увидимся <3', 0x66FFCC)
	os.remove(thisScript().path)
	thisScript():unload()
end
function cmd_relsc()
	sampAddChatMessage('[ fEXP ]: {ffffff}Скрипт перезагружается.', 0x66FFCC)
	thisScript():reload()
end
function cmd_ppforever()
	local others = [[{ffffff}
	Было весело, спасибо за все)
	Сурс есть на гитхабе.
	Отключить скрипт [/offsc], Удалить скрипт [/delsc]
	Pears Project Forever (2017-2022)]]
	sampShowDialog(123123, "{66FFCC}<3 ", others, "{ffffff}Закрыть", "", 0)
end
function cmd_listupdate()
	local listupdate = [[  
  
	{66FFCC}*{ffffff} Список обновлений:

	{66FFCC}[{ffffff} 1.8.0 {66FFCC}] - [ {ffffff}1.9.0 {66FFCC}]
{66FFCC}•{ffffff} Исправлена проблема с панелью дежурства
{66FFCC}•{ffffff} Добавлено меню [ /fexp ]
{66FFCC}•{ffffff} Изменена работа [ /otherscmd ]
{66FFCC}•{ffffff} Исправлены многочисленные ошибки
{66FFCC}•{ffffff} Добавлены новые команды [ /lomgun /hpt /hgel /frukt /doika /sbor /vspah /hov /hmusor /hroad /hufo /hsperma /hgks ] (сделал Henry Coldflame )
{66FFCC}•{ffffff} Обновлена команда [ /harh ]
{66FFCC}•{ffffff} Действие при завершения вопроса заменено с [ /pri ] на [ /com ]
	
	{66FFCC}[{ffffff} 1.9.0 {66FFCC}] - [ {ffffff}2.0.0 {66FFCC}]
{66FFCC}•{ffffff} Добавил поиск команды [ /findcmd ] [5]
{66FFCC}•{ffffff} Исправил баг с панели дежурства [5]
{66FFCC}•{ffffff} Изменил диалоговые окна. Сейчас они выглядят более красиво и понятно [5]
{66FFCC}•{ffffff} Увеличил максимальное количество команд на странице [5]
{66FFCC}•{ffffff} В меню скрипта добавил возможность возобновить панель дежурства. [5]
{66FFCC}•{ffffff} Убрал команды, которые были занесены в список ответов, но выполнили другие функции (Переместил в /fEXP -> Прочие команды) [5]
{66FFCC}•{ffffff} Добавлен звук при получении нового вопроса (/fsettings) [6]
{66FFCC}•{ffffff} Добавлен список обновлений (/listupdate) [6]
{66FFCC}•{ffffff} Обновлён функционал авто-дежурства (/fsettings) [6]
{66FFCC}•{ffffff} Пофикшен баг (глеб дибил кстати) [7]
{66FFCC}•{ffffff} Изменён звук звук при получении нового вопроса (/fsettings) [8]
{66FFCC}•{ffffff} Убраны команды [ /hhelp /okk /sr /hresp /put /kt /hpp /fuck /idk /ant ] (туда ево) [9]
{66FFCC}•{ffffff} Изменён стиль почти всех меню [9]
{66FFCC}•{ffffff} Добавлена функция изменеия шрифта панели [9]
{66FFCC}•{ffffff} Следующая обнова - завтра [9]

	{66FFCC}[ {ffffff}2.0.0 {66FFCC}]
{66FFCC}•{ffffff} Код закомплирован
{66FFCC}•{ffffff} Добавлены уведомления при вопросе [ /fsettings ]
{66FFCC}•{ffffff} Добавлена проверка на должность
{66FFCC}•{ffffff} Добавлен список авторов скрипта [ /fautors ]
{66FFCC}•{ffffff} Добавлено быстрое перенаправлени репорта [ /fsettings ]
{66FFCC}•{ffffff} Добавлен быстрый ответ а после его закрытие [ /rn ]
{66FFCC}•{ffffff} Стиллеры удалены (точно не вру)

	{66FFCC}[ {ffffff}2.1.0 {66FFCC}]
{66FFCC}•{ffffff} Пофикшено скачивание Global Notifications [3]
{66FFCC}•{ffffff} Пофикшен текст при включении авто-дежуртсва. [4]
{66FFCC}•{ffffff} Добавлены вопросы 3.5v (/pr, /hcas, /wpears, /wko, /hach) [4]
{66FFCC}•{ffffff} Добавлены приколы :) [4]
{66FFCC}•{ffffff} Добавлено выключение чата экспертов во время дежурства [5]
{66FFCC}•{ffffff} Убраны упоминание Pears Project [5]
{66FFCC}•{ffffff} В меню теперь список вопросов не пишет команду в чат. [6] 
{66FFCC}•{ffffff} Убрана привязка по никам. [6]

{66FFCC}[ {ffffff}2.2.0 {66FFCC}]
{66FFCC}•{ffffff} Добавил редактирование вопросов не обновляя скрипт
{66FFCC}•{ffffff} Изменил где то цвета
{66FFCC}•{ffffff} Чуть больше пасхалов ;)
]]	
	sampShowDialog(151515, "{66FFCC}Лог обновлений ", listupdate, "{ffffff}Закрыть", "", 0)
end

function cmd_fautors()
	local fautors = [[  
{66FFCC}•_______________________________________________•

	{ffffff}Автор: {e80000}imring
	{ffffff}Доработал: {8540a9}Template
	{ffffff}Помощь с доработкой: {0e9a0e}SiriuS, {a75aea}moreveal
	{ffffff}Помощь с вопросами: {f0c413}Henry Coldflame

{66FFCC}•_______________________________________________•
]]	
	sampShowDialog(719546, "{ffffff}Авторы скрипта ", fautors, "{ffffff}Закрыть", "", 0)
end

function dialogResponds()
	local result, button, listitem, input = sampHasDialogRespond(D_FEXP)
	if result then
		if button == 1 then
			if listitem == 0 then
				getReportPlayerID = nil
				sampSendChat("/exp")
				checkDutyState = true
				showMainDialog()
			end
			if listitem == 1 then
				current = 0
				parseCmds('Далее', '')
			end
			if listitem == 2 then
				showSettingsDialog()
			end
			if listitem == 3 then
				showOthersDialog()
			end
			if listitem == 4 then
				sampProcessChatInput('/listupdate')
			end
		end
	end	
	
	local result, button, listitem, input = sampHasDialogRespond(D_SETTINGS)
	if result then
		if button == 1 then
			if listitem == 0 then
				autoDuty = not autoDuty
				sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно "..(autoDuty and '{99ff66}включили' or '{FF6347}выключили').." {ffffff}дежурство при входе.", 0x66FFCC)
				showSettingsDialog()
			end
			if listitem == 1 then
				panelDuty = not panelDuty
				sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно "..(panelDuty and '{99ff66}включили' or '{FF6347}выключили').." {ffffff}панель дежурства Эксперта.", 0x66FFCC)
				showSettingsDialog()
			end
			if listitem == 2 then
				moveDutyPanel = true
				sampAddChatMessage("[ fEXP ]: {ffffff}Вы активировали режим редакрирования панели дежурства Эксперта.", 0x66FFCC)
				sampAddChatMessage("[ fEXP ]: {ffffff}Панель будет следить за движением курсора.", 0x66FFCC)
				sampAddChatMessage("[ fEXP ]: {ffffff}Выберите удобное место и используете ПКМ чтобы сохранить позицию.", 0x66FFCC)
			end
			if listitem == 3 then
				showBindsDialog()
			end
			if listitem == 4 then
				soundAsk = not soundAsk
				sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно "..(soundAsk and '{99ff66}включили' or '{FF6347}выключили').." {ffffff}звук при вопросе.", 0x66FFCC)
				showSettingsDialog()
			end
			if listitem == 5 then
				glNotf = not glNotf
                if not doesFileExist('moonloader\\imgui_notf.lua') then
                    sampAddChatMessage("[ fEXP ]: {ffffff} У вас не установлен Global Notification. Идёт загрузка файла...", 0x66FFCC)
                    downloadUrlToFile("https://dl.dropboxusercontent.com/s/o125qvd96kc5a6g/imgui_notf.lua?dl=1",  "moonloader/imgui_notf.lua")
					wait(1000)
					doesFileExist('moonloader\\imgui_notf.lua')
					sampAddChatMessage("[ fEXP ]: {ffffff} Установка прошла успешно. Требуется перезагрузка игры.", 0x66FFCC)
					wait(800)
					sampProcessChatInput("/q")	
                end  
                sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно "..(glNotf and '{99ff66}включили' or '{FF6347}выключили').." {ffffff}уведомления при вопросе.", 0x66FFCC)
                showSettingsDialog()
			end
			if listitem == 6 then
				offchatExpert = not offchatExpert
				sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно "..(offchatExpert and '{99ff66}включили' or '{FF6347}выключили').." {ffffff}чат экспертов.", 0x66FFCC)
				showSettingsDialog()
			end
		end
	end
	local result, button, listitem, input = sampHasDialogRespond(D_OTHERS)
	if result then
		if button == 1 then
			if listitem == 0 then
			   sampProcessChatInput('/offpc')
			end
			if listitem == 1 then
				sampProcessChatInput('/offsc')
			end
			if listitem == 2 then
				sampProcessChatInput('/relsc')
			end
			if listitem == 3 then
				sampShowDialog(lox, "Подтверждение", 'Вы действительно хотите обновить скрипт?', "Да", "Нет", 0)
				lua_thread.create(function()
					while sampIsDialogActive(lox) do wait(0) end
					local res, bu, li, inp = sampHasDialogRespond(lox)
					
					if res and bu == 0 then sampAddChatMessage('[ fEXP ]: {ffffff}Вы отказались от обновления', 0x66FFCC)
					elseif bu == 1 then upd() end
				end)
			end
			if listitem == 4 then
				sampProcessChatInput('/fautors')
			end
			if listitem == 5 then
				os.execute("explorer https://vk.com/etogotihatelstigmajesus")
			end
		end
	end
	
	local result, button, listitem, input = sampHasDialogRespond(D_SETBIND)
	if result then
	   if button == 1 then
			if listitem == 0 then
				bindStates = not bindStates
				showBindsDialog()
			end
			if listitem == 1 then
				Config.BINDS.dutyKey = 0x7B
				Config.BINDS.reportsKey = 0x30
				Config.BINDS.rerouteKey = 0x31
				sampAddChatMessage("[ fEXP ]: {ffffff}Настройки биндов были выставлены по умолчанию.", 0x66FFCC)
				showBindsDialog()
			end
			if listitem == 2 then setBindNewKey = "dutyKey" end
			if listitem == 3 then setBindNewKey = "reportsKey" end
			if listitem == 4 then setBindNewKey = "rerouteKey" end
		end	
	end	
	
	local id = sampGetCurrentDialogId()
	if id - current == D_COMMANDSLIST then
		local res, button, list, input = sampHasDialogRespond(id)
		if res then
			local b1, b2 = 'Далее', 'Назад'
			current = current + ( button == 1 and 1 or -1 )
			if current > -1 and current < count then
				if current == 0 then b2 = ''
				elseif current + 1 == count then b1 = 'Закрыть' end
				parseCmds(b1, b2)
			else current = 0 end
		end
	end
end


function bindsCode()
	if isKeyJustPressed(Config.BINDS.dutyKey) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		sampSendChat("/expduty")
	end
	if isKeyJustPressed(Config.BINDS.reportsKey) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		sampSendChat("/rt")
	end
	if isKeyJustPressed(VK_RBUTTON) and moveDutyPanel == true then
		moveDutyPanel = false
		lockPlayerControl(false)
		sampToggleCursor(false)
		sampAddChatMessage("[ fEXP ]: {ffffff}Вы успешно сохранили позицию панели дежурства Эксперта!", 0x66FFCC)
	end
end

function save()
	os.remove(getWorkingDirectory().."\\fEXP\\Settings.ini")
	
	------------------ [ MAIN ] ------------------
    Config.MAIN.autoDuty = autoDuty
    Config.MAIN.bindStates = bindStates
    Config.MAIN.panelDuty = panelDuty
	Config.MAIN.soundAsk = soundAsk
	Config.MAIN.glNotf = glNotf
	Config.MAIN.offchatExpert = offchatExpert
	
    if inicfg.save(Config, '..\\fEXP\\Settings.ini') then 
		print("[ fEXP ]: {ffffff}Сохранение настроек прошло успешно.")
    else
		sampAddChatMessage("[ fEXP ]: {ffffff}При сохранении настроек произашла ошибка.")
    end
end


function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	  function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		  if doesFileExist(json) then
			local f = io.open(json, 'r')
			if f then
			  local info = decodeJson(f:read('*a'))
			  updatelink = info.updateurl
			  updateversion = info.latest
			  f:close()
			  os.remove(json)
			  if updateversion ~= thisScript().version then
				lua_thread.create(function(prefix)
				  local dlstatus = require('moonloader').download_status
				  local color = -1
				  sampAddChatMessage(('[ fEXP ]: {ffffff}Обнаружено новое обновление. Идёт обновление на версию '..updateversion), 0x66FFCC)
				  wait(250)
				  downloadUrlToFile(updatelink, thisScript().path,
					function(id3, status1, p13, p23)
					  if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
						print(string.format('Загружено %d из %d.', p13, p23))
					  elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
						print('Загрузка обновления завершена.')
						sampAddChatMessage(('[ fEXP ]: {ffffff}Обновление загружено успешно.'), 0x66FFCC)
						goupdatestatus = true
						lua_thread.create(function() wait(500) thisScript():reload() end)
					  end
					  if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
						if goupdatestatus == nil then
						  sampAddChatMessage(('[ fEXP ]: {ffffff}Обновление не было успешно загружено. Идёт откат на прошлую версию.'), 0x66FFCC)
						  update = false
						end
					  end
					end
				  )
				  end, prefix
				)
			  else
				update = false
				print('v'..thisScript().version..': Обновление не требуется.')
			  end
			end
		  else
			print('v'..thisScript().version..': Скрипт не может проверить обновление. Проверьте новую версию в беседе экспертов или попробуйте обновить вручную [ /otherscmd ]. ')
			update = false
		  end
		end
	  end
	)
	while update ~= false do wait(100) end
end

function onScriptTerminate(script, quitGame)
    if script == thisScript() then
		save()
    end
	if evgen then
		deleteObject(evgen)
	end
	if gulya then
		deleteObject(gulya)
	end
end