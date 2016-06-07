title: Java8特性 - Lambda表达式
date: 2015-10-30 08:41:43
categories: Coding
tags:
 - lang
 - java
 - java8特性
---

Lambda表达式并不是什么新概念，Java8中引入它主要解决只有单一方法的匿名类使用起来过于丑陋、晦涩的问题。不说废话。假设有这样一个对象：

```java
public class Person {
    public enum Sex {
        MALE, FEMALE
    }

    String name;
    LocalDate birthday;
    Sex gender;
    String emailAddress;

    public int getAge() {
        // ...
    }

    public void printPerson() {
        // ...
    }
}
```

如果想从一组 `Person` 中打印特定年龄的，代码看起来是这样的：

```java
public static void printPersonsOlderThan(List<Person> roster, int age) {
    for (Person p : roster) {
        if (p.getAge() >= age) {
            p.printPerson();
        }
    }
}
```

如果查找年龄的算法变了，你可能会把代码改成这样：

```java
public static void printPersonsWithinAgeRange(
    List<Person> roster, int low, int high) {
    for (Person p : roster) {
        if (low <= p.getAge() && p.getAge() < high) {
            p.printPerson();
        }
    }
}
```

这时你意识到，算法的改变总是会导致修改上面的代码，为了应对将来可能的变化，你想到了把查找 `Person` 的算法从中剥离出来：

```java
public static void printPersons(
    List<Person> roster, CheckPerson tester) {
    for (Person p : roster) {
        if (tester.test(p)) {
            p.printPerson();
        }
    }
}
```

这时只需要针对不同的查找算法提供不同的实现类：

```java
interface CheckPerson {
    boolean test(Person p);
}

class CheckPersonEligibleForSelectiveService implements CheckPerson {
    public boolean test(Person p) {
        return p.gender == Person.Sex.MALE &&
            p.getAge() >= 18 &&
            p.getAge() <= 25;
    }
}
```

调用的时候，只需要实例化特定的实现类并传入方法即可：

```java
printPersons(roster, new CheckPersonEligibleForSelectiveService());
```

然而这样的方式会引入一堆“很小”的实现类。于是你发现这种场景下使用匿名类更为合适：

```java
printPersons(
    roster,
    new CheckPerson() {
        public boolean test(Person p) {
            return p.getGender() == Person.Sex.MALE
                && p.getAge() >= 18
                && p.getAge() <= 25;
        }
    }
);
```

### 1. Lambda 表达式的使用

`CheckPerson` 是一个**函数接口**，它是指只有一个抽象方法的接口(友情提示: 没有任何方法的接口叫**标识接口**)。由于只有一个抽象方法，我们完全有理由在实现中忽略掉方法名，而这正是 Lambda 表达式的作用：

```java
printPersons(
    roster,
    (Person p) -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25
);
```

再回顾一下 `CheckPerson` 接口的代码：

```java
interface CheckPerson {
    boolean test(Person p);
}
```

这样的**函数接口**过于简单，似乎没有必要在应用中定义诸多类似的东西。于是 JDK 给你提供了很多开箱即用的接口，它们在 `java.util.function` 包中。比如该例中可以使用 `Predicate<T>` ：

```java
interface Predicate<T> {
    boolean test(T t);
}
```

使用它来替换 `CheckPerson` 接口，代码变成了：

```java
public static void printPersonsWithPredicate(
    List<Person> roster, Predicate<Person> tester) {
    for (Person p : roster) {
        if (tester.test(p)) {
            p.printPerson();
        }
    }
}
```

对应的调用方式为：

```java
printPersonsWithPredicate(
    roster,
    p -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25
);
```

玩完了年龄的查找算法，我们来看一下执行逻辑。前面的示例在找到合法的年龄后，只是调用了 `printPerson()` 方法进行打印。如果想改变这一执行逻辑，不再是打印呢？我们可以将执行过程当作一个参数并使用 lambda 表达式来改造。要记住，使用 lambda 表达式必须实现函数接口。

`Consumer<T>` 接口可以传入一个参数并返回 `void` ，该接口包含一个方法：` void accept(T t)` ，使用它将代码改为：

```java
public static void processPersons(
        List<Person> roster,
        Predicate<Person> tester,
        Consumer<Person> block) {
    for (Person p : roster) {
        if (tester.test(p)) {
            block.accept(p);
        }
    }
}
```

这时便可以将不同的执行逻辑当作参数传入，如果依然想执行打印方法，则：

```java
processPersons(
     roster,
     p -> p.getGender() == Person.Sex.MALE
         && p.getAge() >= 18
         && p.getAge() <= 25,
     p -> p.printPerson()
);
```

有时会需要处理后得到一个返回值，`Function<T,R>` 接口正是此作用，它包含一个 `R apply(T t)` 方法。现在来继续改造上面的例子，加入一个新参数 `mapper` 来提供获得数据的逻辑：

```java
public static void processPersonsWithFunction(
        List<Person> roster,
        Predicate<Person> tester,
        Function<Person, String> mapper,
        Consumer<String> block) {
    for (Person p : roster) {
        if (tester.test(p)) {
            String data = mapper.apply(p);
            block.accept(data);
        }
    }
}
```

调用代码，获得用户的电子邮件地址并输出到控制台：

```java
processPersonsWithFunction(
    roster,
    p -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25,
    p -> p.getEmailAddress(),
    email -> System.out.println(email)
);
```

### 2. 充分使用泛型

事实上，我们上面得到的 `processPersonsWithFunction` 方法不仅可以处理 `Person` 类型，如果我们把类型声明改用泛型，可以得到更为通用的方法：

```java
public static <X, Y> void processElements(
        Iterable<X> source,
        Predicate<X> tester,
        Function <X, Y> mapper,
        Consumer<Y> block) {
    for (X p : source) {
        if (tester.test(p)) {
            Y data = mapper.apply(p);
            block.accept(data);
        }
    }
}
```

针对 `Person` 类型，依然可以如此调用：

```java
processElements(
    roster,
    p -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25,
    p -> p.getEmailAddress(),
    email -> System.out.println(email)
);
```

它的执行过程是这样的：
1. 从集合 `source` 中获取一组对象，该例从 `roster` 中获得 `Person` 对象。
2. 从这组对象中过滤出符合 `tester` 的( 即满足 `Predicate` 的对象 )。该例的 `Predicate` 使用 lambda 表达式。
3. 通过 `Function` 类型的对象 `mapper` ，将上面过滤出的对象类型映射为某值类型。该例中的 `Function` 对象是 Lambda 表达式，它返回了 `String` 型的电子邮件地址。
4. 将映射后的值通过 `Consumer` 对象 `block` 执行某行为。该例中的 `Consumer` 对象也是 Lambda 表达式，执行的行为是打印字符串。

### 3. 使用链式操作

使用 Lambda 表达式作为参数，使得链式操作变得极为方便，比如：

```java
roster
    .stream()
    .filter(
        p -> p.getGender() == Person.Sex.MALE
            && p.getAge() >= 18
            && p.getAge() <= 25)
    .map(p -> p.getEmailAddress())
    .forEach(email -> System.out.println(email));
```

例子中用到的方法签名如下：

* Stream<E> **stream**()
* Stream<T> **filter**(Predicate<? super T> predicate)
* <R> Stream<R> **map**(Function<? super T,? extends R> mapper)
* void **forEach**(Consumer<? super T> action)

参考此例，可以在 Java 中写出许多能够媲美支持函数式编程的语言的代码。

### 4. 在 GUI 中的应用

Java GUI 编程中经常出现类似的代码：

```java
btn.setOnAction(new EventHandler<ActionEvent>() {
    @Override
    public void handle(ActionEvent event) {
        System.out.println("Hello World!");
    }
});
```

它极其适合使用 Lambda 表达式进行改造：

```java
btn.setOnAction(
    event -> System.out.println("Hello World!")
);
```

### 5. 语法细节

领略了 Lambda 表达式的风采后，来看其语法。Lambda 表达式由三部分组成：

* 形参列表
* 箭头符号
* 主体部分

首先是放在圆括号中的、以逗号分隔的**形参列表**。比如：

```java
(User u, Role r) -> ...
```

在 Lambda 表达式中可以省略参数类型，当只有一个参数时，也可以省略圆括号：

```java
p -> p.getGender() == Person.Sex.MALE 
    && p.getAge() >= 18
    && p.getAge() <= 25
```

**箭头符号**就是 `->` 。

**主体**可以是一个表达式：

```java
p.getGender() == Person.Sex.MALE 
    && p.getAge() >= 18
    && p.getAge() <= 25
```

也可以是一个语句：

```java
p -> {
    return p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25;
}
```

无返回值的语句也可以不使用语句块( `{}` )：

```java
email -> System.out.println(email)
```

来看一个使用多个形参的例子：

```java
public class Calculator {

    interface IntegerMath {
        int operation(int a, int b);   
    }
    
    public int operateBinary(int a, int b, IntegerMath op) {
        return op.operation(a, b);
    }

    public static void main(String... args) {
        Calculator myApp = new Calculator();
        IntegerMath addition = (a, b) -> a + b;
        IntegerMath subtraction = (a, b) -> a - b;
        System.out.println("40 + 2 = " +
            myApp.operateBinary(40, 2, addition));
        System.out.println("20 - 10 = " +
            myApp.operateBinary(20, 10, subtraction));    
    }
}
```

它的输出结果为：

```sh
40 + 2 = 42
20 - 10 = 10
```

### 6. 作用域

Lambda 表达式中可以使用变量，采用词法作用域(ps：可参考 JavaScript 作用域)，不存在变量作用域屏蔽问题。

```java
import java.util.function.Consumer;

public class LambdaScopeTest {

    public int x = 0;

    class FirstLevel {

        public int x = 1;

        void methodInFirstLevel(int x) {
            
            // 该语句将会导致 `语句A` 编译错误：
            // "local variables referenced from a lambda expression
            // must be final or effectively final"
            // x = 99;
            
            Consumer<Integer> myConsumer = (y) -> 
            {
                System.out.println("x = " + x); // 语句A
                System.out.println("y = " + y);
                System.out.println("this.x = " + this.x);
                System.out.println("LambdaScopeTest.this.x = " +
                    LambdaScopeTest.this.x);
            };

            myConsumer.accept(x);

        }
    }

    public static void main(String... args) {
        LambdaScopeTest st = new LambdaScopeTest();
        LambdaScopeTest.FirstLevel fl = st.new FirstLevel();
        fl.methodInFirstLevel(23);
    }
}
```

上例的输出结果为：

```java
x = 23
y = 23
this.x = 1
LambdaScopeTest.this.x = 0
```

如果把例子中的 `myConsumer` 的参数改为 `y` :

```java
Consumer<Integer> myConsumer = (x) -> {
    // ...
}
```

将会抛出错误： "variable x is already defined in method methodInFirstLevel(int)" 。这是因为 Lambda 表达式并不会引入新的作用域范围。Lambda 表达式中只能访问 final 或 effectively final 的变量，这一点和匿名类仍然是一致的。

> **effectively final** 是 Java8 的特性之一：局部内部类和匿名内部类访问的局部变量必须由final修饰，Java8 中可以不加final修饰符，由系统默认添加。

### 7. 目标类型

Lambda 表达式的类型是由上下文推导而来，并不是函数接口的名称。例如之前的两个例子：

* public static void printPersons(List<Person> roster, CheckPerson tester) 
* public void printPersonsWithPredicate(List<Person> roster, Predicate<Person> tester)

当 Java 的运行时执行 `printPersons` 方法时需要 `CheckPerson` 类型，因此 Lambda 表达式的类型是 `CheckPerson` 。而在方法 `printPersonsWithPredicate` 中，其类型为 `Predicate<Person>` 。这种类型叫做 **目标类型(target type)** ，它只能在下列场景使用：

* 变量声明
* 赋值
* 返回语句 return
* 数组初始化
* 方法或构造器参数
* Lambda 表达式主体中
* 条件表达式 `? :`
* 类型转换

最后来看一个例子。假设有如下两个函数接口：

```java
public interface Runnable {
    void run();
}

public interface Callable<V> {
    V call();
}
```

`Runnable.run` 没有返回值，而 `Callable<V>.call` 有返回值。

现在有这样两个方法：

```java
void invoke(Runnable r) {
    r.run();
}

<T> T invoke(Callable<T> c) {
    return c.call();
}
```

下面的语句会执行哪个方法呢？

```java
String s = invoke(() -> "done");
```

答案是 `invoke(Callable<T>)` ，因为它有返回值。因此，Lambda 表达式的类型是 `Callable<T>` ，很简单对吗？

**参考资料**

* [The Java™ Tutorials: Lambda Expressions](http://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

