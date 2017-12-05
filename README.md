# yuca ansible configuration

Welcome to the early stage of the yuca ansible configuration :)

The aim here is to slowly switch all configuration over to using ansible.

## quick start

Prerequisites:

* a working installation of ansible such that you have `ansible-playbook` and `ansible-vault` commands available
* an account on yuca.yunity.org with sudo powers
* if required, access to a/the vault password

Clone this repo:

```
git clone <path/to/repo>
cd yuca
```

If needed, add your local configuration (e.g. your private ssh key):

```
cp group_vars/all.yml.example group_vars/all.yml
# edit contents of group_vars/all.yml
```

Setup karrot-dev (for example):

```
./scripts/run playbooks/karrot-dev/setup.playbook.yml --ask-vault-pass
```

## adding another site

```
cd playbooks
cp -r karrot-dev your-new-site
```

Ensure `roles` is symlinked like so: `playbooks/your-new-site/roles -> roles`.

**Note** copy the most simliar site to what you want to configure (at the moment there is only one anyway...)

## linting

If you install [ansible-lint](https://github.com/willthames/ansible-lint) you can run `./scripts/lint`.

## conventions

* *don't add anything to master that you are not happy for other people to run at any time*
* playbook files are named `*.playbook.yml`
* var files are named `*.vars.yml`
* playbooks are contained within a directory for that site, e.g. `playbooks/my-site/setup.playbook.yml`
* name all tasks (in lowercase)
* implement everything as a reusable 
* use ansible-vault for storing sensitive data
* store secret vars in `secrets.vars.yml`
* use `lowercase_underscore_style` for variables
* always use `.yml` extension not `.yaml`
* don't check in code that fails the `./scripts/lint` check
* when running a playbook it should all be green/ok if nothing has actually changed

## usage with pass

I highly recommend using [pass](https://www.passwordstore.org/) as it works very nicely with the vault mechanism.

For example, if you have the vault password store as `yuca.vault` you can create this file in `vault-password` (make sure to `chmod +x` it):

```
#!/bin/sh
pass yuca.vault
```

Then use it with:

```
./scripts/run playbooks/karrot-dev/setup.playbook.yml --vault-password-file vault-password
```

Benefits:
* use your standard _pass_ password to unlock any of your vault passwords
* caches unlocked passwords for a period of time so you don't need to enter it every time
