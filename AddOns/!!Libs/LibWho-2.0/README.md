[![Build Status](https://travis-ci.org/sylvanaar/who-lib.svg?branch=master)](https://travis-ci.org/sylvanaar/who-lib)
![License](https://img.shields.io/github/license/sylvanaar/who-lib)
# LibWho-2.0

This documentation is for developers looking to utilize the World of Warcraft /who subsystem. The /who subsystem is a shared resource among all addons using it. By using this library, you will ensure that you do not conflict with other addons using the /who subsystem

This library provides the following:

* An Interface for a information's about an user
* Better event for who's
* Queuing of /who and SendWho()
* A much better who interface, with guarantee to be executed & callback

## Usage
There are two ways of using WhoLib: embedding into an object or using the library directly

### Embedded
    -- at the beginning of your addon
    LibStub:GetLibaray('LibWho-2.0'):Embed(self)

    -- call a function within an method:
    function mod:xxx(...)
    self:UserInfo(...)
    end

### External
    -- at the beginning of your addon
    local wholib = LibStub:GetLibrary('LibWho-2.0'):Library()

    -- call a function:
    wholib:UserInfo(...)

### Remarks
The examples in this documentation uses the embedded version, but it should be easy to adopt them to external.

## API Documentation

### lib:Embed(handler)
#### Args
    handler
       table - embed the public functions/constants in the object specified by handler
    Returns
       nil
#### Example
    LibStub:GetLibrary('LibWho-2.0'):Embed(self)
### lib:Library()
    Returns
        table - the library
    Example
        LibStub:GetLibrary('LibWho-2.0'):Library()
### :UserInfo(name [, opts])
#### Args
    name
        string - the exact name of an player
    opts
        optional, table - options
    opts.queue
        optional, number - queue of this query (see below) - .WHOLIB_QUEUE_QUIET (default) or .WHOLIB_QUEUE_SCANNING
    opts.timeout
        optional, number - if the the result is cached, and not older than opts.timeout minutes the cache will be returned, negative value: always use cache (if available), otherwise: send a who query, default: 5 (minutes)
    opts.callback, opts.handler
        optional, callback - see "Callback info" below
    opts.flags
        optional, number - one of more flags or'ed together, see Flags (bit.bor(flag1, flag2 [, flag3 [, ...]]))
    Returns
        nil if there was no appropriate cache
        false
        see Flags: `WHOLIB_FLAG_ALWAYS_CALLBACK`
    user, time
        for cached results
    user
        table - the user's information's
    user.Name
        string - name of the player
    user.Online
        true if online, false if offline, nil if unknown (more results than could be displayed)
    if Online is not true than all following entries will be from the last successful call, or nil
    user.Guild
        string - guild or ''
    user.Class
        string - class
    user.Race
        string - race
    user.Level
        string - level
    user.Zone
        string - zone
    time
        number - the minutes how old the data was
#### Remarks
If you're only interested in this feature, then you don't have to read about :Who() and WHOLIB_QUERY_RESULT.
Do not use .`WHOLIB_FLAG_ALWAYS_CALLBACK` when scanning a list over and over again, do a 5 sec pause after a cached return, cause you may have a short list and a cache time so high that all entries may be cached and in that case this function DO generate an almost infinite loop!

#### Callback
When a callback function is given and the function didn't returned immediately then the callback will be raised when they're a result. The callback function will receive the same arguments as :UserInfo() would return.

#### Flags
##### .`WHOLIB_FLAG_ALWAYS_CALLBACK`
if :UserInfo() would return the cached data, raise the callback immediately with that data instead returning and then return false
#### Example
        -- long version
        local user, time = self:UserInfo(friendsname, { callback = 'UserDataReturned' } )
        if user then
        -- the data was immediately available
        self:UserDataReturned(user, time)
        else
        -- nothing
        -- we will be called when the data is available
        end

        -- short version
        self:UserData(friendsname, { callback = 'UserDataReturned', flags = self.WHOLIB_FLAG_ALWAYS_CALLBACK } )

        -- callback function
        function mod:UserDataReturned(user, time)
        local state
        if user.Online == true then
            state = 'Online'
        elseif user.Online == false then
            state = 'Offline'
        else
            -- user.Online is nil
            state = 'Unknown'
        end
        DEFAULT_CHAT_FRAME:AddMessage(user.Name .. ' is ' .. state)
        end
### :CachedUserInfo(name)
#### Args
    name
        string - the exact name of an player
    Returns
        nil if there was no appropriate cache
    user, time
        for cached results identical to :UserInfo()
### :RegisterCallback(event, callback [,handler])
#### Args
    event
        string - the event you are want to be registered for
    callback, handler
        callback - see "Callback info" below
    Returns
        nil
#### Example
see "Events" below

### :Who(query [ , opts])
#### Args
    query
        string - the search string
    opts
        optional, table - options
    opts.queue
        optional, number - queue of this query (see below) - .`WHOLIB_QUEUE_QUIET` (default) or .`WHOLIB_QUEUE_USER` or .`WHOLIB_QUEUE_SCANNING`
    opts.callback, opts.handler
        optional, callback - see "Callback info" below
    Returns
        nil
#### Remarks
This is an event registration via CallbackHandler-1.0 Everything except query will be ignored when the queue is `.WHOLIB_QUEUE_USER`.
If you've already registered `WHOLIB_QUERY_RESULT` then you may be don't need a callback.

#### Callback
When a callback function is given then the callback will be raised after the query is executed. The callback function will receive the same arguments as the event `:WHOLIB_QUERY_RESULT` has.

#### Example
    self:Who({query = 'n-' .. friendsname, queue = self.`WHOLIB_QUERY_QUIET`, callback = 'DisplayPlayers'})
    -- self:DisplayPlayers is in the `WHOLIB_QUERY_RESULT` example below
#### Remarks
If you're only interested in the information of one player, use :UserInfo() instead. (You can set opts.timeout to 0 if you don't accept cached data.)

### Constants
.`WHOLIB_QUEUE_USER`
.`WHOLIB_QUEUE_QUIET`
.`WHOLIB_QUEUE_SCANNING`
.`WHOLIB_FLAG_ALWAYS_CALLBACK`

### Callback info
Some WhoLib functions accepts its own form of callbacks, or callbacks via CallbackHandler, you have always two ways using them.

#### Using a function
    callback
        function - just point to the function, which should be called
    handler
        nil - must be nil

#### Example 1
    local function eventmanager(event, a1, a2, ...)
    -- has no 'self'
    end

    wholib:RegisterCallback('WHOLIB_QUERY_RESULT', eventmanager)
#### Example 2
    function mod.eventmanager(event, a1, a2, ...)
    -- has no 'self'
    end

### wholib:RegisterCallback('WHOLIB_QUERY_RESULT', mod.eventmanager)
#### Using a method
    callback
        string - the name of the method, which should be called
    handler
        table - the object on which the method should be called, if nil the calling object is used
#### Example
    function mod:eventmanager(event, a1, a2, ...)
        -- has 'self'
    end

    mod:RegisterCallback('WHOLIB_QUERY_RESULT', 'eventmanager')
    -- is equivalent to
    wholib:RegisterCallback('WHOLIB_QUERY_RESULT', 'eventmanager', self)
## Events
### Event: `WHOLIB_QUERY_RESULT` - query, results, complete, name
#### Args
    query
        string - search string
    results
        table - table of results
    results[i].Name
        string - name of the player
    results[i].Online
        true if online, false if offline, nil if unknown (more results than could be displayed)
    results[i].Guild
        string - guild or ''
    results[i].Class
        string - class
    results[i].Race
        string - race
    results[i].Level
        string - level
    results[i].Zone
        string - zone
    complete
        boolean - shows whether all results could be returned (true) or not (false), if not, do a more specific query
    name
        string - if the query was initiated by a :UserInfo() call, then this is the player name of the :UserInfo() call, otherwise nil
#### Remarks
All these fields are returned when any one call "/who" "SendWho()" or :Who(), even when the results are displayed in the chat.

#### Example
    function mod:OnEnable()
    ...
    self:RegisterCallback('WHOLIB_QUERY_RESULT', 'DisplayPlayers')
    ...
    end

    function mod:DisplayPlayers(query, results, complete)
    if not complete then
        DEFAULT_CHAT_FRAME:AddMessage('There were more Players than here shown!')
    end
    for _,result in pairs(results) do
        DEFAULT_CHAT_FRAME:AddMessage('Player ' .. result.Name .. ' is currently in ' .. result.Zone)
    end
    end
## Queues
### `WHOLIB_QUEUE_USER`
Used on user queries (e.g. "/who", SocialFrame's Who)
Will display the results in chat if only some, or in who-frame if more.

### `WHOLIB_QUEUE_QUIET`
Should be standard queue for addon queries, which aren't for scanning, and do not result in a user action: use .`WHOLIB_QUEUE_USER`.
Will neither show chat messages nor who-frame.
Will be slowly queried while the WhoFrame is open. (TODO)

### `WHOLIB_QUEUE_SCANNING`
Use for scanning.
Will neither show chat messages nor who-frame.
Will not be queried while the WhoFrame is open. (TODO)

#### Remarks
At first the .`WHOLIB_QUEUE_USER` queries will be executed, then the .`WHOLIB_QUEUE_QUIET` and at last the .`WHOLIB_QUEUE_SCANNING`.

## Debug
When debugging is enabled then the chat will be filled with added/returned entries, one for each query.

21:01:40 WhoLib: [3] added "n-Lager", queues=0, 0, 1
21:01:40 WhoLib: [3] returned "n-Lager", total=0, queues=0, 0, 0
The [3] means Queue 3 = `WHOLIB_QUEUE_SCANNING`, each query will at first be "added" and later "returned", on returned queries the total number of entries will also be printed. The "queues=0, 0, 1" means that 0 queries are in the .`WHOLIB_QUEUE_USER` queue, 0 in .`WHOLIB_QUEUE_QUIET`, and 1 (the added one) in .`WHOLIB_QUEUE_SCANNING`.
For :UserInfo() even more entries will be printed.

### :SetWhoLibDebug(state)
#### Args
    state
        boolean - Enables or disables the debugging
    Returns
        nil

`/wholibdebug`
Toggles the debugging.
