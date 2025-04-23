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

local opvp_null_spell;

opvp.SpellExt = opvp.CreateClass(opvp.Spell);

function opvp.SpellExt:null()
    return opvp_null_spell;
end

function opvp.SpellExt:init(class, id, traits, props, duration, pvpMult)
    opvp.Spell.init(self, id);

    self._class    = class;
    self._traits   = opvp.number_else(traits);
    self._props    = opvp.number_else(props);
    self._duration = opvp.number_else(duration);
    self._pvp_mult = opvp.number_else(pvpMult, 1);
end

function opvp.SpellExt:class()
    return self._class;
end

function opvp.SpellExt:clone()
    return self;
end

function opvp.SpellExt:crowdControlCategory()
    return opvp.CrowdControlCategory:fromType(self:crowdControlType());
end

function opvp.SpellExt:crowdControlType()
    return bit.band(self._props, opvp.SpellProperty.CROWD_CONTROL_ALL);
end

function opvp.SpellExt:defensiveLevel()
    return bit.band(self._props, opvp.SpellProperty.DEFENSIVE_ALL);
end

function opvp.SpellExt:duration()
    return self._duration;
end

function opvp.SpellExt:durationPvp()
    return self._duration * self._pvp_mult;
end

function opvp.SpellExt:hasRange()
    return bit.band(self._traits, opvp.SpellTrait.RANGE) ~= 0;
end

function opvp.SpellExt:hasNoDr()
    return bit.band(self._traits, opvp.SpellProperty.NO_DR) ~= 0;
end

function opvp.SpellExt:id()
    return self._id;
end

function opvp.SpellExt:immunities()
    return bit.band(self._props, opvp.SpellProperty.IMMUNITY_ALL);
end

function opvp.SpellExt:isAura()
    return bit.band(self._traits, opvp.SpellTrait.AURA) ~= 0;
end

function opvp.SpellExt:isBase()
    return bit.band(self._traits, opvp.SpellTrait.BASE) ~= 0;
end

function opvp.SpellExt:isDefensiveOrOffensive()
    return bit.band(self._traits, opvp.SpellTrait.DEFENSIVE_OFFENSIVE) ~= 0;
end

function opvp.SpellExt:isCrowdControl()
    return bit.band(self._traits, opvp.SpellTrait.CROWD_CONTROL) ~= 0;
end

function opvp.SpellExt:isDefensive()
    return bit.band(self._traits, opvp.SpellTrait.DEFENSIVE) ~= 0;
end

function opvp.SpellExt:isExtended()
    return true;
end

function opvp.SpellExt:isHarmful()
    return bit.band(self._traits, opvp.SpellTrait.HARMFUL) ~= 0;
end

function opvp.SpellExt:isHelpful()
    return bit.band(self._traits, opvp.SpellTrait.HELPFUL) ~= 0;
end

function opvp.SpellExt:isHero()
    return bit.band(self._traits, opvp.SpellTrait.HERO);
end

function opvp.SpellExt:isImmunity()
    return bit.band(self._traits, opvp.SpellTrait.IMMUNITY) ~= 0;
end

function opvp.SpellExt:isInterupt()
    return bit.band(self._traits, opvp.SpellTrait.INTERRUPT) ~= 0;
end

function opvp.SpellExt:isOffensive()
    return bit.band(self._traits, opvp.SpellTrait.OFFENSIVE) ~= 0;
end

function opvp.SpellExt:isPassive()
    return bit.band(self._traits, opvp.SpellTrait.PASSIVE) ~= 0;
end

function opvp.SpellExt:isPet()
    return bit.band(self._traits, opvp.SpellTrait.PET) ~= 0;
end

function opvp.SpellExt:isPowerRegen()
    return bit.band(self._traits, opvp.SpellTrait.POWER_REGEN) ~= 0;
end

function opvp.SpellExt:isPvpTalent()
    return bit.band(self._traits, opvp.SpellTrait.PVP) ~= 0;
end

function opvp.SpellExt:isSpec()
    return bit.band(self._traits, opvp.SpellTrait.SPEC) ~= 0;
end

function opvp.SpellExt:isTalent()
    return bit.band(self._traits, opvp.SpellTrait.TALENT) ~= 0;
end

function opvp.SpellExt:offensiveLevel()
    return bit.band(self._props, opvp.SpellProperty.OFFENSIVE_ALL);
end

function opvp.SpellExt:properties()
    return self._props;
end

function opvp.SpellExt:pvpMultiplier()
    return self._pvp_mult;
end

function opvp.SpellExt:set(id)

end

function opvp.SpellExt:traits()
    return self._traits;
end

opvp_null_spell = opvp.SpellExt(0, 0, opvp.SpellTrait.AURA);
