# 游戏用户

## 获取一个游戏的所有用户信息

```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/game_rounds/1/players
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{

  "paginate_meta":{"current_page":1,"next_page":null,"prev_page":null,"total_pages":1,"total_count":3},
  "game_players":[
    {"id":1,
      "game_round_id":2,
      "avatar":"http://wx.qlogo.cn/mmopen/VX7U0xDSUxgL7k7xGcKNmUjRTaibhnbMXGwbiaB0HuBicvH3HCuhAicf1k5wz7t9b9QBFicATSdqQu13WtDEVmmfM3ibAiatEUEDsmk/0",
      "nickname":"我的爱人",
      "position":1,
      "realname":"",
      "cellphone":"",
      "score":0,
      "rank":0
    },
    {"id":2,
      "game_round_id":2,
      "avatar":"http://wx.qlogo.cn/mmopen/W2SRdFhYWlTKg3H31ettpYDJS7ibcseKuMXUPDIlTCItEdmGJqMfQE24Hic01YbKRb77cvhMZtguo4ibQEwMEmM3j9fOjXgiaqIh/0",
      "nickname":"我的祖国",
      "position":2,
      "realname":"",
      "cellphone":"",
      "score":0,
      "rank":0
    },
    {"id":3,
      "game_round_id":2,
      "avatar":"http://wx.qlogo.cn/mmopen/7yc1S1j89ygxiceUgQqIHbHxOnhtDtKbC7yUCWJ2Oia5hKRsDe9RgPEAnalZ1s7e5qvp0WXf0qPdZPAicMv9G8vf6EibqBcNhLgR/0",
      "nickname":"我的世界",
      "position":3,
      "realname":"",
      "cellphone":"",
      "score":0,
      "rank":0,
      "game_award":{"id":1,"name":"一等奖","prize_name":"","position":1}
    }]
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>/players`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
per_page   |  否   | 单页条数，默认值25，最大9999条|
page       |  否   | 返回页码，从1开始|
q_term     |  否   | 姓名，昵称查询关键字|
q_award    |  否   | 是否中奖查询, 可选值：yes,no|

### 响应
返回字段 |  描述
-----| -------
realname | 真实姓名
cellphone | 电话
score | 游戏分数 数钱分数
rank | 游戏排名 数钱排名
game_award| 中奖信息

## 获取单个游戏用户

```shell
curl -i http://wx-more-staging.getstore.cn/api/v1/game_players/42
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{

  "game_player":
  {
    "id":42,
    "game_round_id":2,
    "position":1,
    "nickname":"我是土豆",
    "avatar":"http://wx.qlogo.cn/mmopen/VX7U0xDSUxgL7k7xGcKNmUjRTaibhnbMXGwbiaB0HuBicvH3HCuhAicf1k5wz7t9b9QBFicATSdqQu13WtDEVmmfM3ibAiatEUEDsmk/0",
    "realname":"我是马铃薯",
    "cellphone":"13812345678",
    "score":0,
    "rank":0,
    "created_at":"2017-05-23T18:48:10.000+08:00",
    "game_award":{"id":1,"name":"一等奖","prize_name":"大米2两","position":1}

  }
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_players/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
