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

local function logic_op_cmp_equal(a, b)              return a == b; end
local function logic_op_cmp_greater_than(a, b)       return a > b; end
local function logic_op_cmp_greater_than_equal(a, b) return a >= b; end
local function logic_op_cmp_less_than(a, b)          return a < b; end
local function logic_op_cmp_less_than_equal(a, b)    return a <= b; end
local function logic_op_cmp_not_equal(a, b)          return a ~= b; end

opvp.CompareCombatLogCondition = opvp.CreateClass(opvp.CombatLogLogicalOpCondition);

opvp.CompareCombatLogCondition.BIT_OPS = {
    [opvp.CombatLogLogicalOp.BIT_AND] = bit.band,
    [opvp.CombatLogLogicalOp.BIT_OR]  = bit.bor,
    [opvp.CombatLogLogicalOp.BIT_XOR] = bit.bxor
}

opvp.CompareCombatLogCondition.CMP_OPS = {
    [opvp.CombatLogLogicalOp.CMP_EQUAL]              = logic_op_cmp_equal;
    [opvp.CombatLogLogicalOp.CMP_GREATER_THAN]       = logic_op_cmp_greater_than;
    [opvp.CombatLogLogicalOp.CMP_GREATER_THAN_EQUAL] = logic_op_cmp_greater_than_equal;
    [opvp.CombatLogLogicalOp.CMP_LESS_THAN]          = logic_op_cmp_less_than;
    [opvp.CombatLogLogicalOp.CMP_LESS_THAN_EQUAL]    = logic_op_cmp_less_than_equal;
    [opvp.CombatLogLogicalOp.CMP_NOT_EQUAL]          = logic_op_cmp_not_equal;
}

function opvp.CompareCombatLogCondition:init(cmpOp, matchOp)
    self._cmp_op = cmpOp;

    if cmpOp ~= nil then
        self._cmp_op = matchOp;
    else
        self._cmp_op = opvp.CombatLogLogicalOp.CMP_EQUAL;
    end

    if matchOp ~= nil then
        self._match_op = matchOp;
    else
        self._match_op = opvp.CombatLogLogicalOp.AND;
    end

    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];
end

function opvp.CompareCombatLogCondition:compare(a, b)
    return self._cmp_fn(a, b);
end

function opvp.CompareCombatLogCondition:compareOp()
    return self._cmp_op;
end

function opvp.CompareCombatLogCondition:matchOp()
    return self._match_op;
end

function opvp.CompareCombatLogCondition:setCompareOp(op)
    self._cmp_op = op;

    self._cmp_fn = opvp.CompareCombatLogCondition.CMP_OPS[self._cmp_op];
end

function opvp.CompareCombatLogCondition:setMatchOp(matchOp)
    self._match_op = matchOp;
end

function opvp.CompareCombatLogCondition:toScript()
    local data = {
        cmp_op    = self._cmp_op,
        match_op  = self._match_op
    };

    return data;
end
