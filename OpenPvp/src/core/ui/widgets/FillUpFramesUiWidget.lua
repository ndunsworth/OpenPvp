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

opvp.FillUpFramesUiWidget = opvp.CreateClass(opvp.UiWidget);

function opvp.FillUpFramesUiWidget:init(widgetSet, widgetId, name)
    opvp.UiWidget.init(self, widgetSet, widgetId, name);

    self._state        = Enum.IconAndTextWidgetState.Hidden;
    self._value        = "";
    self._full_frames  = 0;
    self._fill_max     = 0;
    self._fill_min     = 0;
    self._fill_val     = 0;
    self._total_frames = 0;

    self.updated     = opvp.Signal("opvp.FillUpFramesUiWidget.updated");
end

function opvp.FillUpFramesUiWidget:fullFrames()
    return self._full_frames;
end

function opvp.FillUpFramesUiWidget:maximumFill()
    return self._fill_max;
end

function opvp.FillUpFramesUiWidget:minimumFill()
    return self._fill_min;
end

function opvp.FillUpFramesUiWidget:totalFrames()
    return self._total_frames;
end

function opvp.FillUpFramesUiWidget:fillValue()
    return self._fill_val;
end

function opvp.FillUpFramesUiWidget:totalValue()
    return (self._full_frames * self._fill_max) + self._fill_val;
end

function opvp.FillUpFramesUiWidget:update()
    local info = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(
        self._widget_id
    );

    if info ~= nil then
        self:_onWidgetUpdate(info);
    end
end

function opvp.FillUpFramesUiWidget:widgetType()
    return opvp.UiWidgetType.FILL_UP_FRAMES;
end

function opvp.FillUpFramesUiWidget:_onWidgetUpdate(widgetInfo)
    self._full_frames  = widgetInfo.numFullFrames;
    self._fill_max     = widgetInfo.fillMax;
    self._fill_min     = widgetInfo.fillMin;
    self._fill_val     = widgetInfo.fillValue;
    self._total_frames = widgetInfo.numTotalFrames;

    self.updated:emit();
end
