{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # File explorer and fuzzy finder
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim

      # Git integration
      gitsigns-nvim
      fugitive

      # UI improvements
      lualine-nvim
      nvim-web-devicons
      indent-blankline-nvim

      # Language support
      vim-nix
      rust-vim
      typescript-vim
      kotlin-vim

      # Utilities
      comment-nvim
      nvim-autopairs
      which-key-nvim
      plenary-nvim
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      vim.opt.termguicolors = true
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.isfname:append("@-@")
      vim.opt.updatetime = 50
      vim.opt.colorcolumn = "80"

      -- Set leader key
      vim.g.mapleader = " "

      -- Key mappings
      local keymap = vim.keymap.set

      -- File explorer
      keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

      -- Telescope
      keymap("n", "<leader>ff", ":Telescope find_files<CR>")
      keymap("n", "<leader>fg", ":Telescope live_grep<CR>")
      keymap("n", "<leader>fb", ":Telescope buffers<CR>")
      keymap("n", "<leader>fh", ":Telescope help_tags<CR>")

      -- Window navigation
      keymap("n", "<C-h>", "<C-w>h")
      keymap("n", "<C-j>", "<C-w>j")
      keymap("n", "<C-k>", "<C-w>k")
      keymap("n", "<C-l>", "<C-w>l")

      -- Buffer management
      keymap("n", "<leader>bn", ":bnext<CR>")
      keymap("n", "<leader>bp", ":bprevious<CR>")
      keymap("n", "<leader>bd", ":bdelete<CR>")

      -- Plugin configurations

      -- Nvim Tree
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })

      -- Telescope
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
            }
          }
        }
      })
      require("telescope").load_extension("fzf")

      -- Treesitter
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })

      -- LSP Configuration
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- C/C++ LSP
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
        },
      })

      -- Python LSP
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Java LSP
      lspconfig.jdtls.setup({
        capabilities = capabilities,
        cmd = { "jdtls" },
        settings = {
          java = {
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
          },
          contentProvider = { preferred = "fernflower" },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "$(object.className){$(member.name())=$(member.value), $(otherMembers)}",
            },
            useBlocks = true,
          },
        },
      })

      -- Kotlin LSP
      lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
      })

      -- Rust LSP
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })

      -- Nix LSP
      lspconfig.nixd.setup({
        capabilities = capabilities,
      })

      -- TypeScript LSP
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- LSP key mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          keymap("n", "gD", vim.lsp.buf.declaration, opts)
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "gi", vim.lsp.buf.implementation, opts)
          keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "<leader>f", function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      -- Completion setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Lualine
      require("lualine").setup({
        options = {
          theme = "dracula",
          component_separators = { left = "", right = ""},
          section_separators = { left = "", right = ""},
        },
      })

      -- Git signs
      require("gitsigns").setup()

      -- Comment plugin
      require("Comment").setup()

      -- Autopairs
      require("nvim-autopairs").setup()

      -- Which-key
      require("which-key").setup()

      -- Indent blankline
      require("ibl").setup()
    '';
  };

  # Additional packages that Neovim might need
  home.packages = with pkgs; [
    # Language servers
    nixd
    rust-analyzer
    nodePackages.typescript-language-server
    pyright
    clang-tools
    jdt-language-server
    kotlin-language-server

    # Additional tools
    ripgrep
    fd
    tree-sitter
  ];
}
