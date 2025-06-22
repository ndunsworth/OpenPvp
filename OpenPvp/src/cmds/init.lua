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

opvp.private.DBGCombatLogConnection = opvp.CreateClass(opvp.CombatLogConnection);

function opvp.private.DBGCombatLogConnection:init(partyOnly)
    opvp.CombatLogConnection.init(self);

    self._party_only = partyOnly == true;
    self._party = nil;

    if self._party_only == true then
        opvp.party.joined:connect(self, self._onPartyJoined);
        opvp.party.left:connect(self, self._onPartyLeft);
    end
end

function opvp.private.DBGCombatLogConnection:_onPartyJoined(party)
    if self._party == nil or self._party:isHome() == true then
        self._party = party;
    end
end

function opvp.private.DBGCombatLogConnection:_onPartyLeft(party)
    if party:isHome() == true then
        self._party = opvp.party.instance();
    else
        self._party = opvp.party.home();
    end
end

function opvp.private.DBGCombatLogConnection:event(event)
    if (
        self._party_only == true and (
            self._party == nil or
            (
                self._party:findMemberByGuid(event.sourceGUID) == nil and
                self._party:findMemberByGuid(event.destGUID) == nil
            )
        )
    ) then
        return;
    end

    opvp.printDebug(
[[
COMBAT_LOG_EVENT_UNFILTERED {
    timestamp = %d,
    subevent = %s,
    hideCaster = %s,
    sourceGUID = %s,
    sourceName = %s,
    sourceFlags = %d,
    sourceRaidFlags = %d,
    destGUID = %s,
    destName = %s,
    destFlags = %d,
    destRaidFlags = %d
    spellId = %d
}
]],
        event.timestamp,
        event.subevent,
        tostring(event.hideCaster),
        tostring(event.sourceGUID),
        tostring(event.sourceName),
        event.sourceFlags,
        event.sourceRaidFlags,
        tostring(event.destGUID),
        tostring(event.destName),
        event.destFlags,
        event.destRaidFlags,
        (
            event.subevent == opvp.combatlog.SPELL_CAST_SUCCESS
            and select(12, CombatLogGetCurrentEventInfo())
            or 0
        )
    );
end

local opvp_dbg_auras;
local opvp_dbg_combatlog;
local opvp_dbg_combatlog2;

opvp.OpenPvpRootCmd = opvp.CreateClass(opvp.GroupAddonCommand);

function opvp.OpenPvpRootCmd:init(name, description)
    opvp.GroupAddonCommand.init(self, name, description)
end

function opvp.OpenPvpRootCmd:show()
    opvp.options.match.category:show();
end

opvp.cmds = opvp.OpenPvpRootCmd(opvp.LIB_NAME);

local function opvp_init_dbg_slash_cmds()
    opvp_dbg_auras = opvp.DebugAuraTracker();

    opvp_dbg_combatlog = opvp.private.DBGCombatLogConnection();
    opvp_dbg_combatlog2 = opvp.private.DBGCombatLogConnection(true);

    local dbg_cmd = opvp.GroupAddonCommand("dbg", "Debug commands");

    dbg_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                if opvp_dbg_auras:isConnected() == false then
                    opvp_dbg_auras:connect(opvp.party.auraServer());
                else
                    opvp_dbg_auras:disconnect();
                end
            end,
            "auras",
            "Prints UNIT_AURA event information"
        )
    );

    dbg_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                if opvp_dbg_combatlog:isConnected() == false then
                    opvp_dbg_combatlog:connect();
                else
                    opvp_dbg_combatlog:disconnect();
                end
            end,
            "combatlog",
            "Prints COMBAT_LOG_EVENT_UNFILTERED event information"
        )
    );

    dbg_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                if opvp_dbg_combatlog2:isConnected() == false then
                    opvp_dbg_combatlog2:connect();
                else
                    opvp_dbg_combatlog2:disconnect();
                end
            end,
            "combatlog2",
            "Prints COMBAT_LOG_EVENT_UNFILTERED event information"
        )
    );

    opvp.cmds:addCommand(dbg_cmd);
end

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

    local arena_maps = {
        opvp.Map.DALARAN_SEWERS,
        opvp.Map.ENIGMA_CRUCIBLE,
        opvp.Map.NAGRAND_ARENA,
        opvp.Map.NOKHUDON_PROVING_GROUNDS,
        opvp.Map.RUINS_OF_LORDAERON,
        opvp.Map.TIGERS_PEAK,
        opvp.Map.TOL_VIRON_ARENA
    };

    local bg_maps = {
        opvp.Map.ARATHI_BASIN,
        opvp.Map.TWIN_PEAKS,
        opvp.Map.WARSONG_GULCH
    };

    test_cmd:addCommand(
        opvp.FuncAddonCommand(
            function(editbox, args)
                args = opvp.AddonCommand:splitArgs(args, true);

                local mgr = opvp.match.manager();

                if mgr:isTesting() == true then
                    local is_arena = mgr:match():isArena();

                    mgr:endTest();

                    if is_arena == true then
                        return;
                    end
                end

                local map = arena_maps[math.random(1, #arena_maps)];
                local simulate = opvp.utils.array.contains(args, "simulate");
                local mask = 0;

                if opvp.utils.array.contains(args, "skirmish") == true then
                    mask = opvp.PvpFlag.SKIRMISH;
                elseif opvp.utils.array.contains(args, "shuffle") == true then
                    mask = bit.bor(
                        opvp.PvpFlag.RATED,
                        opvp.PvpFlag.ROUND,
                        opvp.PvpFlag.SHUFFLE
                    )
                end

                mgr:beginTest(
                    opvp.PvpType.ARENA,
                    map,
                    mask,
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
                args = opvp.AddonCommand:splitArgs(args, true);

                local mgr = opvp.match.manager();

                if mgr:isTesting() == true then
                    local is_bg = mgr:match():isBattleground();

                    mgr:endTest();

                    if is_bg == true then
                        return;
                    end
                end

                local map = bg_maps[math.random(1, #bg_maps)];
                local simulate = opvp.utils.array.contains(args, "simulate");

                local mask = 0;

                if opvp.utils.array.contains(args, "blitz") then
                    mask = bit.bor(
                        opvp.PvpFlag.RATED,
                        opvp.PvpFlag.BLITZ
                    );
                elseif opvp.utils.array.contains(args, "rbg") then
                    mask = bit.bor(
                        opvp.PvpFlag.RATED,
                        opvp.PvpFlag.RBG
                    );
                end

                mgr:beginTest(
                    opvp.PvpType.BATTLEGROUND,
                    map,
                    mask,
                    simulate
                );
            end,
            "battleground",
            "Test Battleground"
        )
    );

    opvp.cmds:addCommand(test_cmd);
end

local function opvp_init_slash_cmds()
    opvp_init_dbg_slash_cmds();

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
