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

opvp.IntOption = opvp.CreateClass(opvp.FloatOption);

function opvp.IntOption:init(key, name, description, value, minValue, maxValue)
    if opvp.is_number(minValue) then
        minValue = math.floor(minValue + 0.5);
    else
        minValue = -2147483648;
    end

    if opvp.is_number(maxValue) then
        maxValue = math.floor(maxValue + 0.5);
    else
        maxValue = 2147483647;
    end

    opvp.FloatOption.init(
        self,
        key,
        name,
        description,
        math.floor(value + 0.5),
        minValue,
        maxValue
    );
end

function opvp.IntOption:clamp(value)
    return opvp.FloatOption.clamp(
        self,
        math.floor(value + 0.5)
    );
end

function opvp.IntOption:toScript()
    return self._value;
end

function opvp.IntOption:type()
    return opvp.IntOption.TYPE;
end

function opvp.IntOption:value()
    return self._value;
end

local function create_int_option(...)
    return opvp.IntOption(...);
end

opvp.IntOption.TYPE = opvp.OptionType("int", create_int_option);
