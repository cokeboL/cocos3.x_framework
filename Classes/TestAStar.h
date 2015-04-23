#ifndef _TestAStart_H_
#define _TestAStart_H_

#include "cocos2d.h"
USING_NS_CC;

class TestAStar : public cocos2d::Layer
{
public:
	// there's no 'id' in cpp, so we recommend returning the class instance pointer
	static cocos2d::Scene* createScene();

	// Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
	virtual bool init();

	void onTouchesBegan(const std::vector<Touch*>& touches, Event *event);

	// implement the "static create()" method manually
	CREATE_FUNC(TestAStar);

	TMXTiledMap *tiledMap;
};

#endif // _TestAStart_H_
