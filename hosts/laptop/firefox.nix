{
  ...
}:
{
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/@testpilot-containers/latest.xpi";
          installation_mode = "normal_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi";
          installation_mode = "normal_installed";
        };
        "foxyproxy@eric.h.jung" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/foxyproxy@eric.h.jung/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };
}
