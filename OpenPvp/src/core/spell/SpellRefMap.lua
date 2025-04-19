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

opvp.SpellRef = opvp.CreateClass();

function opvp.SpellRef:init(spell)
    self._count = 1;

    if opvp.is_number(spell) == true then
        self._spell = opvp.Spell(spell);
    elseif spell:isExtended() == true then
        self._spell = spell;
    else
        self._spell = spell:clone();
    end
end

function opvp.SpellRef:deref()
    assert(self._count > 0);

    self._count = self._count - 1;

    return self._count > 0;
end

function opvp.SpellRef:id()
    return self._spell:id();
end

function opvp.SpellRef:isCrowdControl()
    return self._spell:isCrowdControl();
end

function opvp.SpellRef:isHarmful()
    return self._spell:isHarmful();
end

function opvp.SpellRef:isHelpful()
    return self._spell:isHelpful();
end

function opvp.SpellRef:isRaid()
    return self._spell:isRaid();
end

function opvp.SpellRef:name()
    return self._spell:name();
end

function opvp.SpellRef:ref(spell)
    self._count = self._count + 1;

    if (
        opvp.is_number == false and
        self._spell:isExtended() == false and
        spell:isExtended() == true
    ) then
        self._spell = spell:clone();
    end
end

function opvp.SpellRef:refs()
    return self._count;
end

function opvp.SpellRef:spell()
    return self._spell;
end

opvp.SpellRefMap = opvp.CreateClass();

function opvp.SpellRefMap.__iter__(self)
    return next, self._spells, nil;
end

function opvp.SpellRefMap:init()
    self._spells = {};
end

function opvp.SpellRefMap:add(spell)
    local ref;

    if opvp.is_number(spell) == true then
        ref = self._spells[spell];

        if ref ~= nil then
            ref:ref(spell);

            return false;
        else
            self._spells[spell] = opvp.SpellRef(spell);

            return true;
        end
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        ref = self._spells[spell:id()];

        if ref ~= nil then
            ref:ref(spell);

            return false;
        else
            self._spells[spell:id()] = opvp.SpellRef(spell);

            return true;
        end
    else
        return false;
    end
end

function opvp.SpellRefMap:clear()
    self._spells = {};
end

function opvp.SpellRefMap:contains(spell)
    if opvp.is_number(spell) == true then
        return self._spells[spell] ~= nil;
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        return self._spells[spell:id()] ~= nil;
    else
        return false;
    end
end

function opvp.SpellRefMap:findByName(name)
    for id, spell in pairs(self._spells) do
        if spell:name() == name then
            return spell:spell();
        end
    end

    return nil;
end

function opvp.SpellRefMap:findBySpellId(spellId)
    local ref = self._spells[spellId];

    if ref ~= nil then
        return ref:spell();
    else
        return nil;
    end
end

function opvp.SpellRefMap:findCrowdControl()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isCrowdControl() == true then
            table.insert(spells, spell:spell());
        end
    end

    return spells;
end

function opvp.SpellRefMap:findHarmful()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isHarmful() == true then
            table.insert(spells, spell:spell());
        end
    end

    return spells;
end

function opvp.SpellRefMap:findHelpful()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isHelpful() == true then
            table.insert(spells, spell:spell());
        end
    end

    return spells;
end

function opvp.SpellRefMap:findRaid()
    local spells = {};

    for id, spell in pairs(self._spells) do
        if spell:isRaid() == true then
            table.insert(spells, spell:spell());
        end
    end

    return spells;
end

function opvp.SpellRefMap:isEmpty()
    return opvp.utils.table.isEmpty(self._spells);
end

function opvp.SpellRefMap:refs(spell)
    local ref;

    if opvp.is_number(spell) == true then
        ref = self._spells[spell];
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        ref = self._spells[spell:id()];
    else
        return 0;
    end

    if ref ~= nil then
        return ref:refs();
    else
        return 0;
    end
end

function opvp.SpellRefMap:remove(spell)
    local ref;

    if opvp.is_number(spell) == true then
        ref = self._spells[spell];
    elseif opvp.IsInstance(spell, opvp.Spell) == true then
        ref = self._spells[spell:id()];
    else
        return false;
    end

    if ref ~= nil and ref:deref() == false then
        self._spells[ref:id()] = nil;

        return true;
    else
        return false;
    end
end

function opvp.SpellRefMap:size()
    return opvp.utils.table.size(self._spells);
end

function opvp.SpellRefMap:spells()
    local spells = {};

    for id, spell in pairs(self._spells) do
        table.insert(spells, spell:spell());
    end
end

function opvp.SpellRefMap:swap(other)
    if (
        other == nil or
        other == self or
        opvp.IsInstance(other, opvp.SpellRefMap) == false
    ) then
        return;
    end

    local tmp = self._spells;

    self._spells = other._spells;
    other._spells = tmp;
end
