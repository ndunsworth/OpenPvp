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

opvp.GenericMatch = opvp.CreateClass(opvp.Match);

function opvp.GenericMatch:init(queue, description)
    opvp.Match.init(self, queue, description);

    self._friendly_team = opvp.MatchTeam(self);
    self._enemy_team    = opvp.MatchTeam(self);
    self._teams = {
        self._friendly_team,
        self._enemy_team
    };

    if description:isTest() == false then
        self._friendly_provider = opvp.PvpPartyMemberProvider(opvp.PvpPartyMemberFactory());
    else
        self._friendly_provider = nil;
    end

    self._enemy_provider = nil;

    self._player_side    = 0;
    self._match_start    = 0;
    self._round_start    = 0;
    self._round_end      = 0;
    self._init_teams     = true;
end

function opvp.GenericMatch:findOpponentByGuid(guid)
    return self._enemy_team:findMemberByGuid(guid);
end

function opvp.GenericMatch:findOpponentByUnitId(unitId)
    return self._friendly_team:findMemberByUnitId(unitId);
end

function opvp.GenericMatch:findTeamateByGuid(guid)
    return self._friendly_team:findMemberByGuid(guid);
end

function opvp.GenericMatch:findTeamateByUnitId(unitId)
    return self._friendly_team:findMemberByUnitId(unitId);
end

function opvp.GenericMatch:opponentTeam()
    return self._enemy_team;
end

function opvp.GenericMatch:opponents()
    return self._enemy_team:members();
end

function opvp.GenericMatch:opponentsSize()
    return self._enemy_team:size();
end

function opvp.GenericMatch:playerTeam()
    return self._friendly_team;
end

function opvp.GenericMatch:roundElapsedTime()
    if self:isActive() == true then
        return GetTime() - self._round_start;
    else
        return self._round_end - self._round_start;
    end
end

function opvp.GenericMatch:roundStartTime()
    return self._round_start;
end

function opvp.GenericMatch:startTime()
    return self._match_start;
end

function opvp.GenericMatch:team(index)
    return self._teams[index];
end

function opvp.GenericMatch:teamA()
    return self._teams[1];
end

function opvp.GenericMatch:teamB()
    return self._teams[2];
end

function opvp.GenericMatch:teammates()
    return self._friendly_team:members();
end

function opvp.GenericMatch:teammatesSize()
    return self._friendly_team:size();
end

function opvp.GenericMatch:teams()
    return {self._teams[1], self._teams[2]};
end

function opvp.GenericMatch:teamsSize()
    return 2;
end

function opvp.GenericMatch:_close()
    self._friendly_team:shutdown();

    self._friendly_team:_setMatch(nil);
    self._enemy_team:_setMatch(nil);

    self._friendly_team.initialized:disconnect(
        self._enemy_team,
        self._enemy_team.initialize
    );

    self._friendly_team.closed:disconnect(
        self._enemy_team,
        self._enemy_team.shutdown
    );

    opvp.Match._close(self);
end

function opvp.GenericMatch:_initializeTeams()
    if self._init_teams == false then
        return;
    end

    if self:isTest() == true then
        self._friendly_provider = opvp.PvpTestPartyMemberProvider(true);
        self._enemy_provider = opvp.PvpTestPartyMemberProvider();

        self._enemy_provider:_setHostile(true);

        self._friendly_provider:_setFactory(opvp.PvpPartyMemberFactory());
        self._enemy_provider:_setFactory(opvp.PvpPartyMemberFactory());
    else
        assert(
            self._friendly_provider ~= nil and
            self._enemy_provider ~= nil
        );
    end

    assert(
        self._friendly_provider:isFriendly() == true and
        self._enemy_provider:isHostile() == true
    );

    --~ No need to connect to the friendly provider as that means we would
    --~ get called twice since each provider emits.

    --~ Always ensure that enemy provider is the last to emit so that way
    --~ we dont emit globally before all teams are updated.
    self._enemy_provider.scoreUpdate:connect(self, self._onScoreUpdate);

    self._friendly_team:_setMatch(self);
    self._enemy_team:_setMatch(self);

    self._friendly_team:_setProvider(self._friendly_provider);
    self._enemy_team:_setProvider(self._enemy_provider);

    self._friendly_team.initialized:connect(
        self._enemy_team,
        self._enemy_team.initialize
    );

    self._friendly_team.closed:connect(
        self._enemy_team,
        self._enemy_team.shutdown
    );

    self._init_teams = false;
end

function opvp.GenericMatch:_onMatchComplete()
    if self:isRoundBased() == false and self:isActive() == true then
        self:_onMatchRoundComplete();
    end

    opvp.Match._onMatchComplete(self);
end

function opvp.GenericMatch:_onMatchExit()
    self._enemy_team:shutdown();

    opvp.Match._onMatchExit(self);
end

function opvp.GenericMatch:_onMatchJoined()
    self._match_start = GetTime();

    local runtime = GetBattlefieldInstanceRunTime();

    if runtime ~= nil then
        self._match_start = self._match_start - (runtime / 1000);
    end

    opvp.Match._onMatchJoined(self);
end

function opvp.GenericMatch:_onMatchRoundActive()
    self._round_start = GetTime();

    if self:joinedInProgress() == true then
        self._round_start = self._round_start - self:timeElapsed();
    end

    self._round_end = 0;

    opvp.Match._onMatchRoundActive(self);
end

function opvp.GenericMatch:_onMatchRoundComplete()
    self._round_end = GetTime();

    opvp.Match._onMatchRoundComplete(self);
end

function opvp.GenericMatch:_onMatchRoundWarmup()
    opvp.Match._onMatchRoundWarmup(self);
end

function opvp.GenericMatch:_onPartyAboutToJoin(category, guid)
    if self:isTest() == false then
        self._player_side = GetBattlefieldArenaFaction() + 1;
    elseif opvp.player.isAlliance() == true then
        self._player_side = 1;
    else
        self._player_side = 2;
    end

    if self._player_side == 1 then
        self._teams = {
            self._friendly_team,
            self._enemy_team
        };
    else
        self._teams = {
            self._enemy_team,
            self._friendly_team
        };
    end

    self._teams[1]:_setId(1);
    self._teams[2]:_setId(2);

    self:_initializeTeams();

    opvp.Match._onPartyAboutToJoin(self, category, guid);

    if self:isTest() == true then
        self._friendly_team:initialize(category, guid);

        if self:isSimulation() == true then
             self._friendly_provider:addMembers(
                self:matchTeamSize() - 1
            );

             self._enemy_provider:addMembers(
                self:matchTeamSize()
            );
        end
    end
end

function opvp.GenericMatch:_updateOutcome()
    local winning_status;
    local winning_team;

    if self:isTest() == true then
        winning_status, winning_team = opvp.match.manager():tester():outcome();
    else
        winning_status = opvp.match.utils.winner();

        if winning_status == opvp.MatchWinner.WON then
            winning_team = self:playerTeam();
        else
            winning_team = self:opponentTeam();
        end
    end

    local outcome_type;

    if self:isRoundBased() == true then
        outcome_type = opvp.MatchOutcomeType.ROUND;
    else
        outcome_type = opvp.MatchOutcomeType.MATCH;
    end

    self:_setOutcome(winning_status, winning_team, outcome_type);
end
