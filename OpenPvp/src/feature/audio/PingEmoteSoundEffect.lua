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

opvp.PingEmoteSoundEffect = opvp.CreateClass(opvp.SoundEffect);

function opvp.PingEmoteSoundEffect:init(option)
    opvp.SoundEffect.init(self, option);
end

function opvp.PingEmoteSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.PingEmoteSoundEffect:_onFeatureActivated()
    opvp.event.CHAT_MSG_PING:connect(
        self,
        self._onPing
    );

    opvp.SoundEffect._onFeatureActivated(self)
end

function opvp.PingEmoteSoundEffect:_onFeatureDeactivated()
    opvp.event.CHAT_MSG_PING:disconnect(
        self,
        self._onPing
    );

    opvp.SoundEffect._onFeatureDeactivated(self)
end

function opvp.PingEmoteSoundEffect:_onPing(
    text,
    playerName,
    languageName,
    channelName,
    playerName2,
    specialFlags,
    zoneChannelID,
    channelIndex,
    channelBaseName,
    languageID,
    lineID,
    guid,
    bnSenderID,
    isMobile,
    isSubtitle,
    hideSenderInLetterbox,
    supressRaidIcons
)
    local ping_src = string.match(
        text,
        "|Hplayer:(%S+)|h"
    );

    local ping_type = string.match(
        text,
        "|A:ping_chat_%S+:0:0:0:0|a"
    );

    local ping;

    if ping_type == opvp.Ping.ATTACK:markup() then
        ping = opvp.PingType.ATTACK;
    elseif ping_type == opvp.Ping.ASSIST:markup() then
        ping = opvp.PingType.ASSIST;
    elseif ping_type == opvp.Ping.ON_MY_WAY:markup() then
        ping = opvp.PingType.ON_MY_WAY;
    elseif ping_type == opvp.Ping.WARNING:markup() then
        ping = opvp.PingType.WARNING;
    else
        ping = opvp.PingType.NONE;
    end

    if ping ~= opvp.NO_PING then
        local unit = opvp.Unit:createFromUnitGuid(UnitGUID(ping_src));

        opvp.effect.pingEmote(ping, unit:race(), unit:sex());
    end
end

function opvp.effect.pingEmote(ping, race, sex)
    local sound = opvp.effect.pingEmoteSound(ping, race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.pingEmoteSound(ping, race)
    if ping == opvp.PingType.ASSIST then
        return opvp.Emote.HELP:sound(race);
    elseif ping == opvp.PingType.ATTACK then
        return opvp.Emote.ATTACK_TARGET:sound(race);
    elseif ping == opvp.PingType.ON_MY_WAY then
        return opvp.Emote.FOLLOW_ME:sound(race);
    elseif ping == opvp.PingType.WARNING then
        return opvp.Emote.WHOA:sound(race);
    else
        return opvp.Emote.UNKNOWN:sound(race);
    end
end

local opvp_ping_emote_sound_effect;

local function opvp_ping_emote_sound_effect_assist_sample(button, state)
    if state == false then
        PlaySound(233592, opvp.SoundChannel.SFX);

        opvp.effect.pingEmote(
            opvp.PingType.ASSIST,
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_ping_emote_sound_effect_attack_sample(button, state)
    if state == false then
        PlaySound(233593, opvp.SoundChannel.SFX);

        opvp.effect.pingEmote(
            opvp.PingType.ATTACK,
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_ping_emote_sound_effect_omw_sample(button, state)
    if state == false then
        PlaySound(233594, opvp.SoundChannel.SFX);

        opvp.effect.pingEmote(
            opvp.PingType.ON_MY_WAY,
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_ping_emote_sound_effect_warning_sample(button, state)
    if state == false then
        PlaySound(233595, opvp.SoundChannel.SFX);

        opvp.effect.pingEmote(
            opvp.PingType.WARNING,
            math.random(1, opvp.MAX_RACE),
            math.random(1, 2)
        );
    end
end

local function opvp_ping_emote_sound_effect_ctor()
    opvp_ping_emote_sound_effect = opvp.PingEmoteSoundEffect(
        opvp.options.audio.soundeffect.general.pingEmote
    );

    opvp.options.audio.soundeffect.general.pingEmoteAssistSample.clicked:connect(
        opvp_ping_emote_sound_effect_assist_sample
    );

    opvp.options.audio.soundeffect.general.pingEmoteAttackSample.clicked:connect(
        opvp_ping_emote_sound_effect_attack_sample
    );

    opvp.options.audio.soundeffect.general.pingEmoteOmwSample.clicked:connect(
        opvp_ping_emote_sound_effect_omw_sample
    );

    opvp.options.audio.soundeffect.general.pingEmoteWarningSample.clicked:connect(
        opvp_ping_emote_sound_effect_warning_sample
    );
end

opvp.OnAddonLoad:register(opvp_ping_emote_sound_effect_ctor);
