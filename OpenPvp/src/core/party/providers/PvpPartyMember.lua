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

    self._kills         = 0;
    self._deaths        = 0;
    self._damage        = 0;
    self._healing       = 0;

    self._cr            = 0;
    self._cr_gain       = 0;
    self._mmr           = 0;
    self._mmr_gain      = 0;
    self._team          = nil;
    self._stats         = opvp.List();
end

function opvp.PvpPartyMember:cr()
    return self._cr;
end

function opvp.PvpPartyMember:crGain()
    return self._cr_gain;
end

function opvp.PvpPartyMember:damage()
    return self._damage;
end

function opvp.PvpPartyMember:deaths()
    return self._deaths;
end

function opvp.PvpPartyMember:findStatById(id)
    local stat;

    for n=1, self._stats:size() do
        stat = self._stats:item(n);

        if stat:id() == id then
            return stat;
        end
    end

    return nil;
end

function opvp.PvpPartyMember:findStatByStatId(id)
    local stat;

    for n=1, self._stats:size() do
        stat = self._stats:item(n);

        if stat:statId() == id then
            return stat;
        end
    end

    return nil;
end

function opvp.PvpPartyMember:hasStat(id)
    local stat;

    for n=1, self._stats:size() do
        stat = self._stats:item(n);

        if stat:id() == id then
            return true;
        end
    end

    return false;
end

function opvp.PvpPartyMember:healing()
    return self._healing;
end

function opvp.PvpPartyMember:kills()
    return self._kills;
end

function opvp.PvpPartyMember:isPvp()
    return true;
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

    if bit.band(mask, opvp.PartyMember.SCORE_FLAG) then
        self._kills     = 0;
        self._deaths    = 0;
        self._damage    = 0;
        self._healing   = 0;

        self._stats:clear();
    end

    if bit.band(mask, opvp.PartyMember.TEAM_FLAG) then
        self._team = nil;
    end
end

function opvp.PvpPartyMember:_setRating(cr, mmr)
    self:_setFlags(
        opvp.PartyMember.RATING_CURRENT_FLAG,
        cr > -1
    );

    self._cr = cr;
    self._mmr = mmr;
end

function opvp.PvpPartyMember:_setRatingGain(cr, mmr)
    self:_setFlags(
        opvp.PartyMember.RATING_GAIN_FLAG,
        cr > -1
    );

    self._cr_gain = cr;
    self._mmr_gain = mmr;
end

function opvp.PvpPartyMember:_setStatById(id, value)
    local stat = self:findStatById(id);

    if stat ~= nil then
        stat:setValue(value);
    end
end

function opvp.PvpPartyMember:_setStatByStatId(id, value)
    local stat = self:findStatByStatId(id);

    if stat ~= nil then
        stat:setValue(value);
    end
end

function opvp.PvpPartyMember:_setStats(stats)
    self._stats = opvp.List:createFromArray(stats);
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

function opvp.PvpPartyMember:_updateScore(rated)
    if self:isGuidKnown() == false then
        return 0;
    end

    local old_mask = self._mask;
    local info = C_PvP.GetScoreInfoByPlayerGuid(self:guid());

    if info == nil then
        return 0;
    end

    self._kills     = opvp.number_else(info.killingBlows);
    self._deaths    = opvp.number_else(info.deaths);
    self._damage    = opvp.number_else(info.damageDone);
    self._healing   = opvp.number_else(info.healingDone);

    if rated == true then
        info.mmrChange = info.postmatchMMR - info.prematchMMR;

        if info.rating ~= self._cr or info.rematchMMR ~= self._mmr then
            self:_setRating(
                info.rating,
                info.prematchMMR
            );
        end

        if info.ratingChange ~= self._cr_gain or info.mmrChange ~= self._mmr_gain then
            self:_setRatingGain(
                info.ratingChange,
                info.mmrChange
            );
        end
    end

    if opvp.is_table(info.stats) and self._stats:isEmpty() == false then
        local stat;
        local stat_info;

        for n=1, #info.stats do
            stat_info = info.stats[n];

            stat = self:findStatByStatId(stat_info.pvpStatID);

            if stat ~= nil then
                stat:setValue(stat_info.pvpStatValue);
            end
        end
    end

    return bit.band(bit.bnot(old_mask), self._mask);
end
