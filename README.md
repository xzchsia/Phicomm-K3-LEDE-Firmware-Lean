
# Phicomm K3 OpenWrt Firmware 🚀
[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/JE668/Phicomm-K3-LEDE-Firmware-Lean/blob/master/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/JE668/Phicomm-K3-LEDE-Firmware-Lean.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/JE668/Phicomm-K3-LEDE-Firmware-Lean.svg?style=flat-square&label=Forks&logo=github)

该项目提供了针对 Phicomm K3 路由器的 OpenWrt 固件，旨在提供更多功能和定制选项。

该固件基于 [Lean 的 OpenWrt 源码](https://github.com/coolsnowwolf/lede)，并整合了以下主要插件及功能。

后台地址：[10.0.0.1](10.0.0.1)

## 一、主要插件

- [Adguardhome](https://github.com/kongfl888/luci-app-adguardhome) 🛡️
- [SSR-plus](https://github.com/fw876/helloworld) 🌐
- [MosDNS](https://github.com/sbwml/luci-app-mosdns) 🌍
- [SmartDNS](https://github.com/pymumu/openwrt-smartdns)🛜
- [K3 Screen](https://github.com/lwz322/k3screenctrl_build)🖥️


## 二、无线功率调整

如果需要调整无线功率，可以按照以下步骤进行操作：

1. 进入系统-启动项-本地启动脚本
2. 复制以下代码至 "exit 0" 之前:
```shell

iwconfig wlan0 txpower 20
iwconfig wlan1 txpower 20

```
3. 保存应用
4. 重启路由器


## 三、插件使用方法

### MosDNS:

1. 配置文件：自定义
2. 修改配置
```shell
# 转发至本地服务器
  - tag: forward_local
    type: forward
    args:
      upstreams:
        - addr: 127.0.0.1:5333
```
3. 启用&保存&应用



### Adguardhome:

1. 重定向选择“无”
2. 本地端口设置为5333
3. 其他配置照常配置，日志记录设置为2小时，防止爆内存


### SSR-Plus/VSSR:

1. 正常订阅
2. DNS解析方式选择“使用本机端口为5335的DNS服务”


## 进阶用法：

### SmartDNS:

1. SmartDNS正常配置，本地端口修改为5338，第二DNS端口修改为5339
2. Adguardhome:
   上游 DNS服务器
```shell

127.0.0.1:5338

```
   Bootstrap DNS服务器
```shell

127.0.0.1:5338

```

3. MosDNS修改配置
```shell
# 缓存
  - tag: lazy_cache
    type: cache
    args:
      size: 0
      lazy_cache_ttl: 3600
      dump_file: "/etc/mosdns/cache.dump"
      dump_interval: 600
```

      size: 0（此处修改为0，由SmartDNS进行缓存）

```shell
# 转发至远程服务器
  - tag: forward_remote
    type: forward
    args:
      upstreams:
        - addr: 127.0.0.1:5339
```   

⚠️稳定性测试中，有效分流，adguardhome延时8ms


## 四、感谢 🙏

- [Lean](https://github.com/coolsnowwolf)  [Lienol](https://github.com/Lienol)  [lwz322](https://github.com/lwz322)  [Hill-98](https://github.com/Hill-98)  [kongfl888](https://github.com/kongfl888) [haiibo](https://github.com/haiibo)  [P3TERX](https://github.com/P3TERX)  [yangxu52](https://github.com/yangxu52)  [kenzok8](https://github.com/kenzok8) 


## 五、其他

如果您对该固件有任何疑问或建议，请随时提出 issue 或联系上述贡献者。

**注意：** 该固件为自用测试版，使用前请仔细阅读相关文档和风险提示. 🚨
