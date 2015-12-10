title: Ajax 是否是异步请求？
date: 2015-12-10 15:53:57
categories: Coding
tags:
 - javascript
---

刚刚脑子中突然间产生的一个疑问，使用了这么久的 Ajax 技术，是不是真的是一个 `异步请求` ？

我这里所指的 `异步请求` 是指浏览器会为它开启一个独立的线程发起请求，并在成功后执行回调函数。整个过程应该是非阻塞的。

通常我们知道 `setTimeout` 函数会将执行代码压入下一次 Event Loop 中执行：

```js
setTimeout(function () {
    setTimeout(function () {
        console.log('foofoo');
    }, 0);
    console.log('foo');
}, 0);

setTimeout(function () {
    setTimeout(function () {
        console.log('barbar');
    }, 0);
    console.log('bar');
}, 0);

console.log('foobar');
```

输出：

![setTimeout](settimeout.png)

那么 `Ajax` 是否也是如些？想要验证这个问题非常简单，执行下面的代码：

```js
$.get('http://baidu.com');
while(true) {}
```

如果出现跨域请求错误，说明 Ajax 是独立线程的异步请求，如果浏览器假死，说明它只是被压入了下一次 Event Loop 中。

答案是后者，Ajax 并非会独立的异步执行，只是被推迟到下一次事件循环中执行，当前事件循环仍然可以阻塞其执行。

