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

opvp.private.LayoutMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.LayoutMatchFeature:init(option, pvpType)
    opvp.MatchOptionFeature.init(self, option);

    self._match_mask = pvpType;
    self._changing   = false;
    self._layout     = nil;
end

function opvp.private.LayoutMatchFeature:isFeatureEnabled()
    return self:option():index() > 1;
end

function opvp.private.LayoutMatchFeature:name()
    if self._match_mask == opvp.PvpType.ARENA then
        return opvp.strs.LAYOUT_ARENA;
    else
        return opvp.strs.LAYOUT_BATTLEGROUND;
    end
end

function opvp.private.LayoutMatchFeature:_changeLayout(index)
    local layout = opvp.layout.layout(index);

    if layout == nil then
        return;
    end

    self._changing = true;

    layout:load();

    self._changing = false;
end

function opvp.private.LayoutMatchFeature:_onFeatureActivated()
    opvp.layout.changed:connect(self, self._onLayoutChanged);

    opvp.private.state.ui.restore.layout:setValue(
        opvp.layout.activeIndex()
    );

    self:_changeLayout(self:option():index() - 1);

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.LayoutMatchFeature:_onFeatureDeactivated()
    opvp.layout.changed:disconnect(self, self._onLayoutChanged);

    local index = opvp.private.state.ui.restore.layout:value();

    if index ~= 0 then
        if opvp.layout.activeIndex() == self._layout then
            self:_changeLayout(index);
        end

        opvp.private.state.ui.restore.layout:setValue(0);
    end

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

function opvp.private.LayoutMatchFeature:_onLayoutChanged(layout)
    local index = layout:index();

    if (
        self._changing == true or
        index == self:option():index() - 1
    ) then
        self._layout = index;
    else
        self._layout = 0;
    end
end

function opvp.private.LayoutMatchFeature:_onOptionChanged()
    opvp.MatchOptionFeature._onOptionChanged(self);

    if opvp.match.inMatch() == false or self:isActive() == false then
        return;
    end

    local index = self:option():index() - 1;
    local layout = opvp.layout:active();

    if layout ~= nil and layout:index() ~= index then
        self:_changeLayout(index);
    end
end

local opvp_arena_layout_match_feature;
local opvp_bg_layout_match_feature;

local function opvplayout_match_feature_ctor()
    opvp_arena_layout_match_feature = opvp.private.LayoutMatchFeature(
        opvp.options.match.layout.layoutArena,
        opvp.PvpType.ARENA
    );

    opvp_bg_layout_match_feature = opvp.private.LayoutMatchFeature(
        opvp.options.match.layout.layoutBattleground,
        opvp.PvpType.BATTLEGROUND
    );
end

opvp.OnAddonLoad:register(opvplayout_match_feature_ctor);
