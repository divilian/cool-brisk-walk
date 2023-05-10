brisk.pdf: *.tex
	pdflatex $(subst .pdf,.tex,$@)
	makeindex $(subst .pdf,.idx,$@)
	pdflatex $(subst .pdf,.tex,$@)

pdf: brisk.pdf

env: container_env

### Containers
CONTAINER_RUNTIME_ENGINE=$(shell which docker || echo "podman")
CRE=${CONTAINER_RUNTIME_ENGINE}
IMAGE_TAG=cool-brisk-walk-image

container_env: container_image
	${CRE} run --rm --interactive --tty --volume `pwd`:/sources:z --workdir="/sources" ${IMAGE_TAG}

container_image: .container_image_id
.container_image_id: Containerfile
	${CRE} build --file $< --tag ${IMAGE_TAG}
	${CRE} inspect --format {{.Id}} ${IMAGE_TAG} > .container_image_id
