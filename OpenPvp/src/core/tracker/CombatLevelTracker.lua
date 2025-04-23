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

opvp.CombatLevelTracker = opvp.CreateClass(opvp.ClassAuraTracker);

function opvp.CombatLevelTracker:init()
    opvp.ClassAuraTracker.init(self);

    self.memberDefensiveAdded       = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveAdded");
    self.memberDefensiveRemoved     = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveRemoved");
    self.memberDefensiveUpdated     = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveUpdated");
    self.memberDefensiveLevelUpdate = opvp.Signal("opvp.CombatLevelTracker.memberDefensiveLevelUpdate");
    self.memberOffensiveAdded       = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveAdded");
    self.memberOffensiveRemoved     = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveRemoved");
    self.memberOffensiveUpdated     = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveUpdated");
    self.memberOffensiveLevelUpdate = opvp.Signal("opvp.CombatLevelTracker.memberOffensiveLevelUpdate");
end

function opvp.CombatLevelTracker:aurasForClass(class)
    return class:auras():findDefensiveOrOffensive();
end

function opvp.CombatLevelTracker:aurasForSpec(spec)
    return spec:auras():findDefensiveOrOffensive();
end

function opvp.CombatLevelTracker:_onMemberAuraAdded(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onMemberAuraDefensiveAdded(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onMemberAuraOffensiveAdded(member, aura, spell);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraDefensiveAdded(member, aura, spell)
    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraAdded(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraDefensiveAdded(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberDefensiveAdded:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraOffensiveAdded(member, aura, spell)
    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraAdded(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraOffensiveAdded(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberOffensiveAdded:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraRemoved(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onMemberAuraDefensiveRemoved(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onMemberAuraOffensiveRemoved(member, aura, spell);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraDefensiveRemoved(member, aura, spell)
    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraRemoved(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraDefensiveRemoved(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberDefensiveRemoved:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraOffensiveRemoved(member, aura, spell)
    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraRemoved(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraOffensiveRemoved(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberOffensiveRemoved:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraUpdated(member, aura, spell)
    if spell:isDefensive() == true then
        self:_onMemberAuraDefensiveUpdated(member, aura, spell);
    end

    if spell:isOffensive() == true then
        self:_onMemberAuraOffensiveUpdated(member, aura, spell);
        return;
    end
end

function opvp.CombatLevelTracker:_onMemberAuraDefensiveUpdated(member, aura, spell)
    local state = member:defensiveState();

    local new_level, old_level = state:_onAuraUpdated(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraDefensiveUpdated(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberDefensiveUpdated:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberDefensiveLevelUpdate:emit(member, new_level, old_level);
    end
end

function opvp.CombatLevelTracker:_onMemberAuraOffensiveUpdated(member, aura, spell)
    local state = member:offensiveState();

    local new_level, old_level = state:_onAuraUpdated(aura, spell);

    opvp.printDebug(
        "opvp.CombatLevelTracker:_onMemberAuraOffensiveUpdated(\"%s\"), spellId=%d, spellName=\"%s\", duration=%s, newLevel=%d, oldLevel=%d",
        member:nameOrId(),
        aura:spellId(),
        aura:name(),
        opvp.time.formatSeconds(aura:duration()),
        new_level,
        old_level
    );

    self.memberOffensiveUpdated:emit(member, aura, spell);

    if new_level ~= old_level then
        self.memberOffensiveLevelUpdate:emit(member, new_level, old_level);
    end
end
