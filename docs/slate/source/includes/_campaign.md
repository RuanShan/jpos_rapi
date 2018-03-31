# 活动

## 获取所有活动

```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/campaigns
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{
  "paginate_meta":
  {
    "current_page":1,"next_page":null,"prev_page":null,"total_pages":1,"total_count":1
  },
  "campaigns": [
    { "id":1,"name":"六一儿童节快乐联欢","start_at":null,"end_at":null}
  ]
}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/campaigns`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
per_page   |  否   | 单页条数，默认值25，最大100条|
page       |  否   | 返回页码，从1开始|

### 响应

## 添加活动

```shell

curl -i -X POST
  -d "campaign[name]=六一儿童节快乐联欢&campaign[start_at]=2017-05-24T06:32:39"
  -H "Authorization: your_api_key"
  http://wx-more-staging.getstore.cn/api/v1/campaigns  

```
> 上述代码返回结果示例如下:

```json
{
  "campaign":
  {
    "id":5,
    "name":"六一儿童节快乐联欢",
    "start_at":"2017-05-24T06:32:39.000+08:00",
    "end_at":null,
    "created_at":"2017-05-24T14:24:39.000+08:00"
  }
}
```


### HTTP 请求

`POST http://wx-more-staging.getstore.cn/api/v1/campaigns`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
campaign[name]   |  是      | 活动名称|
campaign[start_at]   |  否      | 活动开始时间|
campaign[end_at]   |  否      | 活动结束时间|

### 响应

## 删除活动
```shell

curl -i -X DELETE http://wx-more-staging.getstore.cn/api/v1/campaigns/<id>
  -H "Authorization: your_api_key"

```

### HTTP 请求

`DELETE http://wx-more-staging.getstore.cn/api/v1/campaigns/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
http status： 204


## 修改活动信息

```shell

curl -i -X PUT -d "campaign[name]=庆祝六一儿童节快乐联欢"
  -H "Authorization: your_api_key"
  http://wx-more-staging.getstore.cn/api/v1/campaigns/<id>

```
> 上述代码返回结果示例如下:


```json
{
  "campaign":
  {
    "id":5,
    "name":"六一儿童节快乐联欢",
    "start_at":"2017-05-24T06:32:39.000+08:00",
    "end_at":null,
    "created_at":"2017-05-24T14:24:39.000+08:00"
  }
}
```

### HTTP 请求

`PUT http://wx-more-staging.getstore.cn/api/v1/campaigns/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------
campaign[name]   |  否      | 活动名称|
campaign[start_at]   |  否      | 活动开始时间 格式示例: 2017-05-29T06:32:39|
campaign[end_at]   |  否      | 活动结束时间 格式示例:2017-05-29T06:32:39|

### 响应


## 获取单个活动
```shell

curl -i http://wx-more-staging.getstore.cn/api/v1/campaigns/1
  -H "Authorization: your_api_key"

```
> 上述代码返回结果示例如下:

```json
{

  "campaign":
  {
      "id":1,
      "name":"六一儿童节快乐联欢",
      "start_at":null,
      "end_at":null
  }

}
```

### HTTP 请求

`GET http://wx-more-staging.getstore.cn/api/v1/campaigns/<id>`

### 请求参数

参数名 | 是否必需 | 描述
-----| --------| -------

### 响应
