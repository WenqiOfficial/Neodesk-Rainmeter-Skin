-- NeoDesk - GpuSplit (v3.2)
--
-- Sums UsageMonitor's GPU Engine samples by LUID + engine type,
-- then takes the larger engine type per adapter as its usage.
-- The progress bar is scaled proportionally when the two totals exceed 100%.

local N         = 32
local BAR_FULL  = 248

local PAT_ENGINE = '_luid_(0x%x%x%x%x%x%x%x%x)_(0x%x%x%x%x%x%x%x%x)_phys_(%d+)_eng_(%d+)_engtype_(%w+)'

local slotLuid  = { [1] = '', [2] = '' }
local last      = { i = -1, n = -1, iw = -1, nw = -1, l0 = '', l1 = '' }

local function normalize(v)
	if v < 0 then return 0 end
	return v
end

local function normalizeOverride(raw)
	if not raw or raw == '' then return '' end
	raw = string.lower(raw)

	local high, low = string.match(raw, '^(0x%x+)_(0x%x+)$')
	if high and low then
		return high .. '_' .. low
	end

	local onlyLow = string.match(raw, '^(0x%x+)$')
	if onlyLow then
		return '0x00000000_' .. onlyLow
	end

	return raw
end

local function publishSlots()
	if slotLuid[1] ~= last.l0 or slotLuid[2] ~= last.l1 then
		last.l0 = slotLuid[1]
		last.l1 = slotLuid[2]
		SKIN:Bang('!SetVariable', 'GpuLuid0', slotLuid[1])
		SKIN:Bang('!SetVariable', 'GpuLuid1', slotLuid[2])
		print('GpuSplit: Intel=' .. slotLuid[1] .. ' / NVIDIA=' .. slotLuid[2])
	end
end

function Initialize()
	slotLuid[1] = normalizeOverride(SKIN:GetVariable('GpuLuid0Override'))
	slotLuid[2] = normalizeOverride(SKIN:GetVariable('GpuLuid1Override'))

	if slotLuid[1] == '' or slotLuid[2] == '' then
		print('GpuSplit: GpuLuid0Override or GpuLuid1Override is missing.')
	end

	publishSlots()
end

function Update()
	local engine = {}

	for i = 1, N do
		local m = SKIN:GetMeasure('mInst' .. i)
		if m then
			local s = m:GetStringValue() or ''
			local v = m:GetValue() or 0
			if s ~= '' and v > 0 then
				local high, low, phys, engNo, engType = string.match(s, PAT_ENGINE)
				if high and low and engType then
					local luid = string.lower(high) .. '_' .. string.lower(low)
					local key = luid .. '|' .. engType
					engine[key] = (engine[key] or 0) + v
				end
			end
		end
	end

	local bus = {}
	for key, value in pairs(engine) do
		local luid = string.match(key, '^(.-)|')
		if not bus[luid] or value > bus[luid] then
			bus[luid] = value
		end
	end

	publishSlots()

	local v1, v2 = 0, 0
	for luid, value in pairs(bus) do
		if luid == slotLuid[1] then
			v1 = value
		elseif luid == slotLuid[2] then
			v2 = value
		end
	end

	local pct1, pct2 = normalize(v1), normalize(v2)
	local sum = pct1 + pct2
	local w1, w2

	if sum > 100 then
		w1 = BAR_FULL * pct1 / sum
		w2 = BAR_FULL - w1
	else
		w1 = BAR_FULL * pct1 / 100
		w2 = BAR_FULL * pct2 / 100
	end

	local pi, pn = math.floor(pct1 + 0.5), math.floor(pct2 + 0.5)
	local qi, qn = string.format('%.1f', w1), string.format('%.1f', w2)
	local changed = false

	if pi ~= last.i then
		last.i = pi
		SKIN:Bang('!SetVariable', 'GpuIntelPct', tostring(pi))
		changed = true
	end

	if pn ~= last.n then
		last.n = pn
		SKIN:Bang('!SetVariable', 'GpuNvPct', tostring(pn))
		changed = true
	end

	if qi ~= last.iw then
		last.iw = qi
		last.nw = qn
		SKIN:Bang('!SetVariable', 'GpuIntelW', qi)
		SKIN:Bang('!SetVariable', 'GpuNvW', qn)
		changed = true
	end

	if changed then
		SKIN:Bang('!UpdateMeter', 'ValGPU')
		SKIN:Bang('!UpdateMeter', 'FillGpuIntel')
		SKIN:Bang('!UpdateMeter', 'FillGpuNv')
		SKIN:Bang('!Redraw')
	end
end
