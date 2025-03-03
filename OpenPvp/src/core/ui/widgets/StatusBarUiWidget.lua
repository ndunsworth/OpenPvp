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

opvp.StatusBarUiWidget = opvp.CreateClass(opvp.UiWidget);

function opvp.StatusBarUiWidget:init(widgetSet, widgetId, name)
    opvp.UiWidget.init(self, widgetSet, widgetId, name);

    self._value_max  = 1;
    self._value_min  = 0;
    self._value      = 0;

    self.valueChanged = opvp.Signal("opvp.StatusBarUiWidget.valueChanged");
end

function opvp.StatusBarUiWidget:maximumValue()
    return self._value_max;
end

function opvp.StatusBarUiWidget:minimumValue()
    return self._value_min;
end

function opvp.StatusBarUiWidget:value()
    return self._value;
end

function opvp.StatusBarUiWidget:_initialize()
    local widget_info = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(
        self._widget_id
    );

    self._value_max  = widget_info.barMin;
    self._value_min  = widget_info.barMax;
    self._value      = widget_info.barValue;

    opvp.event.UPDATE_UI_WIDGET:connect(
        self,
        self._onUiWidgetUpdate
    );
end

function opvp.StatusBarUiWidget:_shutdown()
    opvp.event.UPDATE_UI_WIDGET:disconnect(
        self,
        self._onUiWidgetUpdate
    );
end

function opvp.StatusBarUiWidget:_onUiWidgetUpdate(widgetInfo)
    if (
        widgetInfo.widgetSetID ~= self._widget_set or
        widgetInfo.widgetID ~= self._widget_id
    ) then
        return;
    end

    widgetInfo = C_UIWidgetManager.StatusBarWidgetVisualizationInfo(
        self._widget_id
    );

    if widgetInfo.barValue ~= self._value then
        self._value = widgetInfo.barValue;

        self.valueChanged.emit(self._value);
    end
end
