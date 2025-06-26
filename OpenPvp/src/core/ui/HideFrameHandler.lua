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

local opvp_hidden_parent_frame = CreateFrame(
    "Frame",
    "OpenPvpHideFrameHandlerParent",
    UIParent,
    "SecureFrameTemplate"
);

opvp_hidden_parent_frame:Hide();

opvp.HideFrameHandler = opvp.CreateClass();

opvp.HideFrameHandler.ALPHA        = 1;
opvp.HideFrameHandler.STATE_DRIVER = 2;
opvp.HideFrameHandler.VISIBILITY   = 3;
opvp.HideFrameHandler.PARENT       = 4;

function opvp.HideFrameHandler:init(frame, method)
    assert(frame ~= nil);

    self._frame            = frame;
    self._mouse_state      = false;
    self._restore_parent   = nil;
    self._method           = method;
    self._enabled          = false;
    self._active           = false;
    self._lock_wait        = 0;
    self._activation_state = 0;
    self._combat_lock      = false;
    self._edit_mode_toggle = true;

    self.changed = opvp.Signal("opvp.HideFrameHandler.changed");
end

function opvp.HideFrameHandler:inCombatLockdown()
    return (
        self:isEditableDuringCombat() == false and
        InCombatLockdown() == true
    );
end

function opvp.HideFrameHandler:isActive()
    return self._active;
end

function opvp.HideFrameHandler:isActivating()
    return self._activation_state == 1;
end

function opvp.HideFrameHandler:isCombatLockdownEnabled()
    return self._combat_lock;
end

function opvp.HideFrameHandler:isDeactivating()
    return self._activation_state == -1;
end

function opvp.HideFrameHandler:isEditableDuringCombat()
    return self._combat_lock == false;
end

function opvp.HideFrameHandler:isEnabled()
    return self._enabled;
end

function opvp.HideFrameHandler:setCombatLockdownEnabled(state)
    self._combat_lock = opvp.bool_else(state, self._combat_lock);
end

function opvp.HideFrameHandler:setEditModeToggle(state)
    state = opvp.bool_else(state, self._edit_mode_toggle);

    if state == self._edit_mode_toggle then
        return;
    end

    self._edit_mode_toggle = state;

    if opvp.layout.isEditing() == true then
        if state == true then
            self:_setActive(false);
        else
            self:_setActive(true);
        end
    end
end

function opvp.HideFrameHandler:setEnabled(state)
    state = opvp.bool_else(state, self._enabled);

    if state == self._enabled then
        return;
    end

    if state == true then
        self._enabled = true;

        self:_setActive(true);

        opvp.layout.beginEditMode:connect(self, self._onEditModeBegin);
        opvp.layout.endEditMode:connect(self, self._onEditModeEnd);
    else
        self:_setActive(false);

        self._enabled = false;

        opvp.layout.beginEditMode:disconnect(self, self._onEditModeBegin);
        opvp.layout.endEditMode:disconnect(self, self._onEditModeEnd);
    end
end

function opvp.HideFrameHandler:toggle()
    self:setEnabled(not self._enabled);
end

function opvp.HideFrameHandler:_lockdownActivateClear()
    if self._lock_wait == 1 then
        opvp.OnCombatExit:unregister(self, self._lockdownActivateTry);

        self._lock_wait = 0;
    end
end

function opvp.HideFrameHandler:_lockdownActivateTry()
    if self._lock_wait ~= 1 then
        return;
    end

    self._lock_wait = 0;

    self:_setActive(true);
end

function opvp.HideFrameHandler:_lockdownDeactivateClear()
    if self._lock_wait == -1 then
        opvp.OnCombatExit:unregister(self, self._lockdownDeactivateTry);

        self._lock_wait = 0;
    end
end

function opvp.HideFrameHandler:_lockdownDeactivateTry()
    if self._lock_wait ~= -1 then
        return;
    end

    self._lock_wait = 0;

    if self._active == true then
        self:_setActive(false);
    end
end

function opvp.HideFrameHandler:_onActivated()
    if self._method == opvp.HideFrameHandler.ALPHA then
        self._frame:SetAlpha(0);

        self._mouse_state = self._frame:IsMouseEnabled();

        if self._mouse_state == true then
            self._frame:EnableMouse(false);
        end
    elseif self._method == opvp.HideFrameHandler.STATE_DRIVER then
        RegisterAttributeDriver(self._frame, "state-visibility", "hide;");
    elseif self._method == opvp.HideFrameHandler.VISIBILITY then
        self._frame:Hide();
    else
        self._restore_parent = self._frame:GetParent();

        securecallfunction(
            self._frame.SetParent,
            self._frame,
            opvp_hidden_parent_frame
        );
    end

    self.changed:emit(false);
end

function opvp.HideFrameHandler:_onDeactivated()
    if self._method == opvp.HideFrameHandler.ALPHA then
        self._frame:SetAlpha(1);

        if self._mouse_state == true then
            self._frame:EnableMouse(true);

            self._mouse_state = false;
        end
    elseif self._method == opvp.HideFrameHandler.STATE_DRIVER then
        UnregisterStateDriver(self._frame, "state-visibility");
    elseif self._method == opvp.HideFrameHandler.VISIBILITY then
        self._frame:Show();
    else
        securecallfunction(
            self._frame.SetParent,
            self._frame,
            self._restore_parent
        );

        self._restore_parent = nil;
    end

    self.changed:emit(true);
end

function opvp.HideFrameHandler:_onEditModeBegin()
    if self._edit_mode_toggle == true then
        self:_setActive(false);
    end
end

function opvp.HideFrameHandler:_onEditModeEnd()
    if self._edit_mode_toggle == true then
        self:_setActive(true);
    end
end

function opvp.HideFrameHandler:_setActive(state)
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

            self._activation_state = 1;

            self:_onActivated();
        else
            self:_lockdownActivateClear();

            self._activation_state = -1;

            self:_onDeactivated();
        end

        self._active           = state;
        self._lock_wait        = 0;
        self._activation_state = 0;
    end
end
