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

opvp.FloatOption = opvp.CreateClass(opvp.Option);

function opvp.FloatOption:init(key, name, description, value, minValue, maxValue)
    opvp.Option.init(self, key, name, description);

    if opvp.is_number(minValue) then
        self._min = minValue;
    else
        self._min = -2147483648;
    end

    if opvp.is_number(maxValue) then
        self._max = max(self._min, maxValue);
    else
        self._max = 2147483647;
    end

    if opvp.is_number(value) == true then
        self._value = value;
    else
        self._value = 0;
    end

    self.changed = opvp.Signal(key);
end

function opvp.FloatOption:clamp(value)
    if opvp.is_number(value) == true then
        return opvp.math.clamp(value, self._min, self._max);
    else
        return self._min;
    end
end

function opvp.FloatOption:fromScript(data)
    if opvp.is_number(data) == true then
        self:setValue(data);
    end
end

function opvp.FloatOption:setValue(value)
    local valid_value = self:clamp(value);

    if valid_value ~= self._value then
        self._value = valid_value;

        self.changed:emit();
    end
end

function opvp.FloatOption:toScript()
    return self._value;
end

function opvp.FloatOption:type()
    return opvp.FloatOption.TYPE;
end

function opvp.FloatOption:value()
    return self._value;
end

local function create_float_option(...)
    return opvp.FloatOption(...);
end

opvp.FloatOption.TYPE = opvp.OptionType("float", create_float_option);
