pychecks-vim
============

A Vim plugin for checking Python code on the fly, based on pyflakes.vim_.

PyFlakes catches common Python errors like mistyping a variable name or
accessing a local before it is bound, and also gives warnings for things like
unused imports.

pychecks-vim uses the pep8_ and PyFlakes_ libraries to highlight errors and code
style issues in your code. To locate errors quickly, use quickfix_ commands
like ``:cc``.

.. _pyflakes.vim: http://www.vim.org/scripts/script.php?script_id=2441
.. _pep8: http://github.com/jcrocholl/pep8
.. _PyFlakes: http://github.com/kevinw/pyflakes
.. _quickfix: http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix

Quick Installation
------------------

1. Make sure your ``.vimrc`` has::

    filetype on            " enables filetype detection
    filetype plugin on     " enables filetype specific plugins

2. Download the latest release.

3. If you're using pathogen_, unzip the contents of ``pychecks-vim.zip`` into
   its own bundle directory, i.e. into ``~/.vim/bundle/pychecks-vim/``.

   Otherwise unzip ``pychecks.vim`` and the ``pychecks`` directory into
   ``~/.vim/ftplugin/python`` (or somewhere similar on your
   `runtime path`_ that will be sourced for Python files).

.. _pathogen: http://www.vim.org/scripts/script.php?script_id=2332
.. _runtime path: http://vimdoc.sourceforge.net/htmldoc/options.html#'runtimepath'

Options
-------

Set this option in your vimrc file to disable quickfix support::

    let g:pyflakes_use_quickfix = 0

The value is set to 1 by default.

Set this option to add to the set of builtins recognized by PyFlakes::

    let g:pychecks_builtins = '["my_builtin"]'

Set one of these options to disable pep8 or PyFlakes checking::

    let g:pychecks_pep = 0
    let g:pychecks_pyflakes = 0

Contact
-------

Please contact `David H. Bronke`_ in case of emergency.

.. _David H. Bronke: whitelynx@gmail.com

TODO
----
 * signs_ support (show warning and error icons to left of the buffer area)
 * configuration variables
 * parse or intercept useful output from the warnings module

.. _signs: http://www.vim.org/htmldoc/sign.html

