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

`parseInt()` 是JavaScript的内置函数，解析一个字符串参数，并返回一个指定基数的整数 (数学系统的基础)。

```javascript
const intValue = parseInt(string[, radix]);
```

`string` 要被解析的值。如果参数不是一个字符串，则将其转换为字符串(使用 ToString 抽象操作)。字符串开头的空白符将会被忽略。

`radix` 一个介于包含2和36之间的整数(数学系统的基础)，表示上述字符串的基数。基数未填或者传0那么将默认为10。
`返回值` 返回一个整数或NaN

**运行流程**

```javascript
['1', '2', '3'].map((item, index) => parseInt(item, index))

// 每次执行
parseInt('1', 0) // 1 
parseInt('2', 1) // NaN 
parseInt('3', 2) // NaN 
```

**如何达到预期效果**

```javascript
['1', '2', '3'].map((item) => parseInt(item))
OR
['1', '2', '3'].map(Number)
```

**parseInt(value,radix)转换规则(伴随radix)总结**
- value若不是字符串，先转为字符串
- 检查radix是否在区间[2,36]之间，0或不填默认为10，不再此区间直接返回NaN，parseInt('2', 1) 1不在有效值内，返回NaN
- 依顺序找到字符串value中满足小于radix的数，直到无效数值型，parseInt('3', 2) 2表示为按照二进制解析，只有0 1属于有效数字，3不为有效数字，返回NaN

</p>
</details>

###### 2. 以下输出结果是什么？
```javascript
 let i,j,k;
 for( i = 0 , j = 0; i < 10 , j < 6; i++, j++ ) {
   k = i+j;
 }
 console.log('k:', k)
```
<details><summary><b>答案</b></summary>
<p>

#### 答案: k: 10
解析：考察for 循环以及逗号操作。

**逗号操作符**
逗号操作符 对它的每个操作对象求值（从左至右），然后返回最后一个操作对象的值。
```javascript
console.log((1,2)) // 2
console.log((x=2, ++x)) // 3
```
```javascript
const a = {
  foo: function() {
    console.log(this === window);
  }
};

a.foo(); // this此时指向a 显然this !== window

// 使用逗号操作符
(0, a.foo)(); // 'true' in console

// 使用逗号操作符之后等价于
const b = a.foo
b()  // 'true' in console
```
**回到题目**
for循环中，循环条件判断时，由于逗号操作符的缘故，继续循环的条件为最后一个，流程如下：
i=0, j=0  => 0
i=1, j=1  => 2
i=2, j=2  => 4
i=3, j=3  => 6
i=4, j=4  => 8
i=5, j=5  => 10

**题目修改**
```javascript
 let i,j,k;
 for( i = 0 , j = 0; i < 6 , j < 10; i++ , j++ ) {
   k = i+j;
 }
 console.log('k:', k) // k: 18
```

**总结**
如果j的最终值大于i，同样会以j的作循环条件遍历次数。

</p>
</details>

---
###### 3. 以下输出结果？
```javascript
const obj = {
'2': 3,
'3': 4,
'length': 2,
'splice': Array.prototype.splice,
'push': Array.prototype.push
}
console.log(obj)
obj.push(1)
obj.push(2)
console.log(obj)
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：Object(4) [empty × 2, 1, 2, splice: ƒ, push: ƒ]

```javascript
// 考察点
// 1. 当对象存在splice属性时 控制台输出会是数组的形式 但obj仍然是对象类型
// 2. push的位置取决于此时length的长度 此时length为2 所以执行push会从小标2开始 2次push覆盖了3、4，length长度变为4

// 存在splice函数
const o = {
  length: 1,
  splice: Array.prototype.splice,
  push: Array.prototype.push
}
o.push(1)
o.push(2)
console.log('o:', o) // [empty, 1, 2, splice: f, push: f]

// 不存在splice函数时当对象处理
const o2 = {
  length: 1,
  push: Array.prototype.push
}
o.push(1)
o.push(2)
console.log('o2:', o2) // {length: 1, push: ƒ}
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
   
   // example 2
   var a={}, b=Symbol('123'), c=Symbol('123');  
   a[b]='b';
   a[c]='c';  
   console.log(a[b]);
   
   // example 3
   var a={}, b={key:'123'}, c={key:'456'};  
   a[b]='b';
   a[c]='c';  
   console.log(a[b]);
   ```

<details><summary><b>答案</b></summary>
<p>

#### 答案：c b c

解析：此题考察对象的键名的转换

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

// 不确定参数的情况
// add(1)(2)(3) => 6
// add(1,2)(3)(4) => 10
const curry2 = () => {
  let params = []
  const add = (...args) => {
    params = params.concat(args)
    return add
  }
  add[Symbol.toPrimitive] = function () {
    return params.reduce((res, item) => res + item)
  }
  return add
}
let add = curry2()
console.log(+add(1, 2)(3)(4)) // 10
add = curry2()
console.log(+add(1, 2)(3)(4)(5)) // 15
  ```
</p>
</details>

---
###### 6.以下输出结果是什么？

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

#### 答案： 2 4 1 1 2 3 3

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

#### 答案：  0 0 2 3

解析：考察react中setState的原理。
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

###### 22.以下输出是什么？
```javascript
let person = { name: 'Lydia' };
const members = [person];
person = null;

console.log(members);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：[{ name: "Lydia" }]

解析：变量person指向对象，对象在设置彼此相等时通过引用进行交互，当您将一个变量的引用分配给另一个变量时，您制作了该引用的副本。当person重新赋值为null，不会影响之前的数组的引用。
   
</p>
</details>

---

###### 23.以下输出什么？
```javascript
function greeting() {
  throw 'Hello world!';
}

function sayHi() {
  try {
    const data = greeting();
    console.log('It worked!', data);
  } catch (e) {
    console.log('Oh no an error:', e);
  }
}

sayHi();
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：Oh no an error: Hello world!

解析：异常可以是字符串、数字、布尔值或对象。
   
</p>
</details>

---

###### 24.以下输出是什么？
```javascript
// counter.js
let counter = 10;
export default counter;
```
```javascript
// index.js
import myCounter from './counter';

myCounter += 1;

console.log(myCounter);
```

<details><summary><b>答案</b></summary>
<p>

#### 答案：Error

解析：导入的模块是只读的：您不能修改导入的模块。当我们尝试增加 myCounter 的值时，它会抛出一个错误：myCounter 是只读的，无法修改。
   
</p>
</details>

---

###### 25.以下输出的是什么？
```javascript
const name = 'Lydia';
age = 21;

console.log(delete name);
console.log(delete age);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：false, true

解析：删除操作符返回一个布尔值：成功删除时为 true，否则返回 false。但是，使用 var、const 或 let 关键字声明的变量不能使用 delete 运算符删除。
name由const声明，返回false，但age则是添加到window对象上，作为window对象的一个属性，能删除成功。
   
</p>
</details>

---

###### 26.以下的输出是什么？
```javascript
const settings = {
  username: 'lydiahallie',
  level: 19,
  health: 90,
};

const data = JSON.stringify(settings, ['level', 'health']);
console.log(data);

```
<details><summary><b>答案</b></summary>
<p>

#### 答案："{"level":19, "health":90}"

解析：
- JSON.stringify 的第二个参数是替换器。替换器可以是一个函数或一个数组，并允许您控制应该对值进行字符串化的内容和方式。
- 如果替换器是一个数组，那么只有包含在数组中的属性名称会被添加到 JSON 字符串中。
- 如果替换器是一个函数，则在您要字符串化的对象中的每个属性上都会调用此函数。此函数返回的值将是属性添加到 JSON 字符串时的值。
   
</p>
</details>

---

###### 27.以下输出是什么？
```javascript
// index.js
console.log('running index.js');
import { sum } from './sum.js';
console.log(sum(1, 2));

// sum.js
console.log('running sum.js');
export const sum = (a, b) => a + b;
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：running sum.js, running index.js, 3

解析：
- 使用 import 关键字，所有导入的模块都被预先解析。
- 这是 CommonJS 中的 require() 和 import 的区别！使用 require()，你可以在代码运行时按需加载依赖。
- 使用require，你能得到你以为的答案。
</p>
</details>

---

###### 28.以下输出是什么？
```javascript
function foo() {
  return 'Here is pizza!';
}

const bar = () =>
  "Here's chocolate... now go hit the gym already.";

console.log(foo.prototype);
console.log(bar.prototype);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{ constructor: ...} undefined

解析：
- 普通函数如foo，都存在prototype属性，它是一个拥有constructor属性的一个对象
- 箭头函数bar，不存在prototype属性的，访问将会得到undefined
</p>
</details>

---

###### 29.以下输出是什么？
```javascript
const info = {
  [Symbol('a')]: 'b',
};

console.log(info);
console.log(Object.keys(info));
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{ constructor: ...} undefined

解析：考察symbol作为键值
- symbol作为键值是不可枚举的，Object.keys将返回[]
- 打印整个对象时，所有的属性都是可见的，即使是不可枚举的属性
</p>
</details>

---

###### 30.以下输出是什么？
```javascript
const getList = ([x, ...y]) => [x, y]
const getUser = user => { name: user.name, age: user.age }

const list = [1, 2, 3, 4]
const user = { name: "Lydia", age: 21 }

console.log(getList(list))
console.log(getUser(user))
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{ constructor: ...} undefined

解析：考察展开运算符与箭头函数中返回对象
- 展开运算符中，对应x=1，y=[2,3,4],所有返回[1,[2,3,4]]
- 而箭头函数中返回一个对象时，只有一条语句返回，则需要使用括号进行包裹。
  即const getUser = user => ({ name: user.name, age: user.age })
</p>
</details>

---

###### 31.以下输出是什么？
```javascript
const name = 'Lydia';

console.log(name());
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{ constructor: ...} undefined

解析：TypeError
- 变量名保存一个字符串的值，它不是一个函数，因此不能调用
- 当值不是预期的类型时，会抛出 TypeErrors。 JavaScript 期望 name 是一个函数，因为我们试图调用它
- 当你编写了无效的 JavaScrip 内容时，会抛出 SyntaxErrors
- 当 JavaScript 无法找到对您尝试访问的值的引用时，会引发 ReferenceErrors
</p>
</details>

---

###### 32.以下输出是什么？
```javascript
const colorConfig = {
  red: true,
  blue: false,
  green: true,
  black: true,
  yellow: false,
};

const colors = ['pink', 'red', 'blue'];

console.log(colorConfig.colors[1]);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：TypeError
</p>
</details>

---

###### 33.这个方法是的作用是?
```javascript
JSON.parse();
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：Parses JSON to a JavaScript value
```txt
JSON string to a JavaScript value:
const jsonNumber = JSON.stringify(4); // '4'
JSON.parse(jsonNumber); // 4

const jsonArray = JSON.stringify([1, 2, 3]); // '[1, 2, 3]'
JSON.parse(jsonArray); // [1, 2, 3]

const jsonArray = JSON.stringify({ name: 'Lydia' }); // '{"name":"Lydia"}'
JSON.parse(jsonArray); // { name: 'Lydia' }
```
</p>
</details>

---

###### 34.以下的输出是什么?
```javascript
let name = 'Lydia';

function getName() {
  console.log(name);
  let name = 'Sarah';
}

getName();
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：ReferenceError
- 每个函数都有自己的执行上下文（或作用域），当访问name变量，由于自身存在name变量，但是用let声明，会形成暂时性死区，引发ReferenceError
</p>
</details>

---

###### 35.以下输出是什么？
```javascript
const name = 'Lydia Hallie';
const age = 21;

console.log(Number.isNaN(name));
console.log(Number.isNaN(age));

console.log(isNaN(name));
console.log(isNaN(age));
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：false false true false
- 使用Number.isNaN方法，你可以检查你传递的值是否为数值并且等于NaN
- 使用isNaN方法，你可以检查你传递的值是否不是数字
</p>
</details>

---

###### 36.以下输出是什么？
```javascript
const randomValue = 21;

function getInfo() {
  console.log(typeof randomValue);
  const randomValue = 'Lydia Hallie';
}

getInfo();
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：false false true false
- 用 const 关键字声明的变量在初始化之前是不可引用的
- 在未初始化之前引用会报引用错误
</p>
</details>

---

###### 37.以下输出是什么？
```javascript
const person = { name: 'Lydia Hallie' };

Object.seal(person);

person.name = "Evan Bacon"

console.log(person)
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：{ name: 'Evan Bacon' }
- 使用 Object.seal，我们可以防止添加新属性或删除现有属性,但是，您仍然可以修改现有属性的值
</p>
</details>

---

###### 38.以下输出是什么？
```javascript
let randomValue = { name: "Lydia" }
randomValue = 23

if (!typeof randomValue === "string") {
	console.log("It's not a string!")
} else {
	console.log("Yay it's a string!")
}
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：Yay it's a string!
- !typeof randomValue === "string" 会先计算typeof randomValue 为'number' string，取非之后为false，与string比较总是返回false，所以走else语句
</p>
</details>

---

###### 39. 当a为何值时，能打印出xxx?
```js
var a = ?
if (a == 1 && a == 2 && a == 3) {
  console.log('xxx')
}
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：见下
解析：考察js中的隐式类型转换。

引用类型转换原始值的步骤
- 先调用对象的Symbol.toPrimitive方法，如果不存在这个
- 再调用valueOf方法 如果该方法返回一个原始值那么就用此原始值
- 否则，调用toString方法，返回字符串表示
  
**答案1**
```js
const a = {
  value: 1,
  valueOf() {
    return this.value++
  },
 }
```

**答案2**
```js
const a = [1,2,3]
a.toString = a.shift
```

</p>
</details>

---

###### 40. 如何实现 x === x + 1？
<details><summary><b>答案</b></summary>
<p>

#### 答案：Number.MAX_SAFE_INTEGER + 1
```js
const x = Number.MAX_SAFE_INTEGER + 1 
console.log(x === x + 1) // true
```
</p>
</details>

---

###### 41. 下面代码输出为？
```js
function foo(a, b = 1, c) {
  console.log(foo.length)
}

foo(1,2,3)
```

<details><summary><b>答案</b></summary>
<p>

#### 答案：1
解析：函数长度属性及存在默认参数
- es6引入了默认参数。此前，函数length属性用于返回所有函数参数编号
- 默认参数的引入，length属性发生了变化，带默认值的参数是可选的，所以这样的参数不计入length中
- 默认参数后面的参数也是可选，后面的也不会计入长度属性计算中
</p>
</details>

---

###### 42. 以下代码输出？
```js

const obj = {};

Object.defineProperty(obj, 'count', {
 value: '100'
});

console.log(obj.count);
delete obj.count;
console.log(obj.count);
```

<details><summary><b>答案</b></summary>
<p>

#### 答案：100 100
解析：Object.defineProperty 方法及其默认参数
- 语法格式：Object.defineProperty(obj, prop, descriptors)
- descriptors属性描述符
  + 数据描述符 （值 可写 可枚举 可配置）默认情况，不可写 不可枚举 不可配置 可配置属性指定是否可以从对象中删除属性，以及将来是否可以更改属性描述符。题目中由于默认为false 将会别忽略，严格模式下 将会报错
  + 访问描述符 （get set方法）
</p>
</details>

---

###### 43. 以下代码输出？
```js

function Foo() {
 this.flag = true;
}

const foo = new Foo();
const bar = Object.create(foo);

const clone1 = { ...bar };
const clone2 = Object.assign({}, bar);

console.log(bar.flag, clone1.flag, clone2.flag);
```

<details><summary><b>答案</b></summary>
<p>

#### 答案：true undefined undefined
解析：Object.create 和 Object.assign 克隆对象
- 语法：Object.create(proto[,propertiesObject]) 创建一个新对象 并以proto作为原型 propertiesObject对新创建的对象进行初始化 
- admin本身是没有flag属性 访问时找到其原型对象上的属性
- 通过展开符与Object.assign()克隆会忽略其原型
  
**他们原型为**
```js
admin.__proto__ Foo { flag: true },
clone1.__proto__ [Object: null prototype] {},
clone2.__proto__ [Object: null prototype] {}
```
**克隆包含其原型**
```js
const clone1 = { __proto__: Object.getPrototypeOf(obj), ...obj };
const clone2 = Object.assign(Object.create(Object.getPrototypeOf(obj)), obj);
```
</p>
</details>

---

###### 44. 以下代码输出？
```js
const str = 'string';
const str2 = String('string');

console.log(str instanceof String);
console.log(str2 instanceof String);
```

<details><summary><b>答案</b></summary>
<p>

#### 答案：false false
解析：字符串函数和 instanceof 运算符
- instanceof 运算符仅适用于对象
- 字符串文字'string'是原始的
- 非构造函数上下文中的字符串调用（不使用 new 关键字调用）返回一个原始字符串
</p>
</details>

---

###### 45. 以下代码输出？
```js
var a = {n:1};
var b = a;
a.x = a = {n:2};
console.log(a.x);
console.log(b.x);
```
<details><summary><b>答案</b></summary>
<p>

#### 答案：
undefined
{n:2}

解析：
- 连续=号赋值从右到左
- .号优先级高于=号赋值
</p>
</details>

---