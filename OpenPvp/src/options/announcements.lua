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

local function opvp_options_announcements_init()
    local opvp_chat_filter_icon = opvp.utils.textureAtlastMarkup("transmog-icon-chat", 14, 14);
    local opvp_chat_filter_tooltip = "Enabling a feature may remove system chat messages (marked with " .. opvp_chat_filter_icon ..")";

    opvp.options.announcements = {};

    opvp.options.announcements.category = opvp.options.category:createCategory(
        "Announcements",
        "Announcements",
        "",
        opvp.OptionCategory.CHILD_CATEGORY
    );

    opvp.options.announcements.general = {};

    opvp.options.announcements.general.category = opvp.options.announcements.category:createCategory(
        "General",
        "General"
    );

    opvp.options.announcements.general.lastLogin = opvp.options.announcements.general.category:createOption(
        opvp.Option.BOOL,
        "LastLogin",
        "Last Login",
        "",
        false
    );

    opvp.options.announcements.general.profileLoaded = opvp.options.announcements.general.category:createOption(
        opvp.Option.BOOL,
        "ProfileChanged",
        "Profile Changed",
        "",
        false
    );

    opvp.options.announcements.match = {};

    opvp.options.announcements.match.category = opvp.options.announcements.category:createCategory(
        "Match",
        "Match",
        opvp_chat_filter_tooltip
    );

    opvp.options.announcements.match.enter = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "Enter",
        "Enter",
        "",
        false
    );

    opvp.options.announcements.match.join = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "Join",
        "Join",
        "",
        false
    );

    opvp.options.announcements.match.join:setFlags(
        opvp.Option.HIDDEN_FLAG,
        true
    );

    opvp.options.announcements.match.roundWarmup = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "RoundWarmup",
        "Round Warmup",
        "",
        false
    );

    opvp.options.announcements.match.roundWarmupCountdown = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "RoundWarmupCountdown",
        "Round Warmup Countdown",
        "",
        false
    );

    opvp.options.announcements.match.roundWarmupCountdownIcon = opvp.options.announcements.match.category:createOption(
        opvp.Option.LABEL,
        "RoundWarmupCountdownIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.match.roundWarmupCountdownIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.match.roundActive = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "RoundActive",
        "Round Active",
        "",
        false
    );

    opvp.options.announcements.match.roundComplete = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "RoundComplete",
        "Round Complete",
        "",
        false
    );

    opvp.options.announcements.match.complete = opvp.options.announcements.match.category:createOption(
        opvp.Option.BOOL,
        "Complete",
        "Complete",
        "",
        false
    );

    opvp.options.announcements.player = {};

    opvp.options.announcements.player.category = opvp.options.announcements.category:createCategory(
        "Player",
        "Player"
    );

    opvp.options.announcements.player.currentRating = opvp.options.announcements.player.category:createOption(
        opvp.Option.BOOL,
        "LoginCurrentRating",
        "Current Bracket Ratings",
        "Prints your season high and current rating for all active brackets in the Chat Window on Login.",
        false
    );

    opvp.options.announcements.player.pvpCurrencyCapped = opvp.options.announcements.player.category:createOption(
        opvp.Option.BOOL,
        "PvpCurrencyCapped",
        "Pvp Currency Capped",
        "Notifies you when a pvp currency is capped.",
        true
    );

    opvp.options.announcements.player.specChanged = opvp.options.announcements.player.category:createOption(
        opvp.Option.BOOL,
        "SpecChanged",
        "Spec Changed",
        "Prints your Class Specialization in the Chat Window when switching specs.",
        false
    );

    opvp.options.announcements.player.trinketReady = opvp.options.announcements.player.category:createOption(
        opvp.Option.BOOL,
        "TrinketReady",
        "Trinket Ready",
        "",
        false
    );

    opvp.options.announcements.player.trinketUsed = opvp.options.announcements.player.category:createOption(
        opvp.Option.BOOL,
        "TrinketUsed",
        "Trinket Used",
        "",
        false
    );

    opvp.options.announcements.friendlyParty = {};

    opvp.options.announcements.friendlyParty.category = opvp.options.announcements.category:createCategory(
        "FriendlyParty",
        "Party (Player)",
        opvp_chat_filter_tooltip
    );

    opvp.options.announcements.friendlyParty.typeChanged = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "TypeChanged",
        "Convert to Party/Raid",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.typeChangedIcon = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.LABEL,
        "TypeChangedIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.friendlyParty.typeChangedIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.friendlyParty.difficultyChanged = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "DifficultyChanged",
        "Difficulty Changed",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.difficultyChangedIcon = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.LABEL,
        "DifficultyChangedIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.friendlyParty.difficultyChangedIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.friendlyParty.joinLeave = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "JoinLeave",
        "Join/Leave",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.joinLeaveIcon = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.LABEL,
        "JoinLeaveIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.friendlyParty.joinLeaveIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.friendlyParty.memberDeath = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "Death",
        "Member Death",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.memberDeathIcon = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.LABEL,
        "DeathIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.friendlyParty.memberDeathIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.friendlyParty.memberJoinLeave = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "MemberJoinLeave",
        "Member Join/Leave",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.memberJoinLeaveIcon = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.LABEL,
        "MemberJoinLeaveIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.friendlyParty.memberJoinLeaveIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.friendlyParty.memberSpecUpdate = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "MemberSpecUpdate",
        "Member Spec Update",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.memberTrinket = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "MemberTrinketUsed",
        "Member Trinket Used",
        "",
        false
    );

    opvp.options.announcements.friendlyParty.pullTimer = opvp.options.announcements.friendlyParty.category:createOption(
        opvp.Option.BOOL,
        "PullTimer",
        "Pull Timer",
        "",
        false
    );

    opvp.options.announcements.hostileParty = {};

    opvp.options.announcements.hostileParty.category = opvp.options.announcements.category:createCategory(
        "HostileParty",
        "Party (Enemy)"
    );

    opvp.options.announcements.hostileParty.memberDeath = opvp.options.announcements.hostileParty.category:createOption(
        opvp.Option.BOOL,
        "Death",
        "Member Death",
        "",
        false
    );

    opvp.options.announcements.hostileParty.memberJoinLeave = opvp.options.announcements.hostileParty.category:createOption(
        opvp.Option.BOOL,
        "MemberJoinLeave",
        "Member Join/Leave",
        "",
        false
    );

    opvp.options.announcements.hostileParty.memberSpecUpdate = opvp.options.announcements.hostileParty.category:createOption(
        opvp.Option.BOOL,
        "MemberSpecUpdate",
        "Member Spec Update",
        "",
        false
    );

    opvp.options.announcements.hostileParty.memberTrinket = opvp.options.announcements.hostileParty.category:createOption(
        opvp.Option.BOOL,
        "MemberTrinketUsed",
        "Member Trinket Used",
        "",
        false
    );

    opvp.options.announcements.queue = {};

    opvp.options.announcements.queue.category = opvp.options.announcements.category:createCategory(
        "Queue",
        "Queue",
        opvp_chat_filter_tooltip
    );

    opvp.options.announcements.queue.joinLeave = opvp.options.announcements.queue.category:createOption(
        opvp.Option.BOOL,
        "JoinLeave",
        "Join/Leave",
        "",
        false
    );

    opvp.options.announcements.queue.joinLeaveIcon = opvp.options.announcements.queue.category:createOption(
        opvp.Option.LABEL,
        "JoinLeaveIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.queue.joinLeaveIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.queue.ready = opvp.options.announcements.queue.category:createOption(
        opvp.Option.BOOL,
        "Ready",
        "Ready",
        "",
        false
    );

    opvp.options.announcements.queue.readyIcon = opvp.options.announcements.queue.category:createOption(
        opvp.Option.LABEL,
        "ReadyIcon",
        opvp_chat_filter_icon
    );

    opvp.options.announcements.queue.readyIcon:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.announcements.queue.suspended = opvp.options.announcements.queue.category:createOption(
        opvp.Option.BOOL,
        "Suspended",
        "Suspended",
        "",
        false
    );
end

opvp.OnAddonLoad:register(opvp_options_announcements_init);
