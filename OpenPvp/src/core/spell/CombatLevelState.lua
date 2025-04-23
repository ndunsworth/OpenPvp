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

opvp.CombatLevelState = opvp.CreateClass();

function opvp.CombatLevelState:init()
    self._mask  = 0;
end

function opvp.CombatLevelState:level()
    return self:levelForMask(self._mask);
end

function opvp.CombatLevelState:levelName()
    return self:nameForMask(self._mask);
end

function opvp.CombatLevelState:levelForMask(mask)
    return 0;
end

function opvp.CombatLevelState:nameForMask(mask)
    return "";
end

function opvp.CombatLevelState:_onAuraAdded(aura, spell)
    local cur_level  = self:levelForMask(self._mask);
    local aura_level = self:levelForMask(spell:properties());

    if aura_level == 0 then
        return cur_level, cur_level;
    end

    local level_map = self._levels[aura_level];

    if level_map == nil or level_map:add(aura) == false then
        return cur_level, cur_level;
    end

    self._mask = bit.bor(self._mask, aura_level);

    return self:levelForMask(self._mask), cur_level;
end

function opvp.CombatLevelState:_onAuraUpdated(aura, spell)
    return self:_onAuraAdded(aura, spell);
end

function opvp.CombatLevelState:_onAuraRemoved(aura, spell)
    local cur_level  = self:levelForMask(self._mask);
    local aura_level = self:levelForMask(spell:properties());

    if aura_level == 0 then
        return cur_level, cur_level;
    end

    local level_map = self._levels[aura_level];

    if level_map == nil then
        return cur_level, cur_level;
    end

    if (
        level_map:remove(aura) == false or
        level_map:isEmpty() == false
    ) then
        return cur_level, cur_level;
    end

    self._mask = bit.band(self._mask, bit.bnot(aura_level));

    return self:levelForMask(self._mask), cur_level;
end

function opvp.CombatLevelState:_clear()
    for k, level in pairs(self._levels) do
        level:clear();
    end
end

opvp.DefensiveCombatLevelState = opvp.CreateClass(opvp.CombatLevelState);

function opvp.DefensiveCombatLevelState:init()
    opvp.CombatLevelState.init(self);

    self._levels = {
        [opvp.SpellProperty.DEFENSIVE_LOW]    = opvp.AuraMap(),
        [opvp.SpellProperty.DEFENSIVE_MEDIUM] = opvp.AuraMap(),
        [opvp.SpellProperty.DEFENSIVE_HIGH]   = opvp.AuraMap()
    };
end

function opvp.DefensiveCombatLevelState:levelForMask(mask)
    if mask == 0 then
        return 0;
    elseif bit.band(mask, opvp.SpellProperty.DEFENSIVE_HIGH) ~= 0 then
        return opvp.SpellProperty.DEFENSIVE_HIGH;
    elseif bit.band(mask, opvp.SpellProperty.DEFENSIVE_MEDIUM) ~= 0 then
        return opvp.SpellProperty.DEFENSIVE_MEDIUM;
    else
        return opvp.SpellProperty.DEFENSIVE_LOW;
    end
end

function opvp.DefensiveCombatLevelState:nameForMask(mask)
    if mask == 0 then
        return "";
    elseif bit.band(mask, opvp.SpellProperty.DEFENSIVE_HIGH) ~= 0 then
        return opvp.strs.HIGH;
    elseif bit.band(mask, opvp.SpellProperty.DEFENSIVE_MEDIUM) ~= 0 then
        return opvp.strs.MEDIUM;
    else
        return opvp.strs.LOW;
    end
end

opvp.OffensiveCombatLevelState = opvp.CreateClass(opvp.CombatLevelState);

function opvp.OffensiveCombatLevelState:init()
    opvp.CombatLevelState.init(self);

    self._levels = {
        [opvp.SpellProperty.OFFENSIVE_LOW]    = opvp.AuraMap(),
        [opvp.SpellProperty.OFFENSIVE_MEDIUM] = opvp.AuraMap(),
        [opvp.SpellProperty.OFFENSIVE_HIGH]   = opvp.AuraMap()
    };
end

function opvp.OffensiveCombatLevelState:levelForMask(mask)
    if mask == 0 then
        return 0;
    elseif bit.band(mask, opvp.SpellProperty.OFFENSIVE_HIGH) ~= 0 then
        return opvp.SpellProperty.OFFENSIVE_HIGH;
    elseif bit.band(mask, opvp.SpellProperty.OFFENSIVE_MEDIUM) ~= 0 then
        return opvp.SpellProperty.OFFENSIVE_MEDIUM;
    else
        return opvp.SpellProperty.OFFENSIVE_LOW;
    end
end

function opvp.OffensiveCombatLevelState:nameForMask(mask)
    if mask == 0 then
        return "";
    elseif bit.band(mask, opvp.SpellProperty.OFFENSIVE_HIGH) ~= 0 then
        return opvp.strs.HIGH;
    elseif bit.band(mask, opvp.SpellProperty.OFFENSIVE_MEDIUM) ~= 0 then
        return opvp.strs.MEDIUM;
    else
        return opvp.strs.LOW;
    end
end
