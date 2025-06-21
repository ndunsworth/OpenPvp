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

opvp.ChatType = {
    ACHIEVEMENT           = "ACHIEVEMENT",
    AFK                   = "AFK",
    BATTLEGROUND          = "BATTLEGROUND",
    BATTLEGROUND_LEADER   = "BATTLEGROUND_LEADER",
    BG_SYSTEM_ALLIANCE    = "BG_SYSTEM_ALLIANCE",
    BG_SYSTEM_HORDE       = "BG_SYSTEM_HORDE",
    BG_SYSTEM_NEUTRAL     = "BG_SYSTEM_NEUTRAL",
    CHANNEL               = "CHANNEL",
    CHANNEL_JOIN          = "CHANNEL_JOIN",
    CHANNEL_LEAVE         = "CHANNEL_LEAVE",
    CHANNEL_LIST          = "CHANNEL_LIST",
    CHANNEL_NOTICE        = "CHANNEL_NOTICE",
    CHANNEL_NOTICE_USER   = "CHANNEL_NOTICE_USER",
    CHANNEL1              = "CHANNEL1",
    CHANNEL10             = "CHANNEL10",
    CHANNEL2              = "CHANNEL2",
    CHANNEL3              = "CHANNEL3",
    CHANNEL4              = "CHANNEL4",
    CHANNEL5              = "CHANNEL5",
    CHANNEL6              = "CHANNEL6",
    CHANNEL7              = "CHANNEL7",
    CHANNEL8              = "CHANNEL8",
    CHANNEL9              = "CHANNEL9",
    COMBAT_FACTION_CHANGE = "COMBAT_FACTION_CHANGE",
    COMBAT_HONOR_GAIN     = "COMBAT_HONOR_GAIN",
    COMBAT_MISC_INFO      = "COMBAT_MISC_INFO",
    COMBAT_XP_GAIN        = "COMBAT_XP_GAIN",
    DND                   = "DND",
    EMOTE                 = "EMOTE",
    FILTERED              = "FILTERED",
    GUILD                 = "GUILD",
    GUILD_ACHIEVEMENT     = "GUILD_ACHIEVEMENT",
    IGNORED               = "IGNORED",
    INSTANCE_CHAT         = "INSTANCE_CHAT",
    INSTANCE_CHAT_LEADER  = "INSTANCE_CHAT_LEADER",
    LOOT                  = "LOOT",
    MONEY                 = "MONEY",
    MONSTER_EMOTE         = "MONSTER_EMOTE",
    MONSTER_PARTY         = "MONSTER_PARTY",
    MONSTER_SAY           = "MONSTER_SAY",
    MONSTER_WHISPER       = "MONSTER_WHISPER",
    MONSTER_YELL          = "MONSTER_YELL",
    OFFICER               = "OFFICER",
    OPENING               = "OPENING",
    PARTY                 = "PARTY",
    PARTY_LEADER          = "PARTY_LEADER",
    PET_INFO              = "PET_INFO",
    RAID                  = "RAID",
    RAID_BOSS_EMOTE       = "RAID_BOSS_EMOTE",
    RAID_BOSS_WHISPER     = "RAID_BOSS_WHISPER",
    RAID_LEADER           = "RAID_LEADER",
    RAID_WARNING          = "RAID_WARNING",
    REPLY                 = "REPLY",
    RESTRICTED            = "RESTRICTED",
    SAY                   = "SAY",
    SKILL                 = "SKILL",
    SYSTEM                = "SYSTEM",
    TEXT_EMOTE            = "TEXT_EMOTE",
    TRADESKILLS           = "TRADESKILLS",
    WHISPER               = "WHISPER",
    WHISPER_INFORM        = "WHISPER_INFORM",
    YELL                  = "YELL"
};

opvp.chat = {};

function opvp.chat.channelColor(id)
    return C_ChatInfo.GetColorForChatType(id);
end

function opvp.chat.emote(id, unitId)
    local emote = opvp.Emote:createFromId(id);

    emote:emote(unitId);
end

function opvp.chat.isEnabled()
    return not C_SocialRestrictions.IsChatDisabled();
end

function opvp.chat.isSilenced()
    return not C_SocialRestrictions.IsSilenced();
end

function opvp.chat.isSquelched()
    return not C_SocialRestrictions.IsSquelched();
end

function opvp.chat.setEnabled(state)
    C_SocialRestrictions.SetChatDisabled(not state)
end
