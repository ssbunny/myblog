---
layout: post
title:  CSS 布局技巧
date:   2015-09-05 15:56:30
categories: 程序人生
description: 总结归纳了常用的 css 布局技巧。
tags:
 - web
 - css
---

为了方便演示，所有的示例外框采用如下样式用来防止拖拽时超出本文章的布局：

``` css
.demo {
    border: 1px solid #EEE;
    overflow: auto;
    height: 200px;
}
.resizeable {
    resize: both;
}
```

(注：部分示例效果在手机上无法完整显示。)

<style>
.resizeable {
    position: relative;
    resize: both;
}
.resizeable:after {
    content: "";
    position: absolute;
    bottom: 0;
    right: 0;
    cursor: se-resize;
    width: 0;
    height: 0;
    border-bottom: 20px solid #000;
    opacity: .3;
    border-left: 20px solid transparent;
}
.demo {
    border: 1px solid #EEE;
    overflow: auto;
    height: 200px;
    margin-bottom: 8px;
    position: relative;
}
</style>

## 横向布局

### 1.左定宽，右适应

核心思路是让左边的浮动，右边通过 `margin-left` 以留出左边的距离。
实际使用时，注意配合 `overflow` 属性，让上级标签合理地消除浮动。

``` css
.d1 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d1 .left,
.d1 .right {
    height: 100%;
}
.d1 .left {
    float: left;
    width: 100px;
    background-color: red;
}
.d1 .right {
    margin-left: 100px;
    background-color: blue;
}
```

``` html
<div class="demo">
    <div class="d1 resizeable">
        <div class="left"></div>
        <div class="right"></div>
    </div>
</div>
```

效果如下：

<style>
.d1 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d1 .left,
.d1 .right {
    height: 100%;
}
.d1 .left {
    float: left;
    width: 100px;
    background-color: red;
}
.d1 .right {
    margin-left: 100px;
    background-color: blue;
}
</style>

<div class="demo"><div class="d1 resizeable"><div class="left"></div><div class="right"></div></div></div>


**变种**：也可以通过给左侧元素增加 `position: absolute` 属性实现此布局，思路基本相同。
使用时注意上级元素也要指定 `position` 以限制左侧的定位范围。

``` css
.d1 {
    height: 140px;
    width: 300px;
    overflow: hidden;
    position: relative;
}
.d1 .left {
    position: absolute;
    left: 0;
    width: 100px;
    background-color: red;
}
```

### 2.右定宽，左适应

思路和上面完全相同，只需要把左右的顺序反过来。从略。

### 3.左右同时适应

此情况两侧均浮动且使用百分比设置宽度即可。但是有一些技巧需要注意：

* 如果需要设置 `margin`、`border` 等属性，可考虑外围增加一层元素作为包装，以防止右侧被挤到下一行。
在包装元素上设置宽度百分比，同时 `border` 设置为 `0`，在内部元素设置 `width: 100%`，按需设置 `margin`、
`border` 等属性；

* 合理使用 `min-width`、`max-width` 属性，控制宽度范围，防止屏幕分辨率的变化或浏览器尺寸的变化造成显示不正常；

* 通过响应式设计控制左右不同的显示方式。

``` css
.d3 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d3 .left-wrapper,
.d3 .right-wrapper {
    float: left;
    height: 100%;
    border: 0;
}
.d3 .left-wrapper {
    width: 40%;
    background-color: red;
}
.d3 .right-wrapper {
    width: 60%;
    background-color: blue;
}
.d3 .left, .d3 .right {
    color: #EEE;
    margin: 10px;
    padding: 10px;
    border: 2px solid #EEE;
}
```

``` html
<div class="demo">
    <div class="d3 resizeable">
        <div class="left-wrapper">
            <div class="left">left</div>
        </div>
        <div class="right-wrapper">
            <div class="right">right</div>
        </div>
    </div>
</div>
```

效果如下：

<style>
.d3 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d3 .left-wrapper,
.d3 .right-wrapper {
    float: left;
    height: 100%;
    border: 0;
}
.d3 .left-wrapper {
    width: 40%;
    background-color: red;
}
.d3 .right-wrapper {
    width: 60%;
    background-color: blue;
}
.d3 .left, .d3 .right {
    color: #EEE;
    margin: 10px;
    padding: 10px;
    border: 2px solid #EEE;
}
</style>

<div class="demo"><div class="d3 resizeable"><div class="left-wrapper"><div class="left">left</div></div><div class="right-wrapper"><div class="right">right</div></div></div></div>

### 4.左右定宽，中间适应

可采用左边左浮动，右边右浮动，中间通过 `margin` 来完成。
相应的，也可以使用绝对定位(参考1)。

``` css
.d4 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d4 .left, .d4 .right, .d4 .middle {
    height: 100%;
}
.d4 .left {
    float: left;
    width: 80px;
    background-color: red;
}
.d4 .middle {
    margin-left: 80px;
    margin-right: 60px;
    background-color: green;
}
.d4 .right {
    float: right;
    width: 60px;
    background-color: blue;
}
```

``` html
<div class="demo">
    <div class="d4 resizeable">
        <div class="right"></div>
        <div class="left"></div>
        <div class="middle"></div>
    </div>
</div>
```

效果如下：

<style>
.d4 {
    height: 140px;
    width: 300px;
    overflow: hidden;
}
.d4 .left, .d4 .right, .d4 .middle {
    height: 100%;
}
.d4 .left {
    float: left;
    width: 80px;
    background-color: red;
}
.d4 .middle {
    margin-left: 80px;
    margin-right: 60px;
    background-color: green;
}
.d4 .right {
    float: right;
    width: 60px;
    background-color: blue;
}
</style>

<div class="demo"><div class="d4 resizeable"><div class="right"></div><div class="left"></div><div class="middle"></div></div></div>



## 纵向布局

多数展示型页面是不限制总高度的，但有些 dashboard 页面会让高度限制在一屏内，不出现纵向滚动条。
此时，灵活的纵向布局的高度控制一般需要配合使用 `JavasSript` 来实现。这里只归纳一些纯 `CSS` 技巧。

### 1.上下定高，中间适应

通过绝对定位实现。实际使用时发现，此实现只能适用于外围大布局，
内部的高度控制，要么继续沿用此方式，要么通过 `JavasSript` 控制。

``` css
.v1 {
    height: 170px;
    width: 300px;
    overflow: hidden;
}
.v1 .top, .v1 .center, .v1 .bottom {
    position: absolute;
    width: 100%;
}
.v1 .top {
    top: 0;
    height: 30px;
    background-color: red;
}
.v1 .center {
    top: 30px;
    bottom: 40px;
    background-color: green;
}
.v1 .bottom {
    height: 40px;
    bottom: 0;
    background-color: blue;
}
```

``` html
<div class="demo">
    <div class="v1 resizeable">
        <div class="top"></div>
        <div class="center"></div>
        <div class="bottom"></div>
    </div>
</div>
```

效果如下：

<style>
.v1 {
    height: 170px;
    width: 300px;
    overflow: hidden;
}
.v1 .top, .v1 .center, .v1 .bottom {
    position: absolute;
    width: 100%;
}
.v1 .top {
    top: 0;
    height: 30px;
    background-color: red;
}
.v1 .center {
    top: 30px;
    bottom: 40px;
    background-color: green;
}
.v1 .bottom {
    height: 40px;
    bottom: 0;
    background-color: blue;
}
</style>

<div class="demo"><div class="v1 resizeable"><div class="top"></div><div class="center"></div><div class="bottom"></div></div></div>

### 2.上固定，下滚动

此情况只需要设置上面的 `position` 为 `fixed`，下面 `margin-top` 出相应的高度即可。

由于 `fixed` 定位的特殊性，在不使用 frame 的情况下无法在此处给出示例。

## 居中布局

### 1. 水平居中

1) 最简单且常用的方式是设置 `margin: 0 auto` ：

``` css
.c1 {
    height: 100%;
    width: 300px;
    margin: 0 auto;
    background-color: blue;
}
```

``` html
<div class="demo" style="height: 40px">
    <div class="c1"></div>
</div>
```

效果如下：

<style>
.c1 {
    height: 100%;
    width: 300px;
    margin: 0 auto;
    background-color: blue;
}
</style>

<div class="demo" style="height: 40px"><div class="c1"></div></div>

2) 也可以通过**绝对定位**来实现同样的效果:

``` css
.c1 {
    position: absolute;
    width: 300px;
    height: 100%;
    left: 50%;
    margin-left: -150px;
    background-color: blue;
}
```

### 2. 垂直居中

通常可采用上例中绝对定位的思路来实现。示例同时水平、垂直居中的效果：

``` css
.c2 {
    position: absolute;
    top: 50%;
    left: 50%;
    margin-top: -50px;
    margin-left: -150px;
    height: 100px;
    width: 300px;
    background-color: blue;
}
```

``` html
<div class="demo">
    <div class="c2"></div>
</div>
```

效果如下：

<style>
.c2 {
    position: absolute;
    top: 50%;
    left: 50%;
    margin-top: -50px;
    margin-left: -150px;
    height: 100px;
    width: 300px;
    background-color: blue;
}
</style>

<div class="demo"><div class="c2"></div></div>

以上写法兼容性较好，但是只适合宽度、高度固定的情况，因为需要依据它来设置 `margin` 值。
然而有时元素的高、宽并不能确定，而是根据内容适应，此时，需要通过使用 JavaScript
来计算相应的高度。当然，如果你能撇开那些使用古老浏览器的用户不管，你还可以使用 `css3`
实现此效果：

``` css
.c22 {
    height: 100%;

    display:-moz-box;
    -moz-box-pack:center;
    -moz-box-align:center;

    display: -webkit-box;
    -webkit-box-pack: center;
    -webkit-box-align: center;

    display: box;
    box-pack: center;
    box-align: center;
}
.c22 .content {
    /* 此处为模拟的尺寸，实际场景中根据内容撑起。 */
    height: 100px;
    width: 300px;
    background-color: blue;
}
```

``` html
<div class="demo">
    <div class="c22">
        <div class="content"></div>
    </div>
</div>
```

效果如下：

<style>
.c22 {
    height: 100%;

    display:-moz-box;
    -moz-box-pack:center;
    -moz-box-align:center;

    display: -webkit-box;
    -webkit-box-pack: center;
    -webkit-box-align: center;

    display: box;
    box-pack: center;
    box-align: center;
}
.c22 .content {
    /* 此处为模拟的尺寸，实际场景中根据内容撑起。 */
    height: 100px;
    width: 300px;
    background-color: blue;
}
</style>

<div class="demo"><div class="c22"><div class="content"></div></div></div>
(ps: 目前只有较新版本的 Firefox、Safari、Opera 以及 Chrome 支持此效果)
