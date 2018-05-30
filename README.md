# yuca ansible configuration

Welcome to the early stage of the yuca ansible configuration :)

The aim here is to slowly switch all configuration over to using ansible.

## quick start

Prerequisites:

* a working installation of ansible >= 2.4 such that you have `ansible-playbook` and `ansible-vault` commands available
* an account on `yuca.yunity.org` with sudo powers
* access to the vault password (ask @nicksellen or @tiltec or @NerdyProjects)

Clone this repo:

```
git clone git@github.com:yunity/yuca.git
cd yuca
```

If needed, add your local configuration (e.g. your private ssh key):

```
cp group_vars/all.yml.example group_vars/all.yml
# edit contents of group_vars/all.yml
```

### manage the vault password

The vault stores secrets for use on the server.

I highly recommend using [pass](https://www.passwordstore.org/) as it works very nicely with the vault mechanism.

For example, if you have the vault password store as `yuca.vault` you can copy the file `vault-password.example` to `vault-password`.

Benefits:
* use your standard _pass_ password to unlock any of your vault passwords
* caches unlocked passwords for a period of time so you don't need to enter it every time

Alternatively, you could write your own `vault-password` script.

### now run a playbook

Setup karrot-dev (for example):

```
ansible-playbook playbooks/karrot-dev/setup.playbook.yml
```

## adding another site

```
cd playbooks
cp -r karrot-dev your-new-site
```

Ensure `roles` is symlinked like so: `playbooks/your-new-site/roles -> roles`.

**Note** copy the most simliar site to what you want to configure (at the moment there is only one anyway...)

## editing encrypted files

If you need to edit the secrets, you can do so like this:

```
ansible-vault edit playbooks/karrot-dev/secrets.vars.yml
```

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

## local testing with vagrant

You can run playbooks against a local vagrant vm.
This is lets you check whether the playbook is actually able to setup the server from fresh and lets you try out changes before you run them in production.

First start the vagrant box, configure your ssh file and run the playbook.

```
vagrant up
vagrant ssh-config >> ~/.ssh/config
ansible-playbook -i inventory_vagrant playbooks/karrot-dev/setup.playbook.yml
```

After some time, see if it works:

```
curl -k -H 'Host: dev.karrot.world' https://localhost:8443/
```

It should say `hello`.


```
curl -k -H 'Host: dev.karrot.world' https://localhost:8443/api/
```

It should return JSON.