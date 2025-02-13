
# Phicomm K3 OpenWrt Firmware 🚀
[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/JE668/Phicomm-K3-LEDE-Firmware-Lean/blob/master/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/JE668/Phicomm-K3-LEDE-Firmware-Lean.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/JE668/Phicomm-K3-LEDE-Firmware-Lean.svg?style=flat-square&label=Forks&logo=github)

该项目提供了针对 Phicomm K3 路由器的 OpenWrt 固件，旨在提供更多功能和定制选项。

该固件基于 [Lean 的 OpenWrt 源码](https://github.com/coolsnowwolf/lede)，并整合了以下主要插件及功能。

后台地址：[10.0.0.1](10.0.0.1)

## 一、主要插件

- [Adguardhome](https://github.com/kongfl888/luci-app-adguardhome) 🛡️
- [OpenClash](https://github.com/vernesong/OpenClash) 🌐
- [MosDNS](https://github.com/sbwml/luci-app-mosdns) 🌍
- [K3 Screen](https://github.com/lwz322/k3screenctrl_build)🖥️


## 二、无线功率调整

如果需要调整无线功率，可以按照以下步骤进行操作：

1. 进入系统-启动项-本地启动脚本
2. 复制以下代码至 "exit 0" 之前:
```shell

iwconfig wlan0 txpower 20
iwconfig wlan1 txpower 20

```
经过测试，没有 `iwconfig` 命令，使用 `iw` 命令代替  
```shell

iw dev wlan0 set txpower fixed 2000
iw dev wlan1 set txpower fixed 2000

```

3. 保存&应用
4. 重启路由器


## 三、插件使用方法 - MosDNS+OpenClash+AdguardHome

### OpenClash

1. 插件设置 - 模式设置 - 运行模式： 切换到 Fake-IP（增强）模式
2. 插件设置 - DNS 设置 - 本地 DNS 劫持 选择 禁用
3. 插件设置 - 流量控制 - 绕过中国大陆 IP 取消勾选
4. 插件设置 - 流量控制 - 仅允许内网 开启
5. 插件设置 - IPv6 设置 这页的选项全都关闭就行了
6. 覆写设置 - 常规设置 这里都不用改，只需要记住 DNS 监听，后面配置 MosDNS 要用（默认7874）
7. 覆写设置 - DNS 设置 - 自定义上游 DNS 服务器 勾选
8. 覆写设置 - DNS 设置 - 追加上游 DNS 勾选
9. 覆写设置 - DNS 设置 - 追加默认 DNS 勾选
10. 覆写设置 - DNS 设置 - Fake-IP 持久化 勾选
11. 覆写设置 - DNS 设置 页面下方 NameServer，FallBack，Default-NameServer 里的 DNS 服务器全都取消勾选（可在NameServer留运营商DNS）
12. 插件设置 - 开发者选项，自定义防火墙规则:
```shell
en_mode=$(uci -q get openclash.config.en_mode)
proxy_port=$(uci -q get openclash.config.proxy_port)

if [ "$en_mode" == "fake-ip" ]; then
	LOG_OUT "limit route to only fake ips with proxy port $proxy_port"
	iptables -t nat -D openclash -p tcp -j REDIRECT --to-ports $proxy_port
	sleep 1
fi

#  停止AdguradHome
LOG_OUT "stop adguardhome"
/etc/init.d/AdGuardHome stop
sleep 1

#  开启AdguradHome
LOG_OUT "start adguardhome"
/etc/init.d/AdGuardHome start
sleep 1

# 停止MosDNS
LOG_OUT "stop mosdns"
/etc/init.d/mosdns stop
sleep 1

# 开启MosDNS
LOG_OUT "start mosdns"
/etc/init.d/mosdns start
sleep 1

# 重载MosDNS
LOG_OUT "reload mosdns"
/etc/init.d/mosdns reload
sleep 1
```

### MosDNS:

1. 配置文件：自定义
2. 取消 DNS转发
3. 修改配置
```shell
# 国内解析
  - tag: local_sequence
    type: sequence
    args:
      - exec: $forward_local
      - matches:
        - has_resp
        - resp_ip 10.0.0.1/24 # 局域网IP段
        exec: ttl 1800-0

  # 国外解析
  - tag: remote_sequence
    type: sequence
    args:
      - matches:
        - qtype 28
        exec: reject 0
      - exec: forward 127.0.0.1:7874 
      - exec: ttl 1800-0
```
3. 启用&保存&应用

### Adguardhome:

1. 重定向选择“重定向53端口到AdGuardHome”
2. 本地端口设置为5333
3. 日志记录设置为2小时，防止爆内存
4. 在 Web 管理页面上，设置 DNS 设置中，上游 DNS 服务器内只填写一个 MosDNS 的地址 127.0.0.1:5335 #mosdns，私人反向 DNS 服务器写上 127.0.0.1 #dnsmasq
5. DNS 缓存配置里面，缓存大小填写20480，乐观缓存勾上

⚠️以上配置自用稳定，不排除不同设备有不同效果。


## 四、感谢 🙏

- [Lean](https://github.com/coolsnowwolf)  [Lienol](https://github.com/Lienol)  [lwz322](https://github.com/lwz322)  [Hill-98](https://github.com/Hill-98)  [kongfl888](https://github.com/kongfl888) [haiibo](https://github.com/haiibo)  [P3TERX](https://github.com/P3TERX)  [yangxu52](https://github.com/yangxu52)  [kenzok8](https://github.com/kenzok8)  [verneson](https://github.com/verneson)


## 五、其他

如果您对该固件有任何疑问或建议，请随时提出 issue 或联系上述贡献者。

**注意：** 该固件为自用测试版，使用前请仔细阅读相关文档和风险提示. 🚨
