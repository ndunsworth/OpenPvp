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

opvp.Emote.TEMPLATE = opvp.Emote(
    {
        id     = opvp.EmoteId.TEMPLATE,
        name   = "template",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DARK_IRON_DWARF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DRACTHYR
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DRAENEI
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ DWARF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ EARTHEN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ GNOME
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ GOBLIN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ HUMAN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ KUL_TIRAN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ MAGHAR_ORC
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ MECHAGNOME
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ NIGHT_ELF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ NIGHTBORNE
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ ORC
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ PANDAREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ TAUREN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ TROLL
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ UNDEAD
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ VOID_ELF
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ VULPERA
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ WORGEN
                female_id   = 0000,
                male_id     = 0000
            },
            { --~ ZANDALARI_TROLL
                female_id   = 0000,
                male_id     = 0000
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.TEMPLATE);
