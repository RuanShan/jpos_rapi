# 游戏

## 获取所有游戏

```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/game_rounds
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{
  "paginate_meta":
  {
    "current_page":1,"next_page":null,"prev_page":null,"total_pages":1,"total_count":1
  },
  "game_rounds": [
  {
    "id":1,
    "campaign_id":1,
    "name":"六一儿童节快乐联欢",
    "code":"check_in",
    "duration":0,
    "play_times":0,
    "aasm_state":"open",
    "open_at":"2017-05-20T15:28:00.000+08:00",
    "close_at":"2017-05-21T23:31:18.000+08:00",
    "start_at":null,
    "end_at":null,
    "created_at":"2017-05-20T15:29:06.000+08:00"
  },
  {
    "id":2,
    "campaign_id":1,
    "name":"只是第一个數錢游戏",
    "code":"counting",
    "duration":20,
    "play_times":1,
    "open_at":null,
    "close_at":"2017-05-23T18:51:55.000+08:00",
    "start_at":"2017-05-23T18:52:03.000+08:00",
    "end_at":"2017-05-23T18:52:23.000+08:00",
    "created_at":"2017-05-20T15:29:32.000+08:00"
  } ]
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_rounds`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
per_page   |  否   | 单页条数，默认值25，最大100条|
page       |  否   | 返回页码，从1开始|
q_code     |  否   | 查询条件，游戏分类，取值 'check_in','counting'|

### 响应



## 添加游戏


```shell
curl -i -X POST -d  
  "game_round[name]=这是一个新的签到抽奖游戏&game_round[code]=check_in&  
  game_round[campaign_id]=1&game_round[wx_keyword]=qd&
  game_round[contact_required]=1&game_round[display_players]=8&
  game_round[duration]=30&game_round[gear]=100&
  game_round[start_at]=2017-05-24T10:00:00&game_round[end_at]=2017-05-24T10:00:20&
  game_round[game_awards_attributes][0][name]=一等奖&game_round[game_awards_attributes][0][prize_count]=1&
  game_round[game_awards_attributes][1][name]=二等奖&game_round[game_awards_attributes][1][prize_count]=2"
  -H "Authorization: your_api_key"  
  http://wx-more-staging.getstore.cn/api/v1/game_rounds

```
> 上述代码返回结果示例如下:

```json
{
  "game_round":{
    "id": 1,
    "code":"check_in",
    "campaign_id":1,
    "name":"这是一个新的签到抽奖游戏",
    "wx_keyword":"qd",
    "contact_required": true,
    "display_players": 8,
    "duration": 30,
    "gear": 100,
    "start_at": "2017-05-24T10:00:00.000+08:00",
    "end_at": "2017-05-24T10:00:20.000+08:00",
    "game_awards":[
      {"id":1,"game_round_id":1, "name":"一等奖", "position":1, "prize_count":1},
      {"id":2,"game_round_id":1, "name":"二等奖", "position":2, "prize_count":2}
    ]
  }
}
```


### HTTP 请求

`POST http://wx-more-staging.getstore.cn/api/v1/game_rounds`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
game_round[code]   |  是      | 游戏类型, 取值:'check_in','counting'|
game_round[campaign_id]   |  是     | 活动ID|
game_round[name]   |  是      | 游戏名称|
game_round[wx_keyword]   |  否     | 微信回复关键字|
game_round[display_players]   |  否     | 显示用户排名个数|
game_round[duration]   |  否     | 数钱游戏持续时间|
game_round[gear]       |  否     | 数钱游戏货币选择，取值: 1，10，100|
game_round[start_at]   |  否     | 游戏开始时间|
game_round[end_at]   |  否     | 数钱结束时间|
game_round[contact_required]   |  否     | 加入游戏前，用户是否需要输入姓名电话, 取值: 0，1|
game_round[game_awards_attributes][0][name] |  否     | 游戏奖励名称 如：一等奖|
game_round[game_awards_attributes][0][position] |  否     | 游戏奖励排序位置，从1开始|
game_round[game_awards_attributes][0][prize_count]   |  否     | 游戏奖品数量|
game_round[game_awards_attributes][0][prize_name]   |  否     | 游戏奖品名称|


### 响应


## 删除游戏

```shell

curl -i -X DELETE http://wx-more-staging.getstore.cn/api/v1/game_rounds/1
  -H "Authorization: your_api_key"

```

### HTTP 请求

`DELETE http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
http status： 204



## 修改游戏信息

```shell
curl -i -X PUT -d
  "game_round[name]=这是一个最新数钱游戏&game_round[game_awards_attributes][0][name]=最新一等奖&game_round[game_awards_attributes][0][id]=31"
  http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>
  -H "Authorization: your_api_key"

```

> 上述代码返回结果示例如下:

```json
{
 "game_round":
 { "id":1,
   "name":"这是一个最新数钱游戏",
   "contact_required":false,
   "display_players":0,
   "duration":0,
   "play_times":0,
   "award_times":0,
   "aasm_state":"ready",
   "start_at":null,
   "end_at":null,
   "created_at":"2017-05-20T15:29:06.000+08:00",
   "game_awards":[
     {"id":33,"game_round_id":8,"name":"最新一等奖","position":1,"prize_count":1,"prize_name":"","created_at":"2017-05-24T18:21:17.000+08:00"},
     {"id":34,"game_round_id":8,"name":"二等奖","position":2,"prize_count":2,"prize_name":"","created_at":"2017-05-24T18:21:17.000+08:00"}]
 }

}
```

### HTTP 请求

`PUT http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
game_round[name]   |  否      | 游戏名称|
game_round[wx_keyword]   |  否     | 微信回复关键字|
game_round[aasm_state]   |  否     | 游戏状态，取值:见下表 |
game_round[display_players]   |  否     | 显示用户排名个数|
game_round[duration]   |  否     | 数钱游戏持续时间|
game_round[gear]       |  否     | 数钱游戏货币选择，取值: 1，10，100|
game_round[start_at]   |  否     | 游戏开始时间|
game_round[end_at]   |  否     | 数钱结束时间|
game_round[contact_required]   |  否     | 加入游戏前，用户是否需要输入姓名电话, 取值: 0，1|


游戏状态| 取值| 描述
-----| --------| -------
created |created | 新建 |
open | open | 开始签到 |
ready | ready | 结束签到，准备开始 |
starting  | starting | 开始前倒计时中 |
started | started | 游戏已开始 |
completed | completed | 游戏已结束 |
disabled | disabled | 游戏已关闭 |

### 响应


## 获取单个游戏
```shell
curl -i http://wx-more-staging.getstore.cn/api/v1/game_rounds/1
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{
  "game_round":
  {
    "id":1,
    "name":"这是一个最新数钱游戏",
    "contact_required":false,
    "display_players":0,
    "duration":0,
    "play_times":0,
    "award_times":0,
    "aasm_state":"ready",
    "start_at":null,
    "end_at":null,
    "created_at":"2017-05-20T15:29:06.000+08:00",
    "game_awards":[
      {"id":1,"game_round_id":1,"name":"一等奖","position":2,"prize_count":1,"prize_name":"","created_at":"2017-05-20T15:29:06.000+08:00"},
      {"id":2,"game_round_id":1,"name":"二等奖","position":3,"prize_count":2,"prize_name":"","created_at":"2017-05-20T15:29:06.000+08:00"},
    ]
  }
}

```


### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
