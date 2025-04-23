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

local OPVP_DEF_INDEX = 1;
local OPVP_OFF_INDEX = 2;

local opvp_def_lvl_color_lookup = {
    [0]                                   = {r=0.2,  g=0.2,  b=0.2,  a=1.0},
    [opvp.SpellProperty.DEFENSIVE_LOW]    = {r=0.08, g=0.4,  b=0.08, a=1.0},
    [opvp.SpellProperty.DEFENSIVE_MEDIUM] = {r=0.15, g=0.6,  b=0.15, a=1.0},
    [opvp.SpellProperty.DEFENSIVE_HIGH]   = {r=0.5,  g=1.0,  b=0.5,  a=1.0}
};

local opvp_def_lvl_txt_color_lookup = {
    [0]                                   = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.DEFENSIVE_LOW]    = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.DEFENSIVE_MEDIUM] = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.DEFENSIVE_HIGH]   = {r=0.0, g=0.0, b=0.0, a=1.0}
};

local opvp_off_lvl_color_lookup = {
    [0]                                   = {r=0.2,  g=0.2,  b=0.2, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_LOW]    = {r=0.3,  g=0.08, b=0.08, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_MEDIUM] = {r=0.6,  g=0.15, b=0.15, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_HIGH]   = {r=1.0,  g=0.35, b=0.35, a=1.0}
};

local opvp_off_lvl_txt_color_lookup = {
    [0]                                   = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_LOW]    = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_MEDIUM] = {r=0.9, g=0.9, b=0.9, a=1.0},
    [opvp.SpellProperty.OFFENSIVE_HIGH]   = {r=0.0, g=0.0, b=0.0, a=1.0}
};

local OPVP_FOCUS_INDICATOR_WIDTH = 14;

local SharedMedia = LibStub("LibSharedMedia-3.0");

SharedMedia:Register("font","JetBrainsMono", "Interface/Addons/OpenPvp/data/JetBrainsMono-Regular.ttf");
SharedMedia:Register("font","JetBrainsMono Bold", "Interface/Addons/OpenPvp/data/JetBrainsMono-Bold.ttf");

opvp.CombatLevelIndicator = opvp.CreateClass();

function opvp.CombatLevelIndicator:init(index, frame)
    self._unit_frame  = frame;
    self._index       = index;
    self._active      = false;

    self:_initWidget(frame.healthBar);
end

function opvp.CombatLevelIndicator:isDefensiveEnabled()
    return self._frame.indicators[1].enabled;
end

function opvp.CombatLevelIndicator:isOffensiveEnabled()
    return self._frame.indicators[2].enabled;
end

function opvp.CombatLevelIndicator:isVisible()
    return self._unit_frame:IsVisible();
end

function opvp.CombatLevelIndicator:setDefensiveEnabled(state)
    assert(opvp.is_bool(state));

    self:_setIndicatorEnabled(self._frame.indicators[1], state);
end

function opvp.CombatLevelIndicator:setOffensiveEnabled(state)
    assert(opvp.is_bool(state));

    self:_setIndicatorEnabled(self._frame.indicators[2], state);
end

function opvp.CombatLevelIndicator:unitId()
    return self._unit_frame.unit;
end

function opvp.CombatLevelIndicator:_initWidget(parent)
    local name = "OpenPvpCombatLevelIndicator" .. self._index;

    local frame  = CreateFrame("Frame", name, parent);

    frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 3, 0);
    frame:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 3, -0);
    frame:SetPoint("RIGHT", parent, "RIGHT", 3 + OPVP_FOCUS_INDICATOR_WIDTH, 0);

    frame:SetScript("OnHide", function() self:_onHide(); end);
    frame:SetScript("OnShow", function() self:_onShow(); end);

    frame.horiz_divider = frame:CreateLine(nil, "OVERLAY");

    frame.horiz_divider:SetStartPoint("LEFT", frame);
    frame.horiz_divider:SetEndPoint("RIGHT", frame);

    frame.horiz_divider:SetThickness(1);
    frame.horiz_divider:SetColorTexture(0, 0, 0, 1);

    frame:SetFrameLevel(1);

    frame.indicators = {
        {
            id      = opvp.SpellTrait.DEFENSIVE,
            frame   = CreateFrame("Frame", nil, frame),
            level   = 0,
            enabled = true,
        },
        {
            id      = opvp.SpellTrait.OFFENSIVE,
            frame   = CreateFrame("Frame", nil, frame),
            level   = 0,
            enabled = true,
        }
    };

    local indicator;

    for n=1, 2 do
        indicator = frame.indicators[n];

        indicator.frame:SetFrameLevel(0);

        indicator.fill = indicator.frame:CreateTexture(nil, "BACKGROUND");

        indicator.fill:SetPoint("TOPLEFT", indicator.frame);
        indicator.fill:SetPoint("BOTTOMRIGHT", indicator.frame);

        indicator.label = indicator.frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");

        indicator.label:SetFont(
            SharedMedia:Fetch("font", "JetBrainsMono Bold"),
            8,
            ""
        );

        indicator.label:SetJustifyH("CENTER");
        indicator.label:SetJustifyV("MIDDLE");

        indicator.label:SetPoint("CENTER", indicator.frame);

        indicator.borders = {
            indicator.frame:CreateLine(nil, "BORDER"),
            indicator.frame:CreateLine(nil, "BORDER"),
            indicator.frame:CreateLine(nil, "BORDER")
        };

        for n=1,3 do
            indicator.borders[n]:SetThickness(1);
            indicator.borders[n]:SetColorTexture(0, 0, 0, 1);
        end

        indicator.borders[1]:SetStartPoint("TOPLEFT");
        indicator.borders[1]:SetEndPoint("BOTTOMLEFT");

        indicator.borders[2]:SetStartPoint("TOPRIGHT");
        indicator.borders[2]:SetEndPoint("BOTTOMRIGHT");

        local text;

        if n == 1 then
            indicator.frame:SetPoint("TOPLEFT", frame);
            indicator.frame:SetPoint("TOPRIGHT", frame);
            indicator.frame:SetPoint("BOTTOM", frame, "CENTER");

            indicator.borders[3]:SetStartPoint("TOPLEFT");
            indicator.borders[3]:SetEndPoint("TOPRIGHT");

            indicator.fill_colors = opvp_def_lvl_color_lookup;
            indicator.text_colors = opvp_def_lvl_txt_color_lookup;

            text   = "D\nE\nF";
        else
            indicator.frame:SetPoint("BOTTOMLEFT", frame);
            indicator.frame:SetPoint("BOTTOMRIGHT", frame);
            indicator.frame:SetPoint("TOP", frame, "CENTER");

            indicator.borders[3]:SetStartPoint("BOTTOMLEFT");
            indicator.borders[3]:SetEndPoint("BOTTOMRIGHT");

            indicator.colors = test;

            indicator.fill_colors = opvp_off_lvl_color_lookup;
            indicator.text_colors = opvp_off_lvl_txt_color_lookup;

            text   = "A\nT\nK";
        end

        local color1 = indicator.fill_colors[0];
        local color2 = indicator.text_colors[0];

        indicator.fill:SetColorTexture(color1.r, color1.g, color1.b, color1.a);
        indicator.label:SetTextColor(color2.r, color2.g, color2.b, color2.a);
        indicator.label:SetText(text);
    end

    self._frame = frame;

    if parent:IsVisible() == true then
        self:_onShow();
    end
end

function opvp.CombatLevelIndicator:_indicatorCollapse(indicator)
    if indicator.id == opvp.SpellTrait.DEFENSIVE then
        indicator.frame:SetPoint("BOTTOM", self._frame, "CENTER");

        self._frame.horiz_divider:SetStartPoint("LEFT", self._frame);
        self._frame.horiz_divider:SetEndPoint("RIGHT", self._frame);
    else
        indicator.frame:SetPoint("TOP", self._frame, "CENTER");

        self._frame.horiz_divider:SetStartPoint("LEFT", self._frame);
        self._frame.horiz_divider:SetEndPoint("RIGHT", self._frame);
    end
end

function opvp.CombatLevelIndicator:_indicatorExpand(indicator)
    if indicator.id == opvp.SpellTrait.DEFENSIVE then
        indicator.frame:SetPoint("BOTTOM", self._frame);

        self._frame.horiz_divider:SetStartPoint("BOTTOMLEFT", self._frame);
        self._frame.horiz_divider:SetEndPoint("BOTTOMRIGHT", self._frame);
    else
        indicator.frame:SetPoint("TOP", self._frame);

        self._frame.horiz_divider:SetStartPoint("TOPLEFT", self._frame);
        self._frame.horiz_divider:SetEndPoint("TOPRIGHT", self._frame);
    end
end

function opvp.CombatLevelIndicator:_onHide()
    if (
        self:isDefensiveEnabled() == false and
        self:isOffensiveEnabled() == false
    ) then
        return;
    end

    local tracker = opvp.party.combatLevelTracker();

    if self:isDefensiveEnabled() == true then
        tracker.memberDefensiveLevelUpdate:disconnect(
            self,
            self._onMemberDefensiveLevelUpdate
        );
    end

    if self:isOffensiveEnabled() == true then
        tracker.memberOffensiveLevelUpdate:disconnect(
            self,
            self._onMemberOffensiveLevelUpdate
        );
    end
end

function opvp.CombatLevelIndicator:_onMemberDefensiveLevelUpdate(member, newLevel, oldLevel)
    if opvp.unit.isSameUnit(self:unitId(), member:id()) == true then
        self:_setIndicatorLevel(
            self._frame.indicators[1],
            opvp.DefensiveCombatLevelState:levelForMask(newLevel)
        );
    end
end


function opvp.CombatLevelIndicator:_onMemberOffensiveLevelUpdate(member, newLevel, oldLevel)
    if opvp.unit.isSameUnit(self:unitId(), member:id()) == true then
        self:_setIndicatorLevel(
            self._frame.indicators[2],
            opvp.OffensiveCombatLevelState:levelForMask(newLevel)
        );
    end
end

function opvp.CombatLevelIndicator:_onShow()
    if (
        self:isDefensiveEnabled() == false and
        self:isOffensiveEnabled() == false
    ) then
        return;
    end

    local tracker = opvp.party.combatLevelTracker();

    local member = opvp.party.findMemberByUnitId(self:unitId());

    if member ~= nil then
        self:_setIndicatorLevel(self._frame.indicators[1], member:defensiveLevel());
        self:_setIndicatorLevel(self._frame.indicators[2], member:offensiveLevel());
    end

    if self:isDefensiveEnabled() == true then
        tracker.memberDefensiveLevelUpdate:connect(
            self,
            self._onMemberDefensiveLevelUpdate
        );
    end

    if self:isOffensiveEnabled() == true then
        tracker.memberOffensiveLevelUpdate:connect(
            self,
            self._onMemberOffensiveLevelUpdate
        );
    end
end

function opvp.CombatLevelIndicator:_setIndicatorEnabled(indicator, state)
    if indicator.enabled == state then
        return;
    end

    local tracker = opvp.party.combatLevelTracker();

    indicator.enabled = state;

    if state == true then
        indicator.frame:Show();
    else
        indicator.frame:Hide();
    end

    local buddy;

    if indicator.id == opvp.SpellTrait.DEFENSIVE then
        buddy = self._frame.indicators[2];

        if self:isVisible() == true then
            if state == true then
                tracker.memberDefensiveLevelUpdate:connect(
                    self,
                    self._onMemberDefensiveLevelUpdate
                );
            else
                tracker.memberDefensiveLevelUpdate:disconnect(
                    self,
                    self._onMemberDefensiveLevelUpdate
                );
            end
        end
    else
        buddy = self._frame.indicators[1];

        if self:isVisible() == true then
            if state == true then
                tracker.memberOffensiveLevelUpdate:connect(
                    self,
                    self._onMemberOffensiveLevelUpdate
                );
            else
                tracker.memberOffensiveLevelUpdate:disconnect(
                    self,
                    self._onMemberOffensiveLevelUpdate
                );
            end
        end
    end

    if state == false then
        if buddy.enabled == true then
            self:_indicatorExpand(buddy);
        end
    else
        if buddy.enabled == true then
            self:_indicatorCollapse(indicator);

            self:_indicatorCollapse(buddy);
        else
            self:_indicatorExpand(indicator);
        end
    end
end

function opvp.CombatLevelIndicator:_setIndicatorLevel(indicator, level)
    if level == indicator.level then
        return;
    end

    indicator.level = level;

    local color_fill = indicator.fill_colors[indicator.level];
    local color_text = indicator.text_colors[indicator.level];

    indicator.fill:SetColorTexture(
        color_fill.r,
        color_fill.g,
        color_fill.b,
        color_fill.a
    );

    indicator.label:SetTextColor(
        color_text.r,
        color_text.g,
        color_text.b,
        color_text.a
    );
end

local opvp_combat_lvl_indicators;

local function opvp_combat_lvl_indicator_ctor()
    opvp_combat_lvl_indicators = {
        opvp.CombatLevelIndicator(
            1,
            CompactPartyFrameMember1
        ),
        opvp.CombatLevelIndicator(
            2,
            CompactPartyFrameMember2
        ),
        opvp.CombatLevelIndicator(
            3,
            CompactPartyFrameMember3
        ),
        opvp.CombatLevelIndicator(
            4,
            CompactPartyFrameMember4
        ),
        opvp.CombatLevelIndicator(
            5,
            CompactPartyFrameMember5
        )
    };
end

--~ opvp.OnLoginReload:register(opvp_combat_lvl_indicator_ctor);
