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

local opvp_role_markup_lookup = {
    [opvp.RoleType.NONE]   = opvp.utils.textureAtlastMarkup("UI-LFG-RoleIcon-Leader", 16, 16),
    [opvp.RoleType.DPS]    = opvp.utils.textureAtlastMarkup("UI-LFG-RoleIcon-DPS", 16, 16),
    [opvp.RoleType.HEALER] = opvp.utils.textureAtlastMarkup("UI-LFG-RoleIcon-Healer", 16, 16),
    [opvp.RoleType.TANK]   = opvp.utils.textureAtlastMarkup("UI-LFG-RoleIcon-Tank", 16, 16),
};

local function opvp_role_markups(queue)
    local result = "";

    local roles = queue:bonusRoles();

    for n=1, #roles do
        result = result .. opvp_role_markup_lookup[roles[n]:id()];
    end

    if queue:hasEnlistmentBonus() == true then
        result = result .. opvp_role_markup_lookup[opvp.RoleType.NONE];
        --~ result = opvp.utils.textureIdMarkup(
            --~ C_Spell.GetSpellTexture(BATTLEGROUND_ENLISTMENT_BONUS),
            --~ 15,
            --~ 15
        --~ );
    end

    return result;
end

opvp.private.OpenPvpMiniMapButton = opvp.CreateClass(opvp.MiniMapButton);

function opvp.private.OpenPvpMiniMapButton:init()
    opvp.MiniMapButton.init(self);

    self:setName(opvp.LIB_NAME);

    self:setCompartmentIcon("Interface/Icons/achievement_pvp_legion08");

    if opvp.player.isAlliance() then
        self:setButtonIcon("Interface/Icons/ui_allianceicon-round");
    else
        self:setButtonIcon("Interface/Icons/ui_hordeicon-round");
    end

    self.positionChanged:connect(
        function()
            opvp.options.interface.minimap.position:setValue(
                self:position()
            );
        end
    );

    opvp.options.interface.minimap.enabled.changed:connect(
        function()
            self:setVisible(
                opvp.options.interface.minimap.enabled:value()
            );
        end
    );

    self:register();

    self:setPosition(
        opvp.options.interface.minimap.position:value()
    );

    self:setVisible(opvp.options.interface.minimap.enabled:value());
end

function opvp.private.OpenPvpMiniMapButton:addCurrencyTooltip(tooltip)
    local season_active = opvp.season.isActive();

    --~ tooltip:AddLine(" ");
    tooltip:AddLine(opvp.strs.CURRENCY);

    --~ if season_active == true then
        if opvp.player.isMaxLevel() == true then
            if opvp.Currency.CONQUEST:hasMax() == true then
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        opvp.utils.textureIdMarkup(opvp.Currency.CONQUEST:icon(), 14, 14),
                        opvp.Currency.CONQUEST:name()
                    ),
                    string.format(
                        "%d/%d/%d",
                        opvp.currency.conquest(),
                        opvp.currency.conquestEarned(),
                        opvp.currency.conquestMax()
                    ),
                    1, 1, 1
                );
            else
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        opvp.utils.textureIdMarkup(opvp.Currency.CONQUEST:icon(), 14, 14),
                        opvp.Currency.CONQUEST:name()
                    ),
                    string.format(
                        "%d",
                        opvp.currency.conquest()
                    ),
                    1, 1, 1
                );
            end
        end

        if opvp.Currency.BLOODY_TOKEN:hasMax() == true then
            tooltip:AddDoubleLine(
                string.format(
                    "    %s %s",
                    opvp.utils.textureIdMarkup(opvp.Currency.BLOODY_TOKEN:icon(), 14, 14),
                    opvp.Currency.BLOODY_TOKEN:name()
                ),
                string.format(
                    "%d/%d/%d",
                    opvp.currency.bloodyToken(),
                    opvp.currency.bloodyTokenEarned(),
                    opvp.currency.bloodyTokenMax()
                ),
                1, 1, 1
            );
        else
            tooltip:AddDoubleLine(
                string.format(
                    "    %s %s",
                    opvp.utils.textureIdMarkup(opvp.Currency.BLOODY_TOKEN:icon(), 14, 14),
                    opvp.Currency.BLOODY_TOKEN:name()
                ),
                string.format(
                    "%d",
                    opvp.currency.bloodyToken()
                ),
                1, 1, 1
            );
        end
    --~ end

    tooltip:AddDoubleLine(
        string.format(
            "    %s %s",
            opvp.utils.textureIdMarkup(opvp.Currency.HONOR:icon(), 14, 14),
            opvp.Currency.HONOR:name()
        ),
        string.format(
            "%d/%d",
            opvp.currency.honor(),
            opvp.currency.honorMax()
        ),
        1, 1, 1
    );
end

function opvp.private.OpenPvpMiniMapButton:addHonorableKillsTooltip(tooltip)
    --~ tooltip:AddLine(" ");
    tooltip:AddLine(opvp.strs.HONORABLE_KILLS);

    tooltip:AddDoubleLine(
        "    " .. opvp.strs.LIFETIME,
        opvp.player.honorKillsLifetime(),
        1, 1, 1
    );

    tooltip:AddDoubleLine(
        "    " .. opvp.strs.TODAY,
        opvp.player.honorKillsToday(),
        1, 1, 1
    );

    tooltip:AddDoubleLine(
        "    " .. opvp.strs.YESTERDAY,
        opvp.player.honorKillsPrevDay(),
        1, 1, 1
    );
end

function opvp.private.OpenPvpMiniMapButton:addEventsTooltip(tooltip)
    local epoch    = GetServerTime();
    local timespec = C_DateAndTime.GetCalendarTimeFromEpoch(epoch * 1000000);
    local events   = opvp.calendar.findPvpEvents(timespec);

    if #events == 0 then
        return;
    end

    tooltip:AddLine(opvp.strs.EVENTS);

    for n, event in ipairs(events) do
        tooltip:AddDoubleLine(
            "    " .. event.title,
            opvp.time.formatSeconds(time(event.endTime) - epoch),
            1, 1, 1
        );
    end
end

function opvp.private.OpenPvpMiniMapButton:addMatchTooltip(tooltip)
    local match = opvp.match.current();

    if match == nil then
        return;
    end

    self:addMatchInfoTooltip(match, tooltip);

    if match:isBattleground() == true then
        self:addMatchBattlegroundTooltip(match, tooltip);
    elseif match:isShuffle() == true then
        self:addMatchShuffleTooltip(match, tooltip);
    end
end

function opvp.private.OpenPvpMiniMapButton:addMatchBattlegroundTooltip(match, tooltip)
    local players, cls, spec;

    if match:isActive() == true then
        players = opvp.party.utils.sortMembersByRoleStat(match:teammates());
    else
        players = opvp.party.utils.sortMembersByRole(match:teammates());
    end

    local active = match:isActive();
    local complete = match:isComplete();

    local player_team_name;
    local enemy_team_name;

    --~ talenttree-horde-cornerlogo
    --~ talenttree-alliance-cornerlogo
    --~ QuestPortraitIcon-Horde
    --~ QuestPortraitIcon-Alliance
    --~ charcreatetest-logo-alliance
    --~ charcreatetest-logo-horde

    if opvp.match.faction() == opvp.ALLIANCE or (match:isTest() == true and opvp.player.isAlliance()) then
        player_team_name = opvp.Faction.ALLIANCE:colorString(opvp.Faction.ALLIANCE:name());
        enemy_team_name  = opvp.Faction.HORDE:colorString(opvp.Faction.HORDE:name());
    else
        player_team_name = opvp.Faction.HORDE:colorString(opvp.Faction.HORDE:name());
        enemy_team_name  = opvp.Faction.ALLIANCE:colorString(opvp.Faction.ALLIANCE:name());
    end

    if #players > 0 then
        tooltip:AddLine(
            string.format(
                "%s (cr=%d | mmr=%d)",
                player_team_name,
                match:playerTeam():cr(),
                match:playerTeam():mmr()
            )
        );

        for i, member in pairs(players) do
            cls = member:classInfo();
            spec = member:specInfo();

            if active == true then
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "kb=%d | deaths=%d | dmg=%s | healing=%s",
                        member:kills(),
                        member:deaths(),
                        opvp.utils.numberToStringShort(member:damage(), 1),
                        opvp.utils.numberToStringShort(member:healing(), 1)
                    ),
                    1, 1, 1
                );
            elseif complete == true then
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "cr=%d/%d/%s | mmr=%d/%d/%s",
                        member:cr(),
                        member:cr() + member:crGain(),
                        opvp.utils.colorNumberPosNeg(
                            member:crGain(),
                            0.25,
                            1,
                            0.25,
                            1,
                            0.25,
                            0.25
                        ),
                        member:mmr(),
                        member:mmr() + member:mmrGain(),
                        opvp.utils.colorNumberPosNeg(
                            member:mmrGain(),
                            0.25,
                            1,
                            0.25,
                            1,
                            0.25,
                            0.25
                        )
                    ),
                    1, 1, 1
                );
            else
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "cr=%d",
                        member:cr()
                    ),
                    1, 1, 1
                );
            end
        end
    end

    if match:isActive() == true then
        players = opvp.party.utils.sortMembersByRoleStat(match:opponents());
    else
        players = opvp.party.utils.sortMembersByRole(match:opponents());
    end

    if #players > 0 then
        tooltip:AddLine(
            string.format(
                "%s (cr=%d | mmr=%d)",
                enemy_team_name,
                match:opponentTeam():cr(),
                match:opponentTeam():mmr()
            )
        );

        for i, member in pairs(players) do
            cls = member:classInfo();
            spec = member:specInfo();

            if active == true then
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "kb=%d | deaths=%d | dmg=%s | healing=%s",
                        member:kills(),
                        member:deaths(),
                        opvp.utils.numberToStringShort(member:damage(), 1),
                        opvp.utils.numberToStringShort(member:healing(), 1)
                    ),
                    1, 1, 1
                );
            elseif complete == true then
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "cr=%d/%d/%s | mmr=%d/%d/%s",
                        member:cr(),
                        member:cr() + member:crGain(),
                        opvp.utils.colorNumberPosNeg(
                            member:crGain(),
                            0.25,
                            1,
                            0.25,
                            1,
                            0.25,
                            0.25
                        ),
                        member:mmr(),
                        member:mmr() + member:mmrGain(),
                        opvp.utils.colorNumberPosNeg(
                            member:mmrGain(),
                            0.25,
                            1,
                            0.25,
                            1,
                            0.25,
                            0.25
                        )
                    ),
                    1, 1, 1
                );
            else
                tooltip:AddDoubleLine(
                    string.format(
                        "    %s %s",
                        spec:role():icon(),
                        member:nameOrId(true)
                    ),
                    string.format(
                        "cr=%d",
                        member:cr()
                    ),
                    1, 1, 1
                );
            end
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addMatchInfoTooltip(match, tooltip)
    tooltip:AddLine(
        string.format(
            "%s (%s)",
            match:name(),
            match:mapName()
        )
    );

    if match:isBattleground() == true then
        tooltip:AddLine(
            string.gsub(
                match:map():descriptionPvpLong(),
                "-",
                "    -"
            ),
            1, 1, 1
        );
    end
end

function opvp.private.OpenPvpMiniMapButton:addMatchShuffleTooltip(match, tooltip)
    local players = opvp.party.utils.sortMembersByRole(match:players());

    if #players == 0 then
        return;
    end

    tooltip:AddLine(opvp.strs.PLAYERS);

    local cls, spec, stat, wins;

    for i, member in pairs(players) do
        cls = member:classInfo();
        spec = member:specInfo();
        stat = member:findStatById(opvp.PvpStatId.ROUNDS_WON);

        if stat ~= nil then
            wins = stat:value();
        else
            wins = 0;
        end

        tooltip:AddDoubleLine(
            string.format(
                "    %s %s",
                spec:role():icon(),
                member:nameOrId(true)
            ),
            string.format(
                "wins=%d | cr=%d | mmr=%d",
                wins,
                member:cr(),
                member:mmr()
            ),
            1, 1, 1
        );
    end
end

function opvp.private.OpenPvpMiniMapButton:addEventsUpcomingTooltip(tooltip)
    local events    = opvp.List();
    local epoch     = GetServerTime();
    local timespec  = C_DateAndTime.AdjustTimeByDays(
        C_DateAndTime.GetCalendarTimeFromEpoch(
            C_DateAndTime.GetWeeklyResetStartTime() * 1000000
        ),
        7
    );

    local max_index;

    if (C_DateAndTime.GetWeeklyResetStartTime() + (86400 * 7)) - epoch < (86400 * 2) then
        max_index = 3;
    else
        max_index = 2;
    end

    for i=1, max_index do
        events:merge(opvp.calendar.findPvpEvents(timespec));

        timespec = C_DateAndTime.AdjustTimeByDays(timespec, 7);
    end

    tooltip:AddLine(opvp.strs.EVENTS_UPCOMING);

    local event;
    local start_time;

    for n=1, events:size() do
        event = events:item(n);

        start_time = time(event.startTime);

        if start_time - epoch < 86400 then
            tooltip:AddDoubleLine(
                "    " .. event.title,
                opvp.time.formatSeconds(start_time - epoch),
                1, 1, 1
            );
        else
            tooltip:AddDoubleLine(
                "    " .. event.title,
                opvp.time.formatDays(start_time - epoch),
                1, 1, 1
            );
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addQueueInfoTooltip(tooltip)
    --~ tooltip:AddLine(" ");
    tooltip:AddLine(opvp.strs.QUEUES);

    local queues = {
        opvp.Queue.RANDOM_BATTLEGROUND,
        opvp.Queue.RANDOM_EPIC_BATTLEGROUND,
        opvp.Queue.ARENA_SKIRMISH,
        opvp.Queue.BRAWL,
        opvp.Queue.EVENT,
        opvp.Queue.SHUFFLE,
        opvp.Queue.BLITZ,
        opvp.Queue.ARENA_2V2,
        opvp.Queue.ARENA_3V3,
        opvp.Queue.RATED_BATTLEGROUND
    };

    local queue;

    local check_yes = opvp.utils.textureAtlastMarkup("common-icon-checkmark", 14, 14);
    local check_no = opvp.utils.textureAtlastMarkup("common-icon-redx", 14, 14);

    for n=1, #queues do
        queue = queues[n];

        if queue:canQueue() == true then
            local bonuses = opvp_role_markups(queue);

            tooltip:AddDoubleLine(
                "    " .. queue:name(),
                string.format(
                    "%s%s",
                    bonuses,
                    queue:hasDailyWin() and check_yes or check_no
                ),
                1, 1, 1
            );
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addQuestsTooltip(tooltip)
    local quests = opvp.questlog.pvpQuests();

    if #quests == 0 then
        return;
    end

    tooltip:AddLine(opvp.strs.QUESTS);

    local extra;

    for _, quest in pairs(quests) do
        if quest:isDaily() == true then
            extra = " | " .. opvp.time.formatSeconds(C_DateAndTime.GetSecondsUntilDailyReset());
        elseif quest:isWeekly() == true or quest:classification() == opvp.QuestClassification.RECURRING then
            extra = " | " .. opvp.time.formatSeconds(C_DateAndTime.GetSecondsUntilWeeklyReset());
        else
            extra = "";
        end

        tooltip:AddDoubleLine(
            string.format(
                "    %s %s",
                opvp.utils.textureAtlastMarkup(quest:icon(true), 14, 14),
                quest:name()
            ),
            string.format(
                "%s%s",
                quest:isComplete() == true and opvp.strs.QUEST_READY_FOR_TURN_IN or opvp.strs.IN_PROGRESS,
                extra
            ),
            1, 1, 1
        );
    end
end

function opvp.private.OpenPvpMiniMapButton:addQueueBonusTooltip(tooltip)

    local queues = {
        opvp.Queue.RANDOM_BATTLEGROUND,
        opvp.Queue.RANDOM_EPIC_BATTLEGROUND,
        opvp.Queue.ARENA_SKIRMISH,
        opvp.Queue.BRAWL,
        opvp.Queue.EVENT,
        opvp.Queue.SHUFFLE,
        opvp.Queue.BLITZ
    };

    local queue;

    local has_line = false;

    local check_yes = opvp.utils.textureAtlastMarkup("common-icon-checkmark", 14, 14);
    local check_no = opvp.utils.textureAtlastMarkup("common-icon-redx", 14, 14);

    for n=1, #queues do
        queue = queues[n];

        if queue:canQueue() == true then
            local roles = opvp_role_markups(queue);

            if roles ~= "" then
                if has_line == false then
                    --~ tooltip:AddLine(" ");
                    tooltip:AddLine(opvp.strs.QUEUE_BONUSES);

                    has_line = true;
                end

                tooltip:AddDoubleLine(
                    "    " .. queue:name(),
                    roles,
                    1, 1, 1
                );
            end
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addRatingTooltip(tooltip)
    --~ local season_active = opvp.season.isActive();

    --~ if season_active == false then
        --~ return;
    --~ end

    if opvp.player.isMaxLevel() == false then
        return;
    end

    tooltip:AddLine(opvp.strs.CURRENT_RATING);

    local brackets = {
        opvp.RatingBracket.SHUFFLE,
        opvp.RatingBracket.BLITZ,
        opvp.RatingBracket.ARENA_2V2,
        opvp.RatingBracket.ARENA_3V3,
        opvp.RatingBracket.RBG
    };

    local bracket;
    local rating_info;
    local text;
    local icon;
    local avg;

    for n=1, #brackets do
        bracket = brackets[n];
        info = bracket:ratingInfo();

        if info.rating ~= 0 then
            if info.season_played > 0 and info.season_wins > 0 then
                avg = info.season_wins / info.season_played;
            else
                avg = 0;
            end

            tooltip:AddDoubleLine(
                "    " .. bracket:name(),
                string.format(
                    "%s %s (%d%%)",
                    opvp.utils.textureIdMarkup(bracket:tierIcon(), 16, 16),
                    info.rating,
                    100 * avg
                ),
                1, 1, 1
            );
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addSeasonRewardTooltip(tooltip)
    local season_active = opvp.season.isActive();

    if season_active == false then
        return;
    end

    local achiev = opvp.season.achievementId();
    local reward_id = C_AchievementInfo.GetRewardItemID(achiev);
    local prog, req = opvp.season.achievementProgress();

    if (
        reward_id == nil or
        (
            reward_id == 103533 and
            opvp.options.interface.minimap.tooltip.seasonRewardExcludeSaddle:value() == true
        )
    ) then
        return;
    end

    tooltip:AddLine(opvp.strs.SEASON_REWARD);

    local icon = C_Item.GetItemIconByID(reward_id);
    local name = C_Item.GetItemNameByID(reward_id);

    if name ~= nil and icon ~= nil then
        tooltip:AddDoubleLine(
            string.format(
                "    %s %s",
                opvp.utils.textureIdMarkup(icon, 14, 14),
                name
            ),
            string.format(
                "%d/%d",
                prog,
                req
            ),
            1, 1, 1
        );
    else
        tooltip:AddDoubleLine(
            string.format(
                "    %s",
                opvp.strs.UNKNOWN
            ),
            string.format(
                "%d/%d",
                prog,
                req
            ),
            1, 1, 1
        );
    end

    --~ GameTooltip_ShowProgressBar(tooltip, 0, req, prog, FormatPercentage(prog / req));
end

function opvp.private.OpenPvpMiniMapButton:findPvpCalendarEvents(refTime)
    local cal_state = C_Calendar.GetMonthInfo();

    C_Calendar.SetAbsMonth(refTime.month, refTime.year);

    local events       = {};
    local events_size  = C_Calendar.GetNumDayEvents(0, refTime.monthDay);

    if events_size == 0 then
        C_Calendar.SetAbsMonth(cal_state.month, cal_state.year);

        return events;
    end

    refTime.day = refTime.monthDay;

    local event_info;

    for n=1, events_size do
        event_info = C_Calendar.GetDayEvent(0, refTime.monthDay, n);

        if (
            event_info ~= nil and (
                event_info.eventType == Enum.CalendarEventType.PvP or
                opvp_calendar_pvp_event_ids:contains(event_info.eventID) == true
            )
        ) then
            event_info.startTime.day = event_info.startTime.monthDay;
            event_info.endTime.day   = event_info.endTime.monthDay;

            if time(event_info.endTime) > time(refTime) then
                table.insert(
                    events,
                    {
                        event_info.title,
                        time(event_info.startTime),
                        time(event_info.endTime)
                    }
                );
            end
        end
    end

    C_Calendar.SetAbsMonth(cal_state.month, cal_state.year);

    return events;
end

function opvp.private.OpenPvpMiniMapButton:_onEnter(frame)
    if frame == self._frame then
        GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
    else
        GameTooltip:SetOwner(frame, "ANCHOR_NONE");

        GameTooltip:SetPoint("RIGHT", frame, "LEFT", -10, 0)
    end

    GameTooltip:SetCustomLineSpacing(5);

    local season_active = opvp.season.isActive();

    local header = opvp.LIB_NAME;
    local footer = "";

    if season_active == true then
        footer = string.format(
            " - %s %d",
            opvp.strs.SEASON,
            opvp.season.chapter()
        );
    else
        footer = string.format(
            " - %s",
            opvp.strs.OFFSEASON
        );
    end

    GameTooltip:AddLine(
        string.format(
            "%s %s%s",
            opvp.utils.textureIdMarkup("Interface/Icons/achievement_pvp_legion08"),
            header,
            footer
        )
    );

    if (
        opvp.options.interface.minimap.tooltip.scoreboard:value() == true and
        opvp.match.inMatch() == true and
        --~ opvp.match.isTesting() == false and
        opvp.match.isRated() == true
    ) then
        self:addMatchTooltip(GameTooltip);
    else
        if opvp.options.interface.minimap.tooltip.rating:value() == true then
            self:addRatingTooltip(GameTooltip);
        end

        if opvp.options.interface.minimap.tooltip.seasonReward:value() == true then
            self:addSeasonRewardTooltip(GameTooltip);
        end

        if opvp.options.interface.minimap.tooltip.events:value() == true then
            self:addEventsTooltip(GameTooltip);
        end;

        if opvp.options.interface.minimap.tooltip.eventsUpcoming:value() == true then
            self:addEventsUpcomingTooltip(GameTooltip);
        end;

        if opvp.options.interface.minimap.tooltip.quests:value() == true then
            self:addQuestsTooltip(GameTooltip);
        end;

        if opvp.options.interface.minimap.tooltip.queueInfo:value() == true then
            self:addQueueInfoTooltip(GameTooltip);
        end

        if opvp.options.interface.minimap.tooltip.hks:value() == true then
            self:addHonorableKillsTooltip(GameTooltip);
        end

        if opvp.options.interface.minimap.tooltip.currency:value() == true then
            self:addCurrencyTooltip(GameTooltip);
        end
    end

    GameTooltip:Show();
end

function opvp.private.OpenPvpMiniMapButton:_onLeave(frame)
    GameTooltip:Hide();
end

function opvp.private.OpenPvpMiniMapButton:_onMouseClick(button)
    if SettingsPanel:IsVisible() == true then
        if (
            opvp.options.match.category:isShown() == true or
            opvp.options.category:isShown() == true or
            opvp.options.announcements.category:isShown() == true or
            opvp.options.audio.category:isShown() == true or
            opvp.options.interface.category:isShown() == true
        ) then
            SettingsPanel:Hide();
        else
            opvp.options.match.category:show();
        end
    else
        opvp.options.match.category:show();
    end
end

local opvp_minimap_singleton;

local function opvp_minimap_singleton_ctor()
    opvp_minimap_singleton = opvp.private.OpenPvpMiniMapButton();
end

opvp.OnLoginReload:register(opvp_minimap_singleton_ctor);
