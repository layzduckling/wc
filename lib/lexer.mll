{
  open Parser
}

let blank = [' ' '\t']+
let newline = "\n" | "\r" | "\r\n"

let number =  ['0'-'9']+
let plus = '+'
let times = '*'

(* let word = ['!'-'/' '0'-'9' 'A'-'z']+ *)
let word = [^' ' '\t' '\n' '\r']+

rule pattern = parse
| blank as b { BLANK (String.length b) }
(* | number as n { NUM (int_of_string n) } *)
| word as w { WORD (String.length w) }
| newline { NEWLINE }
(* | plus { PLUS }
| times { TIMES } *)
| eof { EOF }