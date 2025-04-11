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

opvp.private.ScreenshotMatchFeature = opvp.CreateClass(opvp.MatchOptionFeature);

function opvp.private.ScreenshotMatchFeature:init(option)
    opvp.MatchOptionFeature.init(self, option);

    self._valid_test     = opvp.MatchTestType.NONE;
    self._match_activate = opvp.MatchStatus.COMPLETE;
    self._screenshot     = false;

    PVPMatchResults:HookScript(
        "OnShow",
        function()
            self:screenshot();
        end
    );
end

function opvp.private.ScreenshotMatchFeature:isFeatureEnabled()
    return self:option():value();
end

function opvp.private.ScreenshotMatchFeature:screenshot()
    if (
        self._screenshot == true and
        opvp.match.current():surrendered() == false
    ) then
        self._screenshot = false;

        --~ We wait 2 frames to screenshot because its hit or miss if the frame
        --~ is fully filled in at 1 frame. Which is dumb as hell because
        --~ logic would say the first draw call after show would fill
        --~ everything in when the frame is IsVisible() == true.
        opvp.Timer:runNextFrame(
            function()
                opvp.Timer:runNextFrame(
                    function()
                        Screenshot();

                        opvp.printMessage(opvp.strs.MATCH_SCREENSHOT);
                    end
                );
            end
        );
    end
end

function opvp.private.ScreenshotMatchFeature:_onFeatureActivated()
    self._screenshot = true;

    opvp.MatchOptionFeature._onFeatureActivated(self);
end

function opvp.private.ScreenshotMatchFeature:_onFeatureDeactivated()
    self._screenshot = false;

    opvp.MatchOptionFeature._onFeatureDeactivated(self);
end

local opvp_screenshot_match_feature;

local function opvp_screenshot_match_feature_ctor()
    opvp_screenshot_match_feature = opvp.private.ScreenshotMatchFeature(
        opvp.options.match.general.screenshot
    );
end

opvp.OnAddonLoad:register(opvp_screenshot_match_feature_ctor);
