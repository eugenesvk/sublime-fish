#! SYNTAX TEST "Packages/sublime-fish-shell-improved/fish.tmLanguage"

# If using fish to test parsing of this file, all invalid illegal tokens and their tests must be temporarily removed

;
#! <- keyword.operator
&
#! <- invalid.illegal.operator
|
#! <- invalid.illegal.operator
\
#! <- constant.character.escape

echo --arg -arg arg ; echo arg # comment
#! <- variable.function
#! ^^^^^^^^^^^^^^^^  meta.function-call
#!   ^^^^^ meta.argument
#!         ^^^^ meta.argument
#!              ^^^ meta.argument
#!                  ^ keyword.operator
#!                    ^^^^ variable.function
#!                    ^^^^^^^^ meta.function-call
#!                             ^ punctuation.definition.comment
#!                             ^^^^^^^^^ comment.line.insert

echo arg & # comment
#!       ^ keyword.operator
#!         ^ comment.line

echo 'single-quoted' "double-quoted" unquoted
#!   ^^^^^^^^^^^^^^^ string.quoted.single
#!                   ^^^^^^^^^^^^^^^ string.quoted.double
#!                                   ^^^^^^^^ meta.string.unquoted

# The ~ and % are only special characters in need of escaping when at the front of arguments
echo ~foo \~bar~\~ %foo \%bar%\%
#!   ^^^^ meta.string.unquoted
#!   ^ keyword.operator.tilde
#!        ^^^^^^^^ meta.string.unquoted
#!        ^^ constant.character.escape
#!                 ^^^^ meta.process-expansion
#!                      ^^^^^^^^ meta.string.unquoted
#!                      ^^ constant.character.escape

echo ~/foo/*.bar /**.bar foo.?\?r ***.bar foo/*\**
#!   ^^^^^^^^^^^ meta.string.unquoted
#!   ^ keyword.operator.tilde
#!         ^ keyword.operator.single-star
#!               ^^^^^^^ meta.string.unquoted
#!                ^^ keyword.operator.double-star
#!                       ^^^^^^^^ meta.string.unquoted
#!                           ^ keyword.operator.question-mark
#!                            ^^ constant.character.escape
#!                                ^^^^^^^ meta.string.unquoted
#!                                ^^ keyword.operator.double-star
#!                                  ^ keyword.operator.single-star
#!                                        ^^^^^^^^ meta.string.unquoted
#!                                            ^ keyword.operator.single-star
#!                                             ^^ constant.character.escape
#!                                               ^ keyword.operator.single-star

echo str\a str\x12345 str\X12345 str\012345
#!   ^^^^^ meta.string.unquoted
#!      ^^ constant.character.escape
#!            ^^^^ constant.character.escape
#!                       ^^^^ constant.character.escape
#!                                  ^^^^ constant.character.escape

echo str\u01a2345 str\U01a2b3c45 str\cab
#!   ^^^^^^^^^^^^ meta.string.unquoted
#!      ^^^^^^ constant.character.escape
#!                   ^^^^^^^^^^ constant.character.escape
#!                                  ^^^ constant.character.escape

echo str\
#!   ^^^^^ meta.string.unquoted
#!      ^^ constant.character.escape
ing # comment
#! <- meta.string.unquoted
#!  ^^^^^^^^^ comment.line.insert

echo str1 2 3str -b="str" --num=2
#!   ^^^^ meta.string.unquoted
#!        ^ meta.string.unquoted constant.numeric
#!          ^^^^ meta.string.unquoted
#!               ^^^ meta.string.unquoted
#!                  ^^^^^ string.quoted.double
#!                        ^^^^^^ meta.string.unquoted
#!                              ^ meta.string.unquoted constant.numeric

echo str \ # not-comment \  # comment
#!   ^^^ meta.string.unquoted
#!       ^^^ meta.string.unquoted
#!       ^^ constant.character.escape
#!                       ^^ meta.string.unquoted constant.character.escape
#!                          ^^^^^^^^^ comment.line.insert

echo arg \ arg \
#! <- variable.function
#! ^^^^^^^^^^^^^ meta.function-call
#!   ^^^ meta.argument
#!       ^ meta.argument
#!             ^ constant.character.escape
  # comment
#! <- comment.line
arg arg # comment
#! <- meta.function-call meta.argument
#! ^^^^ meta.function-call
#!  ^^^ meta.function-call meta.argument
#!      ^ comment.line.insert

echo arg (echo "inner" arg) outer arg
#!       ^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!       ^ punctuation.section.parens.begin
#!        ^^^^^^^^^^^^^^^^ meta.function-call
#!                        ^ punctuation.section.parens.end
#!                          ^ meta.function-call

foo\ bar arg
#! ^^^^^ variable.function

'foo bar' arg
#! ^^^^^^ variable.function

"foo bar" arg
#! ^^^^^^ variable.function

f''o"o"\ ''b""ar arg
#! ^^^^^^^^^^^^^ variable.function

f'\''o"\$\\"o\ \|\$\*b\?\%a\#\(r\) arg
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.function

\\foo arg
#! <- variable.function
#! ^^ variable.function

# Some valid function names are very strange
\ \
#! <- variable.function
  arg
#! ^^ meta.argument

'\'\\'"\"\$\\"\a\b\e\f\n\r\t\v\ \$\\\*\?~\~%\%#\#\(\)\{\}\[\]\<\>^\^\&\|\;\"\'\x0a\X1b\01\u3ccc\U4dddeeee\c?
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.function

%process
#! <- invalid.illegal.operator

<in.log
#! <- invalid.illegal.operator

>out.log
#! <- invalid.illegal.operator

^err.log
#! <- invalid.illegal.operator

-option
#! <- invalid.illegal.function

echo one >out.log two < in.log three ^^err.log four4> out.log five
#!       ^^^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!        ^^^^^^^ meta.path
#!                ^^^ meta.argument
#!                    ^^^^^^^^ meta.function-call.redirection
#!                    ^ keyword.operator
#!                      ^^^^^^ meta.path
#!                                   ^^^^^^^^^ meta.function-call.redirection
#!                                   ^^ keyword.operator
#!                                     ^^^^^^^ meta.path
#!                                             ^^^^^ meta.argument
#!                                                  ^^^^^^^^^ meta.function-call.redirection
#!                                                  ^ keyword.operator
#!                                                    ^^^^^^^ meta.path
#!                                                            ^^^^ meta.argument

echo one 1>err.log two 2^err.log three^four five^6 7>? \
#!       ^^^^^^^^^ meta.function-call.redirection
#!       ^ constant.numeric.file-descriptor
#!        ^ keyword.operator
#!         ^^^^^^^ meta.path
#!                 ^^^ meta.argument
#!                     ^^^^^^^^^ meta.argument
#!                               ^^^^^^^^^^ meta.argument
#!                                          ^^^^^^ meta.argument
#!                                                 ^^^^^^ meta.function-call.redirection
#!                                                 ^ constant.numeric.file-descriptor
#!                                                  ^^ keyword.operator
  out.log 8<? "in.log" nine
#!^^^^^^^ meta.path
#!        ^^^^^^^^^^^^ meta.function-call.redirection
#!        ^ constant.numeric.file-descriptor
#!         ^^ keyword.operator
#!            ^^^^^^^^ meta.path
#!                     ^^^^ meta.argument

echo one ^err.log^'log' >out.log<in.log < \?in.log > ?out.log
#!       ^^^^^^^^^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!        ^^^^^^^^^^^^^ meta.path
#!                      ^^^^^^^^^^^^^^^ meta.function-call.redirection
#!                      ^ keyword.operator
#!                       ^^^^^^^ meta.path
#!                              ^ keyword.operator
#!                               ^^^^^^ meta.path
#!                                      ^^^^^^^^^^ meta.function-call.redirection
#!                                      ^ keyword.operator
#!                                        ^^^^^^^^ meta.path
#!                                                 ^^^^^^^^^^ meta.function-call.redirection
#!                                                 ^ keyword.operator
#!                                                   ^^^^^^^^ invalid.illegal.path

echo one >? 1 >? 2<in.log
#!       ^^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!          ^ meta.path
#!            ^^^^^^^^^^^ meta.function-call.redirection
#!            ^^ keyword.operator
#!               ^^^^^^^^ invalid.illegal.path

echo one > $file <? (echo in.log) >{a,b} ^ \
#!       ^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!         ^^^^^ variable.other
#!               ^^^^^^^^^^^^^^^^ meta.function-call.redirection
#!               ^^ keyword.operator
#!                  ^^^^^^^^^^^^^ meta.parens.command-substitution
#!                                ^^^^^^ meta.function-call.redirection
#!                                ^ keyword.operator
#!                                 ^^^^^ meta.path
#!                                       ^^^^ meta.function-call.redirection
#!                                       ^ keyword.operator
#!                                         ^^ constant.character.escape
  "err.log"
#! <- meta.function-call.redirection
#! ^^^^^^^^ meta.path

echo one ^&2 two three3>&4 four 5>& \
#!       ^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!         ^ constant.numeric.file-descriptor
#!               ^^^^^ meta.argument
#!                     ^^^ meta.function-call.redirection
#!                     ^^ keyword.operator
#!                       ^ constant.numeric.file-descriptor
#!                              ^^^^^ meta.function-call.redirection
#!                              ^ constant.numeric.file-descriptor
#!                               ^^ keyword.operator
  - six 7<&->out.log 2> &1
#!^ keyword.operator.redirection.close
#!  ^^^ meta.argument
#!      ^^^^ meta.function-call.redirection
#!      ^ constant.numeric.file-descriptor
#!       ^^ keyword.operator
#!         ^ keyword.operator.redirection.close
#!          ^^^^^^^^ meta.function-call.redirection
#!          ^ keyword.operator
#!           ^^^^^^^ meta.path
#!                   ^^^^^ meta.function-call.redirection
#!                   ^ constant.numeric.file-descriptor
#!                    ^ keyword.operator
#!                      ^^ invalid.illegal.path

echo one >&1>?two<&2>&4five
#!       ^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!         ^ constant.numeric.file-descriptor
#!          ^^^^^ meta.function-call.redirection
#!          ^^ keyword.operator
#!            ^^^ meta.path
#!               ^^^ meta.function-call.redirection
#!               ^^ keyword.operator
#!                 ^ constant.numeric.file-descriptor
#!                  ^^^^^^^ meta.function-call.redirection
#!                  ^^ keyword.operator
#!                    ^^^^^ invalid.illegal.file-descriptor

echo (echo one \
#!   ^^^^^^^^^^^ meta.parens.command-substitution
#!             ^ constant.character.escape
two three # comment
#!        ^ comment.line.insert
# comment
#! <- comment.line
echo four \
#! <- variable.function
#! ^^^^^^ meta.parens.command-substitution
five six # tricky comment \
echo seven
#! <- variable.function
)
#! <- meta.parens.command-substitution

echo ( \
#!     ^ constant.character.escape
;  &
#! <- keyword.operator
#! ^ invalid.illegal.operator
echo &
#! <- meta.function-call
)  &  & hmm
#! ^ keyword.operator
#!    ^ invalid.illegal.operator

echo ( # comment
#!    ^^^^^^^^^^ comment.line
)

echo foo(echo -e nar\nbar)[2] f(echo oo)\[bar]
#!      ^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!                        ^^^ meta.brackets.index-expansion
#!                        ^ punctuation.section.brackets.begin
#!                          ^ punctuation.section.brackets.end
#!                                      ^^ constant.character.escape

foo\  # comment
#! ^^ variable.function

foo\ bar
#! ^^^^^ variable.function

exec echo \
#! <- meta.function-call.meta support.function
#!   ^^^^ meta.function-call.meta variable.function
arg
#! <-meta.function-call.meta meta.argument
#! ^ meta.function-call.meta

builtin echo &
#! <- meta.function-call.meta support.function
#!      ^^^^ meta.function-call.meta variable.function
#!           ^ keyword.operator

builtin echo arg ; and echo arg
#! <- meta.function-call.meta support.function
#!      ^^^^ meta.function-call.meta variable.function
#!           ^^^ meta.function-call.meta meta.argument
#!               ^ keyword.operator
#!                 ^^^ meta.function-call.statement keyword.operator.word
#!                     ^^^^ meta.function-call.statement variable.function
#!                          ^^^ meta.argument

command  \
#! <- meta.function-call.meta support.function
#!       ^ constant.character.escape
echo  \
#! <- meta.function-call.meta variable.function
arg & # comment
#! <-meta.function-call.meta meta.argument
#!    ^ comment.line
echo arg
#! <- meta.function-call.standard variable.function

command  &
#! <- meta.function-call.standard variable.function
echo arg &
#! <-meta.function-call.standard variable.function

not \
#! <- meta.function-call.statement keyword.operator.word
command \
#! <- meta.function-call.statement support.function
echo \
#! <- meta.function-call.statement variable.function
arg \
#! <- meta.function-call.statement meta.argument
&
#! <- meta.function-call.statement keyword.operator

not builtin case 1>/dev/null
#! <- meta.function-call.statement keyword.operator.word
#!  ^^^^^^^ meta.function-call.statement support.function
#!          ^^^^ meta.function-call.statement variable.function
#!               ^^^^^^^^^^^ meta.function-call.redirection

exec %fish
#! <- meta.function-call.meta support.function
#!   ^^^^^ meta.function-call.meta invalid.illegal.operator

and case; or %fish
#! <- meta.function-call.statement keyword.operator.word
#!  ^^^^ meta.function-call.statement variable.function
#!      ^ keyword.operator
#!        ^^ meta.function-call.statement keyword.operator.word
#!           ^^^^^ meta.function-call.statement invalid.illegal.operator

echo arg | cat
#! <- meta.function-call.standard variable.function
#!       ^ meta.function-call.standard keyword.operator
#!         ^^^ meta.function-call.standard variable.function

echo \
#! <- meta.function-call.standard variable.function
arg \
# comment
| \
#! <- meta.function-call.standard keyword.operator
cat \
#! <- meta.function-call.standard variable.function
| \
#! <- meta.function-call.standard keyword.operator
cat \
#! <- meta.function-call.standard variable.function
arg
#! <- meta.function-call.standard meta.argument

echo (echo arg |) | cat
#!             ^ meta.function-call.standard meta.function-call.standard invalid.illegal.operator
#!                ^ meta.function-call.standard keyword.operator

echo arg | # bad text
#!       ^ meta.function-call.standard keyword.operator
#!         ^^^^^^^^^^ meta.function-call.standard invalid.illegal.function

and echo arg | %fish
#!           ^ meta.function-call.statement keyword.operator
#!             ^^^^^ meta.function-call.statement invalid.illegal.operator

not echo arg | | arg ; # comment
#!           ^ meta.function-call.statement keyword.operator
#!             ^^^^^^^^^^^^^^^^^ meta.function-call.statement invalid.illegal.operator

and and | cat
#! <- meta.function-call.statement keyword.operator.word
#!  ^^^ meta.function-call.statement keyword.operator.word
#!      ^^^^^ meta.function-call.statement invalid.illegal.operator

echo arg1 ; and echo arg2 & not echo arg3 | cat
#! <- meta.function-call.standard variable.function
#!          ^^^ meta.function-call.statement keyword.operator.word
#!              ^^^^ meta.function-call.statement variable.function
#!                        ^ keyword.operator
#!                          ^^^ meta.function-call.statement keyword.operator.word
#!                              ^^^^ meta.function-call.statement variable.function
#!                                        ^ keyword.operator
#!                                          ^^^ meta.function-call.statement variable.function

or echo arg1 | command cat
#! <- meta.function-call.statement keyword.operator.word
#! ^^^^ meta.function-call.statement variable.function
#!           ^ keyword.operator
#!             ^^^^^^^ meta.function-call.statement support.function
#!                     ^^^ meta.function-call.statement variable.function

builtin \
#! <- meta.function-call.meta support.function
true | cat
#! <- meta.function-call.meta variable.function
#!   ^ meta.function-call.meta keyword.operator
#!     ^^^ meta.function-call.meta variable.function

echo "string"(echo "inner string")" outer string"
#!           ^^^^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!                                ^ string.quoted

echo $var $ $$"str" $var $$var $
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!        ^ invalid.illegal.variable-expansion
#!          ^^ variable.other
#!          ^ punctuation.definition.variable
#!           ^ invalid.illegal.variable-expansion
#!            ^^^^^ string.quoted
#!                  ^^^^ variable.other
#!                       ^^^^^ variable.other
#!                       ^^ punctuation.definition.variable
#!                        ^^^^ variable.other variable.other
#!                             ^ invalid.illegal.variable-expansion

echo $var$ (echo $) $$!bad_var # comment
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!       ^ invalid.illegal.variable-expansion
#!               ^ invalid.illegal.variable-expansion
#!                   ^^^^^^^^^ invalid.illegal.variable-expansion
#!                             ^^^^^^^^^ comment.line

echo $var[1..$foo]
#!   ^^^^ variable.other
#!       ^^^^^^^^^ meta.brackets.index-expansion
#!        ^ constant.numeric
#!         ^^ keyword.operator
#!           ^^^^ variable.other

echo $var $var[$var[1 $var[1]] $var[1..2]] "str"
#!   ^^^^ variable.other
#!        ^^^^ variable.other
#!                  ^ meta.brackets.index-expansion meta.brackets.index-expansion
#!                    ^^^^ meta.brackets.index-expansion meta.brackets.index-expansion variable.other
#!                                         ^^^^^ string.quoted

echo $$var[ 1 ][ 1 ]
#!   ^^^^^^^^^^^^^^^ meta.variable-expansion
#!    ^^^^ variable.other
#!        ^^^^^ meta.brackets.index-expansion
#!             ^^^^^ meta.brackets.index-expansion

echo $var[(echo 1)] $var["2"] "str"
#!   ^^^^ variable.other
#!       ^^^^^^^^^^ meta.brackets.index-expansion
#!        ^^^^^^^^  meta.parens.command-substitution
#!                       ^^^ string.quoted
#!                            ^^^^^ string.quoted

echo 'str$str\$str\'str\\"str"'
#!   ^ string.quoted.single punctuation.definition.string.begin
#!    ^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.single
#!                ^^ constant.character.escape
#!                     ^^ constant.character.escape
#!                            ^ string.quoted.single punctuation.definition.string.end

# This is to test that single-quoted strings always include newlines
echo 'str\
str
'
#! <- string.quoted.single punctuation.definition.string.end

echo "str$var\$str\"str\\'str'"
#!   ^ string.quoted.double punctuation.definition.string.begin
#!    ^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.double
#!       ^^^^ variable.other
#!       ^ punctuation.definition.variable
#!           ^^ constant.character.escape
#!                ^^ constant.character.escape
#!                     ^^ constant.character.escape
#!                            ^ string.quoted.double punctuation.definition.string.end

# This is to test that double-quoted strings can escape newlines
echo "str\
str
"
#! <- string.quoted.double punctuation.definition.string.end

echo $var{,'brace',"expansion",he{e,$e}re\,}"str"
#!   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.string.unquoted
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!       ^ punctuation.section.braces.begin
#!        ^ punctuation.section.braces.separator
#!                ^ punctuation.section.braces.separator
#!                            ^ punctuation.section.braces.separator
#!                               ^ punctuation.section.braces.begin
#!                                 ^ punctuation.section.braces.separator
#!                                  ^^ variable.other
#!                                    ^ punctuation.section.braces.end
#!                                       ^^ constant.character.escape
#!                                         ^ punctuation.section.braces.end
#!                                          ^^^^^ string.quoted

echo %"fish" one%two %%percent
#!   ^^^^^^^ meta.process-expansion
#!   ^ punctuation.definition.process
#!    ^^^^^^ meta.string.unquoted
#!           ^^^^^^^ meta.string.unquoted
#!                   ^^^^^^^^^ meta.process-expansion
#!                   ^ punctuation.definition.process
#!                    ^^^^^^^^ meta.string.unquoted

echo %self foo %(set foo "fi"; echo $foo)sh "bar"
#!   ^^^^^ meta.process-expansion
#!   ^ punctuation.definition.process
#!         ^^^ meta.string.unquoted
#!             ^ punctuation.definition.process
#!              ^^^^^^^^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!                                       ^^ meta.process-expansion
#!                                          ^^^^^ string.quoted

echo $var(echo str{$arg}str "{$var}")$var"str"$var
#!   ^^^^ variable.other
#!                 ^^^^ variable.other
#!                          ^^^^^^^^ string.quoted

echo -n --switch=(echo "str;";);
#!   ^^ meta.argument
#!      ^^^^^^^^^^^^^^^^^^^^^^^ meta.argument
#!                         ^ string.quoted
#!                           ^ keyword.operator
#!                             ^ keyword.operator

echo --switch=(echo "str;";
#!   ^^^^^^^^^^^^^^^^^^^^^^^ meta.argument
#!                      ^ string.quoted
#!                        ^ keyword.operator
  echo test \
#!   ^^^^^^^^^ meta.argument
#!          ^ constant.character.escape
    &
#!  ^ keyword.operator
#!   ^ meta.argument
)  ;
#! ^ keyword.operator

while --help; break& end
#! <- meta.function-call.standard variable.function
#!    ^^^^^^ meta.argument
#!          ^ keyword.operator
#!            ^^^^^ variable.function
#!                   ^^^ invalid.illegal.function

begin
#! <- meta.block.begin keyword.control.conditional
  while echo arg
#! ^^^^ meta.block.while keyword.control.conditional
#!      ^^^^^^^^^ meta.function-call.standard
    echo arg
#   ^^^^^^^^ meta.function-call.standard
    break ;
#!  ^^^^^ keyword.control.conditional
#!        ^ keyword.operator
  end ;
#! ^^ keyword.control.conditional
#!    ^ keyword.operator
  break;
#! ^^^^ variable.function
end &
#! <- keyword.control.conditional
#!  ^ keyword.operator

begin end
#! <- meta.block.begin keyword.control.conditional
#!    ^^^ keyword.control.conditional

begin
end; or begin
#! ^ keyword.operator
#!      ^^^^^ meta.block.begin keyword.control.conditional
end
#! <- keyword.control.conditional

if echo arg
#! <- meta.block.if keyword.control.conditional
  and echo arg
  echo arg
else if echo arg
#! <- keyword.control.conditional
#!   ^^ keyword.control.conditional
  and echo arg
  echo arg
else # comment
#! <- keyword.control.conditional
#!   ^^^^^^^^^ comment.line
  echo arg
  if echo arg
    # comment
  end
#! ^^ keyword.control.conditional
end # comment
#! <- keyword.control.conditional
#!  ^^^^^^^^^ comment.line

if --help; else;
#! <- meta.function-call.standard variable.function
#! ^^^^^^ meta.argument
#!       ^ keyword.operator
#!         ^^^^ invalid.illegal.function

if \
#! ^ constant.character.escape
  test foo; end & # comment
#! ^^^ meta.block.if
#!        ^ keyword.operator
#!          ^^^ keyword.control.conditional
#!              ^ keyword.operator
#!                ^^^^^^^^^ comment.line

for in in in in (seq 5) in in # comment
#! <- meta.block.for-in keyword.control.conditional
#!  ^^ meta.argument
#!     ^^ keyword.control.conditional
#!        ^^ meta.argument
#!           ^^ meta.argument
#!              ^^^^^^^ meta.argument meta.parens.command-substitution
#!                      ^^ meta.argument
#!                         ^^ meta.argument
#!                            ^^^^^^^^^ comment.line
  echo arg
#! ^^^ meta.function-call.standard
  continue ;
#! ^^^^^^^ keyword.control.conditional
#!         ^ keyword.operator
end
#! <- keyword.control.conditional

for \
#! <- meta.block.for-in keyword.control.conditional
#!  ^ constant.character.escape
  varname \
#! ^^^^^^ meta.argument
#!        ^ constant.character.escape
  in \
#! ^ keyword.control.conditional
#!   ^ constant.character.escape
    (
#!  ^ meta.argument meta.parens.command-substitution
  echo \
#! ^^^ meta.function-call.standard
  one two \
  three
)
#! <- meta.argument meta.parens.command-substitution
  echo arg arg
#! ^^^ meta.function-call.standard
end
#! <- keyword.control.conditional

switch (echo $var)
#! <- meta.block.switch keyword.control.conditional
#!     ^^^^^^^^^^^ meta.block.switch.value
  case foo
#! ^^^ meta.block.switch.case keyword.control.conditional
#!     ^^^ meta.block.switch.case.wildcard
    echo bar
  case bar
#! ^^^ meta.block.switch.case keyword.control.conditional
#!     ^^^ meta.block.switch.case.wildcard
    echo foo
end
#! <- keyword.control.conditional

switch \
# comment
"foo"
#! <- meta.block.switch.value string.quoted.double
  case \
#! ^^^ meta.block.switch.case keyword.control.conditional
  (echo foo)[] bar one two
#! ^^^^^^^^^^^^^^^^^^^^^ meta.block.switch.case.wildcard
    echo bar
  case '*'
#!     ^^^ meta.block.switch.case.wildcard string.quoted.single
    echo arg
end
#! <- keyword.control.conditional

switch value; case wildcard; command echo foo; end # comment
#!          ^ keyword.operator
#!                         ^ keyword.operator
#!                                           ^ keyword.operator
#!                                                 ^ comment.line

switch --help; case;
#! <- meta.function-call.standard variable.function
#!     ^^^^^^ meta.argument
#!           ^ keyword.operator
#!             ^^^^ invalid.illegal.function

switch--help arg
#! <- variable.function
#! ^^^^^^^^^ meta.function-call.standard variable.function

function foo --arg="bar"
#! <- meta.block.function. keyword.control.conditional
#!       ^^^ entity.name.function
#!           ^^^^^^^^^^^ meta.argument
  return 1
#! ^^^^^ keyword.control.conditional
  echo arg
#! ^^^^^^^ meta.function-call.standard
end
#! <- keyword.control.conditional

function \
#! <- meta.block.function. keyword.control.conditional
#!       ^ constant.character.escape
foo\ bar \
#! <- entity.name.function
#!       ^ constant.character.escape
  arg1 \
#! ^^^ meta.argument
  arg2 # comment
#! ^^^ meta.argument
  echo arg
#! ^^^^^^^ meta.function-call.standard
end
#! <- keyword.control.conditional

function inline; echo arg; end # comment
#! <- meta.block.function. keyword.control.conditional
#!       ^^^^^^ entity.name.function
#!             ^ keyword.operator
#!                       ^ keyword.operator

function '$cmd$'; echo $argv; end; $cmd$ arg1 arg2
#!       ^^^^^^ entity.name.function
#!                               ^ keyword.operator
#!                                 ^^^^^ variable.function



# Tests in progress
#



test echoend # hm
oh dear

echo one | begin; cat; end

begin; echo out; end | echo










