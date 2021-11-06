package main

import (
	"io"
	_ "net/http/pprof"
	"os"
	"runtime"

	_ "github.com/icexin/eggos"
	"github.com/icexin/eggos/app/sh"
	"github.com/icexin/eggos/console"
	"github.com/icexin/eggos/log"
)

func main() {
	log.Infof("[runtime] go version:%s", runtime.Version())
	log.Infof("[runtime] args:%v", os.Args)
	w := console.Console()
	io.WriteString(w, "\nwelcome to eggos\n")
	sh.Bootstrap()
}
