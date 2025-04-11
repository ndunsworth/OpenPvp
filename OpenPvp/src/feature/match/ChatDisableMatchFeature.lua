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

opvp.private.ChatDisableMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.ChatDisableMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._valid_test = opvp.MatchTestType.NONE;

    if opvp.private.state.ui.restore.chat:value() == true then
        C_SocialRestrictions.SetChatDisabled(false);

        opvp.private.state.ui.restore.chat:setValue(false);
    end;
end

function opvp.private.ChatDisableMatchFeature:isValidMatch(match)
    return (
        match ~= nil and
        match:isTest() == false and
        (
            match:isBlitz() == true or
            match:isShuffle() == true
        )
    );
end

function opvp.private.ChatDisableMatchFeature:onLogoutDeactivate()
    return true;
end

function opvp.private.ChatDisableMatchFeature:_onFeatureActivated()
    if opvp.chat.isEnabled() == true then
        opvp.chat.setEnabled(false)

        opvp.private.state.ui.restore.chat:setValue(true);
    end

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.ChatDisableMatchFeature:_onFeatureDeactivated()
    if opvp.private.state.ui.restore.chat:value() == true then
        opvp.chat.setEnabled(true);

        opvp.private.state.ui.restore.chat:setValue(false);
    end

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

local opvp_chat_disable_match_feature;

local function opvp_chat_disable_match_feature_ctor()
    opvp_chat_disable_match_feature = opvp.private.ChatDisableMatchFeature(
        opvp.options.match.chat.disable
    );
end

opvp.OnAddonLoad:register(opvp_chat_disable_match_feature_ctor);
