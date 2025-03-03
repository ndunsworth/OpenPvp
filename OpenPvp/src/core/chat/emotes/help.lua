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

opvp.Emote.HELP = opvp.Emote(
    {
        id     = opvp.EmoteId.HELP,
        name   = "help",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9623,
                male_id     = 9663
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101887,
                male_id     = 101961
            },
            { --~ DRACTHYR
                female_id   = 212776,
                male_id     = 212502
            },
            { --~ DRAENEI
                female_id   = 9688,
                male_id     = 9713
            },
            { --~ DWARF
                female_id   = 2728,
                male_id     = 2716
            },
            { --~ EARTHEN
                female_id   = 262353,
                male_id     = 262428
            },
            { --~ GNOME
                female_id   = 2838,
                male_id     = 2826
            },
            { --~ GOBLIN
                female_id   = 19245,
                male_id     = 31857
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95542,
                male_id     = 95843
            },
            { --~ HUMAN
                female_id   = 2680,
                male_id     = 2668
            },
            { --~ KUL_TIRAN
                female_id   = 127036,
                male_id     = 127130
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96178,
                male_id     = 96246
            },
            { --~ MAGHAR_ORC
                female_id   = 110323,
                male_id     = 110398
            },
            { --~ MECHAGNOME
                female_id   = 144274,
                male_id     = 143891
            },
            { --~ NIGHT_ELF
                female_id   = 2752,
                male_id     = 2740
            },
            { --~ NIGHTBORNE
                female_id   = 96314,
                male_id     = 96382
            },
            { --~ ORC
                female_id   = 2704,
                male_id     = 2692
            },
            { --~ PANDAREN
                female_id   = 29809,
                male_id     = 28922
            },
            { --~ TAUREN
                female_id   = 2801,
                male_id     = 2788
            },
            { --~ TROLL
                female_id   = 2862,
                male_id     = 2850
            },
            { --~ UNDEAD
                female_id   = 2776,
                male_id     = 2764
            },
            { --~ VOID_ELF
                female_id   = 95856,
                male_id     = 95664
            },
            { --~ VULPERA
                female_id   = 144018,
                male_id     = 144110
            },
            { --~ WORGEN
                female_id   = 19435,
                male_id     = 19344
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126943,
                male_id     = 127317
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.HELP);
