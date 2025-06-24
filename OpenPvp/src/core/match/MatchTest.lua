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
    [opvp.InstanceId.ALTERAC_VALLEY]            = opvp.SoundKitSound(25521),
    [opvp.InstanceId.ARATHI_BASIN]              = opvp.SoundKitSound(25528),
    [opvp.InstanceId.ARATHI_BASIN_CLASSIC]      = opvp.SoundKitSound(25528),
    [opvp.InstanceId.ARATHI_BASIN_COMP_STOMP]   = opvp.SoundKitSound(25528),
    [opvp.InstanceId.ARATHI_BASIN_WINTER]       = opvp.SoundKitSound(25528),
    [opvp.InstanceId.CAGE_OF_CARNAGE]           = opvp.SyntheticSound(
                                                    {
                                                        opvp.FileDataSound(6324470),
                                                        opvp.FileDataSound(6324472),
                                                        opvp.FileDataSound(6324474),
                                                        opvp.FileDataSound(6324476),
                                                        opvp.FileDataSound(6324478),
                                                        opvp.FileDataSound(6324480),
                                                        opvp.FileDataSound(6324482),
                                                        opvp.FileDataSound(6324484),
                                                        opvp.FileDataSound(6324486),
                                                        opvp.FileDataSound(6324488),
                                                        opvp.FileDataSound(6324490),
                                                        opvp.FileDataSound(6324492),
                                                        opvp.FileDataSound(6324494)
                                                    }
                                                ),
    [opvp.InstanceId.DALARAN_SEWERS]            = opvp.SoundKitSound(15196),
    [opvp.InstanceId.NAGRAND_ARENA]             = opvp.SoundKitSound(79311),
    [opvp.InstanceId.RUINS_OF_LORDAERON]        = opvp.SoundKitSound(11735),
    [opvp.InstanceId.THE_ROBODROME]             = opvp.SoundKitSound(134872),
    [opvp.InstanceId.TIGERS_PEAK]               = opvp.SoundKitSound(28727),
    [opvp.InstanceId.TWIN_PEAKS]                = opvp.SoundKitSound(20559), --~ Alliance 20557
    [opvp.InstanceId.WARSONG_GULCH]             = opvp.SoundKitSound(43158),
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = opvp.SoundKitSound(43158)
};

local opvp_gate_close_lose_sfx_mapid_lookup = {
    [opvp.InstanceId.CAGE_OF_CARNAGE]           = opvp.SyntheticSound(
                                                    {
                                                        opvp.FileDataSound(6390491),
                                                        opvp.FileDataSound(6390493),
                                                        opvp.FileDataSound(6390495),
                                                        opvp.FileDataSound(6390497),
                                                        opvp.FileDataSound(6390499)
                                                    }
                                                )
};

local opvp_gate_close_win_sfx_mapid_lookup = {
    [opvp.InstanceId.CAGE_OF_CARNAGE]           = opvp.SyntheticSound(
                                                    {
                                                        opvp.FileDataSound(6390463),
                                                        opvp.FileDataSound(6390465),
                                                        opvp.FileDataSound(6390467),
                                                        opvp.FileDataSound(6390469),
                                                        opvp.FileDataSound(6390471)
                                                    }
                                                )
};

local opvp_gate_close_mapid_lookup = {
    [opvp.InstanceId.NAGRAND_ARENA]             = opvp.SoundKitSound(79310),
    [opvp.InstanceId.RUINS_OF_LORDAERON]        = opvp.SoundKitSound(11736),
    [opvp.InstanceId.THE_ROBODROME]             = opvp.SoundKitSound(134874),
    [opvp.InstanceId.TIGERS_PEAK]               = opvp.SoundKitSound(28726),
    [opvp.InstanceId.TWIN_PEAKS]                = opvp.SoundKitSound(20558), --~ Alliance 20556
    [opvp.InstanceId.WARSONG_GULCH]             = opvp.SoundKitSound(43159),
    [opvp.InstanceId.WARSONG_GULCH_CLASSIC]     = opvp.SoundKitSound(43159)
};

opvp.MatchTestType = {
    NONE       = 0;
    FEATURE    = 1,
    SIMULATION = 2
};

opvp.MatchTest = opvp.CreateClass();

function opvp.MatchTest:init()
    self._match            = nil;
    self._active           = false;
    self._countdown_active = false;
    self._test_type        = opvp.MatchTestType.NONE;
    self._party_index      = 0;
    self._outcome_status   = opvp.MatchWinner.WON;
    self._outcome_team     = nil;
    self._music_handle     = 0;

    self._warmup_timer     = opvp.Timer(1);
    self._active_timer     = opvp.Timer(5);
    self._dampening_timer  = opvp.Timer(5);

    self._warmup_timer:setTriggerLimit(4);
    self._dampening_timer:setTriggerLimit(4);

    self._active_timer.timeout:connect(self, self._onMatchRoundActiveTimer);
    self._warmup_timer.timeout:connect(self, self._onMatchRoundWarmupTimer);
    self._dampening_timer.timeout:connect(self, self._onMatchRoundDampeningTimer);

    self._timer_tracker = CreateFrame("Frame", "MatchTest", UIParent);

    self._timer_tracker.timerList = {};
    self._timer_tracker.StartTimerOfType = TimerTracker_StartTimerOfType;

    self._timer_tracker:SetScript("OnEvent", TimerTracker_OnEvent);
end

function opvp.MatchTest:initialize(pvpType, map, pvpFlags, simulate)
    if self:isRunning() == true then
        return;
    end

    pvpFlags = opvp.number_else(pvpFlags)

    local queue;

    if pvpType == opvp.PvpType.ARENA then
        if bit.band(pvpFlags, opvp.PvpFlag.SHUFFLE) ~= 0 then
            queue = opvp.Queue.SHUFFLE
        elseif bit.band(pvpFlags, opvp.PvpFlag.SKIRMISH) ~= 0 then
            queue = opvp.Queue.ARENA_SKIRMISH;
        else
            queue = opvp.Queue.ARENA_3V3;
        end
    else
        if bit.band(pvpFlags, opvp.PvpFlag.BLITZ) ~= 0 then
            queue = opvp.Queue.BLITZ;
        else
            local info = opvp.queue.manager():_findBattlegroundInfo(map:name());

            if info == nil then
                return;
            end

            queue = opvp.Queue.BATTLEGROUND_TEST;

            queue:_setInfo(info);
        end
    end

    local mask;

    if simulate == true then
        self._test_type = opvp.MatchTestType.SIMULATION;

        mask = bit.bor(opvp.PvpFlag.TEST, opvp.PvpFlag.SIMULATION);
    else
        self._test_type = opvp.MatchTestType.FEATURE;

        mask = opvp.PvpFlag.TEST;
    end

    self._match = queue:_createMatch(map, mask);

    if self._match == nil then
        return;
    end

    self._active = true;
end

function opvp.MatchTest:isRunning()
    return self._active;
end

function opvp.MatchTest:isSimulation()
    return self._test_type == opvp.MatchTestType.SIMULATION;
end

function opvp.MatchTest:isSimulationFxEnabled()
    return opvp.options.audio.soundeffect.test.fx:value();
end

function opvp.MatchTest:isSimulationMusicEnabled()
    return opvp.options.audio.soundeffect.test.music:value();
end

function opvp.MatchTest:match()
    return self._match;
end

function opvp.MatchTest:mode()
    return self._test_type;
end

function opvp.MatchTest:outcome()
    return self._outcome_status, self._outcome_team;
end

function opvp.MatchTest:outcomeTeam()
    return self._outcome_team;
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

    self:_onMatchComplete();

    self:_onMatchExit();

    self._active           = false;
    self._outcome_status   = opvp.MatchWinner.WON;
    self._outcome_team     = nil;
end

function opvp.MatchTest:stopMusic()
    if self._music_handle ~= 0 then
        StopSound(self._music_handle, 2000);

        self._music_handle = 0;
    end
end

function opvp.MatchTest:timeElapsed()
    if self._time_started > 0 then
        return GetTime() - self._time_started;
    else
        return 0;
    end
end

function opvp.MatchTest:timeStarted()
    return self._time_started;
end

function opvp.MatchTest:_onMatchComplete()
    self._warmup_timer:stop();
    self._active_timer:stop();
    self._dampening_timer:stop();

    if self._match:isComplete() == false then
        self._match:_onMatchStateChanged(
            opvp.MatchStatus.COMPLETE,
            self._match:statusNext()
        );
    end

    opvp.event.UPDATE_BATTLEFIELD_SCORE:emit();

    if self:isSimulation() == true then
        if self._match:isBattleground() == true then
            local sound;

            if self._match:isWinner() == true then
                sound = opvp.player.factionInfo():battlegroundWinSound();
            else
                sound = opvp.player.factionInfo():battlegroundLostSound();
            end

            sound:play(opvp.SoundChannel.SFX);
        end
    end
end

function opvp.MatchTest:_onMatchEntered()
    if self:isSimulation() == true then
        opvp.notify.pvp(
            string.format(
                opvp.strs.MATCH_TEST_BEGIN_HEADER,
                self._match:queue():name()
            ),
            string.format(
                opvp.strs.MATCH_TEST_BEGIN_FOOTER,
                self._match:map():name()
            ),
            true
        );

        if self:isSimulationFxEnabled() == true then
            if self._match:isBattleground() == true then
                PlaySound(8459, opvp.SoundChannel.SFX);
            else
                PlaySound(8960, opvp.SoundChannel.SFX);
            end
        end
    end

    self._match:_onMatchEntered();
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

    if self:isSimulation() == true then
        opvp.notify.pvp(
            string.format(
                opvp.strs.MATCH_TEST_END_HEADER,
                self._match:queue():name()
            ),
            opvp.strs.MATCH_TEST_END_FOOTER,
            true
        );
    end

    self._match:_close();
    self._match = nil;
end

function opvp.MatchTest:_onMatchJoined()
    self._match:_onMatchJoined();

    self._party_index = self._party_index + 1;
end

function opvp.MatchTest:_onMatchRoundActive()
    self._warmup_timer:stop();
    --~ self._active_timer:start();

    if (
        self:isSimulation() == true and
        self._match:hasDampening() == true
    ) then
        self._dampening_timer:start();
    end

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_ACTIVE,
        self._match:statusNext()
    );

    opvp.event.UPDATE_BATTLEFIELD_SCORE:emit();

    self:_startMusic();
end

function opvp.MatchTest:_onMatchRoundDampeningTimer()
    local dampening = self._match:dampening() * 100;

    if dampening == 0 then
        dampening = 10;
    else
        dampening = dampening + 10;
    end

    self._match:_setDampening(dampening / 100);
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
        self._match:_onMemberTrinketUsed(
            member,
            336126
        );
    end
end

function opvp.MatchTest:_onMatchRoundComplete()
    local is_sim = self:isSimulation();

    self:stopMusic();

    self._active_timer:stop();
    self._dampening_timer:stop();

    local losing_team;

    if math.random(0, 1) == 1 then
        self._outcome_status = opvp.MatchWinner.WON;
        self._outcome_team   = self._match:playerTeam();

        losing_team          = self._match:opponentTeam();
    else
        self._outcome_status = opvp.MatchWinner.LOST;
        self._outcome_team   = self._match:opponentTeam();

        losing_team          = self._match:playerTeam();
    end

    if is_sim == true then
        if (
            self._match:isArena() == true and
            self._match:isActive() == true
        ) then
            if losing_team ~= nil and losing_team:isEmpty() == false then
                local member = losing_team:member(math.random(1, losing_team:size()));

                if member ~= nil then
                    member:_setEnabled(false);
                    member:_setDead(true);

                    losing_team:_onMemberInfoUpdate(
                        member,
                        bit.bor(opvp.PartyMember.DEAD_FLAG, opvp.PartyMember.ENABLED_FLAG)
                    );
                end
            end
        end
    end

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_COMPLETE,
        self._match:statusNext()
    );

    opvp.event.UPDATE_BATTLEFIELD_SCORE:emit();

    if (
        is_sim == true and
        self:isSimulationFxEnabled() == true
    ) then
        local sfx_sound;

        if losing_team ~= nil then
            if losing_team:hasPlayer() == true then
                 sfx_sound = opvp_gate_close_lose_sfx_mapid_lookup[self._match:map():id()];
            else
                 sfx_sound = opvp_gate_close_win_sfx_mapid_lookup[self._match:map():id()];
            end
        end

        if sfx_sound ~= nil then
            sfx_sound:play(opvp.SoundChannel.SFX);
        end

        if self._match:isShuffle() == true then
            PlaySound(888, opvp.SoundChannel.SFX);
        end
    end
end

function opvp.MatchTest:_onMatchRoundWarmup()
    self._time_started = GetTime();

    self._match:_onMatchStateChanged(
        opvp.MatchStatus.ROUND_WARMUP,
        self._match:statusNext()
    );

    self._match:_onPartyAboutToJoin(
        opvp.PartyCategory.INSTANCE,
        string.format(
            "TestParty-%s-0-%08x",
            GetRealmID(),
            self._party_index
        )
    );

    opvp.event.UPDATE_BATTLEFIELD_SCORE:emit();

    if self:isSimulation() == true then
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

        if self:isSimulationFxEnabled() == true then
            if self._match:isBattleground() == true then
                PlaySound(3439, opvp.SoundChannel.SFX);
            end

            local sound = opvp_gate_open_mapid_lookup[self._match:map():instanceId()];

            if sound ~= nil then
                sound:play(opvp.SoundChannel.SFX);
            end
        end

        self:_onMatchRoundActive();
    end
end

function opvp.MatchTest:_startMusic()
    if (
        self:isSimulation() == false or
        self:isSimulationMusicEnabled() == false or
        opvp.sound.isMusicEnabled() == true or
        self._music_handle ~= 0
    ) then
        return;
    end

    local map = self._match:map();

    local sound;

    if map:hasMusic() == true then
        sound = map:music();
    elseif map:hasMusicIntro() == true then
        sound = map:musicIntro();
    end

    if sound == nil then
        return;
    end

    local valid, sound_handle;

    if sound:type() == opvp.SoundType.Faction then
        valid, sound_handle = sound:play(opvp.player.faction());
    else
        valid, sound_handle = sound:play();
    end

    if valid == true then
        self._music_handle = sound_handle
    end
end
