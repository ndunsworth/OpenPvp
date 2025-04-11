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

opvp.PvpPartyMember = opvp.CreateClass(opvp.PartyMember);

function opvp.PvpPartyMember:init()
    opvp.PartyMember.init(self);

    self._cr        = 0;
    self._cr_gain   = 0;
    self._mmr       = 0;
    self._mmr_gain  = 0;
    self._team      = nil;
end

function opvp.PvpPartyMember:cr()
    return self._cr;
end

function opvp.PvpPartyMember:crGain()
    return self._cr_gain;
end

function opvp.PvpPartyMember:isRatingKnown()
    return bit.band(self._mask, opvp.PartyMember.RATING_CURRENT_FLAG) ~= 0;
end

function opvp.PvpPartyMember:isRatingGainedKnown()
    return bit.band(self._mask, opvp.PartyMember.RATING_GAIN_FLAG) ~= 0;
end

function opvp.PvpPartyMember:mmr()
    return self._mmr;
end

function opvp.PvpPartyMember:mmrGain()
    return self._mmr_gain;
end

function opvp.PvpPartyMember:team()
    return self._team;
end

function opvp.PvpPartyMember:_reset(mask)
    opvp.PartyMember._reset(self, mask);

    if bit.band(mask, opvp.PartyMember.RATING_CURRENT_FLAG) then
        self._cr  = 0;
        self._mmr = 0;
    end

    if bit.band(mask, opvp.PartyMember.RATING_GAIN_FLAG) then
        self._cr_gain  = 0;
        self._mmr_gain = 0;
    end

    if bit.band(mask, opvp.PartyMember.TEAM_FLAG) then
        self._team = nil;
    end
end

function opvp.PvpPartyMember:_setRating(cr, mmr)
    if cr > -1 then
        self:_setFlags(
            opvp.PartyMember.RATING_CURRENT_FLAG,
            true
        );

        cr = 0;
        mmr = 0;
    else
        self:_setFlags(
            opvp.PartyMember.RATING_CURRENT_FLAG,
            false
        );
    end

    self._cr = cr;
    self._mmr = mmr;
end

function opvp.PvpPartyMember:_setRatingGain(cr, mmr)
    if cr > -1 then
        self:_setFlags(
            opvp.PartyMember.RATING_GAIN_FLAG,
            true
        );

        cr = 0;
        mmr = 0;
    else
        self:_setFlags(
            opvp.PartyMember.RATING_GAIN_FLAG,
            false
        );
    end

    self._cr_gain = cr;
    self._mmr_gain = mmr;
end

function opvp.PvpPartyMember:_setTeam(team)
    if team ~= self._team then
        self._team = team;

        self:_setFlags(
            opvp.PartyMember.TEAM_FLAG,
            team ~= nil
        );
    end
end

function opvp.PvpPartyMember:_updateScore()
    local old_mask = self._mask;

    if self:isGuidKnown() == false then
        return 0;
    end

    local info = C_PvP.GetScoreInfoByPlayerGuid(self:guid());

    if info == nil then
        return 0;
    end

    if self:isNameKnown() == false then
        self:_setName(info.name);
    end

    if self:isRaceKnown() == false then
        self:_setRace(opvp.Race:fromRaceName(info.raceName));
    end

    if info.prematchMMR > 0 and self:isRatingKnown() == false then
        self:_setRating(
            info.rating,
            info.prematchMMR
        );
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end

function opvp.PvpPartyMember:_updateRatingGained()
    if self:isRatingGainedKnown() == true then
        return true;
    end

    if self:isGuidKnown() == false then
        return false;
    end

    local info = C_PvP.GetScoreInfoByPlayerGuid(self:guid());

    if info == nil then
        return false;
    end

    self:_setRatingGain(
        info.ratingChange,
        info.postmatchMMR - info.prematchMMR
    );

    return true;
end
