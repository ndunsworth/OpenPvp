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

opvp.MiniMapButton = opvp.CreateClass();

function opvp.MiniMapButton:init()
    self._frame          = nil;
    self._moving         = false;
    self._registered     = false;
    self._position       = 0;
    self._icon           = "";
    self.positionChanged = opvp.Signal("opvp.MiniMapButton.positionChanged");

    self._compartment = {
        text         = "",
        icon         = "",
        notCheckable = true,
        func         = function(_, clickInfo, entry)
                           self:_onMouseClick(clickInfo.buttonName);
                       end,
        funcOnEnter  = function(frame) self:_onEnter(frame); end,
        funcOnLeave  = function(frame) self:_onLeave(frame); end,
    };
end

function opvp.MiniMapButton:isMovable()
    return self._frame:IsMovable();
end

function opvp.MiniMapButton:isMoving()
    return self._moving;
end

function opvp.MiniMapButton:name()
    return self._compartment.text;
end

function opvp.MiniMapButton:position()
    return self._position;
end

function opvp.MiniMapButton:register()
    if self._registered == true then
        return;
    end

    if self._frame == nil then
        self:_initializeWidget();
    end

    AddonCompartmentFrame:RegisterAddon(self._compartment);

    self._registered = true;

    self._frame:Show();
end

function opvp.MiniMapButton:setButtonIcon(icon)
    if icon ~= self._icon then
        self._icon = icon;

        if self._frame ~= nil then
            self._frame:SetNormalTexture(icon);
        end
    end
end

function opvp.MiniMapButton:setCompartmentIcon(icon)
    self._compartment.icon = icon;
end

function opvp.MiniMapButton:setName(name)
    self._compartment.text = name;
end

function opvp.MiniMapButton:setVisible(state)
    if state == true then
        self._frame:Show();
    else
        self._frame:Hide();
    end
end

function opvp.MiniMapButton:setMovable(state)
    self._frame:SetMovable(state);
end

function opvp.MiniMapButton:setPosition(angle)
    if angle == self._position then
        return;
    end

    if self._frame ~= nil then
        self._frame:ClearAllPoints();

        local radius = (Minimap:GetWidth() / 2) + 5;

        self._frame:SetPoint(
            "CENTER",
            Minimap,
            "CENTER",
            radius * cos(angle),
            radius * sin(angle)
        );
    end

    self._position = angle;

    self.positionChanged:emit();
end

function opvp.MiniMapButton:unregister()
    if self._registered == false then
        return;
    end

    local entry;

    for n=1, #AddonCompartmentFrame.registeredAddons do
        entry = AddonCompartmentFrame.registeredAddons[i];

        if entry == self._compartment then
            table.remove(
                AddonCompartmentFrame.registeredAddons,
                n
            );

            AddonCompartmentFrame:UpdateDisplay();

            break;
        end
    end

    self._registered = false;

    self._frame:Hide();
end

function opvp.MiniMapButton:_initializeWidget()
    local button = CreateFrame("Button", self:name() .. "MiniMapButton", Minimap);

    button:SetParent(Minimap);
    button:SetFrameStrata("HIGH");

    button:SetFrameLevel(0);

    button:SetSize(25,25);

    button:SetMovable(true);

    button:SetHighlightTexture("Interface/Minimap/UI-Minimap-ZoomButton-Highlight");

    if self._icon ~= "" then
        button:SetNormalTexture(self._icon);
    end

    local size = 50;

    button.border = CreateFrame("Frame", nil, button);

    button.border:SetSize(size,size);

    button.border:SetPoint("CENTER", button, "CENTER");

    button.border.texture = button.border:CreateTexture();

    button.border.texture:SetSize(size,size);

    button.border.texture:SetPoint("TOPLEFT", 9.5, -9.5);

    button.border.texture:SetTexture("Interface/Minimap/MiniMap-TrackingBorder");

    button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

    button:RegisterForDrag("LeftButton");

    button:SetScript("OnEnter", function(frame) self:_onEnter(self._frame); end);
    button:SetScript("OnLeave", function() self:_onLeave(self._frame); end);
    button:SetScript("OnDragStart", function() self:_onDragBegin(); end);
    button:SetScript("OnDragStop", function() self:_onDragEnd(); end);
    button:SetScript("OnClick", function(frame, button) self:_onMouseClick(button); end);

    self._frame = button;

    local radius = (Minimap:GetWidth() / 2) + 5;

    self._frame:SetPoint(
        "CENTER",
        Minimap,
        "CENTER",
        radius * cos(self._position),
        radius * sin(self._position)
    );
end

function opvp.MiniMapButton:_onDragBegin()
    self._frame:StartMoving();
    self._frame:SetScript("OnUpdate", function() self:_onDragUpdate(); end);

    self._moving = true;
end

function opvp.MiniMapButton:_onDragEnd()
    self._frame:StopMovingOrSizing();
    self._frame:SetScript("OnUpdate", nil);

    self._moving = false;
end

function opvp.MiniMapButton:_onDragUpdate()
    local x, y = GetCursorPosition();
    local scale = UIParent:GetEffectiveScale() or 1;

    x = x / scale;
    y = y / scale;

    local center_x, center_y = Minimap:GetCenter();

    local angle = math.atan2(y - center_y, x - center_x);

    self:setPosition(math.deg(angle));
end

function opvp.MiniMapButton:_onMouseClick(button)
end

function opvp.MiniMapButton:_onEnter(frame)
end

function opvp.MiniMapButton:_onLeave(frame)
end
