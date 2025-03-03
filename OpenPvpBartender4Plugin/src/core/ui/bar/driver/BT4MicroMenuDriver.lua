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

local _, OpenPvpPlugin = ...
local opvpplugin = OpenPvpPlugin;

local opvp = _G.OpenPvp;

local BT4MicroMenu = Bartender4:GetModule("MicroMenu");

opvpplugin.BT4MicroMenuDriver = opvp.CreateClass(opvp.MicroMenuDriver);

function opvpplugin.BT4MicroMenuDriver:init()
    opvp.MicroMenuDriver.init(self);
end

function opvpplugin.BT4MicroMenuDriver:isEnabled()
    return (
        BT4MicroMenu.bar ~= nil and
        BT4MicroMenu.bar.config.enabled == true
    );
end

function opvpplugin.BT4MicroMenuDriver:name()
    return "Bartender4";
end

function opvpplugin.BT4MicroMenuDriver:setEnabled(state)
    if BT4MicroMenu.bar == nil then
        return;
    end

    BT4MicroMenu.bar.config.enabled = state;

    if opvp.system.isLogout() == true then
        return;
    end

    if state == true then
        BT4MicroMenu.bar:Enable();
        BT4MicroMenu:ToggleOptions();
        BT4MicroMenu:ApplyConfig();
        BT4MicroMenu:MicroMenuBarShow();
    else
        BT4MicroMenu.bar:Disable();
        BT4MicroMenu:ToggleOptions();
        BT4MicroMenu:ApplyConfig();
    end
end

local function opvp_bt4_micromenu_init()
    opvp.micromenu.bar():_setDriver(opvpplugin.BT4MicroMenuDriver());
end

opvpplugin.OnAddonLoad:register(opvp_bt4_micromenu_init);
