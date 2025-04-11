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

local FILTER_CHANNELS = {
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_SAY",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_YELL"
};

opvp.private.ChatFilterMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.ChatFilterMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._friends     = opvp.List();
    self._ignore      = opvp.List();
    self._valid_test  = opvp.MatchTestType.NONE;

    self._cb = function(...)
        return self:_onMessageEvent(...);
    end
end

function opvp.private.ChatFilterMatchFeature:isFriend(guid)
    if (
        guid == opvp.player.guid() or
        self._friends:contains(guid)
    ) then
        return true;
    end

    if self._ignore:contains(guid) then
        return false;
    end

    local result = (
        C_FriendList.IsFriend(guid) == true or
        C_BattleNet.GetAccountInfoByGUID(guid) ~= nil
    );

    if result == true then
        self._friends:append(guid);
    else
        self._ignore:append(guid);
    end

    return result;
end

function opvp.private.ChatFilterMatchFeature:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.ChatFilterMatchFeature:isValidMatch(match)
    return (
        match ~= nil and
        match:isTest() == false and
        (
            match:isBlitz() == true or
            match:isShuffle() == true
        )
    );
end

function opvp.private.ChatFilterMatchFeature:_onMessageEvent(
    chatFrame,
    event,
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
)
    return self:isFriend(arg12) == false;
end

function opvp.private.ChatFilterMatchFeature:_onFeatureActivated()
    for n=1, #FILTER_CHANNELS do
        ChatFrame_AddMessageEventFilter(FILTER_CHANNELS[n], self._cb);
    end

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.ChatFilterMatchFeature:_onFeatureDeactivated()
    for n=1, #FILTER_CHANNELS do
        ChatFrame_RemoveMessageEventFilter(FILTER_CHANNELS[n], self._cb);
    end

    self._friends:clear();
    self._ignore:clear();

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

local opvp_chat_filter_match_feature;

local function opvp_chat_filter_match_feature_ctor()
    opvp_chat_filter_match_feature = opvp.private.ChatFilterMatchFeature(
        opvp.options.match.chat.mute
    );
end

opvp.OnAddonLoad:register(opvp_chat_filter_match_feature_ctor);
