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

local function setMoveLossOfControlNotification(state)
    LossOfControlFrame:ClearAllPoints();

    if state == true then
        LossOfControlFrame:SetPoint("TOP", ZoneTextFrame, "BOTTOM");
    else
        LossOfControlFrame:SetPoint("CENTER");
    end
end

local function testLossOfControlNotification(button, state)
    if state == true then
        return;
    end

    local data = {
        displayText   = LOSS_OF_CONTROL_DISPLAY_FEAR_MECHANIC,
        displayType   = 1,
        duration      = 6,
        iconTexture   = 132154,
        lockoutSchool = 0,
        locType       = "FEAR_MECHANIC",
        priority      = 5,
        spellID       = 5246,
        startTime     = GetTime(),
        timeRemaining = 6
    };

    LossOfControlFrame_SetUpDisplay(LossOfControlFrame, true, data);

    PlaySound(3231);
end

local function config_lossofcontrol_notification_move()
    if opvp.options.interface.frames.moveLossOfControlNotification:value() == true then
        setMoveLossOfControlNotification(true);
    end

    opvp.options.interface.frames.moveLossOfControlNotification.changed:connect(
        setMoveLossOfControlNotification
    );

    opvp.options.interface.frames.moveLossOfControlNotificationTest.clicked:connect(
        testLossOfControlNotification
    );
end

opvp.OnAddonLoad:register(config_lossofcontrol_notification_move);
