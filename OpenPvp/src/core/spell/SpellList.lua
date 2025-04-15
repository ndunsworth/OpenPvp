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

local function opvp_class_spells_list_init_category(cls, spells, cfg, parentMask)
    local base_mask, mask, spell_id, spell, aura_id;

    if cfg.base ~= nil then
        for n=1, #cfg.base do
            spell_id, mask, aura_id = unpack(cfg.base[n]);

            spell = opvp.SpellExt(
                cls,
                spell_id,
                bit.bor(parentMask, mask),
                aura_id
            );

            spells:append(spell);
        end
    end

    if cfg.talent ~= nil then
        parentMask = bit.bor(parentMask, opvp.SpellTrait.TALENT);

        for n=1, #cfg.talent do
            spell_id, mask, aura_id = unpack(cfg.talent[n]);

            spell = opvp.SpellExt(
                cls,
                spell_id,
                bit.bor(parentMask, mask),
                aura_id
            );

            spells:append(spell);
        end
    end
end

opvp.SpellList = opvp.CreateClass();

function opvp.SpellList:createFromClassConfig(cls, cfg)
    local spells = opvp.SpellList();

    if cfg == nil then
        return spells;
    end

    local mask;

    if cfg.helpful ~= nil then
        mask = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.HELPFUL);

        opvp_class_spells_list_init_category(
            cls,
            spells._spells,
            cfg.helpful,
            mask
        );
    end

    if cfg.harmful ~= nil then
        mask = bit.bor(opvp.SpellTrait.BASE, opvp.SpellTrait.HARMFUL);

        opvp_class_spells_list_init_category(
            cls,
            spells._spells,
            cfg.harmful,
            mask
        );
    end

    return spells;
end

function opvp.SpellList:init()
    self._spells = opvp.List();
end

function opvp.SpellList:findByName(name)
    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:name() == name then
            return spell;
        end
    end

    return nil;
end

function opvp.SpellList:findBySpellId(spellId)
    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:id() == spellId then
            return spell;
        end
    end

    return nil;
end

function opvp.SpellList:findCrowdControl()
    local spells = {};

    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isCrowdControl() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellList:findHarmful()
    local spells = {};

    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isHarmful() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellList:findHelpful()
    local spells = {};

    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isHelpful() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellList:findRaid()
    local spells = {};

    local spell;

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isRaid() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellList:isEmpty()
    return self._spells:isEmpty();
end

function opvp.SpellList:size()
    return self._spells:size();
end
