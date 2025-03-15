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

local function get_sanctuary_ffa()
    local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo();

    if isSubZonePvP == nil or IsInInstance() then
        isSubZonePvP = false
    end

    local in_sanctuary = pvpType == "sanctuary";

    return in_sanctuary, (in_sanctuary == false and isSubZonePvP)
end

local opvp_user_player_singleton = nil;

opvp.Player = opvp.CreateClass(opvp.Unit);

function opvp.Player:init()
    opvp.Unit.init(self);

    self._guid         = opvp.unit.guid("player");
    self._name         = opvp.unit.name("player");
    self._faction      = opvp.unit.faction("player");
    self._race         = opvp.unit.race("player");
    self._class        = opvp.unit.class("player");
    self._sex          = opvp.unit.sex("player");
    self._spec         = opvp.ClassSpec.UNKNOWN;
    self._combat       = false;
    self._warmode      = false;
    self._in_sanctuary = false;
    self._in_ffa       = false;
    self._played_total = 0;
    self._played_level = 0;
    self._parties      = opvp.List();

    self._pvp_trinket_slot           = -1;
    self._pvp_trinket_item_id        = 0;
    self._pvp_trinket_spell_id       = 0;
    self._pvp_trinket_racial_spellid = 0;
    self._pvp_trinket_on_cd          = false;
    self._pvp_trinket_racial_on_cd   = false;
    self._pvp_trinket_timer          = opvp.Timer();
    self._pvp_trinket_racial_timer   = opvp.Timer();
    self._pvp_trinket_emit           = true;
    self._pvp_trinket_racial_emit    = true;

    self._pvp_trinket_timer:setTriggerLimit(1);
    self._pvp_trinket_racial_timer:setTriggerLimit(1);

    self._pvp_trinket_timer.timeout:connect(
        self,
        self._pvpTrinketCheck
    );

    self._pvp_trinket_racial_timer.timeout:connect(
        self,
        self._pvpTrinketRacialCheck
    );

    self.aliveChanged           = opvp.Signal("opvp.Player.aliveChanged");
    self.equipmentChanged       = opvp.Signal("opvp.Player.equipmentChanged");
    self.honorKillsChanged      = opvp.Signal("opvp.Player.honorKillsChanged");
    self.honorLevelChanged      = opvp.Signal("opvp.Player.honorLevelChanged");
    self.inCombatChanged        = opvp.Signal("opvp.Player.inCombatChanged");
    self.inFFAChanged           = opvp.Signal("opvp.Player.inFFAChanged");
    self.inSanctuaryChanged     = opvp.Signal("opvp.Player.inSanctuaryChanged");
    self.pvpTalentsChanged      = opvp.Signal("opvp.Player.pvpTalentsChanged");
    self.pvpTrinketUpdate       = opvp.Signal("opvp.Player.pvpTrinketUpdate");
    self.pvpTrinketRacialUpdate = opvp.Signal("opvp.Player.pvpTrinketRacialUpdate");
    self.restingChanged         = opvp.Signal("opvp.Player.restingChanged");
    self.specChanged            = opvp.Signal("opvp.Player.specChanged");
    self.timePlayedChanged      = opvp.Signal("opvp.Player.timePlayedChanged");
    self.warmodeChanged         = opvp.Signal("opvp.Player.warmodeChanged");

    local spec_id = GetSpecialization();

    if spec_id ~= nil then
        spec_id = GetSpecializationInfo(spec_id);

        if spec_id ~= nil then
            self._spec = self._class:spec(spec_id);
        end
    end

    self._in_sanctuary, self._in_ffa = get_sanctuary_ffa();

    self._warmode = C_PvP.IsWarModeDesired();

    if self._race:id() == opvp.HUMAN then
        self._pvp_trinket_racial_spellid = 59752;
    elseif self._race:id() == opvp.UNDEAD then
        self._pvp_trinket_racial_spellid = 7744;
    end

    opvp.match.roundWarmup:connect(
        self,
        self._onMatchRoundWarmup
    );

    opvp.event.BARBER_SHOP_APPEARANCE_APPLIED:connect(
        self,
        opvp.Player._onBarberUpdate
    );

    opvp.event.HONOR_LEVEL_UPDATE:connect(
        self,
        opvp.Player._onHonorLevelChanged
    );

    opvp.event.PLAYER_ALIVE:connect(
        self,
        opvp.Player._onAlive
    );

    opvp.event.PLAYER_DEAD:connect(
        self,
        opvp.Player._onDead
    );

    opvp.event.PLAYER_UNGHOST:connect(
        self,
        opvp.Player._onUnGhost
    );

    opvp.event.PLAYER_EQUIPMENT_CHANGED:connect(
        self,
        opvp.Player._onEquipmentChanged
    );

    opvp.event.PLAYER_PVP_KILLS_CHANGED:connect(
        function(unitTarget)
            if unitTarget == "player" then
                self:_onHonorKillsUpdate();
            end
        end
    );

    opvp.event.PLAYER_PVP_TALENT_UPDATE:connect(
        self,
        opvp.Player._onPvpTalentChanged
    );

    opvp.event.PLAYER_REGEN_DISABLED:connect(
        function()
            self:_onCombatChanged(true);
        end
    );

    opvp.event.PLAYER_REGEN_ENABLED:connect(
        function()
            self:_onCombatChanged(false);
        end
    );

    opvp.event.PLAYER_SPECIALIZATION_CHANGED:connect(
        function(unitTarget)
            if unitTarget == "player" then
                self:_onSpecChanged();
            end
        end
    );

    opvp.event.PLAYER_FLAGS_CHANGED:connect(
        function(unitTarget)
            if unitTarget == "player" then
                self:_onFlagsChanged();
            end
        end
    );

    opvp.event.PLAYER_UPDATE_RESTING:connect(
        self,
        opvp.Player._onRestingChanged
    );

    opvp.event.TIME_PLAYED_MSG:connect(
        self,
        opvp.Player._onTimePlayedMsg
    );

    opvp.event.ZONE_CHANGED:connect(
        self,
        opvp.Player._onZoneChanged
    );

    opvp.event.ZONE_CHANGED_NEW_AREA:connect(
        self,
        opvp.Player._onZoneChangedNewArea
    );
end

function opvp.Player:instance()
    return opvp_user_player_singleton;
end

function opvp.Player:canToggleWarMode()
    return C_PvP.CanToggleWarMode(not self:isWarmodeEnabled())
end

function opvp.Player:canToggleWarModeInArea()
    return C_PvP.CanToggleWarModeInArea()
end

function opvp.Player:findBuff(spellId)
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId);

    if aura ~= nil and aura.isHelpful == true then
        return aura;
    else
        return nil;
    end
end

function opvp.Player:findDebuff(spellId)
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId);

    if aura ~= nil and aura.isHelpful == true then
        return aura;
    else
        return nil;
    end
end

function opvp.Player:glidingInfo()
    return C_PlayerInfo.GetGlidingInfo();
end

function opvp.Player:hasDeserter()
    local spell_ids = {
        26013,
        405692
    };

    for n = 1, #spell_ids do
        local aura = C_UnitAuras.GetPlayerAuraBySpellID(spell_ids[n]);

        if aura ~= nil then
            return true;
        end
    end

    return false;
end

function opvp.Player:hasPvpRacialTrinket()
    return self._pvp_trinket_racial_spellid ~= 0;
end

function opvp.Player:honorKillsLifetime()
    local hks, max_rank = GetPVPLifetimeStats();

    return hks;
end

function opvp.Player:honorKillsPrevDay()
    hks, hp = GetPVPYesterdayStats();

    return hks;
end

function opvp.Player:honorKillsToday()
    hks, hp = GetPVPSessionStats();

    return hks;
end

function opvp.Player:honorLevel()
    return UnitHonorLevel("player");
end

function opvp.Player:honorLevelXP()
    return {
        xp=UnitHonor("player"),
        xp_max=UnitHonorMax("player")
    };
end

function opvp.Player:id()
    return "player";
end

function opvp.Player:inChromieTime()
    return C_PlayerInfo.IsPlayerInChromieTime();
end

function opvp.Player:inCombat()
    return self._combat;
end

function opvp.Player:inFFA()
    return self._in_ffa;
end

function opvp.Player:inParty(category)
    return opvp.party.hasParty(category);
end

function opvp.Player:hasHomeParty()
    return opvp.party.hasHomeParty();
end

function opvp.Player:hasInstanceParty()
    return opvp.party.hasInstanceParty();
end

function opvp.Player:inSanctuary()
    return self._in_sanctuary;
end

function opvp.Player:isGroupAssistant(category)
    return opvp.party.utils.isGroupAssistant("player", category);
end

function opvp.Player:isGroupLeader(category)
    return opvp.party.utils.isGroupLeader("player", category);
end

function opvp.Player:isItemUsable(itemId)
    return C_PlayerInfo.CanUseItem(itemId);
end

function opvp.Player:isResting()
    return IsResting();
end

function opvp.Player:isWarModeEnabled()
    return self._warmode
end

function opvp.Player:logHonorStats()
    local honor_xp = self:honorLevelXP();

    opvp.printMessage(
        "Honor Info: {\n    level=%d,\n    level_xp=%d/%d,\n    hks={\n        lifetime=%d,\n        today=%d,\n        prev_day=%d,\n    },\n    honor=%d/%d\n}",
        self:honorLevel(),
        honor_xp.xp,
        honor_xp.xp_max,
        self:honorKillsLifetime(),
        self:honorKillsToday(),
        self:honorKillsPrevDay(),
        opvp.currency.honor(),
        opvp.currency.honorMax()
    );
end

function opvp.Player:mapId()
    return C_Map.GetBestMapForUnit("player");
end

function opvp.Player:mapPosition()
    return C_Map.GetPlayerMapPosition(
        C_Map.GetBestMapForUnit("player"),
        "player"
    );
end

function opvp.Player:mapId()
    return C_Map.GetBestMapForUnit("player");
end

function opvp.Player:parties()
    return self._parties:items();
end

function opvp.Player:role()
    return self._class:spec();
end

function opvp.Player:setWarModeEnabled(state)
    if (
        state == self._warmode and
        C_PvP.CanToggleWarMode(state) == true
    ) then
        C_PvP.SetWarModeDesired(state);
    end
end

function opvp.Player:spec()
    return self._spec():id();
end

function opvp.Player:specInfo()
    return self._spec;
end

function opvp.Player:specs()
    return self:classInfo():specs();
end

function opvp.Player:specsSize()
    return self:classInfo():specsSize();
end

function opvp.Player:timePlayed()
    return self._played_total;
end

function opvp.Player:timePlayedLevel()
    return self._played_level;
end

function opvp.Player:timePlayedUpdate()
    RequestTimePlayed();
end

function opvp.Player:toggleWarMode()
    if self:test() == true then
        C_PvP.ToggleWarMode(not self._warmode)
    end

    return C_PvP.IsWarModeDesired();
end

function opvp.Player:_onAlive()
    if UnitIsDeadOrGhost("player") == false then
        self.aliveChanged:emit(true);
    end
end

function opvp.Player:_onBarberUpdate()
    self._sex = opvp.unit.sex("player");
end

function opvp.Player:_onCombatChanged(state)
    if self._combat ~= state then
        self._combat = state;

        self.inCombatChanged:emit(state);
    end
end

function opvp.Player:_onDead()
    self.aliveChanged:emit(false);
end

function opvp.Player:_onEquipmentChanged(equipmentSlot, hasCurrent)
    if equipmentSlot == INVSLOT_TRINKET1 or equipmentSlot == INVSLOT_TRINKET2 then
        self:_onTrinketChanged(equipmentSlot);
    end

    self.equipmentChanged:emit(equipmentSlot, hasCurrent);
end

function opvp.Player:_onFlagsChanged()
    if C_PvP.IsWarModeDesired() ~= self._warmode then
        self:_onWarModeChanged(not self._warmode);
    end
end

function opvp.Player:_onHonorKillsUpdate()
    self.honorLevelChanged:emit();
end

function opvp.Player:_onHonorLevelChanged(isHigherLevel)
    self.honorLevelChanged:emit(isHigherLevel);
end

function opvp.Player:_onMatchRoundWarmup()
    if opvp.match.isTest() == true then
        return;
    end

    self:_pvpTrinketCheck();
    self:_pvpTrinketRacialCheck();
end

function opvp.Player:_onPvpTalentChanged()
    self.pvpTalentsChanged:emit();
end

function opvp.Player:_onPvpTrinketUsed(spellId)
    local msg;

    if spellId == self._pvp_trinket_racial_spellid then
        msg = opvp.strs.TRINKET_RACIAL_USED;

        self._pvp_trinket_racial_emit = false;

        self.pvpTrinketRacialUpdate:emit(false);

        opvp.Timer:runNextFrame(
            function()
                self:_pvpTrinketRacialCheck();
            end
        );
    else
        msg = opvp.strs.TRINKET_USED;

        self._pvp_trinket_emit = false;

        self.pvpTrinketUpdate:emit(false);

        opvp.Timer:runNextFrame(
            function()
                self:_pvpTrinketCheck();
            end
        );
    end

    opvp.printMessageOrDebug(
        opvp.options.announcements.player.trinketUsed:value(),
        msg
    );
end

function opvp.Player:_onRestingChanged()
    self.restingChanged:emit(self:isResting());
end

function opvp.Player:_onSpecChanged()
    local spec = opvp.ClassSpec:fromSpecId(
        select(
            1,
            GetSpecializationInfo(GetSpecialization())
        )
    );

    if self._spec == spec then
        return;
    end;

    local old_spec = self._spec;

    self._spec = spec;

    if old_spec ~= opvp.ClassSpec.UNKNOWN then
        opvp.printMessageOrDebug(
            opvp.options.announcements.player.specChanged:value(),
            opvp.strs.PLAYER_SPEC_CHANGED,
            self._class:color():GenerateHexColor(),
            spec:name()
        );
    else
        opvp.printMessageOrDebug(
            opvp.options.announcements.player.specChanged:value(),
            opvp.strs.PLAYER_SPEC,
            self._class:color():GenerateHexColor(),
            spec:name()
        );
    end

    RequestRatedInfo();

    self.specChanged:emit(self._spec, old_spec);
end

function opvp.Player:_onTimePlayedMsg(total, level)
    if (
        total == self._played_total and
        level == self._played_level
    ) then
        return;
    end

    self._played_total = total;
    self._played_level = level;

    self.timePlayedChanged:emit();
end

function opvp.Player:_onTrinketChanged(equipmentSlot)
    if equipmentSlot == self._trinket_slot then
        local on_cd = self._pvp_trinket_on_cd;

        self._pvp_trinket_slot  = -1;

        self._pvp_trinket_timer:stop();

        self._pvp_trinket_on_cd = false;
        self._pvp_trinket_emit = false;

        if on_cd == false then
            self.pvpTrinketUpdate:emit(false);
        end
    end

    local item_id = GetInventoryItemID("player", equipmentSlot);

    if item_id ~= nil then
        local spell_name, spell_id = GetItemSpell(item_id);

        if spell_id == 336126 or spell_id == 336135 then
            self._pvp_trinket_slot        = equipmentSlot;
            self._pvp_trinket_item_id     = item_id;
            self._pvp_trinket_spell_id    = spell_id;
            self._pvp_trinket_on_cd       = false;
            self._pvp_trinket_emit        = true;

            self:_pvpTrinketCheck();
        end
    end
end

function opvp.Player:_onUnGhost()
    self.aliveChanged:emit(true);
end

function opvp.Player:_onWarModeChanged(state)
    self._warmode = state;

    self.warmodeChanged:emit(self._warmode);
end

function opvp.Player:_onZoneChanged()
    local old_ffa = self._in_ffa;
    local old_sanc = self._in_sanctuary;

    self._in_sanctuary, self._in_ffa = get_sanctuary_ffa();

    if old_sanc ~= self._in_sanctuary then
        self.inSanctuaryChanged:emit(self._in_sanctuary);
    end

    if old_ffa ~= self._in_ffa then
        self.inFFAChanged:emit(self._in_ffa);
    end
end

function opvp.Player:_onZoneChangedNewArea()
    self:_onZoneChanged();
end


function opvp.Player:_pvpTrinketCheck()
    if self._pvp_trinket_slot == -1 then
        return;
    end

    local start, duration, enable = GetInventoryItemCooldown(
        "player",
        self._pvp_trinket_slot
    );

    local cur_time = GetTime();

    if start == nil then
        self._pvp_trinket_on_cd = false;
        self._pvp_trinket_emit = true;

        return;
    end

    local off_cd = start + duration;

    if cur_time < off_cd then
        if self._pvp_trinket_on_cd == false then
            self._pvp_trinket_on_cd = true;

            if self._pvp_trinket_emit == true then
                opvp.printMessageOrDebug(
                    opvp.options.announcements.player.trinketUsed:value(),
                    opvp.strs.TRINKET_ON_COOLDOWN
                );

                self.pvpTrinketUpdate:emit(false);
            else
                self._pvp_trinket_emit = true;
            end

            if self._pvp_trinket_racial_on_cd == false then
                self:_pvpTrinketRacialCheck();
            end
        end

        self._pvp_trinket_timer:setInterval(off_cd - cur_time);

        self._pvp_trinket_timer:start();
    elseif self._pvp_trinket_on_cd == true then
        self._pvp_trinket_timer:stop();

        self._pvp_trinket_trinket_on_cd = false;

        if self._pvp_trinket_emit == true then
            opvp.printMessageOrDebug(
                opvp.options.announcements.player.trinketReady:value(),
                opvp.strs.TRINKET_READY
            );

            self.pvpTrinketUpdate:emit(true);
        else
            self._pvp_trinket_emit = true;
        end
    end
end

function opvp.Player:_pvpTrinketRacialCheck()
    if self._pvp_trinket_racial_spellid == 0 then
        return;
    end

    local info     = C_Spell.GetSpellCooldown(self._pvp_trinket_racial_spellid);
    local cur_time = GetTime();
    local off_cd   = info.startTime + info.duration;

    if cur_time < off_cd then
        if self._pvp_trinket_racial_on_cd == false then
            self._pvp_trinket_racial_on_cd = true;

            if self._pvp_trinket_racial_emit == true then
                opvp.printMessageOrDebug(
                    opvp.options.announcements.player.trinketUsed:value(),
                    opvp.strs.TRINKET_RACIAL_ON_COOLDOWN
                );

                self.pvpTrinketRacialUpdate:emit(false);
            else
                self._pvp_trinket_racial_emit = true;
            end

            if self._pvp_trinket_on_cd == false then
                self:_pvpTrinketCheck();
            end
        end

        self._pvp_trinket_racial_timer:setInterval(off_cd - cur_time);

        self._pvp_trinket_racial_timer:start();
    elseif self._pvp_trinket_racial_on_cd == true then
        self._pvp_trinket_racial_timer:stop();

        self._pvp_trinket_racial_on_cd = false;

        if self._pvp_trinket_racial_emit == true then
            opvp.printMessageOrDebug(
                opvp.options.announcements.player.trinketReady:value(),
                opvp.strs.TRINKET_RACIAL_READY
            );

            self.pvpTrinketRacialUpdate:emit(true);
        else
            self._pvp_trinket_racial_emit = true;
        end
    end
end

opvp.player = {};

function opvp.player.class()
    return opvp_user_player_singleton:class();
end

function opvp.player.classColor()
    return opvp_user_player_singleton:classInfo():color();
end

function opvp.player.classInfo()
    return opvp_user_player_singleton:classInfo();
end

function opvp.player.faction()
    return opvp_user_player_singleton:faction();
end

function opvp.player.factionInfo()
    return opvp_user_player_singleton:factionInfo();
end

function opvp.player.factionOpposite()
    return opvp_user_player_singleton:factionOpposite();
end

function opvp.player.factionOppositeInfo()
    return opvp_user_player_singleton:factionOppositeInfo();
end

function opvp.player.findBuff(spellId)
    return opvp_user_player_singleton:findBuff(spellId);
end

function opvp.player.findDebuff(spellId)
    return opvp_user_player_singleton:findDebuff(spellId);
end

function opvp.player.glidingInfo()
    return opvp_user_player_singleton:glidingInfo();
end

function opvp.player.guid()
    return opvp_user_player_singleton:guid();
end

function opvp.player.hasBuff(spellId)
    return opvp_user_player_singleton:hasBuff(spellId);
end

function opvp.player.hasDebuff(spellId)
    return opvp_user_player_singleton:hasDebuff(spellId);
end

function opvp.player.hasDeserter()
    return opvp_user_player_singleton:hasDeserter();
end

function opvp.player.hasPvpRacialTrinket()
    return opvp_user_player_singleton:hasPvpRacialTrinket();
end

function opvp.player.honorKillsLifetime()
    return opvp_user_player_singleton:honorKillsLifetime();
end

function opvp.player.honorKillsPrevDay()
    return opvp_user_player_singleton:honorKillsPrevDay();
end

function opvp.player.honorKillsToday()
    return opvp_user_player_singleton:honorKillsToday();
end

function opvp.player.honorLevel()
    return opvp_user_player_singleton:honorLevel();
end

function opvp.player.honorLevelXP()
    return opvp_user_player_singleton:honorLevelXP();
end

function opvp.player.instance()
    return opvp_user_player_singleton;
end

function opvp.player.inChromieTime()
    return opvp_user_player_singleton:inChromieTime();
end

function opvp.player.inCombat()
    return opvp_user_player_singleton:inCombat();
end

function opvp.player.inFFA()
    return opvp_user_player_singleton:inFFA();
end

function opvp.player.inGroup()
    return opvp_user_player_singleton:inGroup();
end

function opvp.player.inParty()
    return opvp_user_player_singleton:inParty();
end

function opvp.player.inRaid()
    return opvp_user_player_singleton:inRaid();
end

function opvp.player.inSanctuary()
    return opvp_user_player_singleton:inSanctuary();
end

function opvp.player.isAlliance()
    return opvp_user_player_singleton:isAlliance();
end

function opvp.player.isGroupAssistant(category)
    return opvp_user_player_singleton:isGroupAssistant(category);
end

function opvp.player.isGroupLeader(category)
    return opvp_user_player_singleton:isGroupLeader(category);
end

function opvp.player.isHorde()
    return opvp_user_player_singleton:isHorde();
end

function opvp.player.isItemUsable(itemId)
    return opvp_user_player_singleton:isItemUsable(itemId);
end

function opvp.player.isNeutral()
    return opvp_user_player_singleton:isNeutral();
end

function opvp.player.isRace(race)
    return opvp_user_player_singleton:isRace(race);
end

function opvp.player.isResting(race)
    return opvp_user_player_singleton:isResting(race);
end

function opvp.player.isWarModeEnabled()
    return opvp_user_player_singleton:isWarModeEnabled();
end

function opvp.player.isXpEnabled()
    return opvp_user_player_singleton:isXpEnabled();
end

function opvp.player.level()
    return opvp_user_player_singleton:level();
end

function opvp.player.logHonorStats()
    return opvp_user_player_singleton:logHonorStats();
end

function opvp.player.mapId()
    return opvp_user_player_singleton:mapId();
end

function opvp.player.mapPosition()
    return opvp_user_player_singleton:mapPosition();
end

function opvp.player.name()
    return opvp_user_player_singleton:name();
end

function opvp.player.parties()
    return opvp_user_player_singleton:parties();
end

function opvp.player.race()
    return opvp_user_player_singleton:race();
end

function opvp.player.raceInfo()
    return opvp_user_player_singleton:raceInfo();
end

function opvp.player.spec()
    return opvp_user_player_singleton:spec();
end

function opvp.player.specs()
    return opvp_user_player_singleton:specs();
end

function opvp.player.specsSize()
    return opvp_user_player_singleton:specsSize();
end

function opvp.player.specInfo()
    return opvp_user_player_singleton:specInfo();
end

function opvp.player.sex()
    return opvp_user_player_singleton:sex();
end

function opvp.player.timePlayed()
    return opvp_user_player_singleton:timePlayed();
end

function opvp.player.timePlayedLevel()
    return opvp_user_player_singleton:timePlayedLevel();
end

function opvp.player.timePlayedUpdate()
    opvp_user_player_singleton:timePlayedUpdate();
end

local function opvp_player_singleton_ctor()
    opvp_user_player_singleton = opvp.Player();

    if opvp_user_player_singleton:class() == opvp.HUNTER then
        opvp.unit.isFeignDeath = function(unitId)
            if opvp.unit.isSameUnit(unitId, "player") == true then
                return opvp.player.findBuff(5384);
            else
                return UnitIsFeignDeath(unitId);
            end
        end
    end

    opvp.printDebug("Player - Initialized");
end

local function opvp_player_set_spec_init()
    opvp_user_player_singleton:_onSpecChanged();

    opvp_user_player_singleton:_onTrinketChanged(INVSLOT_TRINKET1);

    if opvp_user_player_singleton._pvp_trinket_slot == -1 then
        opvp_user_player_singleton:_onTrinketChanged(INVSLOT_TRINKET2);
    end

    if opvp_user_player_singleton:hasPvpRacialTrinket() == true then
        opvp_user_player_singleton:_pvpTrinketRacialCheck();
    end
end

opvp.OnAddonLoad:register(opvp_player_singleton_ctor);
opvp.OnLoginReload:register(opvp_player_set_spec_init);
