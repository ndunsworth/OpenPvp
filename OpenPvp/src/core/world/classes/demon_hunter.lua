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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

opvp.Class.DEMON_HUNTER = opvp.Class(
    {
        id = opvp.DEMON_HUNTER,
        file_id = "DEMONHUNTER",
        races  = {
            --~ ALLIANCE
            opvp.Race.NIGHT_ELF,

            --~ HORDE
            opvp.Race.BLOOD_ELF
        },
        specs = {
            opvp.ClassSpec.HAVOC_DEMON_HUNTER,
            opvp.ClassSpec.VENGANCE_DEMON_HUNTER
        },
        spells = {
            harmful = {
                base = {
                },
                talent = {
                    {179057, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.STUN, 2, 1.5},                 -- Chaos Nova
                    {179057, opvp.SpellTrait.DISPELL},                                                             -- Comsume Magic
                    {179057, opvp.SpellTrait.INTERRUPT, 0, 3},                                                     -- Disrupt
                    {258920, opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_LOW, 10},                -- Immolation Aura
                    {217832, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.05},       -- Imprison
                    {162264, opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH, 20},               -- Metamorphosis
                    {207685, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.DISORIENT, 15, 0.2},           -- Sigil of Misery
                    {207685, opvp.SpellTrait.OFFENSIVE, opvp.SpellProperty.OFFENSIVE_MEDIUM},                      -- The Hunt
                    {185245, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.TAUNT, 3},                     -- Torment
                }
            },
            helpful = {
                base = {
                },
                talent = {
                    {209426, opvp.SpellTrait.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_IMMUNE_DMG, 6}, -- Darkness
                    {198793, opvp.SpellTrait.DEFENSIVE},                                                           -- Vengeful Retreat
                }
            }
        },
        auras = {
            harmful = {
                base = {
                },
                talent = {
                    {370970, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT_NO_DR, 1.5},              -- The Hunt (root)
                    {370966, 0, 0, 20},                                                                            -- The Hunt (healing debuff)
                    {185245, opvp.SpellTrait.SNARE, 0, 3},                                                         -- Master of the Glaive
                },
                pvp = {
                    {                                                                                              -- Imprison (Detainment Immunity)
                        221527,
                        opvp.SpellTrait.CROWD_CONTROL_AURA,
                        bit.bor(
                            opvp.SpellProperty.INCAPACITATE,
                            opvp.SpellProperty.IMMUNITY_ALL
                        ),
                        60,
                        0.05
                    },
                }
            },
            helpful = {
                talent = {
                }
            }
        }
    }
);
