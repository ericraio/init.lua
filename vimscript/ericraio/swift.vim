command! -nargs=0 SwiftFormat call Swift_Format()
nnoremap <silent> <Plug>(swift-format) :<C-u>call Swift_Format()<CR>

autocmd BufWritePre,FileWritePre *.swift :SwiftFormat

function! Swift_Format() abort
  let fname = fnamemodify(expand("%"), ':p:gs?\\?/?')

  " Save cursor position and many other things.
  let l:curw = winsaveview()

  " Write current unsaved buffer to a temp file
  let l:tmpname = tempname() . '.swift'
  call writefile(GetLines(), l:tmpname)

  let current_col = col('.')
  let l:args = ['swift', 'format', '--in-place', l:tmpname]
  let [l:out, l:err] = Exec(l:args)
  let diff_offset = len(readfile(l:tmpname)) - line('$')

  if l:err == 0
    call UpdateFile(l:tmpname, fname)
  else
    let errors = ParseErrors(fname, l:out)
    call ShowErrors(errors)
  endif

  " We didn't use the temp file, so clean up
  call delete(l:tmpname)

  " Restore our cursor/windows positions.
  call winrestview(l:curw)

  " be smart and jump to the line the new statement was added/removed
  call cursor(line('.') + diff_offset, current_col)

  " Syntax highlighting breaks less often.
  syntax sync fromstart
endfunction

" show_errors opens a location list and shows the given errors. If the given
" errors is empty, it closes the the location list
function! ShowErrors(errors) abort
  let l:listtype = "locationlist"
  if !empty(a:errors)
    call ListPopulate(l:listtype, a:errors, 'Format')
    call EchoError("SwiftFormat returned error")
  endif

  " this closes the window if there are no errors or it opens
  " it if there is any
  call Window(l:listtype, len(a:errors))
endfunction

" Window opens the list with the given height up to 10 lines maximum.
"
" If no or zero height is given it closes the window by default.
" To prevent this, set g:swift_list_autoclose = 0
function! Window(listtype, ...) abort
  " we don't use lwindow to close the location list as we need also the
  " ability to resize the window. So, we are going to use lopen and lclose
  " for a better user experience. If the number of errors in a current
  " location list increases/decreases, cwindow will not resize when a new
  " updated height is passed. lopen in the other hand resizes the screen.
  if !a:0 || a:1 == 0
    call Close(a:listtype)
    return
  endif

  let height = ListHeight()
  if height == 0
    " prevent creating a large location height for a large set of numbers
    if a:1 > 10
      let height = 10
    else
      let height = a:1
    endif
  endif

  if a:listtype == "locationlist"
    exe 'lopen ' . height
  else
    exe 'copen ' . height
  endif
endfunction

function! ListHeight() abort
  return get(g:, "swift_list_height", 0)
endfunction

function! ListAutoclose() abort
  return get(g:, 'swift_list_autoclose', 1)
endfunction

" Close closes the location list
function! Close(listtype) abort
  let autoclose_window = ListAutoclose()
  if !autoclose_window
    return
  endif

  if a:listtype == "locationlist"
    lclose
  else
    cclose
  endif
endfunction

" Populate populate the list with the given items
function! ListPopulate(listtype, items, title) abort
  if a:listtype == "locationlist"
    call setloclist(0, a:items, 'r')
    call setloclist(0, [], 'a', {'title': a:title})
  else
    call setqflist(a:items, 'r')
    call setqflist([], 'a', {'title': a:title})
  endif
endfunction

" parse_errors parses the given errors and returns a list of parsed errors
function! ParseErrors(filename, content) abort
  let lines = split(a:content, '\n')
  let errors = []

  for line in lines
    let fatalerrors = matchlist(line, '^.*error:.*$')
    let tokens = matchlist(line, '^\s*\(.\{-}\):\(\d\+\):\s*\(.*\)')

    if !empty(fatalerrors)
      let fatalerror = substitute(fatalerrors[0], '^.*\serror', 'error', '')
      call add(errors, {"text": fatalerror})
    elseif !empty(tokens)
      call add(errors, {"filename": a:filename, "lnum": tokens[2], "text": tokens[3]})
    elseif !empty(errors)
      " Preserve indented lines.
      " This comes up especially with multi-line test output.
      if match(line, '^\s') >= 0
        call add(errors, {"text": substitute(line, '\r$', '', '')})
      endif
    endif
  endfor

  return errors
endfunction

" Get all lines in the buffer as a a list.
function! GetLines()
  let buf = getline(1, '$')
  if &encoding != 'utf-8'
    let buf = map(buf, 'iconv(v:val, &encoding, "utf-8")')
  endif
  return buf
endfunction

" Exec runs a shell command "cmd", which must be a list, one argument per item.
" Every list entry will be automatically shell-escaped
" Every other argument is passed to stdin.
function! Exec(cmd, ...) abort
  if len(a:cmd) == 0
    call EchoError("Exec() called with empty a:cmd")
    return ['', 1]
  endif

  let l:bin = a:cmd[0]

  " Lookup the full path. On errors,
  " CheckBinPath will show a warning for us.
  let l:bin = CheckBinPath(l:bin)
  if empty(l:bin)
    return ['', 1]
  endif

  " Finally execute the command using the full, resolved path. Do not pass the
  " unmodified command as the correct program might not exist in $PATH.
  return call('ExecCMD', [[l:bin] + a:cmd[1:]] + a:000)
endfunction

function! ExecCMD(cmd, ...) abort
  let l:bin = a:cmd[0]
  let l:cmd = Shelljoin([l:bin] + a:cmd[1:])

  let l:out = call('System', [l:cmd] + a:000)
  return [l:out, ShellError()]
endfunction

function! EchoInfo(msg)
  call Echo(a:msg, 'Debug')
endfunction

function! EchoError(msg)
  call Echo(a:msg, 'ErrorMsg')
endfunction

" Echo a message to the screen and highlight it with the group in a:hi.
"
" The message can be a list or string; every line with be :echomsg'd separately.
function! Echo(msg, hi)
  let l:msg = []
  if type(a:msg) != type([])
    let l:msg = split(a:msg, "\n")
  else
    let l:msg = a:msg
  endif

  " Tabs display as ^I or <09>, so manually expand them.
  let l:msg = map(l:msg, 'substitute(v:val, "\t", "        ", "")')

  exe 'echohl ' . a:hi
  for line in l:msg
    echom "vimrc: " . line
  endfor
  echohl None
endfunction

function! ShellError() abort
  return v:shell_error
endfunction

" Shelljoin returns a shell-safe string representation of arglist. The
" {special} argument of shellescape() may optionally be passed.
function! Shelljoin(arglist, ...) abort
  " Preserve original shell. This needs to be kept in sync with how s:system
  " sets shell.
  let l:shell = &shell

  try
    let ssl_save = &shellslash
    set noshellslash
    if a:0
      return join(map(copy(a:arglist), 'shellescape(v:val, ' . a:1 . ')'), ' ')
    endif

    return join(map(copy(a:arglist), 'shellescape(v:val)'), ' ')
  finally
    " Restore original values
    let &shellslash = ssl_save
    let &shell = l:shell
  endtry
endfunction

" Run a shell command.
"
" It will temporary set the shell to /bin/sh for Unix-like systems if possible,
" so that we always use a standard POSIX-compatible Bourne shell (and not e.g.
" csh, fish, etc.) See #988 and #1276.
function! System(cmd, ...) abort
  " Preserve original shell, shellredir and shellcmdflag values
  let l:shell = &shell
  let l:shellredir = &shellredir
  let l:shellcmdflag = &shellcmdflag
  let l:shellquote = &shellquote
  let l:shellxquote = &shellxquote

  try
    return call('system', [a:cmd] + a:000)
  finally
    " Restore original values
    let &shell = l:shell
    let &shellredir = l:shellredir
    let &shellcmdflag = l:shellcmdflag
    let &shellquote = l:shellquote
    let &shellxquote = l:shellxquote
  endtry
endfunction

" UpdateFile updates the target file with the given formatted source
function! UpdateFile(source, target)
  " remove undo point caused via BufWritePre
  try | silent undojoin | catch | endtry

  let old_fileformat = &fileformat
  if exists("*getfperm")
    " save file permissions
    let original_fperm = getfperm(a:target)
  endif

  call rename(a:source, a:target)

  " restore file permissions
  if exists("*setfperm") && original_fperm != ''
    call setfperm(a:target , original_fperm)
  endif

  " reload buffer to reflect latest changes
  silent edit!

  let &fileformat = old_fileformat
  let &syntax = &syntax

  let l:listtype = "locationlist"

  let l:list_title = getloclist(0, {'title': 1})

  if has_key(l:list_title, "title") && l:list_title['title'] == "Format"
    lex []
    lclose
  endif
endfunction

" CheckBinPath checks whether the given binary exists or not and returns the
" path of the binary. It returns an empty string if the binary doesn't exist.
function! CheckBinPath(binpath) abort
  " remove whitespaces if incase user applied it
  let binpath = substitute(a:binpath, '^\s*\(.\{-}\)\s*$', '\1', '')

  " save original path
  let old_path = $PATH

  " if it's in PATH just return it
  if executable(binpath)
    if exists('*exepath')
      let binpath = exepath(binpath)
    endif
    let $PATH = old_path

    return binpath
  endif
endfunction
