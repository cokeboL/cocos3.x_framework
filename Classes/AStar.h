#ifndef _AStar_H_
#define _AStar_H_

#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
using namespace std;

// 链表结点结构
typedef class CAstartNode{
public:
	CAstartNode():
		father(0),
		x(0),
		y(0),
		next(0),
		f(0),
		g(0),
		h(0)
	{
	}

	CAstartNode(CAstartNode* father_, int x_, int y_, int endX, int endY) :
		father(father_),
		x(x_),
		y(y_),
		next(0)
	{
		f = father ? father->f + 1 : 0;
		g = abs(endX - x) + abs(endY - y);
		h = f + g;
	}

	~CAstartNode()
	{
	}
    // 结点 x 坐标
    short x;

    //结点 y 坐标
    short y;

    // 当前结点到起始结点的代价
    short f;

    // 当前结点到目标结点的代价
    short g;

    // 总代价
    short h;

    // 当前结点父结点
	class CAstartNode* father;

    // 当前结点子结点
	class CAstartNode* next;
} AstartNode;

// A*算法结构
typedef class CAstarList
{
public:
	CAstarList()
	{
		openHead = new AstartNode;
		closedHead = new AstartNode;
	}

	~CAstarList()
	{
		AstartNode* node;
		while (openHead != NULL)
		{
			node = openHead;
			openHead = openHead->next;
			delete node;
		}

		while (closedHead != NULL)
		{
			node = closedHead;
			closedHead = closedHead->next;
			delete node;
		}
	}

    // open 表
    AstartNode* openHead;
    
	// closed 表
    AstartNode* closedHead;
} AstarList;

class AStar
{
public:
	AStar();
	~AStar();

	// 路径长度
	int astarPathCount;

	// 路经表
	vector<Vec2> astarPathList;

	TMXTiledMap* tiledMap;

	int startX;
	int startY;
	int endX;
	int endY;

	static AStar instance;

	static AStar* getInstance();

    // 取得成本最小的结点
	AstartNode* getMinCostNode(AstarList *astarList);

    // 添加结点到链表
    void addNode(AstartNode* head, AstartNode* node);

    // 从链表中删除结点
    void removeNode(AstartNode* head, AstartNode* node);

    // 检查Tile是否在链表中
    bool isNodeInList(int x, int y, AstartNode* head);

    // 检查Tile是否是地图的路障
    bool isBlock(int x, int y);

    bool findPath(TMXTiledMap* tiledMap, int startX, int startY, int endX, int endY);

	vector<Vec2> &getPath();
};

#endif // _AStar_H_