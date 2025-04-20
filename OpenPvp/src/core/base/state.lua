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

opvp.DEBUG = false;

local opvp_state_db_singleton;
local opvp_save_settings = false;

local function opvp_state_db_on_login()
    if OpenPvpLocalSettingsDB ~= nil then
        if (
            OpenPvpLocalSettingsDB.Debug ~= nil and
            opvp.is_bool(OpenPvpLocalSettingsDB.Debug) == true
        ) then
            opvp.DEBUG = OpenPvpLocalSettingsDB.Debug;
        end

        opvp.printDebug("OptionDatabase(local): Loading Saved Settings");

        local valid, err = pcall(opvp_state_db_singleton.fromScript, opvp_state_db_singleton, OpenPvpLocalSettingsDB);

        if valid == false then
            opvp.printWarning(
                "OptionDatabase(local):fromScript, %s!",
                err
            );
        else
            opvp_save_settings = opvp.OnAddonLoad:hadErrors() == false;
        end

        opvp.printDebug("OptionDatabase(local): Saved Settings Loaded = %s", tostring(opvp_save_settings));
    else
        OpenPvpLocalSettingsDB = opvp_state_db_singleton:toScript();
    end
end

local function opvp_state_db_on_logout()
    if opvp_save_settings == true then
        OpenPvpLocalSettingsDB = opvp_state_db_singleton:toScript();
    end
end

local function opvp_state_db_ctor()
    opvp_state_db_singleton = opvp.RootOption(
        "OpenPvp",
        "OpenPvp",
        "",
        opvp.VERSION
    );

    opvp.event.PLAYER_LOGIN:connect(opvp_state_db_on_login);

    opvp.OnLogout:connect(opvp_state_db_on_logout);

    opvp.private.state.category = opvp_state_db_singleton;

    opvp.private.state.debug = opvp.private.state.category:createOption(
        opvp.Option.BOOL,
        "Debug",
        "Debug"
    );

    opvp.private.state.debug.changed:connect(
        function(state)
            opvp.DEBUG = state;
        end
    );

    opvp.private.state.profile = opvp.private.state.category:createOption(
        opvp.Option.STRING,
        "Profile",
        "Profile",
        "",
        "default"
    );

    opvp.private.state.profileIndex = opvp.private.state.category:createOption(
        opvp.Option.INT,
        "ProfileIndex",
        "ProfileIndex",
        "",
        1
    );

    opvp.private.state.party = {};

    opvp.private.state.party.category = opvp.private.state.category:createCategory(
        "Party",
        "Party"
    );

    opvp.private.state.party.homeGuid = opvp.private.state.party.category:createOption(
        opvp.Option.STRING,
        "HomeGuid",
        "HomeGuid"
    );

    opvp.private.state.party.instanceGuid = opvp.private.state.party.category:createOption(
        opvp.Option.STRING,
        "InstanceGuid",
        "InstanceGuid"
    );

    opvp.private.state.system = {};

    opvp.private.state.system.category = opvp.private.state.category:createCategory(
        "System",
        "System"
    );

    opvp.private.state.system.lastLoginTime = opvp.private.state.system.category:createOption(
        opvp.Option.FLOAT,
        "LastLoginTime",
        "LastLoginTime",
        "",
        0
    );

    opvp.private.state.system.lastLogoutTime = opvp.private.state.system.category:createOption(
        opvp.Option.FLOAT,
        "LastLogoutTime",
        "LastLogoutTime",
        "",
        0
    );

    opvp.private.state.ui = {};

    opvp.private.state.ui.category = opvp.private.state.category:createCategory(
        "Ui",
        "Ui"
    );

    opvp.private.state.ui.restore = {}

    opvp.private.state.ui.restore.category = opvp.private.state.ui.category:createCategory(
        "Restore",
        "Restore"
    );

    opvp.private.state.ui.restore.chat = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "Chat",
        "Chat"
    );

    opvp.private.state.ui.restore.actionbar1 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar1",
        "ActionBar1"
    );

    opvp.private.state.ui.restore.actionbar2 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar2",
        "ActionBar2"
    );

    opvp.private.state.ui.restore.actionbar3 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar3",
        "ActionBar3"
    );

    opvp.private.state.ui.restore.actionbar4 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar4",
        "ActionBar4"
    );

    opvp.private.state.ui.restore.actionbar5 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar5",
        "ActionBar5"
    );

    opvp.private.state.ui.restore.actionbar6 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar6",
        "ActionBar6"
    );

    opvp.private.state.ui.restore.actionbar7 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar7",
        "ActionBar7"
    );

    opvp.private.state.ui.restore.actionbar8 = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "ActionBar8",
        "ActionBar8"
    );

    opvp.private.state.ui.restore.bagbar = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "BagBar",
        "BagBar"
    );

    opvp.private.state.ui.restore.layout = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.INT,
        "Layout",
        "Layout",
        "",
        0
    );

    opvp.private.state.ui.restore.microMenu = opvp.private.state.ui.restore.category:createOption(
        opvp.Option.BOOL,
        "MicroMenu",
        "MicroMenu"
    );
end

opvp.OnAddonLoad:register(opvp_state_db_ctor);
