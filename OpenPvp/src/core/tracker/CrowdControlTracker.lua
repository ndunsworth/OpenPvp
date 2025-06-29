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

opvp.CrowdControlTracker = opvp.CreateClass(opvp.ClassAuraTracker);

function opvp.CrowdControlTracker:init()
    opvp.ClassAuraTracker.init(self);

    self.memberCrowdControlAdded   = opvp.Signal("opvp.CrowdControlTracker.playerCrowdControlAdded");
    self.memberCrowdControlRemoved = opvp.Signal("opvp.CrowdControlTracker.playerCrowdControlRemoved");
end

function opvp.CrowdControlTracker:aurasForClass(class)
    return class:auras():findCrowdControl();
end

function opvp.CrowdControlTracker:aurasForSpec(spec)
    return spec:auras():findCrowdControl();
end

function opvp.CrowdControlTracker:_onMemberAuraAdded(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old, new_dr = cc_state:_onAuraAdded(aura, spell);

    if result == false then
        return;
    end

    --~ opvp.printDebug(
        --~ "opvp.CrowdControlTracker:_onAuraAdded(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, dispell=%d, duration=%0.2f",
        --~ member:nameOrId(),
        --~ aura:spellId(),
        --~ aura:name(),
        --~ cc_cat_state:category():name(),
        --~ cc_cat_state:dr(),
        --~ aura:dispellType(),
        --~ aura:duration()
    --~ );

    self.memberCrowdControlAdded:emit(
        member,
        aura,
        spell,
        cc_cat_state,
        cc_mask_new,
        cc_mask_old,
        new_dr
    );
end

function opvp.CrowdControlTracker:_onMemberAuraRemoved(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old, new_dr = cc_state:_onAuraRemoved(aura, spell);

    if result == false then
        return;
    end

    --~ opvp.printDebug(
        --~ "opvp.CrowdControlTracker:_onAuraRemoved(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, dispell=%d, duration=%0.2f",
        --~ member:nameOrId(),
        --~ aura:spellId(),
        --~ aura:name(),
        --~ cc_cat_state:category():name(),
        --~ cc_cat_state:dr(),
        --~ aura:dispellType(),
        --~ aura:duration()
    --~ );

    self.memberCrowdControlRemoved:emit(
        member,
        aura,
        spell,
        cc_cat_state,
        cc_mask_new,
        cc_mask_old
    );
end

function opvp.CrowdControlTracker:_onMemberAuraUpdated(member, aura, spell)
    local cc_state = member:ccState();

    local result, cc_cat_state, cc_mask_new, cc_mask_old, new_dr = cc_state:_onAuraUpdated(aura, spell);

    if result == false then
        return;
    end

    --~ opvp.printDebug(
        --~ "opvp.CrowdControlTracker:_onAuraUpdated(\"%s\"), spellId=%d, spellName=\"%s\", type=\"%s\", dr=%d, dispell=%d, duration=%.2f",
        --~ member:nameOrId(),
        --~ aura:spellId(),
        --~ aura:name(),
        --~ cc_cat_state:category():name(),
        --~ cc_cat_state:dr(),
        --~ aura:dispellType(),
        --~ aura:duration()
    --~ );

    self.memberCrowdControlAdded:emit(
        member,
        aura,
        spell,
        cc_cat_state,
        cc_mask_new,
        cc_mask_old,
        new_dr
    );
end
