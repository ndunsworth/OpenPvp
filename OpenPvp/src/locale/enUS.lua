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

opvp.locale.enUS = {
    DEBUG_DISABLED                    = "Debug | Disabled",
    DEBUG_ENABLED                     = "Debug | Enabled",
    ACTION_BAR                        = "Action Bar",
    ACTION_BAR_WITH_ID                = "Action Bar %d",
    ACTION_BARS                       = "Action Bars",
    ARENA                             = "Arena",
    ARENA_AND_BATTLEGROUND            = "Arena + Battleground",
    BATTLEGROUND                      = "Battleground",
    BONUS_ACTION_BAR                  = "Bonus Action Bar",
    CAPPED                            = "Capped",
    CLASS_BAR                         = "Class Bar",
    CLASS_BAR_WITH_ID                 = "Class Bar %d",
    CURRENCY                          = "Currency",
    CURRENT_RATING                    = "Current Rating",
    DISABLED                          = "Disabled",
    DAILY_WIN                         = "Daily Win",
    EPIC_BATTLEGROUND                 = "Epic Battleground",
    EVENTS                            = "Events",
    FRAME                             = "Frame",
    FRAMES                            = "Frames",
    HONORABLE_KILLS                   = "Honorable Kills",
    LAYOUT                            = "Layout",
    LAYOUT_ARENA                      = "Arena Layout",
    LAYOUT_BATTLEGROUND               = "Battleground Layout",
    LIFETIME                          = "Lifetime",
    NO                                = "No",
    OFFSEASON                         = "Offseason",
    PARTY                             = "Party",
    PROFILE_CREATE                    = "Create Profile",
    PROFILE_DELETE                    = "Delete Profile",
    QUEUES                            = "Queues",
    RAID                              = "Raid",
    SEASON                            = "Season",
    SEASON_REWARD                     = "Season Reward",
    TODAY                             = "Today",
    UNKNOWN                           = "Unknown",
    YES                               = "Yes",
    YESTERDAY                         = "Yesterday",

    PVP_CURRENCIES_CAPPED             = "Pvp Currencies Capped",

    CMD_HELP                          = "Command | %s - %s",
    CMD_GROUP_HELP                    = "Commands | %s",
    CMD_GROUP_CMD_HELP                = "    [%d] %s - %s",

    FEATURE_ACTIVATED                 = "Feature | %s (activated)",
    FEATURE_DEACTIVATED               = "Feature | %s (deactivated)",
    FEATURE_ENABLED                   = "Feature | %s (enabled)",
    FEATURE_DISABLED                  = "Feature | %s (disabled)",

    FLAG_ALLIANCE                     = "Alliance Flag",
    FLAG_HORDE                        = "Horde Flag",

    GOLD_TEAM_PLAYERS_REMAINING_RE    = "Gold Team: (%d+) Players Remaining",
    PURPLE_TEAM_PLAYERS_REMAINING_RE  = "Purple Team: (%d+) Players Remaining",

    LOGIN_LAST                        = "Last Login - %s",
    LOGIN_SESSION                     = "Current Session - %s",

    MATCH_NO_WINNER                   = "No Winner";
    MATCH_DRAW                        = "Draw";
    MATCH_LOST                        = "Lost";
    MATCH_WON                         = "Won";

    MATCH_INACTIVE_NAME               = "Inactive",
    MATCH_ENTERED_NAME                = "Entered",
    MATCH_JOINED_NAME                 = "Joined",
    MATCH_ROUND_WARMUP_NAME           = "Warmup",
    MATCH_ROUND_ACTIVE_NAME           = "Active",
    MATCH_ROUND_COMPLETE_NAME         = "Round Complete",
    MATCH_COMPLETE_NAME               = "Complete",
    MATCH_EXIT_NAME                   = "Exit",

    MATCH_STARTS_COUNTDOWN_120        = "Match | The %1s begins in %2$s",
    MATCH_STARTS_COUNTDOWN_60         = "Match | The %1s begins in %2$s",
    MATCH_STARTS_COUNTDOWN_30         = "Match | %2$s until the %1$s begins",
    MATCH_STARTS_COUNTDOWN_15         = "Match | %2$s until the %1$s begins",
    MATCH_STARTS_COUNTDOWN_10         = "Match | %2$s until the %1$s begins",

    MATCH_ROUND_STARTS_COUNTDOWN_120  = "Match | Round #%1$d - Begins in %2$s",
    MATCH_ROUND_STARTS_COUNTDOWN_60   = "Match | Round #%1$d - Begins in %2$s",
    MATCH_ROUND_STARTS_COUNTDOWN_30   = "Match | Round #%1$d - Begins in %2$s",
    MATCH_ROUND_STARTS_COUNTDOWN_15   = "Match | Round #%1$d - Begins in %2$s",
    MATCH_ROUND_STARTS_COUNTDOWN_10   = "Match | Round #%1$d - Begins in %2$s",

    MATCH_INACTIVE                    = "Match | Inactive",
    MATCH_ENTERED                     = "Match | Entered - %s",
    MATCH_ENTERED_WITH_MAP            = "Match | Entered - %s (%s)",
    MATCH_JOINED                      = "Match | Joined",
    MATCH_JOINED_IN_PROGRESS          = "Match | Joined in progress",
    MATCH_ROUND_WARMUP                = "Match | Warmup",
    MATCH_ROUND_ACTIVE                = "Match | The %s has begun!",
    MATCH_ROUND_ACTIVE_ARENA          = "Match | The Arena has begun!",
    MATCH_ROUND_ACTIVE_BATTLEGROUND   = "Match | %s has begun!",
    MATCH_ROUND_ACTIVE_WITH_ROUND     = "Match | Round #%d - Has begun!",
    MATCH_ROUND_COMPLETE_DRAW         = "Match | Round #%d - Draw (%s)",
    MATCH_ROUND_COMPLETE_LOST         = "Match | Round #%d - Lost (%s)",
    MATCH_ROUND_COMPLETE_WON          = "Match | Round #%d - Won (%s)",
    MATCH_COMPLETE                    = "Match | Complete",
    MATCH_COMPLETE_DRAW               = "Match | Complete - Draw (%s)",
    MATCH_COMPLETE_DRAW_WITH_ROUNDS   = "Match | Complete - Draw [%2$d-%3$d] (%1$s)",
    MATCH_COMPLETE_LOST               = "Match | Complete - Lost (%s)",
    MATCH_COMPLETE_LOST_WITH_ROUNDS   = "Match | Complete - Lost [%2$d-%3$d] (%1$s)",
    MATCH_COMPLETE_WON                = "Match | Complete - Won (%s)",
    MATCH_COMPLETE_WON_WITH_ROUNDS    = "Match | Complete - Won [%2$d-%3$d] (%1$s)",
    MATCH_EXPIRATION                  = "Match | Instance will expire in %s",
    MATCH_SCREENSHOT                  = "Match | Screenshot Taken",
    MATCH_SURRENDERED                 = "Match | Surrendered",
    MATCH_SURRENDERED_WITH_ELAPSED    = "Match | Surrendered (%s)",
    MATCH_EXIT                        = "Match | Exit",

    MATCH_DUNGEON_DIFF_CHANGED        = "Match | Dungeon Difficulty set to %s",
    MATCH_RAID_DIFF_CHANGED           = "Match | Raid Difficulty set to %s",
    MATCH_RAID_LEGACY_DIFF_CHANGED    = "Match | Legacy Raid Difficulty set to %s",
    MATCH_PLAYER_DIED                 = "Match | %s Died - %s",
    MATCH_PLAYER_DIED_WITH_SPEC       = "Match | %s Died - %s (|c%s%s %s|r)",
    MATCH_PLAYER_JOINED               = "Match | %s Joined - %s",
    MATCH_PLAYER_JOINED_WITH_SPEC     = "Match | %s Joined - %s (|c%s%s %s|r)",
    MATCH_PLAYER_LEAVE                = "Match | %s Left - %s",
    MATCH_PLAYER_LEAVE_WITH_SPEC      = "Match | %s Left - %s (|c%s%s %s|r)",
    MATCH_PLAYER_SPEC_CHANGED         = "Match | %s Spec - %s (|c%s%s %s|r)",

    MATCH_FEATURE_ACTIVATED           = "Match | Feature - %s (activated)",
    MATCH_FEATURE_DEACTIVATED         = "Match | Feature - %s (deactivated)",

    MATCH_FRIENDLY_PLAYER             = "Teammate",
    MATCH_FRIENDLY_TEAM               = "Team",
    MATCH_HOSTILE_PLAYER              = "Enemy Player",
    MATCH_HOSTILE_TEAM                = "Enemy Team",
    MATCH_TRINKET_USED                = "Match | Trinket %s - %s (|c%s%s %s|r)",
    MATCH_TRINKET_USED_WITH_SPEC      = "Match | Trinket %s - %s (|c%s%s %s|r)",

    OPTION_CHANGE_IN_COMBAT_ERR       = "Option | Tried to change the value of \"%s\" while in combat lockdown",

    PARTY_INFO_HEADER                 = "%s Info:",
    PARTY_INFO_EMPTY                  = "    - Empty -",
    PARTY_INFO_MEMBER                 = "    [%d] %s",
    PARTY_INFO_MEMBER_WITH_RACE       = "    [%d] %s (%s)",
    PARTY_INFO_MEMBER_WITH_RACE_SPEC  = "    [%d] %s (%s || |c%s%s %s|r)",
    PARTY_INFO_MEMBER_WITH_SPEC       = "    [%d] %s (|c%s%s %s|r)",

    PARTY_DUNGEON_DIFF_CHANGED        = "%s | Dungeon Difficulty set to %s",
    PARTY_RAID_DIFF_CHANGED           = "%s | Raid Difficulty set to %s",
    PARTY_RAID_LEGACY_DIFF_CHANGED    = "%s | Legacy Raid Difficulty set to %s",
    PARTY_FORMED                      = "%s | Formed",
    PARTY_JOINED                      = "%s | Joined",
    PARTY_LEAVE                       = "%s | Left",
    PARTY_MBR_DIED                    = "%s | Member Died - %s",
    PARTY_MBR_DIED_WITH_SPEC          = "%s | Member Died - %s (|c%s%s %s|r)",
    PARTY_MBR_JOINED                  = "%s | Member Joined - %s",
    PARTY_MBR_JOINED_WITH_SPEC        = "%s | Member Joined - %s (|c%s%s %s|r)",
    PARTY_MBR_LEAVE                   = "%s | Member Left - %s",
    PARTY_MBR_LEAVE_WITH_SPEC         = "%s | Member Left - %s (|c%s%s %s|r)",
    PARTY_MBR_SPEC_CHANGED            = "%s | Member Spec - %s (|c%s%s %s|r)",
    PARTY_CHANGED_TO_PARTY            = "%s | Converted to Party",
    PARTY_CHANGED_TO_RAID             = "%s | Converted to Raid",

    PLAYER_SPEC                       = "Player | Spec - |c%2$s%1$s|r",
    PLAYER_SPEC_CHANGED               = "Player | Spec Changed - |c%2$s%1$s|r",

    POI_NOT_CONTESTED                 = "Neutral",
    POI_ALLIANCE_CONTESTED            = "Alliance Contested",
    POI_ALLIANCE_CONTROLLED           = "Alliance Controled",
    POI_HORDE_CONTESTED               = "Horde Contested",
    POI_HORDE_CONTROLLED              = "Horde Controled",

    PROFILE_LOADED                    = "Profile | Changed to \"%s\"",

    PULL_TIMER_STARTED                = "Countdown | Starting in %s (%s)",
    PULL_TIMER_CANCELED               = "Countdown | Canceled",
    PULL_TIMER_UPDATE                 = "Countdown | %d",
    PULL_TIMER_ENDED                  = "Countdown | Go!",

    QUEUE_JOINED                      = "Queue | Joined - %s",
    QUEUE_JOINED_WITH_EST_TIME        = "Queue | Joined - %s (estimated time %s)",
    QUEUE_JOINED_WITH_WAIT_TIME       = "Queue | Joined - %s (%s in queue)",
    QUEUE_JOINED_WITH_WAIT_EST_TIME   = "Queue | Joined - %s (%s in queue, estimated time %s)",
    QUEUE_CANCELED                    = "Queue | Canceled - %s",
    QUEUE_CANCELED_WITH_WAIT_TIME     = "Queue | Canceled - %s (%s in queue)",
    QUEUE_READY                       = "Queue | Ready - %s",
    QUEUE_READY_WITH_WAIT_TIME        = "Queue | Ready - %s (%s in queue)",
    QUEUE_REJOINED                    = "Queue | Ready Check Failed Queue Resumed - %s",
    QUEUE_REJOINED_WITH_EST_TIME      = "Queue | Ready Check Failed Queue Resumed - %s (estimated time %s)",
    QUEUE_REJOINED_WITH_WAIT_TIME     = "Queue | Ready Check Failed Queue Resumed - %s",
    QUEUE_REJOINED_WITH_WAIT_EST_TIME = "Queue | Ready Check Failed Queue Resumed - %s (%s in queue, estimated time %s)",
    QUEUE_ROLE_CHECK                  = "Queue | Role Check - %s",
    QUEUE_SUSPENDED                   = "Queue | Suspended - %s",
    QUEUE_RESUMED                     = "Queue | Resumed - %s",
    QUEUE_RESUMED_WITH_EST_TIME       = "Queue | Resumed - %s (estimated time %s)",
    QUEUE_RESUMED_WITH_WAIT_TIME      = "Queue | Resumed - %s",
    QUEUE_RESUMED_WITH_WAIT_EST_TIME  = "Queue | Resumed - %s (%s in queue, estimated time %s)",
    QUEUE_SUSPENDED                   = "Queue | Suspended - %s",
    QUEUE_SUSPENDED_WITH_WAIT_TIME    = "Queue | Suspended - %s (%s in queue)",

    RATING_BRACKET_ENABLED            = "Rating Bracket - %s Enabled",
    RATING_BRACKED_DISABLED           = "Rating Bracket - %s Disabled",

    TRINKET_USED                      = "Trinket | Used!",
    TRINKET_ON_COOLDOWN               = "Trinket | On Cooldown!",
    TRINKET_READY                     = "Trinket | Ready!",
    TRINKET_RACIAL_USED               = "Racial Trinket | Used!",
    TRINKET_RACIAL_READY              = "Racial Trinket | Ready!",
    TRINKET_RACIAL_ON_COOLDOWN        = "Racial Trinket | On Cooldown!",
    TRINKET_FRIENDLY_USED             = "Friendly Trinket | %s (%s)",
    TRINKET_HOSTILE_USED              = "Hostile Trinket | %s (%s)",

    DRINKING_SPAM_1                   = "DRINKING:.*",
    LOW_HEALTH_SPAM_1                 = "LOW HEALTH:.*",
    ENEMY_SPEC_SPAM_1                 = "Enemy spec:.*",
    RESURRECTING_SPAM_1               = "RESURRECTING:.*",

    WOW_MATCH_ARENA_BEGINS_60         = "One minute until the Arena battle begins!",
    WOW_MATCH_ARENA_BEGINS_30         = "Thirty seconds until the Arena battle begins!",
    WOW_MATCH_ARENA_BEGINS_15         = "Fifteen seconds until the Arena battle begins!",
    WOW_MATCH_ARENA_ACTIVE            = "The Arena battle has begun!",
    WOW_MATCH_BATTLEGROUND_BEGINS_120 = "The [bB]attle.*begin.*in 2 minutes.",
    WOW_MATCH_BATTLEGROUND_BEGINS_60  = "The [bB]attle.*begin.*in 1 minute.",
    WOW_MATCH_BATTLEGROUND_BEGINS_30  = "The [bB]attle.*begin.*in 30 seconds."
};
