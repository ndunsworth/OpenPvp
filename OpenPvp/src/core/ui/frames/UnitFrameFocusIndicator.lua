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

local OPVP_FOCUS_INDICATOR_WIDTH = 10;

local SharedMedia = LibStub("LibSharedMedia-3.0");

opvp.UnitFrameFocusIndicator = opvp.CreateClass();

function opvp.UnitFrameFocusIndicator:init(unitId, parent)
    self._id = unitId;

    self:_initWidget(parent);
end

function opvp.UnitFrameFocusIndicator:id()
    return self._id;
end

function opvp.UnitFrameFocusIndicator:_initWidget(parent)
    local name = "OpenPvpArenaFocusIndicator" .. self._id;

    local frame = CreateFrame("Frame", name, parent);
    local fill  = frame:CreateTexture();
    local label = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");

    frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0.5);
    frame:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, -0.5);
    frame:SetPoint("RIGHT", parent, "RIGHT", OPVP_FOCUS_INDICATOR_WIDTH, 0);

    fill:SetColorTexture(0.25, 0.25, 0.25, 1);

    fill:SetPoint("TOPLEFT", frame, "TOPLEFT");
    fill:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT");

    fill.borders = {
        frame:CreateLine(nil, "OVERLAY"),
        frame:CreateLine(nil, "OVERLAY"),
        frame:CreateLine(nil, "OVERLAY"),
        frame:CreateLine(nil, "OVERLAY"),
    };

    fill.borders[1]:SetStartPoint("TOPRIGHT");
    fill.borders[1]:SetEndPoint("BOTTOMRIGHT");

    fill.borders[2]:SetStartPoint("BOTTOMRIGHT");
    fill.borders[2]:SetEndPoint("BOTTOMLEFT");

    fill.borders[3]:SetStartPoint("BOTTOMLEFT");
    fill.borders[3]:SetEndPoint("TOPLEFT");

    fill.borders[4]:SetStartPoint("TOPLEFT");
    fill.borders[4]:SetEndPoint("TOPRIGHT");

    for n=1,4 do
        fill.borders[n]:SetThickness(1);
        fill.borders[n]:SetColorTexture(0, 0, 0, 1);
    end

    label:SetTextColor(0, 0, 0, 0);

    label:SetJustifyH("CENTER");
    label:SetJustifyV("MIDDLE");

    label:SetAllPoints();

    label:SetPoint("CENTER");

    label:SetFont(
        SharedMedia:Fetch("font", "Liberation Mono"),
        9,
        ""
    );

    label:SetText("F\nO\nC\nU\nS");

    frame.fill  = fill;
    frame.label = label;

    frame:SetScript("OnHide", function() self:_onHide(); end);
    frame:SetScript("OnShow", function() self:_onShow(); end);

    self._frame = frame;
end

function opvp.UnitFrameFocusIndicator:_onFocusChanged()
    self:_setFocus(opvp.unit.isSameUnit("focus", self._id));
end

function opvp.UnitFrameFocusIndicator:_onHide()
    self:_setEnabled(false);
end

function opvp.UnitFrameFocusIndicator:_onShow()
    self:_setEnabled(true);
end

function opvp.UnitFrameFocusIndicator:_setEnabled(state)
    if state == true then
        opvp.event.PLAYER_FOCUS_CHANGED:connect(self, self._onFocusChanged);

        self:_setFocus(opvp.unit.isSameUnit("focus", self._id));

        self._frame:SetAlpha(1);
    else
        opvp.event.PLAYER_FOCUS_CHANGED:disconnect(self, self._onFocusChanged);

        self._frame:SetAlpha(0);
    end
end

function opvp.UnitFrameFocusIndicator:_setFocus(state)
    if state == true then
        self._frame.label:SetTextColor(0, 0, 0, 1);
        self._frame.fill:SetColorTexture(1, .61, 0.2, 1);
    else
        local r, g, b, a = 0.0, 0.0, 0.0, 0.5;

        self._frame.label:SetTextColor(0, 0, 0, 0);
        self._frame.fill:SetColorTexture(r * 0.35, g * 0.35, b * 0.35, 0.5);
    end
end
