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

local opvp_role_id_lookup;
local opvp_role_token_lookup;

opvp.RoleType = {
    NONE   = 0,
    DPS    = 1,
    HEALER = 2,
    TANK   = 4,
    ALL    = 7
};

opvp.Role = opvp.CreateClass();

function opvp.Role:fromRoleId(id)
    local role = opvp_role_id_lookup[id];

    if role ~= nil then
        return role;
    else
        return opvp.Role.NONE;
    end
end

function opvp.Role:fromRoleToken(name)
    local role = opvp_role_token_lookup[name];

    if role ~= nil then
        return role;
    else
        return opvp.Role.NONE;
    end
end

function opvp.Role:init(id, name, token, icon, iconMarkup)
    self._id          = id;
    self._name        = name;
    self._token       = token;
    self._icon        = icon;
    self._icon_markup = iconMarkup;
end

function opvp.Role:icon()
    return self._icon;
end

function opvp.Role:iconMarkup()
    return self._icon_markup;
end

function opvp.Role:id()
    return self._id;
end

function opvp.Role:isAny(mask)
    return bit.band(mask, self._id) ~= 0;
end

function opvp.Role:isDps()
    return self._id == opvp.RoleType.DPS;
end

function opvp.Role:isHealer()
    return self._id == opvp.RoleType.HEALER;
end

function opvp.Role:isNull()
    return self._id == opvp.RoleType.NONE;
end

function opvp.Role:isTank()
    return self._id == opvp.RoleType.TANK;
end

function opvp.Role:isValid()
    return self._id ~= opvp.RoleType.NONE;
end

function opvp.Role:name()
    return self._name;
end

function opvp.Role:token()
    return self._token;
end

function opvp.Role:setUnit(unitId)
    return UnitSetRole(unitId, self._token);
end

opvp.Role.NONE    = opvp.Role(opvp.RoleType.NONE, "", "NONE", "", "");
opvp.Role.DPS     = opvp.Role(opvp.RoleType.DPS, DAMAGER, "DAMAGER", "UI-Frame-DpsIcon", opvp.utils.textureAtlasMarkup("UI-Frame-DpsIcon"));
opvp.Role.HEALER  = opvp.Role(opvp.RoleType.HEALER, HEALER, "HEALER", "UI-Frame-HealerIcon", opvp.utils.textureAtlasMarkup("UI-Frame-HealerIcon"));
opvp.Role.TANK    = opvp.Role(opvp.RoleType.TANK, TANK, "TANK", "UI-Frame-TankIcon", opvp.utils.textureAtlasMarkup("UI-Frame-TankIcon"));

opvp.Role.ROLES = {
    opvp.Role.NONE,
    opvp.Role.DPS,
    opvp.Role.HEALER,
    opvp.Role.TANK
};

opvp_role_id_lookup = {
    [opvp.RoleType.NONE]   = opvp.Role.DPS,
    [opvp.RoleType.DPS]    = opvp.Role.DPS,
    [opvp.RoleType.HEALER] = opvp.Role.HEALER,
    [opvp.RoleType.TANK]   = opvp.Role.TANK
};

opvp_role_token_lookup = {
    ["NONE"]    = opvp.Role.DPS,
    ["DAMAGER"] = opvp.Role.DPS,
    ["HEALER"]  = opvp.Role.HEALER,
    ["TANK"]    = opvp.Role.TANK,
};
