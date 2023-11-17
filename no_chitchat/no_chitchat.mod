return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`no_chitchat` encountered an error loading the Darktide Mod Framework.")

		new_mod("no_chitchat", {
			mod_script       = "no_chitchat/scripts/mods/no_chitchat/no_chitchat",
			mod_data         = "no_chitchat/scripts/mods/no_chitchat/no_chitchat_data",
			mod_localization = "no_chitchat/scripts/mods/no_chitchat/no_chitchat_localization",
		})
	end,
	packages = {},
}
