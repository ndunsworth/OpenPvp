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
end

function opvp.AuraMap.__iter__(self)
    return next, self._auras, nil;
end

function opvp.AuraMap:add(aura)
    if opvp.IsInstance(aura, opvp.Aura) == true then
        self._auras[aura:id()] = aura;
    end
end

function opvp.AuraMap:auras()
    return opvp.utils.copyTableShallow(self._auras);
end

function opvp.AuraMap:clear()
    self._auras = {};
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

function opvp.AuraMap:findById(id)
    return self._auras[id];
end

function opvp.AuraMap:findByName(name)
    for id, aura in pairs(self._auras) do
        if aura:name() == name then
            return aura;
        end
    end

    return nil;
end

function opvp.AuraMap:findBySpellId(spellId)
    for id, aura in pairs(self._auras) do
        if aura:spellId() == spellId then
            return aura;
        end
    end

    return nil;
end

function opvp.AuraMap:findHarmful()
    local auras = {};

    for id, aura in pairs(self._auras) do
        if aura:isHarmful() == true then
            table.insert(auras, spell);
        end
    end

    return spells;
end

function opvp.AuraMap:isEmpty()
    return opvp.utils.table.isEmpty(self._auras);
end

function opvp.AuraMap:release()
    local result = self._auras;

    self._auras = {};

    return result;
end

function opvp.AuraMap:remove(aura)
    if opvp.is_number(aura) == true then
        self._auras[aura] = nil;
    elseif opvp.IsInstance(aura, opvp.Aura) == true then
        self._auras[aura:id()] = nil;
    end
end

function opvp.AuraMap:size()
    return opvp.utils.table.size(self._auras);
end

function opvp.AuraMap:swap(other)
    if (
        other == nil or
        other == self or
        opvp.IsInstance(other, opvp.AuraMap) == false
    ) then
        return;
    end

    local tmp = self._auras;

    self._auras = other._auras;
    other._auras = tmp;
end
