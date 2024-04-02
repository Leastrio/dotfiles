{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "transparent.nvim";
  pname = "transparent-nvim";
  src = fetchFromGitHub {
    owner = "xiyaowong";
    repo = "transparent.nvim";
    rev = "fd35a46f4b7c1b244249266bdcb2da3814f01724";
    hash = "sha256-wT+7rmp08r0XYGp+MhjJX8dsFTar8+nf10CV9OdkOSk=";
  };
}
