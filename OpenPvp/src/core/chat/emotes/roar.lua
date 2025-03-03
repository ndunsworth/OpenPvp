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

opvp.Emote.ROAR = opvp.Emote(
    {
        id     = opvp.EmoteId.ROAR,
        name   = "roar",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 25267,
                male_id     = 25268
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101897,
                male_id     = 101971
            },
            { --~ DRACTHYR
                female_id   = 212787,
                male_id     = 212512
            },
            { --~ DRAENEI
                female_id   = 25269,
                male_id     = 25270
            },
            { --~ DWARF
                female_id   = 25251,
                male_id     = 25252
            },
            { --~ EARTHEN
                female_id   = 258496,
                male_id     = 258488
            },
            { --~ GNOME
                female_id   = 25253,
                male_id     = 25254
            },
            { --~ GOBLIN
                female_id   = 19254,
                male_id     = 19144
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 25261,
                male_id     = 25262
            },
            { --~ HUMAN
                female_id   = 25255,
                male_id     = 25256
            },
            { --~ KUL_TIRAN
                female_id   = 127046,
                male_id     = 127140
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 25269,
                male_id     = 25270
            },
            { --~ MAGHAR_ORC
                female_id   = 110552,
                male_id     = 110408
            },
            { --~ MECHAGNOME
                female_id   = 144284,
                male_id     = 143901
            },
            { --~ NIGHT_ELF
                female_id   = 25257,
                male_id     = 25258
            },
            { --~ NIGHTBORNE
                female_id   = 96330,
                male_id     = 96398
            },
            { --~ ORC
                female_id   = 25259,
                male_id     = 25260
            },
            { --~ PANDAREN
                female_id   = 62512,
                male_id     = 62516
            },
            { --~ TAUREN
                female_id   = 25261,
                male_id     = 25262
            },
            { --~ TROLL
                female_id   = 25263,
                male_id     = 25264
            },
            { --~ UNDEAD
                female_id   = 25265,
                male_id     = 25266
            },
            { --~ VOID_ELF
                female_id   = 95884,
                male_id     = 95680
            },
            { --~ VULPERA
                female_id   = 143952,
                male_id     = 144044
            },
            { --~ WORGEN
                female_id   = 22449,
                male_id     = 19354
            },
            { --~ ZANDALARI_TROLL
                female_id   = 232217,
                male_id     = 76992
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.ROAR);
