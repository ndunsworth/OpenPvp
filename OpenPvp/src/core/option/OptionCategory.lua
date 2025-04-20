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

local OPT_TYPES = {
    [opvp.Option.BITMASK]    = opvp.BitMaskOption,
    [opvp.Option.BOOL]       = opvp.BoolOption,
    [opvp.Option.BUTTON]     = opvp.ButtonOption,
    [opvp.Option.ENUM]       = opvp.EnumOption,
    [opvp.Option.FLOAT]      = opvp.FloatOption,
    [opvp.Option.INT]        = opvp.IntOption,
    [opvp.Option.LABEL]      = opvp.LabelOption,
    [opvp.Option.LAYOUT]     = opvp.LayoutOption,
    [opvp.Option.MATCH_TYPE] = opvp.MatchTypeOption,
    [opvp.Option.ROLEMASK]   = opvp.RoleMaskOption,
    [opvp.Option.STRING]     = opvp.StringOption
};

opvp.OptionCategory = opvp.CreateClass(opvp.Option);

opvp.OptionCategory.ROOT_CATEGORY  = 0;
opvp.OptionCategory.GROUP_CATEGORY = 1;
opvp.OptionCategory.CHILD_CATEGORY = 2;

function opvp.OptionCategory:init(key, name, description, categoryType)
    opvp.Option.init(self, key, name, description);

    self._name = name;
    self._ui_sub_cat = false;
    self._ui_category = nil;

    if categoryType ~= nil then
        self._cat_type = categoryType;
    else
        self._cat_type = opvp.OptionCategory.GROUP_CATEGORY;
    end

    if opvp.is_str(description) == true then
        self._desc = description;
    else
        self._desc = self._name;
    end

    self._opts = opvp.List();
end

function opvp.OptionCategory:addOption(option)
    if opvp.IsInstance(option, opvp.Option) == false then
        opvp.printWarning("OptionCategory:addOption, option is not an opvp.Option");

        return false;
    end

    if option._category ~= nil then
        opvp.printWarning(
            "OptionCategory:addOption, option already has category \"%s\"",
            option:name()
        );

        return false;
    end

    if self._opts:contains(option) == true then
        opvp.printWarning(
            "OptionCategory:addOption, category already contains option \"%s\"",
            option:name()
        );

        return false;
    end

    if self:findOptionWithKey(option:key()) ~= nil then
        opvp.printWarning(
            "OptionCategory:addOption, category already contains an option with the same name \"%s\"",
            option:name()
        );

        return false;
    end

    self._opts:append(option);

    option._category = self;

    return true;
end

function opvp.OptionCategory:categoryType()
    return self._cat_type;
end

function opvp.OptionCategory:createCategory(key, name, description, categoryType)
    local option = self:findOptionWithKey(key);

    if option ~= nil then
        if opvp.IsInstance(option, opvp.OptionCategory) then
            return option;
        else
            return nil;
        end
    end

    option = opvp.OptionCategory(key, name, description, categoryType);

    option._category = self;

    self._opts:append(option);

    return option;
end

function opvp.OptionCategory:createOption(optionType, key, name, description, ...)
    local option = self:findOptionWithKey(key);

    if option ~= nil then
        opvp.printWarning(
            "OptionCategory:createCategory, category already contains an option with the same key \"%s\"",
            key
        );

        return nil;
    end

    option_type = OPT_TYPES[optionType];

    if option_type == nil then
        opvp.printWarning(
            "OptionCategory:createOption, invalid option type %s",
            tostring(optionType)
        );

        return nil;
    end

    option = option_type(key, name, description, ...);

    option._category = self;

    self._opts:append(option);

    return option;
end

function opvp.OptionCategory:description()
    return self._desc;
end

function opvp.OptionCategory:findOptionWithKey(key)
    if opvp.is_str(key) == false then
        opvp.printWarning(
            ".OptionCategory(\"%s\"):findOptionWithKey(key), key is not a string!",
            self:name()
        );

        return nil;
    end

    for n=1, self._opts:size() do
        local opt = self._opts:item(n);

        if opt and opt:key() == key then
            return opt;
        end
    end

    return nil;
end

function opvp.OptionCategory:findOptionWithName(name)
    if opvp.is_str(name) == false then
        opvp.printWarning(
            ".OptionCategory(\"%s\"):findOptionWithName(name), name is not a string!",
            self:name()
        );

        return nil;
    end

    for n=1, self._opts:size() do
        local opt = self._opts:item(n);

        if opt and opt:name() == name then
            return opt;
        end
    end

    return nil;
end

function opvp.OptionCategory:fromScript(data)
    --~ opvp.printMessage(
        --~ "OptionCategory(\"%s\"):fromScript(%s)",
        --~ self:key(),
        --~ opvp.to_string(data)
    --~ );

    for k, value in pairs(data) do
        local opt = self:findOptionWithKey(k);

        if opt ~= nil then
            opt._loading = true;

            local status, err = pcall(opt.fromScript, opt, value);

            if status == false then
                opvp.printWarning(err);
            end

            opt._loading = false;
        end
    end
end

function opvp.OptionCategory:isEmpty()
    return self._opts:isEmpty();
end

function opvp.OptionCategory:isShown()
    return (
        SettingsPanel:IsVisible() == true and
        self._ui_category ~= nil and
        SettingsPanel:GetCurrentCategory() == self._ui_category
    );
end

function opvp.OptionCategory:name()
    return self._name;
end

function opvp.OptionCategory:options()
    return self._opts:items();
end

function opvp.OptionCategory:setCategoryType(uiType)
    if (
        uiType == opvp.OptionCategory.CHILD_CATEGORY or
        uiType == opvp.OptionCategory.GROUP_CATEGORY
    ) then
        self._cat_type = uiType;
    end
end

function opvp.OptionCategory:setUiCategory(category)
    self._ui_category = category;
end

function opvp.OptionCategory:hide()
    if self:isShown() == true then
        SettingsPanel:Hide();
    end
end

function opvp.OptionCategory:show()
    if self._ui_category ~= nil then
        SettingsPanel:Show();

        Settings.OpenToCategory(self._ui_category:GetID());
    end
end

function opvp.OptionCategory:size()
    return self._opts:size();
end

function opvp.OptionCategory:toScript()
    local data = {};

    for n=1, self._opts:size() do
        local opt = self._opts:item(n);

        if opt:isSavable() == true then
            local opt_data = opt:toScript();

            if opt_data ~= nil then
                data[opt:key()] = opt_data;
            end
        end
    end

    return data;
end

function opvp.OptionCategory:type()
    return opvp.OptionCategory.TYPE;
end

function opvp.OptionCategory:uiCategory()
    return self._ui_category;
end

local function create_category_option(...)
    return opvp.OptionCategory(...);
end

opvp.OptionCategory.TYPE = opvp.OptionType("category", create_category_option);
