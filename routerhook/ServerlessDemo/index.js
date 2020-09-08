'use strict';
const fs = require('fs')
const AXIOS = require('axios')
const CFS_BASE_PATH = '/mnt/' // 请将此配置修改为同serverless.yaml中的inputs->cfs->localMountDir完全相同

exports.main_handler = async (event, context) => {
    console.log("Hello World")
    console.log(event)
    // console.log(context)

    // 开始解构处理event事件，触发器类型为API网关事件，详见说明文档：
    const {
        body,
        headerParameters: {
            basicAuth
        },
        path,
        pathParameters,
        queryString,
        requestContext: {
            sourceIp // 请求的远端IP，也可以看作是你路由器的公网IP
        }
    } = event

    // 可以根据path做一些自定义路由的处理，这里不过多演示，只有当serverless.yaml中指定了header或者path的参数后，pathParameters或者headerParameters中才会有解析的参数

    // 验证basicAuth内容和路由器上RouterHook插件的Header中配置的basicAuth内容是否一致
    if (basicAuth !== 'woshiyigexiaokeai') return '请不要访问我的服务！'

    // 验证通过，则处理消息内容，具体请参看RouterHook消息体说明文档：
    if (!body || body.length < 1) return '你好，你发了个啥？'
    const jsonBody = JSON.parse(body)
    switch (jsonBody.msgTYPE) {
        case 'ifUP': // 网络重拨上线消息：https://github.com/sdlyfjx/rogsoft/tree/master/routerhook#%E7%BD%91%E7%BB%9C%E9%87%8D%E6%8B%A8%E4%B8%8A%E7%BA%BF%E6%B6%88%E6%81%AF%E6%A0%BC%E5%BC%8F%E9%80%82%E9%85%8Difttt
        case 'newDHCP': // 设备上线消息：https://github.com/sdlyfjx/rogsoft/tree/master/routerhook#%E8%AE%BE%E5%A4%87%E4%B8%8A%E7%BA%BF%E6%B6%88%E6%81%AF%E6%A0%BC%E5%BC%8F%E9%80%82%E9%85%8Difttt
        case 'manuINFO': // 手动推送消息，https://github.com/sdlyfjx/rogsoft/tree/master/routerhook#%E8%AE%BE%E5%A4%87%E4%B8%8A%E7%BA%BF%E6%B6%88%E6%81%AF%E6%A0%BC%E5%BC%8F%E9%80%82%E9%85%8Difttt
        case 'cronINFO': // 定时推送消息，消息内容几乎和manuINFO相同
            return 'success'
        default:
            console.log('没有msgTYPE的消息，应该是虚拟传感器消息')
            break
    }
    // 如果上面的switch没有return，说明可能不是一个msgTYPE的消息，所以尝试处理虚拟传感器消息
    if (jsonBody.hasOwnProperty('state') && jsonBody.hasOwnProperty('attributes')) {
        // 说明是一个HASS格式的消息
        const {
            state,
            attributes: {
                unit_of_measurement,
                friendly_name
            }
        } = jsonBody
        if (!friendly_name || !state) return 'NULL VALUES'
        const filename = `${CFS_BASE_PATH}${friendly_name.replace(/\W/g,'_')}.dev` // 已经将frindly_name中所有的非字符替换为下划线
        let old_state, now_state = `${state} ${unit_of_measurement}`
        if (fs.existsSync(filename))
            old_state = fs.readFileSync(filename)
        // 写文件记录当前状态，有则重写，无则创建
        fs.writeFileSync(filename, now_state)
        if (old_state !== now_state) {
            // 状态发生变更，则进行消息推送通知等处理，这里以ios上的ios上的bark为例：
            const msgContent = `您的设备${friendly_name}的状态已变更为：${state}`
            await sendToBark(msgContent)
            await sendToWechatBot(msgContent)
            return 'Notify OK'
        } else {
            console.log('状态无变更，忽略通知')
        }
    }

    return body
};


/**
 * GET发送内容到bark
 * @param {*} content
 */
async function sendToBark(content) {
    const yourBarkID = 'XXX'
    return await AXIOS.get(`https://api.day.app/${yourBarkID}/${content}`).catch(err => console.log(err))
}


/**
 * POST发送通知到企业微信机器人
 * @param {*} content
 */
async function sendToWechatBot(content) {
    const yourBotID = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
    return await AXIOS.post(`https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${yourBotID}`, {
        msgtype: "text",
        text: {
            content
        }
    }).catch(err => console.log(err))
}