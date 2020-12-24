# resolving paths in require

```sh
$ export LUA_PATH="<path_to_directory>/?.lua" && lua <file>
```

or

```lua 
    package.path = package.path .. ";../../modules"
```
