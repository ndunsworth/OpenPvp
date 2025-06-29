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

opvp.private.FriendlyTrinketUsedSoundEffect = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.FriendlyTrinketUsedSoundEffect:init()
    opvp.OptionFeature.init(self, opvp.options.audio.soundeffect.pvp.friendlyTrinket);

    self._monitor_connected = false;
    self._ignore_range      = opvp.player.isRace(opvp.DRACTHYR);
end

function opvp.private.FriendlyTrinketUsedSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onFeatureActivated()
    self:_setMonitorConnected(opvp.match.inMatch() == false);

    opvp.OptionFeature._onFeatureActivated(self)
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onFeatureDeactivated()
    self:_setMonitorConnected(false);

    opvp.OptionFeature._onFeatureDeactivated(self)
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onFeatureDisabled()
    opvp.match.entered:disconnect(self, self._onMatchEntered);
    opvp.match.exit:disconnect(self, self._onMatchExit);
    opvp.match.playerTrinket:disconnect(self, self._onMatchTrinketUsed);

    opvp.OptionFeature._onFeatureDisabled(self)
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onFeatureEnabled()
    opvp.match.entered:connect(self, self._onMatchEntered);
    opvp.match.exit:connect(self, self._onMatchExit);
    opvp.match.playerTrinket:connect(self, self._onMatchTrinketUsed);

    opvp.OptionFeature._onFeatureEnabled(self)
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onMatchEntered()
    self:_setMonitorConnected(false);
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onMatchExit()
    self:_setMonitorConnected(true);
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onMatchTrinketUsed(
    member,
    spellId,
    timestamp
)
    if (
        member:isHostile() == false and
        member:isPlayer() == false and
        (
            self._ignore_range == true or
            member:inRange() == true
        ) and
        member:isRaceKnown() == true and
        member:isSexKnown() == true
    ) then
        opvp.effect.friendlyTrinketEmote(member:race(), member:sex());
    end
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_onTrinketUsed(
    timestamp,
    guid,
    name,
    spellId,
    hostile
)
    if hostile == true or guid == opvp.player.guid() then
        return;
    end

    local unit = opvp.Unit:createFromUnitGuid(guid);

    if unit:isNull() == false then
        opvp.effect.friendlyTrinketEmote(unit:race(), unit:sex());
    end
end

function opvp.private.FriendlyTrinketUsedSoundEffect:_setMonitorConnected(state)
    if state == self._monitor_connected then
        return;
    end

    local monitor = opvp.PvpTrinketMonitor:instance();

    if state == true then
        monitor.trinketUsed:connect(
            self,
            self._onTrinketUsed
        );
    else
        monitor.trinketUsed:disconnect(
            self,
            self._onTrinketUsed
        );
    end

    self._monitor_connected = state;
end

function opvp.effect.friendlyTrinketEmote(race, sex)
    local sound = opvp.effect.friendlyTrinketEmoteSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, false);
end

function opvp.effect.friendlyTrinketEmoteSound(race)
    return opvp.Emote.THREATEN:sound(race);
end

local opvp_friendly_trinket_used_emote_sound_effect;

local function opvp_friendly_trinket_used_emote_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.friendlyTrinketEmote(
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_friendly_trinket_used_emote_sound_effect_ctor()
    opvp_friendly_trinket_used_emote_sound_effect = opvp.private.FriendlyTrinketUsedSoundEffect();

    opvp.options.audio.soundeffect.pvp.friendlyTrinketSample.clicked:connect(
        opvp_friendly_trinket_used_emote_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_friendly_trinket_used_emote_sound_effect_ctor);
