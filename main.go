package main

import (
    "encoding/json"
    "flag"
    "fmt"
    "io/ioutil"
    "log"
    "net/http"
)

type config struct {
    Text string `json:"string"`
}

func main() {

    var filename = flag.String("config", "config.json", "")
    flag.Parse()

    data, err := ioutil.ReadFile(*filename)
    if err != nil {
        log.Fatalln(err)
    }

    var config config
    err = json.Unmarshal(data, &config)

    if err != nil {
        log.Fatalln(err)
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, config.Text)
    })

    log.Fatal(http.ListenAndServe(":8081", nil))

}
