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

local opvp_killing_blow_nice_mean_emotes = opvp.List();
local opvp_killing_blow_target_nice_mean_emotes = opvp.List();

local opvp_killing_blow_nice_emotes = opvp.List:createFromArray(
    {
        "FLEX",
        "FORTHE",
        "NO",
        "MOURN",
        "VICTORY",
        "WHISTLE",
        "WINCE"
    }
);

local opvp_killing_blow_mean_emotes = opvp.List:createFromArray(
    {
        "FACEPALM",
        "GIGGLE",
        "GLOAT",
        "LAUGH",
        "PITY",
        "RUDE",
        "SALUTE",
        "SHUDDER",
        "YAWN"
    }
);

local opvp_killing_blow_target_nice_emotes = opvp.List:createFromArray(
    {
        "BONK",
        "BOOP",
        "FLEX",
        "FORTHE",
        "HUG",
        "NO",
        "MOURN",
        "PULSE",
        "PRAY",
        "RUFFLE",
        "SOOTHE",
        "VICTORY",
        "WHISTLE",
        "WINCE"
    }
);

local opvp_killing_blow_target_mean_emotes = opvp.List:createFromArray(
    {
        "BLAME",
        "BORED",
        "BYE",
        "CACKLE",
        "CHUCKLE",
        "CRINGE",
        "FACEPALM",
        "GIGGLE",
        "GLOAT",
        "GOLFCLAP",
        "GUFFAW",
        "LAUGH",
        "MOCK",
        "PITY",
        "ROFL",
        "RUDE",
        "SHUDDER",
        "STARE",
        "TAUNT",
        "VIOLIN",
        "YAWN"
    }
);

opvp.private.EmoteKillingBlowSoundEffect = opvp.CreateClass(opvp.OptionFeature);

function opvp.private.EmoteKillingBlowSoundEffect:init(option)
    opvp.OptionFeature.init(self, option);

    self._emotes = {
        {
            opvp_killing_blow_nice_emotes,
            opvp_killing_blow_nice_mean_emotes,
            opvp_killing_blow_mean_emotes
        },
        {
            opvp_killing_blow_target_nice_emotes,
            opvp_killing_blow_target_nice_mean_emotes,
            opvp_killing_blow_target_mean_emotes
        }
    };

    local op = opvp.CombatLogLogicalOp();

    op:addCondition(opvp.SubEventCombatLogCondition(opvp.combatlog.PARTY_KILL));

    op:addCondition(
        opvp.TargetFlagsCombatLogCondition(
            opvp.CombatLogLogicalOp.SOURCE,
            opvp.CombatLogLogicalOp.BIT_AND,
            opvp.CombatLogLogicalOp.CMP_EQUAL,
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_AFFILIATION_MINE),
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_AFFILIATION_MINE)
        )
    );

    op:addCondition(
        opvp.TargetFlagsCombatLogCondition(
            opvp.CombatLogLogicalOp.DESTINATION,
            opvp.CombatLogLogicalOp.BIT_AND,
            opvp.CombatLogLogicalOp.CMP_EQUAL,
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE),
            bit.bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_REACTION_HOSTILE)
        )
    );

    self._event_filter = opvp.CallbackCombatLogFilter(
        function(filter, info)
            self:_onKillingBlow(info);
        end,
        op
    );
end

function opvp.private.EmoteKillingBlowSoundEffect:randomEmote(isTargeting, level)
    local emotes;

    if isTargeting == true then
        emotes = self._emotes[2][level];
    else
        emotes = self._emotes[1][level];
    end

    local emote = emotes:item(math.random(1, emotes:size()));

    if emote == "FORTHE" then
        if opvp.player.faction() == opvp.ALLIANCE then
            emote = "FORTHEALLIANCE";
        else
            emote = "FORTHEHORDE";
        end
    end

    return emote;
end

function opvp.private.EmoteKillingBlowSoundEffect:canActivate()
    return opvp.player.inSanctuary() == false;
end

function opvp.private.EmoteKillingBlowSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.EmoteKillingBlowSoundEffect:_onFeatureActivated()
    self._event_filter:connect();

    opvp.OptionFeature._onFeatureActivated(self)
end

function opvp.private.EmoteKillingBlowSoundEffect:_onFeatureDeactivated()
    self._event_filter:disconnect();

    opvp.OptionFeature._onFeatureDeactivated(self)
end

function opvp.private.EmoteKillingBlowSoundEffect:_onFeatureDisabled()
    local player = opvp.player.instance();

    player.inSanctuaryChanged:disconnect(self, self._onSanctuaryChanged);

    opvp.OptionFeature._onFeatureDisabled(self)
end

function opvp.private.EmoteKillingBlowSoundEffect:_onFeatureEnabled()
    local player = opvp.player.instance();

    player.inSanctuaryChanged:connect(self, self._onSanctuaryChanged);

    opvp.OptionFeature._onFeatureEnabled(self)
end

function opvp.private.EmoteKillingBlowSoundEffect:_onKillingBlow(info)
    local targeting = opvp.unit.guid("target") == info.destGUID;

    DoEmote(
        self:randomEmote(
            targeting,
            opvp.options.audio.soundeffect.general.killingBlowEmotesLevel:index()
        ),
        targeting and "target" or "none"
    );
end

function opvp.private.EmoteKillingBlowSoundEffect:_onSanctuaryChanged(state)
    if state == true then
        self:_setActive(false);
    elseif self:canActivate() == true then
        self:_setActive(true);
    end
end

local opvp_killing_blow_emote_sound_effect;

local function opvp_killing_blow_emote_sound_effect_ctor()
    opvp_killing_blow_nice_mean_emotes:merge(
        opvp_killing_blow_nice_emotes
    );

    opvp_killing_blow_nice_mean_emotes:merge(
        opvp_killing_blow_mean_emotes
    );

    opvp_killing_blow_target_nice_mean_emotes:merge(
        opvp_killing_blow_target_nice_emotes
    );

    opvp_killing_blow_target_nice_mean_emotes:merge(
        opvp_killing_blow_target_mean_emotes
    );

    opvp_killing_blow_nice_mean_emotes:shuffle();
    opvp_killing_blow_target_nice_mean_emotes:shuffle();

    opvp_killing_blow_emote_sound_effect = opvp.private.EmoteKillingBlowSoundEffect(
        opvp.options.audio.soundeffect.general.killingBlowEmotes
    );
end

opvp.OnAddonLoad:register(opvp_killing_blow_emote_sound_effect_ctor);
