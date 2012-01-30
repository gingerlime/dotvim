" pychecks.vim - A script to highlight Python code on the fly with warnings
" from Pyflakes (a Python lint tool) and pep8. (a Python code style checker)
"
" Place this script and the accompanying pychecks directory in
" .vim/ftplugin/python.
"
" Includes pyflakes from http://github.com/kevinw/pyflakes and
" pep8 from http://github.com/jcrocholl/pep8.
"
" See README for additional installation and information.
"
" Thanks to matlib.vim for ideas/code on interactive linting.
"
" Maintainer: David H. Bronke <whitelynx@gmail.com>
" Based On: pyflakes.vim by Kevin Watters <kevin.watters@gmail.com>
" Version: 0.1

if exists("b:did_pychecks_plugin")
    finish " only load once
else
    let b:did_pychecks_plugin = 1
endif

if !exists('g:pychecks_builtins')
    let g:pychecks_builtins = []
endif

if !exists('g:pychecks_pep8')
    let g:pychecks_pep8 = 1
endif

if !exists('g:pychecks_pyflakes')
    let g:pychecks_pyflakes = 1
endif

if !exists("b:did_python_init")
    let b:did_python_init = 0

    if !has('python')
        echoerr "Error: pychecks.vim requires Vim to be compiled with +python!"
        finish
    endif

if !exists('g:pychecks_use_quickfix')
    let g:pychecks_use_quickfix = 1
endif


    python << EOF
import vim
import os.path
import sys

if sys.version_info[:2] < (2, 5):
    raise AssertionError(
            'Vim must be compiled with Python 2.5 or higher; you have '
            + sys.version)

# Get the directory this script is in: the pyflakes and pep8 python modules
# should be installed there.
scriptdir = os.path.join(os.path.dirname(vim.eval('expand("<sfile>")')),
        'pychecks')
sys.path.insert(0, scriptdir)

import ast
from operator import attrgetter
import re

import pep8
from pyflakes import checker, messages

class loc(object):
    def __init__(self, lineno, col=None):
        self.lineno = lineno
        self.col_offset = col

class SyntaxError(messages.Message):
    message = 'could not compile: %s'
    def __init__(self, filename, lineno, col, message):
        messages.Message.__init__(self, filename, loc(lineno, col))
        self.message_args = (message,)

class PEP8Error(messages.Message):
    message = 'code style: %s'
    def __init__(self, filename, lineno, col, message):
        messages.Message.__init__(self, filename, loc(lineno, col))
        self.message_args = (message,)

        self.warningOrError = message[0]
        self.errorNumber = message[1:4]

class blackhole(object):
    write = flush = lambda *a, **k: None


def check(buffer):
    filename = buffer.name
    contents = buffer[:]

    # The shebang is usually found at the top of the file, followed by a source
    # code encoding marker. Assume everything else that follows is encoded in
    # the given encoding.
    encoding_found = False
    for n, line in enumerate(contents):
        if n >= 2:
            break
        elif re.match(r'coding[:=]\s*([-\w.]+)', line):
            contents = ['']*(n+1) + contents[n+1:]
            break

    errors = []

    if vim.eval('g:pychecks_pep8'):
        # Check code style using pep8
        pep8.process_options(['-r', filename or '<unknown>'])

        # Apparently pep8 needs newlines at the end of each line.
        p = pep8.Checker(filename or '<unknown>',
                map(lambda x: x + '\n', contents))

        def report_error(line_number, offset, text, check):
            #TODO: What's `check`, and why is it ignored?
            errors.append(PEP8Error(filename, line_number, offset, text))

        p.report_error = report_error

        try:
            p.check_all()
        except:
            #TODO: Generate some sort of useful error here?
            pass

    if vim.eval('g:pychecks_pyflakes'):
        # Check for errors using pyflakes
        contents = '\n'.join(contents) + '\n'

        vimenc = vim.eval('&encoding')
        if vimenc:
            contents = contents.decode(vimenc)

        builtins = []
        try:
            builtins = set(eval(vim.eval('string(g:pychecks_builtins)')))
        except Exception:
            pass

        # If contents is unicode and 'coding' is some valid unicode format,
        # strip the 'coding' declaration to prevent a SyntaxError; see
        # http://www.python.org/dev/peps/pep-0263/
        if isinstance(contents, unicode):
            from encodings import codecs

            codingRE = re.compile(r"#.*coding[:=]\s*([-\w.]+)")
            coding = None
            lines = contents.split('\n', 1)[:2]
            for line in range(2):
                match = codingRE.search(lines[line])
                if match is not None:
                    if codecs.lookup(match.group(1).lower()
                            ).name.startswith('utf'):
                        lines[line] = lines[line][:match.start()] \
                                + "# <strippedEncodingLine> #"

        try:
            # TODO: use warnings filters instead of ignoring stderr
            old_stderr, sys.stderr = sys.stderr, blackhole()
            try:
                tree = ast.parse(contents, filename or '<unknown>')
            finally:
                sys.stderr = old_stderr
        except:
            try:
                value = sys.exc_info()[1]
                lineno, offset, line = value[1][1:]
            except IndexError:
                lineno, offset, line = 1, 0, ''
            except ValueError:
                # Happens if value[1][1:] exists, but len(value[1][1:]) != 3
                # TODO: Is there a simpler way to do this?
                lineno, offset, line = 1, 0, ''

            if line and line.endswith("\n"):
                line = line[:-1]

            errors.append(SyntaxError(filename, lineno, offset, str(value)))
        else:
            # pyflakes looks to _MAGIC_GLOBALS in checker.py to see which
            # UndefinedNames to ignore
            old_globals = getattr(checker,' _MAGIC_GLOBALS', [])
            checker._MAGIC_GLOBALS = set(old_globals) | builtins

            w = checker.Checker(tree, filename or '<unknown>')

            checker._MAGIC_GLOBALS = old_globals

            errors.extend(w.messages)

    errors.sort(key=attrgetter('lineno'))
    return errors


def vim_quote(s):
    return s.replace("'", "''")
EOF
    let b:did_python_init = 1
endif

if !b:did_python_init
    finish
endif

au BufLeave <buffer> call s:ClearPyChecks()

au BufEnter <buffer> call s:RunPyChecks()
au InsertLeave <buffer> call s:RunPyChecks()
au InsertEnter <buffer> call s:RunPyChecks()
au BufWritePost <buffer> call s:RunPyChecks()

au CursorHold <buffer> call s:RunPyChecks()
au CursorHoldI <buffer> call s:RunPyChecks()

au CursorHold <buffer> call s:GetPyChecksMessage()
au CursorMoved <buffer> call s:GetPyChecksMessage()

if !exists("*s:PyChecksUpdate")
    function s:PyChecksUpdate()
        silent call s:RunPyChecks()
        call s:GetPyChecksMessage()
    endfunction
endif

" Call this function in your .vimrc to update PyChecks
if !exists(":PyChecksUpdate")
  command PyChecksUpdate :call s:PyChecksUpdate()
endif

" Hook common text manipulation commands to update PyChecks
"   TODO: is there a more general "text op" autocommand we could register
"   for here?
noremap <buffer><silent> dd dd:PyChecksUpdate<CR>
noremap <buffer><silent> dw dw:PyChecksUpdate<CR>
noremap <buffer><silent> u u:PyChecksUpdate<CR>
noremap <buffer><silent> <C-R> <C-R>:PyChecksUpdate<CR>

" WideMsg() prints [long] message up to (&columns-1) length
" guaranteed without "Press Enter" prompt.
if !exists("*s:WideMsg")
    function s:WideMsg(msg)
        let x=&ruler | let y=&showcmd
        set noruler noshowcmd
        redraw
        echo strpart(a:msg, 0, &columns-1)
        let &ruler=x | let &showcmd=y
    endfun
endif

if !exists("*s:GetQuickFixStackCount")
    function s:GetQuickFixStackCount()
        let l:stack_count = 0
        try
            silent colder 9
        catch /E380:/
        endtry

        try
            for i in range(9)
                silent cnewer
                let l:stack_count = l:stack_count + 1
            endfor
        catch /E381:/
            return l:stack_count
        endtry
    endfunction
endif

if !exists("*s:ActivatePyChecksQuickFixWindow")
    function s:ActivatePyChecksQuickFixWindow()
        try
            silent colder 9 " go to the bottom of quickfix stack
        catch /E380:/
        endtry

        if s:pychecks_qf > 0
            try
                exe "silent cnewer " . s:pychecks_qf
            catch /E381:/
                echoerr "Could not activate PyChecks Quickfix Window."
            endtry
        endif
    endfunction
endif

if !exists("*s:RunPyChecks")
    function s:RunPyChecks()
        " PEP 8 warnings
        highlight link PyChecks_PEP8Error SpellBad

        " Parse errors
        highlight link PyChecks_SyntaxError SpellBad

        " PyFlakes errors
        highlight link PyChecks_Message SpellBad
        highlight link PyChecks_UnusedImport SpellBad
        highlight link PyChecks_RedefinedWhileUnused SpellBad
        highlight link PyChecks_ImportShadowedByLoopVar SpellBad
        highlight link PyChecks_ImportStarUsed SpellBad
        highlight link PyChecks_UndefinedName SpellBad
        highlight link PyChecks_UndefinedExport SpellBad
        highlight link PyChecks_UndefinedLocal SpellBad
        highlight link PyChecks_DuplicateArgument SpellBad
        highlight link PyChecks_RedefinedFunction SpellBad
        highlight link PyChecks_LateFutureImport SpellBad
        highlight link PyChecks_UnusedVariable SpellBad

        if exists("b:cleared")
            if b:cleared == 0
                silent call s:ClearPyChecks()
                let b:cleared = 1
            endif
        else
            let b:cleared = 1
        endif

        let b:matched = []
        let b:matchedlines = {}

        let b:qf_list = []
        let b:qf_window_count = -1

        python << EOF
for w in check(vim.current.buffer):
    vim.command('let s:matchDict = {}')
    vim.command("let s:matchDict['lineNum'] = " + str(w.lineno))
    vim.command("let s:matchDict['message'] = '%s'" % vim_quote(
            w.message % w.message_args))
    vim.command("let b:matchedlines[" + str(w.lineno) + "] = s:matchDict")

    vim.command("let l:qf_item = {}")
    vim.command("let l:qf_item.bufnr = bufnr('%')")
    vim.command("let l:qf_item.filename = expand('%')")
    vim.command("let l:qf_item.lnum = %s" % str(w.lineno))
    vim.command("let l:qf_item.text = '%s'" % vim_quote(
            w.message % w.message_args))

    if hasattr(w, 'warningOrError'):
        vim.command("let l:qf_item.type = '" + w.warningOrError + "'")
    else:
        # Default to errors.
        vim.command("let l:qf_item.type = 'E'")

    if hasattr(w, 'errorNumber'):
        vim.command("let l:qf_item.nr = " + w.errorNumber)

    errorType = w.__class__.__name__

    if getattr(w, 'col', None) is None or isinstance(w, SyntaxError):
        # without column information, just highlight the whole line
        # (minus the newline)
        vim.command(r"let s:mID = matchadd('PyChecks_" + errorType + "', '\%"
                + str(w.lineno) + r"l\n\@!')")
    else:
        # with a column number, highlight the first keyword there
        vim.command(r"let s:mID = matchadd('PyChecks_" + errorType + "', '^\%"
                + str(w.lineno) + r"l\_.\{-}\zs\k\+\k\@!\%>" + str(w.col)
                + r"c')")

        vim.command("let l:qf_item.vcol = 1")
        vim.command("let l:qf_item.col = %s" % str(w.col + 1))

    vim.command("call add(b:matched, s:matchDict)")
    vim.command("call add(b:qf_list, l:qf_item)")
EOF
        if g:pychecks_use_quickfix == 1
            if exists("s:pychecks_qf")
                " if pychecks quickfix window is already created, reuse it
                call s:ActivatePyChecksQuickFixWindow()
                call setqflist(b:qf_list, 'r')
            else
                " one pychecks quickfix window for all buffer
                call setqflist(b:qf_list, '')
                let s:pychecks_qf = s:GetQuickFixStackCount()
            endif
        endif

        let b:cleared = 0
    endfunction
end

" keep track of whether or not we are showing a message
let b:showing_message = 0

if !exists("*s:GetPyChecksMessage")
    function s:GetPyChecksMessage()
        let s:cursorPos = getpos(".")

        " Bail if RunPyChecks hasn't been called yet.
        if !exists('b:matchedlines')
            return
        endif

        " if there's a message for the line the cursor is currently on, echo
        " it to the console
        if has_key(b:matchedlines, s:cursorPos[1])
            let s:pychecksMatch = get(b:matchedlines, s:cursorPos[1])
            call s:WideMsg(s:pychecksMatch['message'])
            let b:showing_message = 1
            return
        endif

        " otherwise, if we're showing a message, clear it
        if b:showing_message == 1
            echo
            let b:showing_message = 0
        endif
    endfunction
endif

if !exists('*s:ClearPyChecks')
    function s:ClearPyChecks()
        let s:matches = getmatches()
        for s:matchId in s:matches
            if match(s:matchId['group'], '^PyChecks_') != -1
                call matchdelete(s:matchId['id'])
            endif
        endfor
        let b:matched = []
        let b:matchedlines = {}
        let b:cleared = 1
    endfunction
endif

" vim: tabstop=4 shiftwidth=4 expandtab textwidth=79
