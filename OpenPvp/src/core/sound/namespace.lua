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

opvp.sound = {};

opvp.SoundChannel = {
    AMBIENCE = "Ambience";
    DIALOG   = "Dialog";
    MASTER   = "Master";
    MUSIC    = "Music";
    SFX      = "SFX";
};

function opvp.sound.volume(channel)
    return tonumber(C_CVar.GetCVar("Sound_" .. channel .. "Volume"));
end

function opvp.sound.isEnabled(channel)
    if channel == opvp.SoundChannel.MASTER then
        channel = "AllSound";
    end

    return C_CVar.GetCVar("Sound_Enable" .. channel) == "1";
end

function opvp.sound.isDialogEnabled()
    return opvp.sound.isEnabled(opvp.SoundChannel.DIALOG);
end

function opvp.sound.isMusicEnabled()
    return opvp.sound.isEnabled(opvp.SoundChannel.MUSIC);
end

function opvp.sound.isMasterEnabled()
    return opvp.sound.isEnabled(opvp.SoundChannel.MASTER);
end

function opvp.sound.isSoundEffectsEnabled()
    return opvp.sound.isEnabled(opvp.SoundChannel.SFX);
end

function opvp.sound.nextVolumeTick(channel)
    local volume = opvp.sound.volume(channel);

    if (volume < 0.125) then
        return 0.125;
    elseif (volume < 0.25) then
        return 0.25;
    elseif (volume < 0.5) then
        return 0.5;
    elseif (volume < 0.75) then
        return 0.75;
    elseif (volume < 1 or not wrap) then
        return 1;
    else
        return 0;
    end
end

function opvp.sound.prevVolumeTick(channel, wrap)
    local volume = opvp.sound.volume(channel);

    if (volume > 0.75) then
        return 0.75;
    elseif (volume > 0.5) then
        return 0.5;
    elseif (volume > 0.25) then
        return 0.25;
    elseif (volume > 0.125) then
        return 0.125;
    elseif (volume > 0 or not wrap) then
        return 0;
    else
        return 1;
    end
end

function opvp.sound.setEnabled(channel, state)
    if state == opvp.sound.isEnabled(channel) then
        return;
    end

    if channel == opvp.SoundChannel.MASTER then
        channel = "AllSound";
    end

    if state == true then
        C_CVar.SetCVar("Sound_Enable" .. channel, 1);

        if channel == opvp.SoundChannel.MUSIC then
            ActionStatus:DisplayMessage(MUSIC_ENABLED);
        end
    else
        C_CVar.SetCVar("Sound_Enable" .. channel, 0);

        if channel == opvp.SoundChannel.MUSIC then
            ActionStatus:DisplayMessage(MUSIC_DISABLED);
        elseif channel == "AllSound" then
            ActionStatus:DisplayMessage(SOUND_DISABLED);
        end
    end
end

function opvp.sound.setDialogEnabled(state)
    opvp.sound.setEnabled(opvp.SoundChannel.DIALOG, state);
end

function opvp.sound.setMasterEnabled(state)
    opvp.sound.setEnabled(opvp.SoundChannel.MASTER, state);
end

function opvp.sound.setMusicEnabled(state)
    opvp.sound.setEnabled(opvp.SoundChannel.MUSIC, state);
end

function opvp.sound.setSoundEffectsEnabled(state)
    opvp.sound.setEnabled(opvp.SoundChannel.DIALOG, state);
end

function opvp.sound.setVolume(channel, value)
    local cvar = "Sound_" .. channel .. "Volume";

    local volume = C_CVar.GetCVar(cvar);

    value = min(max(value, 0), 1);

    if value ~= volume then
        C_CVar.SetCVar(cvar, value);

        opvp.printMessage("Volume | %s - %d%%", channel, 100 * value);
    end
end

function opvp.sound.toggleDialog()
    opvp.sound.setDialogEnabled(
        not opvp.sound.isMusicEnabled()
    );
end

function opvp.sound.toggleMaster()
    opvp.sound.setMasterEnabled(
        not opvp.sound.isMasterEnabled()
    );
end

function opvp.sound.toggleMusic()
    opvp.sound.setMusicEnabled(
        not opvp.sound.isMusicEnabled()
    );
end

function opvp.sound.toggleSoundEffects()
    opvp.sound.setSoundEffectsEnabled(
        not opvp.sound.isSoundEffectsEnabled()
    );
end

function opvp.sound.volumeDown(channel, wrap)
    opvp.sound.setVolume(
        channel,
        opvp.sound.prevVolumeTick(channel, wrap)
    );
end

function opvp.sound.volumeUp(channel, wrap)
    opvp.sound.setVolume(
        channel,
        opvp.sound.nextVolumeTick(channel, wrap)
    );
end
