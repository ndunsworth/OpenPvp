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

local function opvp_options_interface_init()
    local opvp_test_icon = opvp.utils.textureAtlastMarkup("QuestNormal", 14, 14);

    opvp.options.interface = {};

    opvp.options.interface.category = opvp.options.category:createCategory(
        "Interface",
        "Interface",
        "",
        opvp.OptionCategory.CHILD_CATEGORY
    );

    --~ opvp.options.interface.general = {};

    --~ opvp.options.interface.general.category = opvp.options.interface.category:createCategory(
        --~ "General",
        --~ "General"
    --~ );

    opvp.options.interface.frames = {};

    opvp.options.interface.frames.category = opvp.options.interface.category:createCategory(
        "Frames",
        "Frames"
    );

    opvp.options.interface.frames.playerCastBarDisable = opvp.options.interface.frames.category:createOption(
        opvp.Option.BOOL,
        "DisablePlayerCastBar",
        "Hide Player Cast Bar",
        "Hides your characters cast bar.",
        false
    );

    opvp.options.interface.frames.playerCastBarDisable:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.interface.frames.orderHallCommandBarHide = opvp.options.interface.frames.category:createOption(
        opvp.Option.BOOL,
        "HideOrderHallCommandBar",
        "Hide Order Hall Command Bar",
        "Hides Command Bar located at the top of the screen when in your class Order Hall",
        false
    );

    opvp.options.interface.frames.prestigeBadgesHide = opvp.options.interface.frames.category:createOption(
        opvp.Option.BOOL,
        "HidePrestigeBadges",
        "Hide Prestige Badges",
        "Hides the honor level prestige badge on player frames.",
        false
    );

    opvp.options.interface.frames.moveLossOfControlNotification = opvp.options.interface.frames.category:createOption(
        opvp.Option.BOOL,
        "MoveLossOfControlNotification",
        "Move Loss of Control Notification",
        "Moves the Loss of Control notification higher up your screen.",
        false
    );

    opvp.options.interface.frames.moveLossOfControlNotificationTest = opvp.options.interface.frames.category:createOption(
        opvp.Option.BUTTON,
        "MoveLossOfControlNotificationTest",
        opvp_test_icon,
        "Test Notification"
    );

    opvp.options.interface.frames.moveLossOfControlNotificationTest:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.interface.minimap = {};

    opvp.options.interface.minimap.category = opvp.options.interface.category:createCategory(
        "Minimap",
        "Minimap Button"
    );

    opvp.options.interface.minimap.enabled = opvp.options.interface.minimap.category:createOption(
        opvp.Option.BOOL,
        "Enabled",
        "Enabled",
        "",
        false
    );

    opvp.options.interface.minimap.position = opvp.options.interface.minimap.category:createOption(
        opvp.Option.FLOAT,
        "MinimapPosition",
        "Minimap Position",
        "",
        0
    );

    opvp.options.interface.minimap.position:setFlags(
        opvp.Option.HIDDEN_FLAG,
        true
    );

    opvp.options.interface.minimap.tooltip = {};

    opvp.options.interface.minimap.tooltip.category = opvp.options.interface.minimap.category:createCategory(
        "Tooltip",
        "Tooltip"
    );

    opvp.options.interface.minimap.tooltip.rating = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "CurrentRating",
        "Current Rating",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.seasonReward = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "SeasonReward",
        "Season Reward",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.seasonRewardExcludeSaddle = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "SeasonRewardExcludeSaddle",
        "Ignore Vicious Saddle",
        "Only show when the reward is not a Vicious Saddle",
        false
    );

    opvp.options.interface.minimap.tooltip.seasonRewardExcludeSaddle:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.interface.minimap.tooltip.events = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "Events",
        "Events",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.quests = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "Quests",
        "Quests",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.queueInfo = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "QueueInfo",
        "Queue Info",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.hks = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "HonorableKills",
        "Honorable Kills",
        "",
        true
    );

    opvp.options.interface.minimap.tooltip.currency = opvp.options.interface.minimap.tooltip.category:createOption(
        opvp.Option.BOOL,
        "Currency",
        "Currency",
        "",
        true
    );
end

opvp.OnAddonLoad:register(opvp_options_interface_init);
