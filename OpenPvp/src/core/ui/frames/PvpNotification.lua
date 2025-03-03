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

opvp.PvpNotification = opvp.CreateClass();

function opvp.PvpNotification:init(name)
    self._frame = CreateFrame("Button", name, UIParent);
    self._anim_type   = 0;
    self._anim_start  = 0;
    self._anim_length = 0.25;
    self._anim_timer  = opvp.Timer(4);

    self._anim_timer.timeout:connect(self, self.hide);
    self._anim_timer:setTriggerLimit(1);

    self:_initWidget();
end

function opvp.PvpNotification:_initWidget()
    self._frame.bg = self._frame:CreateTexture();

    self._frame.header = self._frame:CreateFontString(nil, "OVERLAY", "QuestFontNormalHuge");
    self._frame.footer = self._frame:CreateFontString(nil, "OVERLAY", "GameTooltipText");

    self._frame.header:SetJustifyH("CENTER");
    self._frame.footer:SetJustifyH("CENTER");

    self._frame.bg:SetPoint("TOPLEFT", self._frame);
    self._frame.bg:SetPoint("BOTTOMRIGHT", self._frame);

    self._frame.header:SetPoint("LEFT", self._frame);
    self._frame.header:SetPoint("RIGHT", self._frame);
    self._frame.header:SetPoint("TOP", self._frame, "CENTER", 0, 25);
    self._frame.header:SetPoint("BOTTOM", self._frame, "CENTER");

    self._frame.footer:SetPoint("LEFT", self._frame);
    self._frame.footer:SetPoint("RIGHT", self._frame);
    self._frame.footer:SetPoint("TOP", self._frame, "CENTER");
    self._frame.footer:SetPoint("BOTTOM", self._frame, "CENTER", 0, -30);

    self._frame:SetPoint("CENTER", 0, 0);
    self._frame:SetPoint("TOP", ZoneTextFrame, "BOTTOM");

    self._frame:SetFrameStrata("LOW");

    self._frame:RegisterForClicks("LeftButtonUp");

    self._frame:SetScript("OnClick", function(frame, button) self:hide(); end);

    self._frame:SetSize(467, 141);

    self._frame:Hide();

    self:setFaction(opvp.player.faction());
end

function opvp.PvpNotification:exec(header, footer)
    if header == nil then
        header = "";
    end

    if footer == nil then
        footer = "";
    end

    self:setHeader(header);
    self:setFooter(footer);

    self:show();
end

function opvp.PvpNotification:hide()
    if (
        self:isVisible() == true and
        self._anim_type ~= -1
    ) then
        self:_beginHide();
    end
end

function opvp.PvpNotification:isVisible()
    return self._frame:IsVisible();
end

function opvp.PvpNotification:setFaction(faction)
    if faction == opvp.ALLIANCE then
        self._frame.bg:SetAtlas("AllianceScenario-TitleBG");
    else
        self._frame.bg:SetAtlas("HordeScenario-TitleBG");
    end
end

function opvp.PvpNotification:setHeader(text)
    self._frame.header:SetText(text);
end

function opvp.PvpNotification:setFooter(text)
    self._frame.footer:SetText(text);
end

function opvp.PvpNotification:show()
    if self._anim_type ~= 1 then
        self:_beginShow();
    end

    --~ PlaySoundFile(642845, opvp.SoundChannel.SFX);
    --~ PlaySound(8232, opvp.SoundChannel.SFX, false);
end

function opvp.PvpNotification:_beginHide()
    if self._anim_type == 0 then
        self._frame:SetScript("OnUpdate", function() self:_onUpdate() end);

        self._anim_start = GetTime();
    elseif self._anim_type == 1 then
        self._anim_timer:stop();
    end

    self._anim_type = -1;
end

function opvp.PvpNotification:_beginShow()
    if self._anim_type == 0 then
        self._frame:SetScript("OnUpdate", function() self:_onUpdate() end);

        self._frame:SetAlpha(0);

        self._frame:Show();

        self._anim_start = GetTime();
    end

    self._anim_timer:stop();

    self._anim_type = 1;
end

function opvp.PvpNotification:_endHide()
    self._frame:Hide();
end

function opvp.PvpNotification:_endShow()
    self._anim_timer:start();

    PlaySound(26905, opvp.SoundChannel.SFX, false);
end

function opvp.PvpNotification:_onUpdate()
    local alpha = self._frame:GetAlpha();
    local diff  = (GetTime() - self._anim_start);
    local finished;

    if diff > 0 then
        diff = opvp.math.clamp(
            diff / self._anim_length,
            0,
            1
        );
    end

    if self._anim_type == 1 then
        alpha = opvp.math.lerp(0, 1, diff);

        finished = alpha == 1;
    else
        alpha = opvp.math.lerp(1, 0, diff);

        finished = alpha == 0;
    end

    self._frame:SetAlpha(alpha);

    if finished == true then
        self._frame:SetScript("OnUpdate", nil);

        if self._anim_type == -1 then
            self:_endHide();
        else
            self:_endShow();
        end

        self._anim_type = 0;
    end
end
