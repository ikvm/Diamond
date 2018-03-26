[Home](https://diamondmvc.github.io/Diamond/) | [Download](https://diamondmvc.github.io/Diamond/download) | [Documentation](https://diamondmvc.github.io/Diamond/docs) | [Tutorials](https://diamondmvc.github.io/Diamond/tutorials) | [Contributing](https://diamondmvc.github.io/Diamond/contributing)

<br>

[![OS](https://img.shields.io/badge/os-windows%20%7C%20linux%20%7C%20macos-ff69b4.svg)](http://code.dlang.org/packages/diamond)
[![LOC](https://img.shields.io/badge/lines--of--code-6000%2B%20%7C%2010000%2B-yellow.svg)](http://code.dlang.org/packages/diamond)
[![Dub version](https://img.shields.io/dub/v/diamond.svg)](http://code.dlang.org/packages/diamond)
[![Dub downloads](https://img.shields.io/dub/dt/diamond.svg)](http://code.dlang.org/packages/diamond)
[![License](https://img.shields.io/dub/l/diamond.svg)](http://code.dlang.org/packages/diamond)

**Diamond** is a full-stack cross-platform  **MVC / Template Framework** written in the **D Programming Language**.

It's inspired by **ASP.NET** and uses **[vibe.d](http://vibed.org/)** for its backend, making **Diamond** a very powerful framework.

This site is only a temporary website until the actual website can be hosted.

## Feature Overview

|General Features|Data & Storage|Views & Frontend|Controllers|More|
|:---:|:---:|:---:|:---:|:---:|:---:|
| [Low Memory & CPU Consumption](#low-memory--cpu-consumption) | [ORM](#orm) | [Compile-time Parsing](#compile-time-parsing) | [Auto-mapping](#auto-mapping) | [Authentication](#authentication) |
| [MVC & HMVC](#mvc--hmvc) | [MySql ORM](#mysql-orm) | [Partial Views](#partial-views) | [View-integration](#view-integration) | [CSRF Protection](#csrf-protection) |
| [RESTful](#restful) | [Caching](#caching) | [Layouts](#layouts) | [Mandatory Actions](#mandatory-actions) | [Cryptography](#cryptography) |
| [Advanced Routing](#advanced-routing) | [Mongo](#mongo) | [Fast & Performant Rendering](#fast--performant-rendering) | [Version-control](#version-control) | [JSON/BSON](#jsonbson) |
| [ACL](#acl) | [Redis](#redis) | [Dynamic](#dynamic) | | [Asynchronous](#asynchronous) |
| [Cross-platform](#cross-platform) | [Request-context](#request-context) | [Any D Code Can Be Executed](#any-d-code-can-be-executed) | | [Fibers/Tasks](#fiberstasks) |
| [Website/Webapi Support](#websitewebapi-support) | [Cookies](#cookies) | [Sections](#sections) | | [Sharding](#sharding) |
| [i18n](#i18n) | [Sessions](#sessions) | [Flash-messages](#flash-messages) | | [Network Security & Restrictions](#network-security--restrictions) |
| | [Transactions](#transactions) | | | [Unittesting](#unit-testing) |
| |  | | | [Logging](#logging) |


## General Features

### Low Memory & CPU Consumption

Diamond uses vibe.d, which currently processes more requests than any other framework, as its backend. At the same time, Diamond is written in D and utilizes D's compile-time facilities, enabling it to keep as little overhead at run time as possible. Memory consumption is low, because Diamond doesn't store much more data in memory than requested, except for minimal session/cookie/request data. CPU consumption is kept to a minimum due to vibe.d's asynchronous fiber model.

### MVC & HMVC

Diamond has a full, integrated Model-view-controller implementation which is based on a similar design to ASP.NET. Implementing views, controllers and models is a striaghtforward concept in Diamond and made to feel as natural as possible.

[![MVC](https://diamondmvc.github.io/Diamond/images/mvc.jpg)](https://diamondmvc.github.io/Diamond/images/mvc.jpg)

### RESTful

Diamond can be RESTful if necessary. REST integration becomes very powerful & secure with the combination of ACL.

```
@HttpAction(HttpGet, "/product/{uint:productId}/") Status getProduct()
{
    auto productId = get!uint("productId");
    auto product = getProductFromDatabase(productId);

    return json(product);
}
```

```
@HttpAction(HttpPut, "/product/{uint:productId}/") Status insertOrUpdateProduct()
{
    auto productId = get!uint("productId"); // If the id is 0 then we'll insert, else we'll update.

    insertProductToDatabase(productId, view.client.json); // Normally you'll want to deserialize the json

    return jsonString(`{
        "success": true
    }`);
}
```

```
@HttpAction(HttpDelete, "/product/{uint:productId}/") Status deleteProduct()
{
    auto productId = get!uint("productId");

    deleteProductFromDatabase(productId);

    return jsonString(`{
        "success": true
    }`);
}
```

### Advanced Routing

Diamond allows for advanced routing with controller actions, which can be type-secure.

```
@HttpAction(HttpGet, "/<>/{uint:userId}/groups/{string:groupName}/") getUserGroup()
{
    auto userId = get!uint("userId");
    auto groupName = get!string("groupName");
    
    auto userGroup = getUserGroupFromDatabase(userId, groupName);
    
    return json(userGroup);
}
```

### ACL (Access Control List)

Diamond has a full-fledged, built-in ACL implementation. It allows for custom creation of roles and permissions-based control of resources. ACL can be combined with the built-in authentication, too.

```
auto administrators = addRole("administrators");

auto owner = addRole("owner", administrators);
auto superUser = addRole("super-user", administrators);
```

```
auto guest = addRole("guest")
  .addPermission("/", true, false, false, false) // Guests can view home page
  .addPermission("/user", true, true, false, false) // Guests can view user pages, as well register (POST)
  .addPermission("/login", true, true, false, false) // Guests can view login page, as well login (POST)
  .addPermission("/logout", false, false, false, false); // Guests cannot logout, because they're not logged in

auto user = addRole("user")
  .addPermission("/", true, false, false, false) // Users can view home page
  .addPermission("/user", true, false, true, false) // Users can view user pages, as well update user information (PUT)
  .addPermission("/login", false, false, false, false) // Users cannot view login page or login
  .addPermission("/logout", false, true, false, false); // Users can logout (POST)
```

### Cross-platform

Diamond supports all platforms supported by both vibe.d & D, including Windows, Linux, macOS/OSX, and more.

[![OS](https://img.shields.io/badge/os-windows%20%7C%20linux%20%7C%20macos-ff69b4.svg)](http://code.dlang.org/packages/diamond)

### Website/Webapi Support

Diamond has support for both writing websites and/or web APIs.

### i18n

i18n (Internationalization) can be used to localize Diamond applications for different languages and cultures.

```
import diamond.data.i18n; // Or just diamond.data

auto message = getMessage(client, "someMessage"); // Gets message from client ...
auto specificMessage = getMessage("en_us", "someMessage"); // Gets message from a specific language ...
```

```
<p>@=i18n.getMessage(client, "someMessage");</p>
<p>@=i18n.getMessage("en_us", "someMessage");</p>
```

```
@* Will show the flag depending on the client's language. *
<img src="@../public/images/flags/@=client.language;.png">
```

## Data & Storage

### ORM

Diamond has a built-in ORM (Diamond-db) which can be used to map customized data, e.g. other database-engines.

### MySql ORM

By default, Diamond has a built-in ORM for MySQL. It's very powerful since it's based on the native MySQL library.

```
module models.mymodel;

import diamond.database;

class MyModel : MySql.MySqlModel!"mymodel_table"
{
  public:
  @DbId ulong id;
  string name;

  this() { super(); }
}
```

### Caching

Diamond implements a lot of caching techniques behind the scenes. It also allows for custom caching of, e.g. expensive views.

[![Cache](https://diamondmvc.github.io/Diamond/images/cache.jpg)](https://diamondmvc.github.io/Diamond/images/cache.jpg)

### Mongo

Diamond has full integration with Mongo through vibe.d.

Source: http://vibed.org/docs#mongo

```
import vibe.d;

MongoClient client;

void test()
{
	auto coll = client.getCollection("test.collection");
	foreach (doc; coll.find(["name": "Peter"]))
		logInfo("Found entry: %s", doc.toJson());
}

shared static this()
{
	client = connectMongoDB("127.0.0.1");
}
```

### Redis

Diamond has full integration with Redis through vibe.d.

See: http://vibed.org/docs#redis

### Request-contexts

Diamond supports request contexts, which allow for each request to have any type of data carried with them anywhere in the application.

```
client.addContext("someString", "Hello World!");

...

auto someString = client.getContext!string("someString", "someString wasn't found!");
```

### Cookies

Diamond has a very user-friendly cookie API directly bound to the request's HTTP client.

```
client.cookies.create("myCookie", "Hello Cookie!", 60);

...

auto myCookie = client.cookies.get("myCookie");
```

### Sessions

Diamond supports sessions, which can share data and cached views between multiple requests from the same user/browser.

```
client.session.setValue("mySesionValue", "Hello Session!");

...

auto mySessionValue = client.session.getValue("mySessionValue");
```

### Transactions

Transactions allow for transactional memory management, as well as transactional database integration. They're useful for performing secure data transactions where invalid/incomplete data are unaffordable.

```
auto bob = new Snapshot!BankAccount(BankAccount("Bob", 200));
auto sally = new Snapshot!BankAccount(BankAccount("Sally", 0));

auto transaction = new Transaction!BankTransfer;
transaction.commit = (transfer)
{
    bob = BankAccount(bob.name, bob.money - transfer.money);
    sally = BankAccount(sally.name, sally.money + transfer.money);
    
    UpdateBankAccount(bob);
    UpdateBankAccount(sally);
};
transaction.success = (transfer)
{
    import diamond.core.io;
    
    print("Successfully transferred $%d from %s to %s", transfer.money, transfer.from, transfer.to);
    print("Bob's money: %d", bob.money);
    print("Sally's money: %d", sally.money);
};
transaction.failure = (transfer, error, retries)
{
    bob.prev(); // Goes back to the previous state of Bob's bank account
    sally.prev(); // Goes back to the previous state of Sally's bank account
    
    return false; // We don't want to retry ...
};

auto transfer = new Snapshot!BankTransfer(BankTransfer("Bob", "Sally", 100));
transaction(transfer);
```

## Views & Frontend

### Compile-time Parsing

Views are parsed at compile time and compiled into D classes that are executed at run time. This makes them very powerful; they don't have to be parsed on each request require only minimal processing.

### Partial Views

Partial views can easily be implemented by creating normal views and simply calling render functions from one view to render others.

```
@* In a view *

@:render("myPartialView");

...

@:render("myPartialView", "someSection");

...

@render!"myPartialView"(new MyPartialViewModel("something something"));
```

### Layouts

Views can use layout views, which allow for advanced layout techniques and view mixins.

layout.dd

```
@<doctype>
<html>
<head>
  <title>@<title></title>
</head>
<body>
  @<view>
</body>
</html>
```

home.dd

```
@[
  layout:
    layout
---
  route:
    home
---
  placeHolders:
    [
      "title": "Home"
    ]
]

The time is: <b>@=Clock.currTime();</b>
```

### Fast & Performant Rendering

Views are rendered fast, because most of their rendering is done at compile time.

### Dynamic

All views are dynamic and thus can render dynamic data.

```
<ul>
@:foreach (item; model.items) {
    <li>
        <b>@=item.name;</b>
    </li>
}
</ul>
```

### Any D Code Can Be Executed

Views allows for any type of D code to be executed with no restrictions. This includes class generation, templates, functions, and expressions directly in the view. This feature is very useful to generate powerful and fast dynamic data, since D is natively compiled, making execution times for the code in views very fast (on par with C and C++.)

```
    @:void b(T)(T item) {
        <strong>@=item;</strong>
    }
    @:b("Bold this");
```

### Sections

Diamond allows views to be split into multiple sections, which can allow for views to only be partially rendered. This is a feature that isn't seen in many other frameworks, especially not as such a clean and innovative implementation. It's a great help for, e.g. responsive designs.

view1:

```
@!phone:
<div class="phone">
    <p>Hello Phone!</p>
</div>

@!desktop:
<div class="desktop">
    <p>Hello Desktop!</p>
</div>
```

view2:

```
@:render("view1", "phone"); // Will render view1 with the phone section
@:render("view1", "desktop"); // Will render view1 with the desktop section
```
### Flash-messages

Flash-messages are useful to create notification messages in a website.

```
@:flashMessage("message1", "This message stays forever.", FlashMessageType.always);
@:flashMessage("message2", "This message dissappers after 10 seconds.", FlashMessageType.always, 10000);
@:flashMessage("message3", "This message is gone after your next refresh.", FlashMessageType.showOnce);
@:flashMessage("message4", "This message is gone after your next refresh and shows for 20 seconds.", FlashMessageType.showOnce, 20000);
```

## Controllers

### Auto-mapping

Controller actions are auto-mapped by their function definitions, which are declared with special attributes.

```
/// Route: /controller_or_view_route/GetSomething
@HttpAction(HttpGet) Status getSomething()
{
    auto someModel = getSomeModel();
    
    return json(someModel);
}
```

### View-integration

Controllers have direct access to the view that's calling them. They can also be shared between multiple views.

```
@HttpDefault defaultAction()
{
    view.model = getViewModel();
    
    return Status.success;
}
```

### Mandatory Actions

Controllers allow for mandatory actions, i.e. actions which are executed and must succeed on every request handled by a controller.

```
/// Called for all requests done to the controller.
@HttpMandatory Status isValidRequest()
{
    auto isValid = validateRequest(view.client);
    
    if (!isValid)
    {
        view.client.error(HttpStatus.badRequest);
    }
    
    return Status.success;
}
```
### Version Control

When building a new version of a web applications, you might want to version the project, allowing for both old and new APIs to be used. This is useful when you're trying to migrate an application from an old API to a new API, when the new API hasn't yet implemented all the features the old API has.

## More

### Authentication

Diamond has a fully integrated authentication API that can be combined with the ACL to create a strong and secure authentication implementation.

Login:

```
long loginTimeInMinutes = 99999;
auto userRole = getRole("user");

client.login(loginTimeinMinutes, userRole);
```

Logout:

```
client.logout();
```

```
if (client.role.name == "user")
{
    // Logged in as a user ...
}
else
{
    // Not logged in as a user ...
}
```

### CSRF Protection

CSRF Protection is built-in to Diamond and can easily be integrated with forms, as well as validated in an application's backend.

View:

```
@:clearCSRFToken();

<form>
@:appendCSRFTokenField("formToken");

@* other fields here *
</form>
```

Controller:

```
auto bankTransferModel = view.client.getModelFromJson!BankTransferModel;

import diamond.security;

if (!isValidCSRFToken(view.client, bankTransferModel.formToken, true))
{
    view.client.error(HttpStatus.badRequest);
}
```

### Cryptography

Cryptography is supported through vibe.d's dependency on Botan.

See: https://code.dlang.org/packages/botan/

### JSON/BSON

JSON & BSON are supported through vibe.d, but some high-level JSON support is implemented for better integration.

```
auto model = client.getModelFromJson!MyModel;
```

```
@HttpAction(HttpGet) Status getModel()
{
     return json(getMyModel());
}
```

```
@HttpAction(HttpGet) Status getRawJsonString()
{
    return jsonString(`{
        "message": "Hello World!",
        success: true
    }`);
}
```

### Asynchronous

Diamond requests are processed asynchrnously through vibe.d, making request processing fast and powerful. Actions, etc., can also be executed asynchronously using the API provided by vibe.d.

[![Async](http://vibed.org/images/feature_event.png)](http://vibed.org/features)

Source: http://vibed.org/features

### Fibers/Tasks

Fibers and tasks are supported through vibe.d allowing for very powerful and performant multithreading.

[![Fibers](http://vibed.org/images/feature_fibers.png)](http://vibed.org/features)

Source: http://vibed.org/features

### Sharding

Diamond supports multiple database systems such as MySQL, Mongo, and Redis, and integration with them can be done easily and without code complexity.

### Network Security & Restrictions

Network security and restrictions can easily be done per controller action/route, or globally for the whole application. This allows restricting certain areas of the application to e.g. a local network. This is very useful for internal administration websites that are hosted on the same server as a public website.

### Unit Testing

Unit testing is a must for enterprise development and must be implemented for an application to make sure everything works as it's supposed to. Unit testing in Diamond allows for the creation of specialized requests that can target certain areas of an application.

```
module unittests.test;

import diamond.unittesting;

static if (isTesting)
{
  class JsonResponse
  {
    string message;
    bool success;
  }

  @HttpTest("My first unittest") test()
  {
    testRequest("/home/test/100", HttpMethod.GET, (scope result)
    {
      assert(result.statusCode == HttpStatus.ok);

      auto foo = result.getModelFromJson!JsonResponse;

      assert(foo.success);
    });

    testRequest("/home/test/500", HttpMethod.GET, (scope result)
    {
      assert(result.statusCode == HttpStatus.ok);

      auto foo = result.getModelFromJson!JsonResponse;

      assert(!foo.success);
    });
  }
}
```


### Logging

Logging is useful to log information about requests, responses, errors etc. It's an essential tool for debugging enterprise applications.

```
log(LogType.error, (result)
{
    logToMSSQLDatabase(result); // Custom implementation to log to a MSSQL database.
});
```

```
logToFile(LogType.error, "errors.log");

...

logToFile(LogType.error, "errors.log",
(result)
{
    import diamond.core.io;
    print(result.toString()); // Prints the log out to the console as well ...
});
```

```
logToDatabase(LogType.error, "logs");

...

logToDatabase(LogType.error, "logs",
(result)
{
     import diamond.core.io;
     
     print("Logged '%s' to the database.", result.logToken);
});
```

## Join Diamond

You can join the development of Diamond at **[Github](https://github.com/DiamondMVC/Diamond/)**

You can also join the Diamond discussion at **[Discord](https://discord.gg/UTysCSH)**
