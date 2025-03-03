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

local opvp_gate_open_mapid_lookup = {
    [opvp.InstanceId.ALTERAC_VALLEY]            = 25521,
    [opvp.InstanceId.ARATHI_BASIN]              = 25528,
    [opvp.InstanceId.ARATHI_BASIN_CLASSIC]      = 25528,
    [opvp.InstanceId.ARATHI_BASIN_COMP_STOMP]   = 25528,
    [opvp.InstanceId.ARATHI_BASIN_WINTER]       = 25528,
    [opvp.InstanceId.DALARAN_SEWERS]            = 15196,
    [opvp.InstanceId.NAGRAND_ARENA]             = 79311,
    [opvp.InstanceId.THE_ROBODROME]             = 134872,
    [opvp.InstanceId.TIGERS_PEAK]               = 28727,
    [opvp.InstanceId.TWIN_PEAKS]                = 20559, --~ Alliance 20557
    [opvp.InstanceId.WARSONG_GULCH]             = 43158,
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = 43158
};

local opvp_gate_close_mapid_lookup = {
    [opvp.InstanceId.NAGRAND_ARENA]             = 79310,
    [opvp.InstanceId.THE_ROBODROME]             = 134874,
    [opvp.InstanceId.TIGERS_PEAK]               = 28726,
    [opvp.InstanceId.TWIN_PEAKS]                = 20558, --~ Alliance 20556
    [opvp.InstanceId.WARSONG_GULCH]             = 43159,
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = 43159
};

local opvp_faction_win_sound = {
    [opvp.ALLIANCE] = 8455,
    [opvp.HORDE]    = 8454
};

opvp.MatchTest = opvp.CreateClass();

function opvp.MatchTest:init()
    self._match            = nil;
    self._active           = false;
    self._countdown_active = false;
    self._simulate         = false;
    self._party_index      = 0;

    self._warmup_timer  = opvp.Timer(1);
    self._active_timer  = opvp.Timer(5);

    self._warmup_timer:setTriggerLimit(4);

    self._active_timer.timeout:connect(self, self._onMatchRoundActiveTimer);
    self._warmup_timer.timeout:connect(self, self._onMatchRoundWarmupTimer);

    self._timer_tracker = CreateFrame("Frame", "MatchTest", UIParent);

    self._timer_tracker.timerList = {};
    self._timer_tracker.StartTimerOfType = TimerTracker_StartTimerOfType;

    self._timer_tracker:SetScript("OnEvent", TimerTracker_OnEvent);
end

function opvp.MatchTest:initialize(pvpType, map, pvpFlags, simulate)
    if self:isRunning() == true then
        return;
    end

    local queue;

    if pvpType == opvp.PvpType.ARENA then
        if (
            opvp.is_number(pvpFlags) == true and
            bit.band(pvpFlags, opvp.PvpFlag.SHUFFLE) ~= 0
        ) then
            queue = opvp.Queue.SHUFFLE
        else
            queue = opvp.Queue.ARENA_SKIRMISH
        end
    else
        local info = opvp.queue.manager():_findBattlegroundInfo(map:name());

        if info == nil then
            return;
        end

        queue = opvp.Queue.BATTLEGROUND_TEST;

        queue:_setInfo(info);
    end

    self._match = queue:_createMatch(map, true);

    if self._match == nil then
        return;
    end

    self._simulate = simulate ~= false;
    self._active = true;
end

function opvp.MatchTest:isRunning()
    return self._active;
end

function opvp.MatchTest:isSimulation()
    return self._simulate;
end

function opvp.MatchTest:match()
    return self._match;
end

function opvp.MatchTest:start()
    if (
        self._match ~= nil and
        self._match:status() == opvp.MatchStatus.INACTIVE
    ) then
        self:_onMatchEntered();
        self:_onMatchJoined();
        self:_onMatchRoundWarmup();
    end
end

function opvp.MatchTest:status()
    if self._match ~= nil then
        return self._match:status();
    else
        return opvp.MatchStatus.INACTIVE;
    end
end

function opvp.MatchTest:stop()
    if self:isRunning() == false then
        return;
    end

    if self._match:isWarmup() == true then
        self._warmup_timer:stop();

        self:_onMatchRoundComplete();
    elseif self._match:isActive() == true then
        self:_onMatchRoundComplete();
    end

    if self._match:isComplete() == false then
        self:_onMatchComplete();
    end

    self:_onMatchExit();

    self._active = false;
end

function opvp.MatchTest:_onMatchComplete()
    self._warmup_timer:stop();
    self._active_timer:stop();

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.COMPLETE,
        self._match:statusNext()
    );
end

function opvp.MatchTest:_onMatchEntered()
    self._match._testing = true;

    if self._simulate == true then
        PlaySound(8459, opvp.SoundChannel.SFX);
    end

    self._match:_onMatchEntered();
end

function opvp.MatchTest:_onMatchJoined()
    self._match:_onMatchJoined();

    self._party_index = self._party_index + 1;

    self._match:_onPartyAboutToJoin(
        opvp.PartyCategory.INSTANCE,
        string.format(
            "TestParty-%s-0-%08x",
            GetRealmID(),
            self._party_index
        )
    );
end

function opvp.MatchTest:_onMatchExit()
    if self._countdown_active == true then
        self._timer_tracker:StartTimerOfType(
            Enum.StartTimerType.PlayerCountdown,
            0,
            0,
            false,
            opvp.player.guid(),
            opvp.player.name()
        );

        self._countdown_active = false;
    end

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.EXIT,
        self._match:statusNext()
    );

    self._match:_close();
    self._match = nil;
end

function opvp.MatchTest:_onMatchRoundActive()
    self._warmup_timer:stop();
    --~ self._active_timer:start();

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_ACTIVE,
        self._match:statusNext()
    );
end

function opvp.MatchTest:_onMatchRoundActiveTimer()
    local team;

    if math.random(0, 1) == 0 then
        team = self._match:playerTeam();
    else
        team = self._match:opponentTeam();
    end

    if team == nil then
        return;
    end

    local index = math.random(1, team:size());

    local member = team:member(index);

    if member ~= nil and member:isPlayer() == true then
        index = ((index + 1) % team:size()) + 1;

        member = team:member(index);
    end

    if member ~= nil then
        self._match:_onMemberTrintetUsed(
            member,
            336126
        );
    end
end

function opvp.MatchTest:_onMatchRoundComplete()
    self._active_timer:stop();

    if self._match:isArena() == true and self._match:isActive() == true then
        local team = self._match:playerTeam();

        if team ~= nil then
            local member = team:member(math.random(2, team:size()));

            if member ~= nil then
                member:_setDead(true);
                member:_setEnabled(false);

                team:_onMemberInfoUpdate(
                    member,
                    bit.bor(opvp.PartyMember.DEAD_FLAG, opvp.PartyMember.ENABLED_FLAG)
                );
            end
        end
    end

    if self._match:isBattleground() == true then
        self._match:_setOutcome(
            opvp.MatchWinner.WON,
            self._match:playerTeam()
        );
    else
        self._match:_setOutcome(
            opvp.MatchWinner.LOST,
            self._match:opponentTeam()
        );
    end

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_COMPLETE,
        self._match:statusNext()
    );

    if (
        self._simulate == true and
        self._match:isBattleground() == true
    ) then
        local sound;

        if self._match:isWinner() == true then
            sound = opvp_faction_win_sound[opvp.player.faction()];
        else
            sound = opvp_faction_win_sound[opvp.player.factionOpposite()];
        end

        if sound ~= nil then
            PlaySound(sound, opvp.SoundChannel.SFX);
        end
    end
end

function opvp.MatchTest:_onMatchRoundWarmup()
    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_WARMUP,
        self._match:statusNext()
    );

    if self._simulate == true then
        self._countdown_active = true;

        self._warmup_timer:start();
    else
        self:_onMatchRoundActive();
    end
end

function opvp.MatchTest:_onMatchRoundWarmupTimer()
    local triggers = self._warmup_timer:remainingTriggers();

    if triggers == 3 then
        self._match:_onCountdownUpdate(60, 60);

        self._timer_tracker:StartTimerOfType(
            Enum.StartTimerType.PlayerCountdown,
            3,
            3,
            false,
            opvp.player.guid(),
            opvp.player.name()
        );
    elseif triggers == 2 then
        self._match:_onCountdownUpdate(30, 60);
    elseif triggers == 1 then
        self._match:_onCountdownUpdate(15, 60);
    else
        self._countdown_active = false;

        if self._match:isBattleground() == true then
            PlaySound(3439, opvp.SoundChannel.SFX);
        end

        local sound = opvp_gate_open_mapid_lookup[self._match:map():instanceId()];

        if sound ~= nil then
            PlaySound(sound, opvp.SoundChannel.SFX);
        end

        self:_onMatchRoundActive();
    end
end
