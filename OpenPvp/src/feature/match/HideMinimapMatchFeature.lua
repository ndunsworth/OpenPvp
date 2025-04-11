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

opvp.private.HideMinimapMatchFeature = opvp.CreateClass(opvp.MatchTypeOptionFeature);

function opvp.private.HideMinimapMatchFeature:init(option)
    opvp.MatchTypeOptionFeature.init(self, option);
end

function opvp.private.HideMinimapMatchFeature:isActiveMatchStatus(status)
    return (
        status == opvp.MatchStatus.ROUND_ACTIVE or
        status == opvp.MatchStatus.ROUND_COMPLETE or
        status == opvp.MatchStatus.COMPLETE
    );
end

function opvp.private.HideMinimapMatchFeature:_onFeatureActivated()
    if Minimap:IsShown() == true then
        ToggleMinimap();

        self._restore = true;
    end

    opvp.MatchTypeOptionFeature._onFeatureActivated(self);
end

function opvp.private.HideMinimapMatchFeature:_onFeatureDeactivated()
    if self._restore == true and Minimap:IsShown() == false then
        ToggleMinimap();
    end

    self._restore = false;

    opvp.MatchTypeOptionFeature._onFeatureDeactivated(self);
end

local opvp_hide_minimap_match_feature;

local function opvp_hide_minimap_match_feature_ctor()
    opvp_hide_minimap_match_feature = opvp.private.HideMinimapMatchFeature(
        opvp.options.match.frames.hideMinimap
    );
end

opvp.OnAddonLoad:register(opvp_hide_minimap_match_feature_ctor);
