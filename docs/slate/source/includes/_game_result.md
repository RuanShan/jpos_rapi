# 游戏成绩

## 获取一个游戏的所有用户的最佳成绩信息，按照成绩降序，游戏时间升序。如赛车游戏，用户可能玩多次，只返回用户的最好成绩，

```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/game_rounds/1/results/best
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{

  "paginate_meta":{"current_page":1,"next_page":null,"prev_page":null,"total_pages":1,"total_count":3},
  "game_results":[
    {"id":1,
      "game_round_id":2,
      "game_player_id":2,
      "avatar":"http://wx.qlogo.cn/mmopen/VX7U0xDSUxgL7k7xGcKNmUjRTaibhnbMXGwbiaB0HuBicvH3HCuhAicf1k5wz7t9b9QBFicATSdqQu13WtDEVmmfM3ibAiatEUEDsmk/0",
      "nickname":"我的爱人",
      "openid":"oF9hV0SyZ6tI_k2WHtpRXqfedRH4",
      "score":130,
      "created_at":"2018-03-29T11:33:03.000+08:00"
    },
    {"id":2,
      "game_round_id":2,
      "game_player_id":4,
      "avatar":"http://wx.qlogo.cn/mmopen/W2SRdFhYWlTKg3H31ettpYDJS7ibcseKuMXUPDIlTCItEdmGJqMfQE24Hic01YbKRb77cvhMZtguo4ibQEwMEmM3j9fOjXgiaqIh/0",
      "nickname":"我的祖国",
      "openid":"oF9hV0SyZ6tI_k2WHtpRXqfedRH4",
      "score":90,
      "created_at":"2018-03-29T11:33:03.000+08:00"
    },
    {"id":3,
      "game_round_id":2,
      "game_player_id":6,
      "avatar":"http://wx.qlogo.cn/mmopen/7yc1S1j89ygxiceUgQqIHbHxOnhtDtKbC7yUCWJ2Oia5hKRsDe9RgPEAnalZ1s7e5qvp0WXf0qPdZPAicMv9G8vf6EibqBcNhLgR/0",
      "nickname":"我的世界",
      "openid":"oF9hV0SyZ6tI_k2WHtpRXqfedRH5",
      "score":10,
      "created_at":"2018-03-29T11:33:03.000+08:00"
    }]
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/game_rounds/<id>/results/best`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
per_page   |  否   | 单页条数，默认值25，最大9999条|
page       |  否   | 返回页码，从1开始|


### 响应
返回字段 |  描述
-----| -------
id | game_result id
game_round_id | game_round id
game_player_id | game_player id
openid | openid
nickname | 昵称
avatar | 头像
score | 游戏分数
created_at | 游戏时间
