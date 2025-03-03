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

opvp.Emote.FOR_THE_HORDE = opvp.Emote(
    {
        id     = opvp.EmoteId.FOR_THE_HORDE,
        name   = "forthehorde",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 62732,
                male_id     = 56513
            },
            { --~ DARK_IRON_DWARF
                female_id   = 0,
                male_id     = 0
            },
            { --~ DRACTHYR
                female_id   = 212772,
                male_id     = 212787
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
                female_id   = 262349,
                male_id     = 262424
            },
            { --~ GNOME
                female_id   = 0,
                male_id     = 0
            },
            { --~ GOBLIN
                female_id   = 62737,
                male_id     = 62738
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 62746,
                male_id     = 74674
            },
            { --~ HUMAN
                female_id   = 0,
                male_id     = 0
            },
            { --~ KUL_TIRAN
                female_id   = 0,
                male_id     = 0
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 0,
                male_id     = 0
            },
            { --~ MAGHAR_ORC
                female_id   = 110319,
                male_id     = 110394
            },
            { --~ MECHAGNOME
                female_id   = 0,
                male_id     = 0
            },
            { --~ NIGHT_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ NIGHTBORNE
                female_id   = 96310,
                male_id     = 96378
            },
            { --~ ORC
                female_id   = 62740,
                male_id     = 62741
            },
            { --~ PANDAREN
                female_id   = 62743,
                male_id     = 62745
            },
            { --~ TAUREN
                female_id   = 62746,
                male_id     = 74674
            },
            { --~ TROLL
                female_id   = 74691,
                male_id     = 76986
            },
            { --~ UNDEAD
                female_id   = 62747,
                male_id     = 62748
            },
            { --~ VOID_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ VULPERA
                female_id   = 144014,
                male_id     = 144106
            },
            { --~ WORGEN
                female_id   = 0,
                male_id     = 0
            },
            { --~ ZANDALARI_TROLL
                female_id   = 74691,
                male_id     = 76986
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.FOR_THE_HORDE);
