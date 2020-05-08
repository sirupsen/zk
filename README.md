# zk

Stupid-fast plain-text Zettelkasten (`zk`) built for (terminal) nerds.

Heavily featuring `fzf`, `ripgrep`, `bat`, and `sqlite`.

![](https://pbs.twimg.com/media/EQGYhAJUYAEPC4j?format=jpg&name=4096x4096)

In this `screenshot`, we have `zks` running in the top-right, `zkt` in the
bottom-right, and `vim` in the left pane. `zk` can be used without `tmux`, but
it's recommended to use `tmux`.

## Usage

The scripts assumes `$ZK_PATH` is set to your Zettelkasten directory. Your
Zettelkasten are markdown files in this directory. Nesting is presently not
supported.  Each note must have a 12-number prefix (date note was created), e.g.
`202005050837 Monkey Ladder.md`. It's recommended to do some kind of backup,
e.g. Dropbox/iCloud/...

Your `zk` Zettelkasten is designed to be edited with your favourite editor.
Currently `zk` only supports Vim natively. `zk` augments your editor with
various scripts to help extract further value.

`zks`. Full-text search (top-right pane in screenshot above) over all your
notes, using `sqlite`. Updates automatically.

`zkt`. List tags. Pressing enter on a tag will show you notes with that tag.

`zkn`. Create a new note, with an appropriate prefix.

## Installation

Clone `zk` and add `bin/` to your `$PATH`:

```
git clone https://github.com/sirupsen/zk.git ~/zk
echo 'export PATH=$PATH:$HOME/zk/bin' >> ~/.bashrc
echo 'export ZK_PATH="$HOME/Zettelkasten"' >> ~/.bashrc
```

Install the dependencies with your package manager. MacOS:

```
brew install ripgrep fzf sqlite3 bat
gem install sqlite3
```

For Vim, you can use
[this](https://github.com/sirupsen/dotfiles/blob/master/home/.vimrc#L480-L517)
in the config to add a `:Note` to add new notes with the prefix, as well as
auto-completion for tags and links. Make sure to use `bouk/vim-markdown` to get
proper highlighting for links.
