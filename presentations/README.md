## Setup

Follow these steps to set everything up:

1. Make sure you've cloned the entire repo. A lot of 'things' rely on the folder structure that is in the repo;
1. Read [README.md](https://github.com/pauby/environment-builds/blob/master/README.md) on how to setup things up;
1. From the root of the repository run the [SetupResources.ps1](https://github.com/pauby/environment-builds/blob/master/SetupResources.ps1) script. **This uses relative paths so needs to be run from the correct location**;
1. Inside _this_ folder create a directory called `presentations`. This can either be a normal folder or a symbolic link. The demos inside the environment rely on that folder being there. This Vagrant environment is a generic one used for my presentations so see the [presentations](https://github.com/pauby/presentations) themselves to see what they use;
3. Run `vagrant up --provider <YOUR PROVIDER>` to start the environment;