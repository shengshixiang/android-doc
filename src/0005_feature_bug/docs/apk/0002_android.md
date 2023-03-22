# README

android.mk,android.bp 功能归纳

# 不提取odex

## android.mk

* LOCAL_DEX_PREOPT := false

## android.bp

```
    dex_preopt:{
        enabled:false,
    },
```