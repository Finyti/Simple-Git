SSM - simple snapshot manager
A simple git-like system, that allows to use most basic git porcelain commands.

## Outcomes

### 1. User capabilities

* User can Initialize a repo
* User can add/remove files from index
* User can commit
* User can revert commits
* User can branch 
* User can merge 
* User can tag (simple and annotated)
* User can ignore files

* User has the ability to inspect properties of the repo

---

## Minimal implementation plan


### 1. Minimal user workflows:
    a.
    1. User initializes an empty repo in new folder
    2. User adds a file to the repo folder
    3. User saves changes to index
    4. User commits changes without a message



### 2. MVP









---

## Second minimal implementation 

### 1. Second minimal user workflow

    b.
    1. User initializes repo in a populated folder
    2. User adds all of the files in the repo to the index
    3. User commits changes with a message
    4. User modifies a file
    5. User saves changes to index 
    6. User commits changes with a message

### 2. sMVP



---

## Architecture 

* CLI - determines what outcomes user wants

* Service - orchestrates work to make to fulfil that outcome

* Domain = core application Functionality, abstracted away From 
all implementation details (PnP).
    * Domain does not need to format data
    * Domain gets all its needs through args

* Repo - An abstraction over DB (Filesystem). Allows to make simple, understandable 
requests without caring how they are accomplished. Called by CLI for changes that 
are not a part of the domain (fe. FS init), and Domain when data is needed or a 
result of a core functionality needs internalizing.

* Formatting - serves the Repo, is an intermediate between Repo and FS