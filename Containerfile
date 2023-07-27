FROM docker.io/fedora:38
RUN dnf -y upgrade
RUN dnf -y install texlive-scheme-basic
RUN dnf -y install make
RUN dnf -y install texlive-ulem texlive-multirow texlive-fancybox texlive-mdwtools
RUN dnf -y install texlive-ccicons
RUN dnf -y install ghostscript
RUN dnf -y install librsvg2-tools
RUN dnf -y install texlive-textcase
CMD bash