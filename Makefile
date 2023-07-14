brisk.pdf: *.tex
	lualatex $(subst .pdf,.tex,$@)
	makeindex $(subst .pdf,.idx,$@)
	lualatex $(subst .pdf,.tex,$@)

pdf: brisk.pdf

front-cover.pdf: cover.svg
	type inkscape && \
		inkscape $^ --batch-process \
			--export-area-drawing --export-type=pdf \
			--export-id="layer3" \
			--export-filename=$@  || \
		rsvg-convert --unlimited --format=pdf \
			--left=-173mm --page-width=6.08in --page-height=9in \
			$^ > $@

CoolBriskWalk.pdf: pdfmarks.ps front-cover.pdf brisk.pdf metadata.ps
	gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $^
	rm $(filter %.ps,$^)

pdfmarks.ps:
	@echo "[ /Label (front-cover) /SrcPg 1 /PAGELABEL pdfmark" > $@
	@echo "[ /Title (Front Cover) /SrcPg 1 /OUT pdfmark" >> $@
	@echo "[ /Title (Sources URL) /SrcPg 3 /Contents (https://github.com/divilian/cool-brisk-walk) /Subtype /Text /Rect [300 0 100 205] /Color [1 1 .75] /ANN pdfmark" >> $@

metadata.ps:
	@echo "[ /Title (A Cool Brisk Walk Through Discrete Mathematics)" > $@
	@echo "  /Author (Stephen Davies)" >> $@
	@echo "  /Keywords (discrete mathematics, computer science)" >> $@
	@echo "  /DOCINFO pdfmark" >> $@

env: container_env

### Containers
CONTAINER_RUNTIME_ENGINE=$(shell which docker || echo "podman")
CRE=${CONTAINER_RUNTIME_ENGINE}
IMAGE_TAG=cool-brisk-walk-image

container_env: container_image
	${CRE} run --rm --interactive --tty --volume `pwd`:/sources:z --workdir="/sources" ${IMAGE_TAG}

container_image: .container_image_id
.container_image_id: Containerfile
	${CRE} build --file $< --tag ${IMAGE_TAG} .
	${CRE} inspect --format {{.Id}} ${IMAGE_TAG} > .container_image_id
