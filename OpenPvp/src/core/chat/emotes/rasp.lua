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

opvp.Emote.RASP = opvp.Emote(
    {
        id     = opvp.EmoteId.RASP,
        name   = "rasp",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9634,
                male_id     = 9669
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101896,
                male_id     = 101970
            },
            { --~ DRACTHYR
                female_id   = 212511,
                male_id     = 212786
            },
            { --~ DRAENEI
                female_id   = 9694,
                male_id     = 9719
            },
            { --~ DWARF
                female_id   = 2739,
                male_id     = 2727
            },
            { --~ EARTHEN
                female_id   = 262361,
                male_id     = 262436
            },
            { --~ GNOME
                female_id   = 2849,
                male_id     = 2837
            },
            { --~ GOBLIN
                female_id   = 19253,
                male_id     = 19026
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95557,
                male_id     = 95878
            },
            { --~ HUMAN
                female_id   = 2691,
                male_id     = 2679
            },
            { --~ KUL_TIRAN
                female_id   = 127045,
                male_id     = 127139
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96193,
                male_id     = 96261
            },
            { --~ MAGHAR_ORC
                female_id   = 110332,
                male_id     = 110407
            },
            { --~ MECHAGNOME
                female_id   = 144283,
                male_id     = 143900
            },
            { --~ NIGHT_ELF
                female_id   = 2763,
                male_id     = 2751
            },
            { --~ NIGHTBORNE
                female_id   = 96329,
                male_id     = 96397
            },
            { --~ ORC
                female_id   = 2715,
                male_id     = 2703
            },
            { --~ PANDAREN
                female_id   = 29824,
                male_id     = 28935
            },
            { --~ TAUREN
                female_id   = 2812,
                male_id     = 2800
            },
            { --~ TROLL
                female_id   = 2873,
                male_id     = 2861
            },
            { --~ UNDEAD
                female_id   = 2787,
                male_id     = 2775
            },
            { --~ VOID_ELF
                female_id   = 95881,
                male_id     = 95679
            },
            { --~ VULPERA
                female_id   = 144027,
                male_id     = 144119
            },
            { --~ WORGEN
                female_id   = 26568,
                male_id     = 19353
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126952,
                male_id     = 127326
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.RASP);
