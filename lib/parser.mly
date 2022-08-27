%start file

// %token <int> NUM
%token <int> WORD
%token <int> BLANK
%token NEWLINE, EOF
// %token PLUS TIMES EOF

// %left PLUS
// %left TIMES
// %nonassoc NUM EOF

// %type <Sum.expr> sum
%type <Types.chunk> chunk
%type <Types.line> line
%type <Types.file> file

%%

// sum:
//     sum PLUS sum { Sum.(Sum ($1, $3)) }
//   | line blankline line { $1 @ [$2] @ $3 }
//   | NUM { Sum.Num $1 }
//   | sum TIMES sum { Sum.(Prod ($1, $3)) }

file:
    EOF { Types.(File []) }
    | line file { Types.(line_file $1 $2) }

line:
    NEWLINE { Types.(Line [Blank 1]) } 
    | chunk line { Types.(chunk_line $1 $2) }

chunk:
    BLANK { Types.(Blank $1) }
    | WORD { Types.(Word $1) }

%%
    