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

opvp.private.QueueReadyFailSoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.QueueReadyFailSoundEffect:init(option)
    opvp.private.SoundEffect.init(self, option);

    self._timer = opvp.Timer(2);

    self._timer:setTriggerLimit(1);

    self._timer.timeout:connect(self, self.play);
end

function opvp.private.QueueReadyFailSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.QueueReadyFailSoundEffect:play()
    opvp.effect.queueReadyFail(
        opvp.player.race(),
        opvp.player.sex()
    );
end

function opvp.private.QueueReadyFailSoundEffect:_onFeatureActivated()
    opvp.queue.readyCheckEnd:connect(self, self._onQueueReadyCheckEnd);

    opvp.private.SoundEffect._onFeatureActivated(self);
end

function opvp.private.QueueReadyFailSoundEffect:_onFeatureDeactivated()
    opvp.queue.statusChanged:disconnect(self, self._onQueueStatusChanged);

    opvp.private.SoundEffect._onFeatureDeactivated(self);
end

function opvp.private.QueueReadyFailSoundEffect:_onQueueReadyCheckEnd(queue)
    if queue:readyCheckDeclined() > 0 then
        self._timer:start();
    end
end

function opvp.effect.queueReadyFail(race, sex)
    local sound = opvp.effect.queueReadyFailSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

local opvp_queue_ready_index = 0;

function opvp.effect.queueReadyFailSound(race)
    return opvp.Emote.SIGH:sound(race);
end

local opvp_queue_ready_fail_sound_effect;

local function opvp_queue_ready_fail_sound_effect_sample(button, state)
    if state == false then
        opvp.effect.queueReadyFail(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

local function opvp_queue_ready_fail_sound_effect_ctor()
    opvp_queue_ready_fail_sound_effect = opvp.private.QueueReadyFailSoundEffect(
        opvp.options.audio.soundeffect.player.queueReadyFail
    );

    opvp.options.audio.soundeffect.player.queueReadyFailSample.clicked:connect(
        opvp_queue_ready_fail_sound_effect_sample
    );
end

opvp.OnAddonLoad:register(opvp_queue_ready_fail_sound_effect_ctor);
