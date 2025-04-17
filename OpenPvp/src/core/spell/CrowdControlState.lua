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

local opvp_cc_status_next_lookup = {
    opvp.CrowdControlStatus.HALF,
    opvp.CrowdControlStatus.QUARTER,
    opvp.CrowdControlStatus.IMMUNE,
    opvp.CrowdControlStatus.FULL,
};

local opvp_cc_value_null;

opvp.CrowdControlValue = opvp.CreateClass();

function opvp.CrowdControlValue:init(category)
    self._cat     = category;
    self._count   = 0;
    self._dr      = opvp.CrowdControlStatus.FULL;
    self._dr_next = opvp.CrowdControlStatus.FULL;
    self._spell   = opvp.SpellExt:null();
    self._auras   = opvp.AuraMap();
end

function opvp.CrowdControlValue:category()
    return self._cat;
end

function opvp.CrowdControlValue:id()
    return self._cat:id();
end

function opvp.CrowdControlValue:hasDr()
    return self._dr ~= opvp.CrowdControlStatus.FULL;
end

function opvp.CrowdControlValue:dr()
    return self._dr;
end

function opvp.CrowdControlValue:drNext()
    return self._dr_next;
end

function opvp.CrowdControlValue:isFull()
    return self._dr == opvp.CrowdControlStatus.FULL;
end

function opvp.CrowdControlValue:isHalf()
    return self._dr == opvp.CrowdControlStatus.HALF;
end

function opvp.CrowdControlValue:isHalfNext()
    return self._dr_next == opvp.CrowdControlStatus.HALF;
end

function opvp.CrowdControlValue:isImmune()
    return self._dr == opvp.CrowdControlStatus.IMMUNE;
end

function opvp.CrowdControlValue:isImmuneNext()
    return self._dr_next == opvp.CrowdControlStatus.IMMUNE;
end

function opvp.CrowdControlValue:isQuarter()
    return self._dr == opvp.CrowdControlStatus.QUARTER;
end

function opvp.CrowdControlValue:isQuarterNext()
    return self._dr_next == opvp.CrowdControlStatus.QUARTER;
end

function opvp.CrowdControlValue:_clear()
    self._count   = 0;
    self._dr      = opvp.CrowdControlStatus.FULL;
    self._dr_next = opvp.CrowdControlStatus.FULL;
    self._spell   = opvp.SpellExt:null();

    self._auras:clear();
end

function opvp.CrowdControlValue:_onAuraAdded(aura, spell)
    if self._auras:contains(aura) == false then
        self._count = self._count + 1;

        self._auras:add(aura);
    end

    self._dr      = self._cat:statusForTime(aura:duration(), spell:duration());
    self._dr_next = opvp_cc_status_next_lookup[self._dr];
    self._spell   = spell;

    return self._count == 1, self._dr;
end

function opvp.CrowdControlValue:_onAuraUpdated(aura, spell)
    local tmp = self._auras:findById(aura:id());

    if tmp ~= nil then
        if tmp:duration() == aura:duration() then
            return false, self._dir;
        end
    else
        self._count = self._count + 1;

        self._auras:add(aura);
    end

    self._dr      = self._cat:statusForTime(aura:duration(), spell:duration());
    self._dr_next = opvp_cc_status_next_lookup[self._dr];
    self._spell   = spell;

    return self._count == 1, self._dr;
end

function opvp.CrowdControlValue:_onAuraRemoved(aura, spell)
    if self._auras:contains(aura) == true then
        self._count = self._count - 1;

        self._auras:remove(aura);
    else
        self._dr      = self._cat:statusForTime(aura:duration(), spell:duration());
        self._dr_next = opvp_cc_status_next_lookup[self._dr];
    end

    if self._count ~= 0 then
        return false, self._dr;
    end

    self._spell   = opvp.SpellExt:null();
    self._dr      = self._dr_next;
    self._dr_next = opvp_cc_status_next_lookup[self._dr];

    return true, self._dr;
end

opvp.CrowdControlState = opvp.CreateClass();

function opvp.CrowdControlState:init()
    self._values = {
        [opvp.CrowdControlType.DISARM]       = opvp.CrowdControlValue(opvp.CrowdControlCategory.DISARM),
        [opvp.CrowdControlType.DISORIENT]    = opvp.CrowdControlValue(opvp.CrowdControlCategory.DISORIENT),
        [opvp.CrowdControlType.INCAPACITATE] = opvp.CrowdControlValue(opvp.CrowdControlCategory.INCAPACITATE),
        [opvp.CrowdControlType.KNOCKBACK]    = opvp.CrowdControlValue(opvp.CrowdControlCategory.KNOCKBACK),
        [opvp.CrowdControlType.ROOT]         = opvp.CrowdControlValue(opvp.CrowdControlCategory.ROOT),
        [opvp.CrowdControlType.SILENCE]      = opvp.CrowdControlValue(opvp.CrowdControlCategory.SILENCE),
        [opvp.CrowdControlType.STUN]         = opvp.CrowdControlValue(opvp.CrowdControlCategory.STUN),
        [opvp.CrowdControlType.TAUNT]        = opvp.CrowdControlValue(opvp.CrowdControlCategory.TAUNT)
    };

    self._mask  = 0;
    self._count = 0;
end

function opvp.CrowdControlState:isAny(mask)
    return bit.band(self._mask, mask) ~= 0;
end

function opvp.CrowdControlState:isDisarmed()
    return bit.band(self._mask, opvp.CrowdControlType.DISARM) ~= 0;
end

function opvp.CrowdControlState:isDisoriented()
    return bit.band(self._mask, opvp.CrowdControlType.DISORIENT) ~= 0;
end

function opvp.CrowdControlState:isIncapacitated()
    return bit.band(self._mask, opvp.CrowdControlType.INCAPACITATE) ~= 0;
end

function opvp.CrowdControlState:isKnockedBack()
    return bit.band(self._mask, opvp.CrowdControlType.KNOCKBACK) ~= 0;
end

function opvp.CrowdControlState:isCrowdControled()
    return self._mask == opvp.CrowdControlType.NONE;
end

function opvp.CrowdControlState:isImmune(category)
    return self:value(category):isImmune();
end

function opvp.CrowdControlState:isRooted()
    return bit.band(self._mask, opvp.CrowdControlType.ROOT) ~= 0;
end

function opvp.CrowdControlState:isSilenced()
    return bit.band(self._mask, opvp.CrowdControlType.SILENCE) ~= 0;
end

function opvp.CrowdControlState:isStunned()
    return bit.band(self._mask, opvp.CrowdControlType.STUN) ~= 0;
end

function opvp.CrowdControlState:isTaunted()
    return bit.band(self._mask, opvp.CrowdControlType.TAUNT) ~= 0;
end

function opvp.CrowdControlState:value(category)
    local value = self._values[cat_type];

    if value ~= nil then
        return value;
    else
        return opvp_cc_value_null;
    end
end

function opvp.CrowdControlState:_clear()
    for k, v in pairs(self._values) do
        v:_clear();
    end
end

function opvp.CrowdControlState:_onAuraAdded(aura, spell)
    local cat_type = spell:crowdControlType();

    if cat_type == opvp.CrowdControlType.NONE then
        return false, opvp.CrowdControlStatus.NONE, self._mask, self._mask;
    end

    local value = self._values[cat_type];

    assert(value ~= nil);

    local result, dr = value:_onAuraAdded(aura, spell);

    local old_state = self._mask;

    if result == true then
        self._mask = bit.bor(self._mask, cat_type);

        self._count = self._count + 1;
    end

    return result, dr, self._mask, old_state;
end

function opvp.CrowdControlState:_onAuraUpdated(aura, spell)
    local cat_type = spell:crowdControlType();

    if cat_type == opvp.CrowdControlType.NONE then
        return false, opvp.CrowdControlStatus.NONE, self._mask, self._mask;
    end

    local value = self._values[cat_type];

    assert(value ~= nil);

    local result, dr = value:_onAuraUpdated(aura, spell);

    local old_state = self._mask;

    if result == true then
        self._mask = bit.bor(self._mask, cat_type);

        self._count = self._count + 1;
    end

    return result, dr, self._mask, old_state;
end

function opvp.CrowdControlState:_onAuraRemoved(aura, spell)
    local cat_type = spell:crowdControlType();

    if cat_type == opvp.CrowdControlType.NONE then
        return false, opvp.CrowdControlStatus.NONE, self._mask, self._mask;
    end

    local value = self._values[cat_type];

    assert(value ~= nil);

    local result, dr = value:_onAuraRemoved(aura, spell);

    local old_state = self._mask;

    if result == true then
        self._mask = bit.band(self._mask, bit.bnot(cat_type));

        self._count = self._count - 1;
    end

    return true, dr, self._mask, old_state;
end

opvp_cc_value_null = opvp.CrowdControlValue(opvp.CrowdControlCategory.NONE);
