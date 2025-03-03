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

local _, OpenPvpPlugin = ...
local opvpplugin = OpenPvpPlugin;

local opvp = _G.OpenPvp;

local opvp_weakaura_timer_singleton;

opvpplugin.WeakAuraTimer = opvp.CreateClass(opvp.Timer);

function opvpplugin.WeakAuraTimer:init(event)
    opvp.Timer.init(self);

    self._refcount = 0;
    self._event    = event;

    self:setInterval(1);
end

function opvpplugin.WeakAuraTimer:deref()
    self._refcount = max(0, self._refcount - 1);

    if self._refcount == 0 then
        self:stop();
    end
end

function opvpplugin.WeakAuraTimer:ref()
    self._refcount = self._refcount + 1;

    if self._refcount == 1 then
        self:start();
    end
end

function opvpplugin.WeakAuraTimer:triggered()
    self._refcount = 1;

    opvpplugin.weakAuraEvent(self._event);

    if self._refcount == 1 then
        self:stop();

        self._refcount = 0;
    end
end

function opvpplugin.timerRef()
    opvp_weakaura_timer_singleton:ref();
end

function opvpplugin.timerDeref()
    opvp_weakaura_timer_singleton:deref();
end

local function opvp_weakaura_init()
    opvp_weakaura_timer_singleton = opvpplugin.WeakAuraTimer(opvpplugin.OPVP_TIMER_UPDATE_WA_EVENT);
end

opvpplugin.OnAddonLoad:register(opvp_weakaura_init);
