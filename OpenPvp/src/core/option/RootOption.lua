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
    local major, minor, release = string.match(str, "(%d+)%.(%d+)v(%d+)");

    if major ~= nil then
        return major, minor, release;
    end

    return string.match(str, "(%d+)%.(%d+)");
end

opvp.RootOption = opvp.CreateClass(opvp.OptionCategory);

function opvp.RootOption:init(key, name, description, version)
    opvp.OptionCategory.init(self, key, name, description);

    self._error = "";

    if version ~= nil then
        self._major_ver, self._minor_ver, self._release_ver = parse_version(version);

        if self._major_ver ~= nil then
            self._major_ver   = tonumber(self._major_ver);
            self._minor_ver   = tonumber(self._minor_ver);

            if self._release_ver ~= nil then
                self._release_ver = tonumber(self._release_ver);
            else
                self._release_ver = 1;
            end
        else
            self._major_ver     = 1;
            self._minor_ver     = 0;
            self._release_ver   = 1;
        end
    else
        self._major_ver   = 1;
        self._minor_ver   = 0;
        self._release_ver = 1;
    end

    self._cat_type = opvp.OptionCategory.ROOT_CATEGORY;
end

function opvp.RootOption:clearError()
    self._error = "";
end

function opvp.RootOption:error()
    return self._error;
end

function opvp.RootOption:fromScript(data)
    self:clearError();

    local version = data.version;

    local major_ver, minor_ver;

    if version == nil or opvp.is_str(version) == false then
        self._error = "version not found or is not a string";

        major_ver = self._major_ver;
        minor_ver = self._minor_ver;
    else
        major_ver, minor_ver = parse_version(version);

        if major_ver == nil then
            self._error = "invalid version string " .. version;

            return false;
        end

        major_ver = tonumber(major_ver);
        minor_ver = tonumber(minor_ver);
    end

    opvp.OptionCategory.fromScript(self, data);

    if major_ver > self._major_ver then
        return false;
    else
        return (
            major_ver < self._major_ver or
            minor_ver <= self._minor_ver
        );
    end
end

function opvp.RootOption:hasError()
    return self._error ~= "";
end

function opvp.RootOption:majorVersion()
    return self._major_ver;
end

function opvp.RootOption:minorVersion()
    return self._minor_ver;
end

function opvp.RootOption:releaseVersion()
    return self._release_ver;
end

function opvp.RootOption:toScript()
    local data = opvp.OptionCategory.toScript(self);

    data.version = self:version();

    return data;
end

function opvp.RootOption:version()
    return string.format(
        "%d.%dv%d",
        self._major_ver,
        self._minor_ver,
        self._release_ver
    );
end
