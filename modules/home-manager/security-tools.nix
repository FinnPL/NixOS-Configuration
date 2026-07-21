{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nmap
    netcat-gnu

    tcpdump
    wireshark
    metasploit
  ];
}
