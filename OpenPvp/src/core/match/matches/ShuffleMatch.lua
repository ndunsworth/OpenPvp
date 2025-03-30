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

opvp.ShuffleMatch = opvp.CreateClass(opvp.GenericMatch);

function opvp.ShuffleMatch:init(queue, description)
    opvp.GenericMatch.init(self, queue, description);

    self._enemy_provider = opvp.ArenaPartyMemberProvider(nil, true);

    self._enemy_provider:_setTeamSize(description:teamSize());

    local cache = opvp.PartyMemberFactoryCache(6);

    cache:setMemberClearFlags(
        bit.bor(
            opvp.PartyMember.ID_FLAG,
            bit.band(
                opvp.PartyMember.STATE_FLAGS,
                bit.bnot(opvp.PartyMember.PLAYER_FLAG)
            )
        )
    );

    self._friendly_provider:_memberFactory():setCache(cache);
    self._enemy_provider:_memberFactory():setCache(cache);

    local map = description:map();

    self._score_emit      = false;
    self._round           = 0;
    self._rounds_mask     = 0;
    self._rounds_won      = 0;
    self._rounds_lost     = 0;
    self._gold_widget     = map:widget("GoldTeamPlayersRemaining");
    self._purp_widget     = map:widget("PurpleTeamPlayersRemaining");

    if self._gold_widget == nil then
        opvp.printDebug(
            "opvp.ShuffleMatch:init, failed to find GoldTeamPlayersRemaining widget on %s",
            map:name()
        );
    end

    if self._purp_widget == nil then
        opvp.printDebug(
            "opvp.ShuffleMatch:init, failed to find PurpleTeamPlayersRemaining widget on %s",
            map:name()
        );
    end
end

function opvp.ShuffleMatch:isRoundKnown(round)
    return bit.band(self._rounds_mask, self:roundFlag(round)) ~= 0;
end

function opvp.ShuffleMatch:round()
    return min(6, self._round + 1);
end

function opvp.ShuffleMatch:roundFlag(round)
    if (
        opvp.is_number(round) == true and
        round > 0 and
        round <= 6
    ) then
        return bit.lshift(1, round - 1)
    else
        return 0;
    end
end

function opvp.ShuffleMatch:roundMask()
    return self._rounds_mask;
end

function opvp.ShuffleMatch:roundsLost()
    return self._rounds_lost;
end

function opvp.ShuffleMatch:roundsWon()
    return self._rounds_won;
end

function opvp.ShuffleMatch:statusNext()
    if (
        self._status == opvp.MatchStatus.ROUND_COMPLETE and
        self._round < 6 and
        self:isRoundKnown(6) == false
    ) then
        return opvp.MatchStatus.ROUND_WARMUP;
    else
        return opvp.GenericMatch.statusNext(self);
    end
end

function opvp.ShuffleMatch:statusPrev()
    if self._status == opvp.MatchStatus.ROUND_WARMUP then
        if self._round <= 1 then
            return opvp.MatchStatus.JOINED;
        else
            return opvp.MatchStatus.ROUND_COMPLETE;
        end
    else
        return opvp.GenericMatch.statusPrev(self);
    end
end

function opvp.ShuffleMatch:_currentScoreBoardRound()
    local widget_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(
        3521
    );

    if widget_info == nil then
        return 0;
    end

    local i1, i2, r1, r2 = string.find(widget_info.text, "(%d+)/(%d)");

    if r1 ~= nil then
        return tonumber(r1);
    else
        return 0;
    end
end

function opvp.ShuffleMatch:_isAlreadyComplete(status)
    if status == opvp.MatchStatus.COMPLETE then
        return true;
    end

    if status == opvp.MatchStatus.ROUND_COMPLETE then
        return self:_currentScoreBoardRound() == 6;
    else
        return false;
    end
end

function opvp.ShuffleMatch:_isAlreadyInProgress(status)
    return (
        opvp.Match._isAlreadyInProgress(self, status) == true or
        self:_currentScoreBoardRound() > 1
    );
end

function opvp.ShuffleMatch:_onMatchComplete()
    if self:surrendered() == false then
        local draw_round = math.floor(((self._round + 1) * 0.5) + 0.5);

        if self._rounds_won == draw_round then
            self:_setOutcome(opvp.MatchWinner.DRAW, nil);
        elseif self._rounds_won > draw_round then
            self:_setOutcome(opvp.MatchWinner.WON, nil);
        else
            self:_setOutcome(opvp.MatchWinner.LOST, nil);
        end
    end

    opvp.GenericMatch._onMatchComplete(self);

end

function opvp.ShuffleMatch:_onMatchEntered()
    if self:isTest() == true then
        self._round = 5;
        self._rounds_mask = bit.bor(
            self:roundFlag(1),
            self:roundFlag(2),
            self:roundFlag(3),
            self:roundFlag(4),
            self:roundFlag(5)
        );
        self._rounds_won  = 3;
        self._rounds_lost = 2;
    else
        self._round       = 0;
        self._rounds_mask = 0;
        self._rounds_won  = 0;
        self._rounds_lost = 0;
    end

    self._score_emit = true;

    opvp.GenericMatch._onMatchEntered(self);
end

function opvp.ShuffleMatch:_onMatchJoinedInProgress(status)
    local round = self:_currentScoreBoardRound();

    self._round = round - 1;

    if round > 1 then
        if status ~= opvp.MatchStatus.COMPLETE then
            for n=1, round do
                self._rounds_mask = bit.bor(
                    self._rounds_mask,
                    self:roundFlag(n)
                );
            end
        end
    end

    opvp.GenericMatch._onMatchJoinedInProgress(self, status);
end

function opvp.ShuffleMatch:_onMatchRoundComplete()
    opvp.GenericMatch._onMatchRoundComplete(self);

    if self:surrendered() == false and self._round < 5 then
        --~ Sadly blizz starts swaping people over to the other team before it
        --~ moves you.  Otherwise we would link the shutdown of the players
        --~ team with the opponents
        self._friendly_team:shutdown();

        self._round = self._round + 1;
    end
end

function opvp.ShuffleMatch:_onMatchRoundWarmup()
    self._rounds_mask = bit.bor(
        self._rounds_mask,
        bit.lshift(1, self._round)
    );

    opvp.GenericMatch._onMatchRoundWarmup(self);
end

function opvp.ShuffleMatch:_onUpdateScore()
    if (
        self._score_emit == false or
        self:isComplete() == false or
        self:isTest() == true
    ) then
        return;
    end

    local members = opvp.List();

    members:merge(self:teammates());
    members:merge(self:opponents());

    members = opvp.party.utils.sortMembersByRole(members);

    local member;
    local score_info;
    local cls;
    local spec;
    local wins;
    local do_msg = opvp.options.announcements.match.scorePlayerRatings:value();

    for n=1, #members do
        member = members[n];

        score_info = C_PvP.GetScoreInfoByPlayerGuid(member:guid());

        if score_info ~= nil then
            self._score_emit = false;

            cls = member:classInfo();
            spec = member:specInfo();

            if score_info.stats ~= nil and #score_info.stats > 0 then
                wins = score_info.stats[1].pvpStatValue;
            else
                wins = 0;
            end

            opvp.printMessageOrDebug(
                do_msg,
                opvp.strs.MATCH_SCORE_SHUFFLE,
                member:nameOrId(),
                cls:color():GenerateHexColor(),
                spec:name(),
                cls:name(),
                wins,
                score_info.prematchMMR,
                score_info.postmatchMMR,
                opvp.utils.colorNumberPosNeg(
                    score_info.postmatchMMR - score_info.prematchMMR,
                    0.25,
                    1,
                    0.25,
                    1,
                    0.25,
                    0.25
                ),
                score_info.rating,
                score_info.rating + score_info.ratingChange,
                opvp.utils.colorNumberPosNeg(
                    score_info.ratingChange,
                    0.25,
                    1,
                    0.25,
                    1,
                    0.25,
                    0.25
                )
            );
        end
    end
end

function opvp.ShuffleMatch:_updateOutcome()
    if (
        self:isTest() == true or
        self._gold_widget == nil or
        self._purp_widget == nil
    ) then
        opvp.GenericMatch._updateOutcome(self);

        if self:isTest() == true and self:isComplete() == false then
            if self:isWinner() == true then
                self._rounds_won = self._rounds_won + 1;
            else
                self._rounds_lost = self._rounds_lost + 1;
            end
        end

        return;
    end

    local gold_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(self._gold_widget:widgetId());
    local purp_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(self._purp_widget:widgetId());

    if gold_info == nil or purp_info == nil then
        self:_setOutcome(opvp.MatchWinner.NONE, nil);

        return;
    end

    local _, _, gold_text = string.find(gold_info.text, opvp.strs.GOLD_TEAM_PLAYERS_REMAINING_RE);
    local _, _, purp_text = string.find(purp_info.text, opvp.strs.PURPLE_TEAM_PLAYERS_REMAINING_RE);

    if gold_text == nil or purp_text == nil then
        self:_setOutcome(opvp.MatchWinner.NONE, nil);

        return;
    end

    local gold_players = tonumber(gold_text);
    local purp_players = tonumber(purp_text);

    if gold_players == purp_players then
        self:_setOutcome(opvp.MatchWinner.DRAW, nil);
    elseif opvp.match.faction() == opvp.ALLIANCE then
        if gold_players > purp_players then
            self._rounds_won = self._rounds_won + 1;

            self:_setOutcome(opvp.MatchWinner.WON, self:opponentTeam());
        else
            self._rounds_lost = self._rounds_lost + 1;

            self:_setOutcome(opvp.MatchWinner.LOST, self:playerTeam());
        end
    else
        if purp_players > gold_players then
            self._rounds_won = self._rounds_won + 1;

            self:_setOutcome(opvp.MatchWinner.WON, self:opponentTeam());
        else
            self._rounds_lost = self._rounds_lost + 1;

            self:_setOutcome(opvp.MatchWinner.LOST, self:playerTeam());
        end
    end
end
