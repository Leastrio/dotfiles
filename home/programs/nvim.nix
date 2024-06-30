{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      presence-nvim
      lualine-nvim
      catppuccin-nvim
      which-key-nvim
      hop-nvim
      bufferline-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-cmp
      nvim-autopairs
      nvim-lspconfig
      cmp-nvim-lsp
      lspkind-nvim
      luasnip
      cmp_luasnip
      rainbow-delimiters-nvim
      nvim-web-devicons
      friendly-snippets

      # Required for icon-picker
      dressing-nvim
      # Required for telescope
      plenary-nvim

      inputs.self.packages.${pkgs.system}.nest-nvim
      inputs.self.packages.${pkgs.system}.icon-picker-nvim
      inputs.self.packages.${pkgs.system}.transparent-nvim
    ];
    extraConfig = ''
      lua <<
        vim.opt.expandtab = true
        vim.opt.incsearch = true
        vim.opt.mouse = "a"
        vim.opt.number = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.splitright = true
        vim.opt.relativenumber = true
        vim.opt.termguicolors = true
        vim.wo.wrap = false
        vim.opt.completeopt = "menu,menuone,noselect"

        vim.g.mapleader = " "
        vim.g.python_recommended_style = 0
        vim.g.rust_recommended_style = 0
        vim.g.elixir_recommended_style = 0

        vim.cmd "syntax on"

        require("presence").setup()
        require("nvim-autopairs").setup {}

        require("lualine").setup {
          options = {
            theme = "catppuccin",
            component_separators = "",
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
            lualine_b = { "filename", "branch", "diagnostics" },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { "filetype", "progress" },
            lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
          },
          inactive_sections = {
            lualine_a = { "filename" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "location" },
          },
          tabline = {},
          extensions = {},
        }

        require("catppuccin").setup({
          flavour = "mocha",
          transparent_background = true,
          integrations = {
            cmp = true,
            treesitter = true,
            hop = true,
            rainbow_delimiters = true,
            telescope = {
              enabled = true
            },
            which_key = true
          }
        })
        vim.cmd.colorscheme "catppuccin"

        require("which-key").setup()

        local transparent = require("transparent")
        transparent.clear_prefix("BufferLine")
        transparent.setup({
          extra_groups = {
            "NormalFloat",
          }
        })

        require("hop").setup()
        require("bufferline").setup()
        require("icon-picker").setup({disable_legacy_commands = true})

        require("nest").applyKeymaps {
          {"<c-c>", [["+y]], mode = "v"},
          {"<leader>", {
            {"hw", "<cmd>HopWord<cr>"},
            {"r", "<cmd>lua vim.lsp.buf.rename()<cr>"},
            {"c", "<cmd>bdelete!<cr>"},
            {"f", "<cmd>Telescope find_files<cr>"},
            {"g", "<cmd>Telescope live_grep<cr>"},
            {"n", "<cmd>IconPickerNormal<cr>"},
            {"qf", "<cmd>lua vim.lsp.buf.code_action()<cr>"}
          }},
          {"J", "<cmd>lua vim.diagnostic.open_float()<cr>"},
          {"K", "<cmd>lua vim.lsp.buf.hover()<cr>"}
        }

        require("nvim-treesitter.configs").setup {
          highlight = {
            enable = true
          }
        }

        require("luasnip.loaders.from_vscode").lazy_load()

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end
          },
          mapping = {
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
            ["<Tab>"] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          },
          formatting = {
            format = lspkind.cmp_format {
              with_text = false,
              maxwidth = 50,
              before = function(entry, vim_item)
                return vim_item
              end
            }
          },
          sources = cmp.config.sources { 
            { name = "nvim_lsp" },
            { name = "luasnip" }
          }
        }

        local lsp = require("lspconfig")
        local configs = require("lspconfig.configs")
        if not configs.lexical then
          configs.lexical = {
            default_config = {
              filetypes = { "elixir", "eelixir", "heex" },
              cmd = { "${pkgs.lexical}/bin/lexical" },
              root_dir = function(fname)
                return lsp.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
              end,
              settings = {}
            }
          }
        end


        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        local servers = { "clangd", "gopls", "rust_analyzer", "pyright", "lexical", "erlangls", "gleam" }
        for _, server in ipairs(servers) do
          lsp[server].setup {
            capabilities = capabilities
          }
        end
    '';
  };
}
