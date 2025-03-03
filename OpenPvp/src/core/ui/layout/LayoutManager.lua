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

opvp.LayoutManager = opvp.CreateClass();

function opvp.LayoutManager:init()
    self._layouts = opvp.List();
    self._editing = false;
    self._active  = 1;

    local preset_1 = {
        layoutName = "Modern (Preset)",
        layoutType = Enum.EditModeLayoutType.Preset,
        systems    = {}
    };

    local preset_2 = {
        layoutName = "Classic (Preset)",
        layoutType = Enum.EditModeLayoutType.Preset,
        systems    = {}
    };

    self._layouts:append(opvp.Layout(1, preset_1));
    self._layouts:append(opvp.Layout(2, preset_2));

    opvp.event.EDIT_MODE_LAYOUTS_UPDATED:connect(self, self._onLayoutsUpdated);
    opvp.event.EDITMODE_ENTER:connect(self, self._onEditModeEnter);
    opvp.event.EDITMODE_LAYOUTS_SAVED:connect(self, self._onEditModeSaved);
    opvp.event.EDITMODE_EXIT:connect(self, self._onEditModeExit);

    opvp.OnLoginReload:connect(self, self._onLoad);
end

function opvp.LayoutManager:active()
    return self._layouts:item(self._active);
end

function opvp.LayoutManager:activeIndex()
    return self._active;
end

function opvp.LayoutManager:isEditing()
    return self._editing;
end

function opvp.LayoutManager:isValidIndex(index)
    return (
        opvp.is_number(index) == true and
        math.floor(index) == index and
        index > 0 and
        index <= self._layouts:size()
    );
end

function opvp.LayoutManager:isValidName(name)
    return C_EditMode.IsValidLayoutName(name);
end

function opvp.LayoutManager:findLayout(name)
    local layout;

    for n=1, self._layouts:size() do
        layout = self._layouts:item(n);

        if layout:name() == name then
            return layout;
        end
    end

    return nil;
end

function opvp.LayoutManager:layout(index)
    return self._layouts:item(index);
end

function opvp.LayoutManager:layouts()
    return self._layouts:items();
end

function opvp.LayoutManager:size()
    return self._layouts:size();
end

function opvp.LayoutManager:_addLayout(index, layout, active)
    for n=index, self._layouts:size() do
        self._layouts:item(n):_setIndex(n + 1);
    end

    opvp.printDebug(
        "LayoutManager - Layout Added (index=%d, name=\"%s\")",
        index,
        layout:name()
    );

    self._layouts:insert(index, layout);

    if active ~= self._active then
        self._active = active;

        opvp.layout.added:emit(layout);

        opvp.printDebug(
            "LayoutManager - Layout Changed (index=%d, name=\"%s\")",
            index,
            layout:name()
        );

        opvp.layout.changed:emit(layout);
    else
        opvp.layout.added:emit(layout);
    end
end

function opvp.LayoutManager:_onEditModeEnter()
    opvp.printDebug("LayoutManager - Edit Mode (begin)");

    self._editing = true;

    opvp.layout.beginEditMode:emit();
end

function opvp.LayoutManager:_onEditModeExit()
    opvp.printDebug("LayoutManager - Edit Mode (end)");

    self._editing = false;

    opvp.layout.endEditMode:emit();
end

function opvp.LayoutManager:_onEditModeSaved()
    self:_onLayoutsUpdated(C_EditMode.GetLayouts(), true);
end

function opvp.LayoutManager:_onLayoutsUpdated(layoutInfo, reconcileLayouts)
    local layout_infos = layoutInfo.layouts;
    local layout_count = self._layouts:size() - 2;
    local layout_info;
    local layout;

    if #layout_infos ~= layout_count then
        if #layout_infos < layout_count then
            for n=3, self._layouts:size() do
                layout = self._layouts:item(n);
                layout_info = layout_infos[n - 2];

                if layout_info == nil or layout_info.layoutName ~= layout:name() then
                    self:_removeLayout(n, layout, layoutInfo.activeLayout);

                    return;
                end
            end
        else
            for n=1, #layout_infos do
                layout_info = layout_infos[n];
                layout = self:findLayout(layout_info.layoutName);

                if layout == nil then
                    layout = opvp.Layout(n + 2, layout_info);

                    self:_addLayout(n + 2, layout, layoutInfo.activeLayout);
                end
            end
        end
    else
        for n=1, #layout_infos do
            layout_info = layout_infos[n];
            layout = self._layouts:item(n + 2);

            layout:_update(layout_info);
        end

        if layoutInfo.activeLayout ~= self._active then
            self._active = layoutInfo.activeLayout;

            local active_layout = self._layouts:item(self._active);

            opvp.printDebug(
                "LayoutManager - Layout Changed (index=%d, name=\"%s\")",
                self._active,
                active_layout:name()
            );

            opvp.layout.changed:emit(active_layout);
        end
    end
end

function opvp.LayoutManager:_onLoad()
    local restore_index = opvp.private.state.ui.restore.layout:value();

    if restore_index == 0 then
        return;
    end

    opvp.private.state.ui.restore.layout:setValue(0);

    local layout = self:layout(restore_index);

    if layout ~= nil then
        layout:load();
    end
end

function opvp.LayoutManager:_removeLayout(index, layout, active)
    self._layouts:removeIndex(index);

    for n=index, self._layouts:size() do
        self._layouts:item(n):_setIndex(n - 1);
    end

    opvp.printDebug(
        "LayoutManager - Layout Deleted (index=%d, name=\"%s\")",
        index,
        layout:name()
    );

    if layout:index() == self._active then
        self._active = active;

        opvp.layout.deleted:emit(layout);

        local active_layout = self._layouts:item(self._active);

        opvp.printDebug(
            "LayoutManager - Layout Changed (index=%d, name=\"%s\")",
            active,
            active_layout:name()
        );

        opvp.layout.changed:emit(active_layout);
    else
        opvp.layout.deleted:emit(layout);
    end
end
