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

opvp.CrowdControlCategoryState = opvp.CreateClass();

function opvp.CrowdControlCategoryState:init(category)
    self._cat        = category;
    self._dr         = opvp.CrowdControlStatus.FULL;
    self._dr_next    = opvp.CrowdControlStatus.FULL;
    self._duration   = 0;
    self._expiration = 0;
    self._spell      = opvp.SpellExt:null();
    self._auras      = opvp.AuraMap();
end

function opvp.CrowdControlCategoryState:auras()
    self._auras:auras()
end

function opvp.CrowdControlCategoryState:category()
    return self._cat;
end

function opvp.CrowdControlCategoryState:id()
    return self._cat:id();
end

function opvp.CrowdControlCategoryState:hasAura(aura)
    self._auras:contains(aura)
end

function opvp.CrowdControlCategoryState:hasDr()
    return self._dr ~= opvp.CrowdControlStatus.FULL;
end

function opvp.CrowdControlCategoryState:dr()
    return self._dr;
end

function opvp.CrowdControlCategoryState:drName()
    return self._cat:nameForStatus(self._dr);
end

function opvp.CrowdControlCategoryState:drNext()
    return self._dr_next;
end

function opvp.CrowdControlCategoryState:drResetTime()
    if self._expiration > 0 then
        return (
            (self._expiration - self._duration) +
            self._cat:resetTime()
        );
    else
        return 0;
    end
end

function opvp.CrowdControlCategoryState:duration()
    return self._duration;
end

function opvp.CrowdControlCategoryState:expiration()
    return self._expiration;
end

function opvp.CrowdControlCategoryState:isFull()
    return self._dr == opvp.CrowdControlStatus.FULL;
end

function opvp.CrowdControlCategoryState:isHalf()
    return self._dr == opvp.CrowdControlStatus.HALF;
end

function opvp.CrowdControlCategoryState:isHalfNext()
    return self._dr_next == opvp.CrowdControlStatus.HALF;
end

function opvp.CrowdControlCategoryState:isImmune()
    return self._dr == opvp.CrowdControlStatus.IMMUNE;
end

function opvp.CrowdControlCategoryState:isImmuneNext()
    return self._dr_next == opvp.CrowdControlStatus.IMMUNE;
end

function opvp.CrowdControlCategoryState:isNull()
    return self._cat:isNull();
end

function opvp.CrowdControlCategoryState:isQuarter()
    return self._dr == opvp.CrowdControlStatus.QUARTER;
end

function opvp.CrowdControlCategoryState:isQuarterNext()
    return self._dr_next == opvp.CrowdControlStatus.QUARTER;
end

function opvp.CrowdControlCategoryState:size()
    self._auras:size()
end

function opvp.CrowdControlCategoryState:_clear()
    self._dr         = opvp.CrowdControlStatus.FULL;
    self._dr_next    = opvp.CrowdControlStatus.FULL;
    self._duration   = 0;
    self._expiration = 0;
    self._spell      = opvp.SpellExt:null();

    self._auras:clear();
end

function opvp.CrowdControlCategoryState:_onAuraAdded(aura, spell)
    local duration   = aura:duration();
    local expiration = aura:expiration();
    local applied    = expiration - duration;
    local dr         = self._cat:statusForTime(duration, spell:durationPvp());

    local exists = not self._auras:add(aura);

    --~ For some reason a Mage Dragon Breath will trigger a Aura Updated
    --~ and its expiration is the same.  It will be floating point error
    --~ off most likely.  Thus we test for that type of scenario and bail
    if (
        exists == true and
        duration == self._duration
    ) then
        return false, false;
    end

    local old_dr = self._dr;

    if spell:hasNoDr() == true then
        self._auras:add(aura);

        return true, false;
    end

    if (
        applied > self._expiration - self._duration and
        (
            dr ~= self._dr or
            self._auras:size() == 1
        )
    ) then
        self._duration   = duration;
        self._expiration = expiration;
        self._spell      = spell;
        self._dr         = dr;
        self._dr_next    = self._cat:statusNext(self._dr);
    end

    return true, self._dr == opvp.CrowdControlStatus.FULL or old_dr ~= self._dr;
end

function opvp.CrowdControlCategoryState:_onAuraUpdated(aura, spell)
    return self:_onAuraAdded(aura, spell);
end

function opvp.CrowdControlCategoryState:_onAuraRemoved(aura, spell)
    if self._auras:remove(aura) == false then
        return false;
    elseif self._auras:isEmpty() == false then
        return true;
    end

    self._spell      = opvp.SpellExt:null();
    self._dr         = self._dr_next;
    self._dr_next    = self._cat:statusNext(self._dr);
    self._duration   = 0;
    self._expiration = 0;

    self._dr_reset = aura:expiration() + self._cat:resetTime();

    return true;
end
