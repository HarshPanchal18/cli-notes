#!/bin/bash

#------------------------------------------
# Purpose:
# Created Date:  Sunday 26 June 2022 03:19:11 PM IST
# Author: Harsh Panchal

# Usage:
#------------------------------------------

[ ! "$EDITOR" ] && EDITOR="vim"
[ ! "$NOTESDIR" ] && NOTESDIR=$HOME/notes

cols=$(tput cols)
hr=$(for((i=0; $i<$cols; $i++));do echo -ne ─; done)

createNote(){
    file=$(echo $1 | sed "s/[^a-zA-Z0-9]/_/g")
    clear
    $EDITOR "$NOTESDIR/$file"
    if [ -f "$NOTESDIR/$file" ]; then
        echo "Note saved: $NOTESDIR/$file"
    else
        echo "Note discarded !"
    fi
    echo
    return 0
}

displayNote(){
    file=$(echo $1|sed "s/[^a-zA-Z0-9]/_/g")
    clear
    
    echo "File name     : $NOTESDIR/$file"
    echo "Created On: $(ls -l $NOTESDIR/$file | awk '{print $6" "$7", "$8}') by $(ls -l $NOTESDIR/$file | awk '{print $3}')"
    echo $hr
    echo
    
    cat "$NOTESDIR/$file"
    echo
    echo $hr

    read -p "> \"e\" to edit, \"r\" to rename, \"d\" to delete [ default: do nothing ] : " ans
    
    [ "$ans" = "e" ] && $EDITOR "$NOTESDIR/$file" && clear && echo "Note saved: $NOTESDIR/$file"
    
    [ "$ans" = "r" ] && clear && read -p "Enter new name: " ans && clear && mv -vi "$NOTESDIR/$file" "$NOTESDIR/$(echo $ans|sed "s/[^a-zA-Z0-9]/_/g")"
    
    [ "$ans" = "d" ] && clear && rm -vi "$NOTESDIR/$file"
    
    return 0
}

[ ! -d "$NOTESDIR" ] && mkdir -p "$NOTESDIR" && echo "Created dir: $NOTESDIR"

[ ! -d "$NOTESDIR" ] && exit 1

if [ "$*" ]; then
    clear
    echo "Searching keywords : $*"
else
    echo
    echo "Usage:   ./notes.sh KEYWORDS [e.g. ./note.sh patching rhel kernel]"
    echo
    exit 1
fi

echo

files=$( grep -iwR $1 $NOTESDIR | cut -d : -f1)
for arg in $*; do
    for file in $files; do
        [ "$(grep -iw $arg $file)" ] || files=$(echo -e "$files"|grep -iwv $file)
    done
done

fileNames=$(ls $NOTESDIR|tr "\t" "\n")
for arg in $*; do
    for fileName in $fileNames;do
        filex=$(echo -e "$filex\n$NOTESDIR/$fileName")
        [ "$(echo $fileName | tr '_' ' ' | grep -iw $arg)" ] || filex=$(echo -e "$filex"|grep -iwv "$NOTESDIR/$fileName")
    done
done

files=$(echo -e "$files\n$filex"|sort -u)

if [ "$files" ]
then
    clear
    echo "Select Option:"
    echo
    opts="@CREATE-NEW-NOTE"
    for file in $files; do
        opts=$(echo -e "$opts\n$(basename $file)")
    done
    opts=$(echo "$opts @EXIT")

    select opt in $opts; do
        [ "$opt" = "@EXIT" ] && break
        [ "$opt" = "@CREATE-NEW-NOTE" ] && createNote "$*" && break
        if [ "$opt" ]; then
            displayNote "$opt"
            break
        fi
    done
else
    clear
    read -p "No note found. Create new note? [ y/N ] : " ans
    if [ "$ans" = "y" ]||[ "$ans" = "Y" ]; then
        createNote "$*"
    else
        clear
    fi
fi
