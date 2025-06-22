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

opvp.FactionCheerEmote = opvp.CreateClass(opvp.Emote);

function opvp.FactionCheerEmote:init()
    self._emotes = {
        [opvp.ALLIANCE] = opvp.Emote.FOR_THE_ALLIANCE,
        [opvp.HORDE]    = opvp.Emote.FOR_THE_HORDE,
        [opvp.NEUTRAL]  = opvp.Emote.UNKNOWN
    }
end

function opvp.FactionCheerEmote:emote(unitId)
    self:_emote():emote(unitId);
end

function opvp.FactionCheerEmote:hasSound()
    return self:_emote():hasSound();
end

function opvp.FactionCheerEmote:id()
    return opvp.EmoteId.FOR_THE_FACTION;
end

function opvp.FactionCheerEmote:name()
    return "forthefaction";
end

function opvp.FactionCheerEmote:playSound(race, sex, channel, noDupes)
    self:_emote():playSound(race, sex, channel, noDupes);
end

function opvp.FactionCheerEmote:sound(race)
    return self:_emote():sound(race);
end

function opvp.FactionCheerEmote:_emote()
    return self._emotes[opvp.player.faction()];
end

opvp.Emote.FOR_THE_FACTION = opvp.FactionCheerEmote();

table.insert(opvp.Emote.EMOTES, opvp.Emote.FOR_THE_FACTION);
