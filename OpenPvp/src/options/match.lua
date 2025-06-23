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

local function opvp_options_match_init()
    opvp.options.match = {};

    opvp.options.match.category = opvp.options.category:createCategory(
        "Match",
        "Match",
        "",
        opvp.OptionCategory.CHILD_CATEGORY
    );

    opvp.options.match.general = {};

    opvp.options.match.general.category = opvp.options.match.category:createCategory(
        "General",
        "General",
        ""
    );

    opvp.options.match.general.blockPartyInvite = opvp.options.match.general.category:createOption(
        opvp.Option.BOOL,
        "BlockPartyInvite",
        "Block Party Invites",
    [[
Auto declines party invites during a Blitz or Shuffle match.

Invites from players on your friends list are allowed.

A whisper is sent to the invitation sender informing them of the reason for the decline.

Adding "%s" anywhere in the message will fill in the name of the match you're currently in.

Setting the message to an empty string will disable the auto reply.
]],
        false
    );

    opvp.options.match.general.blockPartyInviteMessage = opvp.options.match.general.category:createOption(
        opvp.Option.STRING,
        "BlockPartyInviteMsg",
        "Message",
        "Response message sent to the declined invitation sender",
        "I'm currently in a %s match. Your invite was auto declined."
    );

    opvp.options.match.general.blockPartyInviteMessage:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.match.general.focusIndicator = opvp.options.match.general.category:createOption(
        opvp.Option.BOOL,
        "FocusIndicator",
        "Focus Indicator",
        "Displays a focus indicator bar next to enemy Arena party frames.",
        true
    );

    --~ opvp.options.match.general.muteNPCDialog = opvp.options.match.general.category:createOption(
        --~ opvp.Option.BOOL,
        --~ "MuteNPCDialog",
        --~ "Mute NPC Dialog",
--~ [[
--~ Adds NPC dialog for select Arenas to the games MuteSoundFile list and filters chat messages.

--~ Does not alter the volume of any sound channels.

--~ Arenas:
    --~ - Cage of Carnage
    --~ - Enigma Crucible
    --~ - Hook Point
    --~ - Mugambala Arena
    --~ - Nokhudon Proving Grounds

--~ Chat Messages Filtered:
    --~ - CHAT_MSG_RAID_BOSS_EMOTE
    --~ - CHAT_MSG_MONSTER_EMOTE
    --~ - CHAT_MSG_MONSTER_PARTY
    --~ - CHAT_MSG_MONSTER_SAY
    --~ - CHAT_MSG_MONSTER_WHISPER
    --~ - CHAT_MSG_MONSTER_YELL
    --~ - CHAT_MSG_RAID_BOSS_EMOTE
    --~ - CHAT_MSG_RAID_BOSS_WHISPER
--~ ]]
    --~ ,
        --~ true
    --~ );

    opvp.options.match.general.screenshotShuffleRound = opvp.options.match.general.category:createOption(
        opvp.Option.BOOL,
        "ScreenshotShuffleRound",
        "Screenshot Shuffle Round",
        "Screenshot on Shuffle round completion",
        false
    );

    opvp.options.match.general.screenshotMatch = opvp.options.match.general.category:createOption(
        opvp.Option.BOOL,
        "ScreenshotScoreboard",
        "Screenshot Scoreboard",
        "Screenshot scoreboard on Match completion",
        false
    );

    opvp.options.match.chat = {};

    opvp.options.match.chat.category = opvp.options.match.category:createCategory(
        "Chat",
        "Chat"
    );

    opvp.options.match.chat.disable = opvp.options.match.chat.category:createOption(
        opvp.Option.BOOL,
        "DisableChat",
        "Disable ",
        "Disables chat during a Blitz or Shuffle match.",
        false
    );

    opvp.options.match.chat.mute = opvp.options.match.chat.category:createOption(
        opvp.Option.BOOL,
        "MuteChat",
        "Mute ",
    [[
Filters chat messages during a Blitz or Shuffle match.

Messages by match participants are silently dropped giving the appearance of having chat disabled.

Your own messages and match participants on your friends list are unaffected by the filter.

Chat Messages Filtered:
    - CHAT_MSG_EMOTE
    - CHAT_MSG_INSTANCE_CHAT
    - CHAT_MSG_INSTANCE_CHAT_LEADER
    - CHAT_MSG_PARTY
    - CHAT_MSG_PARTY_LEADER
    - CHAT_MSG_RAID
    - CHAT_MSG_RAID_LEADER
    - CHAT_MSG_SAY
    - CHAT_MSG_TEXT_EMOTE
    - CHAT_MSG_WHISPER
    - CHAT_MSG_YELL
]],
        false
    );

    opvp.options.match.chat.filterAddonSpam = opvp.options.match.chat.category:createOption(
        opvp.Option.BOOL,
        "FilterAddonChatSpam",
        "Filter Addon Spam",
    [[
Filters chat spam produced by third party addons.

Example Chat Messages:
    - DRINKING: Nrgy (Priest)
    - LOW HEALTH: Noobpwnerqt (Rogue)
    - RESURRECTING: Nrgy (Priest)
    - Enemy Spec: Noobpwnerqt (Rogue/Assasination)

Chat Messages Filtered:
    - CHAT_MSG_BATTLEGROUND
    - CHAT_MSG_BATTLEGROUND_LEADER
    - CHAT_MSG_INSTANCE_CHAT
    - CHAT_MSG_INSTANCE_CHAT_LEADER
    - CHAT_MSG_PARTY
    - CHAT_MSG_PARTY_LEADER
    - CHAT_MSG_RAID
    - CHAT_MSG_RAID_LEADER
    - CHAT_MSG_RAID_WARNING
    - CHAT_MSG_SAY
    - CHAT_MSG_YELL
]],
        false
    );

    opvp.options.match.layout = {};

    opvp.options.match.layout.category = opvp.options.match.category:createCategory(
        "Layout",
        "Layout",
        ""
    );

    opvp.options.match.layout.layoutArena = opvp.options.match.layout.category:createOption(
        opvp.Option.LAYOUT,
        "LayoutArena",
        opvp.strs.ARENA,
[[
Upon entering an Arena switches the current UI Layout to the one selected.

Exiting the Arena will revert back to the previously active Layout.

Selecting "- none -" will disable this feature for Arena.
]]
    );

    opvp.options.match.layout.layoutArena:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.layout.layoutBattleground = opvp.options.match.layout.category:createOption(
        opvp.Option.LAYOUT,
        "LayoutBattleground",
        opvp.strs.BATTLEGROUND,
[[
Upon entering a Battleground switches the current UI Layout to the one selected.

Exiting the Battleground will revert back to the previously active Layout.

Selecting "- none -" will disable this feature for Battlegrounds.
]]
    );

    opvp.options.match.layout.layoutBattleground:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.layout.layoutBattleground:setFlags(
        opvp.Option.NEW_LINE_FLAG,
        false
    );

    opvp.options.match.actionbars = {};

    opvp.options.match.actionbars.category = opvp.options.match.category:createCategory(
        "ActionBars",
        opvp.strs.ACTION_BARS,
        "Active only while match is in progress (gates open)"
    );

    opvp.options.match.actionbars.hideActionBar1 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar1",
        "Hide Action Bar 1",
        "Hides Action Bar 1 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar1:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar1:setFlags(
        opvp.Option.HIDDEN_FLAG,
        true
    );

    opvp.options.match.actionbars.hideActionBar2 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar2",
        "Hide Action Bar 2",
        "Hides Action Bar 2 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar2:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar3 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar3",
        "Hide Action Bar 3",
        "Hides Action Bar 3 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar3:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar4 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar4",
        "Hide Action Bar 4",
        "Hides Action Bar 4 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar4:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar5 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar5",
        "Hide Action Bar 5",
        "Hides Action Bar 5 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar5:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar6 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar6",
        "Hide Action Bar 6",
        "Hides Action Bar 6 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar6:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar7 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar7",
        "Hide Action Bar 7",
        "Hides Action Bar 7 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar7:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.actionbars.hideActionBar8 = opvp.options.match.actionbars.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideActionBar8",
        "Hide Action Bar 8",
        "Hides Action Bar 8 during a pvp match."
    );

    opvp.options.match.actionbars.hideActionBar8:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames = {};

    opvp.options.match.frames.category = opvp.options.match.category:createCategory(
        "Frames",
        opvp.strs.FRAMES,
        "Active only while match is in progress (gates open)"
    );

    opvp.options.match.frames.hideBagBar = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideBagBar",
        "Hide Bag Bar",
        "Hides the Bag Bar during a pvp match."
    );

    opvp.options.match.frames.hideBagBar:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideChat = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideChat",
        "Hide Chat",
        "Hides the Chat window during a pvp match."
    );

    opvp.options.match.frames.hideHonorBar = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideHonorBar",
        "Hide Honor Bar",
        "Hides the Honor Bar during a pvp match."
    );

    --~ opvp.options.match.frames.hideHonorBar:setFlags(
        --~ opvp.Option.LOCKED_DURING_COMBAT,
        --~ true
    --~ );

    opvp.options.match.frames.hideMicroMenu = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideMicroMenu",
        "Hide Micro Menu",
        "Hides the Micro Menu during a pvp match."
    );

    opvp.options.match.frames.hideMicroMenu:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideMinimap = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideMinimap",
        "Hide Minimap",
        "Hides the Minimap during a pvp match."
    );

    opvp.options.match.frames.hideObjTracker = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideObjTracker",
        "Hide Objective Tracker",
        "Hides the Objective Tracker during a pvp match.\n\nThe Object Tracker is the frame that displays tracked Quest information."
    );

    opvp.options.match.frames.hideObjTracker:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideRaidFrameManager = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideRaidFrameManager",
        "Hide Raid Frame Manager",
        "Hides the Raid Frame Manager during a pvp match."
    );

    opvp.options.match.frames.hideRaidFrameManager:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideTooltips = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideTooltips",
        "Hide Tooltips",
        "Hides Tooltips during a pvp match."
    );

    opvp.options.match.frames.hideTooltips:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hidePlayerFrame = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HidePlayerFrame",
        "Hide Player Frame",
        "Hides the Player Frame during a pvp match.",
        "never"
    );

    opvp.options.match.frames.hidePlayerFrame:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideTargetFrame = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideTargetFrame",
        "Hide Target Frame",
        "Hides the Target Frame during a pvp match.",
        "never"
    );

    opvp.options.match.frames.hideTargetFrame:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.frames.hideFocusFrame = opvp.options.match.frames.category:createOption(
        opvp.Option.MATCH_TYPE,
        "HideFocusFrame",
        "Hide Focus Frame ",
        "Hides the Focus Frame during a pvp match.",
        "never"
    );

    opvp.options.match.frames.hideFocusFrame:setFlags(
        opvp.Option.LOCKED_DURING_COMBAT,
        true
    );

    opvp.options.match.muteNPCDialog = {};

    opvp.options.match.muteNPCDialog.category = opvp.options.match.category:createCategory(
        "MuteNPCDialog",
        "Mute NPC Dialog"
    );

    opvp.options.match.muteNPCDialog.maps = opvp.options.match.muteNPCDialog.category:createOption(
        opvp.Option.STRINGMASK,
        "Maps",
        "",
        "",
        {
            opvp.Map.CAGE_OF_CARNAGE:name(),
            opvp.Map.ENIGMA_CRUCIBLE:name(),
            opvp.Map.HOOK_POINT:name(),
            opvp.Map.MUGAMBALA_ARENA:name(),
            opvp.Map.NOKHUDON_PROVING_GROUNDS:name()
        },
        3,
        0
    );
end

opvp.OnAddonLoad:register(opvp_options_match_init);
