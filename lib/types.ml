(* type expr =
| Sum of expr * expr
| Num of int
| Prod of expr * expr *)

type chunk =
| Word of int
| Blank of int

type line = Line of chunk list

type file = File of line list

let chunk_line (chunk : chunk) (line : line) : line = 
  match line with
  | Line x -> Line (chunk :: x)

let line_file (line : line) (file : file) : file = 
  match file with
  | File x -> File (line :: x)