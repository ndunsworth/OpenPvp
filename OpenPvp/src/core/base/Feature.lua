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

opvp.Feature = opvp.CreateClass();

function opvp.Feature:init()
    self._active    = false;
    self._lock_wait = 0;
    self._enabled   = false;

    opvp.event.PLAYER_ENTERING_WORLD_LOGIN:connect(self, self._onLogin);
    opvp.event.PLAYER_ENTERING_WORLD_RELOAD:connect(self, self._onReload);
    opvp.OnLogout:connect(self, self._onLogout);
end

function opvp.Feature:broadcast()
    return false;
end

function opvp.Feature:canActivate()
    return true;
end

function opvp.Feature:inCombatLockdown()
    return false;
end

function opvp.Feature:isActive()
    return self._active;
end

function opvp.Feature:isEditableDuringCombat()
    return true;
end

function opvp.Feature:isFeatureEnabled()
    return false;
end

function opvp.Feature:name()
    return "";
end

function opvp.Feature:onLogoutDeactivate()
    return false;
end

function opvp.Feature:_onFeatureActivated()
    assert(self._active == false);

    if self:onLogoutDeactivate() == true then
        opvp.OnLogout:connect(
            self,
            self._onLogoutDeactivate
        );
    end

    opvp.printDebug(
        opvp.strs.FEATURE_ACTIVATED,
        self:name()
    );
end

function opvp.Feature:_onFeatureDeactivated()
    assert(self._active == true);

    if self:onLogoutDeactivate() == true then
        opvp.OnLogout:disconnect(
            self,
            self._onLogoutDeactivate
        );
    end

    opvp.printDebug(
        opvp.strs.FEATURE_DEACTIVATED,
        self:name()
    );
end

function opvp.Feature:_onFeatureDisabled()
    assert(self._enabled == true);

    self:_lockdownActivateClear();

    self:_setActive(false);

    opvp.printDebug(
        opvp.strs.FEATURE_DISABLED,
        self:name()
    );

    self._enabled = false;
end

function opvp.Feature:_onFeatureEnabled()
    assert(self._enabled == false);

    self._enabled = true;

    self:_lockdownDeactivateClear();

    opvp.printDebug(
        opvp.strs.FEATURE_ENABLED,
        self:name()
    );

    if self:canActivate() == true then
        self:_setActive(true);
    end
end

function opvp.Feature:_lockdownActivateClear()
    if self._lock_wait == 1 then
        opvp.OnCombatExit:unregister(self, self._lockdownActivateTry);

        self._lock_wait = 0;
    end
end

function opvp.Feature:_lockdownActivateTry()
    if self._lock_wait ~= 1 then
        return;
    end

    self._lock_wait = 0;

    if (
        self:isFeatureEnabled() == true and
        self:canActivate() == true
    ) then
        self:_setActive(true);
    end
end

function opvp.Feature:_lockdownDeactivateClear()
    if self._lock_wait == -1 then
        opvp.OnCombatExit:unregister(self, self._lockdownDeactivateTry);

        self._lock_wait = 0;
    end
end

function opvp.Feature:_lockdownDeactivateTry()
    if self._lock_wait ~= -1 then
        return;
    end

    self._lock_wait = 0;

    if self:isActive() == true then
        self:_setActive(false);
    end
end

function opvp.Feature:_onLogin()
    if self:isFeatureEnabled() == true and self._enabled == false then
        self:_onFeatureEnabled();
    end
end

function opvp.Feature:_onLogout()

end

function opvp.Feature:_onLogoutDeactivate()
    self:_setActive(false);
end

function opvp.Feature:_onReload()
    self:_onLogin();
end

function opvp.Feature:_setActive(state)
    if state == self._active then
        if state == true then
            self:_lockdownDeactivateClear();
        else
            self:_lockdownActivateClear();
        end

        return;
    end

    if self:inCombatLockdown() == true then
        if state == true then
            if self._lock_wait ~= 1 then
                self:_lockdownDeactivateClear();

                self._lock_wait = 1;

                opvp.OnCombatExit:register(self, self._lockdownActivateTry);
            end
        else
            if self._lock_wait ~= -1 then
                self:_lockdownActivateClear();

                self._lock_wait = -1;

                opvp.OnCombatExit:register(self, self._lockdownDeactivateTry);
            end
        end
    else
        if state == true then
            self:_lockdownDeactivateClear();

            self:_onFeatureActivated();
        else
            self:_lockdownActivateClear();

            self:_onFeatureDeactivated();
        end

        self._active    = state;
        self._lock_wait = 0;
    end
end
