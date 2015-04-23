require'lfs'

local head =
[[
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
]]

local include = 
[[
LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../Classes/protobuf-lite \
$(LOCAL_PATH)/../../Classes/runtime \
$(LOCAL_PATH)/../../Classes \
$(LOCAL_PATH)/../../../cocos2d-x/external \
$(LOCAL_PATH)/../../../cocos2d-x/tools/simulator/libsimulator/lib \
$(LOCAL_PATH)/../../../cocos2d-x/cocos/2d \
$(LOCAL_PATH)/../../../cocos2d-x/extensions \
]]

--LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes
--$(LOCAL_PATH)/../../Classes
local tail =
[[

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END

]]

local cpps = {}
local includes = {}
function printdir(path)
	local i = 1 -- 这里是upvalue,每个子目录都不一样的哦，都从1开始数
	
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path .. '/' .. file
			local attr = lfs.attributes (f)
			if attr.mode == "directory" then
				printdir(f)
				f = '$(LOCAL_PATH)/../..' .. string.sub(f, string.find(f, "/Classes"), -1)
				if string.sub(f, -7) ~= "Classes" then
					includes[#includes+1] = f
				end
			else
				f = '../..' .. string.sub(f, string.find(f, "/Classes"), -1)
				if (string.sub(f, -2) == "pp") or (string.sub(f, -2) == "cc") then
					f = string.gsub(f, "//", "/")
					--head = head .. f .. ' \\\n'
					cpps[#cpps+1] = f .. ' \\\n'
				end
			end
		end
	end
	
end

function generate()
	printdir('../../frameworks/runtime-src/Classes')
	for i=1, #cpps do
		head = head .. cpps[i]
	end
	head = head .. 'hellolua/main.cpp\n\n'

	for i=1, #includes do
		if i~= #includes then
			include = include .. includes[i]  .. ' \\\n'
		else
			include = include .. includes[i]  .. '\n'
		end
	end
	
	local newFile =  io.open("../../frameworks/runtime-src/proj.android/jni/Android.mk", "w")
	newFile:write(head .. include .. tail)
	print(head .. include .. tail)
	newFile:close()
end

generate()

