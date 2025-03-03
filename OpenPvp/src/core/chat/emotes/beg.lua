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

opvp.Emote.BEG = opvp.Emote(
    {
        id     = opvp.EmoteId.BEG,
        name   = "beg",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101836,
                male_id     = 101910
            },
            { --~ DRACTHYR
                female_id   = 212718,
                male_id     = 212448
            },
            { --~ DRAENEI
                female_id   = 0,
                male_id     = 0
            },
            { --~ DWARF
                female_id   = 0,
                male_id     = 0
            },
            { --~ EARTHEN
                female_id   = 262300,
                male_id     = 262377
            },
            { --~ GNOME
                female_id   = 0,
                male_id     = 0
            },
            { --~ GOBLIN
                female_id   = 0,
                male_id     = 19087
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95532,
                male_id     = 95871
            },
            { --~ HUMAN
                female_id   = 0,
                male_id     = 0
            },
            { --~ KUL_TIRAN
                female_id   = 126984,
                male_id     = 127078
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96132,
                male_id     = 96200
            },
            { --~ MAGHAR_ORC
                female_id   = 110271,
                male_id     = 110346
            },
            { --~ MECHAGNOME
                female_id   = 144260,
                male_id     = 143839
            },
            { --~ NIGHT_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ NIGHTBORNE
                female_id   = 96268,
                male_id     = 96336
            },
            { --~ ORC
                female_id   = 0,
                male_id     = 0
            },
            { --~ PANDAREN
                female_id   = 29787,
                male_id     = 28921
            },
            { --~ TAUREN
                female_id   = 0,
                male_id     = 0
            },
            { --~ TROLL
                female_id   = 0,
                male_id     = 0
            },
            { --~ UNDEAD
                female_id   = 0,
                male_id     = 0
            },
            { --~ VOID_ELF
                female_id   = 95835,
                male_id     = 95616
            },
            { --~ VULPERA
                female_id   = 144004,
                male_id     = 144096
            },
            { --~ WORGEN
                female_id   = 0,
                male_id     = 0
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126891,
                male_id     = 127265
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.BEG);
