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

opvp.Emote.OPEN_FIRE = opvp.Emote(
    {
        id     = opvp.EmoteId.OPEN_FIRE,
        name   = "openfire",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9633,
                male_id     = 9668
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101894,
                male_id     = 101968
            },
            { --~ DRACTHYR
                female_id   = 212784,
                male_id     = 212509
            },
            { --~ DRAENEI
                female_id   = 9693,
                male_id     = 9718
            },
            { --~ DWARF
                female_id   = 2738,
                male_id     = 2726
            },
            { --~ EARTHEN
                female_id   = 262359,
                male_id     = 262434
            },
            { --~ GNOME
                female_id   = 2848,
                male_id     = 2836
            },
            { --~ GOBLIN
                female_id   = 19251,
                male_id     = 19141
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95546,
                male_id     = 95851
            },
            { --~ HUMAN
                female_id   = 2690,
                male_id     = 2678
            },
            { --~ KUL_TIRAN
                female_id   = 127043,
                male_id     = 127137
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96182,
                male_id     = 96250
            },
            { --~ MAGHAR_ORC
                female_id   = 110330,
                male_id     = 110405
            },
            { --~ MECHAGNOME
                female_id   = 144281,
                male_id     = 143898
            },
            { --~ NIGHT_ELF
                female_id   = 2762,
                male_id     = 2750
            },
            { --~ NIGHTBORNE
                female_id   = 96318,
                male_id     = 96386
            },
            { --~ ORC
                female_id   = 2714,
                male_id     = 2702
            },
            { --~ PANDAREN
                female_id   = 29820,
                male_id     = 28931
            },
            { --~ TAUREN
                female_id   = 2811,
                male_id     = 2799
            },
            { --~ TROLL
                female_id   = 2872,
                male_id     = 2860
            },
            { --~ UNDEAD
                female_id   = 2786,
                male_id     = 2774
            },
            { --~ VOID_ELF
                female_id   = 95861,
                male_id     = 95668
            },
            { --~ VULPERA
                female_id   = 144025,
                male_id     = 144117
            },
            { --~ WORGEN
                female_id   = 19439,
                male_id     = 19351
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126950,
                male_id     = 127324
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.OPEN_FIRE);
