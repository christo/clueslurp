# clueslurp

Transparent filter for `stdin` and `stdout` that collects lines consisting of a *Cult
of the Bound Variable* encrypted publication strings that appear in the output of
running the [ICFP-2006](http://boundvariable.org) __Universal Machine__ and
stores them in a file whose name is specified as the only command line argument.

Pipe the output of the um into it, e.g.:

```shell
rum main.um | clueslurp cbvpubs.txt
```

Note that duplicates are not removed yet so in the mean time use this:

```shell
sort cbvpubs.txt |uniq >cbvpubs-unique.txt
```
