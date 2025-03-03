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

opvp.Emote.FLEE = opvp.Emote(
    {
        id     = opvp.EmoteId.FLEE,
        name   = "flee",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9626,
                male_id     = 9658
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101880,
                male_id     = 101954
            },
            { --~ DRACTHYR
                female_id   = 212768,
                male_id     = 212494
            },
            { --~ DRAENEI
                female_id   = 9683,
                male_id     = 9708
            },
            { --~ DWARF
                female_id   = 2731,
                male_id     = 2719
            },
            { --~ EARTHEN
                female_id   = 262345,
                male_id     = 262420
            },
            { --~ GNOME
                female_id   = 2841,
                male_id     = 2829
            },
            { --~ GOBLIN
                female_id   = 19239,
                male_id     = 19130
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95535,
                male_id     = 95831
            },
            { --~ HUMAN
                female_id   = 2683,
                male_id     = 2671
            },
            { --~ KUL_TIRAN
                female_id   = 127029,
                male_id     = 127123
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96171,
                male_id     = 96239
            },
            { --~ MAGHAR_ORC
                female_id   = 110316,
                male_id     = 110391
            },
            { --~ MECHAGNOME
                female_id   = 144267,
                male_id     = 143884
            },
            { --~ NIGHT_ELF
                female_id   = 2755,
                male_id     = 2743
            },
            { --~ NIGHTBORNE
                female_id   = 96307,
                male_id     = 96375
            },
            { --~ ORC
                female_id   = 2707,
                male_id     = 2695
            },
            { --~ PANDAREN
                female_id   = 29798,
                male_id     = 28915
            },
            { --~ TAUREN
                female_id   = 2804,
                male_id     = 2791
            },
            { --~ TROLL
                female_id   = 2865,
                male_id     = 2853
            },
            { --~ UNDEAD
                female_id   = 2779,
                male_id     = 2767
            },
            { --~ VOID_ELF
                female_id   = 95842,
                male_id     = 95657
            },
            { --~ VULPERA
                female_id   = 144011,
                male_id     = 144103
            },
            { --~ WORGEN
                female_id   = 19426,
                male_id     = 19337
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126936,
                male_id     = 127310
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.FLEE);
