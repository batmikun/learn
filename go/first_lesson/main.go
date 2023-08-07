package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("api/user", makeAPIFunc(handleUser))
  fmt.Print("Connecting to port 3000")
	http.ListenAndServe(":3000", nil)
}

type apiFunc func(http.ResponseWriter, *http.Request) error

func makeAPIFunc(fn apiFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fn(w, r)
	}
}

func handleUser(w http.ResponseWriter, r *http.Request) error {
	return writeJSON(w, http.StatusOK, map[string]string{"message": "Hello"})
}

func writeJSON(w http.ResponseWriter, code int, v any) error {
  w.Header().Set("Content-type", "application/json")
  w.WriteHeader(code)
  return json.NewEncoder(w).Encode(v)
}
