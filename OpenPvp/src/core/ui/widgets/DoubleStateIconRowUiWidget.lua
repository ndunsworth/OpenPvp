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

opvp.DoubleStateIconRowUiWidget = opvp.CreateClass(opvp.UiWidget);

function opvp.DoubleStateIconRowUiWidget:init(widgetSet, widgetId, name)
    opvp.UiWidget.init(self, widgetSet, widgetId, name);

    self._left_state  = 0;
    self._right_state = 0;

    self.iconStateChanged = opvp.Signal("opvp.DoubleStateIconRowUiWidget.iconStateChanged");
end

function opvp.DoubleStateIconRowUiWidget:widgetId()
    return self._widget_id;
end

function opvp.DoubleStateIconRowUiWidget:widgetSet()
    return self._widget_set;
end

function opvp.DoubleStateIconRowUiWidget:_initialize()
    local widget_info = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(
        self._widget_id
    );

    self._left_state  = 0;
    self._right_state = 0;

    for n=1, #widget_info.leftIcons do
        if widget_info.leftIcons[n].iconState == 1 then
            self._left_state = bit.bor(
                self._left_state,
                bit.lshift(1, n - 1)
            );
        end
    end

    for n=1, #widget_info.rightIcons do
        if widget_info.rightIcons[n].iconState == 1 then
            self._right_state = bit.bor(
                self._right_state,
                bit.lshift(1, n - 1)
            );
        end
    end

    opvp.event.UPDATE_UI_WIDGET:connect(
        self,
        self._onUiWidgetUpdate
    );
end

function opvp.DoubleStateIconRowUiWidget:_shutdown()
    opvp.event.UPDATE_UI_WIDGET:disconnect(
        self,
        self._onUiWidgetUpdate
    );
end

function opvp.DoubleStateIconRowUiWidget:_onUiWidgetUpdate(widgetInfo)
    if (
        widgetInfo.widgetSetID ~= self._widget_set or
        widgetInfo.widgetID ~= self._widget_id
    ) then
        return;
    end

    widgetInfo = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(
        self._widget_id
    );

    local left_state, right_state;

    for n=1, #widgetInfo.leftIcons do
        if widgetInfo.leftIcons[n].iconState == 1 then
            left_state = bit.bor(
                left_state,
                bit.lshift(1, n - 1)
            );
        end
    end

    for n=1, #widgetInfo.rightIcons do
        if widgetInfo.rightIcons[n].iconState == 1 then
            right_state = bit.bor(
                right_state,
                bit.lshift(1, n - 1)
            );
        end
    end

    if self._left_state ~= left_state then
        self._left_state = left_state;

        if self._right_state ~= right_state then
            self._right_state = right_state;

            self.iconStateChanged:emit(1, self._left_state);
            self.iconStateChanged:emit(2, self._right_state);
        else
            self.iconStateChanged:emit(1, self._left_state);
        end
    elseif self._right_state ~= right_state then
        self._right_state = right_state;

        self.iconStateChanged:emit(2, self._right_state);
    end
end
