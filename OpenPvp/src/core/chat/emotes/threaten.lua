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

opvp.Emote.THREATEN = opvp.Emote(
    {
        id     = opvp.EmoteId.THREATEN,
        name   = "threaten",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 67793,
                male_id     = 67798
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101902,
                male_id     = 101976
            },
            { --~ DRACTHYR
                female_id   = 212793,
                male_id     = 212518
            },
            { --~ DRAENEI
                female_id   = 67803,
                male_id     = 67808
            },
            { --~ DWARF
                female_id   = 77017,
                male_id     = 77008
            },
            { --~ EARTHEN
                female_id   = 262368,
                male_id     = 262443
            },
            { --~ GNOME
                female_id   = 67813,
                male_id     = 77026
            },
            { --~ GOBLIN
                female_id   = 67818,
                male_id     = 67823
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 112560,
                male_id     = 115396
            },
            { --~ HUMAN
                female_id   = 67828,
                male_id     = 67833
            },
            { --~ KUL_TIRAN
                female_id   = 127052,
                male_id     = 127146
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 100897,
                male_id     = 91938 --~ missing
            },
            { --~ MAGHAR_ORC
                female_id   = 110339,
                male_id     = 102770 --~ missing
            },
            { --~ MECHAGNOME
                female_id   = 144290,
                male_id     = 143907
            },
            { --~ NIGHT_ELF
                female_id   = 67838,
                male_id     = 76960
            },
            { --~ NIGHTBORNE
                female_id   = 92126, --~ missing
                male_id     = 92313 --~ missing
            },
            { --~ ORC
                female_id   = 67843,
                male_id     = 67848
            },
            { --~ PANDAREN
                female_id   = 67853,
                male_id     = 67858
            },
            { --~ TAUREN
                female_id   = 67863,
                male_id     = 67868
            },
            { --~ TROLL
                female_id   = 67873,
                male_id     = 76990
            },
            { --~ UNDEAD
                female_id   = 67878,
                male_id     = 67883
            },
            { --~ VOID_ELF
                female_id   = 92500, --~ missing
                male_id     = 122858
            },
            { --~ VULPERA
                female_id   = 144034,
                male_id     = 144126
            },
            { --~ WORGEN
                female_id   = 67888,
                male_id     = 67893
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126959,
                male_id     = 127333
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.THREATEN);
