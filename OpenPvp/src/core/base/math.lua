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

local _, OpenPvpLib = ...
local opvp = OpenPvpLib;

local opvp_log2base_debruijn_bit_position = {
  0, 9, 1, 10, 13, 21, 2, 29, 11, 14, 16, 18, 22, 25, 3, 30,
  8, 12, 20, 28, 15, 17, 24, 7, 19, 27, 23, 6, 26, 5, 4, 31
}

local opvp_ffs_debruijn_bit_position = {
  0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
  31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
}

opvp.math = {};

function opvp.math.clamp(value, low, high)
    if value <= low then
        return low;
    elseif value >= high then
        return high
    else
        return value;
    end
end

function opvp.math.ffs(n)
    return opvp_ffs_debruijn_bit_position[
        bit.rshift(
            bit.band(n, -n) * 0x077CB531,
            27
        ) + 1
    ];
end

function opvp.math.lerp(a, b, mix)
    return Lerp(a, b, mix);
end

function opvp.math.popcount(n)
    n = n - bit.band(bit.rshift(n, 1), 0x55555555);
    n = bit.band(n, 0x33333333) + bit.band(bit.rshift(n, 2), 0x33333333);

    return (
        bit.rshift(
        bit.band(n + bit.rshift(n, 4), 0xF0F0F0F) * 0x1010101,
        24
        )
    );
end

function opvp.math.logBase2(value)
    value = opvp.math.floorPowerOfTwo(value);

    return opvp_log2base_debruijn_bit_position[bit.rshift(value * 0x07C4ACDD, 27) + 1];
end

function opvp.math.floorPowerOfTwo(n)
    n = bit.bor(n, bit.rshift(n, 1));
    n = bit.bor(n, bit.rshift(n, 2));
    n = bit.bor(n, bit.rshift(n, 4));
    n = bit.bor(n, bit.rshift(n, 8));
    n = bit.bor(n, bit.rshift(n, 16));

    return bit.rshift(n + 1, 1);
end

function opvp.math.ceilPowerOfTwo(n)
    n = n - 1;
    n = bit.bor(n, bit.rshift(n, 1));
    n = bit.bor(n, bit.rshift(n, 2));
    n = bit.bor(n, bit.rshift(n, 4));
    n = bit.bor(n, bit.rshift(n, 8));
    n = bit.bor(n, bit.rshift(n, 16));

    return n + 1;
end
