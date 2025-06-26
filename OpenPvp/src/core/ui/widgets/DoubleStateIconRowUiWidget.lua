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
    self.updated      = opvp.Signal("opvp.DoubleStateIconRowUiWidget.updated");
end

function opvp.DoubleStateIconRowUiWidget:update()
    local info = C_UIWidgetManager.GetDoubleStateIconRowVisualizationInfo(
        self._widget_id
    );

    if info ~= nil then
        self:_onWidgetUpdate(info);
    end
end

function opvp.DoubleStateIconRowUiWidget:widgetType()
    return opvp.UiWidgetType.DOUBLE_STATE_ICON_ROW;
end

function opvp.DoubleStateIconRowUiWidget:_onWidgetUpdate(widgetInfo)
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

    self._left_state = left_state;
    self._right_state = right_state;

    self.updated:emit();
end
