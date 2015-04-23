#ifndef __NETMANAGER_H__
#define __NETMANAGER_H__

#include "NetBase/net.h"
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"
#include <string>
#include <thread>
USING_NS_CC;
USING_NS_CC_EXT;
using namespace cocos2d::network;

#define NET_USING_MUTI_THREAD 1

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#define ccsleep Sleep
#else
#define ccsleep usleep
#endif

class NetMgr: public CNetBean
{
public:
	NetMgr(): CNetBean(), m_connCB(0), m_disconnCB(0), m_timeoutCB(0), m_errCB(0), m_msgCB(0), m_time(0), m_msgThread(0)
	{
	}
	
	virtual ~NetMgr();

	static NetMgr* getInstance() 
	{
		static NetMgr *pInstance = NULL;
		if(pInstance == NULL)
		{
			pInstance = new NetMgr();
			
			pInstance->autorelease();
		}
		return pInstance;
	}
	    
	//virtual const TMessage &getMessage();

	//virtual void popMessage();

	virtual void sendMessage(uint32_t len, uint8_t cmd, uint8_t action, char *pbMsg);
	
	void registerCallBacks(int connCB, int disconnCB, int errCB, int timeoutCB, int msgCB);

	bool httpGet(std::string & url, int cbFunc);

	bool httpPost(std::string & url, std::string data, int cbFunc);

	void pushMsg(TMessage msg)
	{
		m_MessageQueue.push_back(msg);
	}

	void suspend()
	{
		m_netMutex.lock();
	}

	void active()
	{
		m_netMutex.unlock();
	}
public:
	//virtual void visit();
	virtual void visit(Renderer *renderer, const Mat4& parentTransform, uint32_t parentFlags);

//protected:
	virtual void onCreate();
	
	virtual void onConnected();
	
	virtual void onDisconnected();
	
	virtual void onConnectError();
	
	virtual void onConnectTimeout();
	
	virtual void onMessag();

	void httpResponse(HttpClient *sender, HttpResponse *response);

	virtual void updateMessage();

private:
	int m_connCB;
	int m_disconnCB;
	int m_timeoutCB;
	int m_errCB;
	int m_msgCB;
	uint32_t m_time;
	
	std::thread *m_msgThread;

	std::map<std::string, int> requestMap;
};





#endif //__NETMANAGER_H__
