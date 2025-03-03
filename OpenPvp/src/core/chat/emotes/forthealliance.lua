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

opvp.Emote.FOR_THE_ALLIANCE = opvp.Emote(
    {
        id     = opvp.EmoteId.FOR_THE_ALLIANCE,
        name   = "forthealliance",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101883,
                male_id     = 101957
            },
            { --~ DRACTHYR
                female_id   = 212771,
                male_id     = 212497
            },
            { --~ DRAENEI
                female_id   = 62734,
                male_id     = 62735
            },
            { --~ DWARF
                female_id   = 77013,
                male_id     = 77004
            },
            { --~ EARTHEN
                female_id   = 262348,
                male_id     = 262423
            },
            { --~ GNOME
                female_id   = 62736,
                male_id     = 77022
            },
            { --~ GOBLIN
                female_id   = 0,
                male_id     = 0
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 0,
                male_id     = 0
            },
            { --~ HUMAN
                female_id   = 74679,
                male_id     = 74681
            },
            { --~ KUL_TIRAN
                female_id   = 127032,
                male_id     = 127126
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 62734,
                male_id     = 62735
            },
            { --~ MAGHAR_ORC
                female_id   = 0,
                male_id     = 0
            },
            { --~ MECHAGNOME
                female_id   = 62736,
                male_id     = 77022
            },
            { --~ NIGHT_ELF
                female_id   = 62739,
                male_id     = 76956
            },
            { --~ NIGHTBORNE
                female_id   = 0,
                male_id     = 0
            },
            { --~ ORC
                female_id   = 0,
                male_id     = 0
            },
            { --~ PANDAREN
                female_id   = 62742,
                male_id     = 62744
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
                female_id   = 95848,
                male_id     = 95848
            },
            { --~ VULPERA
                female_id   = 0,
                male_id     = 0
            },
            { --~ WORGEN
                female_id   = 74682,
                male_id     = 74687
            },
            { --~ ZANDALARI_TROLL
                female_id   = 0,
                male_id     = 0
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.FOR_THE_ALLIANCE);
