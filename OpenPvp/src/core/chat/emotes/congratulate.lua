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

opvp.Emote.CONGRATULATE = opvp.Emote(
    {
        id     = opvp.EmoteId.CONGRATULATE,
        name   = "congratulate",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9641,
                male_id     = 9657
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101840,
                male_id     = 101914
            },
            { --~ DRACTHYR
                female_id   = 212724,
                male_id     = 212451
            },
            { --~ DRAENEI
                female_id   = 9682,
                male_id     = 9707
            },
            { --~ DWARF
                female_id   = 6104,
                male_id     = 6113
            },
            { --~ EARTHEN
                female_id   = 262304,
                male_id     = 262297
            },
            { --~ GNOME
                female_id   = 6122,
                male_id     = 6131
            },
            { --~ GOBLIN
                female_id   = 19199,
                male_id     = 19091
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95534,
                male_id     = 95891
            },
            { --~ HUMAN
                female_id   = 6141,
                male_id     = 6168
            },
            { --~ KUL_TIRAN
                female_id   = 126989,
                male_id     = 127083
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96134,
                male_id     = 96202
            },
            { --~ MAGHAR_ORC
                female_id   = 110276,
                male_id     = 110351
            },
            { --~ MECHAGNOME
                female_id   = 144265,
                male_id     = 143844
            },
            { --~ NIGHT_ELF
                female_id   = 6177,
                male_id     = 6186
            },
            { --~ NIGHTBORNE
                female_id   = 96270,
                male_id     = 96338
            },
            { --~ ORC
                female_id   = 6357,
                male_id     = 6366
            },
            { --~ PANDAREN
                female_id   = 29793,
                male_id     = 28927
            },
            { --~ TAUREN
                female_id   = 6375,
                male_id     = 6384
            },
            { --~ TROLL
                female_id   = 6393,
                male_id     = 6402
            },
            { --~ UNDEAD
                female_id   = 6411,
                male_id     = 6420
            },
            { --~ VOID_ELF
                female_id   = 95840,
                male_id     = 95618
            },
            { --~ VULPERA
                female_id   = 144009,
                male_id     = 144101
            },
            { --~ WORGEN
                female_id   = 19378,
                male_id     = 19299
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126896,
                male_id     = 127270
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.CONGRATULATE);
