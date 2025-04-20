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

opvp.RoleMaskOption = opvp.CreateClass(opvp.BitMaskOption);

function opvp.RoleMaskOption:init(key, name, description, value)
    opvp.BitMaskOption.init(self, key, name, description, 3, 3, value);
end

function opvp.RoleMaskOption:isDpsEnabled()
    return self:isBitEnabled(opvp.RoleType.DPS);
end

function opvp.RoleMaskOption:isHealerEnabled()
    return self:isBitEnabled(opvp.RoleType.HEALER);
end

function opvp.RoleMaskOption:isTankEnabled()
    return self:isBitEnabled(opvp.RoleType.TANK);
end

function opvp.RoleMaskOption:isRoleEnabled(role)
    if opvp.is_number(role) == true then
        return self:isBitEnabled(role);
    elseif opvp.IsInstance(role, opvp.Role) == true then
        return self:isBitEnabled(role:id());
    else
        return false;
    end
end

function opvp.RoleMaskOption:labelForIndex(index)
    if index > 0 and index <= 3 then
        local role = opvp.Role.ROLES[index + 1];

        assert(role ~= nil);

        return role:iconMarkup() .. " " .. role:name();
    else
        return "";
    end
end

function opvp.RoleMaskOption:setDpsEnabled(state)
    self:setBits(opvp.RoleType.DPS, state);
end

function opvp.RoleMaskOption:setHealerEnabled(state)
    self:setBits(opvp.RoleType.HEALER, state);
end

function opvp.RoleMaskOption:setTankEnabled(state)
    self:setBits(opvp.RoleType.TANK, state);
end

function opvp.RoleMaskOption:type()
    return opvp.RoleMaskOption.TYPE;
end

local function create_rolemask_option(...)
    return opvp.RoleMaskOption(...);
end

opvp.RoleMaskOption.TYPE = opvp.OptionType("rolemask", create_rolemask_option);
