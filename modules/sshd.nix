{ username, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 54322 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ username ];
    };
  };
}
