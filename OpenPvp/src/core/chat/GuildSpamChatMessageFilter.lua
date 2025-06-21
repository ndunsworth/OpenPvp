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

opvp.GuildSpamChatMessageFilter = opvp.CreateClass(opvp.ChatMessageFilter);

function opvp.GuildSpamChatMessageFilter:init()
    opvp.ChatMessageFilter.init(self);

    self._threshold     = 6;

    self._filters_lvl_1 = opvp.List();
    self._filters_lvl_2 = opvp.List();

    self:_loadFilters();
end

function opvp.GuildSpamChatMessageFilter:eval(chatFrame, event, msg, msgLower, player, ...)
    local guid = select(10, ...);

    if guid == nil or self:isSenderValid(guid) == true then
        return false;
    end

    local score = self:messageScore(msgLower, self._threshold);

    if score < self._threshold then
        return false;
    end

    self:ignorePlayer(player, guid);

    return true;
end

function opvp.GuildSpamChatMessageFilter:ignorePlayer(name, guid)
    opvp.friends.addIgnore(name);
end

function opvp.GuildSpamChatMessageFilter:isSenderValid(guid)
    return (
        opvp.party.utils.isGuidInGroup(guid, opvp.PartyCategory.HOME) == true or
        opvp.party.utils.isGuidInGroup(guid, opvp.PartyCategory.INSTANCE) == true or
        opvp.friends.isFriend(guid) == true or
        opvp.friends.isBattleNetFriend(guid) == true
    );
end

function opvp.GuildSpamChatMessageFilter:messageScore(msg, threshold)
    local score = 0;

    for n=1, self._filters_lvl_1:size() do
        if strmatch(msg, self._filters_lvl_1:item(n)) then
            score = score + 2;

            if score >= threshold then
                return score;
            end
        end
    end

    for n=1, self._filters_lvl_2:size() do
        if strmatch(msg, self._filters_lvl_2:item(n)) then
            score = score + 1;

            if score >= threshold then
                return score;
            end
        end
    end

    return score;
end

function opvp.GuildSpamChatMessageFilter:setThreshold(value)
    self._threshold = max(1, value);
end

function opvp.GuildSpamChatMessageFilter:threshold()
    return self._threshold;
end

function opvp.GuildSpamChatMessageFilter:_connect()
    local mgr = opvp.ChatMessageFilterManager:instance();

    mgr:register(opvp.ChatType.WHISPER, self);

    return true;
end

function opvp.GuildSpamChatMessageFilter:_disconnect()
    local mgr = opvp.ChatMessageFilterManager:instance();

    mgr:unregister(opvp.ChatType.WHISPER, self);
end

function opvp.GuildSpamChatMessageFilter:_loadFilters()
    self._filters_lvl_1:clear();
    self._filters_lvl_2:clear();

    self._filters_lvl_1:merge(opvp.strs.GUILD_SPAM_LEVEL_1);
    self._filters_lvl_2:merge(opvp.strs.GUILD_SPAM_LEVEL_2);
end

local opvp_msg_filter_guild_spam_singleton;

local function opvp_msg_filter_guild_spam_ctor()
    opvp_msg_filter_guild_spam_singleton = opvp.GuildSpamChatMessageFilter();

    opvp_msg_filter_guild_spam_singleton:connect();
end

opvp.OnLoginReload:register(opvp_msg_filter_guild_spam_ctor);
