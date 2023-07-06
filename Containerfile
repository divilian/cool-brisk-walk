FROM docker.io/fedora:38
RUN dnf -y upgrade
RUN dnf -y install texlive-scheme-basic
RUN dnf -y install make
RUN dnf -y install texlive-ulem texlive-multirow texlive-fancybox texlive-mdwtools
RUN dnf -y install texlive-ccicons
CMD bash