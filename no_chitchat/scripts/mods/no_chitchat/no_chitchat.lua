local mod = get_mod("no_chitchat")

debug_override = false

mod_settings = {
    debug_enabled = false,
    debug_event = 0,

    mod_locale = 'en',

    hub_radio = false,
    hub_vox = false,
    hub_soldier = false,
    hub_conversation = false,

    hub_hallowette = true,
    hub_siremelk = true,
    hub_mv1 = true,
    hub_krall = true,
    hub_peddler = true,
    hub_hadron = true,
    hub_sefoni = true,

    mission_brief = false,
    mission_info = false,
    mission_conversation = false,
    mission_lore = false,

    enemy_demonhost = true,

    player_death = false,
    player_ability = false,
    player_kill = false,
    player_headshot = false,
    player_horde = false,
    player_tag_item = flase,
    player_tag_enemy = false,
    player_look = false,
    player_throw = false,
    player_wheel = true,

}

toggles = {

    hub_radio = { '.*hub.*idle.*conversation.*', '.*radio_static.*' },
    hub_vox = { ".*hub.*announcement.*", ".*vox_static.*" },
    hub_soldier = { ".*hub.*soldier.*", ".*soldier.*hub.*", ".*initiate.*greeting.*" },
    hub_conversation = { ".*hub.*rumors.*", },

    hub_hallowette = { ".*purser.*interact.*", ".*purser.*goodbye.*" },
    hub_siremelk = { ".*hub_interact_contract_vendor.*", "contract_vendor.*" },
    hub_mv1 = { ".*reject_npc.*" },
    hub_krall = { ".*barber_hello.*", ".*barber.*distance.*", "barber_goodbye.*" },
    hub_peddler = { ".*credit_store_servitor.*" },
    hub_hadron = { ".*hub_idle_crafting.*", ".*tech_priest.*" },
    hub_sefoni = { ".*training_ground_psyker.*hub_interact.*" },

    mission_brief = { "mission_.*_brief.*", "mission_.*_briefing.*", "mission_brief.*" },
    mission_info = {
        ".*mission_info.*",
        ".*survive_almost_done.*",
        ".*mission_armoury.*",
        ".*mission_station_first.*",
        ".*mission_station_station_approach.*",
        ".*mission_armoury_amphitheatre.*",
        ".*info_get_out.*",
        ".*info_event.*",
        ".*mission_cooling.*",
        ".*mission.*propaganda.*"
    },
    mission_conversation = {
        ".*start_banter.*",
        ".*generic_mission.*",
        '.*npc_vo.*',
        ".*zone_tank_foundry.*",
        ".*zone_transit.*",
        ".*region_hubculum.*",
        ".*region_mechanicus.*",
        ".*zone_throneside.*",
        ".*zone_watertown.*",
        ".*story_talk.*",
        ".*environmental_story.*",
        ".*conversation.*",
        ".*bonding_conversation.*",
        ".*combat_pause.*"
    },
    mission_lore = {
        ".*lore_the_warp.*",
        ".*lore_zola.*",
        ".*region_carnival.*",
        ".*lore_melk_one.*",
        ".*lore_era_indomitus.*",
        ".*lore_valkyrie.*",
        ".*lore_daemons.*",
        ".*lore_rannrick.*",
        ".*lore_brahms.*"
    },

    enemy_demonhost = { ".*demonhost_.*mantra.*" },

    player_death = { ".*player_death.*" },
    player_ability = { ".*ability.*" },
    player_kill = { ".*enemy_kill.*", ".*seen_killstreak.*" },
    player_headshot = { ".*head_shot.*", },
    player_horde = { ".*heard_horde.*", ".*heard_enemy.*" },
    player_tag_item = { ".*tag_item.*", ".*smart_tag_vo_pickup_ammo.*", ".*smart_tag.*default.*" },
    player_tag_enemy = { '.*tag_enemy.*', ".*player_enemy_alert.*", ".*on_demand_vo_tag_enemy.*", ".*smart_tag_vo_enemy.*", ".*smart_tag.*threat.*" },
    player_look = { ".*stairs_sighted.*", ".*look_at.*", 'seen_.*', '.*guidance.*' },
    player_throw = { ".*throwing_item.*", ".*throwing_grenade.*" },
    player_wheel = { ".*on_demand_com_wheel.*", ".*com_wheel_vo_location.*", ".*com_wheel_vo_enemy.*" },

}

function echoDebug(event_id, format, ...)
    if (mod_settings['debug_enabled'] and mod_settings['debug_event'] == event_id) or debug_override then
        mod:echo(format, ...);
    end
end

function isDisabled(rule)
    for key, patterns in pairs(toggles) do
        for index, value in ipairs(patterns) do
            if string.find(rule, value) then
                return not mod_settings[key]
            end
        end
    end
    return false
end

mod.on_setting_changed = function(id)
    mod_settings[id] = mod:get(id)
end

mod.on_enabled = function()
    for key, value in pairs(mod_settings) do
        mod_settings[key] = mod:get(key)
    end
end

unhooked = {
    _play_tag_sound = true,
    play_event = true,
    play_local_vo_event = true,
    _play_mission_brief_vo = true,
    _play_dialogue_event_implementation = true,
    _update_currently_playing_dialogues = true,
}

mod:hook_require("scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging", function(instance)

    if unhooked._play_tag_sound then
        unhooked._play_tag_sound = false
        mod:hook_origin(instance, "_play_tag_sound", function(self, tag_instance, event_name)
            local target_location = tag_instance:target_location()

            if isDisabled(event_name) then
                return
            else
                echoDebug(5, "[_play_tag_sound] %s", event_name)
            end

            if target_location then
                self:_play_3d_sound(event_name, target_location)
            else
                local target_unit = tag_instance:target_unit()

                if ALIVE[target_unit] then
                    local unit_position = Unit.world_position(target_unit, 1)

                    self:_play_3d_sound(event_name, unit_position)
                else
                    self:_play_sound(event_name)
                end
            end
        end)
    end

end)

mod:hook_require("scripts/extension_systems/dialogue/dialogue_extension", function(instance)

    if (unhooked.play_event) then
        unhooked.play_event = false

        mod:hook_origin(instance, "play_event", function(self, event)
            local type = event.type

            if not isDisabled(event.sound_event) then
                echoDebug(0, "[play_event]: %s (%s)", event.sound_event, type)
            end

            if type == "resource_event" then
                local sound_event = event.sound_event
                local wwise_source_id = self._wwise_source_id or self._dialogue_system_wwise:make_unit_auto_source(self._play_unit, self._voice_node)

                WwiseWorld.set_switch(self._wwise_world, self._wwise_voice_switch_group, self._wwise_voice_switch_value, self._wwise_source_id)

                return self._dialogue_system_wwise:trigger_resource_event("wwise/events/vo/" .. sound_event, wwise_source_id)
            elseif type == "vorbis_external" then
                local wwise_route = event.wwise_route
                local sound_event = event.sound_event
                local wwise_source_id = self._wwise_source_id or self._dialogue_system_wwise:make_unit_auto_source(self._play_unit, self._voice_node)
                local selected_wwise_route = self:get_selected_wwise_route(wwise_route, wwise_source_id)
                local wwise_play_event = selected_wwise_route.wwise_event_path
                local wwise_es = selected_wwise_route.wwise_sound_source

                self:stop_currently_playing_vce_event()
                self:_set_source_parameter("voice_fx_preset", self._voice_fx_preset, wwise_source_id)

                return self._dialogue_system_wwise:trigger_vorbis_external_event(wwise_play_event, wwise_es, "wwise/externals/" .. sound_event, wwise_source_id)
            end
        end)
    end

    if (unhooked.play_local_vo_event) then
        unhooked.play_local_vo_event = false

        local DialogueCategoryConfig = require("scripts/settings/dialogue/dialogue_category_config")
        local DialogueQueries = require("scripts/extension_systems/dialogue/dialogue_queries")
        local WwiseRouting = require("scripts/settings/dialogue/wwise_vo_routing_settings")

        mod:hook_origin(instance, "play_local_vo_event", function(self, rule_name, wwise_route_key, on_play_callback, seed)
            local dialogue_system = self._dialogue_system
            local rule = self._vo_choice[rule_name]

            if not rule then
                return
            end

            local dialogue_index = nil

            if seed then
                local _, random_n = math.next_random(seed, 1, rule.sound_events_n)
                dialogue_index = random_n
            else
                dialogue_index = DialogueQueries.get_dialogue_event_index(rule)
            end

            local sound_event, subtitles_event, sound_event_duration = self:get_dialogue_event(rule_name, dialogue_index)
            local currently_playing_dialogue = self:get_currently_playing_dialogue()
            local wwise_playing = currently_playing_dialogue and self._dialogue_system_wwise:is_playing(currently_playing_dialogue.currently_playing_event_id)

            if sound_event and not wwise_playing then
                local pre_wwise_event, post_wwise_event = nil
                local dialogue = {}
                local wwise_route = WwiseRouting[wwise_route_key]

                dialogue_system._dialog_sequence_events = dialogue_system:_create_sequence_events_table(pre_wwise_event, wwise_route, sound_event, post_wwise_event)

                if #dialogue_system._dialog_sequence_events > 0 then
                    local trigger = dialogue_system._dialog_sequence_events[1].sound_event

                    if isDisabled(trigger) then
                        return
                    else
                        echoDebug(1, "[play_local_vo_event] %s", trigger)
                    end
                end

                self:set_last_query_sound_event(sound_event)

                dialogue.currently_playing_event_id = self:play_event(dialogue_system._dialog_sequence_events[1])
                local speaker_name = self:get_context().voice_template
                local unit = self._unit
                dialogue_system._playing_units[unit] = self
                dialogue.currently_playing_unit = unit
                dialogue.speaker_name = speaker_name
                dialogue.dialogue_timer = sound_event_duration
                dialogue.currently_playing_subtitle = subtitles_event
                dialogue.wwise_route = wwise_route_key
                dialogue.is_audible = true
                local dialogue_category = dialogue.category
                local category_setting = DialogueCategoryConfig[dialogue_category]
                dialogue_system._playing_dialogues[dialogue] = category_setting

                self:set_currently_playing_dialogue(dialogue)
                table.insert(dialogue_system._playing_dialogues_array, 1, dialogue)

                local animation_event = "start_talking"

                dialogue_system:_trigger_face_animation_event(unit, animation_event)

                local dialogue_system_subtitle = dialogue_system:dialogue_system_subtitle()

                dialogue_system_subtitle:add_playing_localized_dialogue(speaker_name, dialogue)

                if on_play_callback then
                    local id = dialogue.currently_playing_event_id

                    on_play_callback(id, rule_name)
                end
            end
        end)
    end

end)

mod:hook_require("scripts/ui/views/mission_intro_view/mission_intro_view", function(instance)

    if (unhooked._play_mission_brief_vo) then
        unhooked._play_mission_brief_vo = false

        local Vo = require("scripts/utilities/vo")
        local Missions = require("scripts/settings/mission/mission_templates")

        mod:hook_origin(instance, "_play_mission_brief_vo", function(self, mission_name, mission_giver_vo)
            local mission = Missions[mission_name]
            local mission_intro_time = mission.mission_intro_minimum_time or 0
            self.done_at = Managers.time:time("main") + mission_intro_time
            local mission_brief_vo = mission.mission_brief_vo

            if not mission_brief_vo then
                self.mission_briefing_done = true
                return
            end

            local events = mission_brief_vo.vo_events
            local voice_profile = nil

            if isDisabled(events[1]) then
                self.mission_briefing_done = true
                return
            else
                for i, v in ipairs(events) do
                    echoDebug(4, "_play_mission_brief_vo: %s", v)
                end
            end

            if mission_giver_vo == "none" then
                voice_profile = mission_brief_vo.vo_profile
            else
                voice_profile = mission_giver_vo
            end

            local wwise_route_key = mission_brief_vo.wwise_route_key
            local dialogue_system = self:dialogue_system()
            local callback = callback(self, "_cb_on_play_mission_brief_vo")
            local seed = nil

            if Managers.connection then
                seed = Managers.connection:session_seed()
            end

            local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback, seed)
            self._vo_unit = vo_unit
            self._last_vo_event = events[#events]
        end)
    end

end)

mod:hook_require("scripts/extension_systems/dialogue/dialogue_system", function(instance)

    if (unhooked._play_dialogue_event_implementation) then
        unhooked._play_dialogue_event_implementation = false

        local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
        local DialogueCategoryConfig = require("scripts/settings/dialogue/dialogue_category_config")

        mod:hook_origin(instance, "_play_dialogue_event_implementation", function(self, go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, dialogue_rule_index)
            local dialogue_actor_unit = Managers.state.unit_spawner:unit(go_id, is_level_unit, level_name_hash)

            if not dialogue_actor_unit then
                return
            end

            local dialogue_name = NetworkLookup.dialogues[dialogue_id]
            local dialogue = self._dialogues[dialogue_name]

            if not self:_is_playable_dialogue_category(dialogue) then
                return
            end

            if self:_prevent_on_demand_vo(dialogue_actor_unit, dialogue) then
                return
            end

            local extension = self._unit_extension_data[dialogue_actor_unit]

            if not extension then
                return
            end

            local is_a_player = extension:is_a_player()

            if is_a_player and not HEALTH_ALIVE[dialogue_actor_unit] then
                return
            end

            local playing_dialogue_to_discard = extension:get_currently_playing_dialogue()

            if playing_dialogue_to_discard then
                local animation_event = "stop_talking"

                self:_trigger_face_animation_event(dialogue_actor_unit, animation_event)
                extension:stop_currently_playing_wwise_event(playing_dialogue_to_discard.concurrent_wwise_event_id)
                self._dialogue_system_wwise:stop_if_playing(playing_dialogue_to_discard.currently_playing_event_id)
                extension:set_currently_playing_dialogue(nil)
                self:_remove_stopped_dialogue(playing_dialogue_to_discard)

                self._playing_units[dialogue_actor_unit] = nil
            end

            local sound_event, subtitles_event, sound_event_duration = extension:get_dialogue_event(dialogue_name, dialogue_index)
            local rule = self._tagquery_database:get_rule(dialogue_rule_index)
            local is_sequence = nil

            if sound_event then
                extension:set_last_query_sound_event(sound_event)
            end

            local speaker_name = extension:get_context().voice_template
            dialogue.speaker_name = speaker_name

            if speaker_name == "tech_priest_a" and dialogue.wwise_route == 1 then
                dialogue.wwise_route = 21
            end

            if not DEDICATED_SERVER then
                local wwise_route = self._wwise_route_default

                if dialogue.wwise_route ~= nil then
                    wwise_route = self._wwise_routes[dialogue.wwise_route]
                end

                if sound_event then

                    if rule and (rule.pre_wwise_event or rule.post_wwise_event) then

                        dialogue.dialogue_sequence = self:_create_sequence_events_table(rule.pre_wwise_event, wwise_route, sound_event, rule.post_wwise_event)

                        if #dialogue.dialogue_sequence > 0 then
                            local trigger = dialogue.dialogue_sequence[1].sound_event

                            if isDisabled(trigger) then
                                return
                            else
                                echoDebug(2, "[_play_dialogue_event_implementation] %s", trigger)
                            end
                        end

                        dialogue.currently_playing_event_id = extension:play_event(dialogue.dialogue_sequence[1])
                        is_sequence = true
                    else
                        local vo_event = {
                            type = "vorbis_external",
                            sound_event = sound_event,
                            wwise_route = wwise_route
                        }

                        local trigger = vo_event.sound_event

                        if isDisabled(trigger) then
                            return
                        else
                            echoDebug(2, "[_play_dialogue_event_implementation] %s", trigger)
                        end

                        dialogue.currently_playing_event_id = extension:play_event(vo_event)
                        is_sequence = false
                    end

                    local concurrent_wwise_event = rule and rule.concurrent_wwise_event

                    if concurrent_wwise_event then
                        dialogue.concurrent_wwise_event_id = self:play_wwise_event(extension, concurrent_wwise_event)
                    end

                    local class_name = extension._context.class_name
                    local breed_dialogue_setting = DialogueBreedSettings[class_name]

                    if breed_dialogue_setting then
                        local subtitle_distance = breed_dialogue_setting.subtitle_distance

                        if subtitle_distance then
                            dialogue.subtitle_distance = subtitle_distance
                            dialogue.is_audible = self:is_dialogue_audible(dialogue_actor_unit, dialogue)
                        else
                            dialogue.is_audible = true
                        end
                    else
                        dialogue.is_audible = true
                    end
                end

                local animation_event = "start_talking"

                self:_trigger_face_animation_event(dialogue_actor_unit, animation_event)
            end

            self._playing_units[dialogue_actor_unit] = extension
            dialogue.currently_playing_unit = dialogue_actor_unit
            dialogue.dialogue_timer = sound_event_duration
            dialogue.currently_playing_subtitle = subtitles_event

            extension:set_currently_playing_dialogue(dialogue)

            local dialogue_category = dialogue.category
            local category_setting = DialogueCategoryConfig[dialogue_category]
            self._playing_dialogues[dialogue] = category_setting

            table.insert(self._playing_dialogues_array, 1, dialogue)

            local sequence_table = dialogue.dialogue_sequence

            if sequence_table ~= nil and sequence_table[1].type == "vorbis_external" or not is_sequence then
                self._dialogue_system_subtitle:add_playing_localized_dialogue(speaker_name, dialogue)
            end

            if rule then
                dialogue.wwise_route = rule.wwise_route
            end
        end)
    end

    if (unhooked._update_currently_playing_dialogues) then
        unhooked._update_currently_playing_dialogues = false

        local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")

        mod:hook_origin(instance, "_update_currently_playing_dialogues", function(self, t, dt)
            local ALIVE = ALIVE

            for unit, extension in pairs(self._playing_units) do
                repeat
                    if not ALIVE[unit] then
                        self._playing_units[unit] = nil
                    else
                        local currently_playing_dialogue = extension:get_currently_playing_dialogue()
                        local is_currently_playing = nil

                        if currently_playing_dialogue.dialogue_timer then
                            is_currently_playing = currently_playing_dialogue.dialogue_timer - dt > 0
                        end

                        if not is_currently_playing then
                            local animation_event = "stop_talking"

                            self:_trigger_face_animation_event(unit, animation_event)
                            extension:stop_currently_playing_wwise_event(currently_playing_dialogue.concurrent_wwise_event_id)
                            self._dialogue_system_wwise:stop_if_playing(currently_playing_dialogue.currently_playing_event_id)

                            local used_query = currently_playing_dialogue.used_query

                            extension:set_currently_playing_dialogue(nil)
                            self:_remove_stopped_dialogue(currently_playing_dialogue)

                            self._playing_units[unit] = nil

                            if not self._is_server then
                                break
                            end

                            extension:set_dialogue_timer(nil)

                            local result = used_query ~= nil and used_query.result

                            if result then
                                local source = used_query.query_context.source
                                local success_rule = used_query.validated_rule
                                local on_done = success_rule.on_done

                                if on_done then
                                    local user_contexts = self._unit_extension_data[source]

                                    for i = 1, #on_done do
                                        local on_done_command = on_done[i]
                                        local table_name = on_done_command[1]
                                        local argument_name = on_done_command[2]
                                        local op = on_done_command[3]
                                        local argument = on_done_command[4]

                                        if type(op) == "table" then
                                            local new_value = _function_by_op[op](user_contexts:read_from_memory(table_name, argument_name), argument)

                                            user_contexts:store_in_memory(table_name, argument_name, new_value)
                                        else
                                            user_contexts:store_in_memory(table_name, argument_name, op)
                                        end
                                    end
                                end

                                if success_rule.on_post_rule_execution and success_rule.on_post_rule_execution.reject_events then
                                    local reject_events_command = success_rule.on_post_rule_execution.reject_events
                                    self._reject_queries_until = t + reject_events_command.duration
                                end

                                local speaker_name = "UNKNOWN"
                                local breed_data = Unit.get_data(source, "breed")

                                if breed_data and not breed_data.is_player then
                                    speaker_name = breed_data.name
                                elseif ScriptUnit.has_extension(source, "dialogue_system") then
                                    speaker_name = extension:vo_class_name()
                                end

                                local temp_event_data = {
                                    dialogue_name = result,
                                    speaker_class = speaker_name,
                                    sound_event = extension:get_last_query_sound_event(),
                                    voice_profile = extension:get_voice_profile()
                                }

                                if success_rule.heard_speak_routing ~= nil then
                                    local heard_speak_target = success_rule.heard_speak_routing.target

                                    if heard_speak_target ~= "disabled" then
                                        if heard_speak_target == "players" then
                                            self:append_faction_event(unit, "heard_speak", temp_event_data, nil, "imperium", true)
                                        elseif heard_speak_target == "all" then
                                            for registered_unit, registered_extension in pairs(self._unit_extension_data) do
                                                repeat
                                                    if registered_unit == unit then
                                                        break
                                                    end

                                                    if registered_extension:is_dialogue_disabled() then
                                                        break
                                                    end

                                                    self:append_event_to_queue(registered_unit, "heard_speak", temp_event_data, nil)
                                                until true
                                            end
                                        elseif heard_speak_target == "self" then
                                            self:append_self_event(unit, "heard_speak", temp_event_data, nil)
                                        elseif heard_speak_target == "mission_giver_default" then
                                            local voice_over_spawn_manager = Managers.state.voice_over_spawn
                                            local default_mission_giver_voice_profile = voice_over_spawn_manager:current_voice_profile()
                                            local default_mission_giver_unit = voice_over_spawn_manager:voice_over_unit(default_mission_giver_voice_profile)

                                            self:append_targeted_source_event(default_mission_giver_unit, "heard_speak", temp_event_data, nil)
                                        elseif heard_speak_target == "mission_giver_default_class" then
                                            local voice_over_spawn_manager = Managers.state.voice_over_spawn
                                            local default_mission_giver_voice_profile = voice_over_spawn_manager:current_voice_profile()
                                            local default_mission_giver_unit = voice_over_spawn_manager:voice_over_unit(default_mission_giver_voice_profile)
                                            local default_mission_giver_dialogue_extension = ScriptUnit.has_extension(default_mission_giver_unit, "dialogue_system")
                                            local default_mission_giver_class = default_mission_giver_dialogue_extension._context.class_name
                                            local breed_setting = DialogueBreedSettings[default_mission_giver_class]
                                            local voices = breed_setting.wwise_voices

                                            for _, voice in pairs(voices) do
                                                local mission_giver_unit = voice_over_spawn_manager:voice_over_unit(voice)

                                                if mission_giver_unit and mission_giver_unit ~= unit then
                                                    self:append_targeted_source_event(mission_giver_unit, "heard_speak", temp_event_data, nil)
                                                end
                                            end
                                        elseif heard_speak_target == "mission_givers" then
                                            local voice_over_spawn_manager = Managers.state.voice_over_spawn
                                            local mission_giver_breed_settings = DialogueBreedSettings.mission_giver
                                            local mission_giver_voices = mission_giver_breed_settings.wwise_voices

                                            for _, voice in pairs(mission_giver_voices) do
                                                local mission_giver_unit = voice_over_spawn_manager:voice_over_unit(voice)

                                                if mission_giver_unit and mission_giver_unit ~= unit then
                                                    self:append_targeted_source_event(mission_giver_unit, "heard_speak", temp_event_data, nil)
                                                end
                                            end
                                        elseif heard_speak_target == "level_event" then
                                            local level = Managers.state.mission:mission_level()

                                            if level then
                                                Level.trigger_event(level, success_rule.name)
                                            end
                                        else
                                            Log.warning("DialogueSystem", "heard_speak_routing.target %s is wrong or unrecognized", heard_speak_target)
                                        end
                                    end
                                else
                                    local legacy_v2_proximity_system = self._extension_manager:system("legacy_v2_proximity_system")

                                    legacy_v2_proximity_system:add_distance_based_vo_query(unit, "heard_speak", temp_event_data)
                                end

                                extension:set_last_query_sound_event(nil)
                            end
                        elseif currently_playing_dialogue.dialogue_timer then
                            if not DEDICATED_SERVER then
                                local playing = self._dialogue_system_wwise:is_playing(currently_playing_dialogue.currently_playing_event_id)

                                if not playing then
                                    local sequence_table = currently_playing_dialogue.dialogue_sequence

                                    if sequence_table then
                                        table.remove(sequence_table, 1)

                                        if sequence_table[1] ~= nil and sequence_table[1].type == "vorbis_external" then
                                            self._dialogue_system_subtitle:add_playing_localized_dialogue(currently_playing_dialogue.speaker_name, currently_playing_dialogue)
                                        end

                                        if table.size(sequence_table) > 0 then

                                            local trigger = sequence_table[1].sound_event

                                            if isDisabled(trigger) then
                                                return
                                            else
                                                echoDebug(3, "[_update_currently_playing_dialogues]: %s", trigger)
                                            end

                                            currently_playing_dialogue.currently_playing_event_id = extension:play_event(sequence_table[1])
                                        end
                                    end
                                end

                                if currently_playing_dialogue.subtitle_distance then
                                    currently_playing_dialogue.is_audible = self:is_dialogue_audible(unit, currently_playing_dialogue, t)
                                end
                            end

                            currently_playing_dialogue.dialogue_timer = currently_playing_dialogue.dialogue_timer - dt
                        end
                    end
                until true
            end
        end)
    end

    _function_by_op = {
        [TagQuery.OP.ADD] = function(lhs, rhs)
            return (lhs or 0) + rhs
        end,
        [TagQuery.OP.SUB] = function(lhs, rhs)
            return (lhs or 0) - rhs
        end,
        [TagQuery.OP.NUMSET] = function(lhs, rhs)
            return rhs or 0
        end,
        [TagQuery.OP.TIMESET] = function()
            return Managers.time:time("gameplay") + 900
        end
    }

end)

--]]