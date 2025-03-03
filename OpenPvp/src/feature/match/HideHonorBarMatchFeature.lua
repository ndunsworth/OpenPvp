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

local opvp_func = StatusTrackingBarManager.CanShowBar;

local function opvp_hook_CanShowBar(self, barIndex)
    if barIndex ~= 2 then
        return opvp_func(self, barIndex);
    else
        return false;
    end
end

opvp.HideHonorBarMatchFeature = opvp.CreateClass(opvp.MatchTypeOptionFeature);

function opvp.HideHonorBarMatchFeature:init(option)
    opvp.MatchTypeOptionFeature.init(self, option);
end

function opvp.HideHonorBarMatchFeature:isActiveMatchStatus(status)
    return (
        status == opvp.MatchStatus.ROUND_ACTIVE or
        status == opvp.MatchStatus.ROUND_COMPLETE or
        status == opvp.MatchStatus.COMPLETE
    );
end

function opvp.HideHonorBarMatchFeature:_onFeatureActivated()
    StatusTrackingBarManager.CanShowBar = opvp_hook_CanShowBar;

    StatusTrackingBarManager:UpdateBarsShown();

    opvp.MatchTypeOptionFeature._onFeatureActivated(self);
end

function opvp.HideHonorBarMatchFeature:_onFeatureDeactivated()
    StatusTrackingBarManager.CanShowBar = opvp_func;

    StatusTrackingBarManager:UpdateBarsShown();

    opvp.MatchTypeOptionFeature._onFeatureDeactivated(self);
end

local opvp_hide_honorbar_match_feature;

local function opvp_hide_honorbar_match_feature_ctor()
    opvp_hide_honorbar_match_feature = opvp.HideHonorBarMatchFeature(
        opvp.options.match.frames.hideHonorBar
    );
end

opvp.OnAddonLoad:register(opvp_hide_honorbar_match_feature_ctor);
