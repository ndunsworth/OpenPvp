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

opvp.Emote.TAUNT = opvp.Emote(
    {
        id     = opvp.EmoteId.TAUNT,
        name   = "taunt",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 67792,
                male_id     = 67797
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101900,
                male_id     = 101974
            },
            { --~ DRACTHYR
                female_id   = 212791,
                male_id     = 212516
            },
            { --~ DRAENEI
                female_id   = 67802,
                male_id     = 67807
            },
            { --~ DWARF
                female_id   = 77016,
                male_id     = 77007
            },
            { --~ EARTHEN
                female_id   = 0, --~ missing
                male_id     = 0, --~ missing
            },
            { --~ GNOME
                female_id   = 67812,
                male_id     = 77025
            },
            { --~ GOBLIN
                female_id   = 67817,
                male_id     = 67822
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 112559,
                male_id     = 115395
            },
            { --~ HUMAN
                female_id   = 67827,
                male_id     = 67832
            },
            { --~ KUL_TIRAN
                female_id   = 127050,
                male_id     = 127144
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 100896,
                male_id     = 0, --~ missing
            },
            { --~ MAGHAR_ORC
                female_id   = 110337,
                male_id     = 110412
            },
            { --~ MECHAGNOME
                female_id   = 144288,
                male_id     = 143905
            },
            { --~ NIGHT_ELF
                female_id   = 67837,
                male_id     = 76959
            },
            { --~ NIGHTBORNE
                female_id   = 0, --~ missing
                male_id     = 0 --~ missing
            },
            { --~ ORC
                female_id   = 67842,
                male_id     = 67847
            },
            { --~ PANDAREN
                female_id   = 67852,
                male_id     = 67857
            },
            { --~ TAUREN
                female_id   = 67862,
                male_id     = 67867
            },
            { --~ TROLL
                female_id   = 67872,
                male_id     = 76989
            },
            { --~ UNDEAD
                female_id   = 67882,
                male_id     = 67877
            },
            { --~ VOID_ELF
                female_id   = 92500, --~ missing
                male_id     = 122857
            },
            { --~ VULPERA
                female_id   = 144032,
                male_id     = 144124
            },
            { --~ WORGEN
                female_id   = 67887,
                male_id     = 67892
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126957,
                male_id     = 127331
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.TAUNT);
