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

opvp.AuraList = opvp.CreateClass();

function opvp.AuraList:init()
    self._auras = opvp.List();
end

function opvp.AuraList:add(aura)
    if (
        opvp.IsInstance(aura, opvp.Aura) == true and
        self:findById(aura:id()) == false
    ) then
        self._auras:append(aura);
    end
end

function opvp.AuraList:auras()
    return self._auras:items();
end

function opvp.AuraList:clear()
    self._auras:clear();
end

function opvp.AuraList:findById(id)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:id() == id then
            return aura;
        end
    end

    return nil;
end

function opvp.AuraList:findByName(name)
    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:name() == name then
            return aura;
        end
    end

    return nil;
end

function opvp.AuraList:findBySpellId(spellId)
    local aura;

    for n=1, self._spells:size() do
        aura = self._spells:item(n);

        if aura:spellId() == spellId then
            return aura;
        end
    end

    return nil;
end

function opvp.AuraList:findHarmful()
    local auras = {};

    local aura;

    for n=1, self._auras:size() do
        aura = self._auras:item(n);

        if aura:isHarmful() == true then
            table.insert(auras, spell);
        end
    end

    return spells;
end

function opvp.AuraList:isEmpty()
    return self._auras:isEmpty();
end

function opvp.AuraList:release()
    return self._auras:release();
end

function opvp.AuraList:remove(aura)
    if opvp.IsInstance(aura, opvp.Aura) == true then
        self._auras:removeItem(aura);
    end
end

function opvp.AuraList:size()
    return self._auras:size();
end

function opvp.AuraList:swap(other)
    if (
        other ~= nil and
        other ~= self and
        opvp.IsInstance(other, opvp.AuraList) == true
    ) then
        self._auras:swap(other._auras);
    end
end
