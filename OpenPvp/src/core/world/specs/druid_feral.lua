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

local spec_info = {
    class  = opvp.DRUID,
    id     = opvp.ClassSpecId.FERAL_DRUID,
    index  = 2,
    role   = opvp.Role.DPS,
    traits = opvp.ClassSpecTrait.MELEE_PHYSICAL,
    sound  = 143720,
    icon   = "Interface/Icons/ability_druid_catform",
    spells = {
        harmful = {
            talent = {
                {391888, opvp.SpellProperty.OFFENSIVE_MEDIUM, 0, 12},      -- Adaptive Swarm
                {106951, opvp.SpellProperty.OFFENSIVE_HIGH_AURA, 0, 15},   -- Berserk
                {102543, opvp.SpellProperty.OFFENSIVE_HIGH_AURA, 0, 20},   -- Incarnation: Avatar of Ashamane
                {5217,   opvp.SpellProperty.OFFENSIVE_MEDIUM_AURA, 0, 20}, -- Tigers Fury
            }
        },
        helpful = {
            talent = {
                {61336,  opvp.SpellProperty.DEFENSIVE_HIGH_AURA, 0, 6},    -- Survival Instincts
            }
        }
    },
    auras = {
        harmful = {
            talent = {
                {391889, opvp.SpellProperty.OFFENSIVE_MEDIUM},             -- Adaptive Swarm
            }
        }
    }
};

opvp.ClassSpec.FERAL_DRUID = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.FERAL_DRUID);
table.insert(opvp.ClassSpec.DPS_SPECS, opvp.ClassSpec.FERAL_DRUID);

spec_info = nil;
