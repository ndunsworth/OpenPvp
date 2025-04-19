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

opvp.CombatLevelTracker = opvp.CreateClass(opvp.PartyAuraTrackerConnection);

function opvp.CombatLevelTracker:init()
    opvp.PartyAuraTrackerConnection.init(self);

    self.memberDefensiveAdded       = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveAdded");
    self.memberDefensiveRemoved     = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveRemoved");
    self.memberDefensiveUpdated     = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveUpdated");
    self.memberDefensiveLevelUpdate = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveLevelUpdate");
    self.memberOffensiveAdded       = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveAdded");
    self.memberOffensiveRemoved     = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveRemoved");
    self.memberOffensiveUpdated     = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveUpdated");
    self.memberOffensiveLevelUpdate = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveLevelUpdate");
end

function opvp.CombatLevelTracker:_clearMember(member)

end

function opvp.CombatLevelTracker:_onAuraAdded(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onAuraDefensiveAdded(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onAuraOffensiveAdded(member, aura, spell);
    end
end

function opvp.CombatLevelTracker:_onAuraDefensiveAdded(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraDefensiveAdded(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraAdded(aura, spell);

    self.memberDefensiveAdded:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onAuraOffensiveAdded(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraOffensiveAdded(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraAdded(aura, spell);

    self.memberOffensiveAdded:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onAuraRemoved(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onAuraDefensiveRemoved(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onAuraOffensiveRemoved(member, aura, spell);
    end
end

function opvp.CombatLevelTracker:_onAuraDefensiveRemoved(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraDefensiveRemoved(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraRemoved(aura, spell);

    self.memberDefensiveRemoved:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onAuraOffensiveRemoved(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraOffensiveRemoved(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraRemoved(aura, spell);

    self.memberOffensiveRemoved:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onAuraUpdated(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onAuraDefensiveUpdated(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onAuraOffensiveUpdated(member, aura, spell);
        return;
    end
end

function opvp.CombatLevelTracker:_onAuraDefensiveUpdated(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraDefensiveUpdated(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraUpdated(aura, spell);

    self.memberDefensiveUpdated:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onAuraOffensiveUpdated(member, aura, spell)
    opvp.printDebug(
        "opvp.CombatLevelTracker:_onAuraOffensiveUpdated(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s,",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration())
    );

    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraUpdated(aura, spell);

    self.memberOffensiveUpdated:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end
