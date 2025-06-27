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

opvp.private.SetChatStatusMatchFeature = opvp.CreateClass(opvp.MatchTypeOptionFeature);

function opvp.private.SetChatStatusMatchFeature:init(option)
    opvp.MatchTypeOptionFeature.init(self, option);

    self._valid_test  = opvp.MatchTestType.NONE;
    self._prev_status = opvp.ChatStatus.AVAILABLE;
end

function opvp.private.SetChatStatusMatchFeature:isActiveMatchStatus(status)
    return status ~= opvp.MatchStatus.EXIT;
end

function opvp.private.SetChatStatusMatchFeature:_onFeatureActivated()
    opvp.MatchTypeOptionFeature._onFeatureActivated(self);

    if opvp.chat.isDND() == false then
        self._prev_status = opvp.chat.status();

        opvp.chat.setDND(opvp.match.current():name(true));
    end
end

function opvp.private.SetChatStatusMatchFeature:_onFeatureDeactivated()
    opvp.MatchTypeOptionFeature._onFeatureDeactivated(self);

    if self._prev_status ~= opvp.ChatStatus.DND then
        opvp.chat.setStatus(self._prev_status);
    end
end

local opvp_set_chat_status_match_feature_singleton;

local function opvp_set_chat_status_match_feature_singleton_ctor()
    opvp_set_chat_status_match_feature_singleton = opvp.private.SetChatStatusMatchFeature(
        opvp.options.match.social.chatStatusDND
    );
end

opvp.OnAddonLoad:register(opvp_set_chat_status_match_feature_singleton_ctor);
