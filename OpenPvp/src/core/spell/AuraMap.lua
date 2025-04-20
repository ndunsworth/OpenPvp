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

opvp.AuraMap = opvp.CreateClass();

function opvp.AuraMap:init()
    self._auras = {};
    self._size = 0;
end

function opvp.AuraMap.__iter__(self)
    return next, self._auras, nil;
end

function opvp.AuraMap:add(aura)
    if (
        opvp.IsInstance(aura, opvp.Aura) == true and
        self._auras[aura:id()] == nil
    ) then
        self._auras[aura:id()] = aura;
        self._size = self._size + 1;

        return true;
    else
        return false;
    end
end

function opvp.AuraMap:auras()
    return opvp.utils.copyTableShallow(self._auras);
end

function opvp.AuraMap:clear()
    self._auras = {};
    self._size  = 0;
end

function opvp.AuraMap:contains(aura)
    if opvp.is_number(aura) == true then
        return self._auras[aura] ~= nil;
    elseif opvp.IsInstance(aura, opvp.Aura) == true then
        return self._auras[aura:id()] ~= nil;
    else
        return false;
    end

end

function opvp.AuraMap:containsSpell(spell)
    return self:containsSpellId(spell:id());
end

function opvp.AuraMap:containsSpellId(spellId)
    if opvp.is_number(aura) == false then
        return false;
    end

    for id, aura in pairs(self._auras) do
        if aura:spellId() == spellId then
            return aura;
        end
    end

    return false;
end

function opvp.AuraMap:findById(id)
    return self._auras[id];
end

function opvp.AuraMap:findByName(name, map)
    local auras = opvp.AuraMap();

    for id, aura in pairs(self._auras) do
        if aura:name() == name then
            auras._auras[id] = aura;
            auras._size = auras._size + 1;
        end
    end

    return auras;
end

function opvp.AuraMap:findBySpell(spell)
    return self:findBySpellId(spell:id());
end

function opvp.AuraMap:findBySpellId(spellId)
    local auras = opvp.AuraMap();

    for id, aura in pairs(self._auras) do
        if id == spellId then
            auras._auras[id] = aura;
            auras._size = auras._size + 1;
        end
    end

    return auras;
end

function opvp.AuraMap:findHarmful()
    local auras = opvp.AuraMap();

    for id, aura in pairs(self._auras) do
        if aura:isHarmful() == true then
            auras._auras[id] = aura;
            auras._size = auras._size + 1;
        end
    end

    return auras;
end

function opvp.AuraMap:findHelpful()
    local auras = opvp.AuraMap();

    for id, aura in pairs(self._auras) do
        if aura:isHelpful() == true then
            auras._auras[id] = aura;
            auras._size = auras._size + 1;
        end
    end

    return auras;
end

function opvp.AuraMap:isEmpty()
    return self._size == 0;
end

function opvp.AuraMap:release()
    local result = self._auras;

    self._auras = {};

    return result;
end

function opvp.AuraMap:remove(aura)
    if opvp.is_number(aura) == true then
        if self._auras[aura] ~= nil then
            self._auras[aura] = nil;

            self._count = self._size - 1;

            return true;
        end
    elseif opvp.IsInstance(aura, opvp.Aura) == true then
        if self._auras[aura:id()] ~= nil then
            self._auras[aura:id()] = nil;

            self._count = self._size - 1;

            return true;
        end
    end

    return false;
end

function opvp.AuraMap:size()
    return self._size;
end

function opvp.AuraMap:swap(other)
    if (
        other == nil or
        other == self or
        opvp.IsInstance(other, opvp.AuraMap) == false
    ) then
        return;
    end

    local tmp    = self._auras;

    self._auras  = other._auras;
    other._auras = tmp;

    tmp          = self._size;

    self._size   = other._size;
    other._size  = tmp;
end
