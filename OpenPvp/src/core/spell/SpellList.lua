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

opvp.SpellList = opvp.CreateClass();

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

function opvp.SpellList:findDefensive()
    local spells = opvp.SpellMap();

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isDefensive() == true then
            table.insert(spells, spell);
        end
    end

    return spells;
end

function opvp.SpellList:findDefensiveOrOffensive()
    local spells = opvp.SpellMap();

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:isDefensiveOrOffensive() == true then
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

function opvp.SpellList:findOffensive()
    local spells = opvp.SpellMap();

    for n=1, self._spells:size() do
        spell = self._spells:item(n);

        if spell:findOffensive() == true then
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

function opvp.SpellList:swap(other)
    if (
        other ~= nil and
        other ~= self and
        opvp.IsInstance(other, opvp.SpellList) == true
    ) then
        self._spells:swap(other._spells);
    end
end
