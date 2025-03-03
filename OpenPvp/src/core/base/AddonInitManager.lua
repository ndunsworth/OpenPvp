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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.AddonInitManager = opvp.CreateClass(opvp.SignalInitManager);

function opvp.AddonInitManager:init(name)
    opvp.SignalInitManager.init(self, name, opvp.event.ADDON_LOADED);
end

function opvp.AddonInitManager:activated(addon)
    return addon == self:name();
end

function opvp.LoadingScreenBeginInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.LOADING_SCREEN_ENABLED
    );
end

function opvp.LoadingScreenEndInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.LOADING_SCREEN_DISABLED
    );
end

function opvp.LoginInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.PLAYER_ENTERING_WORLD_LOGIN
    );
end

function opvp.LoginInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.PLAYER_ENTERING_WORLD_LOGIN
    );
end

function opvp.LoginReloadInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.PLAYER_ENTERING_WORLD_LOGIN_RELOAD
    );
end

function opvp.ReloadInitManager(name)
    return opvp.SignalInitManager(
        name,
        opvp.event.PLAYER_ENTERING_WORLD_RELOAD
    );
end

local opvp_init_mgr            = opvp.AddonInitManager("OpenPvp");
local opvp_load_scrn_begin_mgr = opvp.SingleShotSignal("OpenPvp.OnLoadingScreenBegin", opvp.event.LOADING_SCREEN_ENABLED);
local opvp_load_scrn_end_mgr   = opvp.SingleShotSignal("OpenPvp.OnLoadingScreenEnd", opvp.event.LOADING_SCREEN_DISABLED);
local opvp_login_mgr           = opvp.LoginInitManager("OpenPvp.OnLogin");
local opvp_login_reload_mgr    = opvp.LoginReloadInitManager("OpenPvp.OnLoginReload");
local opvp_reload_mgr          = opvp.ReloadInitManager("OpenPvp.OnReload");
local opvp_logout_mgr          = opvp.SingleShotSignal("OpenPvp.OnLogout", opvp.event.PLAYER_LOGOUT, true);

opvp.OnAddonLoad            = opvp_init_mgr;
opvp.OnLogin                = opvp_login_mgr;
opvp.OnLoginReload          = opvp_login_reload_mgr;
opvp.OnReload               = opvp_reload_mgr;
opvp.OnLogout               = opvp_logout_mgr;
opvp.OnLoadingScreenBegin   = opvp_load_scrn_begin_mgr;
opvp.OnLoadingScreenEnd     = opvp_load_scrn_end_mgr;
