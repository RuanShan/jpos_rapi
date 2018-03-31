# 游戏奖励

## 获取一个游戏的所有奖励信息
```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>/awards
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{  
  "game_awards": [
    {"id":1,"game_round_id":1,"name":"一等奖","position":1,"prize_count":1,"prize_name":""},
    {"id":2,"game_round_id":1,"name":"二等奖","position":2,"prize_count":2,"prize_name":""},
    {"id":3,"game_round_id":1,"name":"三等奖","position":3,"prize_count":3,"prize_name":""}
  ]
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>/awards`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应



## 添加游戏奖励

```shell
curl -i -X POST
  -d "game_award[name]=四等奖&game_award[game_round_id]=1&game_award[prize_count]=4&game_award[prize_name]=小米1金"
  -H "Authorization: your_api_key"
  http://wx-more-staging.getstore.cn/api/v1/game_awards  

```
> 上述代码返回结果示例如下:

```json
{
  "game_award":
  {
    "id":32,
    "game_round_id":1,
    "name":"四等奖",
    "position":4,
    "prize_count":4,
    "prize_name":"小米1金"
  }
}
```

### HTTP 请求

`POST http://wx-more-staging.getstore.cn/api/v1/game_awards`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
game_award[game_round_id]   |  是      | 游戏id|
game_award[name]   |  是      | 游戏奖励名称|
game_award[position]   |  否      | 游戏抽奖顺序|
game_award[prize_count]   |  否      | 游戏奖品数量|
game_award[prize_name]   |  否      | 游戏奖品名称|

### 响应


## 删除游戏奖励
```shell
curl -i -X DELETE
  -H "Authorization: your_api_key"
  http://wx-more-staging.getstore.cn/api/v1/game_awards/1

```
### HTTP 请求

`DELETE http://wx-more-staging.getstore.cn/api/v1/game_awards/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
http status： 204



## 修改游戏奖励信息
```shell
curl -i -X PUT -d "game_award[prize_name]=小米4金"
  -H "Authorization: your_api_key"
  http://wx-more-staging.getstore.cn/api/v1/game_awards/32

```
> 上述代码返回结果示例如下:


```json
{
  "game_award":
  {
    "id":32,
    "game_round_id":1,
    "name":"四等奖",
    "position":4,
    "prize_count":4,
    "prize_name":"小米4金"
  }
}
```
### HTTP 请求

`PUT http://wx-more-staging.getstore.cn/api/v1/game_awards/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
game_award[name]   |  否      | 游戏奖励名称|
game_award[position]   |  否      | 游戏抽奖顺序|
game_award[prize_count]   |  否      | 游戏奖品数量|
game_award[prize_name]   |  否      | 游戏奖品名称|

### 响应

## 获取单个游戏奖励
```shell
curl -i http://wx-more-staging.getstore.cn/api/v1/game_awards/32
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:


```json
{
  "game_award":
  {
    "id":32,
    "game_round_id":1,
    "name":"二等奖",
    "position":2,
    "prize_count":2,
    "prize_name":"小米1金"
  }
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_awards/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
