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
    AURA          = bit.lshift(1,  0),
    BASE          = bit.lshift(1,  1),
    CHARGES       = bit.lshift(1,  2),
    CROWD_CONTROL = bit.lshift(1,  3),
    DEFENSIVE     = bit.lshift(1,  4),
    DEBUFF        = bit.lshift(1,  5),
    DISPELL       = bit.lshift(1,  6),
    HARMFUL       = bit.lshift(1,  7),
    HELPFUL       = bit.lshift(1,  8),
    HERO          = bit.lshift(1,  9),
    IMMUNITY      = bit.lshift(1, 10),
    INTERRUPT     = bit.lshift(1, 11),
    OFFENSIVE     = bit.lshift(1, 12),
    PASSIVE       = bit.lshift(1, 13),
    PET           = bit.lshift(1, 14),
    POWER_REGEN   = bit.lshift(1, 15),
    PVP           = bit.lshift(1, 16),
    RACIAL        = bit.lshift(1, 17),
    RAID          = bit.lshift(1, 18),
    RANGE         = bit.lshift(1, 19),
    SNARE         = bit.lshift(1, 20),
    SPEC          = bit.lshift(1, 21),
    TALENT        = bit.lshift(1, 22)
};

opvp.SpellProperty = {
    --~ These need to line up with opvp.CrowdControlType
    DISARM                     = bit.lshift(1,  0),
    DISORIENT                  = bit.lshift(1,  1),
    INCAPACITATE               = bit.lshift(1,  2),
    KNOCKBACK                  = bit.lshift(1,  3),
    ROOT                       = bit.lshift(1,  4),
    SILENCE                    = bit.lshift(1,  5),
    STUN                       = bit.lshift(1,  6),
    TAUNT                      = bit.lshift(1,  7),

    NO_DR                      = bit.lshift(1,  8),

    DEFENSIVE_LOW              = bit.lshift(1,  9),
    DEFENSIVE_MEDIUM           = bit.lshift(1, 10),
    DEFENSIVE_HIGH             = bit.lshift(1, 11),

    OFFENSIVE_LOW              = bit.lshift(1, 12),
    OFFENSIVE_MEDIUM           = bit.lshift(1, 13),
    OFFENSIVE_HIGH             = bit.lshift(1, 14),

    PHYSICAL_REDUCTION         = bit.lshift(1, 15),
    MAGIC_REDUCTION            = bit.lshift(1, 16),

    DISARM_IMMUNITY            = bit.lshift(1, 17),
    DISORIENT_IMMUNITY         = bit.lshift(1, 18),
    INCAPACITATE_IMMUNITY      = bit.lshift(1, 19),
    KNOCKBACK_IMMUNITY         = bit.lshift(1, 20),
    MAGIC_IMMUNITY             = bit.lshift(1, 21),
    PYHSICAL_IMMUNITY          = bit.lshift(1, 22),
    ROOT_IMMUNITY              = bit.lshift(1, 23),
    SILENCE_IMMUNITY           = bit.lshift(1, 24),
    STUN_IMMUNITY              = bit.lshift(1, 25),
    TAUNT_IMMUNITY             = bit.lshift(1, 26),

};

opvp.SpellTrait.BASE_TALENT                = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.TALENT);
opvp.SpellTrait.HERO_TALENT                = bit.bor(opvp.SpellTrait.HERO, opvp.SpellTrait.TALENT);
opvp.SpellTrait.SPEC_TALENT                = bit.bor(opvp.SpellTrait.SPEC, opvp.SpellTrait.TALENT);

opvp.SpellTrait.HARMFUL_AURA               = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.HARMFUL);
opvp.SpellTrait.HELPFUL_AURA               = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.HELPFUL);
opvp.SpellTrait.HELPFUL_IMMUNITY           = bit.bor(opvp.SpellTrait.HELPFUL_AURA, opvp.SpellTrait.IMMUNITY);

opvp.SpellTrait.DEFENSIVE_AURA             = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.DEFENSIVE);
opvp.SpellTrait.DEFENSIVE_IMMUNITY         = bit.bor(opvp.SpellTrait.DEFENSIVE, opvp.SpellTrait.IMMUNITY);
opvp.SpellTrait.DEFENSIVE_IMMUNITY_AURA    = bit.bor(opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellTrait.IMMUNITY);
opvp.SpellTrait.OFFENSIVE_AURA             = bit.bor(opvp.SpellTrait.AURA, opvp.SpellTrait.OFFENSIVE);
opvp.SpellTrait.OFFENSIVE_IMMUNITY         = bit.bor(opvp.SpellTrait.OFFENSIVE, opvp.SpellTrait.IMMUNITY);
opvp.SpellTrait.OFFENSIVE_IMMUNITY_AURA    = bit.bor(opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellTrait.IMMUNITY);
opvp.SpellTrait.DEFENSIVE_OFFENSIVE        = bit.bor(opvp.SpellTrait.DEFENSIVE, opvp.SpellTrait.OFFENSIVE);

opvp.SpellTrait.CROWD_CONTROL_AURA         = bit.bor(opvp.SpellTrait.HARMFUL_AURA, opvp.SpellTrait.CROWD_CONTROL);
opvp.SpellTrait.INTERRUPT                  = bit.bor(opvp.SpellTrait.HARMFUL, opvp.SpellTrait.INTERRUPT);
opvp.SpellTrait.SNARE_AURA                 = bit.bor(opvp.SpellTrait.HARMFUL_AURA, opvp.SpellTrait.SNARE);

opvp.SpellTrait.RAID_BUFF                  = bit.bor(opvp.SpellTrait.HELPFUL_AURA, opvp.SpellTrait.RAID);

opvp.SpellProperty.ROOT_NO_DR              = bit.bor(opvp.SpellProperty.ROOT, opvp.SpellProperty.NO_DR);
opvp.SpellProperty.STUN_NO_DR              = bit.bor(opvp.SpellProperty.STUN, opvp.SpellProperty.NO_DR);

opvp.SpellProperty.CROWD_CONTROL_ALL       = bit.bor(
                                                 opvp.SpellProperty.DISARM,
                                                 opvp.SpellProperty.DISORIENT,
                                                 opvp.SpellProperty.INCAPACITATE,
                                                 opvp.SpellProperty.KNOCKBACK,
                                                 opvp.SpellProperty.ROOT,
                                                 opvp.SpellProperty.SILENCE,
                                                 opvp.SpellProperty.STUN,
                                                 opvp.SpellProperty.TAUNT
                                           );

opvp.SpellProperty.DEFENSIVE_ALL           = bit.bor(
                                                 opvp.SpellProperty.DEFENSIVE_LOW,
                                                 opvp.SpellProperty.DEFENSIVE_MEDIUM,
                                                 opvp.SpellProperty.DEFENSIVE_HIGH
                                           );

opvp.SpellProperty.IMMUNITY_CC             = bit.bor(
                                                 opvp.SpellProperty.DISARM_IMMUNITY,
                                                 opvp.SpellProperty.DISORIENT_IMMUNITY,
                                                 opvp.SpellProperty.INCAPACITATE_IMMUNITY,
                                                 opvp.SpellProperty.KNOCKBACK_IMMUNITY,
                                                 opvp.SpellProperty.ROOT_IMMUNITY,
                                                 opvp.SpellProperty.SILENCE_IMMUNITY,
                                                 opvp.SpellProperty.STUN_IMMUNITY,
                                                 opvp.SpellProperty.TAUNT_IMMUNITY
                                           );

opvp.SpellProperty.IMMUNITY_DMG            = bit.bor(opvp.SpellProperty.MAGIC_IMMUNITY, opvp.SpellProperty.PYHSICAL_IMMUNITY);

opvp.SpellProperty.IMMUNITY_ALL            = bit.bor(
                                                 opvp.SpellProperty.IMMUNITY_CC,
                                                 opvp.SpellProperty.IMMUNITY_DMG
                                           );

opvp.SpellProperty.OFFENSIVE_ALL           = bit.bor(
                                                 opvp.SpellProperty.OFFENSIVE_LOW,
                                                 opvp.SpellProperty.OFFENSIVE_MEDIUM,
                                                 opvp.SpellProperty.OFFENSIVE_HIGH
                                           );

opvp.SpellProperty.DEFENSIVE_IMMUNE        = bit.lshift(
                                                 opvp.SpellProperty.DEFENSIVE_HIGH,
                                                 opvp.SpellProperty.IMMUNITY_ALL
                                           );

opvp.SpellProperty.DEFENSIVE_IMMUNE_CC     = bit.lshift(
                                                 opvp.SpellProperty.DEFENSIVE_LOW,
                                                 opvp.SpellProperty.IMMUNITY_CC
                                           );

opvp.SpellProperty.DEFENSIVE_IMMUNE_DMG    = bit.lshift(
                                                 opvp.SpellProperty.DEFENSIVE_HIGH,
                                                 opvp.SpellProperty.IMMUNITY_CC
                                           );

opvp.SpellProperty.OFFENSIVE_IMMUNE        = bit.lshift(
                                                 opvp.SpellProperty.OFFENSIVE_HIGH,
                                                 opvp.SpellProperty.IMMUNITY_ALL
                                           );

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

function opvp.Spell:clone()
    return opvp.Spell(self._id);
end

function opvp.Spell:description()
    return C_Spell.GetSpellDescription(self._id);
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

opvp.spell = {};

function opvp.spell.isPvpRacialTrinket(spellId)
    return (
        spellId == 7744 or
        spellId == 59752
    );
end

function opvp.spell.isPvpTrinket(spellId)
    return (
        spellId == 336126 or
        spellId == 336135
    );
end
