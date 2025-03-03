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

local opvp_system_singleton;

opvp.SystemStatus = {
    NONE   = 0,
    LOGIN  = 1,
    RELOAD = 2,
    LOGOUT = 3
};

opvp.System = opvp.CreateClass();

function opvp.System:instance()
    return opvp_system_singleton;
end

function opvp.System:init()
    self._last_login_time = 0;
    self._login_time      = 0;
    self._reload_time     = 0;
    self._load_state      = opvp.SystemStatus.NONE;
    self._vars_loaded     = false;

    opvp.event.PLAYER_LOGOUT:connect(self, self._onLogout);
    opvp.event.VARIABLES_LOADED:connect(self, self._onVarsLoaded);
end

function opvp.System:isLastLoginValid()
    return self._last_login_time ~= 0;
end

function opvp.System:isLoading()
    return self._load_state ~= opvp.SystemStatus.NONE;
end

function opvp.System:isLogin()
    return self._load_state == opvp.SystemStatus.LOGIN;
end

function opvp.System:isLogout()
    return self._load_state == opvp.SystemStatus.LOGOUT;
end

function opvp.System:isReload()
    return self._load_state == opvp.SystemStatus.RELOAD;
end

function opvp.System:isVarsLoaded()
    return self._vars_loaded;
end

function opvp.System:lastLoginTime()
    return self._last_login_time;
end

function opvp.System:lastReloadTime()
    return self._reload_time;
end

function opvp.System:loginTime()
    return self._login_time;
end

function opvp.System:sessionTime()
    return GetServerTime() - self._login_time;
end

function opvp.System:_onLoadBegin()
    self._load_state = opvp.SystemStatus.LOGIN;

    opvp.private.state.system.lastLoginTime:setValue(
        opvp.private.state.system.lastLogoutTime:value()
    );

    self._last_login_time = opvp.private.state.system.lastLoginTime:value();

    self._login_time = GetServerTime();

    self._reload_time = self._login_time;
end

function opvp.System:_onLoadEnd()
    self._load_state = opvp.SystemStatus.NONE;
end

function opvp.System:_onLogout()
    self._load_state = opvp.SystemStatus.LOGOUT;

    opvp.private.state.system.lastLogoutTime:setValue(self._login_time);
end

function opvp.System:_onReloadBegin()
    self._load_state      = opvp.SystemStatus.RELOAD;
    self._reload_time     = GetServerTime();

    self._last_login_time = opvp.private.state.system.lastLoginTime:value();
    self._login_time      = opvp.private.state.system.lastLogoutTime:value();
end

function opvp.System:_onReloadEnd()
    self._load_state = opvp.SystemStatus.NONE;
end

function opvp.System:_onVarsLoaded()
    self._vars_loaded = true;
end

opvp.system = {};

function opvp.system.isLoading()
    return opvp_system_singleton:isLoading();
end

function opvp.system.isLogin()
    return opvp_system_singleton:isLogin();
end

function opvp.system.isLogout()
    return opvp_system_singleton:isLogout();
end

function opvp.system.isReload()
    return opvp_system_singleton:isReload();
end

function opvp.system.isVarsLoaded()
    return opvp_system_singleton:isVarsLoaded();
end

function opvp.system.lastLoginTime()
    return opvp_system_singleton:lastLoginTime();
end

function opvp.system.lastReloadTime()
    return opvp_system_singleton:lastReloadTime();
end

function opvp.system.loginTime()
    return opvp_system_singleton:loginTime();
end

function opvp.system.sessionTime()
    return opvp_system_singleton:sessionTime();
end

local function opvp_system_singleton_ctor()
    opvp_system_singleton = opvp.System();
end

opvp_system_singleton_ctor();
