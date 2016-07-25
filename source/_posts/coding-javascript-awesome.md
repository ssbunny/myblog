title: Awesome JavaScript
date: 2016-07-22 10:03:34
categories: Coding
description: A curated list of awesome JavaScript frameworks, libraries and software.
tags:
 - javascript
---

持续更新个人接触过的优秀 JavaScript 框架、类库及软件。一些框架同时包含了多种特性，因此分类时只粗略地依据其最核心的功能。

## 1. 包管理工具

### 1.1. [Bower](https://bower.io)
一个针对 Web 开发的包管理器。该工具主要用来帮助用户轻松安装 CSS、JavaScript、图像等相关包，并管理这些包之间的依赖。Bower 既可以管理基于本地资源的包，也可以管理基于 git 系统的包。

### 1.2. [npm](https://www.npmjs.com)
JavaScript 包管理工具，常用在 Node.js 中。




## 2. 构建打包工具

### 2.1 [webpack](https://webpack.github.io)
一个模块绑定器，主要目的是在浏览器上绑定 JavaScript 文件。很不错，个人非常推荐在新项目中尝试。


### 2.2. [Grunt](http://www.gruntjs.net)

自动化工具，执行压缩、编译、单元测试、linting 等任务，均采用插件的形式，因此理论上你可以扩展任何功能。

### 2.3. [Gulp](http://gulpjs.com)

和 Grunt 差不多，只是它利用 Node.js 流的威力减少频繁的 IO 操作。构建速度更快，刚出现的时候因为插件没有 Grunt 多，因此不推荐，现在它的插件也已经相当丰富了，个人首推的自动化工具。


## 3. 模块化加载

### 3.1. [RequireJS](http://requirejs.org)
老牌模块化加载工具，理念还是很不错的，如果关注 JS 模块化的话，这个框架很值得研究。然而实际使用中会觉得它还是太复杂了，而且造成的 JS 源文件碎片化问题解决起来很麻烦。新项目建议直接使用 webpack 做模块绑定。

### 3.2. SeaJS
在推广上强调 CMD 规范，以区别 RequireJS 的 AMD 规范。事实上现阶段的 RequireJS 涵盖了 SeaJS 的功能。个人感觉 SeaJS 最大的优势是其作为国产类库，文档、社区使用起来更方便。




## 4. 模版

模版的功能其实半斤八两，主要看项目特点、渲染性能及个人倾向。

### 4.1. [swig](http://paularmstrong.github.io/swig)
这个博客目前使用的模版。Node.js 或客户端环境均可使用。

### 4.2. [Jade(Pug)](http://jade-lang.com)
我最喜欢在 Node.js 环境中用它做服务端渲染。改名叫 Pug 了。它的语法我很难评论，有人爱有人恨，我起初也看着别扭，慢慢地感觉写起来挺舒服。

### 4.3. [mustache.js](https://github.com/janl/mustache.js)
非常小巧实用的模版引擎。

### 4.4. [EJS](http://ejs.co)
EJS， effective JS，也是个人用得比较多的模版，没什么特别要说的，性能、功能都 OK 。




## 5. 实用工具类

### 5.1. [Sugar](http://sugarjs.com)
扩展原生对象的一个类库。其实就是对 `String`、`Array`、`RegExp` 等原生对象的方法做了扩展。这种直接扩展原生对象的方式已经不再被推荐，个人并不建议使用这个类库，除非你很清楚你的项目特点并在使用它时知道你在做些什么。

### 5.2. [underscore](http://underscorejs.org)
一个非常实用的 JavaScript 类库，采用函数式编程风格。遗憾的是一些常用的类库(如 jQuery)、框架中包含了该类库的部分功能，因此它在服务端 JS 中使用的更多。

### 5.3. [lodash](https://lodash.com)

一个实用的 JavaScript 工具类库。个人只在 Node.js 环境使用过，但它显然也支持浏览器端。

### 5.4. [async](http://caolan.github.io/async/)
主要提供编写异步 JavaScript 的工具函数，顺带提供了些操作集合的方法等。简单实用。

### 5.5. [q](http://documentup.com/kriskowal/q)
实现了 Promises 模式的类库，功能很强大，对模式的实现也很全面。

### 5.6. [bluebird](http://bluebirdjs.com/docs/getting-started.html)
另一个实现了 Promises 模式的类库。性能很不错。我已从使用 `q` 转向了使用 `bluebird`。

### 5.7. [when.js](https://github.com/cujojs/when)
只实现了 Promises/A+ 模式。如果上面两个库显得有些大时，可以考虑使用这个（当然随着时间发展，它也可能变得很大）。另外你可以用它来充当 ES 6 Promises 模式的兼容性实现，让低版本的浏览器支持 ES 6 的这一特性。

### 5.8. [webcomponents.js](http://webcomponents.org/polyfills/)
用来支持 Web Components 规范的一套兼容方案。像 HTML 导入、Shadow DOM 等技术还是很新的，支持它们的浏览器很少，该类库提供了兼容方案，但也只限于 IE10+ 等，过于古老的浏览器实在别指望用 Web Components API .



## 6. 测试

### 6.1. [jasmine](http://jasmine.github.io)
测试框架用得不深入，jasmine 算是使用比较多的一个。在使用 AngularJS 做很好的业务代码分享前，真不知道前端 JS 代码怎么测。而且页面需求变化频率太高，维护测试代码的成本真的很高。

### 6.2. [Mocha](http://mochajs.org)
很简略地在 Node.js 下用过，用来测几个“显然”没什么错误的核心函数。研究文档时感觉它挺不错的样子。有机会地话再深入学习吧。




## 7. UI 相关

### 7.1. jQuery 插件
用过的 jQuery 插件太多了，不再罗列。自己也写过一些插件。另外，jQuery UI 真的不怎么样。使用 jQuery 插件开发界面的最大痛苦是，如果没有人懂得或愿意去阅读、修改下载下来的插件源码，用不了多长时间你的项目就会充斥着各种版本的 jQuery 库。

其实下面有很多款框架、类库都是 jQuery 插件。

### 7.2. [Bootstrap](http://getbootstrap.com)
目前最火的 mobile-first 响应式框架，没什么好说的，烂大街了。

### 7.3. [Semantic UI](http://semantic-ui.com)
官方 Demo 挺漂亮的，可自己搭配它的组件时，远没有用 Bootstrap 好看，总觉得太浮夸。比较值得学习的是它的 CSS 设计思路，还有在写 jQuery 插件时的编码规范。

### 7.4. [Foundation](http://foundation.zurb.com)
非常好用的老牌响应式前端框架，而且它一直保持着良好的更新速度，顺应时代的发展。不知道为什么在国内没那么火。

### 7.5. [ExtJS](https://www.sencha.com/products/extjs/#overview)
UI 组件非常丰富，可以做企业应用、各种复杂的后台管理界面。学习曲线漫长，源文件特别大。有一定经验的前端开发人员用起来还是比较快捷的，毕竟示例代码非常丰富。如果整个团队中没有一个 JavaScript 大牛，不建议使用，出个 Bug 你有可能一天都找不到原因。ExtJS 是一个完整的前端解决方案，用了它几乎不再需要任何其它的框架。

另外，它收费，很贵。用熟了之后开发速度是很惊人的。但是，如果需要频繁做各种自定义页面效果，非常难、非常繁琐、非常耗时、非常容易出问题。

### 7.3. [reveal.js](http://lab.hakim.se/reveal-js/#/)
一个非常帅气的幻灯片框架，功能非常强大，可以用来做 Web 端的讲演稿。



## 8. Web 框架

该分类同时也包含各类 MVC/MVP/MVVM 框架，各类用来做应用架构、整合的框架。

### 8.1. [Express](http://expressjs.com)
我心目中 Node.js 平台下最好用的 Web 框架，没有之一。能和它媲美的只有 [Koa](http://koajs.com) 了，虽然 Koa 的理念更好一些，不过我个人更喜欢整合好的开箱即用的 Express ，毕竟它已经足够轻量级了。而且，我也会比较保守地选择更简单易懂的 Express 。

### 8.2. [Ember.js](http://emberjs.com)
相比 AngularJS ，我还是更看好这个框架的。


## 0. 其它

