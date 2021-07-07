# zk

Stupid-fast plain-text Zettelkasten (`zk`) built for (terminal) nerds. Heavily
featuring `fzf`, `ripgrep`, `bat`, and `sqlite`.

The goal of the `zk` repository is to collect scripts and configurations for
other plain-text Zettelkasten users.

**Note:** This is an on-going extraction from my local environment, but has the
utilities I use by far the most often. I can almost guarantee you you're going
to run into a stacktrace somewhere because of some utility that isn't installed,
etc. Please open PRs/issues if it's not working, or you have questions,
concerns, comments. I'd also love contributions of scripts to `bin/`, such as
showing related notes, polish to search, Vim configs, etc.

If you are looking for something slightly more complete that retains the
Markdown-nature, you should take a look at [Obsidian][2]. After switching
note-taking system every year for years, I am no longer interested in custom
software and will stick to time-tested utilities.

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

`zk`. Open `vim` in the left pane, and `zks` in the right pane. Your
launch-point!

`zks`. `fzf`-enabled full-text search (top-right pane in screenshot above) over
all your notes, using `sqlite`. The index updates automatically based on file
modification. See the `FZF_DEFAULT_OPTS` below for various key-bindings you can
use to open splits in Vim, copy to clipboard, etc.  directly from here. `Alt-S`
will find similar notes with `zksim`.

`zksim`. Finds similar notes to the note passed as an argument. See [#1][1] for
more.

`zkt`. `fzf`-enabled tag browser. Pressing enter on a tag will show you notes
with that tag.  notes, using `sqlite`. See the `FZF_DEFAULT_OPTS` below for
various key-bindings you can use to open splits, copy to clipboard, etc.
directly from here.

`zkt-raw`. Raw list of tags sorted by totals. Useful for other analysis. Used by
`zkt`.

`zkn`. Create a new note, with an appropriate prefix.

`zk-assets-localize`. Given a file, downloads/copies the markdown images to `media/`.

`zk-backlinks`. Adds back-links to each note. I.e., if A links to B, but B
doesn't link to A, then it'll append `Backlink: [[A]]` to B.

`zkrt`/`zk-related-tags`. Finds tags related to the ones in the passed file. You can
pass `-t` to see a tree of tags.

## Installation

Clone `zk` and add `bin/` to your `$PATH`:

```
$ git clone https://github.com/sirupsen/zk.git ~/zk
$ echo 'export PATH=$PATH:$HOME/zk/bin' >> ~/.bashrc
$ echo 'export ZK_PATH="$HOME/Zettelkasten"' >> ~/.bashrc
```

Install the dependencies with your package manager.

MacOS:
```bash
# brew install ripgrep fzf sqlite3 bat
# gem install sqlite3
```

Linux:

`build-essential`,`libsqlite3-dev` and `ruby-dev` are needed to install the sqlite3 gem. For example—on Debian/Ubuntu, run:
```bash
# apt install ripgrep fzf sqlite3 bat build-essential libsqlite3-dev ruby ruby-dev
# gem install sqlite3
```

For **Vim**, you can use
[this](https://github.com/sirupsen/dotfiles/blob/master/home/.vimrc#L480-L517)
in the config to add a `:Note` to add new notes with the prefix, as well as
auto-completion for tags and links. Make sure to use `bouk/vim-markdown` to get
proper highlighting for links.

If you're using `fzf` with `vim`, it's recommended to add this to your `bash`
configuration. It adds super useful key-bindings to open files in splits
(`Ctrl-X`/`Ctrl-V`) from `zkt` and `zks` directly. It also adds `Ctrl-O` to
insert the file-name of whatever you're hovering into Vim, which is handy for
links!:

```bash
export FZF_DEFAULT_OPTS="--height=40% --multi --tiebreak=begin \
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)' \
  --bind 'alt-down:preview-down,alt-up:preview-up' \
  --bind \"ctrl-v:execute-silent[ \
    tmux send-keys -t \{left\} Escape :vs Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-x:execute-silent[ \
    tmux send-keys -t \{left\} Escape :sp Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-o:execute-silent[ \
    tmux send-keys -t \{left\} Escape :read Space ! Space echo Space && \
    tmux send-keys -t \{left\} -l \\\"{}\\\" && \
    tmux send-keys -t \{left\} Enter \
  ]\""
```

## Syncing

I recommend storing the notes in iCloud/Google Drive/Dropbox or whatever you use
to normally sync files. Nice and simple. Some people store them in Git.

[1]: https://github.com/sirupsen/zk/pull/1
[2]: https://obsidian.md/
