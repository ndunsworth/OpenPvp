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

opvp.Emote.ATTACK_TARGET = opvp.Emote(
    {
        id     = opvp.EmoteId.ATTACK_TARGET,
        name   = "attacktarget",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9627,
                male_id     = 9653
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101835,
                male_id     = 101909
            },
            { --~ DRACTHYR
                female_id   = 212716,
                male_id     = 212444
            },
            { --~ DRAENEI
                female_id   = 9678,
                male_id     = 9703
            },
            { --~ DWARF
                female_id   = 2732,
                male_id     = 2720
            },
            { --~ EARTHEN
                female_id   = 262294,
                male_id     = 262376
            },
            { --~ GNOME
                female_id   = 2842,
                male_id     = 2830
            },
            { --~ GOBLIN
                female_id   = 19197,
                male_id     = 19086
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95531,
                male_id     = 95839
            },
            { --~ HUMAN
                female_id   = 2684,
                male_id     = 234305
            },
            { --~ KUL_TIRAN
                female_id   = 126983,
                male_id     = 127077
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96131,
                male_id     = 96199
            },
            { --~ MAGHAR_ORC
                female_id   = 110270,
                male_id     = 110345
            },
            { --~ MECHAGNOME
                female_id   = 144259,
                male_id     = 143838
            },
            { --~ NIGHT_ELF
                female_id   = 2756,
                male_id     = 2744
            },
            { --~ NIGHTBORNE
                female_id   = 96267,
                male_id     = 96335
            },
            { --~ ORC
                female_id   = 2708,
                male_id     = 2696
            },
            { --~ PANDAREN
                female_id   = 29783,
                male_id     = 28919
            },
            { --~ TAUREN
                female_id   = 2805,
                male_id     = 2792
            },
            { --~ TROLL
                female_id   = 2866,
                male_id     = 2854
            },
            { --~ UNDEAD
                female_id   = 2780,
                male_id     = 2768
            },
            { --~ VOID_ELF
                female_id   = 95832,
                male_id     = 95615
            },
            { --~ VULPERA
                female_id   = 144003,
                male_id     = 144095
            },
            { --~ WORGEN
                female_id   = 19366,
                male_id     = 19295
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126890,
                male_id     = 127264
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.ATTACK_TARGET);
