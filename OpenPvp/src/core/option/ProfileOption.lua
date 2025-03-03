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

opvp.ProfileOptionItem = opvp.CreateClass();

function opvp.ProfileOptionItem:init(name, data)
    self._name = name;
    self._data = data;
end

function opvp.ProfileOptionItem:clone(name)
    return opvp.ProfileOptionItem(name, self:data());
end

function opvp.ProfileOptionItem:data()
    return opvp.utils.deepcopy(self._data);
end

function opvp.ProfileOptionItem:name()
    return self._name;
end

function opvp.ProfileOptionItem:setData(data)
    self._data = data;
end

opvp.ProfileOption = opvp.CreateClass(opvp.Option);

function opvp.ProfileOption:init(key, name, description, version)
    opvp.Option.init(self, key .. "Profile", "Profile", "");

    self._default    = {};
    self._root       = opvp.RootOption(key, name, description, version);
    self._profiles   = opvp.List();
    self._profile    = nil;
    self._index      = 0;
    self._save_valid = false;
    self._loading    = false;
    self._create_dialog = {
        text = "Enter Profile Name",
        hasEditBox = 1,
        maxLetters = 32,
        button1 = "Create",
        button2 = "Cancel",
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        exclusive = true,
        OnAccept = function(dialog)
            if self:createProfile(
                dialog.editBox:GetText()
            ) == true then
                self:setProfileByIndex(self:size());
            end
        end,
        OnCancel = function(dialog)
        end,
        OnShow = function(dialog)
            dialog.editBox:SetText("");
            dialog.editBox:SetFocus();
        end,
        EditBoxOnEnterPressed = function(editbox)
            if self:createProfile(
                editbox:GetText()
            ) == true then
                self:setProfileByIndex(self:size());

                editbox:GetParent():Hide();
            end
        end,
        EditBoxOnEscapePressed = function(editbox)
            editbox:GetParent():Hide();
        end
    };

    self._confirm_dialog = {
        text = "",
        button1 = "Yes",
        button2 = "Cancel",
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        exclusive = true,
        OnAccept = function(dialog)
            self:deleteProfileIndex(self:index());
        end,
        OnCancel = function(dialog)
        end,
        OnShow = function(dialog)
        end,
    };

    self.changed       = opvp.Signal(key);
    self.valuesChanged = opvp.Signal(self._key .. ".valuesChanged");
end

function opvp.ProfileOption:copyProfileIndex(index, clone)
    local profile = self:profile(index);

    if profile == nil then
        return false;
    end

    if (
        opvp.is_str(clone) == false or
        clone == "" or
        self:hasProfile(clone) == true
    ) then
        return false;
    end

    self:_addProfile(profile:clone(clone));

    return true;
end

function opvp.ProfileOption:copyProfileNamed(name, clone)
    local profile = self:findProfile(name);

    if profile == nil then
        return false;
    end

    if (
        opvp.is_str(clone) == false or
        clone == "" or
        self:hasProfile(clone) == true
    ) then
        return false;
    end

    self:_addProfile(profile:clone(clone));

    return true;
end

function opvp.ProfileOption:createProfile(name)
    if (
        opvp.is_str(name) == false or
        name == ""
    ) then
        return false;
    end

    local profile;

    for n=1, self._profiles:size() do
        profile = self._profiles:item(n);

        if profile:name() == name then
            return false;
        end
    end

    profile = opvp.ProfileOptionItem(name, self:defaultData());

    self:_addProfile(profile);

    return true;
end

function opvp.ProfileOption:createWidget(name, parent)
    local init_values = function(dropdown, level, menuList)
        local info = UIDropDownMenu_CreateInfo();
        local index = dropdown.option:index();

        for n=1, dropdown.option:size() do
            info.text     = dropdown.option:profileName(n);
            info.value    = n;
            info.checked  = n == index;

            info.func = function(button, arg1, arg2, checked, mouseButton)
                UIDropDownMenu_SetSelectedValue(dropdown, button.value, button.value);

                UIDropDownMenu_SetText(dropdown, dropdown.option:profileName(button.value));

                dropdown.option:setProfileByIndex(button.value);

                button.checked = true;
            end

            UIDropDownMenu_AddButton(info)
        end
    end

    local init_size = function(dropdown, level, menuList)
        local max_width = 0;

        for n=1, dropdown.option:size() do
            UIDropDownMenu_SetText(dropdown, dropdown.option:profileName(n));

            max_width = max(max_width, dropdown.Text:GetUnboundedStringWidth());
        end

        UIDropDownMenu_SetText(dropdown, dropdown.option:profileName(dropdown.option:index()));

        UIDropDownMenu_SetWidth(
            dropdown,
            (
                max_width +
                dropdown.Button:GetWidth() +
                UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING
            )
        );
    end

    local frame = CreateFrame("Frame", name, parent);
    local label = frame:CreateFontString(name .. "_Label", "OVERLAY", "OptionsFontHighlight");
    local dropdown = CreateFrame("Frame", name .. "_Dropdown", frame, "UIDropDownMenuTemplate");
    local create_button = CreateFrame("Button", name .. "_CreateProfile", frame, "UIPanelButtonTemplate");
    local delete_button = CreateFrame("Button", name .. "_DeleteProfile", frame, "UIPanelButtonTemplate");

    create_button:SetDisabledTexture("128-RedButton-Plus-Disabled");
    create_button:SetNormalTexture("128-RedButton-Plus");
    create_button:SetPushedTexture("128-RedButton-Plus-Pressed");
    delete_button:SetDisabledTexture("128-RedButton-Delete-Disabled");
    delete_button:SetNormalTexture("128-RedButton-Delete");
    delete_button:SetPushedTexture("128-RedButton-Delete-Pressed");

    create_button:SetScript(
        "OnEnter",
        function()
            GameTooltip:SetOwner(create_button, "ANCHOR_TOPLEFT");

            GameTooltip:AddLine(opvp.strs.PROFILE_CREATE);

            GameTooltip:Show();

            if callback ~= nil then
                callback();
            end
        end
    );

    create_button:SetScript(
        "OnLeave",
        function()
            GameTooltip:Hide();
        end
    );

    delete_button:SetScript(
        "OnEnter",
        function()
            GameTooltip:SetOwner(delete_button, "ANCHOR_TOPLEFT");

            GameTooltip:AddLine(opvp.strs.PROFILE_DELETE);

            GameTooltip:Show();

            if callback ~= nil then
                callback();
            end
        end
    );

    delete_button:SetScript(
        "OnLeave",
        function()
            GameTooltip:Hide();
        end
    );

    --~ local button_width  = max(create_button:GetTextWidth() + 15, delete_button:GetTextWidth() + 15);
    --~ local button_height = max(create_button:GetTextHeight() + 12, delete_button:GetTextHeight() + 12);
    local button_width  = 24;
    local button_height = 24;

    create_button:SetWidth(button_width);
    create_button:SetHeight(button_height);

    delete_button:SetWidth(button_width);
    delete_button:SetHeight(button_height);

    delete_button:SetEnabled(self:size() > 1);

    create_button:RegisterForClicks("AnyDown", "AnyUp");
    delete_button:RegisterForClicks("AnyDown", "AnyUp");

    create_button:SetScript(
        "OnClick",
        function(frame, mouseButton, state)
            if state == false then
                StaticPopupDialogs["OPVP_OPTIONS_PROFILE"] = self._create_dialog;

                StaticPopup_Show("OPVP_OPTIONS_PROFILE");
            end
        end
    );

    delete_button:SetScript(
        "OnClick",
        function(frame, mouseButton, state)
            if state == false or self:size() == 1 then
                return;
            end

            self._confirm_dialog.text = string.format(
                "Delete Profile \"%s\"?",
                self:profileName(self:index())
            );

            StaticPopupDialogs["OPVP_OPTIONS_DELETE_PROFILE"] = self._confirm_dialog;

            StaticPopup_Show("OPVP_OPTIONS_DELETE_PROFILE");
        end
    );

    frame.label = label;
    frame.dropdown = dropdown;
    frame.create_button = create_button;
    frame.delete_button = delete_button;

    dropdown.noResize = 0;

    dropdown.option = self;

    UIDropDownMenu_Initialize(dropdown, init_values);

    UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

    init_size(dropdown);

    self.changed:connect(
        function()
            UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

            UIDropDownMenu_SetText(dropdown, self:profileName(self:index()));
        end
    );

    self.valuesChanged:connect(
        function()
            UIDropDownMenu_ClearAll(dropdown);

            UIDropDownMenu_Initialize(dropdown, init_values);

            UIDropDownMenu_SetSelectedValue(dropdown, self:index(), self:index());

            UIDropDownMenu_SetText(dropdown, self:profileName(self:index()));

            frame.delete_button:SetEnabled(self:size() > 1);

            init_size(dropdown);
        end
    );

    self:createWidgetTooltip(dropdown);

    label:SetText(self:name());

    label:SetWidth(0);

    label:SetPoint("TOPLEFT", frame);
    label:SetPoint("BOTTOMLEFT", frame);

    --~ dropdown:SetAllPoints();

    dropdown:SetPoint("LEFT", label, "RIGHT");
    dropdown:SetPoint("TOP", frame, "TOP");
    dropdown:SetPoint("BOTTOM", frame, "BOTTOM");

    create_button:SetPoint("CENTER", dropdown, "CENTER");
    create_button:SetPoint("LEFT", dropdown, "RIGHT", -10, 2);
    delete_button:SetPoint("CENTER", create_button, "CENTER");
    delete_button:SetPoint("LEFT", create_button, "RIGHT", 0, 0);

    frame:SetSize(
        (
            label:GetWidth() +
            create_button:GetWidth() +
            delete_button:GetWidth() +
            15 +
            dropdown:GetWidth() -
            UIDROPDOWNMENU_DEFAULT_WIDTH_PADDING * 0.75
        ),
        max(label:GetHeight(), dropdown:GetHeight())
    );

    self._frame = frame;

    return frame;
end

function opvp.ProfileOption:defaultData()
    return opvp.utils.deepcopy(self._default);
end

function opvp.ProfileOption:deleteProfileIndex(index)
    if self:inCombatLockdown() == true then
        return;
    end

    if (
        self._profiles:size() == 1 or
        opvp.is_number(index) ~= true or
        index < 0 or
        index > self._profiles:size()
    ) then
        return;
    end

    if index == self._index then
        self:_removeProfile(self._profile, index);
    else
        self:_removeProfile(self._profiles:item(index), index);
    end
end

function opvp.ProfileOption:deleteProfileNamed(name)
    if self:inCombatLockdown() == true then
        return;
    end

    local profile = self:findProfile(name);

    if profile == nil or self._profiles:size() == 1 then
        return;
    end

    self:_removeProfile(profile, self._profiles:index(profile));
end

function opvp.ProfileOption:findProfile(name)
    if (
        opvp.is_str(name) == false or
        name == ""
    ) then
        return nil;
    end

    local profile;

    for n=1, self._profiles:size() do
        profile = self._profiles:item(n);

        if profile:name() == name then
            return profile;
        end
    end

    return nil;
end

function opvp.ProfileOption:fromScript(data)
    self._profiles:clear();

    self._profile = nil;
    self._loading = true;

    if data ~= nil and opvp.is_table(data) == true then
        local profile_data;
        local profile;

        for n=1, #data do
            profile_data = data[n];

            if (
                profile_data.name ~= nil and
                opvp.is_str(profile_data.name) == true and
                profile_data.name ~= "" and
                self:hasProfile(profile_data.name) == false and
                profile_data.data ~= nil and
                opvp.is_table(profile_data.data) == true
            ) then
                profile = opvp.ProfileOptionItem(
                    profile_data.name,
                    profile_data.data
                );

                self:_addProfile(profile);
            end
        end
    end

    self._loading = false;

    self.valuesChanged:emit();
end

function opvp.ProfileOption:hasProfile(name)
    return self:findProfile(name) ~= nil;
end

function opvp.ProfileOption:index()
    return self._index;
end

function opvp.ProfileOption:profile(index)
    if index == nil then
        return self._profile
    else
        return self._profiles:item(index);
    end
end

function opvp.ProfileOption:isEmpty()
    return self._profiles:isEmpty();
end

function opvp.ProfileOption:profileName(index)
    if (
        opvp.is_number(index) == true and
        index > 0 and
        index <= self._profiles:size()
    ) then
        return self._profiles:item(index):name();
    else
        return "";
    end
end

function opvp.ProfileOption:profiles()
    return self._profiles:items();
end

function opvp.ProfileOption:root()
    return self._root;
end

function opvp.ProfileOption:setDefaultData(data)
    self._default = opvp.utils.deepcopy(data);
end

function opvp.ProfileOption:setProfile(profile)
    if (
        self:inCombatLockdown() == true or
        opvp.IsInstance(profile, opvp.ProfileOptionItem) == false or
        profile == self._profile
    ) then
        return;
    end

    local index = self._profiles:index(profile);

    if index > 0 then
        self:_loadProfile(profile, index);
    end
end

function opvp.ProfileOption:setProfileByIndex(index)
    if self:inCombatLockdown() == true then
        return;
    end

    local profile = self:profile(index);

    if profile == nil or profile == self._profile then
        return;
    end

    self:_loadProfile(profile, index);
end

function opvp.ProfileOption:setProfileByName(name)
    if self:inCombatLockdown() == true then
        return;
    end

    local profile = self:findProfile(name);

    if profile == nil or profile == self._profile then
        return;
    end

    self:_loadProfile(profile, self._profiles:index(profile));
end

function opvp.ProfileOption:size()
    return self._profiles:size();
end

function opvp.ProfileOption:toScript()
    local profile_data = {};
    local profile;

    for n=1, self._profiles:size() do
        profile = self._profiles:item(n);

        if profile == self._profile and self._save_valid == true then
            table.insert(
                profile_data,
                {
                    name=profile:name(),
                    index=n,
                    data=self._root:toScript()
                }
            );
        else
            table.insert(
                profile_data,
                {
                    name=profile:name(),
                    index=n,
                    data=profile:data()
                }
            );
        end
    end

    return profile_data;
end

function opvp.ProfileOption:_addProfile(profile)
    self._profiles:append(profile);

    if self._loading == true then
        return;
    end

    if self._profile == nil then
        self._profile = profile;
        self._index   = 1;
    end

    self.valuesChanged:emit();

    if profile == self._profile then
        self._save_valid = self._root:fromScript(self._profile:data());

        self.changed:emit();
    end
end

function opvp.ProfileOption:_loadProfile(profile, index)
    if self._profile ~= nil and self._save_valid == true then
        self._profile:setData(self._root:toScript());
    end

    self._profile = profile;
    self._index   = index;

    if profile ~= nil then
        self._save_valid = self._root:fromScript(self._profile:data());
    else
        self._save_valid = false;
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.general.profileLoaded:value(),
        opvp.strs.PROFILE_LOADED,
        profile:name()
    );

    self.changed:emit();
end

function opvp.ProfileOption:_onEnableChanged(state)
    if self._frame ~= nil then
        UIDropDownMenu_SetDropDownEnabled(self._frame.dropdown, state);

        if state == true then
            StaticPopup_Hide("OPVP_OPTIONS_PROFILE");
            StaticPopup_Hide("OPVP_OPTIONS_DELETE_PROFILE");
        end

        self._frame.create_button:SetEnabled(state);

        if state == true then
            self._frame.delete_button:SetEnabled(self:size() > 1);
        else
            self._frame.delete_button:SetEnabled(false);
        end
    end
end

function opvp.ProfileOption:_removeProfile(profile, index)
    if self._profile == profile then
        self._profile = nil;

        local incr = 0;

        if self._index == 1 then
            self:_loadProfile(self._profiles:item(2), 2);

            self._index = 1;
        else
            self:_loadProfile(self._profiles:item(index - 1), index - 1);
        end

        self._profiles:removeIndex(index);

        self.valuesChanged:emit();
    else
        self._profiles:removeIndex(index);

        if self._index > index then
            self._index = self._index - 1;
        end

        self.valuesChanged:emit();
    end
end
