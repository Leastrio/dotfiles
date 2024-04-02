{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "nest.nvim";
  pname = "nest-nvim";
  src = fetchFromGitHub {
    owner = "lionc";
    repo = "nest.nvim";
    rev = "e5da827a3adfb383b56587bdf4eb62fae4154364";
    hash = "sha256-A0+PdIU5P5EQuonJZpIpinGe1fzXiy7oQ5wvCLoN/fk=";
  };
}
