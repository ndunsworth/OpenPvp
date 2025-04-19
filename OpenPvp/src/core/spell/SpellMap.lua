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

local function opvp_class_spellmap_init_spell_category2(cls, spells, auras, cfg, parentMask)
    local spell, spell_id, traits, props, duration, pvpMult, ignore_aura;

    for n=1, #cfg do
        spell_id, traits, props, duration, pvpMult, ignore_aura = unpack(cfg[n]);

        spell = opvp.SpellExt(
            cls,
            spell_id,
            bit.bor(parentMask, opvp.number_else(traits)),
            props,
            duration,
            pvpMult
        );

        spells:add(spell);

        if (
            auras ~= nil and
            ignore_aura ~= false and
            spell:isAura() == true
        ) then
            auras:add(spell);
        end
    end
end

local function opvp_class_spellmap_init_spell_category(cls, spells, auras, cfg, parentMask)
    local base_mask;

    if cfg.base ~= nil then
        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.base,
            parentMask
        );
    end

    if cfg.talent ~= nil then
        base_mask = bit.bor(parentMask, opvp.SpellTrait.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.talent,
            base_mask
        );
    end

    if cfg.pvp ~= nil then
        base_mask = bit.bor(parentMask, opvp.SpellTrait.PVP, opvp.SpellTrait.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.pvp,
            base_mask
        );
    end

    if cfg.hero ~= nil then
        base_mask = bit.bor(parentMask, opvp.SpellTrait.HERO, opvp.SpellTrait.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.hero,
            base_mask
        );
    end
end

opvp.SpellMap = opvp.CreateClass();

function opvp.SpellMap:createFromClassConfig(cls, cfgSpell, cfgAura, spells, auras, parentMask)
    if parentMask == nil then
        parentMask = 0;
    end

    local mask;

    if cfgSpell ~= nil then
        if cfgSpell.helpful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellTrait.HELPFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                spells,
                auras,
                cfgSpell.helpful,
                mask
            );
        end

        if cfgSpell.harmful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellTrait.HARMFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                spells,
                auras,
                cfgSpell.harmful,
                mask
            );
        end
    end

    if cfgAura ~= nil then
        if cfgAura.helpful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellTrait.BASE, opvp.SpellTrait.HELPFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                auras,
                nil,
                cfgAura.helpful,
                mask
            );
        end

        if cfgAura.harmful ~= nil then
            mask = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.HARMFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                auras,
                nil,
                cfgAura.harmful,
                mask
            );
        end
    end
end

function opvp.SpellMap.__iter__(self)
    return next, self._spells, nil;
end

function opvp.SpellMap:init()
    self._spells = {};
end

function opvp.SpellMap:add(spell)
    if opvp.is_number(spell) == true then
        spell = opvp.Spell(spell);
    elseif opvp.IsInstance(spell, opvp.Spell) == false then
        return;
    end

    local value = self._spells[spell:id()];

    if (
        value == nil or
        spell:isExtended() == true or
        value:isExtended() == false
    ) then
        self._spells[spell:id()] = spell;
    end
end

function opvp.SpellMap:clear()
    self._spells = {};
end

function opvp.SpellMap:contains(spell)
    if opvp.is_number(spell) == true then
        return self._spells[spell] ~= nil;
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        return self._spells[spell:id()] ~= nil;
    else
        return false;
    end
end

function opvp.SpellMap:findByName(name)
    for id, spell in pairs(self._spells) do
        if spell:name() == name then
            return spell;
        end
    end

    return nil;
end

function opvp.SpellMap:findBySpellId(spellId)
    return self._spells[spellId];
end

function opvp.SpellMap:findCrowdControl()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isCrowdControl() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellMap:findHarmful()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isHarmful() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellMap:findHelpful()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isHelpful() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellMap:findRaid()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isRaid() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellMap:isEmpty()
    return opvp.utils.table.isEmpty(self._spells);
end

function opvp.SpellMap:release()
    local result = self._spells;

    self._spells = {};

    return result;
end

function opvp.SpellMap:remove(spell)
    if opvp.is_number(spell) == true then
        self._spells[spell] = nil;
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        self._spells[spell:id()] = nil;
    end
end

function opvp.SpellMap:size()
    return opvp.utils.table.size(self._spells);
end

function opvp.SpellMap:spells()
    return opvp.utils.copyTableShallow(self._spells);
end

function opvp.SpellMap:swap(other)
    if (
        other == nil or
        other == self or
        opvp.IsInstance(other, opvp.SpellMap) == false
    ) then
        return;
    end

    local tmp = self._spells;

    self._spells = other._spells;
    other._spells = tmp;
end
