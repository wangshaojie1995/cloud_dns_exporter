<div align="center">
<h1>Cloud DNS Exporter</h1>

[![Auth](https://img.shields.io/badge/Auth-eryajf-ff69b4)](https://github.com/eryajf)
[![GitHub contributors](https://img.shields.io/github/contributors/eryajf/cloud_dns_exporter)](https://github.com/eryajf/cloud_dns_exporter/graphs/contributors)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/eryajf/cloud_dns_exporter)](https://github.com/eryajf/cloud_dns_exporter/pulls)
[![GitHub Pull Requests](https://img.shields.io/github/stars/eryajf/cloud_dns_exporter)](https://github.com/eryajf/cloud_dns_exporter/stargazers)
[![HitCount](https://views.whatilearened.today/views/github/eryajf/cloud_dns_exporter.svg)](https://github.com/eryajf/cloud_dns_exporter)
[![GitHub license](https://img.shields.io/github/license/eryajf/cloud_dns_exporter)](https://github.com/eryajf/cloud_dns_exporter/blob/main/LICENSE)
[![](https://img.shields.io/badge/Awesome-MyStarList-c780fa?logo=Awesome-Lists)](https://github.com/eryajf/awesome-stars-eryajf#readme)

<p> 🧰 自动获取DNS提供商的域名及解析列表，同时自动获取每个域名解析的证书信息。🧰 </p>

<img src="https://cdn.jsdelivr.net/gh/eryajf/tu@main/img/image_20240420_214408.gif" width="800"  height="3">
</div><br>

![cloud_dns_exporter](https://socialify.git.ci/eryajf/cloud_dns_exporter/image?description=1&descriptionEditable=%E9%80%90%E6%AD%A5%E8%BF%88%E5%90%91%E8%BF%90%E7%BB%B4%E7%9A%84%E5%9B%9B%E4%B8%AA%E7%8E%B0%E4%BB%A3%E5%8C%96%EF%BC%9A%E8%A7%84%E8%8C%83%E5%8C%96%EF%BC%8C%E6%A0%87%E5%87%86%E5%8C%96%EF%BC%8C%E9%AB%98%E6%95%88%E5%8C%96%EF%BC%8C%E4%BC%98%E9%9B%85%E5%8C%96&font=Bitter&forks=1&issues=1&language=1&name=1&owner=1&pattern=Circuit%20Board&pulls=1&stargazers=1&theme=Light)

</div>

## 项目简介

在我们维护网站的时候，偶尔可能会犯一些相对低级的错误，莫过于忘记更换域名证书而使网站无法访问。然而当我们记得并更换了证书，却又因为遗漏了某些解析而导致网站无法访问。这些都是令人难受的错误。

这个项目，希望能够让你轻松掌握到每个域名解析的证书信息，从而在更换证书时，不会遗漏任何一个解析。

支持多种DNS提供商(目前支持阿里云，腾讯云，其他更多，期待有缘人PR)，且支持单提供商多账号管理。

## 如何使用

可以直接在 [Release](https://github.com/eryajf/cloud_dns_exporter/releases) 发布页面下载二进制，然后更改配置文件，直接运行即可。

默认端口监听在`21798`，为什么选择这个端口，因为项目对应在grafana中的仪表板ID就是[21798](https://grafana.com/grafana/dashboards/21798-cloud-dns-record-info/)。

你也可以选择使用docker部署，部署时把config.yaml在本地配置好，然后运行时，通过挂载(`-v ./config.yaml:/app/config.yaml`)覆盖容器内默认配置即可。

镜像地址：
- 国外: `eryajf/cloud_dns_exporter`
- 国内: `registry.cn-hangzhou.aliyuncs.com/eryajf/cloud_dns_exporter`

目前应用还提供了`-v`参数，用于打印当前所使用的版本信息。

## 一些注意

- 为了提高请求指标数据时的效率，项目设计为通过定时任务提前将数据缓存的方案，默认情况下，域名及解析记录信息为30s/次，证书信息在每天凌晨获取一次。如果你想重新获取，则重启一次应用即可。
- 解析记录的证书信息获取，会受限于不同的网络访问场景，因此请尽可能把本程序部署在能够访问所有解析记录的地方。
- 很多域名证书可能与域名没有match，是因为取到了所在负载服务监听的443对应的证书信息，可根据自己的情况选择忽略或进行处理。

> 如果发现证书获取不准确或错误的情况，请提交issue交流。

## 指标说明

本项目提供指标有如下几项：

| 名称               | 说明                 |
| ------------------ | -------------------- |
| `domain_list`      | 域名列表             |
| `record_list`      | 域名解析记录列表     |
| `record_cert_info` | 解析记录证书信息列表 |

指标标签说明：

```
<!-- 域名列表 -->
domain_list{
    cloud_provider="DNS提供商",
    cloud_name="云账号名称",
    domain_id="域名ID",
    domain_name="域名",
    domain_remark="域名备注",
    domain_status="域名状态",
    create_time="域名创建时间"} 0

<!-- 域名记录列表 -->
record_list{
    cloud_provider="DNS提供商",
    cloud_name="云账号名称",
    domain_name="域名",
    record_id="记录ID",
    record_type="记录类型",
    record_name="记录",
    record_value="记录值",
    record_ttl="记录缓存时间",
    record_weight="记录权重",
    record_status="状态",
    record_remark="记录备注",
    update_time="更新时间",
    full_record="完整记录"} 0

<!-- 域名记录证书信息 -->
record_cert_info{
    cloud_provider="DNS提供商",
    cloud_name="云账号名称",
    domain_name="域名",
    record_id="记录ID",
    full_record="完整记录",
    subject_common_name="颁发对象CN(公用名)",
    subject_organization="颁发对象O(组织)",
    subject_organizational_unit="颁发对象OU(组织单位)",
    issuer_common_name="颁发者CN(公用名)",
    issuer_organization="颁发者O(组织)",
    issuer_organizational_unit="颁发者OU(组织单位)",
    created_date="颁发日期",
    expiry_date="过期日期",
    cert_matched="与主域名是否匹配",
    error_msg="错误信息"} 30 (此value为记录的证书距离到期的天数)
```

## Grafana 仪表板

项目对应的 Grafana Dashboard ID: [21798](https://grafana.com/grafana/dashboards/21798-cloud-dns-record-info/)

概览与域名列表：

![](https://t.eryajf.net/imgs/2024/08/1725118602116.webp)

解析记录与证书详情列表：

![](https://t.eryajf.net/imgs/2024/08/1725118643455.webp)

## 其他说明

- 如果觉得项目不错，麻烦动动小手点个 ⭐️star⭐️!
- 如果你还有其他想法或者需求，欢迎在 issue 中交流！
- 特别欢迎贡献新的DNS服务商，我所遇到的场景并不全面，需要大家一起来完善项目。我花了大量的精力，让项目扩展一个新的模块儿变得非常容易，快行动起来吧。

## 捐赠打赏

如果你觉得这个项目对你有帮助，你可以请作者喝杯咖啡 ☕️

| 支付宝|微信|
|:--------: |:--------: |
|![](https://t.eryajf.net/imgs/2023/01/fc21022aadd292ca.png)| ![](https://t.eryajf.net/imgs/2023/01/834f12107ebc432a.png) |