local mod = get_mod("no_chitchat")

return {
    name = "No ChitChat",
    description = mod:localize("mod_description"),
    is_togglable = true,
    version = "0.1.0",
    options = {
        widgets = {

            {
                setting_id = "hub_toggles",
                tooltip = "hub_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "hub_conversation",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "hub_announcement",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "hub_soldier",
                        type = "checkbox",
                        default_value = false,
                    },
                }
            },

            {
                setting_id = "vendor_toggles",
                tooltip = "vendor_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "vendor_hallowette_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "vendor_siremelk_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "vendor_peddler_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "vendor_mv1_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "vendor_krall_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                    {
                        setting_id = "vendor_hadron_toggle",
                        type = "checkbox",
                        default_value = true,
                    },
                }
            },

            {
                setting_id = "mission_toggles",
                tooltip = "mission_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "mission_banter",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "mission_briefing",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "mission_info",
                        type = "checkbox",
                        tooltip = 'mission_info_tooltip',
                        default_value = false,
                    },
                }
            },

            {
                setting_id = "callout_toggles",
                tooltip = "callout_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    {
                        setting_id = "callout_kill",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "callout_horde",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "callout_story",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "callout_look",
                        tooltip = "callout_look_tooltip",
                        type = "checkbox",
                        default_value = false,
                    },
                    {
                        setting_id = "callout_throw",
                        type = "checkbox",
                        default_value = false,
                    },
                }
            },

            {
                setting_id = "debug_enabled",
                tooltip = "debug_enabled_tooltip",
                type = "checkbox",
                default_value = false,
                sub_widgets = {
                    {
                        setting_id = "debug_event",
                        type = "dropdown",
                        default_value = 0,
                        options = {
                            { text = "event_play_event", value = 0 },
                            { text = "event_play_local_vo_event", value = 1 },
                            { text = "event_play_dialogue_event_implementation", value = 2 },
                            { text = "event_update_currently_playing_dialogues", value = 3 },
                            { text = "event_play_mission_brief_vo", value = 4 },
                        },
                    },
                }
            },

        }
    }
}
