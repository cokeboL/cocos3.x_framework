#include "AStar.h"

#define MAP_LAYER "bg"
#define COLLIDER_LAYER "blocks"
#define COLLIDER "block"

AStar AStar::instance;

AStar::AStar()
{
}

AStar::~AStar()
{
}

AStar* AStar::getInstance()
{
	return &instance;
}

// 取得成本最小的结点
AstartNode* AStar::getMinCostNode(AstarList *astar)
{
    AstartNode* min = astar->openHead->next;
	AstartNode* current = min ? min->next : 0;

    while (current)
    {
        if (current->h < min->h)
        {
            min = current;
        }
        current = current->next;
    }

    return min;
}

// 添加结点到链表
void AStar::addNode(AstartNode* head, AstartNode* node)
{
    while (head->next)
    {
        head = head->next;
    }

    head->next = node;
}

// 从链表中删除结点
void AStar::removeNode(AstartNode* head, AstartNode* node)
{
        AstartNode* current = head;
    head = head->next;

    while (head != NULL)
    {
        if (head == node)
        {
            current->next = head->next;
            head->next = NULL;
            break;
        }
        else
        {
            current = head;
            head = head->next;
        }
    }
}


// 检查Tile是否在链表中
bool AStar::isNodeInList(int x, int y, AstartNode* head)
{
    //bool result = false;
    head = head->next;

    while (head != NULL)
    {
        if (head->x == x && head->y == y)
        {
			return true;
        }
        else
        {
            head = head->next;
        }
    }

    return false;
}

// 检查Tile是否是地图的路障
bool AStar::isBlock(int x, int y)
{
	Size size = tiledMap->getMapSize();
	Size size2 = tiledMap->getContentSize();
	if (x >= 0 && x < size.width && y >= 0 && y < size.height)
    {        
		TMXLayer* mapLayer = tiledMap->getLayer(COLLIDER_LAYER);
		unsigned int gid = mapLayer->getTileGIDAt(Vec2(x, y));

		if (gid && tiledMap->getPropertiesForGID(gid).asValueMap()[COLLIDER].asBool())
		{
			return true;
		}
    }
    else
    {
        return false;
    }

    return false;
}

static std::vector<Sprite*> sprites;
bool AStar::findPath(TMXTiledMap* tmap, int sx, int sy, int ex, int ey)
{
    astarPathCount = 0;
    astarPathList.clear();

    tiledMap = tmap;
	Size mapTiledNum = tiledMap->getMapSize();
	Size tiledSize = tiledMap->getTileSize();

	startX = sx / tiledSize.width;
	startY = mapTiledNum.height - sy / tiledSize.height;
   	endX = ex / tiledSize.width;
	endY = mapTiledNum.height - ey / tiledSize.height;
	
	if (isBlock(endX, endY))
    {
		for (auto it = sprites.begin(); it != sprites.end(); it++)
		{
			(*it)->setColor(Color3B(255, 255, 255));
		}
		sprites.clear();
        return false;
    }

	//检测周围8个tile
    int offsetX[] = {0, 0, -1, 1, -1, -1, 1, 1};
    int offsetY[] = {1, -1, 0, 0, 1, -1, 1, -1};
    
	//检测周围4个tile
	//int offsetX[] = { 0, 0, -1, 1 };
	//int offsetY[] = { 1, -1, 0, 0 };

	AstarList astar;

    AstartNode* currentNode = 0;
	AstartNode* startNode = new AstartNode(0, startX, startY, endX, endY);

	// 把起始结点加入OpenList
    addNode(astar.openHead, startNode);

    // 如查OpenList不为空
    while (astar.openHead->next != NULL)
    {
        // 取得成本最小的结点
        currentNode = getMinCostNode(&astar);

        // 如果当前结点是目标结点
        if (currentNode->x == endX && currentNode->y == endY)
        {
            break;
        }
        else
        {
            // 把当前结点添加到Closed表中
            addNode(astar.closedHead, currentNode);
            // 把当前结点从Open表中删除
            removeNode(astar.openHead, currentNode);

            for (int i = 0; i < 8; i++)
            {
                int x = currentNode->x + offsetX[i];
                int y = currentNode->y + offsetY[i];

				if (x < 0 || x >= tiledMap->getMapSize().width || y < 0 || y >= tiledMap->getMapSize().height)
                {
                    continue;
                }
                else
                {
					if (!isNodeInList(x, y, astar.openHead)
						&& !isNodeInList(x, y, astar.closedHead)
                        && !isBlock(x, y))
                    {
						AstartNode* endNode = new AstartNode(currentNode, x, y, endX, endY);
                        addNode(astar.openHead, endNode);
                    }
                }
            }
        }
    }

    //if (astar.openHead->next && (currentNode->x != endX || currentNode->y != endY))
	if (currentNode && (currentNode->x != endX || currentNode->y != endY))
    {
        astarPathCount = 0;
        return false;
    }
    else
    {
		for (auto it = sprites.begin(); it != sprites.end(); it++)
		{
			(*it)->setColor(Color3B(255, 255, 255));
		}
		sprites.clear();
		//currentNode = currentNode->father; //不包括起始点
		while (currentNode) //包括起始点
        {
			/*
			TMXLayer* mapLayer = tiledMap->layerNamed(MAP_LAYER);
			Sprite* tile = mapLayer->getTileAt(ccp(currentNode->x, currentNode->y));
			tile->setColor(Color3B(255,0,0));
			sprites.push_back(tile);
			auto pos = tile->getPosition();
			auto size = tile->getContentSize();
			pos.x += size.width / 2;
			pos.y += size.height / 2;
			astarPathList.push_back(pos);
			*/
			astarPathList.push_back(Vec2((currentNode->x+0.5)*tiledSize.width,(mapTiledNum.height-currentNode->y-0.5)*tiledSize.height));
            currentNode = currentNode->father;
            astarPathCount++;
        }
		std::reverse(astarPathList.begin(), astarPathList.end());
        return true;
    }

    return false;
}

vector<Vec2> &AStar::getPath()
{
	return astarPathList;
}