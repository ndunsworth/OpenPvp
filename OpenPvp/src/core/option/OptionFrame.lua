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

opvp.OptionDatabaseFrame = opvp.CreateClass();

function opvp.OptionDatabaseFrame:init(db)
    self._db           = db;
    self._cur_category = nil;
    self._root_frame   = nil;
    self._null_frame   = nil;
end

function opvp.OptionDatabaseFrame:show()
    self._db:root():show();
end

function opvp.OptionDatabaseFrame:register()
    if self._null_frame ~= nil then
        return;
    end

    self._null_frame = CreateFrame("Frame", self._db:name() .. "Options");

    --~ self._null_frame.name = self._db:name();
    --~ self._null_frame.category = Settings.RegisterCanvasLayoutCategory(
        --~ self._null_frame,
        --~ self._db:name()
    --~ );

    --~ Settings.RegisterAddOnCategory(self._null_frame.category);

    --~ self._cur_category = self._null_frame.category;

    local root = self._db:root();

    self._root_frame = self:createOptionCategory("Root", root, nil);

    --~ self:createOptionFrames(root:key(), root:options(), self._null_frame);
end

function opvp.OptionDatabaseFrame:createOptionFrames(path, options, parent)
    local last_line_widget;
    local last_widget;
    local height = 0;

    for n=1, #options do
        local option = options[n];

        if option:isHidden() == false then
            local frame;

            if opvp.IsInstance(option, opvp.OptionCategory) == true then
                local cat_parent;

                if option:categoryType() == opvp.OptionCategory.GROUP_CATEGORY then
                    cat_parent = parent;
                else
                    cat_parent = self._null_frame;
                end

                frame = self:createOptionCategory(path, option, cat_parent);
            else
                frame = option:createWidget(
                    path .. "_" .. option:key(),
                    parent
                );
            end

            if last_line_widget ~= nil then
                if option:startLine() == true then
                    frame:SetPoint(
                        "TOPLEFT",
                        last_line_widget,
                        "BOTTOMLEFT",
                        0,
                        -5
                    );

                    height = height + frame:GetHeight() + 5;

                    last_line_widget = frame;
                    last_widget = last_line_widget;
                else
                    frame:SetPoint(
                        "LEFT",
                        last_widget,
                        "RIGHT",
                        15,
                        0
                    );

                    frame:SetPoint(
                        "CENTER",
                        last_widget,
                        "CENTER"
                    );

                    --~ frame:SetPoint(
                        --~ "BOTTOM",
                        --~ last_widget,
                        --~ "BOTTOM"
                    --~ );

                    last_widget = frame;
                end
            else
                frame:SetPoint(
                    "TOPLEFT",
                    parent,
                    "TOPLEFT",
                    0,
                    -5
                );

                height = frame:GetHeight();

                last_line_widget = frame;
                last_widget = frame;
            end
        end
    end

    return height;

    --~ if last_widget ~= nil then
        --~ parent:SetHeight(200);
    --~ end
end

function opvp.OptionDatabaseFrame:createOptionCategory(path, option, parent)
    local prev_category = self._cur_category;

    path = path .. "_" .. option:key();

    local header_text = option:name();
    local header_desc = option:description();

    if header_desc == header_text then
        header_desc = "";
    end

    local frame = CreateFrame("Frame", path .. "_Root", parent);
    local container = CreateFrame("Frame", path .. "_Container", frame);
    local profile_enum = nil;
    local scroll_area = nil;

    local cat_type = option:categoryType();
    local container_offset_y = -5;

    if cat_type == opvp.OptionCategory.ROOT_CATEGORY then
        frame.category = Settings.RegisterCanvasLayoutCategory(
            frame,
            option:name()
        );

        frame.name = option:name();

        Settings.RegisterAddOnCategory(frame.category);

        self._cur_category = frame.category;

        header_text = string.format(
            "%s - v%s",
            self._db:name(),
            self._db:version()
        );

        profile_enum = self._db:profileOption():createWidget(path .. "_Profile", frame)
    elseif cat_type == opvp.OptionCategory.CHILD_CATEGORY then
        frame.category = Settings.RegisterCanvasLayoutSubcategory(
            self._cur_category,
            frame,
            option:name()
        );

        self._cur_category = frame.category;

        container_offset_y = -15;

        header_text = string.format(
            "%s - %s Settings",
            self._db:name(),
            header_text
        );
    end

    option:setUiCategory(self._cur_category);

    local header = self:createHeader(path, header_text, header_desc, frame);

    if parent ~= nil then
        frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 15, 0);
        frame:SetPoint("RIGHT", parent, "RIGHT", -15, 0);
    end

    if cat_type == opvp.OptionCategory.GROUP_CATEGORY then
        header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);
    else
        header:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -15);
    end

    if option:categoryType() == opvp.OptionCategory.GROUP_CATEGORY then
        container:SetPoint(
            "TOPLEFT",
            header,
            "BOTTOMLEFT",
            15,
            container_offset_y
        );

        container:SetPoint(
            "BOTTOMRIGHT",
            frame,
            "BOTTOMRIGHT"
        );
    else
        scroll_area = CreateFrame("ScrollFrame", path .. "_Container", frame, "ScrollFrameTemplate");

        --~ scroll_area.ScrollBar:SetHideIfUnscrollable(true);

        scroll_area:SetPoint(
            "TOPLEFT",
            header,
            "BOTTOMLEFT",
            15,
            -15
        );

        scroll_area:SetPoint(
            "BOTTOMRIGHT",
            frame,
            "BOTTOMRIGHT",
            -(scroll_area.ScrollBar:GetWidth() + 18),
            0
        );

        scroll_area:SetScrollChild(container);

        scroll_area:SetScript(
            "OnSizeChanged",
            function(self, width, height)
                container:SetWidth(width);
            end
        );

        container:SetPoint(
            "BOTTOMRIGHT",
            frame,
            "BOTTOMRIGHT"
        );
    end

    frame.header    = header;
    frame.container = container;
    frame.option    = option;

    option.frame = frame;

    local height = self:createOptionFrames(
        path,
        option:options(),
        container
    );

    frame.container:SetHeight(height);
    frame:SetHeight(frame.header:GetHeight() + height + 15);

    if profile_enum ~= nil then
        profile_enum:SetPoint("CENTER", frame.header, "CENTER", 0, 0);
        profile_enum:SetPoint("RIGHT", scroll_area, "RIGHT", 0, 0);
    end

    self._cur_category = prev_category;

    return frame;
end

function opvp.OptionDatabaseFrame:createHeader(path, text, description, parent)
    local frame = CreateFrame("Frame", path .. "_Header", parent);
    local txt_str = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");

    txt_str:SetTextHeight(16);

    txt_str:SetText(text);

    txt_str:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);

    local width = txt_str:GetUnboundedStringWidth();

    if description ~= "" then
        local desc_str = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");

        desc_str:SetTextHeight(10);

        desc_str:SetText(" - " .. description);

        desc_str:SetJustifyV("MIDDLE");

        desc_str:SetPoint("TOPLEFT", txt_str, "TOPRIGHT", 0, 0);
        desc_str:SetPoint("BOTTOMLEFT", txt_str, "BOTTOMRIGHT", 0, 0);

        width = width + desc_str:GetUnboundedStringWidth();
    end

    frame:SetSize(width, txt_str:GetHeight());

    return frame;
end
