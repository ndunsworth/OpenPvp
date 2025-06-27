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

    if description:isTest() == false then
        self._enemy_provider = opvp.ArenaPartyMemberProvider(nil, true);

        self._enemy_provider:_setTeamSize(description:teamSize());

        local cache = opvp.PartyMemberFactoryCache(6);

        cache:setMemberClearFlags(
            bit.bor(
                opvp.PartyMember.ID_FLAG,
                bit.band(
                    opvp.PartyMember.STATE_FLAGS,
                    bit.bnot(
                        bit.bor(
                            opvp.PartyMember.PLAYER_FLAG,
                            opvp.PartyMember.RATING_CURRENT_FLAG,
                            opvp.PartyMember.RATING_GAIN_FLAG,
                            opvp.PartyMember.SCORE_FLAG
                        )
                    )
                )
            )
        );

        self._friendly_provider:_memberFactory():setCache(cache);
        self._enemy_provider:_memberFactory():setCache(cache);
    end

    local map = description:map();

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

function opvp.ShuffleMatch:roundsKnown()
    return opvp.math.popcount(self._rounds_mask);
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

    opvp.GenericMatch._onMatchEntered(self);
end

function opvp.ShuffleMatch:_onMatchJoinedInProgress(status)
    local round = self:_currentScoreBoardRound();

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

    self._round = round - 1;

    opvp.GenericMatch._onMatchJoinedInProgress(self, status);
end

function opvp.ShuffleMatch:_onMatchRoundActive()
    opvp.GenericMatch._onMatchRoundActive(self);
end

function opvp.ShuffleMatch:_onMatchRoundComplete()
    opvp.GenericMatch._onMatchRoundComplete(self);

    self:_updateRoundOutcome();

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

function opvp.ShuffleMatch:_onOutcomeReady(outcomeType)
    opvp.GenericMatch._onOutcomeReady(self, outcomeType);

    if (
        outcomeType == opvp.MatchOutcomeType.ROUND or
        (
            self:isTest() == true and
            self:isSimulation() == false
        )
    ) then
        return;
    end

    local members = opvp.List();

    members:merge(self:teammates());
    members:merge(self:opponents());

    members = opvp.party.utils.sortMembersByStat(
        members,
        opvp.PvpStatId.ROUNDS_WON,
        opvp.SortOrder.DESCENDING
    );

    local member;
    local score_info;
    local cls;
    local spec;
    local wins;
    local stat;
    local do_msg = opvp.options.announcements.match.scorePlayerRatings:value();

    for n=1, #members do
        member = members[n];
        cls = member:classInfo();
        spec = member:specInfo();

        stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

        if stat ~= nil then
            wins = stat:value();
        else
            wins = 0;
        end

        opvp.printMessageOrDebug(
            do_msg,
            opvp.strs.MATCH_SCORE_SHUFFLE,
            spec:role():iconMarkup(),
            member:nameOrId(true),
            wins,
            member:cr(),
            member:cr() + member:crGain(),
            opvp.utils.colorNumberPosNeg(
                member:crGain(),
                0.25,
                1,
                0.25,
                1,
                0.25,
                0.25
            ),
            member:mmr(),
            member:mmr() + member:mmrGain(),
            opvp.utils.colorNumberPosNeg(
                member:mmrGain(),
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

function opvp.ShuffleMatch:_updateMatchOutcome()
    local draw_round = math.floor((self:round() * 0.5) + 0.5);

    if self._rounds_won == draw_round then
        self:_setOutcome(opvp.MatchWinner.DRAW, nil, opvp.MatchOutcomeType.MATCH);
    elseif self._rounds_won > draw_round then
        self:_setOutcome(opvp.MatchWinner.WON, nil, opvp.MatchOutcomeType.MATCH);
    else
        self:_setOutcome(opvp.MatchWinner.LOST, nil, opvp.MatchOutcomeType.MATCH);
    end
end

function opvp.ShuffleMatch:_updateOutcome()
    if self:isRoundComplete() == true then
        self:_updateRoundOutcome();
    elseif self:isComplete() == true then
        self:_updateMatchOutcome();
    end
end

function opvp.ShuffleMatch:_updateRoundOutcome()
    if self:isTest() == true then
        local winning_status, winning_team = opvp.match.manager():tester():outcome();

        if winning_status == opvp.MatchWinner.WON then
            self._rounds_won = self._rounds_won + 1;
        elseif winning_status == opvp.MatchWinner.LOST then
            self._rounds_lost = self._rounds_lost + 1;
        end

        self:_setOutcome(winning_status, winning_team, opvp.MatchOutcomeType.ROUND);

        return;
    end

    local gold_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(self._gold_widget:widgetId());
    local purp_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(self._purp_widget:widgetId());

    if gold_info == nil or purp_info == nil then
        self:_setOutcome(opvp.MatchWinner.NONE, nil, opvp.MatchOutcomeType.ROUND);

        opvp.printDebug(
            "opvp.ShuffleMatch:_updateRoundOutcome(), map=%d, gold_info=%s, purp_info=%s",
            self:map():instanceId(),
            tostring(gold_info),
            tostring(purp_info)
        );

        return;
    end

    local _, _, gold_text = string.find(gold_info.text, opvp.strs.GOLD_TEAM_PLAYERS_REMAINING_RE);
    local _, _, purp_text = string.find(purp_info.text, opvp.strs.PURPLE_TEAM_PLAYERS_REMAINING_RE);

    if gold_text == nil or purp_text == nil then
        self:_setOutcome(opvp.MatchWinner.NONE, nil, opvp.MatchOutcomeType.ROUND);

        opvp.printDebug(
            "opvp.ShuffleMatch:_updateRoundOutcome(), map=%d, gold_info.text=%s, purp_info.text=%s",
            self:map():instanceId(),
            tostring(gold_info.text),
            tostring(purp_info.text)
        );

        return;
    end

    local gold_players = tonumber(gold_text);
    local purp_players = tonumber(purp_text);

    if gold_players < 3 and purp_players < 3 then
        self:_setOutcome(opvp.MatchWinner.DRAW, nil, opvp.MatchOutcomeType.ROUND);
    elseif opvp.match.faction() == opvp.ALLIANCE then
        if gold_players > purp_players then
            self._rounds_won = self._rounds_won + 1;

            self:_setOutcome(opvp.MatchWinner.WON, self:opponentTeam(), opvp.MatchOutcomeType.ROUND);
        else
            self._rounds_lost = self._rounds_lost + 1;

            self:_setOutcome(opvp.MatchWinner.LOST, self:playerTeam(), opvp.MatchOutcomeType.ROUND);
        end
    else
        if purp_players > gold_players then
            self._rounds_won = self._rounds_won + 1;

            self:_setOutcome(opvp.MatchWinner.WON, self:opponentTeam(), opvp.MatchOutcomeType.ROUND);
        else
            self._rounds_lost = self._rounds_lost + 1;

            self:_setOutcome(opvp.MatchWinner.LOST, self:playerTeam(), opvp.MatchOutcomeType.ROUND);
        end
    end
end
