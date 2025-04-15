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

local OPVP_SPELL_POOL_DEFAULT_SIZE = 100;

local opvp_spell_pool = nil;

opvp.SpellTrait = {
    AURA          = bit.lshift(1,  8),
    BASE          = bit.lshift(1,  9),
    CHARGES       = bit.lshift(1, 10),
    CROWD_CONTROL = bit.lshift(1, 11),
    DEFENSIVE     = bit.lshift(1, 12),
    HARMFUL       = bit.lshift(1, 13),
    HELPFUL       = bit.lshift(1, 14),
    HERO          = bit.lshift(1, 15),
    OFFENSIVE     = bit.lshift(1, 16),
    PASSIVE       = bit.lshift(1, 17),
    PERSONAL      = bit.lshift(1, 18),
    PET           = bit.lshift(1, 19),
    POWER_REGEN   = bit.lshift(1, 20),
    RAID          = bit.lshift(1, 21),
    RANGE         = bit.lshift(1, 22),
    SNARE         = bit.lshift(1, 23),
    SPEC          = bit.lshift(1, 24),
    TALENT        = bit.lshift(1, 25),

    INTERRUPT     = bit.lshift(1,  0),

    LOW           = bit.lshift(1,  0),
    MEDIUM        = bit.lshift(1,  1),
    HIGH          = bit.lshift(1,  2),

    DISARM        = bit.lshift(1,  0),
    DISORIENT     = bit.lshift(1,  1),
    INCAPACITATE  = bit.lshift(1,  2),
    KNOCKBACK     = bit.lshift(1,  3),
    ROOT          = bit.lshift(1,  4),
    SILENCE       = bit.lshift(1,  5),
    STUN          = bit.lshift(1,  6),
    TAUNT         = bit.lshift(1,  7)
};

opvp.SpellTrait.RAID_BUFF                  = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.RAID);
opvp.SpellTrait.MASK_LOW                   = 255;
opvp.SpellTrait.BASE_TALENT                = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.TALENT);
opvp.SpellTrait.HERO_TALENT                = bit.bor(opvp.SpellTrait.HERO, opvp.SpellTrait.TALENT);
opvp.SpellTrait.SPEC_TALENT                = bit.bor(opvp.SpellTrait.SPEC, opvp.SpellTrait.TALENT);
opvp.SpellTrait.DISARM_CROWD_CONTROL       = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.DISARM);
opvp.SpellTrait.DISORIENT_CROWD_CONTROL    = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.DISORIENT);
opvp.SpellTrait.INCAPACITATE_CROWD_CONTROL = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.INCAPACITATE);
opvp.SpellTrait.KNOCKBACK_CROWD_CONTROL    = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.KNOCKBACK);
opvp.SpellTrait.ROOT_CROWD_CONTROL         = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.ROOT);
opvp.SpellTrait.SILENCE_CROWD_CONTROL      = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.SILENCE);
opvp.SpellTrait.STUN_CROWD_CONTROL         = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.STUN);
opvp.SpellTrait.TAUNT_CROWD_CONTROL        = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellTrait.TAUNT);

opvp.Spell = opvp.CreateClass();

function opvp.Spell:acquire(id)
    local spell = opvp_spell_pool:acquire();

    if spell ~= nil then
        return spell;
    end

    opvp.printDebug(
        "opvp.Spell.acquire, growing pool %d->%d",
        opvp_spell_pool:size(),
        opvp_spell_pool:size() * 2
    );

    opvp_spell_pool:setSize(opvp_spell_pool:size() * 2);

    return opvp_spell_pool:acquire();
end

function opvp.Spell:reduce()
    local cur_size = opvp_spell_pool:size();

    if cur_size == OPVP_SPELL_POOL_DEFAULT_SIZE then
        return;
    end

    local size = math.floor(cur_size / 2);

    if opvp_spell_pool:available() >= size then
        opvp.printDebug(
            "opvp.Spell.reduce, shrinking pool %d->%d",
            cur_size,
            size
        );

        opvp_spell_pool:setSize(size);
    end
end

function opvp.Spell:release(spell)
    if spell:isExtended() == false then
        opvp_spell_pool:release(spell);
    end
end

function opvp.Spell:init(id)
    if opvp.is_number(id) then
        self._id = id;
    else
        self._id = 0;
    end
end

function opvp.Spell:castCount()
    return C_Spell.GetSpellCastCount(self._id);
end

function opvp.Spell:charges()
    return self:chargesInfo().currentCharges;
end

function opvp.Spell:chargesInfo()
    local info = C_Spell.GetSpellCharges(self._id);

    if info ~= nil then
        return info;
    else
        return {
            currentCharges    = 0,
            maxCharges        = 0,
            cooldownStartTime = 0,
            cooldownDuration  = 0,
            chargeModRate     = 0
        };
    end
end

function opvp.Spell:chargesMaximum()
    return self:chargesInfo().maxCharges;
end

function opvp.Spell:hasRange()
    return C_Spell.SpellHasRange(self._id);
end

function opvp.Spell:id()
    if self._id >= 0 then
        return self._id;
    else
        return -self._id;
    end
end

function opvp.Spell:isCached()
    return C_Spell.IsSpellDataCached(self._id);
end

function opvp.Spell:isDisabled()
    return C_Spell.IsSpellDisabled(self._id);
end

function opvp.Spell:isExtended()
    return false;
end

function opvp.Spell:isHarmful()
    return C_Spell.IsSpellHarmful(self._id);
end

function opvp.Spell:isHelpful()
    return C_Spell.IsSpellHelpful(self._id);
end

function opvp.Spell:isInRange(target)
    return C_Spell.IsSpellInRange(self._id, target);
end

function opvp.Spell:isNull()
    return self._id == 0;
end

function opvp.Spell:isTalent()
    return C_Spell.IsClassTalentSpell(self._id);
end

function opvp.Spell:isValid()
    return self._id > 0;
end

function opvp.Spell:isPassive()
    return C_Spell.IsSpellPassive(self._id);
end

function opvp.Spell:isUsable()
    return C_Spell.IsSpellUsable(self._id);
end

function opvp.Spell:name()
    return C_Spell.GetSpellName(self._id);
end

function opvp.Spell:set(id)
    if id == nil then
        id = 0;
    else
        assert(opvp.is_number(id));

        if C_Spell.DoesSpellExist(id) == false then
            id = -id;
        end
    end

    self._id = id;
end

function opvp.Spell:texture()
    return C_Spell.GetSpellTexture(self._id);
end
