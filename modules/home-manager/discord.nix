{pkgs, ...}: let
  # CSS to map Stylix base16 colors to Midnight Discord theme variables
  midnightStylixCss = ''
    /**
     * Midnight Discord theme with Stylix colors
     * This maps Stylix base16 variables to Midnight theme variables
     */

    body {
      /* font options */
      --font: 'figtree';
      --code-font: "";

      /* sizes */
      --gap: 12px;
      --divider-thickness: 4px;
      --border-thickness: 1px;

      /* animation options */
      --animations: on;
      --list-item-transition: 0.2s ease;
      --dms-icon-svg-transition: 0.4s ease;
      --border-hover-transition: 0.2s ease;

      /* top bar options */
      --top-bar-height: 32px;
      --top-bar-button-position: titlebar;
      --top-bar-title-position: off;
      --subtle-top-bar-title: off;

      /* chatbar options */
      --custom-chatbar: aligned;
      --chatbar-height: 47px;

      /* dms button options */
      --custom-dms-icon: custom;
      --dms-icon-svg-url: url('https://refact0r.github.io/midnight-discord/assets/Font_Awesome_5_solid_moon.svg');
      --dms-icon-svg-size: 90%;
      --custom-dms-background: off;

      /* window control options */
      --custom-window-controls: on;
      --window-control-size: 14px;

      /* other options */
      --small-user-panel: off;
      --colors: on;

      /* text colors - using Stylix base16 variables */
      --text-0: var(--base00);
      --text-1: #ffffff;
      --text-2: #f0f0f0;
      --text-3: #e0e0e0;
      --text-4: var(--base04);
      --text-5: var(--base03);

      /* background colors - using Stylix base16 variables */
      --bg-1: var(--base02);
      --bg-2: var(--base01);
      --bg-3: var(--base01);
      --bg-4: var(--base00);
      --hover: hsla(220, 19%, 40%, 0.1);
      --active: hsla(220, 19%, 40%, 0.2);
      --active-2: hsla(220, 19%, 40%, 0.3);
      --message-hover: hsla(230, 0%, 0%, 0.1);

      /* accent colors - using Stylix base16 variables */
      --accent-1: var(--base0D);
      --accent-2: var(--base0D);
      --accent-3: var(--base0D);
      --accent-4: var(--base0C);
      --accent-5: var(--base0C);
      --accent-new: var(--base0D);
      --mention: linear-gradient(to right, color-mix(in hsl, var(--base0D), transparent 90%) 40%, transparent);
      --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--base0D), transparent 95%) 40%, transparent);
      --reply: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent);
      --reply-hover: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent);

      /* status colors */
      --online: var(--base0B);
      --dnd: var(--base08);
      --idle: var(--base0A);
      --streaming: var(--base0E);
      --offline: var(--text-4);

      /* border colors */
      --border-light: hsla(230, 20%, 40%, 0.1);
      --border: hsla(230, 20%, 40%, 0.2);
      --button-border: hsla(0, 0%, 100%, 0.1);

      /* base colors - all mapped from Stylix */
      --red-1: var(--base08);
      --red-2: var(--base08);
      --red-3: var(--base08);
      --red-4: var(--base08);
      --red-5: var(--base08);

      --green-1: var(--base0B);
      --green-2: var(--base0B);
      --green-3: var(--base0B);
      --green-4: var(--base0B);
      --green-5: var(--base0B);

      --blue-1: var(--base0D);
      --blue-2: var(--base0D);
      --blue-3: var(--base0D);
      --blue-4: var(--base0D);
      --blue-5: var(--base0D);

      --yellow-1: var(--base0A);
      --yellow-2: var(--base0A);
      --yellow-3: var(--base0A);
      --yellow-4: var(--base0A);
      --yellow-5: var(--base0A);

      --purple-1: var(--base0E);
      --purple-2: var(--base0E);
      --purple-3: var(--base0E);
      --purple-4: var(--base0E);
      --purple-5: var(--base0E);
    }
  '';
in {
  programs.nixcord = {
    enable = true;
    vesktop.enable = true;

    config = {
      useQuickCss = true;

      themeLinks = [
        "https://refact0r.github.io/midnight-discord/build/midnight.css"
      ];

      plugins = {
        biggerStreamPreview.enable = true;
        messageLogger.enable = true;
        callTimer.enable = true;
        clearUrLs.enable = true;
        permissionsViewer.enable = true;
        platformIndicators.enable = true;
        relationshipNotifier.enable = true;
        showHiddenChannels.enable = true;
        typingIndicator.enable = true;
      };
    };

    quickCss = "";
  };

  # Stylix will generate a theme with --base00 through --base0F CSS variables
  stylix.targets.nixcord.enable = true;

  # Extra CSS to map Stylix base16 colors to Midnight Discord theme variables
  stylix.targets.nixcord.extraCss = midnightStylixCss;
}
