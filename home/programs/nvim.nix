{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nui-nvim
      hologram-nvim
      presence-nvim
      feline-nvim
      catppuccin-nvim
      hop-nvim
      lexima-vim
      nvim-cmp
      cmp-buffer
      cmp-path
      nvim-lspconfig
      cmp-nvim-lsp
      bufferline-nvim
      telescope-nvim
      lspkind-nvim
      rainbow-delimiters-nvim
      nvim-treesitter.withAllGrammars
      luasnip
      which-key-nvim
      plenary-nvim
      nvim-web-devicons
      friendly-snippets
      dressing-nvim
      vim-elixir

      inputs.self.packages.${pkgs.system}.nest-nvim
      inputs.self.packages.${pkgs.system}.icon-picker-nvim
      inputs.self.packages.${pkgs.system}.transparent-nvim
    ];
    extraConfig = ''
      lua <<
        local o = vim.o
        o.termguicolors = true
        o.expandtab = true
        o.shiftwidth = 2
        o.tabstop = 2
        o.number = true
        o.relativenumber = true
        o.completeopt = "menu,menuone,noselect"

        local g = vim.g
        g.mapleader = " "

        require("presence").setup()
        require("feline").setup()
        require("catppuccin").setup()
        require("which-key").setup()
        local transp = require("transparent")
        transp.clear_prefix("BufferLine")
        transp.setup({
          extra_groups = {
            "NormalFloat",
          }
        })

        vim.cmd.colorscheme "catppuccin"

        vim.cmd "syntax on"

        require("hop").setup()
        require("bufferline").setup()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("icon-picker").setup({disable_legacy_commands = true})

        require("nest").applyKeymaps {
          {"<c-c>", [["+y]], mode = "v"},
          {"<leader>", {
            {"hw", "<cmd>HopWord<cr>"},
            {"v", "<cmd>BufferLineCycleNext<cr>"},
            {"c", "<cmd>BufferLineCyclePrev<cr>"},
            {"r", "<cmd>lua vim.lsp.buf.rename()<cr>"},
            {"c", "<cmd>bdelete!<cr>"},
            {"f", "<cmd>Telescope find_files<cr>"},
            {"qf", "<cmd>lua vim.lsp.buf.code_action()<cr>"},
            {"n", "<cmd>IconPickerNormal<cr>"}
          }},
          {"J", "<cmd>lua vim.diagnostic.open_float()<cr>"},
          {"K", "<cmd>lua vim.lsp.buf.hover()<cr>"}
        }

        require("nvim-treesitter.configs").setup {
          ensure_installed = {},
          highlight = {
            enable = true
          }
        }

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
            ["<Tab>"] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,
            ["<S-Tab>"] = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
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
          sources = cmp.config.sources { { name = "nvim_lsp" } }
        }

        local capabilites = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        local lsp = require("lspconfig")
        local servers = {"ccls", "gopls", "rust_analyzer", "pyright"}
        for _, server in ipairs(servers) do
          lsp[server].setup {
            on_attach = on_attach
          }
        end

        local configs = require("lspconfig.configs")
        local lexical_config = {
          filetypes = {"elixir", "eelixir"},
          cmd = { "${inputs.lexical.packages.${pkgs.system}.lexical}/bin/lexical" },
          settings = {}
        }

        if not configs.lexical then
          configs.lexical = {
            default_config = {
              filetypes = lexical_config.filetypes,
              cmd = lexical_config.cmd,
              root_dir = function(fname)
                return lsp.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
              end,
              settings = lexical_config.settings
            }
          }
        end

        lsp.lexical.setup({})
    '';
  };
}
