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
    "OpenPvpHideFrameParent",
    UIParent,
    "SecureFrameTemplate"
);

opvp_hidden_parent_frame:Hide();

opvp.HideFrameMatchFeature = opvp.CreateClass(opvp.MatchTypeOptionFeature);

opvp.HideFrameMatchFeature.ALPHA      = 1;
opvp.HideFrameMatchFeature.VISIBILITY = 2;
opvp.HideFrameMatchFeature.PARENT     = 3;

function opvp.HideFrameMatchFeature:init(option, frame, method)
    opvp.MatchTypeOptionFeature.init(self, option);

    self._match_activate   = opvp.MatchStatus.ROUND_ACTIVE;
    self._match_deactivate = opvp.MatchStatus.ROUND_WARMUP;
    self._frame            = frame;
    self._editmode_apply   = false;
    self._mouse_state      = false;
    self._restore_parent   = nil;

    self.toggled = opvp.Signal("opvp.HideFrameMatchFeature.toggled");

    assert(self._frame ~= nil);

    if method == opvp.HideFrameMatchFeature.ALPHA then
        self._method = opvp.HideFrameMatchFeature.ALPHA;
    else
        self._method = opvp.HideFrameMatchFeature.VISIBILITY;
    end
end

function opvp.HideFrameMatchFeature:isActiveMatchStatus(status)
    return (
        status == opvp.MatchStatus.ROUND_ACTIVE or
        status == opvp.MatchStatus.ROUND_COMPLETE or
        status == opvp.MatchStatus.COMPLETE
    );
end

function opvp.HideFrameMatchFeature:setEditModeExitApply(state)
    if state == self._editmode_apply then
        return;
    end

    self._editmode_apply = state;

    if self._editmode_apply == true then
        opvp.layout.beginEditMode:connect(
            self,
            self._onEditModeBegin
        );

        opvp.layout.endEditMode:connect(
            self,
            self._onEditModeEnd
        );
    else
        opvp.layout.beginEditMode:disconnect(
            self,
            self._onEditModeBegin
        );

        opvp.layout.endEditMode:disconnect(
            self,
            self._onEditModeEnd
        );
    end
end

function opvp.HideFrameMatchFeature:_onEditModeBegin()
    self:_setActive(false);
end

function opvp.HideFrameMatchFeature:_onEditModeEnd()
    self:_setActive(true);
end

function opvp.HideFrameMatchFeature:_onFeatureActivated()
    if self._method == opvp.HideFrameMatchFeature.ALPHA then
        self._frame:SetAlpha(0);

        self._enable_mouse = self._frame:IsMouseEnabled();

        if self._enable_mouse == true then
            self._frame:EnableMouse(false);
        end
    elseif self._method == opvp.HideFrameMatchFeature.VISIBILITY then
        self._frame:Hide();
    else
        self._restore_parent = self._frame:GetParent();

        securecallfunction(
            self._frame.SetParent,
            self._frame,
            opvp_hidden_parent_frame
        );
    end

    self.toggled:emit(false);

    opvp.MatchTypeOptionFeature._onFeatureActivated(self);
end

function opvp.HideFrameMatchFeature:_onFeatureDeactivated()
    if self._method == opvp.HideFrameMatchFeature.ALPHA then
        self._frame:SetAlpha(1);

        if self._enable_mouse == true then
            self._frame:EnableMouse(true);
        end
    elseif self._method == opvp.HideFrameMatchFeature.VISIBILITY then
        self._frame:Show();
    else
        securecallfunction(
            self._frame.SetParent,
            self._frame,
            self._restore_parent
        );
    end

    self.toggled:emit(true);

    opvp.MatchTypeOptionFeature._onFeatureDeactivated(self);
end
