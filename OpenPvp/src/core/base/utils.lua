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

function opvp.iter(obj)
    return obj:__iter__();
end

opvp.utils = {};

function opvp.utils.chatTypeColor(id)
    local info = ChatTypeInfo[id];

    if info ~= nil then
        return {
            r=info.r,
            g=info.g,
            b=info.b
        };
    else
        return {
            r=1,
            g=1,
            b=1
        };
    end
end

function opvp.utils.colorNumber(n, r, g, b)
    if (
        r ~= nil and
        g ~= nil and
        b ~= nil
    ) then
        return opvp.utils.colorStringRGB(tostring(n), r, g, b);
    else
        return tostring(n);
    end
end

function opvp.utils.colorNumberPosNeg(n, pr, pg, pb, nr, ng, nb)
    if n < 0 then
        return opvp.utils.colorNumber(n, nr, ng, nb);
    elseif n > 0 then
        return opvp.utils.colorNumber(n, pr, pg, pb);
    else
        return tostring(n);
    end
end

function opvp.utils.colorStringChatType(str, id)
    local color = opvp.utils.chatTypeColor(id);

    return opvp.utils.colorStringRGB(
        str,
        color.r,
        color.g,
        color.b
    );
end

function opvp.utils.colorStringRGB(str, r, g, b)
    return string.format(
        "|cFF%02x%02x%02x%s|r",
        r * 255,
        g * 255,
        b * 255,
        str
    );
end

function opvp.utils.colorStringRGBA(str, r, g, b)
    return string.format(
        "|c%02x%02x%02x%02x%s|r",
        a * 255,
        r * 255,
        g * 255,
        b * 255,
        str
    );
end

function opvp.utils.compress(source, method, level)
    return C_EncodingUtil.CompressString(source, method, level);
end

function opvp.utils.copyTableShallow(tbl)
    if type(tbl) ~= "table" then
        return tbl;
    end

    local result = {};

    for k,v in pairs(tbl) do
        result[k] = v
    end

    return result;
end

function opvp.utils.compareTable(a, b, ignore_mt)
    if a == b then
        return true;
    end

    local a_type = type(a)
    local b_type = type(b)

    if a_type ~= b_type then
        return false;
    end

    if a_type ~= 'table' then
        return a == b;
    end

    if #a ~= #b then
        return false;
    end

    if not ignore_mt then
        local mt1 = getmetatable(a);

        if mt1 and mt1.__eq then
            return a == b;
        end
    end

    local key_set = {};

    for key1, value1 in pairs(a) do
        local value2 = b[key1];

        if value2 == nil or opvp.utils.compareTable(value1, value2, ignore_mt) == false then
            return false;
        end
    end

    return true;
end

function opvp.utils.debugstack(start)
    return debugstack(start);
end

function opvp.utils.decompress(source, method)
    return C_EncodingUtil.DecompressString(source, method);
end

function opvp.utils.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[opvp.utils.deepcopy(orig_key)] = opvp.utils.deepcopy(orig_value)
        end
        setmetatable(copy, opvp.utils.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Save copied tables in `copies`, indexed by original table.
function opvp.utils.deepcopy2(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = opvp.utils.deepcopy2(orig_value, copies)
            end
            setmetatable(copy, opvp.utils.deepcopy2(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function opvp.utils.dump(data)
    DevTools_Dump(data);
end

function opvp.utils.merge(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            opvp.utils.merge(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

function opvp.utils.numberToStringShort(n, precision)
    if n == 0 then
        return string.format("%d", 0);
    end

    if precision == nil then
        precision = 2;
    else
        precision = max(0, precision);
    end

    local token;

    if n > 999999999 then
        n = n / 1000000000;

        token = opvp.strs.NUMERIC_BILLION;
    elseif n > 999999 then
        n = n / 1000000;

        token = opvp.strs.NUMERIC_MILLION;
    elseif n > 999 then
        n = n / 1000;

        token = opvp.strs.NUMERIC_THOUSAND;
    else
        token = "";
    end

    if precision == 0 then
        n = math.floor(n);
    end

    local fmt = "%0." .. tostring(precision) .. "f";

    return string.format(fmt, n) .. token;
end

function opvp.utils.serializeFromCBOR(data)
     return C_EncodingUtil.DeserializeCBOR(data);
end

function opvp.utils.serializeFromJSON(data)
     return C_EncodingUtil.DeserializeJSON(data);
end

function opvp.utils.serializeToCBOR(data)
    return C_EncodingUtil.SerializeCBOR(data);
end

function opvp.utils.serializeToJSON(data)
    return C_EncodingUtil.SerializeJSON(data);
end

opvp.utils.array = {};

function opvp.utils.array.contains(tbl, item)
    for n=1, #tbl do
        if tbl[n] == item then
            return true;
        end
    end

    return false;
end

opvp.utils.table = {};

function opvp.utils.table.isEmpty(tbl)
    return next(tbl) == nil;
end

function opvp.utils.table.size(tbl)
    local n = 0;

    for k, v in pairs(tbl) do
        n = n + 1;
    end

    return n;
end

function opvp.utils.textureAtlastMarkup(name, width, height, offsetX, offsetY, rVertexColor, gVertexColor, bVertexColor)
    return CreateAtlasMarkup(
        name,
        width,
        height,
        offsetX,
        offsetY,
        rVertexColor,
        gVertexColor,
        bVertexColor
    );
end

function opvp.utils.textureMarkup(tex, width, height, offsetX, offsetY)
    --~ TextureUtil.lua

    if offsetX == nil then
        offsetX = 0;
    end

    if offsetY == nil then
        offsetY = 0;
    end

    local left, top, _, bottom, right = tex:GetTexCoord();

    return CreateTextureMarkup(
        tex:GetTexture(),
        width,
        height,
        tex:GetWidth(),
        tex:GetHeight(),
        left,
        right,
        top,
        bottom,
        offsetX,
        offsetY
    );
end

function opvp.utils.textureIdMarkup(id, width, height, offsetX, offsetY)
    --~ TextureUtil.lua

    if offsetX == nil then
        offsetX = 0;
    end

    if offsetY == nil then
        offsetY = 0;
    end

    return CreateSimpleTextureMarkup(
        tostring(id),
        width,
        height,
        0,
        0
    );
end

function opvp.is_bool(var)
    return type(var) == "boolean";
end

function opvp.is_func(var)
    return type(var) == "function";
end

function opvp.is_number(var)
    return type(var) == "number";
end

function opvp.is_str(var)
    return type(var) == "string";
end

function opvp.is_table(var)
    return type(var) == "table";
end

function opvp.bool_else(var, default)
    if opvp.is_bool(var) then
        return var;
    elseif default ~= nil then
        return default;
    else
        return false;
    end
end

function opvp.number_else(var, default)
    if opvp.is_number(var) then
        return var;
    elseif default ~= nil then
        return default;
    else
        return 0;
    end
end

function opvp.str_else(var, default)
    if opvp.is_str(var) then
        return var;
    elseif default ~= nil then
        return default;
    else
        return "";
    end
end

function opvp.to_string(var)
    if var ~= nil then
        return tostring(var);
    else
        return "nil";
    end
end

function opvp.printDebug(msg, ...)
    if opvp.DEBUG == false then
        return;
    end

    local ts = C_CVar.GetCVar("showTimestamps")

    if ... ~= nil then
        msg = string.format(msg, ...);
    end

    if ts ~= "none" then
        print(
            date(ts) .. opvp.utils.colorStringRGB("OPVP:", 1, 1, 0),
            msg
        );
    else
        print(
            opvp.utils.colorStringRGB("OPVP:", 1, 1, 0),
            msg
        );
    end
end

function opvp.printDebugChatType(chatType, msg, ...)
    opvp.printDebug(
        opvp.utils.colorStringChatType(msg, chatType),
        ...
    );
end

function opvp.printMessage(msg, ...)
    local ts = C_CVar.GetCVar("showTimestamps")

    if ... ~= nil then
        msg = string.format(msg, ...);
    end

    if ts ~= "none" then
        print(
            date(ts) .. "|cff00ccffOPVP:|r",
            msg
        );
    else
        print(
            "|cff00ccffOPVP:|r",
            msg
        );
    end
end

function opvp.printMessageChatType(chatType, msg, ...)
    opvp.printMessage(
        opvp.utils.colorStringChatType(msg, chatType),
        ...
    );
end

function opvp.printMessageOrDebug(state, msg, ...)
    if state == true then
        opvp.printMessage(msg, ...);
    else
        opvp.printDebug(msg, ...);
    end
end

function opvp.printMessageOrDebugChatType(state, chatType, msg, ...)
    if state == true then
        opvp.printMessageChatType(chatType, msg, ...);
    else
        opvp.printDebugChatType(chatType, msg, ...);
    end
end

function opvp.printWarning(msg, ...)
    local ts = C_CVar.GetCVar("showTimestamps")

    if ... ~= nil then
        msg = string.format(msg, ...);
    end

    if ts ~= "none" then
        print(
            date(ts) .. "|cffff0000OPVP:|r",
            msg
        );
    else
        print(
            "|cff00ccffOPVP:|r",
            msg
        );
    end
end


    --~ UIParentLoadAddOn("Blizzard_EventTrace")
    --~ EventTrace:Show();
function opvp.testui(t)
    local topCenter = C_UIWidgetManager.GetTopCenterWidgetSetID();
    local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(topCenter);

    for _, w in pairs(widgets, t) do
        print(w.widgetType, w.widgetID)
        if w.widgetType == 0 and w.widgetType == t then
            DevTools_Dump(C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(w.widgetID))
        elseif w.widgetType == 2 and w.widgetType == t then
            DevTools_Dump(C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(w.widgetID))
        elseif w.widgetType == 3 and w.widgetType == t then
            DevTools_Dump(C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo(w.widgetID))
        elseif w.widgetType == 8 and w.widgetType == t then
            DevTools_Dump(C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(w.widgetID))
        end
    end
end

local opvp_seconds_fmt_lower = CreateFromMixins(SecondsFormatterMixin);
local opvp_seconds_fmt_upper = CreateFromMixins(SecondsFormatterMixin);

function opvp_seconds_fmt_lower:FormatZero(abbreviation, toLower)
    local minInterval = self:GetMinInterval(seconds);
    local formatString = self:GetFormatString(minInterval, abbreviation, self.convertToLower);

    return formatString:format(0);
end

opvp_seconds_fmt_lower:Init(1, SecondsFormatter.Abbreviation.Truncate, false, true, true);
opvp_seconds_fmt_upper:Init(1, SecondsFormatter.Abbreviation.Truncate, false, true, false);

opvp.time = {};

function opvp.time.formatSeconds(seconds, uppercase)
    if uppercase == true then
        return opvp_seconds_fmt_lower:Format(seconds);
    else
        return opvp_seconds_fmt_upper:Format(seconds);
    end
end

function opvp.time.bootTime()
    return opvp.system.bootTime();
end
