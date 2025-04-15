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

opvp.SpellExt = opvp.CreateClass(opvp.Spell);

function opvp.SpellExt:init(class, id, mask, auraId)
    opvp.Spell.init(self, id);

    self._class = class;
    self._mask  = mask;

    if opvp.is_number(auraId) == true then
        self._aura_id = auraId;
    elseif bit.band(self._mask, opvp.SpellTrait.AURA) ~= 0 then
        self._aura_id = id;
    else
        self._aura_id = 0;
    end
end

function opvp.SpellExt:aura()
    return self._aura_id;
end

function opvp.SpellExt:class()
    return self._class;
end

function opvp.SpellExt:crowdControlType()
    if self:isCrowdControl() == true then
        return bit.band(self._mask, opvp.SpellTrait.MASK_LOW);
    else
        return opvp.CrowdControlType.NONE
    end
end

function opvp.SpellExt:id()
    return self._id;
end

function opvp.SpellExt:hasRange()
    return bit.band(self._mask, opvp.SpellTrait.RANGE) ~= 0;
end

function opvp.SpellExt:isAura()
    return bit.band(self._mask, opvp.SpellTrait.AURA) ~= 0;
end

function opvp.SpellExt:isBase()
    return bit.band(self._mask, opvp.SpellTrait.BASE) ~= 0;
end

function opvp.SpellExt:isCrowdControl()
    return bit.band(self._mask, opvp.SpellTrait.CROWD_CONTROL) ~= 0;
end

function opvp.SpellExt:isDefensive()
    return bit.band(self._mask, opvp.SpellTrait.DEFENSIVE) ~= 0;
end

function opvp.SpellExt:isExtended()
    return true;
end

function opvp.SpellExt:isHarmful()
    return bit.band(self._mask, opvp.SpellTrait.HARMFUL) ~= 0;
end

function opvp.SpellExt:isHelpful()
    return bit.band(self._mask, opvp.SpellTrait.HELPFUL) ~= 0;
end

function opvp.SpellExt:isHero()
    return bit.band(self._mask, opvp.SpellTrait.HERO);
end

function opvp.SpellExt:isInterupt()
    return bit.band(
        self._mask,
        bit.bor(opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.INTERRUPT)
    ) == opvp.SpellTrait.INTERRUPT
end

function opvp.SpellExt:isOffensive()
    return bit.band(self._mask, opvp.SpellTrait.OFFENSIVE) ~= 0;
end

function opvp.SpellExt:isPassive()
    return bit.band(self._mask, opvp.SpellTrait.PASSIVE) ~= 0;
end

function opvp.SpellExt:isPersonal()
    return bit.band(self._mask, opvp.SpellTrait.PERSONAL) ~= 0;
end

function opvp.SpellExt:isPet()
    return bit.band(self._mask, opvp.SpellTrait.PET) ~= 0;
end

function opvp.SpellExt:isPowerRegen()
    return bit.band(self._mask, opvp.SpellTrait.POWER_REGEN) ~= 0;
end

function opvp.SpellExt:isSpec()
    return bit.band(self._mask, opvp.SpellTrait.SPEC) ~= 0;
end

function opvp.SpellExt:isTalent()
    return bit.band(self._mask, opvp.SpellTrait.TALENT) ~= 0;
end

function opvp.SpellExt:mask()
    return self._mask;
end

function opvp.SpellExt:set(id)

end
