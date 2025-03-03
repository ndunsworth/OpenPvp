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

opvp.Emote.LAUGH = opvp.Emote(
    {
        id     = opvp.EmoteId.LAUGH,
        name   = "laugh",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9648,
                male_id     = 9652
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101890,
                male_id     = 101964
            },
            { --~ DRACTHYR
                female_id   = 212779,
                male_id     = 212505
            },
            { --~ DRAENEI
                female_id   = 9677,
                male_id     = 9702
            },
            { --~ DWARF
                female_id   = 6894,
                male_id     = 6903
            },
            { --~ EARTHEN
                female_id   = 261012,
                male_id     = 261013
            },
            { --~ GNOME
                female_id   = 6908,
                male_id     = 6913
            },
            { --~ GOBLIN
                female_id   = 19248,
                male_id     = 23330
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95556,
                male_id     = 95876
            },
            { --~ HUMAN
                female_id   = 6918,
                male_id     = 6923
            },
            { --~ KUL_TIRAN
                female_id   = 127039,
                male_id     = 127133
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96192,
                male_id     = 96260
            },
            { --~ MAGHAR_ORC
                female_id   = 110326,
                male_id     = 110401
            },
            { --~ MECHAGNOME
                female_id   = 144277,
                male_id     = 143894
            },
            { --~ NIGHT_ELF
                female_id   = 6928,
                male_id     = 6933
            },
            { --~ NIGHTBORNE
                female_id   = 96328,
                male_id     = 96396
            },
            { --~ ORC
                female_id   = 6938,
                male_id     = 6943
            },
            { --~ PANDAREN
                female_id   = 31723,
                male_id     = 30046
            },
            { --~ TAUREN
                female_id   = 6948,
                male_id     = 6953
            },
            { --~ TROLL
                female_id   = 6958,
                male_id     = 6963
            },
            { --~ UNDEAD
                female_id   = 6969,
                male_id     = 6974
            },
            { --~ VOID_ELF
                female_id   = 95879,
                male_id     = 95678
            },
            { --~ VULPERA
                female_id   = 144021,
                male_id     = 144113
            },
            { --~ WORGEN
                female_id   = 23319,
                male_id     = 19348
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126946,
                male_id     = 127320
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.LAUGH);
