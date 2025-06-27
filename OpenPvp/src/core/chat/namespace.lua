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

opvp.ChatStatus = {
    AVAILABLE = 1,
    AFK       = 2,
    DND       = 3
};

local opvp_cur_chat_status_reason = {
    [opvp.ChatStatus.AFK] = "";
    [opvp.ChatStatus.DND] = "";
};

opvp.chat = {};

function opvp.chat.isAvailable()
    return (
        IsChatAFK() == false and
        IsChatDND() == false
    );
end

function opvp.chat.isAFK()
    return IsChatAFK();
end

function opvp.chat.isDND()
    return IsChatDND();
end

function opvp.chat.status()
    if opvp.chat.isAFK() then
        return opvp.ChatStatus.AFK;
    elseif opvp.chat.isDND() then
        return opvp.ChatStatus.DND;
    else
        return opvp.ChatStatus.AVAILABLE;
    end
end

function opvp.chat.reasonAFK()
    return opvp_cur_chat_status_reason[opvp.ChatStatus.AFK];
end

function opvp.chat.reasonDND()
    return opvp_cur_chat_status_reason[opvp.ChatStatus.DND];
end

function opvp.chat.setAvailable()
    opvp.chat.setStatus(opvp.ChatStatus.AVAILABLE);
end

function opvp.chat.setAFK(msg)
    opvp.chat.setStatus(opvp.ChatStatus.AFK, msg);
end

function opvp.chat.setStatus(status, msg)
    print("opvp.chat.setStatus,", status, msg, opvp.chat.status());
    if msg == nil then
        if status == opvp.ChatStatus.AFK then
            msg = DEFAULT_AFK_MESSAGE;
        elseif status == opvp.ChatStatus.DND then
            msg = DEFAULT_DND_MESSAGE;
        else
            msg = "";
        end
    end

    local cur_status = opvp.chat.status();

    if (
        status == cur_status and (
            status ~= opvp.ChatStatus.AVAILABLE or
            msg == ""
        )
    ) then
        return;
    end

    if status == opvp.ChatStatus.AVAILABLE then
        status = cur_status;
    end

    if status == opvp.ChatStatus.AFK then
        SendChatMessage(msg, opvp.ChatType.AFK);
    elseif status == opvp.ChatStatus.DND then
        SendChatMessage(msg, opvp.ChatType.DND);
    else
        return;
    end
end

function opvp.chat.setDND(msg)
    opvp.chat.setStatus(opvp.ChatStatus.DND, msg);
end

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

local function opvp_send_chat_msg_hook(msg, chatType, languageID, target)
    if chatType == opvp.ChatType.AFK then
        if opvp.chat.isAFK() == true then
            opvp_cur_chat_status_reason[opvp.ChatStatus.AFK] = opvp.str_else(msg, DEFAULT_AFK_MESSAGE);
        else
            opvp_cur_chat_status_reason[opvp.ChatStatus.AFK] = "";
        end
    elseif chatType == opvp.ChatType.DND then
        if opvp.chat.isDND() == true then
            opvp_cur_chat_status_reason[opvp.ChatStatus.DND] = opvp.str_else(msg, DEFAULT_DND_MESSAGE);
        else
            opvp_cur_chat_status_reason[opvp.ChatStatus.DND] = "";
        end
    end
end

local function opvp_chat_status_init()
    hooksecurefunc("SendChatMessage", opvp_send_chat_msg_hook);

    if opvp.chat.isAFK() == true then
        opvp_cur_chat_status_reason[opvp.ChatStatus.AFK] = DEFAULT_AFK_MESSAGE;
    elseif opvp.chat.isDND() == true then
        opvp_cur_chat_status_reason[opvp.ChatStatus.DND] = DEFAULT_DND_MESSAGE;
    end

end

opvp.OnLoadingScreenEnd:connect(opvp_chat_status_init)
