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

local opvp_use_music_intro = {
    [opvp.InstanceId.SEETHING_SHORE]            = true
};

opvp.MatchTestAudio = opvp.CreateClass();

function opvp.MatchTestAudio:init()
    self._match            = nil;
    self._test_type        = opvp.MatchTestType.NONE;
    self._music_handle     = 0;
end

function opvp.MatchTestAudio:start(tester)
    self._match     = tester:match();
    self._test_type = tester:testType();

    opvp.match.complete:connect(self, self._onMatchComplete);
    opvp.match.entered:connect(self, self._onMatchEntered);
    opvp.match.joined:connect(self, self._onMatchJoined);
    opvp.match.exit:connect(self, self._onMatchExit);
    opvp.match.roundWarmup:connect(self, self._onMatchRoundWarmup);
    opvp.match.roundActive:connect(self, self._onMatchRoundActive);
    opvp.match.roundComplete:connect(self, self._onMatchRoundComplete);

    opvp.options.audio.soundeffect.test.music.changed:connect(self, self.stopMusic);
end

function opvp.MatchTestAudio:stop()
    self._match            = nil;
    self._test_type        = opvp.MatchTestType.NONE;

    opvp.match.complete:disconnect(self, self._onMatchComplete);
    opvp.match.entered:disconnect(self, self._onMatchEntered);
    opvp.match.joined:disconnect(self, self._onMatchJoined);
    opvp.match.exit:disconnect(self, self._onMatchExit);
    opvp.match.roundWarmup:disconnect(self, self._onMatchRoundWarmup);
    opvp.match.roundActive:disconnect(self, self._onMatchRoundActive);
    opvp.match.roundComplete:disconnect(self, self._onMatchRoundComplete);

    opvp.options.audio.soundeffect.test.music.changed:disconnect(self, self.stopMusic);
end

function opvp.MatchTestAudio:isAborting()
    return self._match:surrendered();
end

function opvp.MatchTestAudio:isSimulation()
    return self._test_type == opvp.MatchTestType.SIMULATION;
end

function opvp.MatchTestAudio:isSimulationFxEnabled()
    return opvp.options.audio.soundeffect.test.fx:value();
end

function opvp.MatchTestAudio:isSimulationMusicEnabled()
    return opvp.options.audio.soundeffect.test.music:value();
end

function opvp.MatchTestAudio:stopMusic()
    if self._music_handle ~= 0 then
        StopSound(self._music_handle, 2000);

        self._music_handle = 0;
    end
end

function opvp.MatchTestAudio:_onMatchComplete()
    if self:isAborting() == true then
        return;
    end

    if (
        self:isSimulation() == true and
        self._match:isBattleground() == true
    ) then
        local sound;

        if self._match:isWinner() == true then
            sound = opvp.player.factionInfo():battlegroundWinSound();
        else
            sound = opvp.player.factionInfo():battlegroundLostSound();
        end

        sound:play(opvp.SoundChannel.SFX);
    end
end

function opvp.MatchTestAudio:_onMatchEntered()
    if (
        self:isSimulation() == true and
        self:isSimulationFxEnabled() == true
    ) then
        if self._match:isBattleground() == true then
            PlaySound(8459, opvp.SoundChannel.SFX);
        else
            PlaySound(8960, opvp.SoundChannel.SFX);
        end
    end
end

function opvp.MatchTestAudio:_onMatchExit()

end

function opvp.MatchTestAudio:_onMatchJoined()

end

function opvp.MatchTestAudio:_onMatchRoundActive()
    if self:isAborting() == true then
        return;
    end

    if self:isSimulationFxEnabled() == true then
        if self._match:isBattleground() == true then
            PlaySound(3439, opvp.SoundChannel.SFX);
        end

        local sound = opvp_gate_open_mapid_lookup[self._match:map():instanceId()];

        if sound ~= nil then
            sound:play(opvp.SoundChannel.SFX);
        end
    end

    self:_startMusic();
end

function opvp.MatchTestAudio:_onMatchRoundComplete()
    self:stopMusic();

    if self:isAborting() == true then
        return;
    end

    if (
        self:isSimulation() == true and
        self:isSimulationFxEnabled() == true
    ) then
        local sfx_sound;

        if losing_team ~= nil then
            if losing_team:hasPlayer() == true then
                 sfx_sound = opvp_gate_close_lose_sfx_mapid_lookup[self._match:mapId()];
            else
                 sfx_sound = opvp_gate_close_win_sfx_mapid_lookup[self._match:mapId()];
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

function opvp.MatchTestAudio:_onMatchRoundWarmup()

end

function opvp.MatchTestAudio:_startMusic()
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

    if map:hasMusic() == true and opvp_use_music_intro[self._match:mapId()] == nil then
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
