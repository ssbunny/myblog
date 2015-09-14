title: 玩转分支语句
date: 2015-09-13 19:56:51
tags:
 - lang
 - pattern
---

分支语句在编程语言中有着举足轻重的地位。有一定工作年限的程序员，通常遇到过这样一段代码，它有数百行，包含了十几甚至二十几个分支，嵌套多达五六层甚至十多层，各种 `if ... else ...` 语句交叉在一起。最可恨的是，每个分支上有着详尽的注释，你花了二十分钟，仔细阅读了每条注释，最后发现这些注释根本不能够告诉你它要做什么，你依然一头雾水。甚至有些注释还TM是错的，和代码逻辑根本不一致。

这样的代码一般是老系统长期维护造成的。随着用户的需求不断地变更，维护它的程序员不得不在代码上无限地增加 `if` 。当然也有“大牛”可以一开始便写出这么复杂的分支逻辑。

废话说了很多，本文的目的在于归纳关于分支语句的林林总总。探讨如何写出漂亮的分支逻辑。

# 1. 重构

一个正常的程序员是不会痛骂 `if A then B` 这样的分支的，大多数分支代码一开始确实也长得如此。然而，随着时间的推移，需求的不断变更，分支代码通常看起来是这样的：

``` c
if (!(A < 10 || B > 5) && A > 10 || B < 20 && C || C > 100) {
    if (...) {
        // ...
    }
    else if (...) {
        if () ....
    }
    ...
}
else if (B > 20 && C < 50) {
    // ...
}
else {
    // ...
}
```

如果你愿意做一个有节操的程序员，在上面的代码继续发臭腐烂、直至必须重写前，你应该对其重构。

## 1.1. 改进复杂的表达式

进入分支的条件逻辑如果过于复杂，通常代码会很难维护。此时可考虑以下手段改进：

### 1.1.1. 条件反转

通常形如 `if [OK] then ... else ...` 的处理逻辑更符号人类的思维习惯，所以对于逻辑“非”优先的分支，可以考虑进行反转。例如将：

``` java
if (!(level > 4 && score > 90)) {
    reject();
} else {
    accept();
}
```

修改为：

``` java
if (level > 4 && score > 90) {
    accept();
} else {
    reject();
}
```


### 1.1.2. 使用解释变量

将表达式中逻辑相关的部分，提取出变量，并给予一个合适的名字。此时变量的命名必须能准确表述表达式的含义。例如将：

``` java
if (inputs.split(",")[0].equals("admin") 
        && DB.get("password").equals(inputs.split(",")[1])) {
    doSomeThing();
}
```

修改为：

``` java
boolean isAdmin = inputs.split(",")[0].equals("admin");
boolean hasCertified = DB.get("password").equals(inputs.split(",")[1]);
if (isAdmin && hasCertified) {
    doSomeThing();
}
```

### 1.1.3. 分解分支条件

如果分支条件中存在多种逻辑交织，可以考虑按层级将其分解。例如将：

``` c
if (gender == MALE && age > 15) {
    // ...
} else if (gender == MALE && age > 20) {
    // ...
} else if (gender == FEMALE && age > 18) {
    // ...
} else if (gender == FEMALE && age > 25) {
    // ...
}
```

修改为：

``` c
if (gender == MALE) {
    if (age > 15) {
        // ...
    } else if (age > 20) {
        // ...
    }
} else if (gender == FEMALE) {
    if (age > 18) {
        // ...
    } else if (age > 25) {
        // ...
    }
}
```

这种分解的副作用是会增加复杂度，要酌情适当使用。


### 1.1.4. 提取函数

有时你在维护一个公共API方法，它里面有一个极其复杂的条件表达式。为了保证主干代码的清晰简洁，你可以将这个表达式暂且简单的移到独立函数中，再酌情考虑重构此表达式。例如将：

``` java
public void Foo() {
    // ...

    if (A > B && B < 100 || C == D && ! E ...) {

    }

    // ...
}
```

修改为：

``` java
public void Foo() {
    // ...

    if (isReady(...)) {

    }

    // ...
}
private boolean isReady(...) {
    return ...
}
```



## 1.2. 改进执行过程

### 1.2.1. 提取函数

从 `if` 、`then` 、`else` 三个段落中分别提炼出独立的函数。这样做的好处是，可以将“要做的事情”独立出来，从来突出条件逻辑。该做法非常适合这种情况：当你想更清楚地表明每个分支的作用，并且突出每个分支的原因时。例如将：

``` java
if (A && B || C) {
    // 此处数十行代码
} else if (...) {
    // 此处数十行代码
} else {
    // 此处数十行代码
}
```

上面各分支中的代码累加起来可能多达百行。尽管这个样例看起来很简单，真实的代码往往会让维护者的阅读压力很大，可以修改为：

``` java
if (A && B || C) {
    doThingA();
} else if (...) {
    doThingB();
} else {
    doThingC();
}
```

### 1.2.2. 使用空对象模式

有时你需要再三检查某对象是否为 `null` ：

``` java
// Foo.java
public class Foo {
    public void foo() {
        User user = Factory.getUser(id);
        if (user != null) {
            Bar bar = Factory.getBar(user.getName());
            if (bar != null) {
                Foobar fb = Factory.getFoobar();
                if (fb != null) {
                    // ...
                }
            }
        } else {
            System.out.println("User is null!");
        }
    }
}

// User.java
public class User {
    public String getName() {
        return "zhangsan";
    }
}

// Factory.java
public class Factory {
    public static User getUser(int id) {
        if (id == 100) {
            return null;
        }
        return new User();
    }
}
```

此时可以将 null 值替换为空对象。重构过程如下：

1. 为源类建立一个子类，使其行为就像是源类的 null 版本。在源类和 null 子类中都加上 `isNull()` 函数，前者的 `isNull()`应该返回 `false` ，后者的 `isNull()` 返回`true` 。
2. 编译。
3. 找出所有“索求源对象却获得一个null”的地方。修改这些地方，使它们改而获得一个空对象。
4. 找出“将源对象与null做比较”的地方。修改这些地方，使它们调用 `isNull()` 函数。
5. 编译、测试。
6. 找出这样的程序点：如果对象不是null，做A动作，否则做B动作。
7. 对于每一个上述地点，在 null 类中覆写A动作，使其行为和B动作相同。
8. 使用上述被覆写的动作，然后删除“对象是否等于null”的条件测试。编译并测试。

重构后的参考代码如下：

``` java
public interface User {
    public boolean isNull();
    public String getName();
}

public class RealUser implements User {
    public boolean isNull() {
        return false;
    }
    public String getName() {
        return "zhangsan";
    }
}

public class NullUser implements User {
    public boolean isNull() {
        return true;
    }
    public String getName() {
        System.out.println("User is null!");
        return "";
    }
}

public class Factory {
    public static User getUser(int id) {
        if (id == 100) {
            return new NullUser();
        }
        return new RealUser();
    }
}

public class Foo {
    public void foo() {
        User user = Factory.getUser(id);
        Bar bar = Factory.getBar(user.getName());
        // ...
    }
}
```

`C#` 、`Go` 、 `swift` 等从语言级别直接提供 NullObject 模式，你可以很方便的使用或改进它。


## 1.3. 改进条件调度

### 1.3.1. 使用 `卫语句` 避免不必要的嵌套

> 条件表达式通常有2种表现形式。第一：所有分支都属于正常行为。第二：条件表达式提供的答案中只有一种是正常行为，其他都是不常见的情况。这2类条件表达式有不同的用途。如果2条分支都是正常行为，就应该使用形如 `if ... else ...`的条件表达式；如果某个条件极其罕见，就应该单独检查该条件，并在该条件为真时立刻从函数中返回。这样的单独检查常常被称为**卫语句(guard clause)**。


可以先将程序逻辑中不符合条件的情况优先过滤掉，以保证主体代码的清晰简单。例如将：

``` java
if (age >= 18) {
    doSomeThing();
}
```

改造为：

``` java
if (age < 18) {
    return;
}
doSomeThing();
```

### 1.3.2. 合并表达式

如果有一系列条件测试都得到相同的结果，将这些测试合并为一个表达式，并将这个条件表达式提炼为一个独立函数。例如将：

``` java
if (A && B) {
    doThingA();
} else if (A && C) {
    doThingA();
} else {
    doThingB();
}
```

改造为：

``` java
if (readyToA()) {
    doThingA();
} else {
    doThingB();
}
```

### 1.3.3. 表驱动法

有时，测试条件可以使用数据表的形式驱动。例如以下代码：

``` bash
if [$month -eq 1]; then
    day=31
elif [$month -eq 2]; then
    day=28
elif [$month -eq 3]; then
    day=31
elif [$month -eq 4]; then
    day=30
elif [$month -eq 5]; then
    day=31
elif [$month -eq 6]; then
    day=30
elif [$month -eq 7]; then
    day=31
elif [$month -eq 8]; then
    day=31
elif [$month -eq 9]; then
    day=30
elif [$month -eq 10]; then
    day=31
elif [$month -eq 11]; then
    day=30
elif [$month -eq 12]; then
    day=31
fi
```

可以改写为：

``` bash
days=(31 28 31 30 31 30 31 31 30 31 30 31)
day=days[$month];
```

又如：

``` js
var bar;
if (foo === 'it') {
    bar = 'a';
} else if (foo === 'is') {
    bar = 'b';
} else if (foo === 'not') {
    bar = 'c';
} else if (foo === 'too') {
    bar = 'd';
} else if (foo === 'bad') {
    bar = 'e';
} else {
    bar = 'f';
}
```

可以修改为：

``` js
var bar = {
    'it': 'a',
    'is': 'b',
    'not': 'c',
    'too': 'd',
    'bad': 'e'
}[foo] || 'f';
```

利用以上方法结合函数式编程方式，在 JavaScript 中可以创造出极其精简灵活的代码。

同样，还可以使用 `map` 或多层 map 来简化分支语句：

``` go
male := make(map[string]string)
female := make(map[string]string)

...

m := map[string]map {
    "MALE": male,
    "FEMALE": female,
}

if m, ok := m["MALE"]; ok {
    m["..."] ...
} else {
    ...
}
```

表驱动法的核心思路是将各判断条件放置到表结构中，从而减化客户端代码的判断逻辑，使代码条理更加清晰。


### 1.3.4. 使用多态





# 2.性能优化