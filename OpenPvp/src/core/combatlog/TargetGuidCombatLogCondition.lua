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

opvp.TargetGuidCombatLogCondition = opvp.CreateClass(opvp.TargetCombatLogCondition);

function opvp.TargetGuidCombatLogCondition:init(target, cmpOp, values)
    opvp.TargetCombatLogCondition.init(self, target);

    self._values = opvp.List();

    if opvp.is_str(values) then
        self._values:append(values);
    elseif opvp.is_table(values) then
        self._values:merge(values);
    end

    if cmpOp ~= nil then
        self._cmp_op = cmpOp;
    else
        self._cmp_op = opvp.CombatLogLogicalOp.CMP_EQUAL;
    end

    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];
end

function opvp.TargetGuidCombatLogCondition:compare(value)
    return self._cmp_fn(
        self._bit_fn(value, self._mask),
        self._value
    );
end

function opvp.TargetGuidCombatLogCondition:compareOp()
    return self._cmp_op;
end

function opvp.TargetGuidCombatLogCondition:eval(info)
    if self:isDestination() == true then
        return self:compare(info.destGUID);
    else
        return self:compare(info.sourceGUID);
    end
end

function opvp.TargetGuidCombatLogCondition:setCompareOp(op)
    self._cmp_op = op;
    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];
end

function opvp.TargetFlagsCombatLogCondition:setValues(values)
    self._values:clear();

    if opvp.is_str(values) then
        self._values:append(values);
    elseif opvp.is_table(values) then
        self._values:merge(values);
    end
end

function opvp.TargetGuidCombatLogCondition:toScript()
    local data = opvp.TargetCombatLogCondition.toScript(self);

    data.cmp_op = self._cmp_op;
    data.values = self._values:items();

    return data;
end

function opvp.TargetGuidCombatLogCondition:toString()
    local cmp_str = opvp.CombatLogLogicalOp.CMP_TYPE_STR[self._cmp_op];
    local field;

    if self:isDestination() == true then
        field = "info.destFlags";
    else
        field = "info.sourceFlags";
    end

    if self._values:isEmpty() == false then
        return string.format(
            "(%s %s {%s})",
            field,
            cmp_str,
            table.concat(self._spells, ",")
        );
    else
        return string.format(
            "(%s %s {})",
            field,
            cmp_str
        );
    end
end

function opvp.TargetGuidCombatLogCondition:value()
    return self._value;
end
