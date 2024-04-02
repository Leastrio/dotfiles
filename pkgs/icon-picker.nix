{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "icon-picker.nvim";
  pname = "icon-picker-nvim";
  src = fetchFromGitHub {
    owner = "ziontee113";
    repo = "icon-picker.nvim";
    rev = "e6dca182518eeb7a51470c13605a5bce08a816e4";
    hash = "sha256-/oi2Kj7GDXzN3ccPoxyxXtQTYSxtZndgELZa2XgZ3U8=";
  };
}
