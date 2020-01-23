package main

import (
       "encoding/json"
       "github.com/gorilla/mux"
       "github.com/jinzhu/gorm"
       _ "github.com/jinzhu/gorm/dialects/mysql"
       "github.com/joho/godotenv"
       "io/ioutil"
       "log"
       "net/http"
       "os"
)

var db *gorm.DB
var err error

type Productview struct {
       Id           int     `json:”id”`
       Name         string  `json:”name”`
       EAN          string  `json:”EAN”`
       Category     string  `json:"Category"`
       SimpleName   string  `json:"Simplename"`
       Manufacturer string  `json:"Manufacturer"`
       Amount       float32 `json:"Amount"`
       Unit         string  `jsoon:"Unit"`
       Brand        string  `json:"Brand"`
}

func getEnvVars() {
       err := godotenv.Load("credentials.env")
       if err != nil {
               log.Fatal("Error loading .env file")
       }
}

func homePage(w http.ResponseWriter, r *http.Request) {
       log.Println("Serving home page for " + r.RemoteAddr + " calling: " + r.Host + r.URL.Path)
       http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
}

func handleRequests() {
       serverport := os.Getenv("SERVER_PORT")
       log.Println("Starting EAN server at http://*:"+serverport+"/")
       log.Println("Quit the server with CONTROL-C.")
       myRouter := mux.NewRouter().StrictSlash(true)
       myRouter.HandleFunc("/", homePage)
       //myRouter.HandleFunc("/new-product", createNewProduct).Methods("POST")
       myRouter.HandleFunc("/product/{query:(?:ean|id)}/{id}", returnSingleProduct)
       myRouter.NotFoundHandler = http.HandlerFunc(Handle404)
       log.Fatal(http.ListenAndServeTLS(":"+serverport, "server.crt", "server.key", myRouter))
}

func Handle404(w http.ResponseWriter, r *http.Request) {
       // Handle 404
       log.Println("Serving 404 for " + r.RemoteAddr + " calling: " + r.Host + r.URL.Path)
       http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
}

func createNewProduct(w http.ResponseWriter, r *http.Request) {
       //Since I moved to Productview this needs a alot of fixing
       // get the body of our POST request
       // return the string response containing the request body
       reqBody, _ := ioutil.ReadAll(r.Body)
       var product Productview
       json.Unmarshal(reqBody, &product)
       db.Create(&product)
       log.Println("Endpoint Hit: Creating New Product")
       json.NewEncoder(w).Encode(product)
}

func returnSingleProduct(w http.ResponseWriter, r *http.Request) {
       vars := mux.Vars(r)
       id := vars["id"]
       query := vars["query"]
       product := Productview{}
       // TODO add context and logging with request IDs across handleers and sessions
       log.Println("Serving SingleProduct for " + r.RemoteAddr + " with " + query + "=" + id)

       var err error

       switch query {
       case
               "ean",
               "id":
               err = db.Where(query+" = ?", id).First(&product).Error
       default:
               err = gorm.ErrRecordNotFound
       }
       if err != nil {
               log.Println(err)
               if gorm.IsRecordNotFoundError(err) {
                       http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
               } else {
                       http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)

               }
       } else {
               json.NewEncoder(w).Encode(product)
       }
}


func main() {
       getEnvVars()
       dbuser := os.Getenv("DATABASE_USER")
       dbpass := os.Getenv("DATABASE_SECRET")
       dbname := os.Getenv("DATABASE_NAME")

       db, err = gorm.Open("mysql", dbuser+ ":" + dbpass + "@tcp(127.0.0.1:3306)/" + dbname + "?charset=utf8&parseTime=True")
       defer db.Close()

       //log.SetPrefix(time.Now().Format("2006-01-02 15:04:05"))
       if err != nil {
               log.Fatal("DB Connection Failed to Open")
       } else {
               log.Println("DB Connection Established")
       }
       //db.AutoMigrate(&Product{})

       handleRequests()

}

