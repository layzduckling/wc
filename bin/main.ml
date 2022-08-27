open Ocamlwc
open Types

let file = Lexing.from_channel stdin
let tokenizer = Lexer.pattern
let result = Parser.file tokenizer file

type info = {
  line_cnt : int;
  word_cnt : int;
  byte_cnt : int;
}

let count_characters (line : line) =
  match line with
  | Line l ->
      let rec count chunks =
        match chunks with
        | [] -> 0
        | Word x :: rest -> x + count rest
        | Blank x :: rest -> x + count rest
      in
      count l

let count_words (line : line) =
  match line with
  | Line l ->
      let rec count chunks =
        match chunks with
        | [] -> 0
        | Word _ :: rest -> 1 + count rest
        | Blank _ :: rest -> count rest
      in
      count l

let fake_eval (result : file) : info =
  match result with
  | File xs ->
      let rec count_words_in_lines lines =
        match lines with
        | [] -> (0, 0)
        | x :: xs ->
            let word_cnt, char_cnt = count_words_in_lines xs in
            (count_words x + word_cnt, count_characters x + char_cnt)
      in
      let word_cnt, char_cnt = count_words_in_lines xs in
      { line_cnt = List.length xs; word_cnt; byte_cnt = char_cnt }

let print_info { line_cnt; word_cnt; byte_cnt } =
  print_int line_cnt;
  print_char ' ';
  print_int word_cnt;
  print_char ' ';
  print_int byte_cnt

let () =
  print_info (fake_eval result);
  print_newline ()
