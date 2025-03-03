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

local function opvp_options_audio_init()
    local opvp_sample_icon = opvp.utils.textureAtlastMarkup("chatframe-button-icon-voicechat", 16, 16);

    opvp.options.audio = {};

    opvp.options.audio.category = opvp.options.db():createCategory("Audio", "Audio");

    opvp.options.audio.category:setCategoryType(opvp.OptionCategory.CHILD_CATEGORY);

    opvp.options.audio.soundeffect = {};

    opvp.options.audio.soundeffect.category = opvp.options.audio.category:createCategory("SoundEffect", "Sound Effect", "", opvp.OptionCategory.GROUP_CATEGORY);

    --~ Sound Effect / General

    opvp.options.audio.soundeffect.general = {};

    opvp.options.audio.soundeffect.general.category = opvp.options.audio.soundeffect.category:createCategory("General", "General", "", opvp.OptionCategory.GROUP_CATEGORY);

    opvp.options.audio.soundeffect.general.killingBlowEmotes = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BOOL,
        "EmoteKillingBlows",
        "Emote Killing Blows",
        [[
Emote whenever you land a killing blow on another player.

The dropdown allows you to specify how friendly/rude the randomly chosen emote is.

Friendly Emotes:
    BONK
    BOOP
    FLEX
    FORTHEALLIANCE/FORTHEHORDE
    HUG
    MOURN
    NO
    PRAY
    PULSE
    RUFFLE
    SALUTE
    SOOTHE
    VICTORY
    WHISTLE
    WINCE

Rude Emotes:
    BLAME
    BORED
    BYE
    CACKLE
    CHUCKLE
    CRINGE
    FACEPALM
    GIGGLE
    GLOAT
    GOLFCLAP
    GUFFAW
    LAUGH
    MOCK
    PITY
    ROFL
    RUDE
    SHUDDER
    STARE
    TAUNT
    VIOLIN
    YAWN]],
        true
    );

    opvp.options.audio.soundeffect.general.killingBlowEmotesLevel = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.ENUM,
        "EmoteKillingBlowsLevel",
        "",
        "",
        {"Friendly", "Friendly + Rude", "Rude"}
    );

    opvp.options.audio.soundeffect.general.killingBlowEmotesLevel:setFlags(opvp.Option.DONT_SAVE_FLAG, true);
    opvp.options.audio.soundeffect.general.killingBlowEmotesLevel:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.general.pingEmote = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BOOL,
        "PingEmote",
        "Ping Emote",
        [[
Player and teammate pings will emit an emote which is unique to each ping type.

This emote is based on the pinging players race/sex.]],
        true
    );

    opvp.options.audio.soundeffect.general.pingEmoteAssistSample = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BUTTON,
        "PingEmoteAssistSample",
        opvp.utils.textureAtlastMarkup("Ping_Wheel_Icon_Assist", 16, 16),
        "Assist"
    );

    opvp.options.audio.soundeffect.general.pingEmoteAssistSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.general.pingEmoteAttackSample = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BUTTON,
        "PingEmoteAttackSample",
        opvp.utils.textureAtlastMarkup("Ping_Wheel_Icon_Attack", 16, 16),
        "Attack"
    );

    opvp.options.audio.soundeffect.general.pingEmoteAttackSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.general.pingEmoteOmwSample = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BUTTON,
        "PingEmoteOmwSample",
        opvp.utils.textureAtlastMarkup("Ping_Wheel_Icon_OnMyWay", 16, 16),
        "On My Way"
    );

    opvp.options.audio.soundeffect.general.pingEmoteOmwSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.general.pingEmoteWarningSample = opvp.options.audio.soundeffect.general.category:createOption(
        opvp.Option.BUTTON,
        "PingEmoteWarningSample",
        opvp.utils.textureAtlastMarkup("Ping_Wheel_Icon_Warning", 16, 16),
        "Warning"
    );

    opvp.options.audio.soundeffect.general.pingEmoteWarningSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    --~ Sound Effect / Player Options
    opvp.options.audio.soundeffect.player = {};

    opvp.options.audio.soundeffect.player.category = opvp.options.audio.soundeffect.category:createCategory("Player", "Player");

    opvp.options.audio.soundeffect.player.login = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BOOL,
        "LoginGreeting",
        "Login Greeting",
        "Your character will greet you upon login.",
        true
    );

    opvp.options.audio.soundeffect.player.loginSample = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BUTTON,
        "LoginGreetingSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.player.loginSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.player.logout = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BOOL,
        "LogoutGoodbye",
        "Logout Goodbye",
        "Your character will bid you farewell as the \"Logging Out\" timer nears completion.",
        true
    );

    opvp.options.audio.soundeffect.player.logoutSample = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BUTTON,
        "LogoutGoodbyeSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.player.logoutSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.player.queueReady = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BOOL,
        "QueueReady",
        "Queue Ready",
        "Cheer when your pvp Queue pops.",
        true
    );

    opvp.options.audio.soundeffect.player.queueReadySample = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BUTTON,
        "QueueReadySample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.player.queueReadySample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.player.specChange = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BOOL,
        "SpecChange",
        "Spec Change",
        "Changing class specializations. This sound effect is unique to each specialization.",
        true
    );

    opvp.options.audio.soundeffect.player.specChangeSample = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.BUTTON,
        "SpecChangeSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.player.specChangeSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.player.specChangeSampleLabel = opvp.options.audio.soundeffect.player.category:createOption(
        opvp.Option.LABEL,
        "SpecChangeSampleLabel",
        ""
    );

    opvp.options.audio.soundeffect.player.specChangeSampleLabel:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    --~ Sound Effect / Match Options

    opvp.options.audio.soundeffect.match = {};

    opvp.options.audio.soundeffect.match.category = opvp.options.audio.soundeffect.category:createCategory("Match", "Match");

    opvp.options.audio.soundeffect.match.teammateMatchBeginBattlecry = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BOOL,
        "TeammateMatchBeginBattlecry",
        "Teammate Match Begin Battlecries",
        "When the gates open your teammates will emote their best battlecries as they charge onto the field of glory.",
        true
    );

    opvp.options.audio.soundeffect.match.teammateMatchBeginBattlecrySample = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BUTTON,
        "TeammateMatchBeginBattlecrySample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.match.teammateMatchBeginBattlecrySample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.match.teammateCelebration = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BOOL,
        "TeammateCelebrations",
        "Teammate Win Celebrations",
        "In an Arena or Shuffle match your teammates will randomly cheer, congratulate you, or taunt the enemy after a win.",
        true
    );

    opvp.options.audio.soundeffect.match.teammateCelebrationSample = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BUTTON,
        "TeammateCongratulationsSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.match.teammateCelebrationSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.match.teammateDeath = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BOOL,
        "TeammateDeath",
        "Teammate Death",
        "When a teammate dies in an Arena or Shuffle match they will emote a random opps/sigh/sorry.",
        true
    );

    opvp.options.audio.soundeffect.match.teammateDeathSample = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BUTTON,
        "TeammateDeathSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.match.teammateDeathSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.match.teammateGreetings = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BOOL,
        "TeammateGreetings",
        "Teammate Greetings",
        "In an Arena or Shuffle match your teammates will greet you.\n\nThis will only occur the first time a player joins your team in a Shuffle match.",
        true
    );

    opvp.options.audio.soundeffect.match.teammateGreetingsSample = opvp.options.audio.soundeffect.match.category:createOption(
        opvp.Option.BUTTON,
        "TeammateGreetingsSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.match.teammateGreetingsSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    --~ Sound Effect / Pvp

    opvp.options.audio.soundeffect.pvp = {};

    opvp.options.audio.soundeffect.pvp.category = opvp.options.audio.soundeffect.category:createCategory("Pvp", "Pvp");

    opvp.options.audio.soundeffect.pvp.enemyTrinket = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "TrinketUsedEnemySoundEffect",
        "Enemy Player Trinket",
        "Enemy player on trinket use emote. This emote is based on the enemy players race/sex.",
        true
    );

    opvp.options.audio.soundeffect.pvp.enemyTrinketSample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "TrinketUsedEnemySoundEffectSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.enemyTrinketSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.friendlyTrinket = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "TrinketUsedFriendlySoundEffect",
        "Friendly Player Trinket",
        "Friendly player on trinket use emote. This emote is based on the friendly players race/sex.",
        true
    );

    opvp.options.audio.soundeffect.pvp.friendlyTrinketSample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "TrinketUsedFriendlySoundEffectSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.friendlyTrinketSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.ffaZone = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "FFAZoneEnterLeave",
        "FFAZone Enter/Leave",
        "Emits a chime when you enter/leave a FFA zone.",
        true
    );

    opvp.options.audio.soundeffect.pvp.ffaZoneSample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "FFAZoneEnterLeaveSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.ffaZoneSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.netomaticEmotes = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "NetomaticEmote",
        "Net-O-Matic Warning",
        "Your character will emote when a hostile player begins or successfuly casts Net-O-Matic.",
        true
    );

    opvp.options.audio.soundeffect.pvp.netomaticEmotesSample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "NetomaticEmoteSample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.netomaticEmotesSample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.trinketReady = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "TrinketReady",
        "Trinket Medallion Ready",
        "Cheer \"For the Alliance\" or \"For the Horde\" when your pvp medallion trinket comes off cooldown.",
        true
    );

    opvp.options.audio.soundeffect.pvp.trinketReadySample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "TrinketReadySample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.trinketReadySample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.trinketRacialReady = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BOOL,
        "TrinketRacialReady",
        "Trinket Racial Ready",
        "When your racial pvp trinket comes off cooldown.  Only valid for human/undead races.",
        true
    );

    opvp.options.audio.soundeffect.pvp.trinketRacialReadySample = opvp.options.audio.soundeffect.pvp.category:createOption(
        opvp.Option.BUTTON,
        "TrinketRacialReadySample",
        opvp_sample_icon
    );

    opvp.options.audio.soundeffect.pvp.trinketRacialReadySample:setFlags(opvp.Option.NEW_LINE_FLAG, false);

    opvp.options.audio.soundeffect.pvp.trinketRacialReadySample:setEnabled(opvp.player.hasPvpRacialTrinket());
end

opvp.OnAddonLoad:register(opvp_options_audio_init);
