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

opvp.private.LogoutGoodbySoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.LogoutGoodbySoundEffect:init()
    opvp.private.SoundEffect.init(self, opvp.options.audio.soundeffect.player.logout);

    self._timer = opvp.Timer(17);

    self._timer.timeout:connect(self, self.greet);
end

function opvp.private.LogoutGoodbySoundEffect:greet()
    opvp.effect.logoutGoodbye(
        opvp.player.race(),
        opvp.player.sex()
    )
end

function opvp.private.LogoutGoodbySoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.LogoutGoodbySoundEffect:_onFeatureActivated()
    opvp.event.PLAYER_CAMPING:connect(self, self._onLogoutBegin);
    opvp.event.LOGOUT_CANCEL:connect(self, self._onLogoutCancel);

    opvp.private.SoundEffect._onFeatureActivated(self)
end

function opvp.private.LogoutGoodbySoundEffect:_onFeatureDeactivated()
    opvp.event.PLAYER_CAMPING:disconnect(self, self._onLogoutBegin);
    opvp.event.LOGOUT_CANCEL:disconnect(self, self._onLogoutCancel);

    opvp.private.SoundEffect._onFeatureDeactivated(self)
end


function opvp.private.LogoutGoodbySoundEffect:_onLogoutBegin()
    self._timer:start();
end

function opvp.private.LogoutGoodbySoundEffect:_onLogoutCancel()
    self._timer:stop();
end

function opvp.effect.logoutGoodbye(race, sex)
    local sound = opvp.effect.logoutGoodbyeSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.logoutGoodbyeSound(race)
    return opvp.Emote.GOODBYE:sound(race);
end

local function opvp_logout_goodbye_sound_sample(button, state)
    if state == false then
        opvp.effect.logoutGoodbye(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

local opvp_logout_goodbye_sound_effect;

local function opvp_logout_goodbye_sound_effect_ctor()
    opvp_logout_goodbye_sound_effect = opvp.private.LogoutGoodbySoundEffect();

    opvp.options.audio.soundeffect.player.logoutSample.clicked:connect(
        opvp_logout_goodbye_sound_sample
    );
end

opvp.OnAddonLoad:register(opvp_logout_goodbye_sound_effect_ctor);
