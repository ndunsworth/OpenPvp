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

local opvp_faction_pvp_warn;
local opvp_faction_sound_bg_loss;
local opvp_faction_sound_bg_win;

opvp.Faction = opvp.CreateClass();

function opvp.Faction:fromGUID(guid)
    return opvp.Faction:fromPlayerLocation(
        PlayerLocation:CreateFromGUID(guid)
    );
end

function opvp.Faction:fromId(id)
    if id == opvp.ALLIANCE then
        return opvp.Faction.ALLIANCE;
    elseif id == opvp.HORDE then
        return opvp.Faction.HORDE;
    else
        return opvp.Faction.NEUTRAL;
    end
end

function opvp.Faction:fromPlayerLocation(location)
    local race_id = C_PlayerInfo.GetRace(location);

    if race_id ~= nil then
        return opvp.Faction:fromRaceId(race_id);
    else
        return opvp.Faction.NEUTRAL;
    end
end

function opvp.Faction:fromRaceId(id)
    local info = C_CreatureInfo.GetFactionInfo(id);

    if info ~= nil then
        if info.name == PLAYER_FACTION_GROUP[PLAYER_FACTION_GROUP.Alliance] then
            return opvp.Faction.ALLIANCE;
        elseif info.name == PLAYER_FACTION_GROUP[PLAYER_FACTION_GROUP.Horde] then
            return opvp.Faction.HORDE;
        end
    end

    return opvp.Faction.NEUTRAL;
end

function opvp.Faction:init(id, name)
   self._id = id;
   self._name = name;
end

function opvp.Faction:battlegroundLostSound()
    return opvp_faction_sound_bg_loss:sound(self._id);
end

function opvp.Faction:battlegroundWinSound()
    return opvp_faction_sound_bg_win:sound(self._id);
end

function opvp.Faction:pvpWarningSound()
    return opvp_faction_pvp_warn:sound(self._id);
end

function opvp.Faction:instance()
    return opvp.Player:instance():factionInfo();
end

function opvp.Faction:id()
    return self._id;
end

function opvp.Faction:isAlliance()
    return self._id == opvp.ALLIANCE
end

function opvp.Faction:isHorde()
    return self._id == opvp.HORDE
end

function opvp.Faction:isNeutral()
    return self._id == opvp.NEUTRAL
end

function opvp.Faction:oppositeFaction()
    if self._id == opvp.ALLIANCE then
        return opvp.Faction.HORDE;
    elseif self._id == opvp.HORDE then
        return opvp.Faction.ALLIANCE;
    else
        return opvp.Faction.NEUTRAL;
    end
end

function opvp.Faction:name()
    return self._name;
end

local function opvp_faction_sounds_init()
    opvp_faction_pvp_warn = opvp.FactionSound(
        opvp.SoundKitSound(8456),
        opvp.SoundKitSound(8457)
    );

    opvp_faction_sound_bg_loss = opvp.FactionSound(
        opvp.SoundKitSound(8454),
        opvp.SoundKitSound(8455)
    );

    opvp_faction_sound_bg_win = opvp.FactionSound(
        opvp.SoundKitSound(8455),
        opvp.SoundKitSound(8454)
    );
end

opvp.OnAddonLoad:register(opvp_faction_sounds_init);
