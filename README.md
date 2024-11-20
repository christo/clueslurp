# clueslurp

Transparent filter for `stdin` and `stdout` that collects lines consisting of a cult
of the bound variable clue string and stores them in a file called
`cbvclues.txt`.

Pipe the output of the um into it, e.g.:

```shell
rum main.um | clueslurp
```

Note that duplicates are not removed yet so in the mean time use this:

```shell
sort cbvclues.txt |uniq >cbvclues-unique.txt
```
