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

opvp.Emote.INCOMING = opvp.Emote(
    {
        id     = opvp.EmoteId.INCOMING,
        name   = "incoming",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9624,
                male_id     = 9664
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101888,
                male_id     = 101962
            },
            { --~ DRACTHYR
                female_id   = 212777,
                male_id     = 212503
            },
            { --~ DRAENEI
                female_id   = 9689,
                male_id     = 9714
            },
            { --~ DWARF
                female_id   = 2729,
                male_id     = 2717
            },
            { --~ EARTHEN
                female_id   = 262354,
                male_id     = 262429
            },
            { --~ GNOME
                female_id   = 2839,
                male_id     = 2827
            },
            { --~ GOBLIN
                female_id   = 19246,
                male_id     = 19137
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95543,
                male_id     = 95844
            },
            { --~ HUMAN
                female_id   = 2681,
                male_id     = 2669
            },
            { --~ KUL_TIRAN
                female_id   = 127037,
                male_id     = 127131
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96179,
                male_id     = 96247
            },
            { --~ MAGHAR_ORC
                female_id   = 110324,
                male_id     = 110399
            },
            { --~ MECHAGNOME
                female_id   = 144275,
                male_id     = 143892
            },
            { --~ NIGHT_ELF
                female_id   = 2753,
                male_id     = 2741
            },
            { --~ NIGHTBORNE
                female_id   = 96315,
                male_id     = 96383
            },
            { --~ ORC
                female_id   = 2705,
                male_id     = 2693
            },
            { --~ PANDAREN
                female_id   = 29812,
                male_id     = 28924
            },
            { --~ TAUREN
                female_id   = 2802,
                male_id     = 2789
            },
            { --~ TROLL
                female_id   = 2863,
                male_id     = 2851
            },
            { --~ UNDEAD
                female_id   = 2777,
                male_id     = 2765
            },
            { --~ VOID_ELF
                female_id   = 95857,
                male_id     = 95665
            },
            { --~ VULPERA
                female_id   = 144019,
                male_id     = 144111
            },
            { --~ WORGEN
                female_id   = 19516,
                male_id     = 19346
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126944,
                male_id     = 127318
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.INCOMING);
