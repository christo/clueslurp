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

## Idea for programmatic interactive control

In the beforetime there was a program called `expect` which was good for driving
interactive consoles with stuff like sending characters, waiting to receive
certain input and some other programming-language-like stuff. What follows is an
idea for a minimalist system with a similar design.

MINI SPOILER: In the contest, the first thing you realise when you boot the VM
is that there are various user accounts that you have to login as in the virtual
machine in order to discover the component puzzles. So you want to login as
a specific user, interact, possibly capture output or send input read from
a file or from executing a child process and then exit.

A few implementation ideas:

* A config file for this filter which can drive the interaction,
  enabling programmatic automation.
* An API which can be used in `GHCi`.
* Use socat or something clever Modify the filter to provide a server socket over which programmatic
  interaction can
  be tapped by possibly multiple programs independently

### Config Command Language

Config file for driving the console interaction, format consists of the
following syntax.

* lines prefixed with `#` and blank lines are ignored in processing
* don't make parsing harder by accidentally making white space significant
* if there is something similar that already exists us that instead,
  possibly a mini language that is more general but which could be easily
  adapted to the character-oriented filter situation?

```ebnf
line 
  : '#' text 
  | cmd
cmd  
  : output
  | await_literal
  | await_regex
  | await_negated_regex
  | set_variable
output 
  : '>' text
await_literal
  : '<' text
await_regex
  : '/' regex
await_negated_regex
  : '^' regex
regex
  : text ['/' regex_options]
set_variable
  : '=' name value_expression
value_expression
  : regex_capture_group
  | 

```

Maybe it would be cool to implement the functionality of the filter in this more
general language. Need to be able to specify an action like append a line that
matches a regex to a file.

The config for this might look something like the following. Match a publication
regex and if found, append the whole match to the file with the given name.
Indentation is for human only.:

```console
# open paren groups trigger followed by sequence of actions
# regex capture group $0 is whole match
(
# look for publications
/ <publication_regex>
  # append whole match to file with given name
  + $0 "publications.txt"
)
```

Other commands could be:

* `f filename` start capturing output to file
* `F filename` start capturing output to file in append mode
* `r filename` send content of file as guest's stdin
* `! command` send output of running command (variable substitution...)
* `s float` sleep float seconds`
* `x` close stream, exit
* `d filename dest` download filename to host dest using `umix` facility
* `u filename dest` upload host filename to `umix` dest using `umix` facility
* Macro facility?
* parenthetic command grouping?

Could have predefined variables like current user, command history, runtime etc.

Can some hacked up script and `socat` cover this sort of feature set without all this implementation
work?