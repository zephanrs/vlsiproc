# VLSI Processor Project

This repository contains the processor project files, including Verilog, testbenches, scripts, and the Cadence workspace.

## Setup

### 1. Set up GitHub SSH access

1. Make sure you have a GitHub account and that your full name is set in your GitHub profile.
2. Create your own SSH key:

```bash
ssh-keygen -t ed25519 -C "netid@cornell.edu"
```

When prompted for a passphrase, just press Enter twice to leave it empty.

3. Display your public SSH key:

```bash
cat ~/.ssh/id_ed25519.pub
```

4. Copy that key and add it to GitHub here:

- [GitHub SSH keys settings](https://github.com/settings/ssh)

5. Click `New SSH key`, paste in the key, and give it a name such as `VLSI Final Project`.
6. Test that GitHub recognizes your key:

```bash
ssh -T git@github.com
```

The first time, type `yes` if GitHub asks you to confirm the host.

### 2. Configure Git

Set your name and Cornell email once:

```bash
git config --global user.name "Your Name"
git config --global user.email "netid@cornell.edu"
```

### 3. Clone this repository

Clone the repo in your home directory and name the local folder `processor`:

```bash
cd ~
git clone git@github.com:zephanrs/vlsiproc.git processor
cd ~/processor
```

## Using The Project

Each time you start working, go to the repo and source the project setup script:

```bash
cd ~/processor
source scripts/setup-project.sh
```

This loads the tool environment used by the project, including the Verilog tools and Cadence tools.

### Starting Cadence Virtuoso

Most VLSI work should start from the `cadence/` directory so Virtuoso picks up the project library setup correctly.

```bash
cd ~/processor/cadence
virtuoso &
```

### Running the Verilog tests

```bash
cd ~/processor
mkdir -p build
cd build
../configure
make check-ref
```

If you want more detailed test output:

```bash
make check-ref-verbose
```

## Working With Git

If you are new to git, use this as the default workflow for this repo.

### 1. Pull before you start working

Every time you log in and start working, update your copy first:

```bash
cd ~/processor
git pull
```

This helps you avoid working on an outdated copy of the repo.

### 2. Check what changed

```bash
git status
```

Use this often. It tells you which files you modified and what git is tracking.

### 3. Add and commit your work

After editing files, it is usually easiest to stage everything at once:

```bash
git add .
git status
```

Always run `git status` right after `git add .` and check that you did not stage extra generated files by accident.

If you staged something you do not want to commit, remove it from the staged list with:

```bash
git restore --staged path/to/file
```

If you want to remove many staged files and start over:

```bash
git restore --staged .
git status
```

Once `git status` looks correct, make the commit:

```bash
git commit -m "brief description of your changes"
```

Cadence can generate lots of extra files, so do not skip the `git status` check before committing.

### 4. Push your commits

```bash
git push
```

If `git push` is rejected because the remote has new commits, update your branch and rebase if git asks you to:

```bash
git pull --rebase
git push
```

If you get a merge conflict during a pull, rebase, or push workflow, stop and ask Irwin for help before trying random commands. If Irwin is not available, then ask an LLM.
