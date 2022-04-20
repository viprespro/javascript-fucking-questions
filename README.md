# JavaScript易错题集列表

:muscle: :rocket: 持续更新学习或工作中遇到的问题。

折叠部分查看答案，祝好运 :heart: :smile:！

---
###### 1. ['1', '2', '3'].map(parseInt)结果是什么？

<details><summary><b>答案</b></summary>
<p>

#### 答案: [1, NaN, NaN]

**map方法**

`map()` 方法创建一个新数组，其结果是该数组中的每个元素是调用一次提供的函数后的返回值。

```javascript
var new_array = arr.map(function callback(currentValue[,index[, array]]) {
 // Return element for new_array
 }[, thisArg])
```

`callback`回调函数需要三个参数, 我们通常只使用第一个参数 (其他两个参数是可选的)。
`currentValue` 是callback 数组中正在处理的当前元素。
`index`可选, 是callback 数组中正在处理的当前元素的索引。
`array`可选, 是callback map 方法被调用的数组。
另外还有`thisArg`可选, 执行 callback 函数时使用的this 值

```javascript
const arr = [1, 2, 3];
arr.map((num) => num + 1); // [2, 3, 4]
```

**parseInt**

`parseInt()` 函数解析一个字符串参数，并返回一个指定基数的整数 (数学系统的基础)。

```javascript
const intValue = parseInt(string[, radix]);
```

`string` 要被解析的值。如果参数不是一个字符串，则将其转换为字符串(使用 ToString 抽象操作)。字符串开头的空白符将会被忽略。

`radix` 一个介于包含2和36之间的整数(数学系统的基础)，表示上述字符串的基数。默认为10。
`返回值` 返回一个整数或NaN

**运行流程**

```javascript
['1', '2', '3'].map((item, index) => {
	return parseInt(item, index)
})

// 每次执行
parseInt('1', 0) // 1
parseInt('2', 1) // NaN 
parseInt('3', 2) // NaN 标识3以2进制 3不是二进制故而解析出错
```

**如何达到预期效果**

```javascript
['1', '2', '3'].map(Number) // [1,2,3]
```

</p>
</details>

###### 2. 以下输出结果是什么？
   ```javascript
   var i,j,k;
   for( i = 0 , j = 0; i < 10 , j < 6; i++ , j++ ) {
     k = i+j;
   }
   document.write(k);
   ```
<details><summary><b>答案</b></summary>
<p>

#### 答案: 10
解析：for 循环以及逗号操作符等。

**逗号操作符**
逗号操作符 对它的每个操作对象求值（从左至右），然后返回最后一个操作对象的值。
```javascript
  console.log((1,2)) // 2
  console.log((x=2, ++x)) // 3
```
```javascript
  var a = {
    foo: function() {
      console.log(this === window);
    }
  };

  a.foo(); // Returns 'false' in console
  // 此时返回就是foo方法的调用 this指向window
  (0, a.foo)(); // Returns 'true' in console
```
**回到题目**
for循环中，循环条件判断时，由于逗号操作符的缘故，继续循环的条件为最后一个，流程如下：
i=0, j=0  => 0
i=1, j=1  => 2
i=2, j=2  => 4
i=3, j=3  => 6
i=4, j=4  => 8
i=5, j=5  => 10

**补充**
如果j的最终值大于i，同样会以j的作循环条件遍历次数。

</p>
</details>

---
###### 3. 以下输出结果？
   ```javascript
   var obj = {
    '2': 3,
    '3': 4,
    'length': 2,
    'splice': Array.prototype.splice,
    'push': Array.prototype.push
   }
   obj.push(1)
   obj.push(2)
   console.log(obj)
   ```
<details><summary><b>答案</b></summary>
<p>

```javascript
// 对象类型如下 将存在length属性为number，并且拥有splice属性对应位函数时，此时对象会变成一个伪数组
const o = {
  length: 1,
  splice: function() {
    console.log(this)
  },
  push: Array.prototype.push
}
// 会做一个key的赋值 push的位置indx就是此时的key值 此时调用了之后length会加1
o.push(1)
// 相当于 o[index] = 1
console.log(o) // Object [empty, 1, splice: ƒ]

// 当没有splice函数时对象处理 输出应该时Object {length:2, 1: 1, splice: f}
```
问题讨论：https://github.com/Advanced-Frontend/Daily-Interview-Question/issues/76


</p>
</details>

---
###### 4. 输出以下结果？

   ```javascript
   // example 1
   var a={}, b='123', c=123;  
   a[b]='b';
   a[c]='c';  
   console.log(a[b]);
   
   ---------------------
   // example 2
   var a={}, b=Symbol('123'), c=Symbol('123');  
   a[b]='b';
   a[c]='c';  
   console.log(a[b]);
   
   ---------------------
   // example 3
   var a={}, b={key:'123'}, c={key:'456'};  
   a[b]='b';
   a[c]='c';  
   console.log(a[b]);
   ```

<details><summary><b>答案</b></summary>
<p>
  **答案：** c	b 	c

**解析：**此题考察	对象的键名的转换

- 对象的键名只能是字符串和 Symbol 类型

- 其他类型的键名会被转换成字符串类型

- 对象转字符串默认会调用 toString 方法

  ```javascript
  // example 1
  var a={}, b='123', c=123;
  a[b]='b';
  
  // c 的键名会被转换成字符串'123'，这里会把 b 覆盖掉。
  a[c]='c';  
  
  // 输出 c
  console.log(a[b]);
  ```

  ```javascript
  // example 2
  var a={}, b=Symbol('123'), c=Symbol('123');  
  
  // b 是 Symbol 类型，不需要转换。
  a[b]='b';
  
  // c 是 Symbol 类型，不需要转换。任何一个 Symbol 类型的值都是不相等的，所以不会覆盖掉 b。
  a[c]='c';
  
  // 输出 b
  console.log(a[b])
  ```

  ```javascript
  // example 3
  var a={}, b={key:'123'}, c={key:'456'};  
  
  // b 不是字符串也不是 Symbol 类型，需要转换成字符串。
  // 对象类型会调用 toString 方法转换成字符串 [object Object]。
  a[b]='b';
  
  // c 不是字符串也不是 Symbol 类型，需要转换成字符串。
  // 对象类型会调用 toString 方法转换成字符串 [object Object]。这里会把 b 覆盖掉。
  a[c]='c';  
  
  // 输出 c
  console.log(a[b]);
  ```
</p>
</details>

---
###### 5. 编写一个函数实现以下需求？

   ```javascript
   add(1); // 1
   add(1)(2);	// 3
   add(1)(2)(3)；// 6
   add(1)(2, 3); // 6
   add(1, 2)(3); // 6
   add(1, 2, 3); // 6
   ```
<details><summary><b>答案</b></summary>
<p>
  考察：函数柯里化

  curry 的概念：只传递给函数一部分参数来调用它，让它返回一个函数去处理剩下的参数。

  ```javascript
    // 参数固定的情况
    const fn = (a, b, c) => a + b + c

    const curry = (fn) => {
      return function curried(...args) {
        if (args.length < fn.length) {
          return function () {
            return curried(...args.concat(Array.from(arguments)))
          }
        }
        return fn(...args)
      }
    }

    const add = curry(fn)

    console.log(add(1, 2)(4))

    // 参数不固定的情况
    // 不限数量参数
    function curry2() {
      // 存储所有的参数
      const args = [].slice.call(arguments)
      // 在内部声明一个函数，利用闭包的特性保存_args并收集所有的参数值
      const fn = function () {
        args.concat(Array.from(arguments))
        return fn
      }
      // 利用toString隐式转换的特性，当最后执行时隐式转换，并计算最终的值返回
      fn.toString = () => args.reduce((a, b) => a + b)
      return fn
    }

    console.log(curry2(1, 2, 3))
    
  ```
</p>
</details>

---
###### 6. **输出以下结果**

```javascript
  function Foo(){
    getName = function(){
        console.log(1);
    };
    return this;
  } 
  Foo.getName = function(){
      console.log(2);
  }
  Foo.prototype.getName = function(){
      console.log(3);
  }
  var getName = function(){
      console.log(4);
  }
  function getName(){
      console.log(5);
  }
  //输出以下的输出结果
  Foo.getName();
  getName();
  Foo().getName();
  getName();
  new Foo.getName();
  new Foo().getName();
  new new Foo().getName();
```
<details><summary><b>答案</b></summary>
<p>
答案： 2 4 1 1 2 3 3

分析：考查原型原型链、隐式定义、变量提升等知识点。
`Foo.getName()` 代码中直接定义，输出2

`getName()` var 变量定义引起的变量提升，理解以下代码

```javascript
var getName = function(){
      console.log(4);
  }
function getName(){
  console.log(5);
}

// 等价于
var getName
function getName() {
    console.log(5)
}
getName = function(){
    console.log(4);
}
```

显然 `getName`已被覆盖，所以输出4

`Foo().getName()`  调用`Foo`方法，函数里面隐式定义了一个`getName`方法,返回this实例，考虑浏览器环境运行，此时相当于`Window.Foo().getName()`, this指向window，而隐式定义的变量则相当于window的属性，此时`getName`也是覆盖了输出为4的`getName`, 即此时``Foo().getName()`输出1

`getName()`等价于上面的一个输出 1

`new Foo.getName()` 即 new (Foo.getName()) 输出2

`new Foo().getName()` 即(new Foo()).getName(), 获取原型上的getName方法 输出3

`new new Foo().getName()` 即类似于上面2 输出3
</p>
</details>

---
###### 7. 下面的输出是什么？
```javascript
  class Example extends React.Component {
  constructor() {
    super();
    this.state = {
      val: 0
    };
  }

  componentDidMount() {
    this.setState({val: this.state.val + 1});
    console.log(this.state.val);    // 第 1 次 log

    this.setState({val: this.state.val + 1});
    console.log(this.state.val);    // 第 2 次 log

    setTimeout(() => {
      this.setState({val: this.state.val + 1});
      console.log(this.state.val);  // 第 3 次 log

      this.setState({val: this.state.val + 1});
      console.log(this.state.val);  // 第 4 次 log
    }, 0);
  }

  render() {
    return null;
  }
};
```
<details><summary><b>答案</b></summary>
<p>
  **答案：**  0 0 2 3
  **解析：**考察react中setState的原理
</p>
</details>

---

###### 8.以下代码输出是什么？（typeof）
```javascript
function foo() {
  let x = (y = 0);
  x++;
  y++;
  return x;
}

console.log(foo(), typeof x, typeof y);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：1, undefined and number

解析：
  1. 首先foo()的调用，x++之后输1
  2. foo函数x，y的定义等价于let x; window.y = 0; x = window.y，由于函数作用域的缘故，全局上下文将不能访问到x，所以typeof x 为undefined
  3. y全局，显然为number
</p>
</details>

---

###### 9.以下代码输出是什么？
```javascript
var y = 1;
if (function f() {}) {
  y += typeof f;
}
console.log(y);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：1undefined

解析：
  1. function f(){} 对象类型，总是返回true
  2. 由于function f(){}是在运行时调用，没有声明的地方，所以是undefined，结果显而易见。
</p>
</details>

---

###### 10.以下在非严格模式下输出是什么？
```javascript
function printNumbers(first, second, first) {
  console.log(first, second, first);
}
printNumbers(1, 2, 3);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：3，2，3

解析：
  1. 在非严格模式下，常规 JavaScript 函数允许重复的命名参数
  2. 后面参数的值，会覆盖同名参数的值
  3. 严格模式下，重名参数会抛出语法错误
</p>
</details>

---

###### 11.以下代码的输出是什么？
```javascript
console.log(String.prototype.trimLeft.name === "trimLeft");
console.log(String.prototype.trimLeft.name === "trimStart");
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：false true

解析：由于 web 兼容性的原因，旧的方法名称 'trimLeft' 仍然充当 'trimStart' 的别名。因此，“trimLeft”的原型始终是“trimStart
</p>
</details>

---

###### 12.Math.max()
```js 
console.log(Math.max());
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：-Infinity

解析：-Infinity 是初始比较值，因为几乎所有其他值都更大。因此，当没有提供参数时，将返回 -Infinity。注意：无参是有效的情况。

</p>
</details>

---

###### 13.以下代码输出是什么？
```js
console.log(10 == [10]);
console.log(10 == [[[[[[[10]]]]]]]);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：true true

解析：上面的比较可以转换为10 === Number([10].valueOf().toString()); // 10

</p>
</details>

---

###### 14.以下输出是什么？
```js
let numbers = [1, 2, 3, 4, NaN];
console.log(numbers.indexOf(NaN));
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：-1

解析：indexOf 在内部使用严格相等运算符 (===) 并且 NaN === NaN 评估为假。由于 indexOf 无法在数组中找到 NaN，因此它总是返回 -1。但是可以使用其他方式来判断

```js
let numbers = [1, 2, 3, 4, NaN];
console.log(numbers.findIndex(Number.isNaN)); // 4

console.log(numbers.includes(NaN)); // true
```

</p>
</details>

---

##### 15.以下输出是什么？
```js
var set = new Set();
set.add("+0").add("-0").add(NaN).add(undefined).add(NaN);
console.log(set);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：Set(4) {"+0", "-0", NaN, undefined}

解析：
  - 所有的NaN值都是相等的
  - +0与-0被视为不同的值

</p>
</details>

---

###### 16.以下输出是什么？
```js
console.log(
  JSON.stringify({ myArray: ["one", undefined, function () {}, Symbol("")] })
);
console.log(
  JSON.stringify({ [Symbol.for("one")]: "one" }, [Symbol.for("one")])
);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{"myArray":['one', null,null,null]}, {}

解析：
  1. undefined、Functions 和 Symbols 不是有效的 JSON 值。因此，这些值要么被省略（在对象中），要么被更改为 null（在数组中）。因此，它返回值数组的空值。
  2. 所有符号键属性将被完全忽略。因此它返回一个空对象（{}）。

</p>
</details>

---

###### 17.以下输出是什么？
```javascript
const { a: x = 10, b: y = 20 } = { a: 30 };

console.log(x);
console.log(y);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：30, 20

解析：
  1. 可以检索对象属性并将其分配给具有不同名称的变量
  2. 当检索到的值未定义时，该属性分配了默认值

</p>
</details>

---

###### 18.以下输出是什么？
```javascript
const obj = { key: "value" };
const array = [...obj];
console.log(array);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：TypeError

解析：
  1. 扩展语法只能应用于可迭代对象
  2. 默认情况下，对象是不可迭代的，但是当在数组中使用时，或者与 map()、reduce() 和 assign() 等迭代函数一起使用时，它们变得可迭代。如果你仍然尝试这样做，它仍然会抛出 TypeError: obj is not iterable.

</p>
</details>

---

###### 19.以下代码输出是什么?
```javascript
const myGenerator = (function* () {
  yield 1;
  yield 2;
  yield 3;
})();
for (const value of myGenerator) {
  console.log(value);
  break;
}

for (const value of myGenerator) {
  console.log(value);
}
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：1

解析：
  1. 一旦迭代器关闭，生成器不应该被重新使用
  2. 生成器已关闭并尝试再次对其进行迭代不会产生更多结果

</p>
</details>

---

###### 20.以下代码输出是什么？
```javascript
const squareObj = new Square(10);
console.log(squareObj.area);

class Square {
  constructor(length) {
    this.length = length;
  }

  get area() {
    return this.length * this.length;
  }

  set area(value) {
    this.area = value;
  }
}
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：ReferenceError

解析：
  1. 不像函数定义，类的定义不会提升，必须要先定义再引用，否则会出现引用错误的问题
   
</p>
</details>

---

###### 21.以下代码输出是什么？
```javascript
let msg = "Good morning!!";
msg.name = "John";
console.log(msg.name);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：undefined

解析：它在非严格模式返回undefined，在为严格模式返回错误。
在非严格模式下，将创建包装器对象并获取提到的属性。但是在访问下一行的属性后，该对象消失了。
   
</p>
</details>

---