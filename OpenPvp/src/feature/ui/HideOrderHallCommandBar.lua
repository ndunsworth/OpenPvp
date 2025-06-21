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

local function setOrderHallCommandBarDisabled(state)
    if (
        OrderHallCommandBar == nil or
        C_Garrison.IsPlayerInGarrison(Enum.GarrisonType.Type_7_0_Garrison) == false
    ) then
        return;
    end

    if state == true then
        OrderHallCommandBar:Hide();
    else
        OrderHallCommandBar:Show();
    end
end

local function opvp_orderhall_on_show()
    if opvp.options.interface.frames.orderHallCommandBarHide:value() == true then
        setOrderHallCommandBarDisabled(true);
    end
end

local function opvp_orderhall_ui_addon_loaded()
    hooksecurefunc(
        OrderHallCommandBar,
        "Show",
        opvp_orderhall_on_show
    );

    if OrderHallCommandBar:IsShown() == true then
        opvp_orderhall_on_show();
    end
end

local function opvp_addon_loaded(addon)
    if addon == "Blizzard_OrderHallUI" then
        opvp_orderhall_ui_addon_loaded();
    end
end

local function hide_orderhall_command_bar_hide_init()
    opvp.options.interface.frames.orderHallCommandBarHide.changed:connect(
        setOrderHallCommandBarDisabled
    );

    if C_AddOns.IsAddOnLoaded("Blizzard_OrderHallUI") == false then
        opvp.event.ADDON_LOADED:connect(
            opvp_addon_loaded
        );
    else
        opvp_orderhall_ui_addon_loaded();
    end
end

opvp.OnAddonLoad:register(hide_orderhall_command_bar_hide_init);
