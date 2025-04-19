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

local opvp_cc_cat_state_null;

opvp.CrowdControlState = opvp.CreateClass();

function opvp.CrowdControlState:init()
    self._cats = {
        [opvp.CrowdControlType.DISARM]       = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.DISARM),
        [opvp.CrowdControlType.DISORIENT]    = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.DISORIENT),
        [opvp.CrowdControlType.INCAPACITATE] = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.INCAPACITATE),
        [opvp.CrowdControlType.KNOCKBACK]    = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.KNOCKBACK),
        [opvp.CrowdControlType.ROOT]         = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.ROOT),
        [opvp.CrowdControlType.SILENCE]      = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.SILENCE),
        [opvp.CrowdControlType.STUN]         = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.STUN),
        [opvp.CrowdControlType.TAUNT]        = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.TAUNT)
    };

    self._mask  = 0;
end

function opvp.CrowdControlState:category(category)
    local cat = self._cats[category];

    if cat ~= nil then
        return cat;
    else
        return opvp_cc_cat_state_null;
    end
end

function opvp.CrowdControlState:duration(category)
    return self:category(category):duration();
end

function opvp.CrowdControlState:expiration(category)
    return self:category(category):expiration();
end

function opvp.CrowdControlState:isAny(mask)
    return bit.band(self._mask, mask) ~= 0;
end

function opvp.CrowdControlState:isOnly(category)
    return bit.band(self._mask, category) == category;
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

function opvp.CrowdControlState:isCrowdControlled()
    return self._mask == opvp.CrowdControlType.NONE;
end

function opvp.CrowdControlState:isImmune(category)
    return self:category(category):isImmune();
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

function opvp.CrowdControlState:_clear()
    for k, v in pairs(self._cats) do
        v:_clear();
    end
end

function opvp.CrowdControlState:_onAuraAdded(aura, spell)
    local cat_type = spell:crowdControlType();
    local cat = self:category(cat_type);

    if cat:isNull() == true then
        return false, cat, self._mask, self._mask;
    end

    local result = cat:_onAuraAdded(aura, spell);

    local old_state = self._mask;

    if result == true then
        self._mask = bit.bor(self._mask, cat_type);
    end

    return result, cat, self._mask, old_state;
end

function opvp.CrowdControlState:_onAuraUpdated(aura, spell)
    local cat_type = spell:crowdControlType();
    local cat = self:category(cat_type);

    if cat:isNull() == true then
        return false, cat, self._mask, self._mask;
    end

    local result = cat:_onAuraUpdated(aura, spell);

    local old_state = self._mask;

    if result == true and cat:size() == 1 then
        self._mask = bit.bor(self._mask, cat_type);
    end

    return result, cat, self._mask, old_state;
end

function opvp.CrowdControlState:_onAuraRemoved(aura, spell)
    local cat_type = spell:crowdControlType();
    local cat = self:category(cat_type);

    if cat:isNull() == true then
        return false, cat, self._mask, self._mask;
    end

    local result = cat:_onAuraRemoved(aura, spell);

    local old_state = self._mask;

    if result == true then
        self._mask = bit.band(self._mask, bit.bnot(cat_type));
    end

    return true, cat, self._mask, old_state;
end

opvp_cc_cat_state_null = opvp.CrowdControlCategoryState(opvp.CrowdControlCategory.NONE);
