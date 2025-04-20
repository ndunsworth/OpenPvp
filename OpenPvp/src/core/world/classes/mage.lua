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

opvp.Class.MAGE = opvp.Class(
    {
        id = opvp.MAGE,
        file_id = "MAGE",
        races = {
            --~ NEUTRAL
            opvp.Race.DRACTHYR,
            opvp.Race.EARTHEN,
            opvp.Race.PANDAREN,

            --~ ALLIANCE
            opvp.Race.DRAENEI,
            opvp.Race.DWARF,
            opvp.Race.GNOME,
            opvp.Race.HUMAN,
            opvp.Race.NIGHT_ELF,
            opvp.Race.WORGEN,

            --~ ALLIANCE ALLIES
            opvp.Race.DARK_IRON_DWARF,
            opvp.Race.KUL_TIRAN,
            opvp.Race.LIGHTFORGED_DRAENEI,
            opvp.Race.MECHAGNOME,
            opvp.Race.VOID_ELF,
            opvp.Race.WORGEN,

            --~ HORDE
            opvp.Race.BLOOD_ELF,
            opvp.Race.GOBLIN,
            opvp.Race.ORC,
            opvp.Race.TAUREN,
            opvp.Race.TROLL,
            opvp.Race.UNDEAD,

            --~ HORDE ALLIES
            opvp.Race.HIGHMOUNTAIN_TAUREN,
            opvp.Race.MAGHAR_ORC,
            opvp.Race.NIGHTBORNE,
            opvp.Race.VULPERA,
            opvp.Race.ZANDALARI_TROLL
        },
        specs = {
            opvp.ClassSpec.ARCANE_MAGE,
            opvp.ClassSpec.FIRE_MAGE,
            opvp.ClassSpec.FROST_MAGE
        },
        spells = {
            harmful = {
                base = {
                    {120,    opvp.SpellTrait.SNARE, 0, 5, false},                                                -- Cone of Cold
                    {2139,   opvp.SpellTrait.INTERRUPT},                                                         -- Counterspell
                    {108853},                                                                                    -- Fire Blast
                    {33395,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT, 8},                    -- Freeze (Water Elemental)
                    {122,    opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT, 6},                    -- Frost Nova
                    {116,    opvp.SpellTrait.SNARE},                                                             -- Frostbolt
                    {61305,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Black Cat)
                    {277792, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Bumblebee)
                    {277787, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Direhorn)
                    {161354, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Monkey)
                    {161372, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Peacock)
                    {161355, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Penguin)
                    {28272,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Pig)
                    {161353, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Polar Bear Cub)
                    {126819, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Porcupine)
                    {61721,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Rabbit)
                    {118,    opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Sheep)
                    {61780,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Turkey)
                    {28271,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 60, 0.1},      -- Polymorph (Turtle)
                },
                talent = {
                    {157981, opvp.SpellTrait.CROWD_CONTROL, 0, 0},                                               -- Blast Wave
                    {31661,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.DISORIENT, 3},               -- Dragon's Breath
                    {157997, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.ROOT, 3},                    -- Ice Nova
                    {113724, opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 6, 1, false},  -- Ring of Frost
                    {389794, opvp.SpellTrait.CROWD_CONTROL, opvp.SpellProperty.STUN, 4, 1, false},               -- Snowdrift
                }
            },
            helpful = {
                base = {
                    {1459,   opvp.SpellTrait.RAID_BUFF, 0, 3600},                                                -- Arcane Intellect
                    {1953},                                                                                      -- Blink
                    {11426,  opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 4},               -- Ice Barrier
                    {66,     opvp.SpellTrait.AURA, 0, 20},                                                       -- Invisibility
                    {130,    opvp.SpellTrait.AURA, 0, 30},                                                       -- Slow Fall
                    {80353,  opvp.SpellTrait.RAID_BUFF, opvp.SpellProperty.OFFENSIVE_HIGH, 40},                  -- Time Warp
                },
                talent = {
                    {342247, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_MEDIUM, 10},           -- Alter Time
                    {212801},                                                                                    -- Displacement
                    {110960, 0, 0, 20},                                                                          -- Greater Invisiblity (stealth)
                    {45438,  opvp.SpellTrait.DEFENSIVE_IMMUNITY_AURA, opvp.SpellProperty.DEFENSIVE_IMMUNE, 10},  -- Ice Block
                    {414658, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_HIGH, 10},             -- Ice Cold
                    {55342,  opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_LOW, 40},              -- Mirror Image
                    {212653},                                                                                    -- Shimmer
                }
            }
        },
        auras = {
            harmful = {
                base = {
                    {212792, opvp.SpellTrait.SNARE, 0, 5, 1},                                                    -- Cone of Cold
                },
                talent = {
                    {82691,  opvp.SpellTrait.CROWD_CONTROL_AURA, opvp.SpellProperty.INCAPACITATE, 6},            -- Ring of Frost
                }
            },
            helpful = {
                talent = {
                    {113862, opvp.SpellTrait.DEFENSIVE_AURA, opvp.SpellProperty.DEFENSIVE_HIGH, 20},             -- Greater Invisiblity (dmg reduc)
                    {342242, opvp.SpellTrait.OFFENSIVE_AURA, opvp.SpellProperty.OFFENSIVE_HIGH, 6},              -- Time Warp (Time Anomaly)
                }
            }
        }
    }
);
