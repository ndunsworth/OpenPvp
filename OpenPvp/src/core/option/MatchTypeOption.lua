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

opvp.MatchTypeOption = opvp.CreateClass(opvp.EnumOption);

function opvp.MatchTypeOption:init(key, name, description, value)
    opvp.EnumOption.init(
        self,
        key,
        name,
        description,
        {
            string.lower(opvp.strs.DISABLED),
            string.lower(opvp.strs.ARENA),
            string.lower(opvp.strs.ARENA_AND_BATTLEGROUND),
            string.lower(opvp.strs.BATTLEGROUND),
        }
    );

    if value ~= nil then
        self:setValue(value);
    end
end

function opvp.MatchTypeOption:matchMask()
    local index = self:index();

    if index < 2 then
        return 0;
    elseif index == 2 then
        return 1;
    elseif index == 3 then
        return 3;
    else
        return 2;
    end
end

function opvp.MatchTypeOption:type()
    return opvp.MatchTypeOption.TYPE;
end

local function create_match_type_option(...)
    return opvp.MatchTypeOption(...);
end

opvp.MatchTypeOption.TYPE = opvp.OptionType("matchtype", create_match_type_option);
