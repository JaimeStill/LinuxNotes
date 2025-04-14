# Tweaks

## Modify Cursors

Repo: [Bibata_Cursor_Translucent](https://github.com/Silicasandwhich/Bibata_Cursor_Translucent)
Guide: [COSMIC - Setting a Cursor Theme](https://www.reddit.com/r/pop_os/comments/1g31qof/cosmic_setting_a_cursor_theme/)

1. Download and extract the latest release for the desired cursor theme.

2. Move the theme to **`/usr/share/icons`**.

3. Add the following variables to **`/etc/environment`**:

    ```sh
    XCURSOR_SIZE=16
    XCURSOR_THEME=Bibata_Ghost
    ```

4. Modify **`/etc/alternatives/x-cursor-theme`**:

    ```ini
    [Icon Theme]
    Inherits=Bibata_Ghost,Adwaita
    ```

5. Adjust GTK applications to follow the cursor theme:

    ```sh
    gsettings set org.gnome.desktop.interface cursor-theme Bibata_Ghost
    ```

6. Create the following directory hierarchy (if it doesn't exist):

    ```sh
    mkdir -p ~/.local/share/icons/default
    ```

7. Create a symlink from the system cursors to your local user profile:

    ```sh
    ln -s /usr/share/icons/default /home/<user>/.local/share/icons/default
    ```

8. Create **`~/.config/gtk-3.0/settings.ini`** (if it doesn't exist) and add the following configuration:

    ```ini
    [Settings]
    gtk-cursor-theme-name="Bibata_Ghost"
    ```