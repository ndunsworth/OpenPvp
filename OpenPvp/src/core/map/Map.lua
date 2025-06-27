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

opvp.MapType = {
    UNKNOWN   = -1,
    CONTINENT = Enum.UIMapType.Continent,
    COSMIC    = Enum.UIMapType.Cosmic,
    DUNGEON   = Enum.UIMapType.Dungeon,
    MICRO     = Enum.UIMapType.Micro,
    ORPHAN    = Enum.UIMapType.Orphan,
    WORLD     = Enum.UIMapType.World,
    ZONE      = Enum.UIMapType.Zone
};

opvp.Map = opvp.CreateClass();

function opvp.Map:init(id)
    self._id     = opvp.number_else(id);
    self._name   = "";
    self._parent = 0;
    self._flags  = 0;
    self._type   = opvp.MapType.UNKNOWN;
end

function opvp.Map:description()
    return "";
end

function opvp.Map:flags()
    return self._flags;
end

function opvp.Map:group()
    return C_Map.GetMapGroupID(self._id);
end

function opvp.Map:hasArt()
    return C_Map.MapHasArt(self._id) == true;
end

function opvp.Map:hasParent()
    return self:parent() ~= 0;
end

function opvp.Map:id()
    return self._id;
end

function opvp.Map:isCity()
    return C_Map.IsCityMap(self._id) == true;
end

function opvp.Map:isNull()
    return self._id == 0;
end

function opvp.Map:name()
    self:_fetchInfo();

    return self._name;
end

function opvp.Map:parent()
    self:_fetchInfo();

    return self._parent;
end

function opvp.Map:playerLevelInfo()
    local
    playerMinLevel,
    playerMaxLevel,
    petMinLevel,
    petMaxLevel = C_Map.GetMapLevels(self._map_id);

    if playerMinLevel ~= nil then
        return {
            player_min_level = playerMinLevel,
            player_max_level = playerMaxLevel,
            pet_min_level    = petMinLevel,
            pet_max_level    = petMaxLevel
        };
    else
        return {
            player_min_level = 0,
            player_max_level = 0,
            pet_min_level    = 0,
            pet_max_level    = 0
        };
    end
end

function opvp.Map:preload()
    C_Map.RequestPreloadMap(self._id);
end

function opvp.Map:size()
    local width, height = C_Map.GetMapWorldSize(self._id);

    return CreateVector2D(
        opvp.number_else(width),
        opvp.number_else(height)
    );
end

function opvp.Map:toStript()
    return {
        id = self._id
    };
end

function opvp.Map:type()
    self:_fetchInfo();

    return self._type;
end

function opvp.Map:_fetchInfo()
    if self._fetched == true then
        return;
    end

    local info = C_Map.GetMapInfo(self._id);

    if info ~= nil then
        self._flags  = opvp.number_else(info.mapType);
        self._name   = opvp.str_else(info.name);
        self._parent = opvp.number_else(info.parentMapID);
        self._type   = opvp.number_else(info.mapType);
    else
        self._flags  = 0;
        self._name   = "";
        self._parent = 0;
        self._type   = opvp.MapType.UNKNOWN;
    end
end

opvp.Map.UNKNOWN = opvp.Map();
