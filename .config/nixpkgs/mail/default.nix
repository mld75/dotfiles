{ pkgs, config, lib ? pkgs.stdenv.lib, ... }:
{
  home = {
    packages = with pkgs; [
      isync
      mu
    ];
  };

  programs.mbsync = {
    enable = true;
    extraConfig = ''
Sync All
Create Both
Remove None
Expunge Both
CopyArrivalDate yes
SyncState *
'';
  };
  programs.msmtp = {
    enable = true;
    extraConfig = ''
# Global Settings
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt'';
  };

  accounts.email = {
    accounts = {
      gmail = {
        primary = true;
        flavor = "gmail.com";
        imap = {
          host = "imap.gmail.com";
          port = 993;
        };
        smtp = {
          host = "smtp.gmail.com";
        };
        address = "joern.gersdorf@gmail.com";
        aliases = [
          "joern@gersdorf.info"
          "j0xaf@j0xaf.de"
          "familie@gersdorf.info"
          "modeless@modeless.de"
        ];
        realName = "Jörn Gersdorf";
        userName = "joern.gersdorf";
        passwordCommand = "pass gmail.com/isync.sun";

        mbsync = {
          enable = true;
          create = "both";
          remove = "none";
          expunge = "both";

          groups.personal = {
            channels = {
              inbox = {
                farPattern = "";
                nearPattern = "";
              };
              sent = {
                farPattern = config.accounts.email.accounts.gmail.folders.sent;
                nearPattern = "Sent";
              };
              trash = {
                farPattern = config.accounts.email.accounts.gmail.folders.trash;
                nearPattern = "Trash";
              };
              starred = {
                farPattern = "[Gmail]/Starred";
                nearPattern = "Starred";
              };
              drafts = {
                farPattern = config.accounts.email.accounts.gmail.folders.drafts;
                nearPattern = "Drafts";
              };
              archive = {
                farPattern = "[Gmail]/All Mail";
                nearPattern = "Archive";
              };
            };
          };
          extraConfig.account = {
            PipelineDepth = 50;
            AuthMechs = "LOGIN";
            SSLType = "IMAPS";
            SSLVersions = "TLSv1.2";
          };
          extraConfig.remote = {
            Account = "gmail";
          };
          extraConfig.local = {
            SubFolders = "Verbatim";
          };
        };

        mu.enable = true;

        msmtp = {
          enable = true;
          extraConfig = {
            host = "smtp.gmail.com";
            port = "587";
            protocol = "smtp";
            auth = "on";
            tls = "on";
            tls_starttls = "on";
            from = "joern@gersdorf.info";
            user = config.accounts.email.accounts.gmail.userName;
          };
        };

        maildir.path = "Gmail";

        folders = {
          drafts = "[Gmail]/Drafts";
          inbox = "Inbox";
          sent = "[Gmail]/Sent Mail";
          trash = "[Gmail]/Trash";
        };
      };
    };
  };

  services.mbsync = {
    enable = false;
    # description = "mbsync Mailbox Synchronization Service";
    # Have to use /run/current-system/... because I am running the unstable
    # version of mu, because mu 1.2 is out of date, and in stable.
    # I can switch to ${pkgs.mu} once NixOS 20.09 comes out.
    #postExec = "/run/current-system/sw/bin/mu index";
    postExec = "${pkgs.mu}/bin/mu index";
    frequency = "*-*-* *:0/5"; # Run this service every 5 minutes.
    verbose = true;
  };
}
