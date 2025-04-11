-- Copyright (c) 2025, Nathan Dunsworth
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of {{ project }} nor the names of its contributors
--       may be used to endorse or promote products derived from this software
--       without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local _, OpenPvp = ...
local opvp = OpenPvp;

opvp.event = {};

---~ Area POI events
opvp.event.AREA_POIS_UPDATED                   = opvp.EventRegistrySignal("AREA_POIS_UPDATED");

--~ Console events
opvp.event.CONSOLE_COLORS_CHANGED              = opvp.EventRegistrySignal("CONSOLE_COLORS_CHANGED");
opvp.event.CONSOLE_FONT_SIZE_CHANGED           = opvp.EventRegistrySignal("CONSOLE_FONT_SIZE_CHANGED");
opvp.event.CONSOLE_LOG                         = opvp.EventRegistrySignal("CONSOLE_LOG");
opvp.event.CONSOLE_MESSAGE                     = opvp.EventRegistrySignal("CONSOLE_MESSAGE");
opvp.event.CVAR_UPDATE                         = opvp.EventRegistrySignal("CVAR_UPDATE");
opvp.event.GLUE_CONSOLE_LOG                    = opvp.EventRegistrySignal("GLUE_CONSOLE_LOG");
opvp.event.TOGGLE_CONSOLE                      = opvp.EventRegistrySignal("TOGGLE_CONSOLE");
opvp.event.VARIABLES_LOADED                    = opvp.EventRegistrySignal("VARIABLES_LOADED");

--~ Combat log events
opvp.event.COMBAT_LOG_EVENT_UNFILTERED         = opvp.EventRegistrySignal("COMBAT_LOG_EVENT_UNFILTERED");

--~ Chat events
opvp.event.CHAT_DISABLED_CHANGED               = opvp.EventRegistrySignal("CHAT_DISABLED_CHANGED");
opvp.event.CHAT_DISABLED_CHANGE_FAILED         = opvp.EventRegistrySignal("CHAT_DISABLED_CHANGE_FAILED");
opvp.event.CHAT_MSG_ADDON                      = opvp.EventRegistrySignal("CHAT_MSG_ADDON");
opvp.event.CHAT_MSG_EMOTE                      = opvp.EventRegistrySignal("CHAT_MSG_EMOTE");
opvp.event.CHAT_MSG_GUILD                      = opvp.EventRegistrySignal("CHAT_MSG_GUILD");
opvp.event.CHAT_MSG_PARTY                      = opvp.EventRegistrySignal("CHAT_MSG_PARTY");
opvp.event.CHAT_MSG_RAID                       = opvp.EventRegistrySignal("CHAT_MSG_RAID");
opvp.event.CHAT_MSG_PING                       = opvp.EventRegistrySignal("CHAT_MSG_PING");
opvp.event.CHAT_MSG_SAY                        = opvp.EventRegistrySignal("CHAT_MSG_SAY");
opvp.event.CHAT_MSG_SYSTEM                     = opvp.EventRegistrySignal("CHAT_MSG_SYSTEM");
opvp.event.CHAT_MSG_TEXT_EMOTE                 = opvp.EventRegistrySignal("CHAT_MSG_TEXT_EMOTE");
opvp.event.CHAT_MSG_WHISPER                    = opvp.EventRegistrySignal("CHAT_MSG_WHISPER");
opvp.event.CHAT_MSG_YELL                       = opvp.EventRegistrySignal("CHAT_MSG_YELL");

--~ Currency events
opvp.event.CURRENCY_DISPLAY_UPDATE             = opvp.EventRegistrySignal("CURRENCY_DISPLAY_UPDATE");

--~ Group events
opvp.event.GROUP_FORMED                        = opvp.EventRegistrySignal("GROUP_FORMED");
opvp.event.GROUP_JOINED                        = opvp.EventRegistrySignal("GROUP_JOINED");
opvp.event.GROUP_LEFT                          = opvp.EventRegistrySignal("GROUP_LEFT");
opvp.event.GROUP_ROSTER_UPDATE                 = opvp.EventRegistrySignal("GROUP_ROSTER_UPDATE");
opvp.event.INSTANCE_BOOT_START                 = opvp.EventRegistrySignal("INSTANCE_BOOT_START");
opvp.event.INSTANCE_BOOT_STOP                  = opvp.EventRegistrySignal("INSTANCE_BOOT_STOP");
opvp.event.INSTANCE_GROUP_SIZE_CHANGED         = opvp.EventRegistrySignal("INSTANCE_GROUP_SIZE_CHANGED");
opvp.event.INVITE_TO_PARTY_CONFIRMATION        = opvp.EventRegistrySignal("INVITE_TO_PARTY_CONFIRMATION");
opvp.event.PARTY_INVITE_CANCEL                 = opvp.EventRegistrySignal("PARTY_INVITE_CANCEL");
opvp.event.PARTY_INVITE_REQUEST                = opvp.EventRegistrySignal("PARTY_INVITE_REQUEST");
opvp.event.PARTY_LEADER_CHANGED                = opvp.EventRegistrySignal("PARTY_LEADER_CHANGED");
opvp.event.PARTY_LOOT_METHOD_CHANGED           = opvp.EventRegistrySignal("PARTY_LOOT_METHOD_CHANGED");
opvp.event.PARTY_MEMBER_DISABLE                = opvp.EventRegistrySignal("PARTY_MEMBER_DISABLE");
opvp.event.PARTY_MEMBER_ENABLE                 = opvp.EventRegistrySignal("PARTY_MEMBER_ENABLE");
opvp.event.PLAYER_DIFFICULTY_CHANGED           = opvp.EventRegistrySignal("PLAYER_DIFFICULTY_CHANGED");
opvp.event.PLAYER_ROLES_ASSIGNED               = opvp.EventRegistrySignal("PLAYER_ROLES_ASSIGNED");
opvp.event.READY_CHECK                         = opvp.EventRegistrySignal("READY_CHECK");
opvp.event.READY_CHECK_CONFIRM                 = opvp.EventRegistrySignal("READY_CHECK_CONFIRM");
opvp.event.READY_CHECK_FINISHED                = opvp.EventRegistrySignal("READY_CHECK_FINISHED");
opvp.event.ROLE_CHANGED_INFORM                 = opvp.EventRegistrySignal("ROLE_CHANGED_INFORM");
opvp.event.CANCEL_PLAYER_COUNTDOWN             = opvp.EventRegistrySignal("CANCEL_PLAYER_COUNTDOWN");
opvp.event.START_PLAYER_COUNTDOWN              = opvp.EventRegistrySignal("START_PLAYER_COUNTDOWN");

--~ Layout events
opvp.event.EDIT_MODE_LAYOUTS_UPDATED           = opvp.EventRegistrySignal("EDIT_MODE_LAYOUTS_UPDATED");
opvp.event.EDITMODE_ENTER                      = opvp.EventRegistrySignal("EditMode.Enter");
opvp.event.EDITMODE_LAYOUTS_SAVED              = opvp.EventRegistrySignal("EditMode.SavedLayouts");
opvp.event.EDITMODE_EXIT                       = opvp.EventRegistrySignal("EditMode.Exit");

--~ LFG events
opvp.event.LFG_QUEUE_STATUS_UPDATE             = opvp.EventRegistrySignal("LFG_QUEUE_STATUS_UPDATE");
opvp.event.LFG_UPDATE                          = opvp.EventRegistrySignal("LFG_UPDATE");

--~ Login events
opvp.event.ADDON_LOADED                        = opvp.EventRegistrySignal("ADDON_LOADED");
opvp.event.ADDONS_UNLOADING                    = opvp.EventRegistrySignal("ADDONS_UNLOADING");
opvp.event.LOGOUT_CANCEL                       = opvp.EventRegistrySignal("LOGOUT_CANCEL");
opvp.event.PLAYER_LOGIN                        = opvp.EventRegistrySignal("PLAYER_LOGIN");
opvp.event.PLAYER_LOGOUT                       = opvp.EventRegistrySignal("PLAYER_LOGOUT");
opvp.event.PLAYER_QUITING                      = opvp.EventRegistrySignal("PLAYER_QUITING");

--~ Nameplate events
opvp.event.FORBIDDEN_NAME_PLATE_CREATED        = opvp.EventRegistrySignal("FORBIDDEN_NAME_PLATE_CREATED");
opvp.event.FORBIDDEN_NAME_PLATE_UNIT_ADDED     = opvp.EventRegistrySignal("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
opvp.event.FORBIDDEN_NAME_PLATE_UNIT_REMOVED   = opvp.EventRegistrySignal("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");
opvp.event.NAME_PLATE_CREATED                  = opvp.EventRegistrySignal("NAME_PLATE_CREATED");
opvp.event.NAME_PLATE_UNIT_ADDED               = opvp.EventRegistrySignal("NAME_PLATE_UNIT_ADDED");
opvp.event.NAME_PLATE_UNIT_REMOVED             = opvp.EventRegistrySignal("NAME_PLATE_UNIT_REMOVED");

--~ Player events
opvp.event.BARBER_SHOP_APPEARANCE_APPLIED      = opvp.EventRegistrySignal("BARBER_SHOP_APPEARANCE_APPLIED");
opvp.event.PLAYER_ALIVE                        = opvp.EventRegistrySignal("PLAYER_ALIVE");
opvp.event.PLAYER_CAMPING                      = opvp.EventRegistrySignal("PLAYER_CAMPING");
opvp.event.PLAYER_CONTROL_GAINED               = opvp.EventRegistrySignal("PLAYER_CONTROL_GAINED");
opvp.event.PLAYER_CONTROL_LOST                 = opvp.EventRegistrySignal("PLAYER_CONTROL_LOST");
opvp.event.PLAYER_DEAD                         = opvp.EventRegistrySignal("PLAYER_DEAD");
opvp.event.PLAYER_EQUIPMENT_CHANGED            = opvp.EventRegistrySignal("PLAYER_EQUIPMENT_CHANGED");
opvp.event.PLAYER_FLAGS_CHANGED                = opvp.EventRegistrySignal("PLAYER_FLAGS_CHANGED");
opvp.event.PLAYER_FOCUS_CHANGED                = opvp.EventRegistrySignal("PLAYER_FOCUS_CHANGED");
opvp.event.PLAYER_REGEN_DISABLED               = opvp.EventRegistrySignal("PLAYER_REGEN_DISABLED");
opvp.event.PLAYER_REGEN_ENABLED                = opvp.EventRegistrySignal("PLAYER_REGEN_ENABLED");
opvp.event.PLAYER_SPECIALIZATION_CHANGED       = opvp.EventRegistrySignal("PLAYER_SPECIALIZATION_CHANGED");
opvp.event.PLAYER_TARGET_CHANGED               = opvp.EventRegistrySignal("PLAYER_TARGET_CHANGED");
opvp.event.PLAYER_UNGHOST                      = opvp.EventRegistrySignal("PLAYER_UNGHOST");
opvp.event.PLAYER_UPDATE_RESTING               = opvp.EventRegistrySignal("PLAYER_UPDATE_RESTING");
opvp.event.TIME_PLAYED_MSG                     = opvp.EventRegistrySignal("TIME_PLAYED_MSG");

--~ Spell events
opvp.event.SPELL_PUSHED_TO_ACTIONBAR           = opvp.EventRegistrySignal("SPELL_PUSHED_TO_ACTIONBAR");
opvp.event.SPELL_TEXT_UPDATE                   = opvp.EventRegistrySignal("SPELL_TEXT_UPDATE");
opvp.event.SPELL_UPDATE_COOLDOWN               = opvp.EventRegistrySignal("SPELL_UPDATE_COOLDOWN");
opvp.event.SPELL_UPDATE_ICON                   = opvp.EventRegistrySignal("SPELL_UPDATE_ICON");
opvp.event.SPELL_UPDATE_CHARGES                = opvp.EventRegistrySignal("SPELL_UPDATE_CHARGES");
opvp.event.SPELL_UPDATE_USABLE                 = opvp.EventRegistrySignal("SPELL_UPDATE_USABLE");
opvp.event.SPELL_UPDATE_USES                   = opvp.EventRegistrySignal("SPELL_UPDATE_USES");
opvp.event.SPELLS_CHANGED                      = opvp.EventRegistrySignal("SPELLS_CHANGED");

--~ Sound events
opvp.event.SOUND_DEVICE_UPDATE                 = opvp.EventRegistrySignal("SOUND_DEVICE_UPDATE");
opvp.event.SOUNDKIT_FINISHED                   = opvp.EventRegistrySignal("SOUNDKIT_FINISHED");

--~ Pvp events
opvp.event.ARENA_COOLDOWNS_UPDATE              = opvp.EventRegistrySignal("ARENA_COOLDOWNS_UPDATE");
opvp.event.ARENA_CROWD_CONTROL_SPELL_UPDATE    = opvp.EventRegistrySignal("ARENA_CROWD_CONTROL_SPELL_UPDATE");
opvp.event.ARENA_OPPONENT_UPDATE               = opvp.EventRegistrySignal("ARENA_OPPONENT_UPDATE");
opvp.event.ARENA_PREP_OPPONENT_SPECIALIZATIONS = opvp.EventRegistrySignal("ARENA_PREP_OPPONENT_SPECIALIZATIONS");
opvp.event.ARENA_SEASON_WORLD_STATE            = opvp.EventRegistrySignal("ARENA_SEASON_WORLD_STATE");
opvp.event.BATTLEFIELD_AUTO_QUEUE              = opvp.EventRegistrySignal("BATTLEFIELD_AUTO_QUEUE");
opvp.event.BATTLEFIELD_AUTO_QUEUE_EJECT        = opvp.EventRegistrySignal("BATTLEFIELD_AUTO_QUEUE_EJECT");
opvp.event.BATTLEFIELD_QUEUE_TIMEOUT           = opvp.EventRegistrySignal("BATTLEFIELD_QUEUE_TIMEOUT");
opvp.event.BATTLEFIELDS_SHOW                   = opvp.EventRegistrySignal("BATTLEFIELDS_SHOW");
opvp.event.BATTLEGROUND_OBJECTIVES_UPDATE      = opvp.EventRegistrySignal("BATTLEGROUND_OBJECTIVES_UPDATE");
opvp.event.BATTLEGROUND_POINTS_UPDATE          = opvp.EventRegistrySignal("BATTLEGROUND_POINTS_UPDATE");
opvp.event.HONOR_LEVEL_UPDATE                  = opvp.EventRegistrySignal("HONOR_LEVEL_UPDATE");
opvp.event.LOSS_OF_CONTROL_ADDED               = opvp.EventRegistrySignal("LOSS_OF_CONTROL_ADDED");
opvp.event.LOSS_OF_CONTROL_UPDATE              = opvp.EventRegistrySignal("LOSS_OF_CONTROL_UPDATE");
opvp.event.PLAYER_CONTROL_GAINED               = opvp.EventRegistrySignal("PLAYER_CONTROL_GAINED");
opvp.event.PLAYER_ENTERING_BATTLEGROUND        = opvp.EventRegistrySignal("PLAYER_ENTERING_BATTLEGROUND");
opvp.event.PLAYER_JOINED_PVP_MATCH             = opvp.EventRegistrySignal("PLAYER_JOINED_PVP_MATCH");
opvp.event.PLAYER_PVP_KILLS_CHANGED            = opvp.EventRegistrySignal("PLAYER_PVP_KILLS_CHANGED");
opvp.event.PLAYER_PVP_TALENT_UPDATE            = opvp.EventRegistrySignal("PLAYER_PVP_TALENT_UPDATE");
opvp.event.POST_MATCH_CURRENCY_REWARD_UPDATE   = opvp.EventRegistrySignal("POST_MATCH_CURRENCY_REWARD_UPDATE");
opvp.event.PVP_BRAWL_INFO_UPDATED              = opvp.EventRegistrySignal("PVP_BRAWL_INFO_UPDATED");
opvp.event.PVP_MATCH_ACTIVE                    = opvp.EventRegistrySignal("PVP_MATCH_ACTIVE");
opvp.event.PVP_MATCH_COMPLETE                  = opvp.EventRegistrySignal("PVP_MATCH_COMPLETE");
opvp.event.PVP_MATCH_INACTIVE                  = opvp.EventRegistrySignal("PVP_MATCH_INACTIVE");
opvp.event.PVP_MATCH_STATE_CHANGED             = opvp.EventRegistrySignal("PVP_MATCH_STATE_CHANGED");
opvp.event.PVP_RATED_STATS_UPDATE              = opvp.EventRegistrySignal("PVP_RATED_STATS_UPDATE");
opvp.event.PVP_REWARDS_UPDATE                  = opvp.EventRegistrySignal("PVP_REWARDS_UPDATE");
opvp.event.PVP_ROLE_POPUP_HIDE                 = opvp.EventRegistrySignal("PVP_ROLE_POPUP_HIDE");
opvp.event.PVP_ROLE_POPUP_SHOW                 = opvp.EventRegistrySignal("PVP_ROLE_POPUP_SHOW");
opvp.event.PVP_ROLE_UPDATE                     = opvp.EventRegistrySignal("PVP_ROLE_UPDATE");
opvp.event.PVP_SPECIAL_EVENT_INFO_UPDATED      = opvp.EventRegistrySignal("PVP_SPECIAL_EVENT_INFO_UPDATED");
opvp.event.PVP_TIMER_UPDATE                    = opvp.EventRegistrySignal("PVP_TIMER_UPDATE");
opvp.event.PVP_TYPES_ENABLED                   = opvp.EventRegistrySignal("PVP_TYPES_ENABLED");
opvp.event.PVP_VEHICLE_INFO_UPDATED            = opvp.EventRegistrySignal("PVP_VEHICLE_INFO_UPDATED");
opvp.event.PVP_WORLDSTATE_UPDATE               = opvp.EventRegistrySignal("PVP_WORLDSTATE_UPDATE");
opvp.event.PVPQUEUE_ANYWHERE_SHOW              = opvp.EventRegistrySignal("PVPQUEUE_ANYWHERE_SHOW");
opvp.event.PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE  = opvp.EventRegistrySignal("PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE");
opvp.event.UPDATE_ACTIVE_BATTLEFIELD           = opvp.EventRegistrySignal("UPDATE_ACTIVE_BATTLEFIELD");
opvp.event.UPDATE_BATTLEFIELD_SCORE            = opvp.EventRegistrySignal("UPDATE_BATTLEFIELD_SCORE");
opvp.event.UPDATE_BATTLEFIELD_STATUS           = opvp.EventRegistrySignal("UPDATE_BATTLEFIELD_STATUS");
opvp.event.WAR_MODE_STATUS_UPDATE              = opvp.EventRegistrySignal("WAR_MODE_STATUS_UPDATE");
opvp.event.WARGAME_REQUESTED                   = opvp.EventRegistrySignal("WARGAME_REQUESTED");
opvp.event.WORLD_PVP_QUEUE                     = opvp.EventRegistrySignal("WORLD_PVP_QUEUE");

--~ Timer events
opvp.event.START_TIMER                         = opvp.EventRegistrySignal("START_TIMER");
opvp.event.STOP_TIMER_OF_TYPE                  = opvp.EventRegistrySignal("STOP_TIMER_OF_TYPE");

--~ Unit events
opvp.event.INSPECT_READY                       = opvp.EventRegistrySignal("INSPECT_READY");
opvp.event.UNIT_ABSORB_AMOUNT_CHANGED          = opvp.EventRegistrySignal("UNIT_ABSORB_AMOUNT_CHANGED");
opvp.event.UNIT_AREA_CHANGED                   = opvp.EventRegistrySignal("UNIT_AREA_CHANGED");
opvp.event.UNIT_ATTACK                         = opvp.EventRegistrySignal("UNIT_ATTACK");
opvp.event.UNIT_ATTACK_POWER                   = opvp.EventRegistrySignal("UNIT_ATTACK_POWER");
opvp.event.UNIT_ATTACK_SPEED                   = opvp.EventRegistrySignal("UNIT_ATTACK_SPEED");
opvp.event.UNIT_AURA                           = opvp.EventRegistrySignal("UNIT_AURA");
opvp.event.UNIT_CHEAT_TOGGLE_EVENT             = opvp.EventRegistrySignal("UNIT_CHEAT_TOGGLE_EVENT");
opvp.event.UNIT_CLASSIFICATION_CHANGED         = opvp.EventRegistrySignal("UNIT_CLASSIFICATION_CHANGED");
opvp.event.UNIT_COMBAT                         = opvp.EventRegistrySignal("UNIT_COMBAT");
opvp.event.UNIT_CONNECTION                     = opvp.EventRegistrySignal("UNIT_CONNECTION");
opvp.event.UNIT_CTR_OPTIONS                    = opvp.EventRegistrySignal("UNIT_CTR_OPTIONS");
opvp.event.UNIT_DAMAGE                         = opvp.EventRegistrySignal("UNIT_DAMAGE");
opvp.event.UNIT_DEFENSE                        = opvp.EventRegistrySignal("UNIT_DEFENSE");
opvp.event.UNIT_DISPLAYPOWER                   = opvp.EventRegistrySignal("UNIT_DISPLAYPOWER");
opvp.event.UNIT_DISTANCE_CHECK_UPDATE          = opvp.EventRegistrySignal("UNIT_DISTANCE_CHECK_UPDATE");
opvp.event.UNIT_FACTION                        = opvp.EventRegistrySignal("UNIT_FACTION");
opvp.event.UNIT_FLAGS                          = opvp.EventRegistrySignal("UNIT_FLAGS");
opvp.event.UNIT_FORM_CHANGED                   = opvp.EventRegistrySignal("UNIT_FORM_CHANGED");
opvp.event.UNIT_HEAL_ABSORB_AMOUNT_CHANGED     = opvp.EventRegistrySignal("UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
opvp.event.UNIT_HEAL_PREDICTION                = opvp.EventRegistrySignal("UNIT_HEAL_PREDICTION");
opvp.event.UNIT_HEALTH                         = opvp.EventRegistrySignal("UNIT_HEALTH");
opvp.event.UNIT_IN_RANGE_UPDATE                = opvp.EventRegistrySignal("UNIT_IN_RANGE_UPDATE");
opvp.event.UNIT_INVENTORY_CHANGED              = opvp.EventRegistrySignal("UNIT_INVENTORY_CHANGED");
opvp.event.UNIT_LEVEL                          = opvp.EventRegistrySignal("UNIT_LEVEL");
opvp.event.UNIT_MANA                           = opvp.EventRegistrySignal("UNIT_MANA");
opvp.event.UNIT_MAX_HEALTH_MODIFIERS_CHANGED   = opvp.EventRegistrySignal("UNIT_MAX_HEALTH_MODIFIERS_CHANGED");
opvp.event.UNIT_MAXHEALTH                      = opvp.EventRegistrySignal("UNIT_MAXHEALTH");
opvp.event.UNIT_MAXPOWER                       = opvp.EventRegistrySignal("UNIT_MAXPOWER");
opvp.event.UNIT_MODEL_CHANGED                  = opvp.EventRegistrySignal("UNIT_MODEL_CHANGED");
opvp.event.UNIT_NAME_UPDATE                    = opvp.EventRegistrySignal("UNIT_NAME_UPDATE");
opvp.event.UNIT_OTHER_PARTY_CHANGED            = opvp.EventRegistrySignal("UNIT_OTHER_PARTY_CHANGED");
opvp.event.UNIT_PET                            = opvp.EventRegistrySignal("UNIT_PET");
opvp.event.UNIT_PET_EXPERIENCE                 = opvp.EventRegistrySignal("UNIT_PET_EXPERIENCE");
opvp.event.UNIT_PHASE                          = opvp.EventRegistrySignal("UNIT_PHASE");
opvp.event.UNIT_PORTRAIT_UPDATE                = opvp.EventRegistrySignal("UNIT_PORTRAIT_UPDATE");
opvp.event.UNIT_POWER_BAR_HIDE                 = opvp.EventRegistrySignal("UNIT_POWER_BAR_HIDE");
opvp.event.UNIT_POWER_BAR_SHOW                 = opvp.EventRegistrySignal("UNIT_POWER_BAR_SHOW");
opvp.event.UNIT_POWER_BAR_TIMER_UPDATE         = opvp.EventRegistrySignal("UNIT_POWER_BAR_TIMER_UPDATE");
opvp.event.UNIT_POWER_FREQUENT                 = opvp.EventRegistrySignal("UNIT_POWER_FREQUENT");
opvp.event.UNIT_POWER_POINT_CHARGE             = opvp.EventRegistrySignal("UNIT_POWER_POINT_CHARGE");
opvp.event.UNIT_POWER_UPDATE                   = opvp.EventRegistrySignal("UNIT_POWER_UPDATE");
opvp.event.UNIT_QUEST_LOG_CHANGED              = opvp.EventRegistrySignal("UNIT_QUEST_LOG_CHANGED");
opvp.event.UNIT_RANGED_ATTACK_POWER            = opvp.EventRegistrySignal("UNIT_RANGED_ATTACK_POWER");
opvp.event.UNIT_RANGEDDAMAGE                   = opvp.EventRegistrySignal("UNIT_RANGEDDAMAGE");
opvp.event.UNIT_RESISTANCES                    = opvp.EventRegistrySignal("UNIT_RESISTANCES");
opvp.event.UNIT_SPELL_HASTE                    = opvp.EventRegistrySignal("UNIT_SPELL_HASTE");
opvp.event.UNIT_SPELLCAST_CHANNEL_START        = opvp.EventRegistrySignal("UNIT_SPELLCAST_CHANNEL_START");
opvp.event.UNIT_SPELLCAST_CHANNEL_STOP         = opvp.EventRegistrySignal("UNIT_SPELLCAST_CHANNEL_STOP");
opvp.event.UNIT_SPELLCAST_CHANNEL_UPDATE       = opvp.EventRegistrySignal("UNIT_SPELLCAST_CHANNEL_UPDATE");
opvp.event.UNIT_SPELLCAST_DELAYED              = opvp.EventRegistrySignal("UNIT_SPELLCAST_DELAYED");
opvp.event.UNIT_SPELLCAST_EMPOWER_START        = opvp.EventRegistrySignal("UNIT_SPELLCAST_EMPOWER_START");
opvp.event.UNIT_SPELLCAST_EMPOWER_STOP         = opvp.EventRegistrySignal("UNIT_SPELLCAST_EMPOWER_STOP");
opvp.event.UNIT_SPELLCAST_EMPOWER_UPDATE       = opvp.EventRegistrySignal("UNIT_SPELLCAST_EMPOWER_UPDATE");
opvp.event.UNIT_SPELLCAST_FAILED               = opvp.EventRegistrySignal("UNIT_SPELLCAST_FAILED");
opvp.event.UNIT_SPELLCAST_FAILED_QUIET         = opvp.EventRegistrySignal("UNIT_SPELLCAST_FAILED_QUIET");
opvp.event.UNIT_SPELLCAST_INTERRUPTED          = opvp.EventRegistrySignal("UNIT_SPELLCAST_INTERRUPTED");
opvp.event.UNIT_SPELLCAST_INTERRUPTIBLE        = opvp.EventRegistrySignal("UNIT_SPELLCAST_INTERRUPTIBLE");
opvp.event.UNIT_SPELLCAST_NOT_INTERRUPTIBLE    = opvp.EventRegistrySignal("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
opvp.event.UNIT_SPELLCAST_RETICLE_CLEAR        = opvp.EventRegistrySignal("UNIT_SPELLCAST_RETICLE_CLEAR");
opvp.event.UNIT_SPELLCAST_RETICLE_TARGET       = opvp.EventRegistrySignal("UNIT_SPELLCAST_RETICLE_TARGET");
opvp.event.UNIT_SPELLCAST_START                = opvp.EventRegistrySignal("UNIT_SPELLCAST_START");
opvp.event.UNIT_SPELLCAST_STOP                 = opvp.EventRegistrySignal("UNIT_SPELLCAST_STOP");
opvp.event.UNIT_SPELLCAST_SUCCEEDED            = opvp.EventRegistrySignal("UNIT_SPELLCAST_SUCCEEDED");
opvp.event.UNIT_STATS                          = opvp.EventRegistrySignal("UNIT_STATS");
opvp.event.UNIT_TARGET                         = opvp.EventRegistrySignal("UNIT_TARGET");
opvp.event.UNIT_TARGETABLE_CHANGED             = opvp.EventRegistrySignal("UNIT_TARGETABLE_CHANGED");

--~ Widget events
opvp.event.UPDATE_UI_WIDGET                    = opvp.EventRegistrySignal("UPDATE_UI_WIDGET");

--~ World state events
opvp.event.LOADING_SCREEN_ENABLED              = opvp.EventRegistrySignal("LOADING_SCREEN_ENABLED");
opvp.event.LOADING_SCREEN_DISABLED             = opvp.EventRegistrySignal("LOADING_SCREEN_DISABLED");
opvp.event.PLAYER_ENTERING_WORLD               = opvp.EventRegistrySignal("PLAYER_ENTERING_WORLD");
opvp.event.PLAYER_LEAVING_WORLD                = opvp.EventRegistrySignal("PLAYER_LEAVING_WORLD");
opvp.event.SETTINGS_LOADED                     = opvp.EventRegistrySignal("SETTINGS_LOADED");
opvp.event.ZONE_CHANGED                        = opvp.EventRegistrySignal("ZONE_CHANGED");
opvp.event.ZONE_CHANGED_NEW_AREA               = opvp.EventRegistrySignal("ZONE_CHANGED_NEW_AREA");

opvp.event.PLAYER_ENTERING_WORLD_LOGIN         = opvp.Signal("PLAYER_ENTERING_WORLD_LOGIN");
opvp.event.PLAYER_ENTERING_WORLD_LOGIN_RELOAD  = opvp.Signal("PLAYER_ENTERING_WORLD_LOGIN_RELOAD");
opvp.event.PLAYER_ENTERING_WORLD_RELOAD        = opvp.Signal("PLAYER_ENTERING_WORLD_RELOAD");

local function opvp_player_entering_world(isInitialLogin, isReloadingUi)
    if isInitialLogin == true then
        ChatFrame1:SetMaxLines(1024);

        local sys = opvp.System:instance();

        sys:_onLoadBegin();

        if sys:isLastLoginValid() == true then
            opvp.printMessage(
                opvp.strs.LOGIN_LAST,
                date("%c", sys:lastLoginTime())
            );
        end

        opvp.event.PLAYER_ENTERING_WORLD_LOGIN_RELOAD:emit();

        opvp.event.PLAYER_ENTERING_WORLD_LOGIN:emit();

        opvp.OnLoadingScreenEnd:connect(sys, sys._onLoadEnd);
    elseif isReloadingUi == true then
        ChatFrame1:SetMaxLines(1024);

        local sys = opvp.System:instance();

        sys:_onReloadBegin();

        if sys:isLastLoginValid() == true then
            opvp.printMessage(
                opvp.strs.LOGIN_LAST,
                date("%c", sys:lastLoginTime())
            );
        end

        opvp.printMessage(
            opvp.strs.LOGIN_SESSION,
            opvp.time.formatSeconds(opvp.system.sessionTime())
        );

        opvp.event.PLAYER_ENTERING_WORLD_LOGIN_RELOAD:emit();

        opvp.event.PLAYER_ENTERING_WORLD_RELOAD:emit();

        opvp.OnLoadingScreenEnd:connect(sys, sys._onReloadEnd);
    end
end

opvp.event.PLAYER_ENTERING_WORLD:connect(opvp_player_entering_world);

hooksecurefunc(
    "CancelLogout",
    function()
        opvp.event.LOGOUT_CANCEL:emit();
    end
);
