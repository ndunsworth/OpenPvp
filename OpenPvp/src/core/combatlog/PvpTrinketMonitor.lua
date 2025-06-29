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

opvp.PvpTrinketMonitor = opvp.CreateClass(opvp.CombatLogFilter);

function opvp.PvpTrinketMonitor:instance()
    if opvp_trinket_monitor_singleton ~= nil then
        return opvp_trinket_monitor_singleton;
    end

    opvp_trinket_monitor_singleton = opvp.PvpTrinketMonitor();

    return opvp_trinket_monitor_singleton;
end

function opvp.PvpTrinketMonitor:init()
    opvp.CombatLogFilter.init(self, nil);

    self.trinketUsed = opvp.Signal("opvp.PvpTrinketMonitor.trinketUsed");

    self._spell_id_op = opvp.SpellIdCombatLogCondition(
        {
            336126, -- Gladiator's Medallion
            336135, -- Adaptation
            59752,  -- Will to Survive
            7744    -- Will of the Forsaken
        }
    );

    local op = opvp.CombatLogLogicalOp();

    op:addCondition(
        opvp.SubEventCombatLogCondition(opvp.combatlog.SPELL_CAST_SUCCESS)
    );

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

    self:setOp(op);
    --~ local player = opvp.player.instance();

    --~ player.inSanctuaryChanged:connect(self, self._onSanctuaryChanged);

    --~ if opvp.player.inSanctuary() == false then
        self:connect();
    --~ end
end

function opvp.PvpTrinketMonitor:triggered(event)
    local spell_id = self._spell_id_op:lastSpellId();

    local hostile = bit.band(event.sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
    local racial  = opvp.spell.isPvpRacialTrinket(spell_id);

    if opvp.player.guid() == event.sourceGUID then
        opvp.player.instance():_onPvpTrinketUsed(spell_id);
    elseif opvp.match.inMatch(true) == false then
        local info = opvp.guid.playerInfo(event.sourceGUID);

        local do_msg;
        local msg;

        if hostile == true then
            do_msg = opvp.options.announcements.hostileParty.memberTrinket:value();

            if racial == true then
                msg = opvp.strs.TRINKET_RACIAL_HOSTILE_USED;
            else
                msg = opvp.strs.TRINKET_HOSTILE_USED;
            end
        else
            do_msg = opvp.options.announcements.friendlyParty.memberTrinket:value();

            if racial == true then
                msg = opvp.strs.TRINKET_RACIAL_FRIENDLY_USED;
            else
                msg = opvp.strs.TRINKET_FRIENDLY_USED;
            end
        end

        opvp.printMessageOrDebug(
            do_msg,
            msg,
            event.sourceName,
            info.class:colorString(info.race:name() .. " " .. info.class:name())
        );
    end

    self.trinketUsed:emit(
        event.timestamp,
        event.sourceGUID,
        event.sourceName,
        spell_id,
        hostile
    );
end

function opvp.PvpTrinketMonitor:_onSanctuaryChanged(state)
    if state == true then
        self:disconnect();
    elseif self:canActivate() == true then
        self:connect();
    end
end
