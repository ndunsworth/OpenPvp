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

local opvp_dispell_type_name_lookup = {
    [opvp.DispellType.BLEED]   = opvp.strs.BLEED,
    [opvp.DispellType.CURSE]   = opvp.strs.CURSE,
    [opvp.DispellType.DISEASE] = opvp.strs.DISEASE,
    [opvp.DispellType.ENRAGE]  = opvp.strs.ENRAGE,
    [opvp.DispellType.MAGIC]   = opvp.strs.MAGIC,
    [opvp.DispellType.POISON]  = opvp.strs.POISON,
}

local OPVP_SPELL_POOL_DEFAULT_SIZE = 100;

local opvp_spell_pool = nil;

opvp.SpellProperty = {
    AURA             = bit.lshift(1,  0),
    BASE             = bit.lshift(1,  1),
    CAST             = bit.lshift(1,  2),
    CHARGES          = bit.lshift(1,  3),
    CROWD_CONTROL    = bit.lshift(1,  4),
    DEFENSIVE        = bit.lshift(1,  5),
    DEBUFF           = bit.lshift(1,  6),
    DISPELL          = bit.lshift(1,  7),
    HARMFUL          = bit.lshift(1,  8),
    HELPFUL          = bit.lshift(1,  9),
    HERO             = bit.lshift(1, 10),
    IMMUNITY         = bit.lshift(1, 11),
    INTERRUPT        = bit.lshift(1, 12),
    OFFENSIVE        = bit.lshift(1, 13),
    PASSIVE          = bit.lshift(1, 14),
    PET              = bit.lshift(1, 15),
    POWER_REGEN      = bit.lshift(1, 16),
    PVP              = bit.lshift(1, 17),
    RACIAL           = bit.lshift(1, 18),
    RAID             = bit.lshift(1, 19),
    RANGE            = bit.lshift(1, 20),
    SNARE            = bit.lshift(1, 21),
    SPEC             = bit.lshift(1, 22),
    TALENT           = bit.lshift(1, 23),

    DEFENSIVE_LOW    = bit.lshift(1, 24),
    DEFENSIVE_MEDIUM = bit.lshift(1, 25),
    DEFENSIVE_HIGH   = bit.lshift(1, 26),

    OFFENSIVE_LOW    = bit.lshift(1, 27),
    OFFENSIVE_MEDIUM = bit.lshift(1, 28),
    OFFENSIVE_HIGH   = bit.lshift(1, 29),
};

opvp.CrowdControlSpellProperty = {
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

    DISARM_IMMUNITY            = bit.lshift(1,  9),
    DISORIENT_IMMUNITY         = bit.lshift(1, 10),
    INCAPACITATE_IMMUNITY      = bit.lshift(1, 11),
    INTERRUPT_IMMUNITY         = bit.lshift(1, 12),
    KNOCKBACK_IMMUNITY         = bit.lshift(1, 13),
    MAGIC_IMMUNITY             = bit.lshift(1, 14),
    PYHSICAL_IMMUNITY          = bit.lshift(1, 15),
    ROOT_IMMUNITY              = bit.lshift(1, 16),
    SILENCE_IMMUNITY           = bit.lshift(1, 17),
    STUN_IMMUNITY              = bit.lshift(1, 18),
    TAUNT_IMMUNITY             = bit.lshift(1, 19),

    DISARM_REDUCTION           = bit.lshift(1, 20),
    DISORIENT_REDUCTION        = bit.lshift(1, 21),
    INCAPACITATE_REDUCTION     = bit.lshift(1, 22),
    INTERRUPT_REDUCTION        = bit.lshift(1, 23),
    KNOCKBACK_REDUCTION        = bit.lshift(1, 24),
    MAGIC_REDUCTION            = bit.lshift(1, 25),
    PYHSICAL_REDUCTION         = bit.lshift(1, 26),
    ROOT_REDUCTION             = bit.lshift(1, 27),
    SILENCE_REDUCTION          = bit.lshift(1, 28),
    STUN_REDUCTION             = bit.lshift(1, 29),
    TAUNT_REDUCTION            = bit.lshift(1, 30),
};

opvp.SpellProperty.BASE_TALENT                     = bit.bor(opvp.SpellProperty.BASE, opvp.SpellProperty.TALENT);
opvp.SpellProperty.HERO_TALENT                     = bit.bor(opvp.SpellProperty.HERO, opvp.SpellProperty.TALENT);
opvp.SpellProperty.SPEC_TALENT                     = bit.bor(opvp.SpellProperty.SPEC, opvp.SpellProperty.TALENT);

opvp.SpellProperty.HARMFUL_AURA                    = bit.bor(opvp.SpellProperty.AURA, opvp.SpellProperty.HARMFUL);
opvp.SpellProperty.HELPFUL_AURA                    = bit.bor(opvp.SpellProperty.AURA, opvp.SpellProperty.HELPFUL);
opvp.SpellProperty.HELPFUL_IMMUNITY                = bit.bor(opvp.SpellProperty.HELPFUL_AURA, opvp.SpellProperty.IMMUNITY);

opvp.SpellProperty.DEFENSIVE_AURA                  = bit.bor(opvp.SpellProperty.AURA, opvp.SpellProperty.DEFENSIVE);
opvp.SpellProperty.DEFENSIVE_LOW_AURA              = bit.bor(opvp.SpellProperty.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW);
opvp.SpellProperty.DEFENSIVE_MEDIUM_AURA           = bit.bor(opvp.SpellProperty.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_MEDIUM);
opvp.SpellProperty.DEFENSIVE_HIGH_AURA             = bit.bor(opvp.SpellProperty.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_HIGH);
opvp.SpellProperty.DEFENSIVE_IMMUNITY              = bit.bor(opvp.SpellProperty.DEFENSIVE, opvp.SpellProperty.IMMUNITY);
opvp.SpellProperty.DEFENSIVE_IMMUNITY_AURA         = bit.bor(opvp.SpellProperty.DEFENSIVE_AURA, opvp.SpellProperty.IMMUNITY);
opvp.SpellProperty.DEFENSIVE_LOW_IMMUNITY_AURA     = bit.bor(opvp.SpellProperty.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_LOW);
opvp.SpellProperty.DEFENSIVE_MEDIUM_IMMUNITY_AURA  = bit.bor(opvp.SpellProperty.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_MEDIUM);
opvp.SpellProperty.DEFENSIVE_HIGH_IMMUNITY_AURA    = bit.bor(opvp.SpellProperty.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_HIGH);

opvp.SpellProperty.OFFENSIVE_AURA                  = bit.bor(opvp.SpellProperty.AURA, opvp.SpellProperty.OFFENSIVE);
opvp.SpellProperty.OFFENSIVE_LOW_AURA              = bit.bor(opvp.SpellProperty.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_LOW);
opvp.SpellProperty.OFFENSIVE_MEDIUM_AURA           = bit.bor(opvp.SpellProperty.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_MEDIUM);
opvp.SpellProperty.OFFENSIVE_HIGH_AURA             = bit.bor(opvp.SpellProperty.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH);
opvp.SpellProperty.OFFENSIVE_IMMUNITY              = bit.bor(opvp.SpellProperty.OFFENSIVE, opvp.SpellProperty.IMMUNITY);
opvp.SpellProperty.OFFENSIVE_IMMUNITY_AURA         = bit.bor(opvp.SpellProperty.OFFENSIVE_HIGH_AURA, opvp.SpellProperty.IMMUNITY);

opvp.SpellProperty.DEFENSIVE_OFFENSIVE             = bit.bor(opvp.SpellProperty.DEFENSIVE, opvp.SpellProperty.OFFENSIVE);

opvp.SpellProperty.DEFENSIVE_OFFENSIVE_AURA          = bit.bor(opvp.SpellProperty.AURA, opvp.SpellProperty.DEFENSIVE_OFFENSIVE);
opvp.SpellProperty.DEFENSIVE_OFFENSIVE_LOW_AURA      = bit.bor(opvp.SpellProperty.DEFENSIVE_OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_LOW, opvp.SpellProperty.DEFENSIVE_LOW);
opvp.SpellProperty.DEFENSIVE_OFFENSIVE_MEDIUM_AURA   = bit.bor(opvp.SpellProperty.DEFENSIVE_OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_MEDIUM, opvp.SpellProperty.DEFENSIVE_MEDIUM);
opvp.SpellProperty.DEFENSIVE_OFFENSIVE_HIGH_AURA     = bit.bor(opvp.SpellProperty.DEFENSIVE_OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH, opvp.SpellProperty.DEFENSIVE_HIGH);
opvp.SpellProperty.DEFENSIVE_OFFENSIVE_IMMUNITY      = bit.bor(opvp.SpellProperty.DEFENSIVE_OFFENSIVE, opvp.SpellProperty.IMMUNITY);
opvp.SpellProperty.DEFENSIVE_OFFENSIVE_IMMUNITY_AURA = bit.bor(opvp.SpellProperty.DEFENSIVE_OFFENSIVE_HIGH_AURA, opvp.SpellProperty.IMMUNITY);

opvp.SpellProperty.HARMFUL_CROWD_CONTROL           = bit.bor(opvp.SpellProperty.HARMFUL, opvp.SpellProperty.CROWD_CONTROL);
opvp.SpellProperty.CROWD_CONTROL_AURA              = bit.bor(opvp.SpellProperty.HARMFUL_AURA, opvp.SpellProperty.CROWD_CONTROL);
opvp.SpellProperty.INTERRUPT                       = bit.bor(opvp.SpellProperty.HARMFUL, opvp.SpellProperty.INTERRUPT);
opvp.SpellProperty.SNARE_AURA                      = bit.bor(opvp.SpellProperty.HARMFUL_AURA, opvp.SpellProperty.SNARE);

opvp.SpellProperty.RAID_BUFF                       = bit.bor(opvp.SpellProperty.HELPFUL_AURA, opvp.SpellProperty.RAID);

opvp.SpellProperty.DEFENSIVE_ALL                   = bit.bor(
                                                         opvp.SpellProperty.DEFENSIVE_LOW,
                                                         opvp.SpellProperty.DEFENSIVE_MEDIUM,
                                                         opvp.SpellProperty.DEFENSIVE_HIGH
                                                   );

opvp.SpellProperty.OFFENSIVE_ALL                   = bit.bor(
                                                         opvp.SpellProperty.OFFENSIVE_LOW,
                                                         opvp.SpellProperty.OFFENSIVE_MEDIUM,
                                                         opvp.SpellProperty.OFFENSIVE_HIGH
                                                   );

opvp.CrowdControlSpellProperty.ROOT_NO_DR          = bit.bor(opvp.CrowdControlSpellProperty.ROOT, opvp.CrowdControlSpellProperty.NO_DR);
opvp.CrowdControlSpellProperty.STUN_NO_DR          = bit.bor(opvp.CrowdControlSpellProperty.STUN, opvp.CrowdControlSpellProperty.NO_DR);

opvp.CrowdControlSpellProperty.CROWD_CONTROL_ALL   = bit.bor(
                                                         opvp.CrowdControlSpellProperty.DISARM,
                                                         opvp.CrowdControlSpellProperty.DISORIENT,
                                                         opvp.CrowdControlSpellProperty.INCAPACITATE,
                                                         opvp.CrowdControlSpellProperty.KNOCKBACK,
                                                         opvp.CrowdControlSpellProperty.ROOT,
                                                         opvp.CrowdControlSpellProperty.SILENCE,
                                                         opvp.CrowdControlSpellProperty.STUN,
                                                         opvp.CrowdControlSpellProperty.TAUNT
                                                   );

opvp.CrowdControlSpellProperty.IMMUNITY_CC         = bit.bor(
                                                         opvp.CrowdControlSpellProperty.DISARM_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.DISORIENT_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.INCAPACITATE_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.KNOCKBACK_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.ROOT_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.SILENCE_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.STUN_IMMUNITY,
                                                         opvp.CrowdControlSpellProperty.TAUNT_IMMUNITY
                                                   );

opvp.CrowdControlSpellProperty.IMMUNITY_DMG        = bit.bor(opvp.CrowdControlSpellProperty.MAGIC_IMMUNITY, opvp.CrowdControlSpellProperty.PYHSICAL_IMMUNITY);

opvp.CrowdControlSpellProperty.IMMUNITY_ALL        = bit.bor(
                                                         opvp.CrowdControlSpellProperty.IMMUNITY_CC,
                                                         opvp.CrowdControlSpellProperty.IMMUNITY_DMG
                                                   );

opvp.CrowdControlSpellProperty.REDUCTION_CC         = bit.bor(
                                                         opvp.CrowdControlSpellProperty.DISARM_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.DISORIENT_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.INCAPACITATE_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.KNOCKBACK_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.ROOT_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.SILENCE_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.STUN_REDUCTION,
                                                         opvp.CrowdControlSpellProperty.TAUNT_REDUCTION
                                                   );

opvp.CrowdControlSpellProperty.REDUCTION_DMG        = bit.bor(opvp.CrowdControlSpellProperty.MAGIC_REDUCTION, opvp.CrowdControlSpellProperty.PYHSICAL_REDUCTION);

opvp.CrowdControlSpellProperty.REDUCTION_ALL        = bit.bor(
                                                         opvp.CrowdControlSpellProperty.REDUCTION_CC,
                                                         opvp.CrowdControlSpellProperty.REDUCTION_DMG
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
    return opvp.str_else(C_Spell.GetSpellName(self._id));
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
    return opvp.number_else(C_Spell.GetSpellTexture(self._id));
end

opvp.spell = {};

function opvp.spell.info(spellId)
    return C_Spell.GetSpellInfo(spellId);
end

function opvp.spell.link(spellId, glyphId)
    return opvp.hyperlink.createDeathRecap(spellId, glyphId);
end

function opvp.spell.dispellName(dispellType)
    local result = opvp_dispell_type_name_lookup[dispellType];

    if result ~= nil then
        return result;
    else
        return "";
    end
end

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
