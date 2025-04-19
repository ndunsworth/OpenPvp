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

local opvp_cc_type_lookup;

local opvp_cc_status_name_lookup = {
    opvp.strs.CC_FULL,
    opvp.strs.CC_HALF,
    opvp.strs.CC_QUARTER,
    opvp.strs.CC_TAUNT_2,
    opvp.strs.CC_TAUNT_3,
    opvp.strs.CC_TAUNT_4,
    opvp.strs.CC_IMMUNE
};

local opvp_cc_status_next_lookup = {
    opvp.CrowdControlStatus.HALF,
    opvp.CrowdControlStatus.QUARTER,
    opvp.CrowdControlStatus.IMMUNE,
    opvp.CrowdControlStatus.TAUNT_3,
    opvp.CrowdControlStatus.TAUNT_4,
    opvp.CrowdControlStatus.IMMUNE,
    opvp.CrowdControlStatus.FULL
};

opvp.CrowdControlCategory = opvp.CreateClass();

function opvp.CrowdControlCategory:fromType(id)
    local result = opvp_cc_type_lookup[id];

    if result ~= nil then
        return result;
    else
        return opvp.CrowdControlCategory.NONE;
    end
end

function opvp.CrowdControlCategory:init(id, name, display)
    self._id      = id;
    self._name    = name;
    self._display = display;
end

function opvp.CrowdControlCategory:displayName()
    return self._display;
end

function opvp.CrowdControlCategory:id()
    return self._id;
end

function opvp.CrowdControlCategory:isAny(mask)
    return bit.band(mask, self._id) ~= 0;
end

function opvp.CrowdControlCategory:isDisarm()
    return self._id == opvp.CrowdControlType.DISARM;
end

function opvp.CrowdControlCategory:isDisorient()
    return self._id == opvp.CrowdControlType.DISORIENT;
end

function opvp.CrowdControlCategory:isIncapacitate()
    return self._id == opvp.CrowdControlType.INCAPACITATE;
end

function opvp.CrowdControlCategory:isKnockback()
    return self._id == opvp.CrowdControlType.KNOCKBACK;
end

function opvp.CrowdControlCategory:isNull()
    return self._id == opvp.CrowdControlType.NONE;
end

function opvp.CrowdControlCategory:isRoot()
    return self._id == opvp.CrowdControlType.ROOT;
end

function opvp.CrowdControlCategory:isSilence()
    return self._id == opvp.CrowdControlType.SILENCE;
end

function opvp.CrowdControlCategory:isStun()
    return self._id == opvp.CrowdControlType.STUN;
end

function opvp.CrowdControlCategory:isTaunt()
    return self._id == opvp.CrowdControlType.TAUNT;
end

function opvp.CrowdControlCategory:name()
    return self._name;
end

function opvp.CrowdControlCategory:nameForStatus(status)
    local name = opvp_cc_status_name_lookup[status];

    if name ~= nil then
        return name;
    else
        return "";
    end
end

function opvp.CrowdControlCategory:resetTime()
    if self._id == opvp.CrowdControlType.KNOCKBACK then
        return 10;
    else
        return 18;
    end
end

function opvp.CrowdControlCategory:statusForTime(appliedTime, baseTime)
    if appliedTime <= 0 then
        return opvp.CrowdControlStatus.IMMUNE;
    elseif appliedTime >= baseTime then
        return opvp.CrowdControlStatus.FULL;
    end

    baseTime = baseTime / 2;

    if appliedTime >= baseTime then
        return opvp.CrowdControlStatus.HALF;
    else
        return opvp.CrowdControlStatus.QUARTER;
    end
end

function opvp.CrowdControlCategory:statusNext(status)
    if self._id == opvp.CrowdControlType.KNOCKBACK then
        if status == opvp.CrowdControlStatus.FULL then
            return opvp.CrowdControlStatus.IMMUNE;
        else
            return opvp.CrowdControlStatus.FULL;
        end
    elseif (
        self._id == opvp.CrowdControlType.TAUNT and
        status == opvp.CrowdControlStatus.FULL
    ) then
        return opvp.CrowdControlStatus.TAUNT_2;
    else
        local result = opvp_cc_status_next_lookup[status];

        if result ~= nil then
            return result;
        else
            return opvp.CrowdControlStatus.FULL;
        end
    end
end

function opvp.CrowdControlCategory:timeForStatus(baseTime, status)
    return 0;
end

opvp.CrowdControlCategory.NONE = opvp.CrowdControlCategory(
    opvp.CrowdControlType.NONE,
    "",
    ""
);

opvp.CrowdControlCategory.DISARM = opvp.CrowdControlCategory(
    opvp.CrowdControlType.DISARM,
    opvp.strs.CC_DISARM_NAME,
    opvp.strs.CC_DISARM_DISPLAY_NAME
);

opvp.CrowdControlCategory.DISORIENT = opvp.CrowdControlCategory(
    opvp.CrowdControlType.DISORIENT,
    opvp.strs.CC_DISORIENT_NAME,
    opvp.strs.CC_DISORIENT_DISPLAY_NAME
);

opvp.CrowdControlCategory.INCAPACITATE = opvp.CrowdControlCategory(
    opvp.CrowdControlType.INCAPACITATE,
    opvp.strs.CC_INCAPACITATE_NAME,
    opvp.strs.CC_INCAPACITATE_DISPLAY_NAME
);

opvp.CrowdControlCategory.KNOCKBACK = opvp.CrowdControlCategory(
    opvp.CrowdControlType.KNOCKBACK,
    opvp.strs.CC_KNOCKBACK_NAME,
    opvp.strs.CC_KNOCKBACK_DISPLAY_NAME
);

opvp.CrowdControlCategory.ROOT = opvp.CrowdControlCategory(
    opvp.CrowdControlType.ROOT,
    opvp.strs.CC_ROOT_NAME,
    opvp.strs.CC_ROOT_DISPLAY_NAME
);

opvp.CrowdControlCategory.SILENCE = opvp.CrowdControlCategory(
    opvp.CrowdControlType.SILENCE,
    opvp.strs.CC_SILENCE_NAME,
    opvp.strs.CC_SILENCE_DISPLAY_NAME
);

opvp.CrowdControlCategory.STUN = opvp.CrowdControlCategory(
    opvp.CrowdControlType.STUN,
    opvp.strs.CC_STUN_NAME,
    opvp.strs.CC_STUN_DISPLAY_NAME
);

opvp.CrowdControlCategory.TAUNT = opvp.CrowdControlCategory(
    opvp.CrowdControlType.TAUNT,
    opvp.strs.CC_TAUNT_NAME,
    opvp.strs.CC_TAUNT_DISPLAY_NAME
);

opvp_cc_type_lookup = {
    [opvp.CrowdControlType.NONE]         = opvp.CrowdControlCategory.NONE,
    [opvp.CrowdControlType.DISARM]       = opvp.CrowdControlCategory.DISARM,
    [opvp.CrowdControlType.DISORIENT]    = opvp.CrowdControlCategory.DISORIENT,
    [opvp.CrowdControlType.INCAPACITATE] = opvp.CrowdControlCategory.INCAPACITATE,
    [opvp.CrowdControlType.KNOCKBACK]    = opvp.CrowdControlCategory.KNOCKBACK,
    [opvp.CrowdControlType.ROOT]         = opvp.CrowdControlCategory.ROOT,
    [opvp.CrowdControlType.SILENCE]      = opvp.CrowdControlCategory.SILENCE,
    [opvp.CrowdControlType.STUN]         = opvp.CrowdControlCategory.STUN,
    [opvp.CrowdControlType.TAUNT]        = opvp.CrowdControlCategory.TAUNT
};
