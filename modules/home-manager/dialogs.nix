{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors.withHashtag;
  raw = config.lib.stylix.colors;

  # Material 3 style dialogs for Qt apps, loaded through qt5ct/qt6ct
  qtDialogs = pkgs.writeText "m3-dialogs.qss" ''
    QMessageBox, QDialog {
      background-color: ${c.base01};
    }

    QMessageBox QLabel#qt_msgboxex_icon_label {
      margin: 24px 0 0 24px;
    }

    QMessageBox QLabel#qt_msgbox_label {
      margin: 24px 24px 0 12px;
      color: ${c.base05};
      font-size: 15pt;
    }

    QMessageBox QLabel#qt_msgbox_informativelabel {
      margin: 8px 24px 20px 12px;
      color: ${c.base04};
    }

    QDialogButtonBox QPushButton {
      min-height: 40px;
      min-width: 64px;
      padding: 0 20px;
      margin: 0 0 12px 8px;
      border: none;
      border-radius: 20px;
      background-color: ${c.base02};
      color: ${c.base0D};
      font-weight: 500;
      icon-size: 0px;
      outline: none;
    }

    QDialogButtonBox QPushButton:hover {
      background-color: #3d${raw.base0D};
    }

    QDialogButtonBox QPushButton:default {
      background-color: ${c.base0D};
      color: ${c.base00};
    }

    QDialogButtonBox QPushButton:default:hover {
      background-color: #d9${raw.base0D};
    }
  '';
in {
  qt.qt5ctSettings.Interface.stylesheets = "${qtDialogs}";
  qt.qt6ctSettings.Interface.stylesheets = "${qtDialogs}";

  # Material 3 style dialogs for GTK3 (GtkMessageDialog) and libadwaita (AdwAlertDialog)
  stylix.targets.gtk.extraCss = ''
    messagedialog.background,
    messagedialog .dialog-action-area {
      background-color: ${c.base01};
    }

    messagedialog .titlebar,
    messagedialog headerbar {
      min-height: 0;
      padding: 0;
      border: none;
      box-shadow: none;
      background: ${c.base01};
    }

    messagedialog .dialog-vbox {
      padding: 24px 24px 0 24px;
    }

    messagedialog label {
      color: ${c.base04};
    }

    messagedialog label.title,
    dialog.alert .message-area .title-2,
    dialog.alert .message-area .title-4 {
      font-size: 1.5em;
      font-weight: 400;
      color: ${c.base05};
    }

    messagedialog .dialog-action-area {
      padding: 20px 24px 24px 24px;
    }

    dialog.alert sheet {
      background-color: ${c.base01};
      border-radius: 28px;
      min-width: 360px;
    }

    dialog.alert .message-area {
      padding: 24px 24px 16px 24px;
    }

    dialog.alert .message-area .body {
      color: ${c.base04};
    }

    dialog.alert .response-area {
      padding: 8px 20px 24px 24px;
    }

    dialog.alert .response-area separator {
      opacity: 0;
      min-width: 0;
      min-height: 0;
    }

    messagedialog .dialog-action-area button,
    dialog.alert .response-area button {
      min-height: 40px;
      padding: 0 16px;
      margin: 0 0 0 8px;
      border: none;
      border-radius: 9999px;
      background-image: none;
      background-color: ${c.base02};
      color: ${c.base0D};
      font-weight: 500;
      box-shadow: none;
    }

    dialog.alert .response-area button {
      margin: 4px;
    }

    messagedialog .dialog-action-area button:hover,
    dialog.alert .response-area button:hover {
      background-color: mix(${c.base02}, ${c.base0D}, 0.15);
    }

    messagedialog .dialog-action-area button.suggested-action,
    dialog.alert .response-area button.suggested-action {
      background-color: ${c.base0D};
      color: ${c.base00};
    }

    messagedialog .dialog-action-area button.suggested-action label,
    dialog.alert .response-area button.suggested-action label {
      color: ${c.base00};
    }

    messagedialog .dialog-action-area button.suggested-action:hover,
    dialog.alert .response-area button.suggested-action:hover {
      background-color: mix(${c.base0D}, ${c.base00}, 0.15);
    }

    messagedialog .dialog-action-area button.destructive-action,
    dialog.alert .response-area button.destructive-action {
      color: ${c.base08};
    }
  '';

  # Native dialogs go through GTK, so they pick up the styling above
  programs.vscode.profiles.default.userSettings."window.dialogStyle" = "native";
}
