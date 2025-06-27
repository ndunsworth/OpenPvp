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

local opvp_uiwidget_server_singleton;

opvp.UiWidgetServer = opvp.CreateClass(opvp.Object);

function opvp.UiWidgetServer:instance()
    return opvp_uiwidget_server_singleton;
end

function opvp.UiWidgetServer:__del__()
    for k, widgets in pairs(self._widgets) do
        for n=1, widgets:size() do
            widgets:item(n):_onDisconnected();
        end
    end
end

function opvp.UiWidgetServer:init()
    opvp.Object.init(self);

    self._widgets = {};

    opvp.event.UPDATE_UI_WIDGET:connect(self, self._onUpdateWidget);
end

function opvp.UiWidgetServer:_onUpdateWidget(info)
    local widgets = self._widgets[info.widgetID];

    if widgets == nil then
        return;
    end

    for n=1, widgets:size() do
        widgets:item(n):update();
    end
end

function opvp.UiWidgetServer:_register(widget)
    local widget_id = widget:widgetId();

    local widgets = self._widgets[widget_id];

    if widgets == nil then
        widgets = opvp.List();

        widgets:append(widget);

        self._widgets[widget_id] = widgets;
    else
        widgets:append(widget);
    end
end

function opvp.UiWidgetServer:_unregister(widget)
    local widget_id = widget:widgetId();

    local widgets = self._widgets[widget_id];

    if widgets == nil then
        return;
    end

    widgets:removeItem(widget);
end

local function opvp_uiwidget_server_singleton_ctor()
    opvp_uiwidget_server_singleton = opvp.UiWidgetServer();

    opvp.printDebug("UiWidgetServer - Initialized");
end

opvp.OnAddonLoad:register(opvp_uiwidget_server_singleton_ctor);
