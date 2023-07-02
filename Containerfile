FROM docker.io/debian:bookworm
RUN apt update && apt -y upgrade
RUN apt install -y make texlive-latex-recommended
RUN apt install -y texlive-latex-extra
CMD bash