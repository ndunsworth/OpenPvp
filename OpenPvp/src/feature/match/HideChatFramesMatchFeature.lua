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

opvp.private.HideChatFramesMatchFeature = opvp.CreateClass(opvp.MatchTypeOptionFeature);

function opvp.private.HideChatFramesMatchFeature:init(option)
    opvp.MatchTypeOptionFeature.init(self, option);
end

function opvp.private.HideChatFramesMatchFeature:isActiveMatchStatus(status)
    return status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.private.HideChatFramesMatchFeature:setAlpha(alpha)
    GeneralDockManager:SetAlpha(alpha);

    local frame;

    for n=1,FCF_GetNumActiveChatFrames() do
        frame = _G["ChatFrame" .. n];

        if frame ~= nil then
            --~ ChatFrame.FontStringContainer needs to be set so icons in msgs
            --~ arent visible
            frame:SetAlpha(alpha);
            frame.FontStringContainer:SetAlpha(alpha);
        end
    end
end

function opvp.private.HideChatFramesMatchFeature:_onFeatureActivated()
    self:setAlpha(0);

    opvp.MatchTypeOptionFeature._onFeatureActivated(self);
end

function opvp.private.HideChatFramesMatchFeature:_onFeatureDeactivated()
    self:setAlpha(1);

    opvp.MatchTypeOptionFeature._onFeatureDeactivated(self);
end

local opvp_hide_chat_frames_match_feature;

local function opvp_hide_chat_frames_match_feature_ctor()
    opvp_hide_chat_frames_match_feature = opvp.private.HideChatFramesMatchFeature(
        opvp.options.match.frames.hideChat
    );
end

opvp.OnAddonLoad:register(opvp_hide_chat_frames_match_feature_ctor);
