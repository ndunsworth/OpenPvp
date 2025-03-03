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

opvp.SpellIdCombatLogCondition = opvp.CreateClass(opvp.CompareCombatLogCondition);

function opvp.SpellIdCombatLogCondition:init(spellIds, cmpOp, matchOp)
    opvp.CompareCombatLogCondition.init(self, cmpOp, matchOp);

    if spellIds == nil then
        self._spells = {};
    elseif type(spellIds) == "number" or type(spellIds) == "table" then
        self._spells = spellIds;
    else
        --~ throw;
    end

    self._last_spell = 0;
end

function opvp.SpellIdCombatLogCondition:eval(info)
    local spell_id = select(12, CombatLogGetCurrentEventInfo());

    return self:isValidSpell(spell_id);
end

function opvp.SpellIdCombatLogCondition:isValidSpell(spellId)
    if type(spellId) ~= "number" then
        return false;
    end

    if type(self._spells) == "number" then
        return self:compare(spellId, self._spells);
    end

    if #self._spells == 0 then
        return false;
    end

    self._last_spell = 0;

    if self._match_type == opvp.CombatLogLogicalOp.AND then
        for n=1, #self._spells do
            if self:compare(spellId, self._spells[n]) == false then
                self._last_spell = spellId;

                return false;
            end
        end

        return true;
    else
        for n=1,#self._spells do
            if self:compare(spellId, self._spells[n]) == true then
                self._last_spell = spellId;

                return true;
            end
        end

        return false;
    end
end

function opvp.SpellIdCombatLogCondition:lastSpellId()
    return self._last_spell;
end

function opvp.SpellIdCombatLogCondition:spellIds()
    return opvp.utils.copyTableShallow(self._spells);
end

function opvp.SpellIdCombatLogCondition:setSpellIds(spellIds)
    self._spells = spellIds;
end

function opvp.SpellIdCombatLogCondition:toScript()
    local data = opvp.CompareCombatLogCondition.toScript(self);

    data.spells = opvp.utils.copyTableShallow(self._spells);

    return data;
end

function opvp.SpellIdCombatLogCondition:toString()
    if type(self._spells) == "number" then
        return string.format(
            "info.extraSpellId %s %d",
            opvp.CombatLogLogicalOp.CMP_TYPE_STR[self._cmp_op],
            self._spells
        );
    end

    if #self._spells > 0 then
        return string.format(
            "info.extraSpellId %s {%s}",
            opvp.CombatLogLogicalOp.CMP_TYPE_STR[self._cmp_op],
            table.concat(self._spells, ",")
        );
    else
        return string.format(
            "info.extraSpellId %s {}",
            opvp.CombatLogLogicalOp.CMP_TYPE_STR[self._cmp_op]
        );
    end
end
