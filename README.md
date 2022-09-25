# cli-notes

=======
Probably the simplest and lightest notes taking tool on your terminal.

<!--[![asciicast](https://asciinema.org/a/245695.svg)](https://asciinema.org/a/245695)-->

Give execute permission

```bash
chmod +x notes.sh
```

Create your 1st notes (Tip: default editor is vi; to change it, edit $EDITOR variable in note.sh)

```bash
./notes.sh my first note
```

Write "I love Linux" and close editor. notes is created. Now lets find the note

```bash
./notes.sh Linux
```

or

```bash
./notes.sh first note
```

Customization
-------------
Change default editor or notess directory using followig environment variables.

```bash
export EDITOR="vim"                     # Or you favourite text editor
export notesSDIR="$HOME/mynotes"        # Or any location you have write access to
```
