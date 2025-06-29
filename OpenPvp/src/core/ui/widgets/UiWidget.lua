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

opvp.UiWidgetType = {
    DOUBLE_STATE_ICON_ROW = Enum.UIWidgetVisualizationType.DoubleStateIconRow,
    DOUBLE_STATUS_BAR     = Enum.UIWidgetVisualizationType.DoubleStatusBar,
    FILL_UP_FRAMES        = Enum.UIWidgetVisualizationType.FillUpFrames,
    ICON_AND_TEXT         = Enum.UIWidgetVisualizationType.IconAndText,
    STATUS_BAR            = Enum.UIWidgetVisualizationType.StatusBar
};

opvp.UiWidget = opvp.CreateClass(opvp.Object);

function opvp.UiWidget:createFromCfg(cfg)
    if cfg.widget_type == Enum.UIWidgetVisualizationType.DoubleStateIconRow then
        return opvp.DoubleStateIconRowUiWidget(cfg.widget_set, cfg.widget_id, cfg.name);
    elseif cfg.widget_type == Enum.UIWidgetVisualizationType.DoubleStatusBar then
        return opvp.DoubleStatusBarUiWidget(cfg.widget_set, cfg.widget_id, cfg.name);
    elseif cfg.widget_type == Enum.UIWidgetVisualizationType.IconAndText then
        return opvp.IconAndTextUiWidget(cfg.widget_set, cfg.widget_id, cfg.name);
    elseif cfg.widget_type == Enum.UIWidgetVisualizationType.StatusBar then
        return opvp.StatusBarUiWidget(cfg.widget_set, cfg.widget_id, cfg.name);
    end

    return nil;
end

function opvp.UiWidget:__del__()
    self:disconnect();
end

function opvp.UiWidget:init(widgetSet, widgetId, name)
    if name == nil then
        name = "";
    end

    self._widget_set = widgetSet;
    self._widget_id  = widgetId;
    self._name       = name;
    self._connected  = false;
end

function opvp.UiWidget:connect()
    if self._connected == true then
        return;
    end

    opvp.UiWidgetServer:instance():_register(self);

    self:_onConnected();

    self:update();
end

function opvp.UiWidget:isConnected()
    return self._connected;
end

function opvp.UiWidget:disconnect()
    if self._connected == false then
        return;
    end

    opvp.UiWidgetServer:instance():_unregister(self);

    self:_onDisconnected();
end

function opvp.UiWidget:name()
    return self._name;
end

function opvp.UiWidget:setWidgetId(widgetId)
    self._widget_id  = widgetId;
end

function opvp.UiWidget:setWidgetSet(widgetSet)
    self._widget_set = widgetSet;
end

function opvp.UiWidget:update()

end

function opvp.UiWidget:widgetId()
    return self._widget_id;
end

function opvp.UiWidget:widgetSet()
    return self._widget_set;
end

function opvp.UiWidget:_onConnected()
    self._connected = true;
end

function opvp.UiWidget:_onDisconnected()
    self._connected = false;
end

function opvp.UiWidget:_onWidgetUpdate(info)

end
