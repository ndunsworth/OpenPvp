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

local opvp_msg_filter_mgr_singleton;

opvp.ChatMessageFilterManager = opvp.CreateClass();

function opvp.ChatMessageFilterManager:instance()
    return opvp_msg_filter_mgr_singleton;
end

function opvp.ChatMessageFilterManager:init()
    self._filters = {};

    for k,v in pairs(opvp.ChatType) do
        self._filters[k] = opvp.List();
    end

    self._cb = function(frame, event, ...)
        return self:eval(frame, event, ...);
    end
end

function opvp.ChatMessageFilterManager:eval(chatFrame, event, msg, ...)
    local filters = self._filters[string.gsub(event, "CHAT_MSG_", "")];

    if filters == nil then
        return;
    end

    local msg_lower = string.lower(msg);

    for n=1, filters:size() do
        if filters:item(n):eval(chatFrame, event, msg, msg_lower, ...) == true then
            return true;
        end
    end

    return false;
end

function opvp.ChatMessageFilterManager:register(chatType, filter)
    local filters = self._filters[chatType];

    if filters == nil or filters:contains(filter) == true then
        return;
    end

    filters:append(filter);

    if filters:size() == 1 then
        ChatFrame_AddMessageEventFilter("CHAT_MSG_" .. chatType, self._cb);
    end
end

function opvp.ChatMessageFilterManager:unregister(chatType, filter)
    local filters = self._filters[chatType];

    if filters ~= nil then
         filters:removeItem(filter);

        if filters:isEmpty() == true then
            ChatFrame_RemoveMessageEventFilter("CHAT_MSG_" .. chatType, self._cb);
        end
    end
end

local function opvp_msg_filter_mgr_ctor()
    opvp_msg_filter_mgr_singleton = opvp.ChatMessageFilterManager();

    local match_round_warmup_filter = opvp.MatchOptionChatTypesMessageFilter(
        opvp.options.announcements.match.roundWarmupCountdown,
        {opvp.ChatType.BG_SYSTEM_NEUTRAL},
        {
            opvp.strs.WOW_MATCH_ARENA_BEGINS_60,
            opvp.strs.WOW_MATCH_ARENA_BEGINS_30,
            opvp.strs.WOW_MATCH_ARENA_BEGINS_15,
            opvp.strs.WOW_MATCH_ARENA_ACTIVE,
            opvp.strs.WOW_MATCH_BATTLEGROUND_BEGINS_120,
            opvp.strs.WOW_MATCH_BATTLEGROUND_BEGINS_60,
            opvp.strs.WOW_MATCH_BATTLEGROUND_BEGINS_30
        }
    );

    local party_convert_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.friendlyParty.typeChanged,
        {opvp.ChatType.SYSTEM},
        {
            ERR_PARTY_CONVERTED_TO_RAID,
            ERR_RAID_CONVERTED_TO_PARTY
        },
        true
    );

    local party_join_leave_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.friendlyParty.joinLeave,
        {opvp.ChatType.SYSTEM},
        {
            ERR_CROSS_FACTION_GROUP_JOINED,
            ERR_GROUP_DISBANDED,
            ERR_UNINVITE_YOU,
        },
        true
    );

    local party_difficulty_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.friendlyParty.difficultyChanged,
        {opvp.ChatType.SYSTEM},
        {
            ERR_DUNGEON_DIFFICULTY_CHANGED_S,
            ERR_RAID_DIFFICULTY_CHANGED_S,
            ERR_LEGACY_RAID_DIFFICULTY_CHANGED_S
        },
        true
    );

    local party_member_death_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.friendlyParty.memberDeath,
        {opvp.ChatType.SYSTEM},
        {
            ERR_PLAYER_DIED_S
        },
        true
    );

    local party_member_join_leave_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.friendlyParty.memberJoinLeave,
        {opvp.ChatType.SYSTEM},
        {
            ERR_BG_PLAYER_LEFT_S,
            ERR_BG_PLAYER_JOINED_SS,
            ERR_INSTANCE_GROUP_ADDED_S,
            ERR_INSTANCE_GROUP_REMOVED_S,
            ERR_LEFT_GROUP_YOU,
            ERR_PLAYER_JOINED_BATTLE_D,
            ERR_PLAYER_LEFT_BATTLE_D,
            ERR_PLAYERS_JOINED_BATTLE_D,
            ERR_PLAYERLIST_JOINED_BATTLE,
            ERR_PLAYERS_LEFT_BATTLE_D,
            JOINED_PARTY,
            LEFT_PARTY
        },
        true
    );

    --~ ERR_LFG_LEFT_QUEUE
    --~ ERR_LFG_PROPOSAL_FAILED

    local queue_join_leave_filter = opvp.OptionChatTypesMessageFilter(
        opvp.options.announcements.queue.joinLeave,
        {opvp.ChatType.SYSTEM},
        {
            ERR_SOLO_JOIN_BATTLEGROUND_S,
            ERR_SOLO_JOIN_BATTLEGROUND_SPEC_S
        },
        true
    );

    --~ local queue_ready_filter = opvp.OptionChatTypesMessageFilter(
        --~ opvp.options.announcements.queue.ready,
        --~ {opvp.ChatType.SYSTEM},
        --~ {
            --~ ERR_SOLO_JOIN_BATTLEGROUND_S,
            --~ ERR_SOLO_JOIN_BATTLEGROUND_SPEC_S
        --~ },
        --~ true
    --~ );
end

opvp.OnLoginReload:register(opvp_msg_filter_mgr_ctor);
