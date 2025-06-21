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

local opvp_match_status_signal_lookup;

opvp.MatchOutcomeType = {
    NONE  = 0,
    MATCH = 1,
    ROUND = 2
};

opvp.MatchStatus = {
    INACTIVE       = 1,
    ENTERED        = 2,
    JOINED         = 3,
    ROUND_WARMUP   = 4,
    ROUND_ACTIVE   = 5,
    ROUND_COMPLETE = 6,
    COMPLETE       = 7,
    EXIT           = 8
};

opvp.MatchWinner = {
    NONE = 0,
    DRAW = 1,
    LOST = 2,
    WON  = 3
};

local opvp_match_status_next_of_lookup = {
    [opvp.MatchStatus.INACTIVE]       = opvp.MatchStatus.ENTERED;
    [opvp.MatchStatus.ENTERED]        = opvp.MatchStatus.JOINED;
    [opvp.MatchStatus.JOINED]         = opvp.MatchStatus.ROUND_WARMUP;
    [opvp.MatchStatus.ROUND_WARMUP]   = opvp.MatchStatus.ROUND_ACTIVE;
    [opvp.MatchStatus.ROUND_ACTIVE]   = opvp.MatchStatus.ROUND_COMPLETE;
    [opvp.MatchStatus.ROUND_COMPLETE] = opvp.MatchStatus.COMPLETE;
    [opvp.MatchStatus.COMPLETE]       = opvp.MatchStatus.EXIT;
    [opvp.MatchStatus.EXIT]           = opvp.MatchStatus.INACTIVE;
};

local opvp_match_status_prev_of_lookup = {
    [opvp.MatchStatus.INACTIVE]       = opvp.MatchStatus.INACTIVE;
    [opvp.MatchStatus.ENTERED]        = opvp.MatchStatus.INACTIVE;
    [opvp.MatchStatus.JOINED]         = opvp.MatchStatus.ENTERED;
    [opvp.MatchStatus.ROUND_WARMUP]   = opvp.MatchStatus.JOINED;
    [opvp.MatchStatus.ROUND_ACTIVE]   = opvp.MatchStatus.ROUND_WARMUP;
    [opvp.MatchStatus.ROUND_COMPLETE] = opvp.MatchStatus.ROUND_ACTIVE;
    [opvp.MatchStatus.COMPLETE]       = opvp.MatchStatus.ROUND_COMPLETE;
    [opvp.MatchStatus.EXIT]           = opvp.MatchStatus.COMPLETE;
};

local opvp_match_status_name_lookup = {
    [opvp.MatchStatus.INACTIVE]       = opvp.strs.MATCH_INACTIVE_NAME,
    [opvp.MatchStatus.ENTERED]        = opvp.strs.MATCH_ENTERED_NAME,
    [opvp.MatchStatus.JOINED]         = opvp.strs.MATCH_JOINED_NAME;
    [opvp.MatchStatus.ROUND_WARMUP]   = opvp.strs.MATCH_ROUND_WARMUP_NAME,
    [opvp.MatchStatus.ROUND_ACTIVE]   = opvp.strs.MATCH_ROUND_ACTIVE_NAME,
    [opvp.MatchStatus.ROUND_COMPLETE] = opvp.strs.MATCH_ROUND_COMPLETE_NAME,
    [opvp.MatchStatus.COMPLETE]       = opvp.strs.MATCH_COMPLETE_NAME,
    [opvp.MatchStatus.EXIT]           = opvp.strs.MATCH_EXIT_NAME
};

local opvp_match_compelete_str_lookup = {
    {
        [opvp.MatchWinner.DRAW] = opvp.strs.MATCH_COMPLETE_DRAW_WITH_ROUNDS,
        [opvp.MatchWinner.LOST] = opvp.strs.MATCH_COMPLETE_LOST_WITH_ROUNDS,
        [opvp.MatchWinner.WON]  = opvp.strs.MATCH_COMPLETE_WON_WITH_ROUNDS,
    },
    {
        [opvp.MatchWinner.DRAW] = opvp.strs.MATCH_COMPLETE_DRAW,
        [opvp.MatchWinner.LOST] = opvp.strs.MATCH_COMPLETE_LOST,
        [opvp.MatchWinner.WON]  = opvp.strs.MATCH_COMPLETE_WON,
    }
};

local opvp_warmup_countdown_msg_lookup = {
    [120] = opvp.strs.MATCH_STARTS_COUNTDOWN_120,
    [60]  = opvp.strs.MATCH_STARTS_COUNTDOWN_60,
    [30]  = opvp.strs.MATCH_STARTS_COUNTDOWN_30,
    [15]  = opvp.strs.MATCH_STARTS_COUNTDOWN_15
};

local opvp_round_warmup_countdown_msg_lookup = {
    [120] = opvp.strs.MATCH_ROUND_STARTS_COUNTDOWN_120,
    [60]  = opvp.strs.MATCH_ROUND_STARTS_COUNTDOWN_60,
    [30]  = opvp.strs.MATCH_ROUND_STARTS_COUNTDOWN_30,
    [15]  = opvp.strs.MATCH_ROUND_STARTS_COUNTDOWN_15
};

opvp.Match = opvp.CreateClass();

function opvp.Match:nameForStatus(status)
    local name = opvp_match_status_name_lookup[status];

    if name ~= nil then
        return name;
    else
        return opvp.strs.MATCH_INACTIVE_NAME;
    end
end

function opvp.Match:nextStatusOf(status)
    local status = opvp_match_status_next_of_lookup[status];

    if status ~= nil then
        return status;
    else
        return opvp.MatchStatus.INACTIVE;
    end
end

function opvp.Match:prevStatusOf(status)
    local status = opvp_match_status_prev_of_lookup[status];

    if status ~= nil then
        return status;
    else
        return opvp.MatchStatus.INACTIVE;
    end
end

function opvp.Match:statusFromActiveMatchState()
    return opvp.match.utils.state();
end

function opvp.Match:init(queue, description, testType)
    self._queue             = queue;
    self._desc              = description;
    self._status            = opvp.MatchStatus.INACTIVE;
    self._enter_in_prog     = false;
    self._surrendered       = false;
    self._testing           = testType;
    self._dampening         = 0;
    self._countdown         = false;
    self._countdown_time    = 0;
    self._countdown_timer   = opvp.Timer(1);
    self._round_results     = false;
    self._aura_cfg          = opvp.MatchAuraServerConfig(self);

    self._outcome           = opvp.MatchWinner.NONE;
    self._outcome_valid     = false;
    self._outcome_final     = false;
    self._outcome_team      = nil;

    self._countdown_timer.timeout:connect(self, self._countdownUpdate);
end

function opvp.Match:bracket()
    if self._queue:isRated() == true then
        return self._queue:bracket();
    else
        return nil;
    end
end

function opvp.Match:dampening()
    return self._dampening;
end

function opvp.Match:description()
    return self._desc;
end

function opvp.Match:findPlayerByGuid(guid)
    local player = self:playerTeam():findPlayerByGuid(guid);

    if player ~= nil then
        return player;
    end

    return self:findOpponentByGuid(guid);
end

function opvp.Match:findOpponentByGuid(guid)
    local players = self:opponents();

    for n=1, #players do
        if players[n]:guid() == guid then
            return players[n];
        end
    end

    return nil;
end

function opvp.Match:findTeamateByGuid(guid)
    return self:playerTeam():findPlayerByGuid(guid);
end

function opvp.Match:hasDampening()
    return self._desc:hasDampening();
end

function opvp.Match:hasWinner()
    return self._outcome ~= opvp.MatchWinner.NONE;
end

function opvp.Match:identifierName()
    if self:isArena() then
        return opvp.strs.ARENA;
    elseif self:isBattlegroundEpic() == true then
        return opvp.strs.EPIC_BATTLEGROUND;
    else
        return opvp.strs.BATTLEGROUND;
    end
end

function opvp.Match:instanceExpiration()
    if self._status == opvp.MatchStatus.COMPLETE then
        return GetBattlefieldInstanceExpiration() / 1000;
    else
        return -1;
    end
end

function opvp.Match:isActive()
    return self._status == opvp.MatchStatus.ROUND_ACTIVE;
end

function opvp.Match:isArena()
    return self._desc:isArena();
end

function opvp.Match:isBattleground()
    return self._desc:isBattleground();
end

function opvp.Match:isBattlegroundEpic()
    return self._desc:isBattlegroundEpic();
end

function opvp.Match:isBrawl()
    return self._desc:isBrawl();
end

function opvp.Match:isBlitz()
    return self._desc:isBlitz();
end

function opvp.Match:isComplete()
    return (
        self._status == opvp.MatchStatus.COMPLETE or
        self._status == opvp.MatchStatus.EXIT
    );
end

function opvp.Match:isCountingDown()
    return self._countdown;
end

function opvp.Match:isDraw()
    return self._outcome == opvp.MatchWinner.DRAW;
end

function opvp.Match:isEvent()
    return self._desc:isEvent();
end

function opvp.Match:isLastRound()
    return self:round() == self:rounds();
end

function opvp.Match:isOutcomeFinal()
    return self._outcome_final;
end

function opvp.Match:isOutcomeValid()
    return self._outcome_valid;
end

function opvp.Match:isRoundComplete()
    return self._status == opvp.MatchStatus.ROUND_COMPLETE;
end

function opvp.Match:isRoundWarmup()
    return self._status == opvp.MatchStatus.ROUND_WARMUP;
end

function opvp.Match:isRated()
    return self._desc:isRated();
end

function opvp.Match:isRBG()
    return self._desc:isRBG();
end

function opvp.Match:isRoundBased()
    return self._desc:isRoundBased();
end

function opvp.Match:isShuffle()
    return self._desc:isShuffle();
end

function opvp.Match:isSimulation()
    return self._testing == opvp.MatchTestType.SIMULATION;
end

function opvp.Match:isSkirmish()
    return self._desc:isSkirmish();
end

function opvp.Match:isTest()
    return self._testing ~= opvp.MatchTestType.NONE;
end

function opvp.Match:isWarmup()
    return self._status == opvp.MatchStatus.ROUND_WARMUP;
end

function opvp.Match:isWinner()
    return self._outcome == opvp.MatchWinner.WON;
end

function opvp.Match:joinedInProgress()
    return self._enter_in_prog;
end

function opvp.Match:map()
    return self._desc:map();
end

function opvp.Match:mapId()
    return self._desc:map():id();
end

function opvp.Match:mapName()
    return self._desc:map():name();
end

function opvp.Match:matchTeamSize()
    return self._desc:teamSize();
end

function opvp.Match:name()
    return self._queue:name();
end

function opvp.Match:opponents()
    return {};
end

function opvp.Match:opponentsSize()
    return 0;
end

function opvp.Match:outcome()
    return self._outcome;
end

function opvp.Match:playerTeam()
    return nil;
end

function opvp.Match:poiManager()
    return nil;
end

function opvp.Match:pvpType()
    return self._queue:pvpType();
end

function opvp.Match:queue()
    return self._queue;
end

function opvp.Match:round()
    return 1;
end

function opvp.Match:roundElapsedTime()
    return 0;
end

function opvp.Match:roundStartTime()
    return 0;
end

function opvp.Match:rounds()
    return self._desc:rounds();
end

function opvp.Match:roundsLost()
    if self:isComplete() == true and self:isWinner() == false then
        return 1;
    else
        return 0;
    end
end

function opvp.Match:roundsWon()
    if self:isComplete() == true and self:isWinner() == true then
        return 1;
    else
        return 0;
    end
end

function opvp.Match:roundsWon()
    return 0;
end

function opvp.Match:status()
    return self._status;
end

function opvp.Match:startTime()
    return 0;
end

function opvp.Match:statusName()
    return opvp.Match:nameForStatus(self._status);
end

function opvp.Match:statusNext()
    if (
        self._status == opvp.MatchStatus.ROUND_ACTIVE and
        self:isRoundBased() == false
    ) then
        return opvp.MatchStatus.COMPLETE;
    else
        return opvp.Match:nextStatusOf(self._status);
    end
end

function opvp.Match:statusPrev()
    if (
        self._status == opvp.MatchStatus.COMPLETE and
        self:isRoundBased() == false
    ) then
        return opvp.MatchStatus.ROUND_ACTIVE;
    else
        return opvp.Match:prevStatusOf(self._status);
    end
end

function opvp.Match:surrendered()
    return self._surrendered;
end

function opvp.Match:team(index)
    return self:teams()[index];
end

function opvp.Match:teams()
    return {};
end

function opvp.Match:teamsSize()
    return 0;
end

function opvp.Match:teammates()
    return {};
end

function opvp.Match:teammatesSize()
    return 0;
end

function opvp.Match:testType()
    return self._testing;
end

function opvp.Match:timeElapsed()
    if self._status ~= opvp.MatchStatus.INACTIVE then
        if self:isTest() == false then
            local runtime = GetBattlefieldInstanceRunTime();

            if runtime ~= nil then
                return runtime / 1000;
            else
                return 0;
            end
        else
            return opvp.match.manager():tester():timeElapsed();
        end
    else
        return 0;
    end
end

function opvp.Match:winner()
    return self._outcome_team;
end

function opvp.Match:_close()
    if self:isTest() == false then
        opvp.event.START_TIMER:disconnect(self, self._onStartTimer);
    end

    self._countdown_timer:stop();

    self._queue           = nil;
    self._desc            = nil;
    self._outcome_team    = nil;
end

function opvp.Match:_countdownCancel()
    if self._countdown == false then
        return;
    end

    self._countdown_timer:stop();

    local t = self._countdown_time;

    self._countdown      = false;
    self._countdown_time = 0;

    self:_onCountdownUpdate(-1, t);
end

function opvp.Match:_countdownStart(currentTime, totalTime)
    if self._countdown == true then
        self:_countdownCancel();
    end

    self._countdown      = true;
    self._countdown_time = totalTime;

    self._countdown_timer:setTriggerLimit(currentTime);

    self._countdown_timer:start();

    self:_onCountdownUpdate(currentTime, self._countdown_time);
end

function opvp.Match:_countdownUpdate()
    local triggers = self._countdown_timer:remainingTriggers();
    local t        = self._countdown_time;

    if triggers == 0 then
        self._countdown      = false;
        self._countdown_time = 0;
    end

    self:_onCountdownUpdate(triggers, t);
end

function opvp.Match:_currentRound()
    if self:isRoundBased() == false then
        return;
    end

    local round = current_shuffle_round();

    if round > 0 then
        self._round = round;
    end
end

function opvp.Match:_findPlayer(unitToken, guid, name, create)
    return nil, false;
end

function opvp.Match:_isAlreadyComplete(status)
    return (
        status == opvp.MatchStatus.COMPLETE or
        status == opvp.MatchStatus.ROUND_COMPLETE
    );
end

function opvp.Match:_isAlreadyInProgress(status)
    return (
        status ~= opvp.MatchStatus.INACTIVE and
        status ~= opvp.MatchStatus.ROUND_WARMUP
    );
end

function opvp.Match:_onCountdownUpdate(timeRemaining, totalTime)
    if self:isRoundBased() == true then
        local msg = opvp_round_warmup_countdown_msg_lookup[timeRemaining];

        if msg ~= nil then
            opvp.printMessageOrDebug(
                opvp.options.announcements.match.roundWarmupCountdown:value(),
                msg,
                self:round(),
                opvp.time.formatSeconds(timeRemaining)
            );
        end
    else
        local msg = opvp_warmup_countdown_msg_lookup[timeRemaining];

        if msg ~= nil then
            opvp.printMessageOrDebug(
                opvp.options.announcements.match.roundWarmupCountdown:value(),
                msg,
                self:identifierName(),
                opvp.time.formatSeconds(timeRemaining)
            );
        end
    end

    opvp.match.countdown:emit(timeRemaining, totalTime);
end

function opvp.Match:_onMatchComplete()
    self:_setStatus(opvp.MatchStatus.COMPLETE);

    local expire = self:instanceExpiration();

    if expire > 0 then
        opvp.printMessageOrDebug(
            do_msg,
            opvp.strs.MATCH_EXPIRATION,
            opvp.time.formatSeconds(expire)
        );
    end
end

function opvp.Match:_onMatchEntered()
    opvp.printMessageOrDebug(
        opvp.options.announcements.match.enter:value(),
        self:queue():isMapRandom() == true and opvp.strs.MATCH_ENTERED_WITH_MAP or opvp.strs.MATCH_ENTERED,
        self:name(),
        self:mapName()
    );

    if self:isTest() == false then
        opvp.event.START_TIMER:connect(self, self._onStartTimer);
    end

    self._aura_cfg:initialize();

    self:_setOutcome(opvp.MatchWinner.NONE, nil, opvp.MatchOutcomeType.NONE);

    self:_setStatus(opvp.MatchStatus.ENTERED);
end

function opvp.Match:_onMatchExit()
    self:_setStatus(opvp.MatchStatus.EXIT);

    self._aura_cfg:shutdown();
end

function opvp.Match:_onMatchJoined()
    if self._enter_in_prog == false then
        opvp.printDebug(opvp.strs.MATCH_JOINED);
    else
        opvp.printDebug(opvp.strs.MATCH_JOINED_IN_PROGRESS);
    end

    self:_setStatus(opvp.MatchStatus.JOINED);
end

function opvp.Match:_onMatchJoinedInProgress(status)
    self:_onMatchJoined();

    if status == opvp.MatchStatus.ROUND_WARMUP then
        self:_onMatchRoundWarmup();
    elseif status == opvp.MatchStatus.ROUND_ACTIVE then
        self:_onMatchRoundWarmup();
        self:_onMatchRoundActive();
    elseif status == opvp.MatchStatus.ROUND_COMPLETE then
        self:_onMatchRoundWarmup();
        self:_onMatchRoundComplete();
    elseif status == opvp.MatchStatus.COMPLETE then
        self:_onMatchComplete();
    end
end

function opvp.Match:_onMatchRoundActive()
    if self:isRoundBased() == true then
        opvp.printMessageOrDebug(
            opvp.options.announcements.match.roundActive:value(),
            opvp.strs.MATCH_ROUND_ACTIVE_WITH_ROUND,
            self:round()
        );
    elseif self:isArena() == true then
        opvp.printMessageOrDebug(
            opvp.options.announcements.match.roundActive:value(),
            opvp.strs.MATCH_ROUND_ACTIVE_ARENA
        );
    else
        opvp.printMessageOrDebug(
            opvp.options.announcements.match.roundActive:value(),
            opvp.strs.MATCH_ROUND_ACTIVE_BATTLEGROUND,
            self:map():name()
        );
    end

    self:_setStatus(opvp.MatchStatus.ROUND_ACTIVE);
end

function opvp.Match:_onMatchRoundComplete()
    self._countdown_timer:stop();

    if self._cc_tracker ~= nil then
        self._cc_tracker:disconnect();
    end

    self:_setStatus(opvp.MatchStatus.ROUND_COMPLETE);
end

function opvp.Match:_onMatchRoundWarmup()
    opvp.printMessageOrDebug(
        opvp.options.announcements.match.roundWarmup:value(),
        opvp.strs.MATCH_ROUND_WARMUP
    );

    if self._cc_tracker ~= nil then
        if self:isArena() == true then
            self._cc_tracker:connect(self, bit.bor(opvp.Affiliation.FRIENDLY, opvp.Affiliation.HOSTILE))
        else
            self._cc_tracker:connect(self, opvp.Affiliation.FRIENDLY)
        end
    end

    self._round_results = true;

    self:_setOutcome(opvp.MatchWinner.NONE, nil, opvp.MatchOutcomeType.NONE);

    self:_setDampening(0);

    self:_setStatus(opvp.MatchStatus.ROUND_WARMUP);
end

function opvp.Match:_onMatchStateChanged(status, expected)
    opvp.printDebug(
        "opvp.Match._onMatchStateChanged, current_status=%s, new_status=%s, expected_status=%s",
        opvp.Match:nameForStatus(self._status),
        opvp.Match:nameForStatus(status),
        opvp.Match:nameForStatus(expected)
    );

    if status == expected then
        if status == opvp.MatchStatus.ROUND_WARMUP then
            self:_onMatchRoundWarmup();
        elseif status == opvp.MatchStatus.ROUND_ACTIVE then
            self:_onMatchRoundActive();
        elseif status == opvp.MatchStatus.ROUND_COMPLETE then
            self:_onMatchRoundComplete();
        elseif status == opvp.MatchStatus.COMPLETE then
            if self:isRoundBased() == false then
                self:_onMatchRoundComplete();
            end

            self:_onMatchComplete();
        elseif status == opvp.MatchStatus.EXIT then
            self:_onMatchExit();
        end

        return true;
    end

    if (
        (
            self._status == opvp.MatchStatus.ROUND_WARMUP or
            expected == opvp.MatchStatus.ROUND_WARMUP
        ) and
        (
            status == opvp.MatchStatus.ROUND_COMPLETE or
            status == opvp.MatchStatus.COMPLETE
        )
    ) then
        self._surrendered = true;

        if self._status == opvp.MatchStatus.ROUND_ACTIVE then
            self:_onMatchRoundComplete();
        end

        self:_onMatchComplete();

        return true;
    elseif (
        self._status == opvp.MatchStatus.ROUND_ACTIVE and
        (
            (
                status == opvp.MatchStatus.COMPLETE and
                expected == opvp.MatchStatus.ROUND_COMPLETE
            ) or
            (
                status == opvp.MatchStatus.ROUND_COMPLETE and
                expected == opvp.MatchStatus.COMPLETE
            )
        ) and
        self:isLastRound() == true
    ) then
        --~ Enum.PvPMatchState.PostRound and they way Blizz do status changes sigh.
        --~ Everything should have had a round start and round end.
        --~ The fact you have to apply logic and know game state + match type
        --~ to determine Enum.PvPMatchSate is redic design.

        self:_onMatchRoundComplete();
        self:_onMatchComplete();

        return true;
    end

    return false;
end

function opvp.Match:_onOutcomeReady(outcomeType)
    opvp.printDebug("opvp.Match._onOutcomeReady(%d)", outcomeType);

    if outcomeType == opvp.MatchOutcomeType.ROUND then
        local msg;
        local round_time = opvp.time.formatSeconds(self:roundElapsedTime());

        if self:hasDampening() == true and self._dampening > 0 then
            round_time = string.format(
                "%s @ %d%% %s",
                round_time,
                100 * self._dampening,
                opvp.spell.link(110310)
            );
        end

        if self:isWinner() == true then
            msg = opvp.strs.MATCH_ROUND_COMPLETE_WON;
        elseif self:hasWinner() == true then
            msg = opvp.strs.MATCH_ROUND_COMPLETE_LOST;
        else
            msg = opvp.strs.MATCH_ROUND_COMPLETE_DRAW;
        end

        opvp.printMessageOrDebug(
            opvp.options.announcements.match.roundComplete:value(),
            msg,
            self:round(),
            round_time
        );
    elseif outcomeType == opvp.MatchOutcomeType.MATCH then
        local msg;
        local elapsed = self:timeElapsed();

        if self:surrendered() == true then
            msg = opvp.strs.MATCH_SURRENDERED;
        else
            if self:isRoundBased() == true then
                msg = opvp_match_compelete_str_lookup[1][self._outcome];
            else
                msg = opvp_match_compelete_str_lookup[2][self._outcome];
            end
        end

        if msg ~= nil then
            opvp.printMessageOrDebug(
                opvp.options.announcements.match.complete:value(),
                msg,
                opvp.time.formatSeconds(elapsed),
                self:roundsWon(),
                self:roundsLost()
            );
        end
    end

    opvp.match.outcomeReady:emit(self, outcomeType);
end

function opvp.Match:_onPartyAboutToJoin(category, guid)
    if self:isTest() == true then
        return;
    end

    local team = self:playerTeam();

    if team ~= nil then
        opvp.party.manager():_setParty(team);
    end
end

function opvp.Match:_onScoreUpdate()
    opvp.printDebug("opvp.Match._onScoreUpdate");
end

function opvp.Match:_onStartTimer(timerType, timeSeconds, totalTime)
    if timerType == Enum.StartTimerType.PvPBeginTimer then
        self:_countdownStart(timeSeconds, totalTime);
    end
end

function opvp.Match:_onStopTimer(timerType)
    if timerType == Enum.StartTimerType.PvPBeginTimer then
        self:_countdownCancel();
    end
end

function opvp.Match:_setDampening(value)
    if value == self._dampening then
        return
    end

    self._dampening = value

    if value > 0 then
        opvp.printMessageOrDebug(
            opvp.options.announcements.match.dampening:value(),
            opvp.strs.MATCH_DAMPENING,
            100 * value
        );
    end

    opvp.match.dampeningUpdate:emit(value);
end

function opvp.Match:_setOutcome(outcome, team, outcomeType)
    if self._outcome_team ~= nil and self._outcome_team ~= team then
        self._outcome_team:_setWinner(false);
    end

    self._outcome       = outcome;
    self._outcome_team  = team;
    self._outcome_valid = outcomeType ~= opvp.MatchOutcomeType.NONE;

    if self._outcome_team ~= nil then
        self._outcome_team:_setWinner(true);
    end

    if self._outcome_valid == true then
        self._outcome_final = outcomeType == opvp.MatchOutcomeType.MATCH;

        self:_onOutcomeReady(outcomeType);
    else
        self._outcome_final = false;
    end
end

local opvp_match_signals_lookup;

function opvp.Match:_setStatus(status)
    if status == self._status then
        return;
    end

    local old_status = self._status;

    self._status = status;

    opvp.match.statusChanged:emit(self._status, old_status);

    local signal = opvp_match_status_signal_lookup[self._status];

    if signal ~= nil then
        signal:emit();
    end
end

function opvp.Match:_updateOutcome()
    if self:isTest() == false then
        return;
    end

    local winning_status, winning_team = opvp.match.manager():tester():outcome();

    self:_setOutcome(winning_status, winning_team, opvp.MatchOutcomeType.MATCH);
end

local function opvp_match_status_signal_lookup_ctor()
    opvp_match_status_signal_lookup = {
        [opvp.MatchStatus.INACTIVE]       = opvp.match.active,
        [opvp.MatchStatus.ENTERED]        = opvp.match.entered,
        [opvp.MatchStatus.JOINED]         = opvp.match.joined,
        [opvp.MatchStatus.ROUND_WARMUP]   = opvp.match.roundWarmup,
        [opvp.MatchStatus.ROUND_ACTIVE]   = opvp.match.roundActive,
        [opvp.MatchStatus.ROUND_COMPLETE] = opvp.match.roundComplete,
        [opvp.MatchStatus.COMPLETE]       = opvp.match.complete,
        [opvp.MatchStatus.EXIT]           = opvp.match.exit
    };
end

opvp.OnAddonLoad:register(opvp_match_status_signal_lookup_ctor);
