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

local opvp_trinket_monitor_singleton;

opvp.PvpTrinketMonitor = opvp.CreateClass(opvp.OptionFeature);

function opvp.PvpTrinketMonitor:instance()
    if opvp_trinket_monitor_singleton ~= nil then
        return opvp_trinket_monitor_singleton;
    end

    opvp_trinket_monitor_singleton = opvp.PvpTrinketMonitor();

    return opvp_trinket_monitor_singleton;
end

function opvp.PvpTrinketMonitor:init()
    self._spell_id_op = opvp.SpellIdCombatLogCondition(
        {
            336126, -- Gladiator's Medallion
            336135, -- Adaptation
            59752,  -- Will to Survive
            7744    -- Will of the Forsaken
        }
    );

    local op = opvp.CombatLogLogicalOp();

    op:addCondition(opvp.SubEventCombatLogCondition("SPELL_CAST_SUCCESS"));

    op:addCondition(
        opvp.TargetFlagsCombatLogCondition(
            opvp.CombatLogLogicalOp.SOURCE,
            opvp.CombatLogLogicalOp.BIT_AND,
            opvp.CombatLogLogicalOp.CMP_EQUAL,
            COMBATLOG_OBJECT_TYPE_PLAYER,
            COMBATLOG_OBJECT_TYPE_PLAYER
        )
    );

    op:addCondition(self._spell_id_op);

    self._event_filter = opvp.CallbackCombatLogFilter(
        function(filter, info)
            self:_onTrintetUsed(info);
        end,
        op
    );

    local player = opvp.player.instance();

    --~ player.inSanctuaryChanged:connect(self, self._onSanctuaryChanged);

    self.trinketUsed = opvp.Signal("opvp.PvpTrinketMonitor.trinketUsed");

    --~ if opvp.player.inSanctuary() == false then
        self._event_filter:connect();
    --~ end
end

function opvp.PvpTrinketMonitor:_onSanctuaryChanged(state)
    if state == true then
        self._event_filter:disconnect();
    elseif self:canActivate() == true then
        self._event_filter:connect();
    end
end

function opvp.PvpTrinketMonitor:_onTrintetUsed(info)
    local spell_id = self._spell_id_op:lastSpellId();

    if opvp.player.guid() == info.sourceGUID then
        opvp.player.instance():_onPvpTrinketUsed(spell_id);
    end

    self.trinketUsed:emit(
        info.sourceGUID,
        info.sourceName,
        spell_id,
        bit.band(info.sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
    );
end
