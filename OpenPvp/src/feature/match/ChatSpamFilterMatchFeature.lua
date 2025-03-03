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

opvp.ChatSpamFilterMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.ChatSpamFilterMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._ignore_test = true;

    local addon_spam_msgs = {};

    for n=1, #opvp.locales do
        local locale = opvp.locale[opvp.locales[n]];

        table.insert(addon_spam_msgs, locale.DRINKING_SPAM_1);
        table.insert(addon_spam_msgs, locale.LOW_HEALTH_SPAM_1);
        table.insert(addon_spam_msgs, locale.ENEMY_SPEC_SPAM_1);
        table.insert(addon_spam_msgs, locale.RESURRECTING_SPAM_1);
    end

    self._spam_filter = opvp.ChatTypesMessageFilter(
        {
            opvp.ChatType.BATTLEGROUND,
            opvp.ChatType.BATTLEGROUND_LEADER,
            opvp.ChatType.INSTANCE_CHAT,
            opvp.ChatType.INSTANCE_CHAT_LEADER,
            opvp.ChatType.PARTY,
            opvp.ChatType.PARTY_LEADER,
            opvp.ChatType.RAID,
            opvp.ChatType.RAID_LEADER,
            opvp.ChatType.RAID_WARNING,  --~ I would shoot someone if they used this option in gladius lmao
            opvp.ChatType.SAY,
            opvp.ChatType.YELL,
        },
        addon_spam_msgs,
        false,
        true
    );
end

function opvp.ChatSpamFilterMatchFeature:_onFeatureActivated()
    self._spam_filter:connect();

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.ChatSpamFilterMatchFeature:_onFeatureDeactivated()
    self._spam_filter:disconnect();

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

local opvp_filter_chat_spam_match_feature;

local function opvp_filter_chat_spam_match_feature_ctor()
    opvp_filter_chat_spam_match_feature = opvp.ChatSpamFilterMatchFeature(
        opvp.options.match.chat.filterAddonSpam
    );
end

opvp.OnAddonLoad:register(opvp_filter_chat_spam_match_feature_ctor);
