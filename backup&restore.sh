#!/bin/bash

##################
#Author: PHILIPS
#Date: 14/07/2025
# A simple back up script to back up files to a specified directory.
################

# Error exit function
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# backup directory creation
user=$(whoami) || error_exit "Could not determine the current user"
mkdir -p /home/$user/backups || error_exit "Could not create backup directory"

# Source dir var
read -p "Enter the source directory to back up (e.g., /home/$user/documents): " source_dir || error_exit "Could not read user input"

#ask user if they have set source directory
read -p "Have you set the source directory? (y/n): " choice || error_exit "Could not read user input"
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Source directory is set at $source_dir, proceeding with the backup..."
    echo "------------------------------------------"
    echo "Starting backup script..."
    echo "loading..."
      sleep 2
fi
if [[ "$choice" == "n" || "$choice" == "N" ]]; then
    echo "Please set the source directory before running the backup"
    exit 1
fi

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
    error_exit "Source directory $source_dir does not exist"
fi


# other variables
backup_dir="/home/$user/backups" || error_exit "Backup directory does not exist"
date=$(date +%Y%m%d_%H%M%S) || error_exit "Could not get the current date"
backup_file="$backup_dir/backup_$date.tar.gz" || error_exit "Could not create backup file path"

# Install tar if not installed
if ! command -v tar &> /dev/null; then
    echo "tar could not be found, installing..." 
    echo "------------------------------------------"
    sudo apt-get update || error_exit "Could not update package list" 
    sudo apt-get install tar -y || error_exit "Could not install tar"
    echo "------------------------------------------"
    echo "tar installed successfully"
    echo "*****************************"
fi

# ask user if they want to proceed with the backup
read -p "Do you want to proceed with the backup of $source_dir to $backup_file? (y/n): " choice || error_exit "Could not read user input"
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Creating backup of $source_dir to $backup_file"
    tar -czf "$backup_file" -C "$source_dir" . || error_exit "Could not create backup file"
    echo "------------------------------------------"
    echo "Backup created successfully at $backup_file"
    echo "*****************************"
else
    echo "Backup creation skipped by user"
    echo "------------------------------------------"
    echo "No backup script completed"
    echo "*****************************"
fi

#listing backup files
echo "Listing backup files in $backup_dir"
ls -lh "$backup_dir" || error_exit "Could not list backup files"
echo "------------------------------------------"
echo "All backup scripts listed successfully"

echo "*****************************"

# Ask user if the want to restore backed up files and choose the backup file to restore from
read -p "Do you want to restore the backup? (y/n): " choice || error_exit "Could not read user input"
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Available backup files:"
    ls -lh "$backup_dir" || error_exit "Could not list backup files"
    read -p "Enter the backup file path to restore eg /home/user/backups/backup_20230101_120000.tar.gz: " restore_file || error_exit "Could not read user input"
    if [ -f "$restore_file" ]; then
        echo "Restoring backup from $restore_file to $source_dir"
        tar -xzf "$restore_file" -C "$source_dir" || error_exit "Could not restore backup file"
        echo "------------------------------------------"
        echo "Backup restored successfully from $restore_file"
        echo "*****************************"
        echo "Listing restored files in $source_dir"
        ls -lh "$source_dir" || error_exit "Could not list restored files"
        echo "------------------------------------------"
        echo "All restored files listed successfully"
        echo "*****************************"
    else
        echo "No backup file found at $restore_file"
        echo "------------------------------------------"
        echo "Backup restore failed"
        echo "*****************************"
    fi
else
    echo "Backup restore skipped by user"
    echo "------------------------------------------"
    echo "Backup script completed successfully"
    echo "*****************************"
fi


