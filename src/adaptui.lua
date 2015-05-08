UI_PATH = "res/csd/720_1280"
MODULE_SCALE = 1

local ui_solutions = 
{
	{640, 1136},
	{750, 1334},
	{768, 1024},
}

local module_design_size = {720, 1280}

local function auto_adapt()
	local size = {width=768, height=1136} --cc.Director:getInstance():getWinSize()
	real_rate = size.width/size.height
	
	print("********************\n")
	print("real_rate: ", real_rate, " w: ", size.width, " h: ", size.height)

	local ui_rates = {}
	for i, v in ipairs(ui_solutions) do
		ui_rates[i] = v[1] / v[2]
		print("rate " .. i .. ": ", ui_rates[i], " w: ", v[1], " h: ", v[2])
	end
	
	local curr_rate = 0
	local min_sub_idx = 1
	local min_sub_rate = 0
	for i, v in ipairs(ui_rates) do
		curr_rate = math.abs(ui_rates[i]-real_rate)/real_rate

		if i == 1 then
			min_sub_idx = i
			min_sub_rate = curr_rate
		else
			if curr_rate < min_sub_rate then
				min_sub_idx = i
				min_sub_rate = curr_rate
			end
		end
	end

	local ui_path = "res/csd/" .. ui_solutions[min_sub_idx][1] .. '_' .. ui_solutions[min_sub_idx][2]
	local module_scale = math.min(ui_solutions[min_sub_idx][1] / module_design_size[1], ui_solutions[min_sub_idx][2] / module_design_size[2])

	print("ui_path: ", ui_path)
	print("module_scale: ", module_scale)
	print("********************\n")

	return ui_path, module_scale
end

UI_PATH, MODULE_SCALE = auto_adapt()
