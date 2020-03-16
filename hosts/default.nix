# Common host configuration.
{ config, pkgs, lib, ... }:
{ imports = [
    ../cachix.nix # Cachix Binary Cache
    ../hardware-configuration.nix # Autogenerated
  ];
  boot.loader.timeout = 1; # Set timeout to 1 for faster boot speeds.
  boot.kernelModules = [
    "tcp_bbr"
    "bfq"
  ];
  boot.kernel.sysctl = {
  "net.core.default_qdisc"             = "fq";
  "net.ipv4.tcp_congestion_control"    = "bbr";
  "net.ipv4.tcp_slow_start_after_idle" = "0"; # Should help to improve performance in some cases.
  };

  console.useXkbConfig = true; # Use keymap from xserver.

  environment.checkConfigurationOptions = true;
  environment.systemPackages = with pkgs; [ # Try to keep cli utils in this global config, we don't know if x11 or audio will be installed, or if this will be a server.
  # applications/editors
  vim # The most popular clone of the VI editor
  # applications/misc
  calcurse # A calendar and scheduling application for the command line
  wtf # The personal information dashboard for your terminal
  # applications/version-management
  gitAndTools.gitFull # Distributed version control system
  # development/libraries
  libnotify # A library that sends desktop notifications to a notification daemon
  #development/tools
  pkgconf # Package compiler and linker metadata toolkit
  # os-specific/linux
  hdparm # A tool to get/set ATA/SATA drive parameters under Linux
  kexectools # Tools related to the kexec Linux feature
  psmisc # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
  # shells
  dash # A POSIX-compliant implementation of /bin/sh that aims to be as small as possible
  mksh # MirBSD Korn Shell
  rc # The Plan 9 shell
  # tools/archivers
  p7zip # A port of the 7-zip archiver
  unzip # An extraction utility for archives compressed in .zip format
  zip # Compressor/archiver for creating and modifying zipfiles
  # tools/misc
  abduco # Allows programs to be run independently from its controlling terminal
  cloc # A program that counts lines of source code
  dvtm # Dynamic virtual terminal manager
  entr # Run arbitrary commands when files change
  file # A program that shows the type of files
  mc # File Manager and User Shell for the GNU Project
  ncdu # Disk usage analyzer with an ncurses interface
  pfetch # A pretty system information tool written in POSIX sh
  scanmem # Memory scanner for finding and poking addresses in executing processes
  snore # sleep with feedback
  xclip # Tool to access the X clipboard from a console application
  # tools/networking
  bwm_ng # A small and simple console-based live network and disk io bandwidth monitor
  curlFull # A command line tool for transferring files with URL syntax
  #inetutils # Collection of common network programs
  tftp-hpa # TFTP tools - a lot of fixes on top of BSD TFTP
  wget # Tool for retrieving files using HTTP, HTTPS, and FTP
  # tools/package-management
  appimagekit # A tool to package desktop applications as AppImages
  # tools/security
  mkpasswd # Overfeatured front-end to crypt, from the Debian whois package
  # tools/system
  htop # An interactive process viewer for Linux
  hwinfo # Hardware detection tool from openSUSE
  nq # Unix command line queue utility
  pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
  plan9port # Plan 9 from User Space
  ];

  hardware.ksm.enable = true; # Kernel Same-Page Merging, can be suitable for more than Virtual Machine use, as it's useful for any application which generates many instances of the same data.

  location.provider = "geoclue2";

  nix.autoOptimiseStore = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  nix.maxJobs = lib.mkDefault 2;
  nix.trustedUsers = [ "root" "@wheel" ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };

  powerManagement.enable = lib.mkDefault false;

  programs.dconf.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.mosh.enable = true;
  programs.nano.syntaxHighlight = true;
  programs.tmux.enable = true;
  programs.tmux.keyMode = "vi";

  security.hideProcessInformation = true;

  services.earlyoom.enable = true; # Enable early out of memory killing.
  services.earlyoom.freeMemThreshold = 3;
  services.fail2ban.enable = true;
  services.flatpak.enable = true;
  services.fstrim.enable = true;
  services.logind.extraConfig = ''KillUserProcesses=yes
    HandlePowerKey=ignore'';
  services.openssh.enable = true;
  services.timesyncd.enable = true;

  system.autoUpgrade.enable = true;
  system.stateVersion = "20.03"; # Check release notes before changing this. *insert scary warning here*

  systemd.extraConfig = "DefaultLimitNOFILE=1048576"; # Set limits for Esync: https://github.com/lutris/lutris/wiki/How-to:-Esync

  time.timeZone = "America/Los_Angeles"; # Set this to your local timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
}
