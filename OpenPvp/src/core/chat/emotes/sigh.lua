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

opvp.Emote.SIGH = opvp.Emote(
    {
        id     = opvp.EmoteId.SIGH,
        name   = "sigh",
        sounds = {
            { --~ BLOOD_ELF
                female_id      = 539187,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 539170,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ DARK_IRON_DWARF
                female_id      = 101898,
                male_id        = 101972
            },
            { --~ DRACTHYR
                female_id      = 212788,
                male_id        = 212513
            },
            { --~ DRAENEI
                female_id      = 539682,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 539495,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ DWARF
                female_id      = 539794,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 539873,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ EARTHEN
                female_id      = 262363,
                male_id        = 262438
            },
            { --~ GNOME
                female_id      = 540266,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 540277,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ GOBLIN
                female_id      = 0,
                male_id        = 0
            },
            { --~ HIGHMOUNTAIN_TAUREN
                female_id      = 95559,
                male_id        = 95880
            },
            { --~ HUMAN
                female_id      = 540524,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 540729,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ KUL_TIRAN
                female_id      = 127047,
                male_id        = 127141
            },
            { --~ LIGHTFORGED_DRAENEI
                female_id      = 96195,
                male_id        = 96263
            },
            { --~ MAGHAR_ORC
                female_id      = 110334,
                male_id        = 110409
            },
            { --~ MECHAGNOME
                female_id      = 144285,
                male_id        = 143902
            },
            { --~ NIGHT_ELF
                female_id      = 540865,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 540952,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ NIGHTBORNE
                female_id      = 96331,
                male_id        = 96399
            },
            { --~ ORC
                female_id      = 541151,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 541236,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ PANDAREN
                female_id      = 31724,
                male_id        = 30048
            },
            { --~ TAUREN
                female_id      = 542813,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 542900,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ TROLL
                female_id      = 543089,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 543088,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ UNDEAD
                female_id      = 542524,
                female_id_type = opvp.SoundType.FileData,
                male_id        = 542610,
                male_id_type   = opvp.SoundType.FileData
            },
            { --~ VOID_ELF
                female_id      = 95886,
                male_id        = 95681
            },
            { --~ VULPERA
                female_id      = 144029,
                male_id        = 144121
            },
            { --~ WORGEN
                female_id      = 0,
                male_id        = 0
            },
            { --~ ZANDALARI_TROLL
                female_id      = 126954,
                male_id        = 127328
            }
        }
    }
);

table.insert(opvp.Emote.EMOTES, opvp.Emote.SIGH);
