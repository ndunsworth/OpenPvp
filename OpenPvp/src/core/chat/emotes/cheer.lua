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

opvp.Emote.CHEER = opvp.Emote(
    {
        id     = opvp.EmoteId.CHEER,
        name   = "cheer",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 9632,
                male_id     = 9656
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101838,
                male_id     = 101912
            },
            { --~ DRACTHYR
                female_id   = 212722,
                male_id     = 212449
            },
            { --~ DRAENEI
                female_id   = 9681,
                male_id     = 9706
            },
            { --~ DWARF
                female_id   = 2737,
                male_id     = 2725
            },
            { --~ EARTHEN
                female_id   = 262302,
                male_id     = 262379
            },
            { --~ GNOME
                female_id   = 2847,
                male_id     = 2835
            },
            { --~ GOBLIN
                female_id   = 19202,
                male_id     = 19089
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 95552,
                male_id     = 95864
            },
            { --~ HUMAN
                female_id   = 2689,
                male_id     = 2677
            },
            { --~ KUL_TIRAN
                female_id   = 126987,
                male_id     = 127081
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 96188,
                male_id     = 96256
            },
            { --~ MAGHAR_ORC
                female_id   = 110274,
                male_id     = 110349
            },
            { --~ MECHAGNOME
                female_id   = 144263,
                male_id     = 143842
            },
            { --~ NIGHT_ELF
                female_id   = 2761,
                male_id     = 2749
            },
            { --~ NIGHTBORNE
                female_id   = 96324,
                male_id     = 96392
            },
            { --~ ORC
                female_id   = 2713,
                male_id     = 2701
            },
            { --~ PANDAREN
                female_id   = 29791,
                male_id     = 28926
            },
            { --~ TAUREN
                female_id   = 2810,
                male_id     = 2797
            },
            { --~ TROLL
                female_id   = 2871,
                male_id     = 2859
            },
            { --~ UNDEAD
                female_id   = 2785,
                male_id     = 2773
            },
            { --~ VOID_ELF
                female_id   = 95873,
                male_id     = 95674
            },
            { --~ VULPERA
                female_id   = 144007,
                male_id     = 144099
            },
            { --~ WORGEN
                female_id   = 19517,
                male_id     = 19297
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126894,
                male_id     = 127268
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.CHEER);
