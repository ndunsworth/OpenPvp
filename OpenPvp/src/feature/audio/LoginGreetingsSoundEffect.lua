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

local opvp_login_greetings_sound_effect;

opvp.private.LoginGreetingsSoundEffect = opvp.CreateClass(opvp.private.SoundEffect);

function opvp.private.LoginGreetingsSoundEffect:init()
    opvp.private.SoundEffect.init(self, opvp.options.audio.soundeffect.player.login);
end

function opvp.private.LoginGreetingsSoundEffect:greet()
    opvp.Timer:singleShot(
        3,
        function()
            opvp.effect.loginGreetings(
                opvp.player.race(),
                opvp.player.sex()
            )
        end
    );
end

function opvp.private.LoginGreetingsSoundEffect:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.LoginGreetingsSoundEffect:_onFeatureActivated()
    if opvp.system.isLogin() == true then
        opvp.OnLoadingScreenEnd:connect(self, self.greet);
    end

    opvp.private.SoundEffect._onFeatureActivated(self)
end

function opvp.private.LoginGreetingsSoundEffect:_onFeatureDeactivated()
    opvp.private.SoundEffect._onFeatureDeactivated(self)
end

function opvp.effect.loginGreetings(race, sex)
    local sound = opvp.effect.loginGreetingsSound(race);

    sound:play(sex, opvp.SoundChannel.SFX, true);
end

function opvp.effect.loginGreetingsSound(race)
    return opvp.Emote.HELLO:sound(race);
end

local function opvp_login_greetings_sound_sample(button, state)
    if state == false then
        opvp.effect.loginGreetings(
            opvp.player.race(),
            opvp.player.sex()
        );
    end
end

local function opvp_login_greetings_sound_effect_ctor()
    opvp_login_greetings_sound_effect = opvp.private.LoginGreetingsSoundEffect();

    opvp.options.audio.soundeffect.player.loginSample.clicked:connect(
        opvp_login_greetings_sound_sample
    );
end

opvp.OnAddonLoad:register(opvp_login_greetings_sound_effect_ctor);
