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

opvp.DoubleStatusBarUiWidget = opvp.CreateClass(opvp.UiWidget);

function opvp.DoubleStatusBarUiWidget:init(widgetSet, widgetId, name)
    opvp.UiWidget.init(self, widgetSet, widgetId, name);

    self._value_max  = {0, 0};
    self._value_min  = {0, 0};
    self._value      = {0, 0};
    self.updated     = opvp.Signal("opvp.DoubleStatusBarUiWidget.updated");
end

function opvp.DoubleStatusBarUiWidget:maximumValue(index)
    return self._value_max[index];
end

function opvp.DoubleStatusBarUiWidget:minimumValue(index)
    return self._value_min[index];
end

function opvp.DoubleStatusBarUiWidget:update()
    local info = C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(
        self._widget_id
    );

    if info ~= nil then
        self:_onWidgetUpdate(info);
    end
end

function opvp.DoubleStatusBarUiWidget:value(index)
    return self._value[index];
end

function opvp.DoubleStatusBarUiWidget:values()
    return {self._value[1], self._value[2]};
end

function opvp.DoubleStatusBarUiWidget:widgetType()
    return opvp.UiWidgetType.DOUBLE_STATUS_BAR;
end

function opvp.DoubleStatusBarUiWidget:_onWidgetUpdate(widgetInfo)
    local mask = 0;

    self._value[1] = widgetInfo.leftBarValue;
    self._value[2] = widgetInfo.rightBarValue;

    self.updated:emit();
end
