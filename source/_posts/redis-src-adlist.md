title: Redis 中的数据结构：双链表
date: 2015-12-15 15:02:39
categories: Coding
tags:
 - redis
---

Redis 实现了通用的双链表作为其基础数据结构之一。双链表是 redis 列表类型的实际存储方式之一，同时双链表还被其它功能模块广泛使用。它由三部分组成：

* 节点
* 迭代器
* 链表自身

其**节点**如下：

```c
typedef struct listNode {
    struct listNode *prev;
    struct listNode *next;
    void *value;
} listNode;
```

包含指向前驱、后继节点的指针及当前节点存储的值。这个值的类型为 `void*` ，说明 redis 并不限制链表存储的数据类型。

**链表**的定义如下：

```c
typedef struct list {
    listNode *head;
    listNode *tail;
    void *(*dup)(void *ptr);
    void (*free)(void *ptr);
    int (*match)(void *ptr, void *key);
    unsigned long len;
} list;
```

`list` 中保存了指向表头和表尾的指针，因此在执行 `LPUSH`、`RPUSH`、`RPOP` 等命令时是非常快的(θ(1))；其中还保存了 len 值，因此 `LLEN` 命令的执行也是非常快的。

![double_link_list.svg](double_link_list.svg)

另外，它还保存了三个函数指针 dup、free 和 match 用来复制、释放和对比链表，这样做是因为节点值的类型是不确定的，具体的实现方法交由用户代码灵活扩展处理。比如如果用户定义了 match 函数的实现，则采用它来替换默认使用 `==` 的比较策略：

```c
if (list->match) {
    if (list->match(node->value, key)) {
        listReleaseIterator(iter);
        return node;
    }
} else {
    if (key == node->value) {
        listReleaseIterator(iter);
        return node;
    }
}
```

类似地，释放一个链表时会优先调用指定的 free 函数后再完成其它释放过程：

```c
void listRelease(list *list)
{
    unsigned long len;
    listNode *current, *next;

    current = list->head;
    len = list->len;
    while(len--) {
        next = current->next;
        if (list->free) list->free(current->value);
        zfree(current);
        current = next;
    }
    zfree(list);
}
```

**迭代器**的结构如下：

```c
typedef struct listIter {
    listNode *next;
    int direction;
} listIter;
```

其中，direction 可以向前或向后：

```c
#define AL_START_HEAD 0
#define AL_START_TAIL 1
```

可以通过：

```c
listIter *listGetIterator(list *list, int direction);
```

获得迭代器，通过：

```c
listNode *listNext(listIter *iter);
```

进行遍历。另外，还可以将指针移到表头或表尾：

```c
void listRewind(list *list, listIter *li);
void listRewindTail(list *list, listIter *li);
```


