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

opvp.ArenaMatch = opvp.CreateClass(opvp.GenericMatch);

function opvp.ArenaMatch:init(queue, description)
    opvp.GenericMatch.init(self, queue, description);

    self._enemy_provider = opvp.ArenaPartyMemberProvider();

    self._enemy_provider:_setTeamSize(description:teamSize());
end

function opvp.ArenaMatch:_onMatchRoundWarmup()
    --~ self._test_timer = opvp.Timer(5);

    --~ self._test_timer:setTriggerLimit(10);

    --~ local test_func = function()
        --~ local widget_ids = {
            --~ C_UIWidgetManager.GetTopCenterWidgetSetID(),
            --~ C_UIWidgetManager.GetPowerBarWidgetSetID(),
            --~ C_UIWidgetManager.GetObjectiveTrackerWidgetSetID(),
            --~ C_UIWidgetManager.GetBelowMinimapWidgetSetID()
        --~ };

        --~ for n=1, #widget_ids do
            --~ local widget_set = widget_ids[n];
            --~ local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(widget_set);

            --~ for _, w in pairs(widgets) do
                --~ print(widget_set, w.widgetType, w.widgetID);

                --~ if w.widgetType == 0 then
                    --~ local widget_info = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(w.widgetID);

                    --~ if widget_info ~= nil then
                        --~ print(widget_info.text);
                    --~ end
                --~ elseif w.widgetType == 2 then
                    --~ local widget_info = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(w.widgetID);

                    --~ if widget_info ~= nil then
                        --~ print(widget_info.text, widget_info.barValue);

                        --~ DevTools_Dump(widget_info.partitionValues)
                    --~ end
                --~ elseif w.widgetType == 3 then
                    --~ local widget_info = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(w.widgetID);

                    --~ if widget_info ~= nil then
                        --~ print(widget_info.text, widget_info.leftBarValue, widget_info.rightBarValue);
                    --~ end
                --~ elseif w.widgetType == 8 then
                    --~ local widget_info = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(w.widgetID);

                    --~ if widget_info ~= nil then
                        --~ print(widget_info.text, widget_info.shownState, widget_info.enabledState);
                    --~ end
                --~ end
            --~ end
        --~ end
    --~ end

    --~ self._test_timer.timeout:connect(test_func);

    --~ if self:isTest() == false then
        --~ self._test_timer:start();
    --~ end

    opvp.GenericMatch._onMatchRoundWarmup(self);
end
