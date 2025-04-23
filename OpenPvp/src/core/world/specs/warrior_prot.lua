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
    class  = opvp.WARRIOR,
    id     = opvp.ClassSpecId.PROTECTION_WARRIOR,
    role   = opvp.Role.DPS,
    traits = opvp.ClassSpecTrait.MELEE_PHYSICAL,
    sound  = 59081,
    icon   = "Interface/Icons/ability_warrior_defensivestance",
    spells = {
        harmful = {
            talent = {
                {385954, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 4},          -- Shield Charge
            },
            pvp = {
                {199042, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT, 4},          -- Thunderstruck
            }
        },
        helpful = {
            talent = {
                {12975,  opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_HIGH, 8},    -- Last Stand
                {871,    opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_HIGH, 8},    -- Shield Wall
            },
            pvp = {
                {213871, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_MEDIUM, 60}, -- Bodyguard
            }
        }
    }
};

opvp.ClassSpec.PROTECTION_WARRIOR = opvp.ClassSpec(spec_info);

table.insert(opvp.ClassSpec.SPECS, opvp.ClassSpec.PROTECTION_WARRIOR);
table.insert(opvp.ClassSpec.TANK_SPECS, opvp.ClassSpec.PROTECTION_WARRIOR);

spec_info = nil;
