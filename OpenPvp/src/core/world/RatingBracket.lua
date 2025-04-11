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

local opvp_rating_brackets_known = false;

opvp.BracketId = {
    NONE        = 0;
    ARENA_2V2   = 1;
    ARENA_3V3   = 2;
    BLITZ       = 3;
    RBG         = 4;
    SHUFFLE     = 5;
    MAX_BRACKET = 5;
}

local function tierInfoToTable(tier, info)
    return {
        enum=info.pvpTierEnum,
        icon=info.tierIconID,
        name=info.name,
        next_rating=info.ascendRating,
        next_tier=info.ascendTier,
        prev_rating=info.descendRating,
        prev_tier=info.descendTier,
        tier=tier
    };
end

opvp.RatingBracket = opvp.CreateClass();

function opvp.RatingBracket:fromInternalId(id)
    if id >= 0 and id <= opvp.MAX_BRACKET then
        return opvp.RatingBracket.BRACKETS[id + 1];
    else
        return opvp.RatingBracket.UNKNOWN;
    end
end

function opvp.RatingBracket:fromIndex(index)
    for n, bracket in ipairs(opvp.RatingBracket.BRACKETS) do
        if bracket:index() == index then
            return bracket;
        end
    end

    return opvp.RatingBracket.UNKNOWN;
end

function opvp.RatingBracket:init(
    pvpBracket,
    pvpType,
    index,
    queueSize,
    teamSize,
    name,
    ilvlMin,
    mask
)
    self._id          = pvpBracket;
    self._type        = pvpType;
    self._index       = index;
    self._queue_size  = queueSize;
    self._team_size   = teamSize;
    self._name        = name;
    self._ilvl        = ilvlMin;
    self._mask        = bit.bor(mask, opvp.PvpFlag.RATED, opvp.PvpFlag.RANDOM_MAP);
    self._enabled     = false;

    self.stateChanged = opvp.Signal("opvp.RatingBracket.stateChanged")
end

function opvp.RatingBracket:bonusRoles()
    local bonus;

    if self._id == opvp.BracketId.SHUFFLE then
        bonus = select(5, C_PvP.GetRatedSoloShuffleRewards())
    elseif self._id == opvp.BracketId.BLITZ then
        bonus = select(5, C_PvP.GetRatedSoloRBGRewards());
    end

    local role;
    local roles = {};

    if bonus ~= nil then
        for n=1, #bonus.validRoles do
            role = opvp.Role:fromRoleString(bonus.validRoles[n]);

            if role:isValid() == true then
                table.insert(roles, role);
            end
        end
    end

    return roles;
end

function opvp.RatingBracket:hasDailyWin()
    local result = false;

    if self._type ~= opvp.PvpType.NONE then
        result = select(9, GetPersonalRatedInfo(self._index));
    end

    if result ~= nil then
        return result;
    else
        return false;
    end
end

function opvp.RatingBracket:hasMinimumItemLevel()
    return self._ilvl > 0;
end

function opvp.RatingBracket:id()
    return self._id;
end

function opvp.RatingBracket:index()
    return self._index;
end

function opvp.RatingBracket:isDisabled()
    return self._enabled == false;
end

function opvp.RatingBracket:isEnabled()
    return self._enabled == true;
end

function opvp.RatingBracket:logRanking()
    local info = self:ratingInfo();

    local msg;

    if self._type ~= opvp.PvpType.NONE then
        if info.season_best ~= 0 and info.season_best ~= info.rating then
            if info.ranking ~= 0 then
                msg = string.format(
                    "%s - rating=%d (%s), rank=%d, high=%d (%s)",
                    self._name,
                    info.rating,
                    info.ranking,
                    self:tierName(),
                    info.season_best,
                    PVPUtil.GetTierName(
                        self:tierInfoForRating(info.season_best).enum
                    )
                );
            else
                msg = string.format(
                    "%s - rating=%d (%s), high=%d (%s)",
                    self._name,
                    info.rating,
                    self:tierName(),
                    info.season_best,
                    PVPUtil.GetTierName(
                        self:tierInfoForRating(info.season_best).enum
                    )
                );
            end
        else
            if info.rating > 0 then
                msg = string.format(
                    "%s - rating=%d (%s)",
                    self._name,
                    info.rating,
                    self:tierName()
                );
            else
                msg = string.format(
                    "%s - No Rating",
                    self._name
                );
            end

        end
    else
        msg = "Invalid Rating Bracket!";
    end

    if msg ~= nil then
        opvp.printMessage(msg);
    end
end

function opvp.RatingBracket:mask()
    return self._mask;
end

function opvp.RatingBracket:minimumItemLevel()
    return self._ilvl;
end

function opvp.RatingBracket:name()
    return self._name;
end

function opvp.RatingBracket:played()
    return self._name;
end

function opvp.RatingBracket:queueSize()
    return self._queue_size;
end

function opvp.RatingBracket:ranking()
    if self._type ~= opvp.PvpType.NONE then
        local ranking = select(11, GetPersonalRatedInfo(self._index));

        if ranking ~= nil then
            return ranking;
        end
    end

    return 0;
end

function opvp.RatingBracket:rating()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        result = select(1, GetPersonalRatedInfo(self._index));
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:ratingInfo()
    local function zero_or_value(value)
        if value ~= nil then
            return value
        else
            return 0
        end
    end

    if self._enabled == false or self._type == opvp.PvpType.NONE then
        return {
            rating=0,
            season_best=0,
            weekly_best=0,
            season_played=0,
            season_wins=0,
            weekly_played=0,
            weekly_wins=0,
            has_won=false,
            tier=0,
            ranking=0
        };
    end

     --~ 1 rating,
     --~ 2 season_best,
     --~ 3 weekly_best,
     --~ 4 season_played,
     --~ 5 season_wins,
     --~ 6 weekly_played,
     --~ 7 weekly_wins,
     --~ 8 last_week_best,
     --~ 9 has_won,
    --~ 10 tier,
    --~ 11 ranking,
    --~ 12 rounds_season_played,
    --~ 13 rounds_season_wins,
    --~ 14 rounds_weekly_played,
    --~ 15 rounds_weekly_wins

    local rating,
    season_best,
    weekly_best,
    season_played,
    season_wins,
    weekly_played,
    weekly_wins,
    last_week_best,
    has_won,
    tier,
    ranking,
    rounds_season_played,
    rounds_season_wins,
    rounds_weekly_played,
    rounds_weekly_wins = GetPersonalRatedInfo(self._index);

    if self._id == opvp.BracketId.SHUFFLE then
        return {
            rating=zero_or_value(rating),
            season_best=zero_or_value(season_best),
            weekly_best=zero_or_value(weekly_best),
            season_played=zero_or_value(rounds_season_played),
            season_wins=zero_or_value(rounds_season_wins),
            weekly_played=zero_or_value(rounds_weekly_played),
            weekly_wins=zero_or_value(rounds_weekly_wins),
            has_won=has_won,
            tier=tier,
            ranking=zero_or_value(ranking)
        };
    else
        return {
            rating=zero_or_value(rating),
            season_best=zero_or_value(season_best),
            weekly_best=zero_or_value(weekly_best),
            season_played=zero_or_value(season_played),
            season_wins=zero_or_value(season_wins),
            weekly_played=zero_or_value(weekly_played),
            weekly_wins=zero_or_value(weekly_wins),
            has_won=has_won,
            tier=tier,
            ranking=zero_or_value(ranking)
        };
    end
end

function opvp.RatingBracket:seasonBest()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        result = select(2, GetPersonalRatedInfo(self._index));
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:seasonPlayed()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        if self._id == opvp.BracketId.SHUFFLE then
            result = select(12, GetPersonalRatedInfo(self._index));
        else
            result = select(4, GetPersonalRatedInfo(self._index));
        end
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:seasonWins()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        if self._id == opvp.BracketId.SHUFFLE then
            result = select(13, GetPersonalRatedInfo(self._index));
        else
            result = select(5, GetPersonalRatedInfo(self._index));
        end
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:seasonWinPercentage()
    local info = self:ratingInfo();

    if info.season_played > 0 and info.season_wins > 0 then
        return info.season_wins / info.season_played;
    else
        return 0;
    end
end

function opvp.RatingBracket:teamSize(id)
    return self._team_size;
end

function opvp.RatingBracket:tier()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        result = select(10, GetPersonalRatedInfo(self._index));
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:tierInfo()
    local tier = self:tier();

    if tier ~= 0 then
        local info = C_PvP.GetPvpTierInfo(tier);

        if info ~= nil then
            return tierInfoToTable(tier, info);
        end
    end

    return {
        enum=0,
        icon=0,
        name="",
        next_rating=0,
        next_tier=0,
        prev_rating=0,
        prev_tier=0,
        tier=0
    };
end

function opvp.RatingBracket:tierInfoForRating(rating)
    if self._enabled == false or self._type == opvp.PvpType.NONE then
        return {
            enum=0,
            icon=0,
            name="",
            next_rating=0,
            next_tier=0,
            prev_rating=0,
            prev_tier=0,
            tier=0
        };
    end

    local tier_info = self:tierInfo();
    local tier = tier_info.tier;

    while tier_info ~= nil do
        tier = tier_info.tier;

        if rating > tier_info.prev_rating and rating < tier_info.next_rating then
            return tier_info;
        end

        local next_tier;

        if rating >= tier_info.next_rating then
            if tier_info.next_tier ~= 0 then
                next_tier = tier_info.next_tier;
            else
                return tier_info;
            end
        else
            if tier_info.prev_tier ~= 0 then
                next_tier = tier_info.prev_tier;
            else
                return tier_info;
            end
        end

        local next_info = C_PvP.GetPvpTierInfo(next_tier);

        if next_info == nil then
            return tier_info;
        end

        tier_info = tierInfoToTable(next_tier, next_info);
    end
end

function opvp.RatingBracket:tierIcon()
    return self:tierInfo().icon;
end

function opvp.RatingBracket:tierIconForRating(rating)
    return self:tierInfoForRating(rating).icon;
end

function opvp.RatingBracket:tierName()
    local enum = self:tierInfo().enum;

    if enum ~= 0 then
        return PVPUtil.GetTierName(enum);
    else
        return ""
    end
end

function opvp.RatingBracket:tierNameForRating(rating)
    local enum = self:tierInfoForRating(rating).enum;

    if enum ~= 0 then
        return PVPUtil.GetTierName(enum);
    else
        return ""
    end
end

function opvp.RatingBracket:type()
    return self._type;
end

function opvp.RatingBracket:weeklyBest()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        result = select(3, GetPersonalRatedInfo(self._index));
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:weeklyPlayed()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        if self._id == opvp.BracketId.SHUFFLE then
            result = select(14, GetPersonalRatedInfo(self._index));
        else
            result = select(6, GetPersonalRatedInfo(self._index));
        end
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:weeklyWins()
    local result;

    if self._type ~= opvp.PvpType.NONE then
        if self._id == opvp.BracketId.SHUFFLE then
            result = select(15, GetPersonalRatedInfo(self._index));
        else
            result = select(7, GetPersonalRatedInfo(self._index));
        end
    end

    if result ~= nil then
        return result;
    else
        return 0;
    end
end

function opvp.RatingBracket:weeklyWinPercentage()
    local info = self:ratingInfo();

    if info.weekly_played > 0 and info.weekly_wins > 0 then
        return info.weekly_wins / info.weekly_played;
    else
        return 0;
    end
end

function opvp.RatingBracket:_setEnabled(state)
    if state == self._enabled then
        return;
    end

    self._enabled = state;

    if opvp.match.inMatch() == false then
        if self._enabled == true then
            opvp.printDebug(
                opvp.strs.RATING_BRACKET_ENABLED,
                self._name
            );
        else
            opvp.printDebug(
                opvp.strs.RATING_BRACKET_DISABLED,
                self._name
            );
        end
    end

    self.stateChanged:emit(self._enabled);

    opvp.bracket.stateChanged:emit(self, self._enabled);
end

opvp.bracket = {};

opvp.bracket.stateChanged = opvp.Signal("opvp.bracket.stateChanged")

function opvp.bracket.hasMinimumItemLevel(id)
    return opvp.RatingBracket:fromInternalId(id):hasMinimumItemLevel();
end

function opvp.bracket.info(id)
    return opvp.RatingBracket:fromInternalId(id):info();
end

function opvp.bracket.index(id)
    return opvp.RatingBracket:fromInternalId(id):index();
end

function opvp.bracket.logRanking(id)
    opvp.RatingBracket:fromInternalId(id):logRanking();
end

function opvp.bracket.logRankings()
    for n=2, #opvp.RatingBracket.BRACKETS do
        local bracket = opvp.RatingBracket.BRACKETS[n];
        local rating = bracket:rating();

        if rating ~= 0 then
            bracket:logRanking();
        end
    end
end

function opvp.bracket.minimumItemLevel(id)
    return opvp.RatingBracket:fromInternalId(id):minimumItemLevel();
end

function opvp.bracket.name(id)
    return opvp.RatingBracket:fromInternalId(id):name();
end

function opvp.bracket.played(id)
    return opvp.RatingBracket:fromInternalId(id):played();
end

function opvp.bracket.queueSize(id)
    return opvp.RatingBracket:fromInternalId(id):queueSize();
end

function opvp.bracket.ranking(id)
    return opvp.RatingBracket:fromInternalId(id):ranking();
end

function opvp.bracket.rating(id)
    return opvp.RatingBracket:fromInternalId(id):rating();
end

function opvp.bracket.seasonBest(id)
    return opvp.RatingBracket:fromInternalId(id):seasonBest();
end

function opvp.bracket.seasonPlayed(id)
    return opvp.RatingBracket:fromInternalId(id):seasonPlayed();
end

function opvp.bracket.seasonWins(id)
    return opvp.RatingBracket:fromInternalId(id):seasonWins();
end

function opvp.bracket.seasonWinPercentage(id)
    return opvp.RatingBracket:fromInternalId(id):seasonWinPercentage();
end

function opvp.bracket.teamSize(id)
    return opvp.RatingBracket:fromInternalId(id):teamSize();
end

function opvp.bracket.tier(id)
    return opvp.RatingBracket:fromInternalId(id):tier();
end

function opvp.bracket.tierInfo(id)
    return opvp.RatingBracket:fromInternalId(id):tierInfo();
end

function opvp.bracket.tierInfoForRating(id, rating)
    return opvp.RatingBracket:fromInternalId(id):tierInfoForRating(rating);
end

function opvp.bracket.tierIcon(id)
    return opvp.RatingBracket:fromInternalId(id):tierIcon();
end

function opvp.bracket.tierName(id)
    return opvp.RatingBracket:fromInternalId(id):tierName();
end

function opvp.bracket.type(id)
    return opvp.RatingBracket:fromInternalId(id):type();
end

function opvp.bracket.weeklyBest(id)
    return opvp.RatingBracket:fromInternalId(id):weeklyBest();
end

function opvp.bracket.weeklyPlayed(id)
    return opvp.RatingBracket:fromInternalId(id):weeklyPlayed();
end

function opvp.bracket.weeklyWins(id)
    return opvp.RatingBracket:fromInternalId(id):weeklyWins();
end

function opvp.bracket.weeklyWinPercentage(id)
    return opvp.RatingBracket:fromInternalId(id):weeklyWinPercentage();
end

opvp.RatingBracket.UNKNOWN = opvp.RatingBracket(
    opvp.BracketId.NONE,
    opvp.PvpType.NONE,
    0,
    0,
    0,
    "",
    0,
    0
);

opvp.RatingBracket.ARENA_2V2 = opvp.RatingBracket(
    opvp.BracketId.ARENA_2V2,
    opvp.PvpType.ARENA,
    1,
    2,
    2,
    CONQUEST_BRACKET_NAME_2V2,
    0,
    opvp.PvpFlag.DAMPENING
);

opvp.RatingBracket.ARENA_3V3 = opvp.RatingBracket(
    opvp.BracketId.ARENA_3V3,
    opvp.PvpType.ARENA,
    2,
    3,
    3,
    CONQUEST_BRACKET_NAME_3V3,
    0,
    opvp.PvpFlag.DAMPENING
);

opvp.RatingBracket.BLITZ = opvp.RatingBracket(
    opvp.BracketId.BLITZ,
    opvp.PvpType.BATTLEGROUND,
    9,
    1,
    8,
    CONQUEST_BRACKET_NAME_BATTLEGROUND_BLITZ,
    C_PvP.GetRatedSoloRBGMinItemLevel(),
    opvp.PvpFlag.BLITZ
);

opvp.RatingBracket.RBG = opvp.RatingBracket(
    opvp.BracketId.RBG,
    opvp.PvpType.BATTLEGROUND,
    4,
    10,
    10,
    CONQUEST_BRACKET_NAME_RBG,
    0,
    opvp.PvpFlag.RBG
);

opvp.RatingBracket.SHUFFLE = opvp.RatingBracket(
    opvp.BracketId.SHUFFLE,
    opvp.PvpType.ARENA,
    7,
    1,
    3,
    CONQUEST_BRACKET_NAME_SOLO_SHUFFLE,
    C_PvP.GetRatedSoloShuffleMinItemLevel(),
    bit.bor(
        opvp.PvpFlag.DAMPENING,
        opvp.PvpFlag.SHUFFLE,
        opvp.PvpFlag.ROUND
    )
);

opvp.RatingBracket.BRACKETS = {
    opvp.RatingBracket.UNKNOWN,
    opvp.RatingBracket.SHUFFLE,
    opvp.RatingBracket.BLITZ,
    opvp.RatingBracket.ARENA_2V2,
    opvp.RatingBracket.ARENA_3V3,
    opvp.RatingBracket.RBG
};

local function opvp_pvp_types_enabled(
    wargameBattlegrounds,
    ratedBattlegrounds,
    ratedArenas,
    ratedSoloShuffle,
    ratedBGBlitz
)
    opvp.RatingBracket.SHUFFLE:_setEnabled(ratedSoloShuffle);
    opvp.RatingBracket.BLITZ:_setEnabled(ratedBGBlitz);
    opvp.RatingBracket.ARENA_2V2:_setEnabled(ratedArenas);
    opvp.RatingBracket.ARENA_3V3:_setEnabled(ratedArenas);
    opvp.RatingBracket.RBG:_setEnabled(ratedBattlegrounds);

    if opvp_rating_brackets_known == false then
        if (
            opvp.match.inMatch() == false and
            opvp.options.announcements.player.currentRating:value() == true
        ) then
            opvp.bracket.logRankings();
        end

        opvp_rating_brackets_known = true;
    end
end

opvp.event.PVP_TYPES_ENABLED:connect(opvp_pvp_types_enabled);

opvp.OnLoginReload:register(
    function()
        RequestPVPOptionsEnabled();
        RequestRatedInfo();
    end
);
