```go
//////////////////////       

/* 在macOS或Linux上编译并运行hello.go */
$ cd try_go //切换到保存hello.go的目录
$ go fmt hello.go //格式化代码
$ go build hello.go //编译代码
$ ./hello //运行可执行文件

/* 在Windows上编译并运行hello.go */
> cd try_go //切换到保存hello.go的目录
> go fmt hello.go //格式化代码
> go build hello.go //编译代码
> hello.exe //运行可执行文件

// go build 将源代码文件编译成二进制文件
// go run 编译并运行程序，不保存可执行文件
// go fmt 使用Go标准格式重新格式化源文件
// go version 显示当前Go版本号
// go doc 包名 函数名 显示go文档信息

// go build命令将代码编译成可执行文件，这样的可执行文件可以分发给用户，即使用户没有安装Go，也可以运行它们



//////////////////////   goroutine和channel
/*
	一些大问题可以分解成一系列的小任务，goroutine可以让程序同时处理几个不同的任务，不同的goroutine之间可以使用channel
	来协调它们的工作，channel允许goroutine互相发送数据并同步，这样一个goroutine就不会领先于另一个gorouine。goroutine
	可以充分利用多核处理器，尽快地完成相应的任务。
*/

func abc(channel chan string) {
	channel <- "a"
	channel <- "b"
	channel <- "c"
}

func def(channel chan string) {
	channel <- "d"
	channel <- "e"
	channel <- "f"
}

func main() {
	//创建两个channel
	channel1 := make(chan string)
	channel2 := make(chan string)

	//将每个channel传递给新goroutine中运行的函数
	go abc(channel1)
	go def(channel2)

	//按顺序从channel接收和打印值
	fmt.Print(<-channel1)
	fmt.Print(<-channel2)
	fmt.Print(<-channel1)
	fmt.Print(<-channel2)
	fmt.Print(<-channel1)
	fmt.Print(<-channel2)
	fmt.Println()         

	//输出结果adbecf
	//abc goroutine每次向channel发送一个值时都会阻塞，直到main gorouine接收到它为止，def gorouine也是如此。
	//main gorouine成为abc goroutine和def gorouine的协调器，只有当它准备读取它们发送的值时，才允许它们继续。
}

package main

import "fmt"

func odd(channel chan int) {
	channel <- 1
	channel <- 3
}

func even(channel chan int) {
	channel <- 2
	channel <- 4
}


func main() {
	channelA := make(chan int)
	channelB := nake(chan int)

	go odd(channelA)
	go even(channelB)

	fmt.Println(<-channelA) // 1
	fmt.Println(<-channelA) // 3
	fmt.Println(<-channelB) // 2
	fmt.Println(<-channelB) // 4
}

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

//声明一个struct类型
type Page struct {
	URL string
	Size int
}

func responseSize(url string, channel chan Page) {
	fmt.Println("Getting", url)
	response, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	}
	defer response.Body.Close()
	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Fatal(err)
	}
	//返回一个包含当前URL和页面大小的Page
	channel <- Page{URL: url, Size: len(body)}
}


func main() {
	pages := make(chan Page)
	//将url移动到一个切片中
	urls := []string{"https://example.com", "https:://golang.org", "https://golang.org/doc"}
	//对每个url嗲用responseSize
	for _, url := range urls {
		//将channel传递给responseSize
		go responseSize(url, pages)
	}
	//对每一个responseSize发送，都从channel接收一次
	for i := 0; i < len(urls); ++i {
		//接收Page
		page := <- pages
		fmt.Printf("%s: %d\n", page.URL, page.Size)
	}
}

/*
	goroutine是同步运行的函数，新的goroutine以一个go语句开始：一个普通的函数调用，前面是"go"关键字；
	channel是用于在goroutine之间发送值的数据结构，默认情况下，在channel上发送一个值会阻塞当前goroutine，
	直到该值被接收为止。试图接收一个值也会阻塞当前的gorouine，直到值被发送至相应的channel为止。
*/

//所有Go程序都至少有一个goroutine，程序启动时调用main函数的goroutine。
//Go程序在mian goroutine停止时结束，即使其他的goroutine尚未完成其工作。
//time.Sleep函数将当前的goroutine暂停一段时间。
//Go不保证何时在goroutine之间切换，或者它持续运行一个goroutine多长时间。这允许goroutine更高效地运行，但这意味着你不能指望按特定的顺序执行操作。
//函数返回值不能在go语句中使用，部分原因是当调用函数试图使用它时，返回值还没有准备好。
//如果需要goroutine中的值，则需要将其传递给一个channel，以便其他的goroutine从此channel中接收该值。
//channel是通过调用内置的make函数创建的。
//每个channel只携带一种特定类型的值，在创建channel时指定该类型。


//计算机的浮点数运算总是有几万亿分之一的偏差。
fmt.Printf("About one-third: %0.2f\n", 1.0/3.0)

resultString := fmt.Sprintf("About one-third: %0.2f\n", 1.0/3.0)
fmt.Printf(resultString)

%f 浮点数
%d 十进制数
%s 字符串
%t 布尔值 true or false
%v 任何值，根据所提供的值的类型选择适当的格式 -> fmt.Printf("%v %v %v", "", "\t", "\n") -> 没有任何显式输出
%#v 任何值，按其在Go代码中显示的格式进行格式化 -> fmt.Printf("%#v %#v %#v", "", "\t", "\n") -> "" "\t" "\n"
%T 所提供值的类型(int,string等)
%% 一个完完全全的百分号

//错误信息
guess, err := strconv.Atoi(input) //输出的字符串转换为整数
if err != nil {
	log.Fatal(err)
}


//创建错误值
package main

import (
	"errors"
	"fmt"
)

func main() {
	err := errors.New("height can't be negative")
	fmt.Println(err.Error()) //打印错误信息
	log.Fatal(err) //打印错误信息，然后退出程序
	err := fmt.Errorf("a height of %0.2f is invalid", -2.33333) //定义带打印参数的错误信息
	fmt.Println(err.Error())
	fmt.Println(err) //打印错误信息
}

package main

import "fmt"

func paintNeeded(width float64, height float64) (float64, error) {
	if width < 0 {
		return 0, fmt.Errorf("a width of %0.2f is invalid", width)
	}
	if height < 0 {
		return 0, fmt.Errorf("a height of %0.2f is invalid", height)
	}
	area := width * height
	return area / 10.0, nil
}

func main() {
	amount, err := paintNeeded(4.2, -3.0)
	if err != nil {
		fmt.Println(err)
		//log.Fatal(err)
	} else {
		fmt.Printf("%0.2f liters needed\n", amount)
	}	
}

//与其他语言不同，在Go中，返回一个指向函数局部变量的指针是可以的，即使该变量不在作用域内，只要你仍然拥有指针，Go将确保你仍然可以访问该值。

func main() {
	amount := 6
	double(amount)
	fmt.Println(amount) //打印原始值
}

func double(number int) { //形参为实参的副本
	number *= 2 //改变副本值
}

func main() {
	amount := 6
	double(&amount)
	fmt.Println(amount) //打印改变的值
}

func double(number *int)
{
	*number *= 2 //更新指针处的值
}

//%12s的结果是一个12个字符的字符串(用空格填充),%2d的结果是一个2个字符的整数，%7.3的结果是，包括小数点在内,7位数字，其中保留3位小数
//当函数返回多个值时，最后一个值通常具有一个error类型，错误值有一个Error()方法，该方法返回描述错误的字符串。
//按照惯例，函数返回一个错误值nil，表示没有错误。
//如果函数接收一个指针作为参数，并更新该指针处的值，那么更新后的值在函数外部仍然可见。

package main

import (
	"greeting" //导入"greeting"包
	"greeting/deutsch" //导入"deutsh"包，两个包各自包含自己直接目录下的文件内容
)

func main() {
	greeting.Hello()
	greeting.Hi()
	deutsch.Hallo()
	deutsh.GutenTag()
}

/*
	go run -> Go必须编译程序及它所依赖的所有包，然后才能执行，当编译完成后，丢弃编译后的代码。
	go build -> 该命令进行编译并把可执行二进制文件(即使没有安装Go也可以执行的文件)保存在当前目录中。
	go install -> 保存编译后的可执行程序的二进制版本(Windows中为文件夹名称.exe)，保存在Go工作区中的bin目录。需要指定包含以package main开头的.go文件所在的文件夹(命名相关)，可执行文件保存在这个文件夹中。
	在哪个目录执行go install并不重要，Go工具将在src目录中查找该目录。bin目录如果不存在，会自动创建它。

	设置GOPATH：如果你的代码存储在默认目录之外的目录中，可以使用export命令设置环境变量，配置go工具以到正确的位置进行查找。(只在当前的终端起作用)
	Mac或者Linux：export GOPATH="/code"
	Windows: set GOPATH="C:\code"
*/

package main

import (
	"fmt"
	"github.com/headfirstgo/keyboard" //更新导入路径，防止路径重复冲突
	"log"
)

go工具有一个名为go get的子命令，可以自动下载和安装包。
go get github.com/headfirstgo/greeting，go工具将连接到github.com，在/headfirstgo/greeting路径下载Git存储库，并将其保存在Go工作区的src目录中

可以使用go doc命令来显示关于任何包或函数的文档。
go doc strconv -> 输出包括包名和导入路径、包的整体描述及包输出的所有函数的列表。
go doc strconv ParseFloat 获取包中函数的详细信息，包括函数名，参数，返回值及函数描述。

直接出现在package子句或者函数声明之前的普通Go注释被视为文档注释，将显示在go doc的输出中。

//Package keyboard reads user input from the keyboard.
package keyboard
...

//GetFloat reads a floating-point number from the keyboard. It returns the number read and any error encountered.
func GetFloat() (float64, error) {
	...
}

$ go doc github.com/headfirstgo/keyboard -> 包描述
$ go doc github.com/headfirstgo/keyboard GetFloat -> 函数描述

*注释应该是完整的句子
*包注释应以Package开头，后跟报名
//Package mypackage enables widget management.
*函数注释应以它们描述的函数的名称开头
//MyFunction converts widgets to gizmos.
*可以通过缩进在注释中包含代码示例

使用搜索引擎查看文档 -> golang 包名称 -> https://golang.org/pkg/fmt/

查看本地安装包：
$ godoc -http=:6060
http://localhost:6060/pkg
ctrl + c 退出

默认情况下，工作区目录是用户主目录中名为go的目录。
通过设置GOPATH环境变量，可以使用另一个目录作为工作区。
Go在工作区中使用三个子目录：bin目录用于保存编译过的可执行文件，pkg目录保存编译过的包代码，src目录保存Go源代码
包名由包目录中源代码文件顶部的package子句确定，除了main包之外，包名应该与包含它的目录名相同。

数组保存特定数量的元素，不能增长或收缩。
var notes [7]string //创建一个由7个字符串组成的数组
notes[0] = "do" 
notes[1] = "re"
notes[2] = "mi"
fmt.Println(notes[0])

var primes [5]int
primes[0] = 2
primes[1] = 3
fmt.Println(primes[0])

var dates [3]time.Time //创建一个由3个Time值组成的数组
dates[0] = time.Unix(1257894000, 0)
dates[1] = time.Unix(1447920000, 0)
dates[2] = time.Unix(1508632200, 0)
fmt.Println(dates[1])

数组中，int的默认值为0，字符串的默认值是空字符串，创建数组时，它所包含的所有值都初始化为数组所保存类型的零值。

var notes [7]string = [7]string{"do","re","mi","fa","so","la","ti"}
notes := [7]string{"do","re","mi","fa","so","la","ti"}

var primes [5]int = [5]int{2, 3, 5, 7, 11}
primes := [5]int{2, 3, 5, 7, 11}

//字面量初始化，多行方式，注意最后一个初始化元素之后的逗号
text := [3]string{
	"a",
	"b",
	"c",
}

fmt包可以自动处理数组
var notes [3]string = [3]string{"do", "re", "mi"}
var primes [5]int = [5]int{2, 3, 5, 7, 11}
fmt.Println(notes) -> [do re mi]
fmt.Println(primes) -> [2 3 5 7 11]

#打印Go数组字面量
fmt.Printf("%#v\n", notes) -> [3]string{"do", "re", "mi"}
fmt.Printf("%#v\n", primes) -> [5]int{2, 3, 5, 7, 11}

数组包含特定数量的元素，试图访问数组外的索引会导致panic，这是在程序运行时(而不是编译时)发生的错误。
通常，panic会导致程序崩溃并向用户显示错误信息。 -> panic: runtime error: index out of range

len(数组名称) -> 返回数组的长度

notes := [7]string{"do","re","mi","fa","so","la","ti"}
for index, note := range notes {
	fmt.Println(index, note)
}

for _, note := range notes {
	fmt.Println(note)
}

for index, _ := range notes {
	fmt.Println(index)
}

工作区 > src > github.com > headfirstgo > average > main.go 
go install github.com/headfirstgo/average 
可以在任何目录中执行，go工具将在工作区的src目录中，查找github.com/headfirstgo/average目录，
并编译其中包含的任何.go文件。生成的可执行文件将被命名为average，并保存在Go工作区的bin目录中。

numbers := [3]float64{71.8, 56.2, 89.5}
var sum float64 = 0
for _, number := range numbers {
	sum += number
}
sampleCount := float64(len(numbers)) //int -> float64
fmt.Printf("Average: %0.2f\n", sum / sampleCount)


//读取文本文件
data.txt 
71.8
56.2
89.5
只需要用go run运行readfile.go，并不是安装它，因此可以将其保存在Go工作区目录之外。
package main 

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("data.txt") //打开数据文件进行读取 -> 返回被打开文件的os.File指针
	if err != nil { //如果打开文件时出现错误，报告错误并退出
		log.Fatal(err)
	}

	scanner := bufio.NewScanner(file) //为文件创建一个新的扫描器
	for scanner.Scan() { //从文件中读取一行，循环到文件结尾，scanner.Scan返回false
		fmt.Println(scanner.Text()) //打印该行
	}

	err = file.Close() //关闭文件以释放资源
	if err != nil { //如果关闭文件时出现错误，报告错误并退出
		log.Fatal(err)
	}

	if scanner.Err() != nil { //如果扫描文件时出现错误，报告错误并退出
		log.Fatal(scanner.Err())
	}
}

> 工作区 > src > github.com > headfirstgo > datafile > floats.go
// Package datafile allows reading data samples from files.
package datafile

import (
	"bufio"
	"os"
	"strconv"
)

// GetFloats reads a float64 from each line of a file.
func GetFloats(fileName string) ([3]float64, error) {
	var numbers [3]float64
	file, err := os.Open(fileName)
	if err != nil {
		return numbers, err
	}

	i := 0 
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		numbers[i], err = strconv.ParseFloat(scanner.Text(), 64)
		if err != nil {
			return numbers, err
		}
		i++ 
	}
	err = file.Close()
	if err != nil {
		return numbers, err 
	}
	if scanner.Err() != nil {
		return numbers, scanner.Err()
	}
	return numbers, nil
}

与数组相同的是，切片由多个相同类型的元素构成，不同的是，切片允许我们在结尾追加更多的元素。
var notes []string //声明一个切片变量
notes = make([]string, 7) //创建7个字符串的切片

-> 上面两步简化为一步
primes := make([]int, 5)
fmt.Println(len(primes))
primes[0] = 2
primes[1] = 3
fmt.Println(primes[0])

letters := []string{"a", "b", "c"}
for i := 0; i < len(letters); ++i {
	fmt.Println(letters[i])
}
for _, letter := range letters {
	fmt.Println(letter)
}

notes := []string{"do", "re", "mi", "fa", "so", "la", "ti"} //使用一个切片字面量赋值
fmt.Println(notes[3], notes[6], notes[0])
primes := []int { //一个多行的切片字面量
	2,
	3,
	5,
}
fmt.Println(primes[0], primes[1], primes[2])

underlyingArray := [5]string{"a", "b", "c", "d", "e"}
i, j := 1, 4 //j的最大值为5，如果设置为6->invalid slice index 6 (out of bounds for 5-element array)
slice2 := underlyingArray[i:j] // [:j] [i:]
fmt.Println(slice2) // [b c d]

//修改底层数组，切片也会发生变化，反之亦然
array1 := [5]string{"a", "b", "c", "d", "e"}
slice1 := array[0:3]
array1[1] = "X"
fmt.Println(array1) //[a X c d e]
fmt.Println(slice1) //[a X c]

//通常使用make和切片字面量来创建切片，而不是创建一个数组，再用一个切片在上面操作，这样就不用关心底层数组了，每次创建一个新的数组

调用append函数，惯例是将函数的返回值赋给传入的那个切片变量
slice := []string{"a", "b"}
fmt.Println(slice, len(slice))
slice = append(slice, "c")
fmt.Println(slice, len(slice))
slice = append(slice, "d", "e")
fmt.Println(slice, len(slice))

floatSlice := make([]float64, 10) //创建元素没有赋初值的切片
boolSlice := make([]bool, 10) 
fmt.Println(floatSlice[9], boolSlice[5]) // 0 false

var slice []string //变量值是nil
if len(slice) == 0 { //len函数返回0
	slice = append(slice, "first item") 
}
fmt.Println("%#v\n", slice) //[]string{"first item"

func GetFloats(fileName string) ([]float64, error) { //返回一个切片
	var numbers []float64 //变量默认为nil，append处理nil的行为和处理空切片的行为相同
	number, err := strconv.ParseFloat(scanner.Text(), 64) //将string转换为float64并且赋值给一个临时变量
	numbers = append(numbers, number) //可以不断追加新的数字给切片

	if err != nil {
		return nil, err //返回nil而不是切片，切片在此处也是nil，这样返回更加明晰
	}
}

numbers, err := datafile.GetFloats("data.txt") //返回切片
for _, number := range numbers { //对数组和切片的操作一样
	sum += number
}

//可变长参数
 func serveralInts(numbers ...int)
 {
 	fmt.Println(numbers)
 }

 func main() {
 	serveralInts(1) // [1]
 	serveralInts(1, 2, 3) // [1 2 3]
 	serveralInts() // 如果没有参数，会收到一个空的切片 []
 }

 //仅仅函数定义中的最后一个参数可以是可变长参数，不能把它放到必需参数之前
 func mix(num int, flag bool, strings ...string)
 {
 	fmt.Println(num, flag, strings)
 }

 func main() {
 	mix(1, true, "a", "b")
 	mix(2, false, "a", "b", "c", "d")
 }

 package main 

 import "fmt"

 func average(numbers ...float64) float64 {
 	var sum float64 = 0
 	for _, number := range numbers {
 		sum += number 
 	}
 	return sum / float64(len(numbers))
 }

 func main() {
 	fmt.Println(average(100, 50))
 	fmt.Println(average(90.7, 89.7, 98.5, 92.3))
 }

func main() {
	arguments := os.Args[1:]
	var numbers []float64
	for _, argument := range arguments {
		number, err := strconv.ParseFloat(argument, 64)
		if err != nil {
			log.Fatal(err)
		}
		numbers = append(numbers, number)
	}
	fmt.Printf("Average: %0.2f\n", average(numbers...)) //向可变参数函数传入切片
}

os.Args包变量包含当前程序执行的命令行参数组成的string类型的切片；
为了声明一个变长参数函数，在最后一个参数之前增加省略号...，这个参数就可以以切片的形式接收一组参数；
当调用可变参数函数的时候，可以通过在切片之后追加省略号的方式来代替变长参数；


//映射：
var ranks map[string]int //声明一个映射变量
ranks = make(map[string]int) //真正创建一个映射

//或者简写为：
ranks := make(map[string]int) //创建一个映射并声明一个保存它的变量

ranks["gold"] = 1
ranks["silver"] = 2
ranks["bronze"] = 3
fmt.Println(ranks["bronze"])
fmt.Println(ranks["gold"])

整数和切片仅允许使用整型作为索引，但是几乎可以使用任意类型作为映射的键和值。

//映射字面量
myMap := map[string]float64{"a":1.2, "b":5.6}
//多行映射字面量
elements := map[string]string{
	"H" : "Hydrogen",
	"li": "Lithium",
}
//一个空的映射
emptyMap := map[string]float64{}
//映射中的零值
numbers := make(map[string]int)
fmt.Printf("%#v\n", numbers["I haven't been assigned"]) // 0
words := make(map[string]string)
fmt.Printf("%#v\n", words["I haven't been assigned"]) // ""

counters := make(map[string]int)
counters["a"]++
counters["b"]++
fmt.Println(counters["a"], counters["b"], counters["c"]) //1 1 0

counters := map[string]int{"a" : 3, "b" : 0}
var value int 
var ok bool 
value, ok = counters["a"]
_, ok = counters["a"]
fmt.Println(value, ok) //访问一个已经赋值过的值，ok返回true
value, ok = counters["c"]
fmt.Println(value,ok) //访问一个未赋值的值，ok返回false


//使用delete函数删除键值对
ranks := make(map[string]int)
delete(ranks, "bronze") //删除键bronze和相关的值

grades := map[string]float64{"Alma":74.2, "Rohit":86.5, "Carl":59.7}
for name, grade := range grades { //循环键和值
}
for name := range grades { //循环键
}
for _, grade := range grades { //循环值
}

grades := map[string]float64{"Alma":74.2, "Rohit":86.5, "Carl":59.7}
var names []string
for name := range grades {
	names = append(names, name)
}
sort.Strings(names)
for _, name := range names {
	fmt.Printf("%s has a grade of %0.1f\n", name, grades[name])
}

package main 

import (
	"fmt"
	"github.com/headfirstgo/datafile"
	"log"
)

func main() {
	lines, err = datafile.GetStrings("votes.txt")
	if err != nil {
		log.Fatal(err)
	}

	counts := make(map[string]int)
	for _,line : range lines {
		counts[line]++
	}
	for name, count := range counts {
		fmt.Printf("Votes for %s : %d\n", name, count)
	}
}

//切片和映射保存一种类型的值
//struct是由多种类型的值构建的
var myStruct struct {
	number float64
	word string
	toggle bool 
}

fmt.Printf("%#v\n", myStruct) // struct {number float64, word string; toggle bool} {number:0, word:"", toggle:false}
myStruct.number = 3.14
fmt.Println(myStruct.number)

//定义类型
package main 

import "fmt"

type part struct { //定义一个名为part的类型
	description string 
	count int 
}

type car struct { //定义一个名为car的类型
	name string 
	topSpeed float64
}

function main() {
	var porsche car 
	porsche.name = "911 R"
	porsche.topSpeed = 323
}

package main 

import "fmt"

type part struct {
	description string 
	count int 
}

func showInfo(p part) {
	fmt.Println("Description:", p.description)
	fmt.Println("Count:", p.count)
}

func main() {
	var bolts part 
	bolts.description = "Hex"
	bolts.count = 24 
	showIfo(bolts)
}

func minimumOrder(description string) part {
	var p part 
	p.description = description 
	p.count = 100 
	retrurn p
}

func main() {
	p := minimumOrder("hex");
	fmt.Println(p.description, p.count)
} 


//传递引用 vs 传递指针
func main() {
	amount := 6 
	double(&amount)
	fmt.Println(amount)
}

func double(number *int) {
	*number *= 2
}

package main 

import "fmt"

type subscriber struct {
	name string 
	rate float64 
	active bool 
}

func applyDiscount(s *subscriber) {
	s.rate = 4.99
}

func main() {
	var s subscriber 
	applyDiscount(&s)
	fmt.Println(s.rate) //4.99
}
//使用点运算符在struct指针和struct上都可访问字段

//通过指针访问struct的字段
func main() {
	var value int = 2 //创建一个值
	var point *int = &value //创建一个指向该值的指针
	fmt.Println(pointer) //打印指针指向的地址
	fmt.Println(*pointer) // 2
}

type mystruct struct {
	myField int 
}

func main() {
	var value myStruct 
	value.myField = 3 
	var pointer *myStruct = &value 
	fmt.Println((*pointer).myField) //注意括号的使用 3
	pointer.myField = 9 //通过指针赋值struct的字段
	fmt.Println(pointer.myField) //和上面等效
}

//传递指针，避免拷贝
type subscriber struct {
	name string 
	rate float64 
	active bool 
}

func printInfo(s *subscriber) {
	fmt.Println(s.name)
	fmt.Println(s.rate)
	fmt.Println(s.active)
}

func defaultSubscriber(name string) *subscriber {
	var s subscriber 
	s.name = name 
	s.rate = 5.99 
	s.acitve = true 
	return &s
}

func applyDiscount(s *subscriber) {
	s.rate = 4.99
}

func main() {
	subscriber1 = defaultSubscriber("Aman")
	applyDiscount(subscriber1)
	printInfo(subscriber1)
}

Go类型名称与变量和函数名称遵循相同的规则：如果变量、函数或者类型以大写字母开头，它就会被认为是导出的，
并且可以从外部包访问。即使一个struct类型被从包中导出，如果它的字段名称没有首字母大写，它的字段也不会被导出。
package magazine 

type Subscriber struct {
	Name String 
	Rate float64 
	Active bool 
}

struct字面量 
subscriber := magazine.Subscriber{Name: "Aman", Rate: 4.99, Active: true}
subscriber1 := magazine.Subscriber{Rate:4.99} //忽略其余字段，被忽略的字段设置为各自类型的零值

在struct字段列表中增加一个类型，没有名字，定义了一个匿名字段。使用匿名字段的方式将内部struct增加到外部struct，被称为嵌入了外部struct。你可以
像访问外部字段一样访问嵌入的struct字段。

package magazine 

type Subscriber struct {
	Name string 
	Rate float64 
	Active bool 
	Address
}

type Address struct {
	...
}

subscriber := magazine.Subscriber{Name: "Aman"}
subscriber.Address.Street = "123 st"
//也可
subscriber.Street = "123 Oak St"


package main 

import "fmt"

type Liters float64  //定义两个新类型，基础类型都是float64
type Gallons float64 

func main() {
	var carFuel Gallons 
	var busFuel Liters 
	carFuel = Gallons(10.0)
	busFuel = Liters(240.0)

	carFuel = Liters(240.0) //错误

	carFuel := Gallons(10.0)
	busFuel := Liters(240.0)


	fmt.Println(Liters(1.2) + 3.4) //定义类型可与字面值一起运算
	fmt.Println(Gallons(5.5) - 2.2)
	fmt.Println(Gallons(1.2) == 1.2) //true
	fmt.Println(Liters(1.2) < 3.4) //true

	fmt.Println(Liters(1.2) + Gallons(3.4)) //错误，需要先转换类型

}

*************Go语言不支持重载

func ToGallons(l Liters) Gallons {
	return Gallons(l * 0.264)
}

func ToLiters(g Gallons) Liters {
	return Liters(g * 3.785)
}

func main() {
	carFuel := Gallons(1.2)
	busFuel := Liters(4.5)
	carFuel += ToGallons(Liters(40.0))
	busFuel += ToLiters(Gallons(30.0))
}

//方法的定义与函数定义很像，事实上，它们只有一点不同，你需要增加一个额外的参数，一个接收器参数，在函数名称之前的括号中：
package main 

import "fmt"

type MyType string 

func (m MyType) sayHi() {
	fmt.Println("Hi from", m)
}

func main() {
	value := MyType("a MyType value")
	value.sayHi() //Hi from a MyType value
	anotherValue := MyType("another value")
	anotherValue.sayHi() //Hi from another value
}

按照惯例，Go开发者通常使用一个字母作为名称 -- 小写的接收器类型名称的首字母。Go使用接收器参数来替代其他语言中的self或者this。

方法几乎就像一个函数，除了事实上它们在接收器上被调用外，方法与任何函数完全相同。

func (n *Number) Double { //将接收器参数修改为指针类型
	*n *= 2 //修改指针指向的值
}

func main() {
	number := Number(4)
	fmt.Println(number)
	number.Double() //接收器参数是不是指针类型，都不需要修改方法的调用形式
	fmt.Println(number)
}

type MyType string 

func (m MyType) method() {
	fmt.Println("Method with value receiver")
}

func (m *MyType) pointerMethod() {
	fmt.Println("Method with pointer receiver")
}

func main() {
	value := MyType("a value")
	pointer := &value
	value.method() //Method with value receiver
	value.pointerMethod() //值类型自动转换为指针 //Method with pointer receiver
	pointer.method() //指针类型自动转换为值 //Method with value receiver
	pointer.pointerMethod() //Method with pointer receiver
}

&MyType("a value") //cannot take the address of MyType("a value")

MyType("a value").pointerMethod() //cannot call pointer method on MyType("a value") cannot take the address of MyType("a value")

你需要将值保存在变量中，允许Go能得到一个指向它的指针
value := MyType("a value")
value.pointerMethod() //Go将value转化为指针

package main 

import "fmt"

type Liters float64
type Milliliters float64 
type Gallons float64 

func (l Liters) ToGallons() Gallons {
	return Gallons(l * 0.264)
}

func (m Milliliters) ToGallons() Gallons {
	return Gallons(m * 0.000264)
}

func main() {
	soda := Liters(2)
	fmt.Println(soda.ToGallons())
	water := Milliliters(500)
	fmt.Println(water.ToGallons())
}

方法定义很像函数定义，除了它需要包含一个接收器参数。方法与接收器参数的类型相关，一旦定义，方法可以被那个类型的任意值调用。

在函数名称前放入一个在括号中的接收器参数来定义一个方法：
func (m MyType) MyMethod() {

}

接收器参数可以像其他参数一样在方法内部被调用：
func (m MyType) MyMethod() {
	fmt.Println("called on", m)
}

在同一个包中定义多个同名的函数不被允许，即使它们有不同类型的参数，你可以定义多个相同名字的方法，
只要它们分别属于不同的类型。

你只能为同包的类型定义方法。

就像其他的参数一样，接收器参数接收一个原值的拷贝，如果你的方法需要修改接收器，你应该在接收器参数上使用指针类型，并且修改指针指向的值。

package calendar

type Date struct {
	Year int 
	Month int 
	Day int 
}

func (d *Date) SetYear(year int) {
	d.Year = year //现在更新的是原值，不是拷贝
}

func main() {
	data := Date{}
	date.SetYear(2019)
	fmt.Println(date.Year)
}

func (d *Date) SetYear(year int) error {
	if year < 1 {
		return errors.New("invalid year")
	}
	d.Year = year 
	return nil
}

func (d *Date) SetMonth(month int) error {
	if month < 1 || month > 12 {
		return errors.New("invalid month")
	}
	d.Month = month 
	return nil
}

func (d *Date) SetDay(day int) error {
	if day < 1 || day > 31 {
		return errors.New("invalid day")
	}
	d.Day = day 
	return nil
}

func main() {
	date := calendar.Date{}
	err := date.SetYear(2019)
	if err != nil {
		log.Fatal(err)
	}

	err := date.SetMonth(5)
	if err != nil {
		log.Fatal(err)
	}

	err := date.SetDay(27)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(date.Year())
	fmt.Println(date.Month())
	fmt.Println(date.Day())
}

Go使用未导出的变量、struct字段、函数或者方法，把数据封装在包中。

如果你嵌入了一个具有导出方法的struct类型，它的方法会被提升到外部类型，
意味着你可以调用那个方法，就像在外部类型上定义了该方法一样。还记得把一个
struct类型嵌入另一个中会让内部的struct字段被提升到外部struct吗？这也是
相同的点子，但是用方法代替了字段。

package mypackage 

import "fmt"

type MyType struct { //声明MyType是一个struct类型
	EmbeddedType //EmbeddedType是一个嵌入MyType的类型
}

type EmbeddedType string //声明一个被嵌入的类型，并不在意它是否是个struct

func (e EmbeddedType) ExportedMethod() { //这个方法被提升至MyType
	fmt.Println("Hi from ExportedMethod on EmbeddedType")
}

func (e EmbeddedType) unexportedMethod() {//这个方法不会被提升

}

package main 

import "mypackage"

func main() {
	value := mypackage.MyType() 
	value.ExportedMethod() //调用从EmbeddedType提升的方法

	//对于未导出的字段或者方法，没有被提升
	//value.unexportedMethod() //错误，undefined
}


package calendar 

import (
	"errors"
	"unicode/utf8" //计算string中的字符个数
)

type Event struct {
	title string //非导出字段
	Date
}

func (e *Event) Title() string {
	return e.title 
}

func (e *Event) SetTitle(title string) error {
	if utf8.RuneCountInString(title) > 30 {
		return errors.New("invalid title")
	}
	e.title = title 
	return nil
}

封装：将程序中的数据隐藏在一部分代码中，而对另一部分不可见。封装可以被用来保护数据免于无效数据，
封装数据也更容易修改。你可以确保不会破坏其他访问数据的代码，因为没有代码有权限破坏。

嵌入：一个类型使用匿名字段的方式保存到另一个struct类型中，被称为嵌入了struct。嵌入类型的方法会提升到
外部类型，它们可以被调用，就像它们是在外部类型上定义的一样。

外部类型定义的方法和内部嵌入类型的方法，生存时间是一样的。一个嵌入类型的未导出方法不会被提升到外部类型。

//接口
type myInterface interface {
	methodWithoutParameters() 
	methodWithParameters(float64) 
	methodWithReturnValue() string 
}

任何拥有接口定义的所有方法的类型被称作满足那个接口。一个满足接口的类型可以用在任何需要接口的地方。
除了接口中列出的方法之外，类型还可以有更多的方法，但是它不能缺少接口中的任何方法，否则就不满足那个接口。
一个类型可以满足多个接口，一个接口(通常应该)可以有多个类型满足它。

package main 

import "fmt"

type Whistle string 

func (w Whistle) MakeSound() { 
	fmt.Println("Tweet!")
}

type Horn string 

func (h Horn) MakeSound() {
	fmt.Println("Honk!")
}

type NoiceMaker interface { //代表任何含有MakeSound方法的类型
	MakeSound()
}

func main() {
	var toy NoiseMaker 
	toy = Whistle("Toyco Canary") //将一个满足NoiseMaker的类型的值赋给变量
	toy.MakeSound() //Tweet!
	toy = Horn("Toyco Blaster")
	toy.MakeSound() //Honk!
}

func play (n NoiseMaker) {
	n.MakeSound()
}

func main() {
	play(Whistle("Toyco Canary")) // Tweet!
	play(Horn("Toyco Blaster")) // Honk!
}


注意，可以将具有其他方法的类型赋值给接口类型，只要你不调用那些方法，一切都会工作得很好。
type Robot string 

func (r Robot) MakeSound() { //Robot满足NoiseMaker接口
	fmt.Println("Beep Boop")
}

func (r Robot) Walk() { //一个额外的方法
	fmt.Println("Powering legs")
}

type NoiseMaker interface {
	MakeSound()
}

func play(n NoiseMaker) {
	n.MakeSound()
}

func main() {
	play(Robot("Botco Ambler"))
}

----

package main 

import "fmt"

type Switch string 
func (s *Switch) toggle() {
	if *s == "on" {
		*s = "off"
	} else {
		*s = "on"
	}
	fmt.Println(*s)
}

type Toggleable interface {
	toggle()
}

func main() {
	s := Switch("off")
	var t Toggleable = &s //注意，赋给一个指针，替代一个直接的Switch值，才能正常工作
	t.toggle() 
}

类型转换并不适用于接口类型：
 record := gadet.TapeRecorder(player) //错误 cannot convert player (type player) to type gadget.TapeRecorder: need type assertion

将一个具体类型的值赋给一个接口类型的变量时，类型断言让你能取回具体类型。
type Robot string 
func (r Robot) MakeSound() {
	fmt.Println("Beep Boop")
}

func (r Robot) Walk() {
	fmt.Println("Powering legs")
}

type NoiseMaker interface {
	MakeSound()
}

func main() {
	var noiseMaker NoiseMaker = Robot("Botco Ambler")
	noiseMaker.MakeSound() //调用接口中的方法
	var robot Robot = noiseMaker.(Robot) //使用类型断言取回具体类型
	robot.Walk() //调用在具体类型(而不是接口)上定义的方法
}

type Player interface {
	Play(string) 
	Stop()
}

func TryOut(player Player) {
	player.Play("Test Track")
	player.Stop()
	recorder, ok := player.(gadget.TapeRecorder)
	if ok {
		recorder.Record()
	}
}

func main() {
	TryOut(gadget.TapeRecorder())
	TryOut(gadget.TapePlayer()) //类型断言未成功,Record没有被调用
}


type error interface {
	Error() string 
}

type ComedyError string //定义一个以string为基础类型的类型
func (c ComedyError) Error() String { //满足error接口
	return string(c) //Error方法需要返回一个string，所以做个类型转换
}

func main() {
	var err error //声明一个error类型的变量
	err = ComedyError("What's error") //ComedyError满足error接口，所以我们能把ComedyError赋值给变量
	fmt.Println(err) //What's error
}

type OverheatError float64 
func (o OverheatError) Error() string {
	return fmt.Sprintf("Overheating by %0.2f degrees!", o)
}

func checkTemperature(actual float64, safe float64) error {
	excess := actual - safe 
	if excess > 0 {
		return OverheatError(excess)
	}
	return nil
}

func main() {
	var err error = checkTemperature(121.379, 100.0)
	if err != nil {
		log.Fatal(err)
	}
}

error类型像int或者string一样，是一个“预定义标识符”，它不属于任何包。它是“全局块”的一部分，
这意味着它在任何地方可用，不用考虑当前包信息。


type Stringer interface {
	String() string //任何具有返回string的String方法的类型都是一个fmt.Stringer
}

type CoffeePot string 
func (c CoffeePot) String() string { //满足Stringer接口
	return string(c) + " coffee pot"
}

func main() {
	coffeePot := CoffeePot("LuxBrew") 
	fmt.Println(coffeePot.String()) //LuxBrew coffee pot 
}

type Gallons float64
func (g Gallons) String() string {
	return fmt.Sprintf("%0.2f gal", g) //当Gallons满足Stringer接口
}

func main() {
	fmt.Println(Gallons(12.092384)) //12.09 gal
}

//空接口
type Anything interface {

}

interface{}类型被称为空接口，用来接收任何类型的值，不需要实现任何方法来满足空接口，所以所有的类型都满足它。
如果你定义了一个接收一个空接口作为参数的函数，可以传入任何类型的值作为参数：

func AcceptAnything(thing interface{}) { //接收一个空接口作为参数
	fmt.Println(thing) //打印
	whistle, ok := thing.(Whistle) //使用类型断言来获得Whistle
	if ok {
		whistle.MakeSound() //调用Whistle上的方法
	}
}

func main() {
	AcceptAnything(3.1415)
	AcceptAnything("A string")
	AcceptAnything(true)
	AcceptAnything(Whistle("Toyco Canary"))
}

大多数fmt中的函数接收空接口类型的值，所以你可以传给它们空接口类型的值。
空接口没有任何方法，意味着你没法调用空接口类型值的任何方法。
为了在空接口类型的值上调用方法，需要使用类型断言来获得具体类型的值。

一个接口是特定的值预期具有的一组方法。任何拥有接口定义中的所有方法的类型被称为满足这个接口。
如果一个类型满足接口，那么它就可以被赋给那个接口类型的任何变量或者函数参数。

为了满足一个接口，类型必须实现接口定义的所有方法，方法名称、参数类型(或没有)和返回值类型(或没有)都必须与接口中定义的一致。

类型可以满足多个接口，接口也可以被不同的类型满足。

类型断言返回第二个bool值，来表明断言是否成功。
car, ok := vehicle.(Car)

package main 

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func OpenFile(fileName string) (*os.File, error) {
	fmt.Println("Opening", fileName)
	return os.Open(fileName) //打开文件并返回指向该文件的指针，以及遇到的任何错误
}

func CloseFile(file *os.File) {
	fmt.Println("Closing file")
	file.Close() //关闭文件
}

func GetFloats(fileName string) ([]float64, error) {
	var numbers []float64
	file, err := OpenFile(fileName) //不是直接调用os.Open，而是调用Openfile
	if err != nil {
		return nil, err
	}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		number, err := strconv.ParseFloat(scanner.Text(), 64)
		if err != nil {
			return nil, err
		}
		numbers = append(numbers, number)
	}
	CloseFile(file) //不是直接调用file.Close，而是调用CloseFile
	if scanner.Err() != nil {
		return nil, scanner.Err()
	}
	return numbers, nil
}

如果你有一个无论如何希望确保运行的函数调用，都可以使用defer语句，可以将defer关键字放在任何普通函数或者方法调用之前，
Go将延迟执行函数调用，直到当前函数退出之后。

defer不能延迟for循环或者变量赋值，只能延迟函数和方法调用，可以编写一个函数或方法来做任何想要做的事情，然后延迟对该
函数或者方法的调用。

//递归

package main 

import "fmt"

func count(start in, end int) {
	fmt.Printf("count(%d, %d) called\n", start, end)
	fmt.Println(start)
	if start < end {
		count(start + 1, end)
	}
	fmt.Printf("Returninbg from count(%d, %d) call\n", start, end)
}

func main() {
	count(1, 3)
}

/*
	count(1, 3) called
	1
	count(2, 3) called
	2
	count(3, 3) called
	3
	Returning from count(3, 3) call
	Returning from count(2, 3) call
	Returning from count(1, 3) call 
*/

//递归地列出目录内容
package main 

import (
	"fmt"
	"io/ioutil"
	"log"
	"path/filepath"
)


func scanDirectory(path string) error {
	fmt.Println(path) //打印当前目录
	files, err := ioutil.ReadDir(path) //获取包含目录内容的切片
	if err != nil {
		return err 
	}

	for _, file := range files {
		filePath := filepath.Join(path, file.Name()) //用斜杠将目录路径和文件名连接起来
		if file.IsDir() { //如果这是一个子目录
			err := scanDirectory(filePath) //递归调用scanDirectory，这次是用子目录的路径
			if err != nil {
				return err 
			}
		} else {
			fmt.Println(filePath) //如果这是一个普通文件，只需打印它的路径
		}
	}
	return nil
}

func main() {
	err := scanDirectory("go") //通过对顶部目录调用scanDirectory来启动该过程
	if err != nil {
		log.Fatal(err)
	}
}

访问数组和切片中的无效索引；类型断言失败，且不使用可选的ok布尔值；都会出现panic。
当程序出现panic时，当前函数停止运行，程序打印日志消息并崩溃。

panic函数需要一个满足空接口的参数，也就是说，它可以是任何类型。当程序发生panic时，panic输出中
包含堆栈跟踪，即调用堆栈列表，这对于确定导致程序崩溃的原因很有用。

//引发panic
package main 
func main() {
	panic("oh, no, we're going down")
}

延迟调用在崩溃前完成：当程序出现panic时，所有延迟的函数调用仍然会被执行，如果有多个延迟调用，它们的执行顺序
将与被延迟的顺序相反。

//用panic简化error处理
package main 

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
)


func scanDirectory(path string) {
	fmt.Println(path) //打印当前目录
	files, err := ioutil.ReadDir(path) //获取包含目录内容的切片
	if err != nil {
		panic(err) // 
	}

	for _, file := range files {
		filePath := filepath.Join(path, file.Name()) //用斜杠将目录路径和文件名连接起来
		if file.IsDir() { //如果这是一个子目录
			scanDirectory(filePath) //递归调用scanDirectory，这次是用子目录的路径
		} else {
			fmt.Println(filePath) //如果这是一个普通文件，只需打印它的路径
		}
	}
}

func main() {
	scanDirectory("go") //通过对顶部目录调用scanDirectory来启动该过程
}


JT0012817419289

当scanDirectory在读取目录遇到错误时，它就产生panic，所有对scanDirectory的递归调用都退出。

调用panic应该留给“不可能”的情况：错误表示的是程序中的错误，而不是用户方面的错误。

package main 

import (
	"fmt"
	"math/rand"
	"time"
)

func awardPrize() {
	doorNumber := rand.Intn(3) + 1
	if doorNumber == 1 {
		fmt.Println("You win a cruise")
	} else if doorNumber == 2 {
		fmt.Println("You win a goat")
	} else if doorNumber == 3 {
		fmt.Println("You win a car")
	} else {
		panic("invalid door number") //不应该产生其他的数字，但如果产生了，那就产生panic
	}
}

func main() {
	rand.Seed(time.Now().Unix())
	awardPrize()
}

//recover和panic的组合不建议使用
func calmDown() {
	recover()
}

func freakOut() {
	defer calmDown()
	panic ("ch no") //当恢复时，freakOut在这个位置返回
	fmt.Println("I won't be run!") //panic之后的这段代码将永远不会执行
}

func main() {
	freakOut()
	fmt.Println("Exiting normally") //这段代码在freakOut返回之后运行
}

func main() {
	fmt.Println(recover()) //如果在一个程序中调用了recover，而这个程序没有panic，那么这里recover()什么都不做，返回nil
}

func reportPanic() {
	p := recover()
	if p == nil {
		return
	}
	err, ok := p.(error) //断言panic值的类型为error
	if ok {
		fmt.Println(err)
	} else {
		panic(p) //如果panic的值不是error，则使用相同的值恢复panic
	}
}

func scanDirectory(path string) {
	fmt.Println(path) //打印当前目录
	files, err := ioutil.ReadDir(path) //获取包含目录内容的切片
	if err != nil {
		panic(err)
	}

	for _, file := range files {
		filePath := filepath.Join(path, file.Name()) //用斜杠将目录路径和文件名连接起来
		if file.IsDir() { //如果这是一个子目录
			scanDirectory(filePath) //递归调用scanDirectory，这次是用子目录的路径
		} else {
			fmt.Println(filePath) //如果这是一个普通文件，只需打印它的路径
		}
	}
}

func main() {
	defer reportPanic() 
	scanDirectory("go")
}

Defer: 可以在任何函数或者方法调用之前添加"defer"关键字，将该调用推迟到当前函数退出后。延迟函数调用通常用于清理代码，即使在发生错误时也需要运行。
Recover: 如果延迟的函数调用内置的"recover"函数，程序将从panic状态中恢复(如果有的话)，"recover"函数返回最初传递给"panic"函数的任何值。

可以调用内置的panic函数来引发程序panic，除非调用内置的recover函数，否则panic的程序将崩溃并显示日志信息。
延迟的函数可以调用内置的recover函数，这将使程序恢复正常运行。

package prose 

import "strings"

func JoinWithCommas(phrases []string) string {
	result := strings.Join(phrases[:len(phrases) - 1], ", ") //除了最后一个短语，每个短语都用逗号连接在一起
	result += " and "
	result += phrases[len(phrases) - 1] //添加最后一个短语
	return result 
}

strings.Join函数获取一个字符串切片，并使用一个字符串将它们连接在一起，Join返回一个字符串，其中合并了切片中的所有项，并用连接字符串分隔每个项。
fmt.Println(strings.Join([]string{"05", "14", "2018"}, "/")) // 05/14/2018
fmt.Println(strings.Join([]string{"state", "of", "the", "art"}, "-")) // state-of-the-art

//自动化测试就像每次更改代码时都自动检查bug一样
//_test.go部分是重要的，go test工具查找以后该后缀命名的文件
在包目录的join.go旁边，添加join_test.go文件

package prose

import "testing" //导入标准的"testing"包

//函数名以Test开头，Test后面的名称可以是任何你想要的
func TestTwoElements(t *testing.T) { //将一个指向testing.T值的指针传递给函数
	t.Error("no test written yet") //调用testing.T上的方法来表示测试失败
}

func TestThreeElements(t *testing.T) {
	t.Error("no test here either")
}

//你不需要将测试代码与正在测试的代码，放在同一个包中，但是如果你想从包中访问未导出的类型或者函数，则需要这样做。

//使用go test命令运行测试，该命令采用一个或者多个包的导入路径，就像go install或者go doc一样，它将在那些包目录中找到所有名字以_test.go结尾的文件，
//并运行名字以Test开头的文件中包含的每个函数
go test github.com/headfirstgo/prose 

如果测试未通过，prose包会打印FAIL状态，如果测试通过，prose包会打印ok状态。

func TestTwoElements(t *testing.T) {
	list := []string{"apple", "orange"}
	if JoinWithCommas(list) != "apple and orange" {
		t.Error("didn't match expected value")
	}
}

func TestThreeElements(t *testing.T) {
	list := []string{"apple", "orange", "pear"}
	if JoinWithCommas(list) != "apple, orange, and pear" {
		t.Error("didn't match expected value")
	}
}

package prose 

import (
	"fmt"
	"testing"
)

//使用Errorf方法获得更详细的测试失败消息
func TestTwoElements(t *testing.T) {
	list := []string{"apple", "orange"}
	want := "apple and orange"
	got := JoinWithCommas(list)
	if got != want {
		t.Error(errorString(list, got, want))
	}
}

func TestThreeElements(t *testing.T) {
	list := []string{"apple", "orange", "pear"}
	want := "apple, orange, and pear"
	got := JoinWithCommas(list)
	if got != want {
		t.Error(errorString(list, got, want))
	}
}

func errorString(list []string, got string, want string) string {
	return fmt.Sprintf("JoinWithCommas(%#v) = \"%s\", want \"%s\"", list, got, want)
}

go build和go install都被设置为忽略名称以_test.go结尾的文件，go工具可以将你的程序代码编译成一个可执行文件，
但是它将忽略测试代码，即使它保存在相同的包目录中。

go test -v (显示详细信息) -run (限制正在运行的测试集)
-run Two => 只有名称中包含Two的测试函数才会匹配
-run Elements => TestTwoElements TestThreeElements会运行，但是TestOneElement不会运行，因为其名字末尾没有s

//进一步减少测试中的重复代码 => 表驱动测试
type testData struct {
	list []string
	want string
}

//list_test.go文件
import "testing"

type testData struct {
	list []string
	want string
}

func JoinWithCommas(phrases []string) string {
	if len(phrases) == 0 {
		return ""
	} else if len(phrases) == 1 {
		return phrases[0]
	} else if len(phrases) == 2 {
		return phrases[0] + " and " + phrases[1]
	} else {
		result := strings.Join(phrases[:len(phrases) - 1], ", ")
		result += ", and "
		result += phrases[len(phrases) - 1]
		return result 
	}
}

func TestJoinWithCommas(t *testing.T) {
	tests := []testData{
		testData{list: []string{"apple"}, want: "apple"},
		testData{list: []string{"apple", "orange"}, want: "apple and orange"}
		testData{list: []string{"apple", "orange", "pear"}, want: "apple, orange, and pear"}
	}
	for _, test := range tests {
		got := JoinWithCommas(test.list)
		if got != test.want {
			t.Errorf("JoinWithCommas(%#v) = \"%s\", want \"%s\"", test.list, got, test.want)
		}
	}
}

测试函数必须接受单个参数：一个指向testing.T值的指针。
Errorf方法的工作原理类似于Error，但是它接受格式化字符串，就像fmt.Printf一样。
_test.go文件中名字不以Test开头的函数，不会由go test运行，它们可以被测试用作helper函数，即被那些Test开头的函数调用。

//响应请求，Web应用程序

package main 

import (
	"log"
	"net/http"
)

func viewHandler(writer http.ResponseWriter, request *http.Request) {
	message := []byte("Hello, web!") //字符串转换为[]byte
	_, err := writer.Write(message) //向响应中添加"Hello, web!"， write不接受字符串，但是它接受byte值的切片
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	http.HandleFunc("/hello", viewHandler) //如果收到一个以/hello结尾的URL请求，那么调用viewHandler函数来生成响应
	err := http.ListenAndServe("localhost:8080", nil) //监听浏览器的请求，并对其做出响应；nil表示将使用通过HandleFunc设置的函数来处理请求
	log.Fatal(err)
}

$ go run hello.go
在浏览器访问 http://localhost:8080/hello -> 浏览器响应Hello, web!
终端程序使用ctrl+c进行退出

byte类型是Go的基本类型之一，用于保存原始数据，比如可能从文件或网络连接中读取的数据，如果直接打印byte值的切片，它不会显示任何有意义的内容，但是
如果将byte值的切片转换为字符串，则会返回可读文本。

func main() {
	response, err := http.Get("https://example.com")
	if err != nil {
		log.Fatal(err)
	}
	defer response.Body.close()
	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(body))
}

//[]byte -> string
fmt.Println(string([]byte{72, 101, 108, 108, 111}))
//string -> []byte
fmt.Println([]byte("Hello"))


package main 

import (
	"log"
	"net/http"
)

func write(writer http.ResponseWriter, message string) {
	_, err := writer.Write([]byte(message))
	if err != nil {
		log.Fatal(err)
	}
}

func englishHandler(writer http.ResponseWriter, request *http.Request) {
	write(writer, "Hello, web!")
}

func frenchHandler(writer http.ResponseWriter, request *http.Request) {
	write(writer, "Salut web!")
}

func main() {
	http.HandleFunc("/hello", englishHandler)
	http.HandleFunc("/salut", frenchHandler)
	err := http.ListenAndServe("localhost:8080", nil)
	log.Fatal(err)
}


//正常地声明一个函数
func sayHi() {
	fmt.Println("Hi")
}

func main() {
	var myFunction func() 声明一个类型为 func() 的变量
	myFuction = sayHi //将sayHi函数赋值给变量
	myFunction() //调用存储在变量中的函数
}

---

func sayHi() {
	fmt.Println("Hi")
}

func divide(a int, b int) float64 {
	return float64(a) / float64(b)
}

func main() {
	var greeterFunction func()
	var mathFunction func(int, int) float64 
	greeterFunction = sayHi
	mathFunction = divide
	greeterFunction() //Hi
	fmt.Println(mathFunction(5, 2)) //2.5
}

因为ListenAndServe总是返回一个错误，如果没有错误，ListenAndServe将永远不会返回。这个错误永远不会是nil，
所以只需对其调用log.Fatal。

package main 

import (
	"bufio"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
)

// Guestbook is a struct used in rendering view.html
type Guestbook struct {
	SignatureCount int //保存签名的总数
	Signatures []string //将保存签名本身
}

//check calls log.Fatal on any non-nil error
func check(err error) {
	if err != nil {
		log.Fatal(err) //输出错误并退出程序
	}
}

//viewHandler reads guestbook signatures and displays them together
//with a count of all signatures
func viewHandler(writer http.ResponseWriter, request *http.Request) {
	signatures := getStrings("signatures.txt") //从文件中读取签名
	html, err := template.ParseFiles("view.html") //基于view.html的内容，创建一个模版
	check(err)
	guestbook := Guestbook {
		SignatureCount: len(signatures), //保存签名的数量
		Signatures: signatures, //保存签名本身
	}
	err = html.Execute(writer, guestbook) //将Guestbook struct数据插入模版，并将结果写入ResponseWriter
	check(err)
}

//newHandler displays a form to enter a signature
func newHandler(writer http.ResponseWriter, request *http.Request) {
	html, err := template.ParseFiles("new.html") //从模板加载HTML表单
	check(err)
	err = html.Execute(writer, nil)
	check(err)
}

//createHandler takes a POST request with a signature to add, and appends it to the signatures file.
func createHandler(writer http.ResponseWriter, request *http.Request) {
	signatures := request.FormValue("signature") //获取signature表单字段的值
	options := os.O_WRONLY | os.O_APPEND | os.O_CREATE
	file, err := os.OpenFile("signatures.txt", options, os.FileMode(0600)) //打开文件进行写入，如果文件存在，则进行追加，如果不存在，则创建它
	check(err)
	_, err = fmt.Fprintln(file, signature) //将表单字段内容添加到文件中
	check(err)
	err = file.Close() //关闭文件
	check(err)
	http.Redirect(writer, request, "/guestbook", http.StatusFound) //将浏览器重定向到主留言薄页面
}

//getStrings returns a slice of strings read from fileName, one string per line
func getStrings(fileName string) []string {
	var lines []string //文件的每一行都将作为字符串追加到这个切片
	file, err := os.Open(fileName) //打开文件
	if os.IsNotExist(err) { //如果得到一个错误，表明文件不存在，返回nil而不是切片
		return nil
	}
	check(err) //所有其他错误都应正常检查和报告
	defer file.Close() 
	scanner := bufio.NewScanner(file) //为文件内容创建一个扫描器
	for scanner.Scan() { //对文件的每一行
		lines = append(lines, scanner.Text()) //将其文本附加到切片
	}
	check(scanner.Err()) //报告扫描过程中遇到的任何错误
	return lines //返回字符串的切片
}

func main() {
	http.HandleFunc("/guestbook", viewHandler) //查看签名列表的请求，将由viewHandler函数处理
	http.HandleFunc("/guestbook/new", newHandler) //获取HTML表单的请求，将由newHandler处理
	http.HandleFunc("/guestbook/create", createHandler)//提交表单的请求，将由createHandler处理
	err := http.ListenAndServe("localhost:8080", nil) //无限循环，将HTTP请求传递给适当的函数进行处理
	log.Fatal(err)
}

//view.html文件提供了签名列表的HTML模版。模版action提供了插入签名数量以及整个签名列表的位置
<h1>Guestbook</h1> //页面顶部的一级标题
<div>
	{{.SignatureCount}} total signatures - 
	<a href="/guestbook/new">Add Your Signature</a> //指向代表HTML表单的路径的链接
</div>

<div>
	{{range .Signatures}}
		<p>{{.}}</p> //对于每个切片元素都会重复该操作，“点”被设置为当前签名字符串，插入包含签名的HTML paragraph元素
	{{end}}
</div>

//new.html文件只是保存用于新签名的HTML表单，没有数据将插入其中，因此不存在模版action
<h1>Add a Signature</h1>
<form action="/guestbook/create" method="POST"> //HTML表单，提交将转到"/guestbook/create"路径，提交将使用POST方法
	<div><input type="text" name="signature"></div> //文本字段，其数据可以在"signature"名字下访问
	<div><input type="submit"></div> //提交表单的按钮
</form>


权限参数在Windows上被忽略，其使用默认权限创建文件。

fmt.Println(os.FileMode(0700)) //-rwx------ 文件的所有者拥有全部的权限(读、写、执行)
fmt.Println(os.FileMode(0070)) //----rwx--- 文件组中的用户拥有全部的权限
fmt.Println(os.FileMode(0007)) //-------rwx 系统上的所有其他用户拥有全部的权限 第一个"-"代表是普通文件

fileInfo, err := os.Stat("my_directory") //获取文件或者目录的统计信息
if err != nil {
	log.Fatal(err)
}

fmt.Println(fileInfo.Mode()) //打印目录的FileMode信息 drwxr-xr-x

任何以0开头的数字序列都将被视为八进制数，Unix chmod命令使用八进制数字设置文件权限。
0 没有权限 
1 执行 
2 写 
3 写，执行 
4 读 
5 读，执行
6 读，写
7 读，写，执行

func saveString(fileName string, str string) error {
	err := ioutil.WriteFile(fileName, []byte(str), 0600)
	return err 
}

func main() {
	err := saveString("hindi.txt", "Namaste")
	if err != nil {
		log.Fatal(err)
	}
}

//局部变量作用域
if count := 5; count > 4 {
	fmt.Println("count is", count)
	count = count - 1
}

import (
	"fmt"
	"math/rand"
	"time"
)

func awardPrize() {
	switch rand.Intn(3) + 1 {
		case 1:
			fmt.Println("1")
		case 2:
			fmt.Println("2")
		case 3:
			fmt.Println("3")
		default:
			panic("invalid door number")
	}
}

func main() {
	rand.Seed(time.Now().Unix())
	awardPrize()
}

Go会在Case代码末尾自动退出switch，如果希望下一个case的代码也能运行，
可以在一个case中使用fallthrough关键字。

Go使用rune类型的值表示Unicode值，Go使用UTF-8，这是表示Unicode字符的标准。
任何时候处理字符串的一部分，就把它转成符文，而不是字节。如果需要字符串的字符长度，
则应该使用unicode/utf8包的RuneCountInString函数。此函数将返回
正确的字符数，而不考虑用于存储每个字符的字节数。
fmt.Println(utf8.RuneCountInString(asciiString)) //字符串包含5个符文
fmt.Println(utf8.RuneCountInString(utf8String)) //字符串包含5个符文


channel := make(chan string, 3)
有缓冲的channel：当另一个goroutine从channel接收一个值时，它从缓冲区中提取最早添加的值。

//==================Go语言创建的goroutine数量过多会产生什么后果？

/*
	在Go语言中，goroutine是一种轻量级的线程，由Go运行时管理，相较于传统的线程，goroutine的创建和切换开销更小，初始栈空间通常只需要2-4KB 。然而，创建过多的goroutine可能会带来一些后果：

	1. **系统资源耗尽**：如果goroutine的数量超过了系统能够处理的限度，可能会导致程序崩溃。例如，如果每个goroutine都尝试进行I/O操作，可能会因为文件描述符或套接字的数量超过系统上限而导致错误，如“too many concurrent operations on a single file or socket (max 1048575)”。

	2. **内存不足**：每个goroutine至少需要消耗一定量的内存空间，如果计算机的内存有限，过多的goroutine可能会因为内存不足而崩溃。例如，如果每个goroutine占用2KB的内存，那么在2GB的内存下最多只能支持大约1M个goroutine同时存在。

	3. **调度问题**：Go运行时使用M:N调度模型，即多个goroutine映射到较少的系统线程上。如果goroutine数量过多，可能会导致调度器的效率降低，进而影响程序的性能。

	4. **GC压力增大**：随着goroutine数量的增加，垃圾回收（GC）的负担也会随之增加，因为GC需要跟踪更多的对象。这可能会导致GC暂停时间变长，影响程序的响应时间和吞吐量。

	为了避免这些问题，可以采取以下措施：

	- **限制并发数量**：通过使用带缓冲的channel或者第三方库（如tunny或ants）来控制goroutine的并发数量。
	- **合理设计并发逻辑**：确保goroutine之间不会相互阻塞，避免死锁和资源竞争。
	- **监控和调优**：使用工具监控程序的运行状态，根据实际情况调整goroutine的数量和程序的内存使用。

	综上所述，goroutine的数量并不是越多越好，需要根据应用程序的具体需求和运行环境来合理控制。


	》》控制 Go 语言中 goroutine 的并发数量是确保程序性能和稳定性的关键。以下是一些常用的方法来控制 goroutine 的并发数量：

	1. **使用带缓冲的 channel**：
	   创建一个带有缓冲区的 channel，缓冲区的大小决定了可以同时运行的 goroutine 的最大数量。通过在启动 goroutine 之前向 channel 发送信号，可以限制同时运行的 goroutine 数量。

	   ```go
	   ch := make(chan struct{}, maxConcurrency) // maxConcurrency 是并发数上限
	   for i := 0; i < totalJobs; i++ {
	       ch <- struct{}{} // 申请一个运行名额
	       go func(job int) {
	           defer func() { <-ch }() // 运行结束后释放名额
	           doWork(job)
	       }(i)
	   }
	   ```

	2. **使用 WaitGroup**：
	   `sync.WaitGroup` 可以用来等待一组 goroutine 完成。虽然它本身不限制并发数量，但可以确保在所有 goroutine 完成之前主 goroutine 不会提前退出。

	   ```go
	   var wg sync.WaitGroup
	   for i := 0; i < totalJobs; i++ {
	       wg.Add(1)
	       go func(job int) {
	           defer wg.Done()
	           doWork(job)
	       }(i)
	   }
	   wg.Wait()
	   ```

	3. **使用第三方库**：
	   使用如 `tunny` 或 `ants` 这样的第三方库来创建一个固定大小的 goroutine 池，这些库提供了简单的 API 来控制并发执行的 goroutine 数量。

	   - 使用 `tunny`：

	     ```go
	     import "github.com/Jeffail/tunny"

	     func main() {
	         pool := tunny.NewFunc(maxConcurrency, func(i interface{}) interface{} {
	             doWork(i.(int))
	             return nil
	         })
	         defer pool.Close()

	         for i := 0; i < totalJobs; i++ {
	             go pool.Process(i)
	         }
	     }
	     ```

	   - 使用 `ants`：

	     ```go
	     import ants "github.com/panjf2000/ants"

	     func main() {
	         pool, err := ants.NewPool(maxConcurrency, ants.WithExpiryDuration(time.Second*5))
	         if err != nil {
	             log.Fatalf("create pool failed: %v", err)
	         }
	         defer pool.Release()

	         for i := 0; i < totalJobs; i++ {
	             pool.Submit(doWork, i)
	         }
	     }
	     ```

	4. **使用 context 包**：
	   `context` 包可以用来控制 goroutine 的取消和超时。虽然它不直接控制并发数量，但可以用来优雅地取消超时或不再需要的 goroutine。

	5. **动态调整并发数**：
	   根据程序的运行情况和资源使用情况动态调整并发数。例如，可以监控 CPU 使用率或内存使用情况，并相应地调整 goroutine 的数量。

	6. **设置系统资源限制**：
	   在某些情况下，可以通过调整操作系统的配置来增加资源限制，如使用 `ulimit` 命令增加文件描述符的限制。

	选择合适的方法取决于具体的应用场景和需求。通常，结合使用这些方法可以更有效地控制 goroutine 的并发执行，从而优化程序的性能和资源使用。


	》〉生成 1 到 100 万的数字顺序地使用 goroutine，我们可以采用类似的方法，但需要注意几个关键点：

	1. **避免内存溢出**：由于数字范围很大，不能一次性将所有数字放入 channel，这可能会消耗大量内存甚至导致内存溢出。
	2. **使用无缓冲 channel**：这可以确保发送操作在接收操作之前不会完成，从而保证数字的顺序性。
	3. **同步机制**：使用 WaitGroup 或其他同步机制来等待 goroutine 完成。

	下面是一个生成 1 到 100 万数字的示例代码：

	```go
	package main

	import (
		"fmt"
		"sync"
	)

	func generateNumbers(wg *sync.WaitGroup, ch chan<- int) {
		defer wg.Done() // 确保在函数结束时通知 WaitGroup

		for i := 1; i <= 1000000; i++ {
			ch <- i // 发送数字到 channel
		}
		close(ch) // 发送完毕后关闭 channel
	}

	func main() {
		ch := make(chan int) // 创建一个无缓冲的 channel
		var wg sync.WaitGroup

		wg.Add(1) // 添加一个任务到 WaitGroup

		go generateNumbers(&wg, ch) // 启动生成数字的 goroutine

		for num := range ch { // 从 channel 中接收数字直到 channel 被关闭
			fmt.Println(num)
		}

		wg.Wait() // 等待生成数字的 goroutine 完成
	}
	```

	在这个示例中，`generateNumbers` 函数负责生成 1 到 100 万的数字，并通过无缓冲 channel 发送它们。我们在函数结束时调用 `wg.Done()`，并在所有数字发送完毕后关闭 channel。

	主 goroutine 中，我们启动了一个 goroutine 来生成数字。然后，我们从 channel 中接收并打印每个数字，直到 channel 被关闭。使用无缓冲 channel 确保了数字的发送和接收是同步的，从而保持了顺序性。

	请注意，这个示例中的打印操作可能会非常慢，因为它是顺序执行的。如果需要提高效率，可以考虑使用并行处理方法，但这将需要更复杂的同步机制来保持数字的顺序性。此外，如果打印操作是性能瓶颈，可以考虑将打印操作也并行化，但这通常不是推荐的做法，因为它可能会迅速填满控制台输出缓冲区。


	》〉要使用并行处理方法生成 1 到 100 万的数字，我们可以创建多个 goroutine，每个 goroutine 生成数字范围的一部分，然后将这些数字通过 channel 发送到一个合并的 channel。最后，从合并的 channel 中顺序地接收并打印所有数字。

	下面是一个使用并行处理生成数字的示例代码：

	```go
	package main

	import (
		"fmt"
		"sync"
	)

	const (
		totalNumbers = 1000000
		numWorkers   = 10 // 可以根据需要调整工作 goroutine 的数量
	)

	func generateNumbers(start, end int, ch chan<- int, wg *sync.WaitGroup) {
		defer wg.Done() // 通知 WaitGroup 任务已完成

		for i := start; i <= end && i <= totalNumbers; i++ {
			ch <- i // 发送数字到 channel
		}
	}

	func main() {
		ch := make(chan int) // 创建一个无缓冲的 channel 用于合并结果
		var wg sync.WaitGroup

		// 计算每个 goroutine 应该处理的数字范围
		rangeSize := totalNumbers / numWorkers

		// 启动 numWorkers 个 goroutine 来生成数字
		for i := 0; i < numWorkers; i++ {
			start := (i * rangeSize) + 1
			end := start + rangeSize - 1
			if i == numWorkers-1 {
				end = totalNumbers // 确保最后一个 goroutine 处理剩余的所有数字
			}

			wg.Add(1) // 添加一个任务到 WaitGroup
			go generateNumbers(start, end, ch, &wg)
		}

		go func() {
			wg.Wait() // 等待所有生成数字的 goroutine 完成
			close(ch) // 关闭 channel，表示不再发送更多数字
		}()

		// 从 channel 中顺序接收并打印所有数字
		for num := range ch {
			fmt.Println(num)
		}
	}
	```

	在这个示例中，我们首先定义了要生成的总数字数量 `totalNumbers` 和工作 goroutine 的数量 `numWorkers`。每个 goroutine 负责生成指定范围内的数字。

	我们创建了一个无缓冲的 channel `ch` 来合并所有生成的数字，并使用 `sync.WaitGroup` 来等待所有 goroutine 完成。

	每个生成数字的 goroutine 通过 `generateNumbers` 函数生成其指定范围内的数字，并将它们发送到合并 channel。当所有 goroutine 都完成时，我们关闭 channel。

	最后，我们启动了一个额外的 goroutine 来等待所有生成数字的 goroutine 完成，并在完成后关闭 channel。然后，我们从合并 channel 中顺序接收并打印所有数字。

	请注意，这种方法可以提高生成数字的效率，因为多个 goroutine 可以并行工作。但是，打印操作仍然是顺序执行的，这可能会成为性能瓶颈。如果需要进一步提高性能，可以考虑使用并行打印方法，但这将需要更复杂的同步机制。

	》〉在 Go 语言中，`sync.WaitGroup` 是一个用于协调多个并发执行的 goroutine 的同步原语。它允许主 goroutine 等待一组 goroutine 完成它们的任务。

	以下是 `sync.WaitGroup` 的一些关键点：

	1. **创建 WaitGroup**：
	   使用 `var wg sync.WaitGroup` 声明一个 WaitGroup 变量。

	2. **添加计数**：
	   使用 `wg.Add(delta int)` 方法来设置 WaitGroup 的计数器。`delta` 可以是正数或负数。通常，你会在启动每个 goroutine 之前调用 `wg.Add(1)` 来增加计数。

	3. **完成计数**：
	   当 goroutine 完成它的任务时，应该调用 `wg.Done()` 来减少 WaitGroup 的计数器。

	4. **等待完成**：
	   使用 `wg.Wait()` 方法让主 goroutine 等待直到 WaitGroup 的计数器达到零。这意味着所有添加到计数器的 goroutine 都已经调用了 `Done()` 方法。

	下面是一个使用 `sync.WaitGroup` 的简单示例：

	```go
	package main

	import (
		"fmt"
		"sync"
		"time"
	)

	func worker(id int, wg *sync.WaitGroup) {
		defer wg.Done() // 通知 WaitGroup 此 goroutine 即将完成

		fmt.Printf("Worker %d starting\n", id)
		time.Sleep(time.Second) // 模拟工作
		fmt.Printf("Worker %d done\n", id)
	}

	func main() {
		var wg sync.WaitGroup

		// 启动三个 goroutine
		for i := 1; i <= 3; i++ {
			wg.Add(1) // 对每个 goroutine 增加计数
			go worker(i, &wg)
		}

		// 等待所有 goroutine 完成
		wg.Wait()
		fmt.Println("All workers completed")
	}
	```

	在这个示例中，我们启动了三个工作 goroutine，每个 goroutine 都通过 `worker` 函数执行。我们在启动每个 goroutine 之前调用 `wg.Add(1)` 来增加 WaitGroup 的计数。每个 goroutine 通过 `defer wg.Done()` 来确保在函数退出前减少计数。最后，我们调用 `wg.Wait()` 来等待所有 goroutine 完成。当所有 goroutine 都调用了 `Done()` 方法后，`wg.Wait()` 将返回，主函数打印出所有工作已完成的消息。

*/


```
