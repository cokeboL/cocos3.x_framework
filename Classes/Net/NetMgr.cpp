#include "Net/NetMgr.h"
#include "CCLuaEngine.h"


NetMgr::~NetMgr()
{
	m_isRunning = false;
	m_MessageQueue.clear(); 
	this->close();
	if(m_msgThread)
	{
		m_msgThread->join();
	}
}

void NetMgr::onCreate()
{
	m_isRunning = true;
#if NET_USING_MUTI_THREAD
	m_msgThread = new std::thread(&NetMgr::updateMessage, this);
#endif
}

void NetMgr::onConnected()
{
	if(m_connCB)
	{
		LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_connCB, 0);
	}
}

void NetMgr::onDisconnected()
{
	if(m_disconnCB)
	{
		LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_disconnCB, 0);
	}
}

void NetMgr::onConnectError()
{
	if(m_errCB)
	{
		LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_errCB, 0);
	}
}

void NetMgr::onConnectTimeout()
{
	if(m_timeoutCB)
	{
		LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_timeoutCB, 0);
	}
}

void NetMgr::onMessag()
{
	if(m_msgCB)
	{
		TMessage &msg = m_MessageQueue.front();
		auto L = LuaEngine::getInstance()->getLuaStack()->getLuaState();

		lua_pushinteger(L, msg.error);
		lua_pushinteger(L, msg.cmd);
		lua_pushinteger(L, msg.action);
		lua_pushinteger(L, msg.flags);
		lua_pushinteger(L, msg.option);
		lua_pushinteger(L, msg.time);
  		lua_pushlstring(L, msg.message, msg.len);
		LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_msgCB, 7);
		m_MessageQueue.pop_front();
	}
}

void NetMgr::sendMessage(uint32_t len, uint8_t cmd, uint8_t action, char *msg)
{
	char *buf = (char*)malloc(pack_head_bytes+len);

	uint32_t *plen = (uint32_t*)buf;
	*plen++ = len;

	uint32_t *perror = plen;
	*perror++ = 0;

	uint8_t *pcmd = (uint8_t*)perror;
	*pcmd++ = cmd;

	uint8_t *paction = (uint8_t*)pcmd;
	*paction++ = action;

	uint8_t *pflags = (uint8_t*)paction;
	*pflags++ = 0;

	uint8_t *poptionn = (uint8_t*)pflags;
	*poptionn++ = 0;

	uint32_t *ptime = (uint32_t*)poptionn;
	*ptime++ = m_time++;

	memcpy((void*)ptime, msg, len);

	this->write(buf, pack_head_bytes+len);
	/*
	for(int idx = 0; idx < pack_head_bytes+len; idx++ ) {
		this->m_vSendBuffer.push_back(buf[idx]);
	}
	*/
	free(buf);
}

void NetMgr::registerCallBacks(int connCB, int disconnCB, int errCB, int timeoutCB, int msgCB)
{
	m_connCB = connCB;
	m_disconnCB = disconnCB;
	m_timeoutCB = timeoutCB;
	m_errCB = errCB;
	m_msgCB = msgCB;
}

bool NetMgr::httpGet(std::string & url, int cbFunc)
{
	HttpRequest* request = new HttpRequest();
    request->setUrl(url.c_str());
    request->setRequestType(HttpRequest::Type::GET);
    request->setResponseCallback(this, httpresponse_selector(NetMgr::httpResponse));
	
	char buf[16] = {0};
	sprintf(buf, "%x", cbFunc);
	std::string tag(buf);
    request->setTag(tag.c_str());

	requestMap[tag] = cbFunc;
	
    HttpClient::getInstance()->send(request);
    request->release();
	return true;
}


bool NetMgr::httpPost(std::string & url, std::string data, int cbFunc)
{
	HttpRequest* request = new HttpRequest();
    request->setUrl(url.c_str());
    request->setRequestType(HttpRequest::Type::POST);
    request->setResponseCallback(this, httpresponse_selector(NetMgr::httpResponse));
	request->setRequestData(data.c_str(), data.length()); 

	char buf[16] = {0};
	sprintf(buf, "%x", cbFunc);
	std::string tag(buf);
    request->setTag(tag.c_str());

	requestMap[tag] = cbFunc;
	
    HttpClient::getInstance()->send(request);
    request->release();
	return true;
}

void NetMgr::httpResponse(HttpClient *sender, HttpResponse *response)
{
    if (!response)
    {
        return;
    }
    
	bool ret = false;

	std::string tag(response->getHttpRequest()->getTag());
	if(!requestMap[tag])
	{
		return;
	}
    
    //int statusCode = response->getResponseCode();
    //char statusString[64] = {0};
    //sprintf(statusString, "HTTP Status Code: %d, tag = %s", statusCode, response->getHttpRequest()->getTag());
    //log("response code: %d", statusCode);
    
	std::string value;
    if (!response->isSucceed()) 
    {
        ret = false;
        value = std::string(response->getErrorBuffer());
    }
	else
	{
		ret = true;
		std::vector<char> *buffer = response->getResponseData();
		char *data = new char[buffer->size()+1];
		for (unsigned int i = 0; i < buffer->size(); i++)
		{
			data[i] = (*buffer)[i];
		}
		data[buffer->size()] = 0;
		value = std::string(data);
		delete [] data;
	}

	auto L = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	lua_pushboolean(L, ret);
  	lua_pushstring(L, value.c_str());
  	LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(requestMap[tag], 2);
	requestMap[tag] = 0;
	sender->destroyInstance();
}

void NetMgr::visit(Renderer *renderer, const Mat4& parentTransform, uint32_t parentFlags)
{ 
	if (this->m_nConnectStatus == EConnecting) {
		int nRet = this->m_Sock.IsConnected();	
		if (nRet == 1) {
			this->m_nConnectStatus = EConnected;
			this->onConnected();
		} else if (nRet < 0) {
			this->m_nConnectStatus = EConnectError;
			this->close();
			this->onConnectError();
		} else {
			struct timeval ccTimeNow;
			gettimeofday(&ccTimeNow, NULL);
			if(ccTimeNow.tv_sec - m_ccConnectTime.tv_sec >= SOCK_CONNECT_TIMEOUT){
				this->m_nConnectStatus = EConnectTimeout;
				this->close();
				this->onConnectTimeout();
			}
		}
	}
	if(!m_MessageQueue.empty())
	{
		this->onMessag();
	}
	if(this->m_nConnectStatus == EDisconnected)
	{
		this->close();
		this->onDisconnected();
	}

#if NET_USING_MUTI_THREAD
#else
	updateMessage();
#endif
}

void NetMgr::updateMessage()
{
#if NET_USING_MUTI_THREAD
	while(m_isRunning)
	{
		m_netMutex.lock();
#endif
		CCLOG("----------- NetMgr::updateMessage --------\n");
		if(this->m_nConnectStatus == EConnected)
		{
			
			while(m_Sock.IsReadable())
			{
				int nLen = m_Sock.Read(m_RecvBuffer, SOCK_RECVBUFFERSIZE);
				if (nLen == 0 || nLen  == SOCKET_ERROR) 
				//if (nLen == 0) 
				{
					this->m_nConnectStatus = EDisconnected;
					break;
				} 
				else 
				{
					this->read(m_RecvBuffer, nLen);
				}
			}
			/*
			if(m_Sock.IsWritable())
			{
				if(this->m_vSendBuffer.size() > 0)
				{
					int maxlen = SOCK_SENDBUFFERSIZE > m_vSendBuffer.size() ? m_vSendBuffer.size() : SOCK_SENDBUFFERSIZE;
					for(int idx = 0; idx < maxlen; idx++ ) {
						this->m_SendBuffer[idx] = m_vSendBuffer.at(idx);
					}
					int n = this->write(this->m_SendBuffer, maxlen);
					if(n > 0)
					{
						for(int idx = 0; idx < n; idx++ ) {
							this->m_vSendBuffer.pop_front();
						}
					}
				}
				
			}
			*/
		}
#if NET_USING_MUTI_THREAD		
		m_netMutex.unlock();
		ccsleep(40);
	}
#endif
}
