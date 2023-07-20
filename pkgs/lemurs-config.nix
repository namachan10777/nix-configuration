{ pkgs, xsessionDir, xsessionOption }: {
  config = ''
    # Possible values:
    # - default: Initially focus on first non-cached value
    # - no-focus: No initial focus
    # - environment: Initially focus on the environment selector
    # - username: Initially focus on the username field
    # - password: Initially focus on the password field
    focus_behaviour = "default"

    [power_controls]
    # Allow for the shutdown option to be used
    allow_shutdown = true
    # The text in the top-left to display how to shutdown. The text '%key%' will be
    # replaced with the shutdown_key.
    shutdown_hint = "Shutdown %key%"

    # The color and modifiers of the hint in the top-left corner
    shutdown_hint_color = "dark gray"
    shutdown_hint_modifiers = ""

    # The key used to shutdown. Possibilities are F1 to F12.
    shutdown_key = "F1"
    # The command that is executed when the key is pressed
    shutdown_cmd = "${pkgs.systemd}/bin/systemctl poweroff -l"

    # Allow for the reboot option to be used
    allow_reboot = true

    # The text in the top-left to display how to reboot. The text '%key%' will be
    # replaced with the shutdown_key.
    reboot_hint = "Reboot %key%"

    # The color and modifiers of the hint in the top-left corner
    reboot_hint_color = "dark gray"
    reboot_hint_modifiers = ""

    # The key used to reboot. Possibilities are F1 to F12.
    reboot_key = "F2"
    # The command that is executed when the key is pressed
    reboot_cmd = "${pkgs.systemd}/bin/systemctl reboot -l"

    # The margin between the shutdown and reboot hints
    hint_margin = 2

    # Setting for the selector of the desktop environment you are using.
    [environment_switcher]
    # Terms:
    # ---------
    # Movers: indicators which show which direction one can move whilst selecting
    # the desktop environment
    # Selected: The currently selected desktop environment.
    # Neighbours: The adjacent desktop environment to the one current selected
    #
    # Visualisation:
    #
    #    <     i3       bspwm     awesome   >
    #
    #    ^      ^         ^          ^      ^
    #    |      |         |          |      |
    #  mover    |      selected      |    mover
    #           |                    |      
    #       neighbour            neighbour
    # ---------
    #

    # Show an option for the TTY shell when logging in as one of the environments. 
    # NOTE: it is always shown when no viable options are found. 
    include_tty_shell = false

    # Remember the selected environment after logging in for the next time
    remember = true

    # Enables showing the movers
    show_movers = true

    # Mover's color and modifiers whilst the selector is unfocused
    mover_color = "dark gray" 
    mover_modifiers = ""

    # Mover's color and modifiers whilst the selector is focused
    mover_color_focused = "orange"
    mover_modifiers_focused = "bold" 

    # The characters used to display the movers. Suggestions are:
    # -  "<"  ">"
    # - "<-"  "->"
    # - "<<"  ">>"
    # -  "["  "]"
    left_mover = "<"
    right_mover = ">"

    # The margin between the movers and the neighbours or selected (depending on
    # `show_neighbours`)
    mover_margin = 1

    # Enables showing the neighbours
    show_neighbours = true

    # Neighbours' color and modifiers whilst the selector is unfocused
    neighbour_color = "dark gray"
    neighbour_modifiers = ""

    # Neighbours' color and modifiers whilst the selector is focused
    neighbour_color_focused = "gray"
    neighbour_modifiers_focused = ""

    # Margin between neighbours and selected
    neighbour_margin = 1

    # Selected's color and modifiers whilst the selector is unfocused
    selected_color = "gray"
    selected_modifiers = "underlined"

    # Selected's color and modifiers whilst the selector is focused
    selected_color_focused = "white"
    selected_modifiers_focused = "bold"

    # The length of the name of the desktop environment which is displayed.
    max_display_length = 8

    # The text used when no desktop environments are available
    no_envs_text = "No environments..."

    # The color and modifiers of the 'no desktop environments available text'
    # whilst the selector is unfocused
    no_envs_color = "white"
    no_envs_modifiers = ""

    # The color and modifiers of the 'no desktop environments available text'
    # whilst the selector is focused
    no_envs_color_focused = "red"
    no_envs_modifiers_focused = ""

    [username_field]

    # Remember the username for the next time after a successful login attempt.
    remember = true

    [username_field.style]
    # Enables showing a title
    show_title = true
    # The text used within the title
    title = "Login"

    # The title's color and modifiers whilst the username field is unfocused
    title_color = "white"
    content_color = "white"

    # The title's color and modifiers whilst the username field is focused
    title_color_focused = "orange"
    content_color_focused = "orange"

    # Enables showing the borders
    show_border = true
    # The borders' color and modifiers whilst the username field is unfocused
    border_color = "white"
    # The borders' color and modifiers whilst the username field is focused
    border_color_focused = "orange"

    # Constrain the width of the username field
    use_max_width = true
    # The contraint of the username field's width
    max_width = 48

    [password_field]

    # The character used for replacement when typing a password. Leave empty for no
    # feedback.
    # Note: Only one character is accepted.
    content_replacement_character = "*"

    [password_field.style]
    # Enables showing a title
    show_title = true
    # The text used within the title
    title = "Password"

    # The title's color and modifiers whilst the password field is unfocused
    title_color = "white"
    content_color = "white"

    # The title's color and modifiers whilst the password field is focused
    title_color_focused = "orange"
    content_color_focused = "orange"

    # Enables showing the borders
    show_border = true
    # The borders' color and modifiers whilst the username field is unfocused
    border_color = "white"
    # The borders' color and modifiers whilst the username field is focused
    border_color_focused = "orange"

    # Constrain the width of the password field
    use_max_width = true
    # The contraint of the password field's width
    max_width = 48

  '';
  xsetup = ''
    #! ${pkgs.bash}/bin/bash
    # Xsession - run as user
    # Copyright (C) 2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>

    # This file is extracted from kde-workspace (kdm/kfrontend/genkdmconf.c)
    # Copyright (C) 2001-2005 Oswald Buddenhagen <ossi@kde.org>

    # Note that the respective logout scripts are not sourced.
    case $SHELL in
      */bash)
        [ -z "$BASH" ] && exec $SHELL $0 "$@"
        set +o posix
        [ -f /etc/profile ] && . /etc/profile
        if [ -f $HOME/.bash_profile ]; then
          . $HOME/.bash_profile
        elif [ -f $HOME/.bash_login ]; then
          . $HOME/.bash_login
        elif [ -f $HOME/.profile ]; then
          . $HOME/.profile
        fi
        ;;
    */zsh)
        [ -z "$ZSH_NAME" ] && exec $SHELL $0 "$@"
        [ -d /etc/zsh ] && zdir=/etc/zsh || zdir=/etc
        zhome=${ZDOTDIR:-$HOME}
        # zshenv is always sourced automatically.
        [ -f $zdir/zprofile ] && . $zdir/zprofile
        [ -f $zhome/.zprofile ] && . $zhome/.zprofile
        [ -f $zdir/zlogin ] && . $zdir/zlogin
        [ -f $zhome/.zlogin ] && . $zhome/.zlogin
        emulate -R sh
        ;;
      */csh|*/tcsh)
        # [t]cshrc is always sourced automatically.
        # Note that sourcing csh.login after .cshrc is non-standard.
        xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
        $SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) source ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
        . $xsess_tmp
        rm -f $xsess_tmp
        ;;
      */fish)
        [ -f /etc/profile ] && . /etc/profile
        xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
        $SHELL --login -c "/bin/sh -c 'export -p' > $xsess_tmp"
        . $xsess_tmp
        rm -f $xsess_tmp
        ;;
      *) # Plain sh, ksh, and anything we do not know.
        [ -f /etc/profile ] && . /etc/profile
        [ -f $HOME/.profile ] && . $HOME/.profile
        ;;
    esac

    [ -f /etc/xprofile ] && . /etc/xprofile
    [ -f $HOME/.xprofile ] && . $HOME/.xprofile

    # run all system xinitrc shell scripts.
    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for i in /etc/X11/xinit/xinitrc.d/* ; do
      if [ -x "$i" ]; then
        . "$i"
      fi
      done
    fi

    # Load Xsession scripts
    # OPTIONFILE, USERXSESSION, USERXSESSIONRC and ALTUSERXSESSION are required
    # by the scripts to work
    xsessionddir="${xsessionDir}"
    OPTIONFILE=${xsessionOption}
    USERXSESSION=$HOME/.xsession
    USERXSESSIONRC=$HOME/.xsessionrc
    ALTUSERXSESSION=$HOME/.Xsession

    if [ -d "$xsessionddir" ]; then
        for i in `ls $xsessionddir`; do
            script="$xsessionddir/$i"
            echo "Loading X session script $script"
            if [ -r "$script"  -a -f "$script" ] && expr "$i" : '^[[:alnum:]_-]\+$' > /dev/null; then
                . "$script"
            fi
        done
    fi

    if [ -d /etc/X11/Xresources ]; then
      for i in /etc/X11/Xresources/*; do
        [ -f $i ] && ${pkgs.xorg.xrdb}/bin/xrdb -merge $i
      done
    elif [ -f /etc/X11/Xresources ]; then
      ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresources
    fi
    [ -f $HOME/.Xresources ] && ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources

    if [ -f "$USERXSESSION" ]; then
      . "$USERXSESSION"
    fi

    if [ -z "$*" ]; then
        exec ${pkgs.xorg.xmessage}/bin/xmesasge -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
    else
        exec $@
    fi
  '';
}
