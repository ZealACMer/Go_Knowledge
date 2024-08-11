在 Go 语言中，如果你想定时运行一个 `.sh` 文件，可以通过结合使用 `time` 包来创建一个定时器，并使用 `os/exec` 包来执行 `.sh` 脚本。下面是一个简单的示例，展示如何每隔一定时间运行一个 `.sh` 脚本：

```go
package main

import (
	"fmt"
	"os/exec"
	"time"
)

func main() {
	// 定义定时器间隔时间
	ticker := time.NewTicker(2 * time.Second)
	quit := make(chan struct{})

	go func() {
		for {
			select {
			case <-ticker.C:
				// 每次定时器触发时执行
				runScript()
			case <-quit:
				ticker.Stop()
				return
			}
		}
	}()

	// 假定让程序运行10秒后退出
	time.Sleep(10 * time.Second)
	close(quit)
	fmt.Println("程序结束")
}

func runScript() {
	shPath := "./your_script.sh"

	// 创建*exec.Cmd， sh -c用于运行shell命令
	cmd := exec.Command("sh", "-c", shPath)

	// 执行命令，并获取标准输出与错误输出
	out, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Println("执行脚本失败:", err)
		return
	}

	fmt.Println("脚本输出:", string(out))
}
```

这个示例程序中，首先导入了必要的包。`time` 包用于设定定时器，`os/exec` 包用于执行外部命令。程序设置了一个定时器，每隔2秒钟触发一次执行 `runScript` 函数，在这个函数中，通过 `exec.Command()` 执行一个 `.sh` 脚本，并打印脚本的输出或者错误信息。最后，示例程序设置了10秒后退出的逻辑，代表你的程序会每隔2秒执行一次脚本，共执行5次。

请确保将 `shPath` 的值替换为你的 `.sh` 文件的实际路径。此外，记得给你的 `.sh` 文件设置执行权限（使用 `chmod +x your_script.sh` 命令）。

这只是一个简单的定时执行任务的例子。根据你的具体需求，你可能还需要添加错误处理、日志记录或其他逻辑。
