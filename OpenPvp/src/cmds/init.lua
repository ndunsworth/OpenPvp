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

opvp.OpenPvpRootCmd = opvp.CreateClass(opvp.GroupAddonCommand);

function opvp.OpenPvpRootCmd:init(name, description)
    opvp.GroupAddonCommand.init(self, name, description)
end

function opvp.OpenPvpRootCmd:show()
    opvp.options.match.category:show();
end

opvp.cmds = opvp.OpenPvpRootCmd("OpenPvp");

local function opvp_init_party_slash_cmds()
    local party_cmd = opvp.GroupAddonCommand("party", "Party commands");

    party_cmd:addCommand(
        opvp.FuncAddonCommand(
            opvp.party.logInfo,
            "info",
            "Prints party information"
        )
    );

    opvp.cmds:addCommand(party_cmd);
end

local function opvp_init_match_slash_cmds()
    local match_cmd = opvp.GroupAddonCommand("match", "Match commands");
    local team_cmd = opvp.GroupAddonCommand("team", "Team commands");

    match_cmd:setDefaultCommad("options");

    match_cmd:addCommand(
        opvp.ShowOptionAddonCommand(
            opvp.options.match.category,
            "options",
            "Show Match options panel"
        )
    );

    team_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                if opvp.match.inMatch() == true then
                    local match = opvp.match.current();

                    if args == "team" then
                        match:playerTeam():logInfo();
                    elseif args == "enemy" then
                        match:opponentTeam():logInfo();
                    else
                        match:playerTeam():logInfo();
                        match:opponentTeam():logInfo();
                    end
                end
            end,
            "info",
            "Prints team party information"
        )
    );

    match_cmd:addCommand(team_cmd);

    opvp.cmds:addCommand(match_cmd);
end

local function opvp_init_sound_slash_cmds()
    local sound_cmd = opvp.GroupAddonCommand("sound", "Sound commands");
    local vol_cmds = opvp.GroupAddonCommand("volume", "Volume commands");

    vol_cmds:addCommand(
        opvp.FuncAddonCommand(
            function()
                opvp.sound.volumeDown(opvp.SoundChannel.MASTER);
            end,
            "down",
            "down"
        )
    );

    vol_cmds:addCommand(
        opvp.FuncAddonCommand(
            function()
                opvp.sound.volumeUp(opvp.SoundChannel.MASTER);
            end,
            "up",
            "up"
        )
    );

    vol_cmds:addCommand(
        opvp.FuncAddonCommand(
            function()
                opvp.sound.setMasterEnabled(false);
            end,
            "mute",
            "mute"
        )
    );

    vol_cmds:addCommand(
        opvp.FuncAddonCommand(
            function()
                opvp.sound.setMasterEnabled(true);
            end,
            "unmute",
            "unmute"
        )
    );

    vol_cmds:addCommand(
        opvp.FuncAddonCommand(
            function()
                opvp.sound.toggleMaster();
            end,
            "toggle",
            "toggle"
        )
    );

    sound_cmd:addCommand(vol_cmds);

    opvp.cmds:addCommand(sound_cmd);
end

local function opvp_init_test_slash_cmds()
    local test_cmd = opvp.GroupAddonCommand("test", "Test commands");

    test_cmd:setDefaultCommad("arena");

    test_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                local mgr = opvp.match.manager();

                if mgr:isTesting() == true then
                    local is_arena = mgr:match():isArena();

                    mgr:endTest();

                    if is_arena == true then
                        return;
                    end
                end

                local map = opvp.Map.NAGRAND_ARENA;
                local simulate = string.lower(args) == "simulate";

                mgr:beginTest(
                    opvp.PvpType.ARENA,
                    map,
                    0,
                    simulate
                );
            end,
            "arena",
            "Test Arena"
        )
    );

    test_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                local mgr = opvp.match.manager();

                if mgr:isTesting() == true then
                    local is_bg = mgr:match():isBattleground();

                    mgr:endTest();

                    if is_bg == true then
                        return;
                    end
                end

                local map = opvp.Map.WARSONG_GULCH;
                local simulate = string.lower(args) == "simulate";

                mgr:beginTest(
                    opvp.PvpType.BATTLEGROUND,
                    map,
                    0,
                    simulate
                );
            end,
            "battleground",
            "Test Battleground"
        )
    );

    test_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                local mgr = opvp.match.manager();

                if mgr:isTesting() == true then
                    local is_arena = mgr:match():isArena();

                    mgr:endTest();

                    if is_arena == true then
                        return;
                    end
                end

                local map = opvp.Map.NAGRAND_ARENA;
                local simulate = string.lower(args) == "simulate";

                mgr:beginTest(
                    opvp.PvpType.ARENA,
                    opvp.Map.NAGRAND_ARENA,
                    bit.bor(
                        opvp.PvpFlag.RATED,
                        opvp.PvpFlag.ROUND,
                        opvp.PvpFlag.SHUFFLE
                    ),
                    simulate
                );
            end,
            "shuffle",
            "Test Shuffle"
        )
    );

    test_cmd:addCommand(
        opvp.FuncAddonCommand(
            function()
                local party = opvp.party.home();

                party:sendAddonMessage(
[[
test
]],
                    "RAID",
                    nil,
                    opvp.SocketPriority.NORMAL
--~ function opvp.Socket:write(data, channel, target, priority)
--~ function ChatThrottleLib:SendAddonMessage(prio, prefix, text, chattype, target, queueName, callbackFn, callbackArg)
                );
            end,
            "msg",
            "Test MSG"
        )
    );

    opvp.cmds:addCommand(test_cmd);
end

local function opvp_init_slash_cmds()
    opvp.cmds:addCommand(
        opvp.FuncAddonCommand(
            opvp.player.logHonorStats,
            "honor",
            "Prints honor information"
        )
    );

    opvp_init_match_slash_cmds();

    opvp_init_party_slash_cmds();

    opvp.cmds:addCommand(
        opvp.FuncAddonCommand(
            opvp.queue.logPendingStatus,
            "queue",
            "Prints queue information"
        )
    );

    opvp.cmds:addCommand(
        opvp.FuncAddonCommand(
            opvp.bracket.logRankings,
            "rating",
            "Prints rating information"
        )
    );

    opvp_init_sound_slash_cmds();
    opvp_init_test_slash_cmds();
end

local function OpenPvpCommands(msg, editbox)
    opvp.cmds:eval(editbox, msg);
end

SlashCmdList["OPENPVPLIB_SLASHCMD"] = OpenPvpCommands;

SLASH_OPENPVPLIB_SLASHCMD1 = '/opvp';

opvp.OnAddonLoad:register(opvp_init_slash_cmds);
