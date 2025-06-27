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

opvp.private.HideVigorPowerBarFeature = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.HideVigorPowerBarFeature:init(option, mask, affiliation)
    opvp.OptionFeature.init(self, option);

    self._handler = opvp.HideFrameHandler(
        UIWidgetPowerBarContainerFrame,
        opvp.HideFrameHandler.VISIBILITY
    );
end

function opvp.private.HideVigorPowerBarFeature:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.HideVigorPowerBarFeature:_onFeatureActivated()
    opvp.OptionFeature._onFeatureActivated(self);

    opvp.player.instance().skyRidingChanged:connect(
        self._handler,
        self._handler.setEnabled
    );

    self._handler:setEnabled(opvp.player.isSkyRiding());
end

function opvp.private.HideVigorPowerBarFeature:_onFeatureDeactivated()
    opvp.OptionFeature._onFeatureDeactivated(self);

    opvp.player.instance().skyRidingChanged:disconnect(
        self._handler,
        self._handler.setEnabled
    );

    self._handler:setEnabled(false);
end

local hide_vigor_power_bar_singleton;

local function hide_vigor_power_bar_singleton_ctor()
    hide_vigor_power_bar_singleton = opvp.private.HideVigorPowerBarFeature(
        opvp.options.interface.frames.vigorPowerBarHide
    );
end

opvp.OnAddonLoad:register(hide_vigor_power_bar_singleton_ctor);
