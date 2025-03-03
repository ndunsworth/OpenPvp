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

opvp.Emote.UNKNOWN = opvp.Emote(
    {
        id     = opvp.EmoteId.UNKNOWN,
        name   = "",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 0,
                male_id     = 0
            },
            { --~ DARK_IRON_DWARF
                female_id   = 0,
                male_id     = 0
            },
            { --~ DRACTHYR
                female_id   = 0,
                male_id     = 0
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
                female_id   = 0,
                male_id     = 0
            },
            { --~ GNOME
                female_id   = 0,
                male_id     = 0
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
                female_id   = 0,
                male_id     = 0
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
                female_id   = 0,
                male_id     = 0
            },
            { --~ ORC
                female_id   = 0,
                male_id     = 0
            },
            { --~ PANDAREN
                female_id   = 0,
                male_id     = 0
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
                female_id   = 0,
                male_id     = 0
            },
            { --~ VULPERA
                female_id   = 0,
                male_id     = 0
            },
            { --~ WORGEN
                female_id   = 0,
                male_id     = 0
            },
            { --~ ZANDALARI_TROLL
                female_id   = 0,
                male_id     = 0
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.UNKNOWN);
