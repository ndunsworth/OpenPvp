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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.TargetFlagsCombatLogCondition = opvp.CreateClass(opvp.TargetCombatLogCondition);

function opvp.TargetFlagsCombatLogCondition:init(target, bitOp, cmpOp, mask, value)
    opvp.TargetCombatLogCondition.init(self, target);

    if bitOp ~= nil then
        self._bit_op = bitOp;
    else
        self._bit_op = opvp.CombatLogLogicalOp.BIT_AND;
    end

    if cmpOp ~= nil then
        self._cmp_op = cmpOp;
    else
        self._cmp_op = opvp.CombatLogLogicalOp.CMP_EQUAL;
    end

    self._bit_fn = opvp.CompareCombatLogCondition.BIT_OPS[self._bit_op];
    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];

    self._mask = mask;

    if value ~= nil then
        self._value = value;
    else
        self._value = self._mask;
    end
end

function opvp.TargetFlagsCombatLogCondition:bitOp()
    return self._bit_op;
end

function opvp.TargetFlagsCombatLogCondition:compare(value)
    return self._cmp_fn(
        self._bit_fn(value, self._mask),
        self._value
    );
end

function opvp.TargetFlagsCombatLogCondition:compareOp()
    return self._cmp_op;
end

function opvp.TargetFlagsCombatLogCondition:eval(info)
    if self:isDestination() == true then
        return self:compare(info.destFlags);
    else
        return self:compare(info.sourceFlags);
    end
end

function opvp.TargetFlagsCombatLogCondition:mask()
    return self._mask;
end

function opvp.TargetFlagsCombatLogCondition:setBitOp(op)
    self._bit_op = op;
end

function opvp.TargetFlagsCombatLogCondition:setCompareOp(op)
    self._cmp_op = op;

    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];
end

function opvp.TargetFlagsCombatLogCondition:setMask(mask)
    self._mask = mask;
end

function opvp.TargetFlagsCombatLogCondition:setValue(value)
    self._value = value;
end

function opvp.TargetFlagsCombatLogCondition:toScript()
    local data = opvp.TargetCombatLogCondition.toScript(self);

    data.bit_op = self._bit_op;
    data.cmp_op = self._cmp_op;
    data.mask   = self._mask;
    data.value  = self._value;

    return data;
end

function opvp.TargetFlagsCombatLogCondition:toString()
    local field;

    if self:isDestination() == true then
        field = "info.destFlags";
    else
        field = "info.sourceFlags";
    end

    return string.format(
        "(%s %s %d) %s %d",
        field,
        opvp.CombatLogLogicalOp.BIT_TYPE_STR[self._bit_op],
        self._mask,
        opvp.CombatLogLogicalOp.CMP_TYPE_STR[self._cmp_op],
        self._value
    );
end

function opvp.TargetFlagsCombatLogCondition:value()
    return self._value;
end
