let head =
  <head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, inital-scale=1.0">
  <meta name="description" content="word, line, character and byte count">
  <title>WC</title>
  </head>

let upload request =
  <html>
  <%s! head %>
  <body>
    <form method="POST" action="/" enctype="multipart/form-data">
      <%s! Dream.csrf_tag request %>
      <input name="files" type="file" multiple>
      <button>submit</button>
    </form>
  </body>
  </html>

let report files =
  <html>
  <%s! head %>
  <body>
  <ol>
%   files |> List.iter (fun (name, content) ->
%     let name =
%       match name with
%         | None -> "None"
%         | Some name -> name
%       in
        <li><%s name %><br><%i String.length content %> B</li>
%     );
  </ol>
  </body>
  </html>

