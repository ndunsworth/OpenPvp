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

opvp.CombatLogEvent = opvp.CreateClass();

opvp.CombatLogEvent.NPC_FRIENDLY_MASK    = bit.bor(COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_REACTION_FRIENDLY);
opvp.CombatLogEvent.NPC_HOSTILE_MASK     = bit.bor(COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_REACTION_HOSTILE);
opvp.CombatLogEvent.PLAYER_FRIENDLY_MASK = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY);
opvp.CombatLogEvent.PLAYER_HOSTILE_MASK  = bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE);

function opvp.CombatLogEvent:init()
    self.timestamp       = 0;
    self.subevent        = "";
    self.hideCaster      = false;
    self.sourceGUID      = "";
    self.sourceName      = "";
    self.sourceFlags     = 0;
    self.sourceRaidFlags = 0;
    self.destGUID        = "";
    self.destName        = "";
    self.destFlags       = 0;
    self.destRaidFlags   = 0
end

function opvp.CombatLogEvent:isDestHostile()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_REACTION_HOSTILE
    ) == COMBATLOG_OBJECT_REACTION_HOSTILE;
end

function opvp.CombatLogEvent:isDestFriendly()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_REACTION_FRIENDLY
    ) == COMBATLOG_OBJECT_REACTION_FRIENDLY;
end

function opvp.CombatLogEvent:isDestFriendlyNPC()
    return bit.band(
        self.destFlags,
         opvp.CombatLogEvent.NPC_FRIENDLY_MASK
    ) == opvp.CombatLogEvent.NPC_FRIENDLY_MASK;
end

function opvp.CombatLogEvent:isDestFriendlyPlayer()
    return bit.band(
        self.destFlags,
         opvp.CombatLogEvent.PLAYER_FRIENDLY_MASK
    ) == opvp.CombatLogEvent.PLAYER_FRIENDLY_MASK;
end

function opvp.CombatLogEvent:isSrcHostileNPC()
    return bit.band(
        self.destFlags,
         opvp.CombatLogEvent.NPC_HOSTILE_MASK
    ) == opvp.CombatLogEvent.NPC_HOSTILE_MASK;
end

function opvp.CombatLogEvent:isDestHostilePlayer()
    return bit.band(
        self.destFlags,
         opvp.CombatLogEvent.PLAYER_HOSTILE_MASK
    ) == opvp.CombatLogEvent.PLAYER_HOSTILE_MASK;
end

function opvp.CombatLogEvent:isDestMine()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_AFFILIATION_MINE
    ) == COMBATLOG_OBJECT_AFFILIATION_MINE;
end

function opvp.CombatLogEvent:isDestNeutral()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_REACTION_NEUTRAL
    ) == COMBATLOG_OBJECT_REACTION_NEUTRAL;
end

function opvp.CombatLogEvent:isDestNPC()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_CONTROL_NPC
    ) == COMBATLOG_OBJECT_CONTROL_NPC;
end

function opvp.CombatLogEvent:isDestPlayer()
    return bit.band(
        self.destFlags,
        COMBATLOG_OBJECT_TYPE_PLAYER
    ) == COMBATLOG_OBJECT_TYPE_PLAYER;
end

function opvp.CombatLogEvent:isSrcHostile()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_REACTION_HOSTILE
    ) == COMBATLOG_OBJECT_REACTION_HOSTILE;
end

function opvp.CombatLogEvent:isSrcFriendly()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_REACTION_FRIENDLY
    ) == COMBATLOG_OBJECT_REACTION_FRIENDLY;
end

function opvp.CombatLogEvent:isSrcFriendlyNPC()
    return bit.band(
        self.sourceFlags,
         opvp.CombatLogEvent.NPC_FRIENDLY_MASK
    ) == opvp.CombatLogEvent.NPC_FRIENDLY_MASK;
end

function opvp.CombatLogEvent:isSrcFriendlyPlayer()
    return bit.band(
        self.sourceFlags,
         opvp.CombatLogEvent.PLAYER_FRIENDLY_MASK
    ) == opvp.CombatLogEvent.PLAYER_FRIENDLY_MASK;
end

function opvp.CombatLogEvent:isSrcHostileNPC()
    return bit.band(
        self.sourceFlags,
         opvp.CombatLogEvent.NPC_HOSTILE_MASK
    ) == opvp.CombatLogEvent.NPC_HOSTILE_MASK;
end

function opvp.CombatLogEvent:isSrcHostilePlayer()
    return bit.band(
        self.sourceFlags,
         opvp.CombatLogEvent.PLAYER_HOSTILE_MASK
    ) == opvp.CombatLogEvent.PLAYER_HOSTILE_MASK;
end

function opvp.CombatLogEvent:isSrcMine()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_AFFILIATION_MINE
    ) == COMBATLOG_OBJECT_AFFILIATION_MINE;
end

function opvp.CombatLogEvent:isSrcNeutral()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_REACTION_NEUTRAL
    ) == COMBATLOG_OBJECT_REACTION_NEUTRAL;
end

function opvp.CombatLogEvent:isSrcNPC()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_CONTROL_NPC
    ) == COMBATLOG_OBJECT_CONTROL_NPC;
end

function opvp.CombatLogEvent:isSrcPlayer()
    return bit.band(
        self.sourceFlags,
        COMBATLOG_OBJECT_TYPE_PLAYER
    ) == COMBATLOG_OBJECT_TYPE_PLAYER;
end

function opvp.CombatLogEvent:update()
    self.timestamp,
    self.subevent,
    self.hideCaster,
    self.sourceGUID,
    self.sourceName,
    self.sourceFlags,
    self.sourceRaidFlags,
    self.destGUID,
    self.destName,
    self.destFlags,
    self.destRaidFlags = CombatLogGetCurrentEventInfo();

    --~ opvp.printDebug(
--~ [[
--~ COMBAT_LOG_EVENT_UNFILTERED {
    --~ timestamp = %d,
    --~ subevent = %s,
    --~ hideCaster = %s,
    --~ sourceGUID = %s,
    --~ sourceName = %s,
    --~ sourceFlags = %d,
    --~ sourceRaidFlags = %d,
    --~ destGUID = %s,
    --~ destName = %s,
    --~ destFlags = %d,
    --~ destRaidFlags = %d
--~ }
--~ ]],
        --~ self.timestamp,
        --~ self.subevent,
        --~ tostring(self.hideCaster),
        --~ tostring(self.sourceGUID),
        --~ tostring(self.sourceName),
        --~ self.sourceFlags,
        --~ self.sourceRaidFlags,
        --~ tostring(self.destGUID),
        --~ tostring(self.destName),
        --~ self.destFlags
    --~ );
end
