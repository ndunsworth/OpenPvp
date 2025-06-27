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

opvp.ResourceMatchObjective = opvp.CreateClass(opvp.MatchObjective);

function opvp.ResourceMatchObjective:init()
    opvp.MatchObjective.init(self);

    self._data_provider = opvp.ResourceMatchObjectiveDataProvider();

    self._data_provider.valueChanged:connect(self, self._onValueChanged);

    self.valueChanged = opvp.Signal("opvp.MatchObjectiveStatusProvider.valueChanged");
end

function opvp.ResourceMatchObjective:maximumValue()
    return self._data_provider:maximumValue();
end

function opvp.ResourceMatchObjective:type()
    return opvp.MatchObjectiveType.RESOURCE;
end

function opvp.ResourceMatchObjective:value()
    return self._data_provider:value();
end

function opvp.ResourceMatchObjective:_onValueChanged(value)
    self:valueChanged(value);
end

function opvp.ResourceMatchObjective:_setDataProvider(provider)
    assert(opvp.IsInstance(provider, opvp.ResourceMatchObjectiveDataProvider));

    if provider == self._data_provider then
        return;
    end

    self._data_provider.changed:disconnect(self, self._onValueChanged);

    self._data_provider = provider;

    self._data_provider.changed:connect(self, self._onValueChanged);
end
