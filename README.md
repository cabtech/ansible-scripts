----
# ansible-scripts
Handy scripts for using Ansible

## Contents
| Name | Purpose |
| ---- | ------- |
| ct-avds.sh | mimics what `ansible-vault decrypt_string` could be |
| ct-combine-ssh-fragments.sh | combines `~/.ssh/cfg.d/*cfg` into `~/.ssh/config` |
| ct-play.sh | wrapper around ansible-playbook |
| ct-vault.sh | wrapper around ansible-vault |

### ct-avds.sh
```
ct-avds.sh [-Pv] [-p vault_file] -f file
```

Ansible Vault Decrypt String.  Parses a file with a single string that was encrypted with `ansible-vault encrypt_string` and passes it to `ansible-vault decrypt`.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -P | no | prompts you for the ansible-vault password |
| -f | yes | name of the file containing the encrypted string |
| -p | no | name of the vault password file (default = `./.vault`) |
| -v | no | produces extra out for testing (only use interactively) |

### ct-combine-ssh-fragments.sh
```
ct-combine-ssh-frgaments.sh [-ds]
```

Rather than try and manipulate `~/.ssh/config` directly, create files in `~/.ssh/cfg.d` and use this to combine them.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -d | no | display diffs |
| -s | no | soft mode: don't replace `~/.ssh/config` and show intended diffs |

### ct-play.sh
```
ct-play.sh [-adx] [OTHER_ARGS] -l limit -p playbook [-t tag1,,,tagN] [-s skiptag1,,,skiptagN]
```

The key thing about this script is that chech mode is the default.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -a | no | required with `-l all` to confirm you mean it |
| -d | no | diff mode |
| -l limit | yes | limit to operate on |
| -p playbook | yes | playbook to run |
| -s tag1,,,tagN | no | tags to skip |
| -t tag1,,,tagN | no | tags to choose |
| -x | no | switches to live mode (default is check-mode) |
| others | no | to be added |

### ct-strip-escape-codes.sh
Based on [StackOverflow](https://stackoverflow.com/questions/6534556/how-to-remove-and-all-of-the-escape-sequences-in-a-file-using-linux-shell-sc)
```
ct-strip-escape-codes.sh filename
    or
someProcess | ct-strip-escape-codes.sh
```

### ct-vault.sh
```
ct-vault.sh [-SVdehnsv] [-F vault_file] [-a <decrypt|encrypt|view>] [-g grep_string] -f file
```

The script will detect whether a file is vaulted or not and factor that in.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -F path | no | location of the vault file (default= `./.vault`) |
| -S | no | do not save a copy of the decrypted file |
| -V | no | set vault file to empty string |
| -a action | no | valid actions are [decrypt, encrypt, view] (default=view)|
| -d | no | same as `-a decrypt` | 
| -e | no | same as `-a encrypt` | 
| -f filename | yes | filename to operate on |
| -g string | no | combines view and grep |
| -h | no | echo usage string and exit |
| -n | no | soft mode, echoes command that would have been run and exits | 
| -s | no | save a copy of the decrypted file so that you can diff for changes (default) |
| -v | no | verbose mode |

****
