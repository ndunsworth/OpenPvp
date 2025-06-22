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

local function parse_version(str)
    return string.match(str, "(%d+)%.(%d+)");
end

local opvp_opt_db_singleton = nil;
local opvp_opt_db_frame = nil;

opvp.OptionDatabase = opvp.CreateClass();

function opvp.OptionDatabase:instance()
    return opvp_opt_db_singleton;
end

function opvp.OptionDatabase:init(name, description, version)
    self._profile    = opvp.ProfileOption(name, name, description, version);
    self._error      = "";
    self._save_valid = "";

    self._profile:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );
end

function opvp.OptionDatabase:addOption(option)
    return self._profile:root():addOption(option);
end

function opvp.OptionDatabase:clearError()
    return self._profile:root():clearError();
end

function opvp.OptionDatabase:createCategory(key, name, description, categoryType)
    return self._profile:root():createCategory(key, name, description, categoryType);
end

function opvp.OptionDatabase:createOption(optionType, name, description, ...)
    return self._profile:root():createOption(optionType, name, description, ...);
end

function opvp.OptionDatabase:description()
    return self._profile:description();
end

function opvp.OptionDatabase:error()
    return self._profile:root():error();
end

function opvp.OptionDatabase:findOptionWithKey(key)
    return self._profile:root():findOptionWithKey(key);
end

function opvp.OptionDatabase:findOptionWithName(name)
    return self._profile:root():findOptionWithName(name);
end

function opvp.OptionDatabase:fromScript(data)
    return self._profile:fromScript(data);
end

function opvp.OptionDatabase:hasError()
    return self._profile:root():hasError();
end

function opvp.OptionDatabase:isEmpty()
    return self._profile:root():isEmpty();
end

function opvp.OptionDatabase:majorVersion()
    return self._profile:root():majorVersion();
end

function opvp.OptionDatabase:minorVersion()
    return self._profile:root():minorVersion();
end

function opvp.OptionDatabase:name()
    return self._profile:root():name();
end

function opvp.OptionDatabase:profile()
    return self._profile:profileName(self._profile:index());
end

function opvp.OptionDatabase:setProfile(name)
    return self._profile:setProfileByName(name);
end

function opvp.OptionDatabase:options()
    return self._profile:root():options();
end

function opvp.OptionDatabase:profileOption()
    return self._profile;
end

function opvp.OptionDatabase:root()
    return self._profile:root();
end

function opvp.OptionDatabase:size()
    return self._profile:root():size();
end

function opvp.OptionDatabase:toScript()
    return {
        profile  = self._profile:profileName(self._profile:index()),
        profiles = self._profile:toScript()
    }
end

function opvp.OptionDatabase:version()
    return self._profile:root():version();
end

local opvp_save_settings = false;

local function opvp_opt_db_on_login()
    local profile_option = opvp_opt_db_singleton:profileOption();
    local root_option    = opvp_opt_db_singleton:root();
    local profile_name   = "default";

    profile_option:setDefaultData(root_option:toScript());

    if OpenPvpGlobalSettingsDB ~= nil then
        opvp.printDebug("OptionDatabase(global): Loading Saved Settings");

        local valid, err = pcall(opvp.OptionDatabase.fromScript, opvp_opt_db_singleton, OpenPvpGlobalSettingsDB);

        if valid == false then
            opvp.printWarning(
                "OptionDatabase(global):fromScript, %s!",
                err
            );
        else
            opvp_save_settings = opvp.OnAddonLoad:hadErrors() == false;
        end

        opvp.printDebug("OptionDatabase(global): Saved Settings Loaded = %s", tostring(opvp_save_settings));
    end

    if profile_option:isEmpty() == true then
        profile_option:createProfile("default");

        OpenPvpGlobalSettingsDB = opvp_opt_db_singleton:toScript();
    else
        local profile = profile_option:findProfile(
            opvp.private.state.profile:value()
        );

        if profile == nil then
            local index = opvp.private.state.profileIndex:value();

            profile = profile_option:profile(index);
        end

        if profile ~= nil then
            profile_option:setProfile(profile);
        else
            profile_option:setProfileByIndex(1);
        end
    end

    opvp.private.state.profile:setValue(
        profile_option:profileName(profile_option:index())
    );

    opvp.private.state.profileIndex:setValue(
        profile_option:index()
    );

    profile_option.changed:connect(
        function()
            local index = profile_option:index();

            opvp.private.state.profileIndex:setValue(index);

            opvp.private.state.profile:setValue(
                profile_option:profileName(index)
            );
        end
    );

    opvp_opt_db_frame = opvp.OptionDatabaseFrame(opvp_opt_db_singleton);

    opvp_opt_db_frame:register();

    opvp.options.loaded:emit();
end

local function opvp_opt_db_on_logout()
    if opvp_save_settings == true then
        local data = opvp_opt_db_singleton:toScript();

        OpenPvpGlobalSettingsDB = data.profiles;
    end
end

local function opvp_opt_db_ctor()
    opvp_opt_db_singleton = opvp.OptionDatabase(
        opvp.LIB_NAME,
        "",
        opvp.LIB_VERSION
    );

    opvp.event.PLAYER_LOGIN:connect(opvp_opt_db_on_login);

    opvp.OnLogout:connect(opvp_opt_db_on_logout);
end

opvp.OnAddonLoad:register(opvp_opt_db_ctor);
