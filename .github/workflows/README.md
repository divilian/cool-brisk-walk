Two Actions workflows have been added:

- `container-image.yaml`: This workflow file builds the container image which will be used to build the PDF in.
- `pdf.yaml`: This workflow builds the PDF using the container image from the previous workflow, and also ships the PDF out to a server (`scp`) if the changes are happening on `master` branch.

The following secrets must be configured in the repository settings, under actions settings, (https://github.com/**USERNAME_HERE**/cool-brisk-walk/settings/secrets/actions) by the repository owner for each of these workflows:
1. `container-image.yaml`:
- `REGISTRY_TOKEN`: This should be set to the value of an authentication/access token that has permissions to write to the container registry. The access token is generated from the [repository owner's profile settings](https://github.com/settings/tokens). For Github, 'classic' tokens should be used.

2. `pdf.yaml`:
The following are the ssh credentials for the machine that the PDF is `scp`-ed to. Pretty self-explanatory.
- `SSH_USERNAME`
- `SSH_HOST`
- `SSH_PORT`
- `SSH_KEY`: The contents of the SSH private key used to login to the server.
- `SSH_DESTINATION_DIR`: Not the destination path, but only the destination directory.

Note:
- After the first run of `container-image.yaml` workflow, a cool-brisk-walk container image will have been uploaded to
https://github.com/**USERNAME_HERE**/cool-brisk-walk/pkgs/container/cool-brisk-walk from where the image will be downloaded
during the execution of `pdf.yaml` workflow to build the pdf in. However, it's permissions won't be 'public' yet. So, under
package settings (https://github.com/users/**USERNAME_HERE**/packages/container/cool-brisk-walk/settings) at least Github
Actions should be allowed to access the image (or the package could be made public entirely).
- Because of context availability (https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability),
'ghcr.io' appears in the workflow files and must be configured in place if a different container registry is to be used.