import jester, asyncdispatch
import json, strutils

import norm/[model, sqlite]

let dbConn = open(":memory:", "", "", "")

proc messageJson(msg: string): string =
  """{"message": $#}""" % [msg]

type
  User* = ref object of Model
    firstName*, lastName*, phoneNumber*, email*: string

proc createUser(firstName: string = "", lastName: string = "", phoneNumber: string = "", email: string = ""): User =
  User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
  

routes:
  get "/users":
    var users = @[createUser()]
    dbConn.select(users, "User.firstName = ?", @"firstName")
    resp %*users

  post "/createUser":
    dbConn.createTables(createUser())
    let body = try: request.body.parseJson
                except: newJNull()

    if body.isNil:
      resp(Http500, messageJson("invalid json"), contentType="application/json")
      
    var user: User = User(
      firstName: body["firstName"].getStr(),
      lastName: body["lastName"].getStr(),
      phoneNumber: body["phoneNumber"].getStr(),
      email: body["email"].getStr()
    )

    dbConn.insert(user)
    resp(Http201, messageJson("User Created"), contentType="application/json")

runForever()
