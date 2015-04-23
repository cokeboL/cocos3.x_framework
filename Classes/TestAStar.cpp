#include "TestAStar.h"
#include "AStar.h"

USING_NS_CC;

Scene* TestAStar::createScene()
{
	// 'scene' is an autorelease object
	auto scene = Scene::create();

	// 'layer' is an autorelease object
	

	// add layer as a child to scene
	scene->addChild(TestAStar::create());

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
bool TestAStar::init()
{
	if (!Layer::init())
	{
		return false;
	}

	setTouchEnabled(true);

	tiledMap = TMXTiledMap::create("res/map.tmx");
	addChild(tiledMap);

	return true;
}

void TestAStar::onTouchesBegan(const std::vector<Touch*>& touches, Event *event)
//void TestAStar::onTouchBegan(Touch *touch, Event *unused_event)
{
	auto touchPos = touches[0]->getStartLocation();

	Size mapTiledNum = tiledMap->getMapSize();
	Size tiledSize = tiledMap->getTileSize();

	int sx = 0 / tiledSize.width;
	int sy = 0 / tiledSize.height;

	int ex = touchPos.x / tiledSize.width;
	int ey = touchPos.y / tiledSize.height;

	sy = mapTiledNum.height - sy -1;
	ey = mapTiledNum.height - ey - 1;
	
	AStar::getInstance()->findPath(this->tiledMap, 0, 0, touchPos.x, touchPos.y);
	//return true;
}
