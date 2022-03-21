

# Recommendations
## Runtime environment
LÖVE 0.11.x

## luarocks
lsqlite3complete  


# Known bugs
## event
listet events are not executet in main thread.

## UT
tostring is displays numbers in a table as string.

## shared
shared tables are not iterable using pairs or ipairs function. This is not fixable until löve uses lua5.2+.

local references to a shared table get not updatet properly in some cases. you should always work with env.shared directly.