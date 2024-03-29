-- This file is part of SA MoonLoader package.
-- Licensed under the MIT License.
-- Copyright (c) 2016, BlastHack Team <blast.hk>


local k = {
	VK_LBUTTON = 0x01,
	VK_RBUTTON = 0x02,
	VK_CANCEL = 0x03,
	VK_MBUTTON = 0x04,
	VK_XBUTTON1 = 0x05,
	VK_XBUTTON2 = 0x06,
	VK_BACK = 0x08,
	VK_TAB = 0x09,
	VK_CLEAR = 0x0C,
	VK_RETURN = 0x0D,
	VK_SHIFT = 0x10,
	VK_CONTROL = 0x11,
	VK_MENU = 0x12,
	VK_PAUSE = 0x13,
	VK_CAPITAL = 0x14,
	VK_KANA = 0x15,
	VK_JUNJA = 0x17,
	VK_FINAL = 0x18,
	VK_KANJI = 0x19,
	VK_ESCAPE = 0x1B,
	VK_CONVERT = 0x1C,
	VK_NONCONVERT = 0x1D,
	VK_ACCEPT = 0x1E,
	VK_MODECHANGE = 0x1F,
	VK_SPACE = 0x20,
	VK_PRIOR = 0x21,
	VK_NEXT = 0x22,
	VK_END = 0x23,
	VK_HOME = 0x24,
	VK_LEFT = 0x25,
	VK_UP = 0x26,
	VK_RIGHT = 0x27,
	VK_DOWN = 0x28,
	VK_SELECT = 0x29,
	VK_PRINT = 0x2A,
	VK_EXECUTE = 0x2B,
	VK_SNAPSHOT = 0x2C,
	VK_INSERT = 0x2D,
	VK_DELETE = 0x2E,
	VK_HELP = 0x2F,
	VK_0 = 0x30,
	VK_1 = 0x31,
	VK_2 = 0x32,
	VK_3 = 0x33,
	VK_4 = 0x34,
	VK_5 = 0x35,
	VK_6 = 0x36,
	VK_7 = 0x37,
	VK_8 = 0x38,
	VK_9 = 0x39,
	VK_A = 0x41,
	VK_B = 0x42,
	VK_C = 0x43,
	VK_D = 0x44,
	VK_E = 0x45,
	VK_F = 0x46,
	VK_G = 0x47,
	VK_H = 0x48,
	VK_I = 0x49,
	VK_J = 0x4A,
	VK_K = 0x4B,
	VK_L = 0x4C,
	VK_M = 0x4D,
	VK_N = 0x4E,
	VK_O = 0x4F,
	VK_P = 0x50,
	VK_Q = 0x51,
	VK_R = 0x52,
	VK_S = 0x53,
	VK_T = 0x54,
	VK_U = 0x55,
	VK_V = 0x56,
	VK_W = 0x57,
	VK_X = 0x58,
	VK_Y = 0x59,
	VK_Z = 0x5A,
	VK_LWIN = 0x5B,
	VK_RWIN = 0x5C,
	VK_APPS = 0x5D,
	VK_SLEEP = 0x5F,
	VK_NUMPAD0 = 0x60,
	VK_NUMPAD1 = 0x61,
	VK_NUMPAD2 = 0x62,
	VK_NUMPAD3 = 0x63,
	VK_NUMPAD4 = 0x64,
	VK_NUMPAD5 = 0x65,
	VK_NUMPAD6 = 0x66,
	VK_NUMPAD7 = 0x67,
	VK_NUMPAD8 = 0x68,
	VK_NUMPAD9 = 0x69,
	VK_MULTIPLY = 0x6A,
	VK_ADD = 0x6B,
	VK_SEPARATOR = 0x6C,
	VK_SUBTRACT = 0x6D,
	VK_DECIMAL = 0x6E,
	VK_DIVIDE = 0x6F,
	VK_F1 = 0x70,
	VK_F2 = 0x71,
	VK_F3 = 0x72,
	VK_F4 = 0x73,
	VK_F5 = 0x74,
	VK_F6 = 0x75,
	VK_F7 = 0x76,
	VK_F8 = 0x77,
	VK_F9 = 0x78,
	VK_F10 = 0x79,
	VK_F11 = 0x7A,
	VK_F12 = 0x7B,
	VK_F13 = 0x7C,
	VK_F14 = 0x7D,
	VK_F15 = 0x7E,
	VK_F16 = 0x7F,
	VK_F17 = 0x80,
	VK_F18 = 0x81,
	VK_F19 = 0x82,
	VK_F20 = 0x83,
	VK_F21 = 0x84,
	VK_F22 = 0x85,
	VK_F23 = 0x86,
	VK_F24 = 0x87,
	VK_NUMLOCK = 0x90,
	VK_SCROLL = 0x91,
	VK_OEM_FJ_JISHO = 0x92,
	VK_OEM_FJ_MASSHOU = 0x93,
	VK_OEM_FJ_TOUROKU = 0x94,
	VK_OEM_FJ_LOYA = 0x95,
	VK_OEM_FJ_ROYA = 0x96,
	VK_LSHIFT = 0xA0,
	VK_RSHIFT = 0xA1,
	VK_LCONTROL = 0xA2,
	VK_RCONTROL = 0xA3,
	VK_LMENU = 0xA4,
	VK_RMENU = 0xA5,
	VK_BROWSER_BACK = 0xA6,
	VK_BROWSER_FORWARD = 0xA7,
	VK_BROWSER_REFRESH = 0xA8,
	VK_BROWSER_STOP = 0xA9,
	VK_BROWSER_SEARCH = 0xAA,
	VK_BROWSER_FAVORITES = 0xAB,
	VK_BROWSER_HOME = 0xAC,
	VK_VOLUME_MUTE = 0xAD,
	VK_VOLUME_DOWN = 0xAE,
	VK_VOLUME_UP = 0xAF,
	VK_MEDIA_NEXT_TRACK = 0xB0,
	VK_MEDIA_PREV_TRACK = 0xB1,
	VK_MEDIA_STOP = 0xB2,
	VK_MEDIA_PLAY_PAUSE = 0xB3,
	VK_LAUNCH_MAIL = 0xB4,
	VK_LAUNCH_MEDIA_SELECT = 0xB5,
	VK_LAUNCH_APP1 = 0xB6,
	VK_LAUNCH_APP2 = 0xB7,
	VK_OEM_1 = 0xBA,
	VK_OEM_PLUS = 0xBB,
	VK_OEM_COMMA = 0xBC,
	VK_OEM_MINUS = 0xBD,
	VK_OEM_PERIOD = 0xBE,
	VK_OEM_2 = 0xBF,
	VK_OEM_3 = 0xC0,
	VK_ABNT_C1 = 0xC1,
	VK_ABNT_C2 = 0xC2,
	VK_OEM_4 = 0xDB,
	VK_OEM_5 = 0xDC,
	VK_OEM_6 = 0xDD,
	VK_OEM_7 = 0xDE,
	VK_OEM_8 = 0xDF,
	VK_OEM_AX = 0xE1,
	VK_OEM_102 = 0xE2,
	VK_ICO_HELP = 0xE3,
	VK_PROCESSKEY = 0xE5,
	VK_ICO_CLEAR = 0xE6,
	VK_PACKET = 0xE7,
	VK_OEM_RESET = 0xE9,
	VK_OEM_JUMP = 0xEA,
	VK_OEM_PA1 = 0xEB,
	VK_OEM_PA2 = 0xEC,
	VK_OEM_PA3 = 0xED,
	VK_OEM_WSCTRL = 0xEE,
	VK_OEM_CUSEL = 0xEF,
	VK_OEM_ATTN = 0xF0,
	VK_OEM_FINISH = 0xF1,
	VK_OEM_COPY = 0xF2,
	VK_OEM_AUTO = 0xF3,
	VK_OEM_ENLW = 0xF4,
	VK_OEM_BACKTAB = 0xF5,
	VK_ATTN = 0xF6,
	VK_CRSEL = 0xF7,
	VK_EXSEL = 0xF8,
	VK_EREOF = 0xF9,
	VK_PLAY = 0xFA,
	VK_ZOOM = 0xFB,
	VK_PA1 = 0xFD,
	VK_OEM_CLEAR = 0xFE,
}

local names = {
	[k.VK_LBUTTON] = 'Left Button',
	[k.VK_RBUTTON] = 'Right Button',
	[k.VK_CANCEL] = 'Break',
	[k.VK_MBUTTON] = 'Middle Button',
	[k.VK_XBUTTON1] = 'X Button 1',
	[k.VK_XBUTTON2] = 'X Button 2',
	[k.VK_BACK] = 'Backspace',
	[k.VK_TAB] = 'Tab',
	[k.VK_CLEAR] = 'Clear',
	[k.VK_RETURN] = 'Enter',
	[k.VK_SHIFT] = 'Shift',
	[k.VK_CONTROL] = 'Ctrl',
	[k.VK_MENU] = 'Alt',
	[k.VK_PAUSE] = 'Pause',
	[k.VK_CAPITAL] = 'Caps Lock',
	[k.VK_KANA] = 'Kana',
	[k.VK_JUNJA] = 'Junja',
	[k.VK_FINAL] = 'Final',
	[k.VK_KANJI] = 'Kanji',
	[k.VK_ESCAPE] = 'Esc',
	[k.VK_CONVERT] = 'Convert',
	[k.VK_NONCONVERT] = 'Non Convert',
	[k.VK_ACCEPT] = 'Accept',
	[k.VK_MODECHANGE] = 'Mode Change',
	[k.VK_SPACE] = 'Space',
	[k.VK_PRIOR] = 'Page Up',
	[k.VK_NEXT] = 'Page Down',
	[k.VK_END] = 'End',
	[k.VK_HOME] = 'Home',
	[k.VK_LEFT] = 'Arrow Left',
	[k.VK_UP] = 'Arrow Up',
	[k.VK_RIGHT] = 'Arrow Right',
	[k.VK_DOWN] = 'Arrow Down',
	[k.VK_SELECT] = 'Select',
	[k.VK_PRINT] = 'Print',
	[k.VK_EXECUTE] = 'Execute',
	[k.VK_SNAPSHOT] = 'Print Screen',
	[k.VK_INSERT] = 'Insert',
	[k.VK_DELETE] = 'Delete',
	[k.VK_HELP] = 'Help',
	[k.VK_0] = '0',
	[k.VK_1] = '1',
	[k.VK_2] = '2',
	[k.VK_3] = '3',
	[k.VK_4] = '4',
	[k.VK_5] = '5',
	[k.VK_6] = '6',
	[k.VK_7] = '7',
	[k.VK_8] = '8',
	[k.VK_9] = '9',
	[k.VK_A] = 'A',
	[k.VK_B] = 'B',
	[k.VK_C] = 'C',
	[k.VK_D] = 'D',
	[k.VK_E] = 'E',
	[k.VK_F] = 'F',
	[k.VK_G] = 'G',
	[k.VK_H] = 'H',
	[k.VK_I] = 'I',
	[k.VK_J] = 'J',
	[k.VK_K] = 'K',
	[k.VK_L] = 'L',
	[k.VK_M] = 'M',
	[k.VK_N] = 'N',
	[k.VK_O] = 'O',
	[k.VK_P] = 'P',
	[k.VK_Q] = 'Q',
	[k.VK_R] = 'R',
	[k.VK_S] = 'S',
	[k.VK_T] = 'T',
	[k.VK_U] = 'U',
	[k.VK_V] = 'V',
	[k.VK_W] = 'W',
	[k.VK_X] = 'X',
	[k.VK_Y] = 'Y',
	[k.VK_Z] = 'Z',
	[k.VK_LWIN] = 'Left Win',
	[k.VK_RWIN] = 'Right Win',
	[k.VK_APPS] = 'Context Menu',
	[k.VK_SLEEP] = 'Sleep',
	[k.VK_NUMPAD0] = 'Numpad 0',
	[k.VK_NUMPAD1] = 'Numpad 1',
	[k.VK_NUMPAD2] = 'Numpad 2',
	[k.VK_NUMPAD3] = 'Numpad 3',
	[k.VK_NUMPAD4] = 'Numpad 4',
	[k.VK_NUMPAD5] = 'Numpad 5',
	[k.VK_NUMPAD6] = 'Numpad 6',
	[k.VK_NUMPAD7] = 'Numpad 7',
	[k.VK_NUMPAD8] = 'Numpad 8',
	[k.VK_NUMPAD9] = 'Numpad 9',
	[k.VK_MULTIPLY] = 'Numpad *',
	[k.VK_ADD] = 'Numpad +',
	[k.VK_SEPARATOR] = 'Separator',
	[k.VK_SUBTRACT] = 'Num -',
	[k.VK_DECIMAL] = 'Numpad .',
	[k.VK_DIVIDE] = 'Numpad /',
	[k.VK_F1] = 'F1',
	[k.VK_F2] = 'F2',
	[k.VK_F3] = 'F3',
	[k.VK_F4] = 'F4',
	[k.VK_F5] = 'F5',
	[k.VK_F6] = 'F6',
	[k.VK_F7] = 'F7',
	[k.VK_F8] = 'F8',
	[k.VK_F9] = 'F9',
	[k.VK_F10] = 'F10',
	[k.VK_F11] = 'F11',
	[k.VK_F12] = 'F12',
	[k.VK_F13] = 'F13',
	[k.VK_F14] = 'F14',
	[k.VK_F15] = 'F15',
	[k.VK_F16] = 'F16',
	[k.VK_F17] = 'F17',
	[k.VK_F18] = 'F18',
	[k.VK_F19] = 'F19',
	[k.VK_F20] = 'F20',
	[k.VK_F21] = 'F21',
	[k.VK_F22] = 'F22',
	[k.VK_F23] = 'F23',
	[k.VK_F24] = 'F24',
	[k.VK_NUMLOCK] = 'Num Lock',
	[k.VK_SCROLL] = 'Scrol Lock',
	[k.VK_OEM_FJ_JISHO] = 'Jisho',
	[k.VK_OEM_FJ_MASSHOU] = 'Mashu',
	[k.VK_OEM_FJ_TOUROKU] = 'Touroku',
	[k.VK_OEM_FJ_LOYA] = 'Loya',
	[k.VK_OEM_FJ_ROYA] = 'Roya',
	[k.VK_LSHIFT] = 'Left Shift',
	[k.VK_RSHIFT] = 'Right Shift',
	[k.VK_LCONTROL] = 'Left Ctrl',
	[k.VK_RCONTROL] = 'Right Ctrl',
	[k.VK_LMENU] = 'Left Alt',
	[k.VK_RMENU] = 'Right Alt',
	[k.VK_BROWSER_BACK] = 'Browser Back',
	[k.VK_BROWSER_FORWARD] = 'Browser Forward',
	[k.VK_BROWSER_REFRESH] = 'Browser Refresh',
	[k.VK_BROWSER_STOP] = 'Browser Stop',
	[k.VK_BROWSER_SEARCH] = 'Browser Search',
	[k.VK_BROWSER_FAVORITES] = 'Browser Favorites',
	[k.VK_BROWSER_HOME] = 'Browser Home',
	[k.VK_VOLUME_MUTE] = 'Volume Mute',
	[k.VK_VOLUME_DOWN] = 'Volume Down',
	[k.VK_VOLUME_UP] = 'Volume Up',
	[k.VK_MEDIA_NEXT_TRACK] = 'Next Track',
	[k.VK_MEDIA_PREV_TRACK] = 'Previous Track',
	[k.VK_MEDIA_STOP] = 'Stop',
	[k.VK_MEDIA_PLAY_PAUSE] = 'Play / Pause',
	[k.VK_LAUNCH_MAIL] = 'Mail',
	[k.VK_LAUNCH_MEDIA_SELECT] = 'Media',
	[k.VK_LAUNCH_APP1] = 'App1',
	[k.VK_LAUNCH_APP2] = 'App2',
	[k.VK_OEM_1] = {';', ':'},
	[k.VK_OEM_PLUS] = {'=', '+'},
	[k.VK_OEM_COMMA] = {',', '<'},
	[k.VK_OEM_MINUS] = {'-', '_'},
	[k.VK_OEM_PERIOD] = {'.', '>'},
	[k.VK_OEM_2] = {'/', '?'},
	[k.VK_OEM_3] = {'`', '~'},
	[k.VK_ABNT_C1] = 'Abnt C1',
	[k.VK_ABNT_C2] = 'Abnt C2',
	[k.VK_OEM_4] = {'[', '{'},
	[k.VK_OEM_5] = {'\'', '|'},
	[k.VK_OEM_6] = {']', '}'},
	[k.VK_OEM_7] = {'\'', '"'},
	[k.VK_OEM_8] = {'!', '�'},
	[k.VK_OEM_AX] = 'Ax',
	[k.VK_OEM_102] = '> <',
	[k.VK_ICO_HELP] = 'IcoHlp',
	[k.VK_PROCESSKEY] = 'Process',
	[k.VK_ICO_CLEAR] = 'IcoClr',
	[k.VK_PACKET] = 'Packet',
	[k.VK_OEM_RESET] = 'Reset',
	[k.VK_OEM_JUMP] = 'Jump',
	[k.VK_OEM_PA1] = 'OemPa1',
	[k.VK_OEM_PA2] = 'OemPa2',
	[k.VK_OEM_PA3] = 'OemPa3',
	[k.VK_OEM_WSCTRL] = 'WsCtrl',
	[k.VK_OEM_CUSEL] = 'Cu Sel',
	[k.VK_OEM_ATTN] = 'Oem Attn',
	[k.VK_OEM_FINISH] = 'Finish',
	[k.VK_OEM_COPY] = 'Copy',
	[k.VK_OEM_AUTO] = 'Auto',
	[k.VK_OEM_ENLW] = 'Enlw',
	[k.VK_OEM_BACKTAB] = 'Back Tab',
	[k.VK_ATTN] = 'Attn',
	[k.VK_CRSEL] = 'Cr Sel',
	[k.VK_EXSEL] = 'Ex Sel',
	[k.VK_EREOF] = 'Er Eof',
	[k.VK_PLAY] = 'Play',
	[k.VK_ZOOM] = 'Zoom',
	[k.VK_PA1] = 'Pa1',
	[k.VK_OEM_CLEAR] = 'OemClr'
}

k.key_names = names

function k.id_to_name(vkey)
	local name = names[vkey]
	if type(name) == 'table' then
		return name[1]
	end
	return name
end

function k.name_to_id(keyname, case_sensitive)
	if not case_sensitive then
		keyname = string.upper(keyname)
	end
	for id, v in pairs(names) do
		if type(v) == 'table' then
			for _, v2 in pairs(v) do
				v2 = (case_sensitive) and v2 or string.upper(v2)
				if v2 == keyname then
					return id
				end
			end
		else
			local name = (case_sensitive) and v or string.upper(v)
			if name == keyname then
				return id
			end
		end
	end
end

return k
