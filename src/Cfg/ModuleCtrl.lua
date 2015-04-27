local ModuleCtrl =
{
	--** 主场景 *************************************************

	-- 主界面UI
	MainUIRemoveOnHide = true,
	MainUIResAsyncLoad = true,

	-- 卡牌界面
	CardRemoveOnHide = true,
	CardResAsyncLoad = true,
	CardShowEvent = "CardShowEvent",
	CardHideEvent = "CardHideEvent",

	-- 聊天界面
	ChatRemoveOnHide = true,
	ChatResAsyncLoad = true,
	ChatShowEvent = "ChatShowEvent",
	ChatHideEvent = "ChatHideEvent",

	-- 竞技场界面
	ArenaRemoveOnHide = true,
	ArenaResAsyncLoad = true,
	ArenaShowEvent = "ArenaShowEvent",
	ArenaHideEvent = "ArenaHideEvent",

	-- 战斗界面
	FightRemoveOnHide = true,
	FightResAsyncLoad = true,
	FightShowEvent = "CardShowEvent",
	FightHideEvent = "CardHideEvent",
	


	--** 战斗场景 *************************************************
}

return ModuleCtrl
