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

opvp.CombatLogLogicalOp = opvp.CreateClass(opvp.CombatLogLogicalOpCondition);

opvp.CombatLogLogicalOp.AND                    = 1;
opvp.CombatLogLogicalOp.OR                     = 2;

opvp.CombatLogLogicalOp.BIT_AND                = 1;
opvp.CombatLogLogicalOp.BIT_OR                 = 2;
opvp.CombatLogLogicalOp.BIT_XOR                = 3;

opvp.CombatLogLogicalOp.CMP_EQUAL              = 1;
opvp.CombatLogLogicalOp.CMP_GREATER_THAN       = 2;
opvp.CombatLogLogicalOp.CMP_GREATER_THAN_EQUAL = 3;
opvp.CombatLogLogicalOp.CMP_LESS_THAN          = 4;
opvp.CombatLogLogicalOp.CMP_LESS_THAN_EQUAL    = 5;
opvp.CombatLogLogicalOp.CMP_NOT_EQUAL          = 6;

opvp.CombatLogLogicalOp.DESTINATION            = "dest";
opvp.CombatLogLogicalOp.SOURCE                 = "source";

opvp.CombatLogLogicalOp.GUID                   = "GUID";
opvp.CombatLogLogicalOp.FLAGS                  = "Flags";
opvp.CombatLogLogicalOp.NAME                   = "Name";
opvp.CombatLogLogicalOp.RAIDFLAGS              = "RaidFlags";

opvp.CombatLogLogicalOp.BIT_TYPE_STR = {
    [opvp.CombatLogLogicalOp.BIT_AND] = "&",
    [opvp.CombatLogLogicalOp.BIT_OR]  = "|",
    [opvp.CombatLogLogicalOp.BIT_XOR] = "^"
};

opvp.CombatLogLogicalOp.CMP_TYPE_STR = {
    [opvp.CombatLogLogicalOp.CMP_EQUAL]              = "==",
    [opvp.CombatLogLogicalOp.CMP_GREATER_THAN]       = ">",
    [opvp.CombatLogLogicalOp.CMP_GREATER_THAN_EQUAL] = ">=",
    [opvp.CombatLogLogicalOp.CMP_LESS_THAN]          = "<",
    [opvp.CombatLogLogicalOp.CMP_LESS_THAN_EQUAL]    = "<=",
    [opvp.CombatLogLogicalOp.CMP_NOT_EQUAL]          = "~="
};

opvp.CombatLogLogicalOp.MATCH_TYPE_STR = {
    [opvp.CombatLogLogicalOp.AND] = "and",
    [opvp.CombatLogLogicalOp.OR] = "or",
};

function opvp.CombatLogLogicalOp:init(matchOp)
    if matchOp ~= nil then
        self._match_op = matchOp;
    else
        self._match_op = opvp.CombatLogLogicalOp.AND;
    end

    self._ops = opvp.List();
end

function opvp.CombatLogLogicalOp:addCondition(condition)
    self:insertCondition(0, condition);
end

function opvp.CombatLogLogicalOp:appendCondition(condition)
    self:insertCondition(-1, condition);
end

function opvp.CombatLogLogicalOp:clear()
    self._ops:clear();
end

function opvp.CombatLogLogicalOp:eval(info)
    if self._match_op == opvp.CombatLogLogicalOp.AND then
        for n=1,self._ops:size() do
            local op = self._ops:item(n);

            if op:eval(info) == false then
                return false;
            end
        end

        return true;
    else
        for n=1,self._ops:size() do
            local op = self._ops:item(n);

            if op:eval(info) == true then
                return true;
            end
        end

        return self._ops:isEmpty();
    end
end

function opvp.CombatLogLogicalOp:insertCondition(index, condition)
    if (
        condition == nil or
        condition == self or
        self._ops:contains(condition) == true or
        (
            opvp.IsInstance(condition, opvp.CombatLogLogicalOp) and
            condition:isChild(self) == true
        )
    ) then
        return;
    end

    self._ops:insert(index, condition);
end

function opvp.CombatLogLogicalOp:isChild(condition)
    for n=1,self._ops:size() do
        local op = self._ops:item(n);

        if (
            op == condition or
            (
                opvp.IsInstance(op, opvp.CombatLogLogicalOp) == true and
                op:isChild(condition) == true
            )
        ) then
            return true;
        end
    end

    return false;
end

function opvp.CombatLogLogicalOp:isEmpty()
    return self._ops:isEmpty();
end

function opvp.CombatLogLogicalOp:isParent(condition)
    return condition:isChild(self);
end

function opvp.CombatLogLogicalOp:matchOp()
    return self._match_op;
end

function opvp.CombatLogLogicalOp:removeCondition(condition)
    return self._ops:removeItem(condition);
end

function opvp.CombatLogLogicalOp:setMatchOp(matchOp)
    self._match_op = matchOp;
end

function opvp.CombatLogLogicalOp:size()
    return self._ops:size();
end

function opvp.CombatLogLogicalOp:toScript()
    local op_data = {};

    for n=1,self._ops:size() do
        local op = self._ops:item(n);

        table.insert(op_data, op:toScript());
    end

    return {ops=op_data};
end

function opvp.CombatLogLogicalOp:toString()
    if self._ops:isEmpty() then
        return "(true)";
    end

    local op_strs = {};

    for n=1,self._ops:size() do
        local op_str = self._ops:item(n):toString();

        if op_str and op_str ~= "" then
            table.insert(op_strs, op_str);
        end
    end

    if #op_strs > 0 then
        return string.format(
            "(%s)",
            table.concat(
                op_strs,
                string.format(
                    " %s ",
                    opvp.CombatLogLogicalOp.MATCH_TYPE_STR[self._match_op]
                )
            )
        );
    else
        return "(true)";
    end
end
