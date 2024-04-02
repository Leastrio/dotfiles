{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "pets.nvim";
  pname = "pets-nvim";
  src = fetchFromGitHub {
    owner = "giusgad";
    repo = "pets.nvim";
    rev = "94b4724e031fc3c9b6da19bdef574f44fabcca16";
    hash = "sha256-CtBCiTo26cTU+q/67QSrondNeyoAdVuIXMHZnxHMIm4=";
  };
}
