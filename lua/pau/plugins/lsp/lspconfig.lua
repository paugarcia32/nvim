return {
  "neovim/nvim-lspconfig",
  event = { "User FilePost"},
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end



    local my_arduino_fqbn = {
        ["COM4"] = "esp32:esp32:esp32doit-devkit-v1",
        -- ["/home/h4ck3r/dev/arduino/sensor"] = "arduino:mbed:nanorp2040connect",
    }

    local DEFAULT_FQBN = "esp32:esp32:esp32doit-devkit-v1"

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,

      ["arduino_language_server"] = function()
        -- configure lua server (with special settings)
        lspconfig["arduino_language_server"].setup({
          capabilities = {
            general = {
              positionEncodings = { "utf-16" }
            },
            textDocument = {
              callHierarchy = {
                dynamicRegistration = false
              },
              codeAction = {
                codeActionLiteralSupport = {
                  codeActionKind = {
                    valueSet = { "", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports" }
                  }
                },
                dataSupport = true,
                dynamicRegistration = true,
                isPreferredSupport = true,
                resolveSupport = {
                  properties = { "edit" }
                }
              },
              completion = {
                completionItem = {
                  commitCharactersSupport = false,
                  deprecatedSupport = false,
                  documentationFormat = { "markdown", "plaintext" },
                  preselectSupport = false,
                  snippetSupport = false
                },
                completionItemKind = {
                  valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
                },
                completionList = {
                  itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" }
                },
                contextSupport = false,
                dynamicRegistration = false
              },
              declaration = {
                linkSupport = true
              },
              definition = {
                dynamicRegistration = true,
                linkSupport = true
              },
              diagnostic = {
                dynamicRegistration = false
              },
              documentHighlight = {
                dynamicRegistration = false
              },
              documentSymbol = {
                dynamicRegistration = false,
                hierarchicalDocumentSymbolSupport = true,
                symbolKind = {
                  valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
                }
              },
              formatting = {
                dynamicRegistration = true
              },
              hover = {
                contentFormat = { "markdown", "plaintext" },
                dynamicRegistration = true
              },
              implementation = {
                linkSupport = true
              },
              inlayHint = {
                dynamicRegistration = true,
                resolveSupport = {
                  properties = { "textEdits", "tooltip", "location", "command" }
                }
              },
              publishDiagnostics = {
                dataSupport = true,
                relatedInformation = true,
                tagSupport = {
                  valueSet = { 1, 2 }
                }
              },
              rangeFormatting = {
                dynamicRegistration = true
              },
              references = {
                dynamicRegistration = false
              },
              rename = {
                dynamicRegistration = true,
                prepareSupport = true
              },
              semanticTokens = vim.NIL,
              signatureHelp = {
                dynamicRegistration = false,
                signatureInformation = {
                  activeParameterSupport = true,
                  documentationFormat = { "markdown", "plaintext" },
                  parameterInformation = {
                    labelOffsetSupport = true
                  }
                }
              },
              synchronization = {
                didSave = true,
                dynamicRegistration = false,
                willSave = true,
                willSaveWaitUntil = true
              },
              typeDefinition = {
                linkSupport = true
              }
            },
            window = {
              showDocument = {
                support = true
              },
              showMessage = {
                messageActionItem = {
                  additionalPropertiesSupport = false
                }
              },
              workDoneProgress = true
            },
            workspace = {
              applyEdit = true,
              configuration = true,
              didChangeConfiguration = {
                dynamicRegistration = false
              },
              didChangeWatchedFiles = {
                dynamicRegistration = true,
                relativePatternSupport = true
              },
              inlayHint = {
                refreshSupport = true
              },
              semanticTokens = vim.NIL,
              symbol = {
                dynamicRegistration = false,
                symbolKind = {
                  valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
                }
              },
              workspaceEdit = {
                resourceOperations = { "rename", "create", "delete" }
              },
              workspaceFolders = true
            }
          },
          filetypes = { "arduino" },
          cmd = {
              "arduino-language-server",
              "-cli-config", "/Users/Pau/AppData/Local/Arduino15/arduino-cli.yaml",
              "-fqbn",
              "esp32:esp32:esp32doit-devkit-v1"
          },
          -- on_new_config = function ()

          --     config.cmd = {
          --         "arduino-language-server",
          --         "-cli-config", "/Users/Pau/AppData/Local/Arduino15/arduino-cli.yaml",
          --         "-fqbn",
          --         DEFAULT_FQBN
          --     }
          -- end
        })
      end,
    })
  end,
}