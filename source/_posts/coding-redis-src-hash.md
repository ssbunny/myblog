title: Redis 中的数据结构：散列表
date: 2015-12-21 11:05:05
categories: Coding
tags:
 - redis
---

散列表是 redis 中的基础数据结构之一， redis 中的键空间、redisDB、 `SET`、`ZSET`、集群节点映射等，都是通过散列表实现的。结构体定义为：

```c
typedef struct dict {
    dictType *type;
    void *privdata;
    dictht ht[2];
    long rehashidx;
    int iterators;
} dict;
```

其中，`*type` 指针指向 dict 的类型，例如它是一个 ZSET(zsetDictType) 还是一个集群节点(clusterNodesDictType)。实际上它们的存储结构是相同的，之所以区分类型，是因为其散列函数、key 的比较(或销毁)策略是不同的。因而所谓的 dict 类型，不过是一组函数指针罢了：

```c
typedef struct dictType {
    unsigned int (*hashFunction)(const void *key);       // 散列函数
    void *(*keyDup)(void *privdata, const void *key);    // key 复制函数
    void *(*valDup)(void *privdata, const void *obj);    // value 复制函数
    int (*keyCompare)(void *privdata, const void *key1, const void *key2);     // key 比较函数
    void (*keyDestructor)(void *privdata, void *key);    // key 销毁函数
    void (*valDestructor)(void *privdata, void *obj);    // value 销毁函数
} dictType;
```

数组 `ht` 中存放的是 dict 的实际散列表结构 `dictht` ：

```c
typedef struct dictht {
    dictEntry **table;
    unsigned long size;
    unsigned long sizemask;
    unsigned long used;
} dictht;
```

之所以存放 2 个，是为了实现**渐进式再散列(incremental rehashing)**。

`**table` 指向桶结构 `dictEntry` :

```c
typedef struct dictEntry {
    void *key;
    union {
        void *val;
        uint64_t u64;
        int64_t s64;
        double d;
    } v;
    struct dictEntry *next;
} dictEntry;
```

当发生冲突时，dict 首先会使用**分离链接法**将散列到同一个值的所有元素保留到一个表中。当到了一定时机，它会通过**再散列**进行扩展。

![redis-dict.svg](redis-dict.svg)

Redis 还提供了遍历散列表用的迭代器，它支持安全(遍历期间可以增加元素等操作)、不安全两种方式遍历散列表：

```c
typedef struct dictIterator {
    dict *d;
    long index;
    int table, safe;
    dictEntry *entry, *nextEntry;
    long long fingerprint;
} dictIterator;
```

todo 渐进式再散列



_(使用的源码基于 redis 3.0.5)_ 
