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
    local spell, spell_id, spell_props, cc_props, duration, pvpMult, ignore_aura;

    for n=1, #cfg do
        spell_id, spell_props, cc_props, duration, pvpMult, ignore_aura = unpack(cfg[n]);

        spell = opvp.SpellExt(
            cls,
            spell_id,
            bit.bor(parentMask, opvp.number_else(spell_props)),
            cc_props,
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
        base_mask = bit.bor(parentMask, opvp.SpellProperty.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.talent,
            base_mask
        );
    end

    if cfg.hero ~= nil then
        base_mask = bit.bor(parentMask, opvp.SpellProperty.HERO, opvp.SpellProperty.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.hero,
            base_mask
        );
    end

    if cfg.pvp ~= nil then
        base_mask = bit.bor(parentMask, opvp.SpellProperty.PVP, opvp.SpellProperty.TALENT);

        opvp_class_spellmap_init_spell_category2(
            cls,
            spells,
            auras,
            cfg.pvp,
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
            mask = bit.bor(parentMask, opvp.SpellProperty.HELPFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                spells,
                auras,
                cfgSpell.helpful,
                mask
            );
        end

        if cfgSpell.harmful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellProperty.HARMFUL);

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
        parentMask = bit.bor(parentMask, opvp.SpellProperty.AURA);

        if cfgAura.helpful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellProperty.HELPFUL);

            opvp_class_spellmap_init_spell_category(
                cls,
                auras,
                nil,
                cfgAura.helpful,
                mask
            );
        end

        if cfgAura.harmful ~= nil then
            mask = bit.bor(parentMask, opvp.SpellProperty.HARMFUL);

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
    self._size   = 0;
end

function opvp.SpellMap:add(spell)
    if opvp.is_number(spell) == true then
        spell = opvp.Spell(spell);
    elseif opvp.IsInstance(spell, opvp.Spell) == false then
        return;
    end

    local value = self._spells[spell:id()];

    if value == nil then
        self._spells[spell:id()] = spell;

        self._size = self._size + 1;
    end
end

function opvp.SpellMap:clear()
    table.wipe(self._spells);
end

function opvp.SpellMap:clone()
    local result = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        spells._spells[id] = spell:clone();
    end

    return result;
end

function opvp.SpellMap:difference(other)
    local spells = opvp.SpellMap();

    if opvp.IsInstance(other, opvp.SpellMap) == false then
        return spells;
    end
    if opvp.is_number(spell) == true then
        return self._spells[spell] ~= nil;
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        return self._spells[spell:id()] ~= nil;
    else
        return false;
    end
end

function opvp.SpellMap:intersection(other)
    local spells = opvp.SpellMap();

    if opvp.IsInstance(other, opvp.SpellMap) == false then
        return spells;
    end

    local a, b;

    if self._size >= other._size then
        a = other;
        b = self;
    else
        a = self;
        b = other;
    end

    for id, spell in pairs(a._spells) do
        if b._spells[id] ~= nil then
            spell._spells[id] = spell:clone();
        end
    end

    return spells;
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

function opvp.SpellMap:findDefensive()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isDefensive() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findDefensiveOrOffensive()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isDefensiveOrOffensive() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findCrowdControl()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isCrowdControl() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findHarmful()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isHarmful() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findHelpful()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isHelpful() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findOffensive()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isOffensive() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:findRaid()
    local spells = opvp.SpellMap();

    for id, spell in pairs(self._spells) do
        if spell:isRaid() == true then
            spells._spells[id] = spell;
            spells._size = spells._size + 1;
        end
    end

    return spells;
end

function opvp.SpellMap:intersect(other)
    self:swap(self:intersection(other));
end

function opvp.SpellMap:intersection(other)
    local spells = opvp.SpellMap();

    if opvp.IsInstance(other, opvp.SpellMap) == false then
        return spells;
    end

    local a, b;

    if self._size >= other._size then
        a = other;
        b = self;
    else
        a = self;
        b = other;
    end

    for id, spell in pairs(a._spells) do
        if b._spells[id] ~= nil then
            spell._spells[id] = spell:clone();
        end
    end

    return spells;
end

function opvp.SpellMap:merge(other)
    if opvp.IsInstance(other, opvp.SpellMap) == false then
        return;
    end

    for id, spell in pairs(other._spells) do
        if self._spells[id] == nil then
            spell._spells[id] = spell:clone();
        end
    end
end

function opvp.SpellMap:merged(other)
    local spells = self.clone();

    spells:merge(other);

    return spells;
end

function opvp.SpellMap:isEmpty()
    return self._size == 0;
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
    return self._size;
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

    local tmp     = self._spells;

    self._spells  = other._spells;
    other._spells = tmp;

    tmp           = self._size;

    self._size    = other._size;
    other._size   = tmp;
end
