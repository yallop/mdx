open Cmdliner

let non_deterministic =
  let doc = "Run non-deterministic tests." in
  Arg.(value & flag & info ["non-deterministic"; "n"] ~doc)

let file =
  let doc = "The file to use." in
  Arg.(required & pos 0 (some string) None & info [] ~doc ~docv:"FILE")

let section =
  let doc =
    "Select file sub-sections. Will be interpreted as a Perl regular expression."
  in
  Arg.(value & opt (some string) None & info ["section"; "s"] ~doc ~docv:"PAT")

let not_verbose =
  let doc = "Do not show the result of evaluating toplevel phrases." in
  Arg.(value & flag & info ["silent-eval"] ~doc)

let silent =
  let doc = "Do not show any (phrases and findlib directives) results." in
  Arg.(value & flag & info ["silent"] ~doc)

let verbose_findlib =
  let doc =
    "Show the result of evaluating findlib directives in toplevel fragments."
  in
  Arg.(value & flag & info ["verbose-findlib"] ~doc)

let prelude =
  let doc = "A file to load as prelude." in
  Arg.(value & opt (some string) None & info ["prelude"] ~doc ~docv:"FILE")

let prelude_str =
  let doc = "A string to load as prelude." in
  Arg.(value & opt (some string) None & info ["prelude-str"] ~doc ~docv:"STR")

let root =
  let doc = "The directory to run the tests from." in
  Arg.(value & opt (some string) None & info ["root"] ~doc ~docv:"DIR")

let direction =
  let doc = "Direction of file synchronization. $(b,to-ml) assumes \
             the .md file is the reference and updates the .ml and \
             the .md files accordingly. $(b,to-md) assumes the .ml \
             file is the reference and updates the .md file \
             accordingly. $(b,infer-timestamp) uses the files last \
             modification timestamps to determine the reference file \
             and updates the least recent files." in
  let opt_names =
    [ "infer-timestamp", `Infer_timestamp
    ; "to-md", `To_md
    ; "to-ml", `To_ml ]
  in
  let names = ["direction"] in
  let docv = String.concat "|" (List.map fst opt_names) in
  let docv = "{" ^ docv ^ "}" in
  Arg.(value & opt (enum opt_names) `Infer_timestamp & info names ~doc ~docv)

let setup_log style_renderer level =
  Fmt_tty.setup_std_outputs ?style_renderer ();
  Logs.set_level level;
  Logs.set_reporter (Logs_fmt.reporter ());
  ()

let setup =
  Term.(const setup_log $ Fmt_cli.style_renderer () $ Logs_cli.level ())
