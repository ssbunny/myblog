title: 编程基本原则汇总
date: 2015-10-19 15:48:35
categories: Coding
tags:
 - pattern
---

整理一些公认的编程基本原则。

## KISS

> Keep It Simple Stupid

要注重简约。

## YAGNI

> you aren't gonna need it

在确实需要某功能之前，不要依靠预测去实现它。

## DRY

> Don't Repeat Yourself

不要编写重复代码，将业务规则、公式、元数据等放在一处。

## LSP 

> Liskov Substitution Principle

里氏替换原则：程序中的对象可以被它的子类型替换，而同时不改变程序的正确性。

## LoD
> Law of Demeter : Don't talk to strangers

迪米特法则：又叫最少知识原则，一个对象应当对其他对象有尽可能少的了解，不和陌生人说话。

对象的方法应该只调用以下方法：
1. 对象自己的；
2. 方法参数中的；
3. 方法内部创建的任何对象中的方法；
4. 对象直接属性或域中的方法(聚合关系)。

## OCP
> **Open/Closed Principle:** Software entities (e.g. classes) should be open for extension, but closed for modification.

开闭原则：软件实体应当对扩展开放，对修改关闭。

## SRP
> **Single Responsibility Principle: **A class should never have more than one reason to change.

单一职责原则：就一个类而言，应该仅有一个引起它变化的原因。


**Resources**

1. [KISS principle](http://en.wikipedia.org/wiki/KISS_principle)
2. [Keep It Simple Stupid (KISS)](http://principles-wiki.net/principles:keep_it_simple_stupid)
3. [You Arent Gonna Need It](http://c2.com/xp/YouArentGonnaNeedIt.html)
4. [You’re NOT gonna need it!](http://www.xprogramming.com/Practices/PracNotNeed.html)
5. [You aren't gonna need it](http://en.wikipedia.org/wiki/You_ain't_gonna_need_it)
6. [Dont Repeat Yourself](http://c2.com/cgi/wiki?DontRepeatYourself)
7. [Don't repeat yourself](http://en.wikipedia.org/wiki/Don't_repeat_yourself)
8. [Don't Repeat Yourself](http://programmer.97things.oreilly.com/wiki/index.php/Don't_Repeat_Yourself)
9. [Code For The Maintainer](http://c2.com/cgi/wiki?CodeForTheMaintainer)
10. [The Noble Art of Maintenance Programming](http://blog.codinghorror.com/the-noble-art-of-maintenance-programming/)
11. [Program optimization](http://en.wikipedia.org/wiki/Program_optimization)
12. [Premature Optimization](http://c2.com/cgi/wiki?PrematureOptimization)
13. [Law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter)
14. [The Law of Demeter Is Not A Dot Counting Exercise](http://haacked.com/archive/2009/07/14/law-of-demeter-dot-counting.aspx/)
15. [Liskov substitution principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)
16. [The Liskov Substitution Principle](http://freshbrewedcode.com/derekgreer/2011/12/31/solid-javascript-the-liskov-substitution-principle/)
17. [Single responsibility principle](http://en.wikipedia.org/wiki/Single_responsibility_principle)