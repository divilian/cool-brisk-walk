# cool-brisk-walk
This is the LaTeX source code for Davies' "A Cool Brisk Walk Through Discrete Mathematics,"
the text that accompanies volume I of [allthemath.org](http://allthemath.org).

UMW textbook for CPSC 284 (Applied Discrete Mathematics)

To build:
```
$ lualatex brisk.tex
$ makeindex brisk.idx 
$ lualatex brisk.tex
```
Or the shorter: `make pdf`

If you don't have `lualatex` in your environment, and don't want to pollute it, you can use
[containers](https://en.wikipedia.org/wiki/OS-level_virtualization) so long as you have a container
runtime engine like [`docker`](https://www.docker.com/) or [`podman`](https://podman.io/) on your machine.
Run `make env` to set up an environment, and `make pdf` inside the container's shell to generate the pdf.
Consult the [Makefile](Makefile) for further details (and [Makefile Tutorial](https://makefiletutorial.com/)
to understand Makefiles in general).
