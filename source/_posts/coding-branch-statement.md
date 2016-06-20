title: 写好程序分支控制
date: 2015-09-13
categories: Coding
updated: 2015-09-18
tags:
 - lang
 - pattern
---


分支语句在编程语言中有着举足轻重的地位。有一定工作年限的程序员，通常遇到过这样一段代码，它有数百行，包含了十几甚至二十几个分支，嵌套多达五六层甚至十多层，各种 `if ... else ...` 语句交叉在一起。最可恨的是，每个分支上有着详尽的注释，你花了二十分钟，仔细阅读了每条注释，最后发现这些注释根本不能够告诉你它要做什么，你依然一头雾水。甚至有些注释还TM是错的，和代码逻辑根本不一致。

这样的代码一般是老系统长期维护造成的。随着用户的需求不断地变更，维护它的程序员不得不在代码上无限地增加 `if` 。当然也有“大牛”可以一开始便写出这么复杂的分支逻辑。

废话说了很多，本文的目的在于归纳关于分支语句的林林总总。探讨如何写出漂亮的分支逻辑。

# 1. 重构

一个正常的程序员是不会痛骂 `if A then B` 这样的分支的，大多数分支代码一开始确实也长得如此。然而，随着时间的推移，需求的不断变更，分支代码通常看起来是这样的：

```c
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

如果你愿意做一个有节操的程序员，在上面的代码继续发臭腐烂、直至必须重写前，你应该对其重构。我认为**重构应该优先保证那些公开的API方法流程清晰易读、抽象层次一致、职责单一，具体的实现细节交由私有方法处理。**

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

这种分解的副作用是有可能增加圈复杂度，要酌情适当使用。


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

有时你需要再三检查某对象是否为 `null` ，并对空对象做出相同的响应：

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
        if (id == 0) {
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
        if (id == 0) {
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

另外，还可以在不修改 `User` 代码的前提下，引入**标识接口**来识别空对象。例如增加一个：

``` java
interface Null {}
```

它不定义任何函数。然后让空对象实现它：

``` java
class NullUser extends User implements Null {
    // ...
}
```

此时便可以通过 `instanceof` 操作符来检查对象是否为 null.


## 1.3. 改进条件调度

### 1.3.1. 使用 `卫语句` 避免不必要的嵌套

> 条件表达式通常有2种表现形式。第一：所有分支都属于正常行为。第二：条件表达式提供的答案中只有一种是正常行为，其他都是不常见的情况。这2类条件表达式有不同的用途。如果2条分支都是正常行为，就应该使用形如 `if ... else ...` 的条件表达式；如果某个条件极其罕见，就应该单独检查该条件，并在该条件为真时立刻从函数中返回。这样的单独检查常常被称为**卫语句(guard clause)**。


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
day=days[$month]
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

表驱动法的核心思路是将各判断条件放置到表结构中，将判断逻辑转化为查找表的逻辑，从而减化客户端代码，使代码条理更加清晰。使用时应该重点关注表结构的设计。


### 1.3.4. 使用多态

当条件分支逻辑是用来判定类型、代码执行逻辑的抽象层次一致且较为复杂时，可考虑使用多态。例如以下代码(注：示例代码结构其实很简单，通常不需要修改，希望你能够理解它背后所代表的复杂的结构)：

``` java
public int getLegNumbers(String name) {
    switch(name) {
    case "chicken":
        return 2;
    case "frog":
        return 4;
    case "crab":
        return 8;
    case "centipede":
        return 70;
    }
}
```

可以重构为：

``` java
// 客户端代码：
public int getLegNumbers(Animal animal) {
    return animal.legs();
}
```

``` java
// 基于多态的重构
public interface Animal {
    legs();
}
public class Chicken implements Animal {
    public int legs() {
        return 2;
    }
}
public class Frog implements Animal {
    public int legs() {
        return 4;
    }
}
public class Crab implements Animal {
    public int legs() {
        return 8;
    }
}
public class Centipede implements Animal {
    public int legs() {
        return 70;
    }
}
```

有时你还需要：
1. 使用**策略模式**或**状态模式**取代类型代码；
2. 使用**命令模式**替换条件调度逻辑。

### 1.3.5. 使用鸭子类型

除了使用多态做类型泛化，也可以使用鸭子类型约束行为方法。它可以忽略掉你必须对类型所做的判断，而只关心程序中的行为逻辑的抽象。例如：

``` go
type Chicken struct {
    legs int
}

func NewChicken() *Chicken {
    chicken := Chicken{
        legs: 2,
    }
    return &chicken
}

func (c *Chicken) Legs() int {
    return c.legs
}

...
```

客户端代码只需要约束鸭子类型，不需要关注实现细节，甚至不需要关注是不是 `Animal`，只要有 `Legs`，哪怕你是一张桌子：

``` go
type LegsNumber interface {
    Legs() int
}

func LegNumbers(anything LegsNumber) {
    return anything.Legs()
}
```


重构过程你应该把握好“度”的问题，并不是当你遇到A情况时，将其重构为B情况即为最佳实践。通常脱离应用场景是无法谈最佳实践的。例如当你过分地依赖多态或其它设计模式时，很可能因为引入过多的类，将原本简单清晰的代码变得更晦涩。你应该努力做到让代码阅读者每次接收到的信息保持相同的抽象层次，比如一个业务流程控制方法中，应该只能看到流程的控制逻辑以及执行哪些流程，而不应该出现流程处理的细节。



# 2. 性能优化

> 过早的优化是万恶之源。 -- Donald Knuth

首先，千万不要为了你以为的那么一丁点性能提升，就以牺牲代码可读性为代价而做性能优化！其次，你要认清你所谓的性能提升10倍，是将 1 毫秒变成了 0.1 毫秒，还是将 10 秒变成了 1 秒。性能优化应该关注产生性能瓶颈的部分。

通常优化工作应该在高层次上来做，很少会出现优化一个分支语句这种极端的场景。但为了文章的完整性，仍然总结了一些和分支相关的优化技巧。结构良好的代码通常和编程语言的关系不是那么紧密，但是性能优化往往会和编程语言紧密关联。优化工作应该总是**结合运行时的具体环境**来做，以下仅仅是一些思路总结。


假设有这样一段代码：

``` c
if (value == 0) {
    return result0;
} else if (value == 1) {
    return result1;
} else if (value == 2) {
    return result2;
} else if (value == 3) {
    return result3;
} else if (value == 4) {
    return result4;
} else if (value == 5) {
    return result5;
} else if (value == 6) {
    return result6;
} else if (value == 7) {
    return result7;
} else if (value == 8) {
    return result8;
} else if (value == 9) {
    return result9;
} else {
    return result10;
}
```

## 2.1 将条件按频率倒排

实际业务中，如果 `value` 为 `9` 的情况经常出现，则应该将该判断放在最前面。

``` c
if (value == 9) {
    return result9;
} else if (value == 0) {
    return result0;
} else if (value == 1) {
    return result1;
} else if (value == 2) {
    return result2;
} else if (value == 3) {
    return result3;
} else if (value == 4) {
    return result4;
} else if (value == 5) {
    return result5;
} else if (value == 6) {
    return result6;
} else if (value == 7) {
    return result7;
} else if (value == 8) {
    return result8;
} else {
    return result10;
}
```

## 2.2 拆分分支

如果没有明显的频率，则可考虑拆分成多个分支。其实和上面一样，核心思路是**减少分支判断的次数**：

``` c
if (value < 6) {
    if (value < 3) {
        if (value == 0) {
            return result0;
        } else if (value == 1) {
            return result1;
        } else {
            return result2;
        }
    } else {
        if (value == 3) {
            return result3;
        } else if (value == 4) {
            return result4;
        } else {
            return result5;
        }
    }
} else {
    if (value < 8) {
        if (value == 6) {
            return result6;
        } else {
            return result7;
        }
    } else {
        if (value == 8) {
            return result8;
        } else if (value == 9) {
            return result9;
        } else {
            return result10;
        }
    }
}
```

## 2.3 使用 switch 语句

多重条件判断时推荐 `switch` 语句，通常编译器更容易针对它做优化。而像 JavaScript 中，其性能随解释引擎不同表现参差不齐。

上面的例子很容易改造成 `switch` 语句，不再给出示例代码。

## 2.4 使用表查询

参见“重构”中的“表驱动法”。当条件判断数量众多，且这些条件能用数字或字符串等离散值来表示时，通常可以进行类似的优化。使用表结构，不仅能提高代码可读性，也能提升效率。

## 2.5 Duff 策略

这条和分支没有直接关系，是快速循环的技巧。由于会用到 `switch` 语句，也放在此处备查。

首先要了解这样一个事实：对于绝大多数语言，将循环展开后效率往往更高。例如：

``` js
var i = values.length;
while (i--) {
    process(values[i]);
}
```

比如数组中有 5 项，展开后的执行速度更快：

``` js
process(values[0]);
process(values[1]);
process(values[2]);
process(values[3]);
process(values[4]);
```

Duff 策略由 Tom Duff 首先在 C 语言中提出。它是一种展开循环的构想，通过限制循环次数来减少循环开销。这里给出 JavaScript 实现的示例代码(因为这种技巧在 JavaScript 中更实用)：

``` js
var iterations = Math.ceil(values.length / 8);
var startAt = values.length % 8;
var i = 0;

do {
    switch(startAt) {
        case 0: process(values[i++]);
        case 7: process(values[i++]);
        case 6: process(values[i++]);
        case 5: process(values[i++]);
        case 4: process(values[i++]);
        case 3: process(values[i++]);
        case 2: process(values[i++]);
        case 1: process(values[i++]);
    }
    startAt = 0;
} while (--iterations > 0);
```


