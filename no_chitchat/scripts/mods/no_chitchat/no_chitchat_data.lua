local mod = get_mod("no_chitchat")

return {
    name = "No ChitChat",
    description = mod:localize("mod_description"),
    is_togglable = true,
    allow_rehooking = true,
    version = "0.3.0",
    options = {
        widgets = {
            {
                setting_id = "hub_toggles",
                tooltip = "hub_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    { setting_id = "hub_radio", type = "checkbox", default_value = true, },
                    { setting_id = "hub_vox", type = "checkbox", default_value = true, },
                    { setting_id = "hub_soldier", type = "checkbox", default_value = true, },
                    { setting_id = "hub_conversation", type = "checkbox", default_value = true, },
                    { setting_id = "hub_hallowette", type = "checkbox", default_value = true, },
                    { setting_id = "hub_siremelk", type = "checkbox", default_value = true, },
                    { setting_id = "hub_mv1", type = "checkbox", default_value = true, },
                    { setting_id = "hub_krall", type = "checkbox", default_value = true, },
                    { setting_id = "hub_peddler", type = "checkbox", default_value = true, },
                    { setting_id = "hub_hadron", type = "checkbox", default_value = true, },
                    { setting_id = "hub_sefoni", type = "checkbox", default_value = true, },
                }
            },
            {
                setting_id = "mission_toggles",
                tooltip = "mission_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    { setting_id = "mission_brief", type = "checkbox", default_value = false, },
                    { setting_id = "mission_info", type = "checkbox", default_value = false, },
                    { setting_id = "mission_conversation", type = "checkbox", default_value = false, },
                    { setting_id = "mission_lore", type = "checkbox", default_value = false, },
                }
            },
            {
                setting_id = "enemy_toggles",
                tooltip = "enemy_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    { setting_id = "enemy_demonhost", type = "checkbox", default_value = true, },
                    { setting_id = "enemy_flamer", type = "checkbox", default_value = true, },
                    { setting_id = "enemy_grenadier", type = "checkbox", default_value = true, },
                    { setting_id = "enemy_gunner", type = "checkbox", default_value = true, },
                    { setting_id = "enemy_berzerker", type = "checkbox", default_value = true, },
                    { setting_id = "enemy_netgunner", type = "checkbox", default_value = true, },
                }
            },
            {
                setting_id = "player_toggles",
                tooltip = "player_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    { setting_id = "player_death", type = "checkbox", default_value = false, },
                    { setting_id = "player_ability", type = "checkbox", default_value = false, },
                    { setting_id = "player_kill", type = "checkbox", default_value = false, },
                    { setting_id = "player_headshot", type = "checkbox", default_value = false, },
                    { setting_id = "player_horde", type = "checkbox", default_value = false, },
                    { setting_id = "player_tag_item", type = "checkbox", default_value = false, },
                    { setting_id = "player_tag_enemy", type = "checkbox", default_value = false, },
                    { setting_id = "player_look", type = "checkbox", default_value = false, },
                    { setting_id = "player_throw", type = "checkbox", default_value = false, },
                    { setting_id = "player_wheel", type = "checkbox", default_value = false, },
                }
            },
            {
                setting_id = "team_toggles",
                tooltip = "team_toggles_tooltip",
                type = "group",
                sub_widgets = {
                    { setting_id = "team_advice", type = "checkbox", default_value = true, },
                    { setting_id = "team_help", type = "checkbox", default_value = true, },
                    { setting_id = "team_warning", type = "checkbox", default_value = true, },
                    { setting_id = "team_hacking", type = "checkbox", default_value = true, },
                    { setting_id = "team_revive", type = "checkbox", default_value = true, },
                    { setting_id = "team_downed", type = "checkbox", default_value = true, },
                    { setting_id = "team_monster", type = "checkbox", default_value = true, },
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
                            { text = "event_play_tag_sound", value = 5 },
                        },
                    },
                }
            },
        }
    }
}
