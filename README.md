----
# ansible-scripts
Scripts for making using Ansible even easier

## Contents
| Name | Purpose |
| ---- | ------- |
| ct-combine-ssh-fragments.sh | combines `~/.ssh/cfg.d/*cfg` into `~/.ssh/config` |
| ct-play.sh | wrapper around ansible-playbook |
| ct-vault.sh | wrapper around ansible-vault |

### ct-combine-ssh-fragments.sh
```ct-combine-ssh-frgaments.sh [-ds]```

Rather than try and manipulate `~/.ssh/config` directly, create files in `~/.ssh/cfg.d` and use this to combine them.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -d | no | display diffs |
| -s | no | soft mode: don't replace `~/.ssh/config` and show intended diffs |

### ct-play.sh
```ct-play.sh [-adx] [OTHER_ARGS] -l limit -p playbook [-t tag1,,,tagN] [-s skiptag1,,,skiptagN]```

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

### ct-vault.sh
```ct-vault.sh [-SVdehnsv] [-F vault_file] [-a <decrypt|encrypt|view>] [-g grep_string] -f file```

The script will detect whether a file is vaulted or not and factor that in.

| Flag | Required? | Purpose |
| ---- | --------- | ------- |
| -F path | no | location of the vault file (default= `./.vault`) |
| -S | no | do not save a copy of the decrypted file |
| -V | no | set vault file to empty string |
| -a action | one of [-a,-d,-e,-g] is needed | action in [decrypt, encrypt, view] (default=view)|
| -d | one of [-a,-d,-e,-g] is needed | same as `-a decrypt` | 
| -e | one of [-a,-d,-e,-g] is needed | same as `-a encrypt` | 
| -f filename | yes | filename to operate on |
| -g string | one of [-a,-d-e,-g] is needed | combines view and grep |
| -h | no | echo usage string and exit |
| -n | no | soft mode, echoes command that would have been run and exits | 
| -s | no | save a copy of the decrypted file so that you can diff for changes (default) |
| -v | no | verbose mode |

****
