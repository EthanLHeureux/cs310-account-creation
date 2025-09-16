#!/usr/bin/env bash
# adduser.sh
# Author:       Ethan L'Heureux
# Description:  Create new accounts with username = first-last

# Ask for the person's full name (ex. John Doe).
echo "Enter full name (ex: John Doe): "
read fullname

# Ask what role they should have.
echo "Enter role (User / AV Tech / Admin): "
read role

# Convert name to lowercase and replace spaces with dashes.
username=${fullname,,}
username=${username// /-}

# Pick groups depending on role.
groups=""
case "${role,,}" in
  "user" )
    groups=""
    echo "Role selected: User (no extra groups)." ;;
  "av tech"|"avtech")    
    groups="video,audio"
    echo "Role selected: AV Tech (groups: video,audio)." ;;
  "admin" )
    groups="root"
    echo "Role selected: Admin (groups: root)." ;;
  * )
    echo "Invalid role: $role"
    exit 1 ;;
esac

# Ask for confirmation before continuing.
echo "Continue with creating account '$username' with these groups? (y/n): "
read confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Account creation cancelled."
  exit 0
fi

# Check if the account already exists.
if id "$username" &>/dev/null; then
  echo "User $username already exists!"
else
  # Create the account with home dir and bash shell.
  sudo useradd -m -s /bin/bash ${groups:+-G $groups} "$username"
  echo "Account created: $username"
  echo "Please set a password now:"
  sudo passwd "$username"
fi