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

--~ Default for a 3v3
--~ Allow for overflow since a UNIT_AURA event might hit the cap.
local OPVP_AURA_POOL_DEFAULT_SIZE = 40 * 7;

local opvp_aura_pool = nil;

local opvp_aura_dispell_type_lookup = {
    Curse   = opvp.DispellType.CURSE,
    Disease = opvp.DispellType.DISEASE,
    Magic   = opvp.DispellType.MAGIC,
    Poison  = opvp.DispellType.POISON
};

local function opvp_aura_dispell_type(name)
    if name == nil then
        return opvp.DispellType.NONE;
    end

    if name == "" then
        return opvp.DispellType.ENRAGE;
    end

    local result = opvp_aura_dispell_type_lookup[name];

    if result ~= nil then
        return result;
    else
        return opvp.DispellType.NONE;
    end
end

opvp.Aura = opvp.CreateClass();

function opvp.Aura:acquire()
    local aura = opvp_aura_pool:acquire();

    if aura ~= nil then
        return aura;
    end

    opvp.printDebug(
        "opvp.Aura.acquire, growing pool %d->%d",
        opvp_aura_pool:size(),
        opvp_aura_pool:size() * 2
    );

    opvp_aura_pool:setSize(opvp_aura_pool:size() * 2);

    aura = opvp_aura_pool:acquire();

    assert(aura ~= nil);

    return aura;
end

function opvp.Aura:reduce()
    local cur_size = opvp_aura_pool:size();

    if cur_size == OPVP_AURA_POOL_DEFAULT_SIZE then
        return;
    end

    local size = math.floor(cur_size / 2);

    if opvp_aura_pool:available() >= size then
        opvp.printDebug(
            "opvp.Aura.reduce, shrinking pool %d->%d",
            cur_size,
            size
        );

        opvp_aura_pool:setSize(size);
    end
end

function opvp.Aura:release(aura)
    if opvp.IsInstance(aura, opvp.Aura) then
        opvp_aura_pool:release(aura);
    elseif opvp.IsInstance(aura, opvp.AuraMap) then
        for id, a in opvp.iter(aura) do
            opvp_aura_pool:release(a);
        end
    end
end

function opvp.Aura:init()
    self._id           = 0;

    self._applications = 0;
    self._charges      = 0;
    self._charges_max  = 0;
    self._dispell_type = opvp.DispellType.NONE;
    self._duration     = 0;
    self._expiration   = 0;
    self._time_mod     = 0;
    self._icon         = 0;
    self._name         = "";
    self._spell_id     = 0;
    self._source       = "";

    self._mask         = 0;
end

function opvp.Aura:applications()
    return self._applications;
end

function opvp.Aura:clear()
    self._id           = 0;

    self._applications = 0;
    self._charges      = 0;
    self._charges_max  = 0;
    self._dispell_type = opvp.DispellType.NONE;
    self._duration     = 0;
    self._expiration   = 0;
    self._time_mod     = 0;
    self._icon         = 0;
    self._name         = "";
    self._spell_id     = 0;
    self._source       = "";

    self._mask         = 0;
end

function opvp.Aura:charges()
    return self._charges;
end

function opvp.Aura:chargesMaximum()
    return self._charges_max;
end

function opvp.Aura:dispellType()
    return self._dispell_type;
end

function opvp.Aura:duration()
    return self._duration;
end

function opvp.Aura:expiration()
    return self._expiration;
end

function opvp.Aura:hasCharges()
    return self._charges_max ~= 0;
end

function opvp.Aura:hasDuration()
    return self._duration ~= 0;
end

function opvp.Aura:hasExpiration()
    return self._expiration ~= 0;
end

function opvp.Aura:icon()
    return self._icon;
end

function opvp.Aura:id()
    return self._id;
end

function opvp.Aura:isHarmful()
    return bit.band(self._mask, opvp.SpellProperty.HARMFUL) ~= 0;
end

function opvp.Aura:isHelpful()
    return bit.band(self._mask, opvp.SpellProperty.HELPFUL) ~= 0;
end

function opvp.Aura:isNull()
    return self._id == 0;
end

function opvp.Aura:name()
    return self._name;
end

function opvp.Aura:set(info)
    if info == nil then
        self:clear();

        return;
    end

    self._id           = info.auraInstanceID;

    assert(self._id ~= nil);

    self._applications = opvp.number_else(info.applications);
    self._charges      = opvp.number_else(info.charges);
    self._charges_max  = opvp.number_else(info.maxCharges);
    self._dispell_type = opvp_aura_dispell_type(info.dispelName);
    self._duration     = opvp.number_else(info.duration);
    self._expiration   = opvp.number_else(info.expirationTime);
    self._time_mod     = opvp.number_else(info.timeMod);
    self._name         = opvp.str_else(info.name);
    self._spell_id     = opvp.number_else(info.spellId);
    self._source       = opvp.str_else(info.sourceUnit);

    self._mask         = 0;

    if opvp.bool_else(info.isHelpful, false) == true then
        self._mask = bit.bor(self._mask, opvp.SpellProperty.HELPFUL);
    elseif opvp.bool_else(info.isHarmful, false) == true then
        self._mask = bit.bor(self._mask, opvp.SpellProperty.HARMFUL);
    end
end

function opvp.Aura:spellId()
    return self._spell_id;
end

function opvp.Aura:source()
    return self._source;
end

function opvp.Aura:timeModifier()
    return self._time_mod;
end

function opvp.Aura:update(info)
    assert(
        info.auraInstanceID == self._id and
        info.spellId == self._spell_id
    );

    self._applications = opvp.number_else(info.applications);
    self._charges      = opvp.number_else(info.charges);
    self._charges_max  = opvp.number_else(info.maxCharges);
    self._duration     = opvp.number_else(info.duration);
    self._expiration   = opvp.number_else(info.expirationTime);
    self._time_mod     = opvp.number_else(info.timeMod);
    self._icon         = opvp.number_else(info.icon);
    self._source       = opvp.str_else(info.sourceUnit);
end

opvp_aura_pool = opvp.Pool(OPVP_AURA_POOL_DEFAULT_SIZE, opvp.Aura);
