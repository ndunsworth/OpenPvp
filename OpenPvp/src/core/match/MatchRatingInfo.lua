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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.MatchRatingInfo = opvp.CreateClass();

function opvp.MatchRatingInfo:init()
    self._mmr       = 0;
    self._mmr_gain  = 0;
    self._cr        = 0;
    self._cr_gain   = 0;
end

function opvp.MatchRatingInfo:cr()
    return self._cr;
end

function opvp.MatchRatingInfo:crGain()
    return self._cr_gain;
end

function opvp.MatchRatingInfo:mmr()
    return self._mmr;
end

function opvp.MatchRatingInfo:mmrGain()
    return self._mmr_gain;
end

function opvp.MatchRatingInfo:setCR(rating)
    self._cr = rating;
end

function opvp.MatchRatingInfo:setCRGain(value)
    self._cr_gain = value;
end

function opvp.MatchRatingInfo:setMMR(rating)
    self._mmr = rating;
end

function opvp.MatchRatingInfo:setMMRGain(value)
    self._mmr_gain = rating;
end
