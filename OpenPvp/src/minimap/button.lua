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

local opvp_calendar_pvp_event_ids = opvp.List:createFromArray(
    {
         561, -- Arena Skirmish Bonus Event
         563, -- Battleground Bonus Event
         666, -- PvP Brawl: Arathi Blizzard
        1452, -- PvP Brawl: Battleground Blitz
        1120, -- PvP Brawl: Classic Ashran
        1235, -- PvP Brawl: Comp Stomp
        1047, -- PvP Brawl: Cooking Impossible
         702, -- PvP Brawl: Deep Six
        1240, -- PvP Brawl: Deepwind Dunk
         663, -- PvP Brawl: Gravity Lapse
         667, -- PvP Brawl: Packed House
        1233, -- PvP Brawl: Shado-Pan Showdown
        1311, -- PvP Brawl: Solo Shuffle
         662, -- PvP Brawl: Southshore vs. Tarren Mill
        1170, -- PvP Brawl: Temple of Hotmogu
         664  -- PvP Brawl: Warsong Scramble
    }
);

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

    self:setName("OpenPvp");

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

function opvp.private.OpenPvpMiniMapButton:addEventsTooltip(tooltip)
    local timespec = C_DateAndTime.GetCurrentCalendarTime();

    local events_size = C_Calendar.GetNumDayEvents(0, timespec.monthDay);

    if events_size == 0 then
        return;
    end

    tooltip:AddLine(opvp.strs.EVENTS);

    timespec.day = timespec.monthDay;

    local cur_time = time(timespec);
    local event_info;

    for n=1, events_size do
        event_info = C_Calendar.GetDayEvent(0, timespec.monthDay, n);

        if (
            event_info.eventType == Enum.CalendarEventType.PvP or
            opvp_calendar_pvp_event_ids:contains(event_info.eventID) == true
        ) then
            event_info.endTime.day = event_info.endTime.monthDay;

            local expires = time(event_info.endTime) - cur_time;

            if expires > 0 then
                tooltip:AddDoubleLine(
                    "    " .. event_info.title,
                    opvp.time.formatSeconds(expires),
                    1, 1, 1
                );
            end
        end
    end
end

function opvp.private.OpenPvpMiniMapButton:addCurrencyTooltip(tooltip)
    local season_active = opvp.season.isActive();

    --~ tooltip:AddLine(" ");
    tooltip:AddLine(opvp.strs.CURRENCY);

    --~ if season_active == true then
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

function opvp.private.OpenPvpMiniMapButton:addRatingTooltip(tooltip)
    --~ local season_active = opvp.season.isActive();

    --~ if season_active == false then
        --~ return;
    --~ end

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

    for n=1, #brackets do
        bracket = brackets[n];
        info = bracket:ratingInfo();

        if info.rating ~= 0 then
            tooltip:AddDoubleLine(
                "    " .. bracket:name(),
                string.format(
                    "%s %s",
                    opvp.utils.textureIdMarkup(bracket:tierIcon(), 16, 16),
                    info.rating
                ),
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

function opvp.private.OpenPvpMiniMapButton:addSeasonRewardTooltip(tooltip)
    local season_active = opvp.season.isActive();

    if season_active == false then
        return;
    end

    tooltip:AddLine(opvp.strs.SEASON_REWARD);

    local achiev = opvp.season.achievementId();
    local reward_id = C_AchievementInfo.GetRewardItemID(achiev);
    local prog, req = opvp.season.achievementProgress();

    if reward_id ~= nil then
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
    end

    --~ GameTooltip_ShowProgressBar(tooltip, 0, req, prog, FormatPercentage(prog / req));
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

function opvp.private.OpenPvpMiniMapButton:_onEnter(frame)
    if frame == self._frame then
        GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
    else
        GameTooltip:SetOwner(frame, "ANCHOR_NONE");

        GameTooltip:SetPoint("RIGHT", frame, "LEFT", -10, 0)
    end

    GameTooltip:SetCustomLineSpacing(5);

    local season_active = opvp.season.isActive();

    local header = "OpenPvp";
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

    if opvp.options.interface.minimap.tooltip.rating:value() == true then
        self:addRatingTooltip(GameTooltip);
    end

    if opvp.options.interface.minimap.tooltip.seasonReward:value() == true then
        self:addSeasonRewardTooltip(GameTooltip);
    end
    if opvp.options.interface.minimap.tooltip.events:value() == true then
        self:addEventsTooltip(GameTooltip);
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
