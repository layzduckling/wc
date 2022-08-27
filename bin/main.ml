open Ocamlwc
open Types

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

let string_of_info { line_cnt; word_cnt; byte_cnt } =
  string_of_int line_cnt ^ " " ^string_of_int word_cnt ^ " " ^ string_of_int byte_cnt
(* 
let () =
  print_info (fake_eval result);
  print_newline () *)
let process content =
  let file = Lexing.from_string content in
  let tokenizer = Lexer.pattern in
  let result = Parser.file tokenizer file in
  string_of_info (fake_eval result)
  
open Dream

let () =
  router
    [
      (get "/" @@ fun request -> html (Template.upload request));
      ( post "/" @@ fun request ->
        match%lwt multipart request with
        | `Ok [ ("files", files) ] -> html (Template.report files process)
        | _ -> empty `Bad_Request );
    ]
  |> logger |> memory_sessions
  |> run ~interface:"0.0.0.0" ~port:(int_of_string (Sys.getenv "PORT"))