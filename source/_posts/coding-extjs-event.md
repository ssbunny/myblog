title: ExtJS 核心概念 - 事件模型
date: 2015-07-21 14:37:04
categories: Coding
tags:
 - web
 - extjs
 - javascript
 - ExtJS核心概念系列文章
---

我们在使用 ExtJS 时，经常会为某组件绑定事件，以做相应扩展处理。创建组件时通过配置 `listeners` 属性即可绑定事件：

```js
var i = 0;
var btn = Ext.create('Ext.button.Button', {
    text: 'Button',
    listeners: {
        mouseover: function (btn) {
            console.log(btn.getText() + ++i);
        }
    },
    renderTo: document.body
});
```

也可以通过 `on` 方法给组件实例绑定事件：

```js
btn.on('click', function () {
    alert('clicked');
});
```

以上方法已经能解决我们使用 ExtJS 事件时绝大多数需求。然而当我们扩展或自定义一个组件时，常常需要注册自定义的事件并在合适的时机触发它们。

本篇文章要讲的事件模型分为三部分，以上为其一 —— 绑定：

* 注册
* 触发
* 绑定

## ExtJS事件模型完整示例

先来看一个较为完整的示例：

```js
Ext.define('MyButton', {
    extend: 'Ext.button.Button',

    initComponent: function () {
        this.callParent();
        this.addEvents('blink');  // <------ 注册
    },

    shake: function () {
        console.log('Give your body a bit of a shake!');
        this.fireEvent('blink', this); // <------ 触发
        console.log('Take a break!');
    }

});

var mybtn = Ext.create('MyButton');

// <------ 绑定
mybtn.on('blink', function () {
    console.log('Begin to blink!');
});
mybtn.on('blink', function () {
    console.log('Begin to blink, again!');
});

mybtn.shake();
```

执行结果如下：

![示例结果](event_01.png)

从代码中可以看出，对于 `shake` 方法只需要在合适的时机触发 `blink` 事件，它不需要知道有谁绑定了该事件，也不关心事件的执行过程，从而将 `blink` 这一特定行为从 `shake` 中解耦。


## 观察者模式

理解 ExtJS 的事件机制，需要先了解 **观察者模式**。该模式维护了一个被观察对象(subject)与其观察者(observer)之间的一对多关系，当对象状态变化时，会自动通知并更新观察者。

![观察者模式类图](event_02.gif)

一个被观察对象和两个观察者调用关系时序图如下：

![观察者模式时序图](event_03.gif)

剥离出精简的代码实现示例：

```js
function Subject() {
    this.observers = [];
}
Subject.prototype = {
    addObserver: function (ob) {
        this.observers.push(ob);
    },
    removeObserver: function () {
        // remove...
    },
    notify: function () {
        var i = 0, len = this.observers.length;
        for (; i < len; ++i) {
            this.observers[i].update();
        }
    }
    // ...
};

function Observer(name) {
    this.name = name;
    this.update = function () {
        console.log(this.name + ' was updated!');
    }
}

var zs = new Observer('zhangsan');
var ls = new Observer('lisi');

var subject = new Subject();
subject.addObserver(zs);
subject.addObserver(ls);
subject.notify();
```

关于观察者模式的书籍、网络资源极其丰富，请参考相应介绍。

## 发布/订阅模式

发布/订阅模式可以被理解为一种特殊的观察者模式。订阅者和发布者并不直接耦合，而是通过注册事件的方式，因此较之观察者模式，其耦合度更低。

这里摘录 JavaScript 大神 addyosmani 实现的发布/订阅模式代码供参考：

```js
;(function ( window, doc, undef ) {

    var topics = {},
        subUid = -1,
        pubsubz ={};

    pubsubz.publish = function ( topic, args ) {

        if (!topics[topic]) {
            return false;
        }

        setTimeout(function () {
            var subscribers = topics[topic],
                len = subscribers ? subscribers.length : 0;

            while (len--) {
                subscribers[len].func(topic, args);
            }
        }, 0);

        return true;

    };

    pubsubz.subscribe = function ( topic, func ) {

        if (!topics[topic]) {
            topics[topic] = [];
        }

        var token = (++subUid).toString();
        topics[topic].push({
            token: token,
            func: func
        });
        return token;
    };

    pubsubz.unsubscribe = function ( token ) {
        for (var m in topics) {
            if (topics[m]) {
                for (var i = 0, j = topics[m].length; i < j; i++) {
                    if (topics[m][i].token === token) {
                        topics[m].splice(i, 1);
                        return token;
                    }
                }
            }
        }
        return false;
    };

    getPubSubz = function(){
        return pubsubz;
    };

    window.pubsubz = getPubSubz();

}( this, this.document ));
```

## 事件模型的缺陷

事件模型虽然能够较好的解耦，为编码工作带来灵活性，然而它也有较为明显的缺陷：

**1. 发布者无法得知订阅者中产生的错误**

例如之前的示例，如果订阅者中抛出了异常：

```js
mybtn.on('blink', function () {
    Ext.Error.raise('I am too old to blink!');
});
```

我们无法在发布者中得知这一情况。下面的代码无法起作用：

```js
// ...
shake: function () {
    console.log('Give your body a bit of a shake!');
    try {
        this.fireEvent('blink', this);
    } catch (err) {
        // do something
    }
    console.log('Take a break!');
}
```

尽管你可以通过回调方式，将 Error 对象作为回调参数反向传回给发布者，但这样带来的编码复杂度是很高的，而且不能保证每个订阅者都正确捕获异常并传回。同时，发布者自己也会因为异常处理而变得臃肿，且它无法很好的识别异常类型，更无从得知合适的处理逻辑。

**2. 流程控制变得复杂**

事件的订阅过程相对较为分散，通常很难确实绑定的顺序。如果你需要做一系列操作，通过事件模型来处理的话，会把问题变得极为复杂繁琐。

**3. 多个订阅者之间无法通讯，它们互相不了解彼此做了哪些操作**

我发现，这一问题在实际使用 ExtJS 时暴露的极为普遍。很多人习惯通过绑定事件时的回调参数修改此对象，这样一来，由于其它订阅者并不知道他做了什么操作，极有可能得到一个不正确的对象状态。

例如，张三在某个 JavaScript 源文件中通过绑定事件修改了 button 的状态：

```js
mybtn.on('blink', function (btn) {
    btn.setText('MyButton');
});
```

而李四并不知道张三做了什么，他想当然地基于 button 的状态做了一些操作：

```js
mybtn.on('blink', function (btn) {
    var text = btn.getText();
    if (text === 'Button') {
        console.log('I am a button!');
    }
});
```

遗憾的是，如果李四的代码先于张三的执行，则李四能得到正确结果；如果张三的代码先于李四的执行，则李四不能得到正确结果。这显然使得代码结构变得混乱，本来通过事件模型解耦而不相关的代码，又无形地被耦合起来了。而更痛苦的是这样的代码变得更分散，很可能彼此并不知道他人的存在。

**4. 代码调试变得困难**

事件注册到容器中，发布者和订阅者不存在直接调用关系，因此代码调试相对困难一些。


## 备注

button 组件的 `handler` 不是事件。ExtJS中配置的 `handler` 只是一个方法调用，不进行事件绑定；

