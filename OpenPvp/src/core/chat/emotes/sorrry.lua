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

opvp.Emote.SORRY = opvp.Emote(
    {
        id     = opvp.EmoteId.SORRY,
        name   = "sorry",
        sounds = {
            { --~ BLOOD_ELF
                female_id   = 67791,
                male_id     = 67796
            },
            { --~ DARK_IRON_DWARF
                female_id   = 101899,
                male_id     = 101973
            },
            { --~ DRACTHYR
                female_id   = 212790,
                male_id     = 212515
            },
            { --~ DRAENEI
                female_id   = 67801,
                male_id     = 67806
            },
            { --~ DWARF
                female_id   = 77015,
                male_id     = 77006
            },
            { --~ EARTHEN
                female_id   = 243959,
                male_id     = 262433
            },
            { --~ GNOME
                female_id   = 67811,
                male_id     = 77024
            },
            { --~ GOBLIN
                female_id   = 67816,
                male_id     = 67821
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id   = 112558,
                male_id     = 115394
            },
            { --~ HUMAN
                female_id   = 67826,
                male_id     = 67831
            },
            { --~ KUL_TIRAN
                female_id   = 127049,
                male_id     = 127143
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id   = 100895,
                male_id     = 67805
            },
            { --~ MAGHAR_ORC
                female_id   = 110336,
                male_id     = 110411
            },
            { --~ MECHAGNOME
                female_id   = 144287,
                male_id     = 143904
            },
            { --~ NIGHT_ELF
                female_id   = 67836,
                male_id     = 76958
            },
            { --~ NIGHTBORNE
                female_id   = 92123,
                male_id     = 91322
            },
            { --~ ORC
                female_id   = 67841,
                male_id     = 67846
            },
            { --~ PANDAREN
                female_id   = 67851,
                male_id     = 67856
            },
            { --~ TAUREN
                female_id   = 67861,
                male_id     = 67866
            },
            { --~ TROLL
                female_id   = 67871,
                male_id     = 76988
            },
            { --~ UNDEAD
                female_id   = 67876,
                male_id     = 67881
            },
            { --~ VOID_ELF
                female_id   = 92497,
                male_id     = 122856
            },
            { --~ VULPERA
                female_id   = 144031,
                male_id     = 144123
            },
            { --~ WORGEN
                female_id   = 67886,
                male_id     = 67891
            },
            { --~ ZANDALARI_TROLL
                female_id   = 126956,
                male_id     = 127330
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.SORRY);
