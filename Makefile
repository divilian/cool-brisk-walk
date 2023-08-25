pdf: brisk.pdf

brisk.pdf: *.tex
	lualatex $(subst .pdf,.tex,$@)
	makeindex $(subst .pdf,.idx,$@)
	lualatex $(subst .pdf,.tex,$@)
	lualatex $(subst .pdf,.tex,$@)

front-cover.pdf: cover.svg
	type inkscape 2> /dev/null && \
		inkscape $^ --batch-process \
			--export-area-drawing --export-type=pdf \
			--export-id="layer3" \
			--export-filename=$@  || \
		rsvg-convert --unlimited --format=pdf \
			--left=-173mm --page-width=6.08in --page-height=9in \
			$< > $@

brisk-sans-titlepage.pdf: brisk.pdf
	gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=2 -sOutputFile=$@ $^

coolbrisk.pdf: pdfmarks.ps front-cover.pdf brisk-sans-titlepage.pdf metadata.ps
	gs -q -o $@ -sDEVICE=pdfwrite -f $^ -c "[ /Label (a) /PAGELABEL pdfmark"
	rm $(filter %.ps,$^)

pdfmarks.ps:
	@echo "[ /Title (Front Cover) /SrcPg 1 /OUT pdfmark" > $@
#	@echo "[ /Title (Sources URL) /SrcPg 2 /Contents (https://github.com/divilian/cool-brisk-walk) /Subtype /Text /Rect [300 0 100 205] /Color [1 1 .75] /ANN pdfmark" >> $@

metadata.ps:
	@echo "[ /Title (A Cool Brisk Walk Through Discrete Mathematics)" > $@
	@echo "  /Author (Stephen Davies)" >> $@
	@echo "  /Subject (Discrete Mathematics)" >> $@
	@echo "  /Keywords (discrete mathematics, computer science, sets, relations," >> $@
	@echo "  probability, structures, graphs, trees, counting, combinatorics," >> $@
	@echo "  numbers, logic, proof)" >> $@
	@echo "  /DOCINFO pdfmark" >> $@

##### Environment
env: needs := guix docker podman
env : has := $(foreach need,$(needs),$(shell which $(need)))
env:
ifeq ($(words $(has)),'0')
	$(error Unable to find any of the following: $(foreach need,$(needs),`$(need)`))
endif
	@if [ -f "`which guix`" ]; then \
		make .guix_env; \
	elif [ -f "`which docker`" ] || [ -f "`which podman`" ]; then \
		make .container_env; \
	else \
		echo "This should not execute." && false; \
	fi

### Environment: Guix Shell
.guix_env:
	guix shell --container \
		coreutils-minimal sed make \
		texlive-scheme-basic texlive-ulem texlive-multirow texlive-fancybox \
		texlive-mdwtools texlive-textcase texlive-ccicons texlive-memoir \
		texlive-paralist texlive-enumitem texlive-hyperref texlive-pgf \
		texlive-etoolbox texlive-xkeyval ghostscript librsvg

### Environment: Containers
CONTAINER_RUNTIME_ENGINE=$(shell which docker || echo "podman")
CRE=${CONTAINER_RUNTIME_ENGINE}
IMAGE_TAG=cool-brisk-walk-image

.container_env: .container_image
	${CRE} run --rm --interactive --tty --volume `pwd`:/sources:z --workdir="/sources" ${IMAGE_TAG}

.container_image: .container_image_id
.container_image_id: Containerfile
	${CRE} build --file $< --tag ${IMAGE_TAG} .
	${CRE} inspect --format {{.Id}} ${IMAGE_TAG} > .container_image_id
