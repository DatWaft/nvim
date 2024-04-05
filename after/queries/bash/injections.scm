;; extends

; printf 'format'
((command
  name: (command_name) @_command
  .
  argument: [
    (string (string_content) @injection.content)
    (concatenation (string (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#set! injection.language "printf"))

; printf -v var 'format'
((command
  name: (command_name) @_command
  argument: (word) @_arg
  .
  (_)
  .
  argument: [
    (string (string_content) @injection.content)
    (concatenation (string (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#eq? @_arg "-v")
  (#set! injection.language "printf"))

; printf -- 'format'
((command
  name: (command_name) @_command
  argument: (word) @_arg
  .
  argument: [
    (string (string_content) @injection.content)
    (concatenation (string (string_content) @injection.content))
    (raw_string) @injection.content
    (concatenation (raw_string) @injection.content)
  ])
  (#eq? @_command "printf")
  (#eq? @_arg "--")
  (#set! injection.language "printf"))
