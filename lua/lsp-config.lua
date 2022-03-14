local null_ls = require("null-ls")

local lsp = {}

local opts = {noremap = true, silent = true}

local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {silent = true})
end

local on_attach = function(client, bufnr)
    vim.api.nvim_set_keymap('n', '<Leader>e', "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
        -- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()")
    end
    if client.name == 'jsonls' then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
end

lsp.init = function()
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- UI tweaks from https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
    local border = {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"}, {"│", "FloatBorder"}, {"╯", "FloatBorder"},
        {"─", "FloatBorder"}, {"╰", "FloatBorder"}, {"│", "FloatBorder"}
    }
    local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
    }

    local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if has_cmp_nvim_lsp then capabilities = cmp_nvim_lsp.update_capabilities(capabilities) end

    require'lspconfig'.clangd.setup {capabilities = capabilities, cmd = {'clangd', '--background-index'}, handlers = handlers, on_attach = on_attach}

    local cmd = nil

    require('lspconfig').tsserver.setup({
        capabilities = capabilities,
        handlers = handlers,
        on_attach = function(client, bufnr)
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
            local ts_utils = require("nvim-lsp-ts-utils")
            ts_utils.setup({
                debug = false,
                disable_commands = false,
                enable_import_on_completion = false,

                -- import all
                import_all_timeout = 5000, -- ms
                -- lower numbers = higher priority
                import_all_priorities = {
                    same_file = 1, -- add to existing import statement
                    local_files = 2, -- git files or files with relative path markers
                    buffer_content = 3, -- loaded buffer content
                    buffers = 4 -- loaded buffer names
                },
                import_all_scan_buffers = 100,
                import_all_select_source = false,
                -- if false will avoid organizing imports
                always_organize_imports = true,

                -- filter diagnostics
                filter_out_diagnostics_by_severity = {},
                filter_out_diagnostics_by_code = {},

                -- inlay hints
                auto_inlay_hints = true,
                inlay_hints_highlight = "Comment",
                inlay_hints_priority = 200, -- priority of the hint extmarks
                inlay_hints_throttle = 150, -- throttle the inlay hint request
                inlay_hints_format = { -- format options for individual hint kind
                    Type = {},
                    Parameter = {},
                    Enum = {}
                    -- Example format customization for `Type` kind:
                    -- Type = {
                    --     highlight = "Comment",
                    --     text = function(text)
                    --         return "->" .. text:sub(2)
                    --     end,
                    -- },
                },

                -- update imports on file move
                update_imports_on_move = false,
                require_confirmation_on_move = false,
                watch_dir = nil
            })

            ts_utils.setup_client(client)
            buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
            buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
            buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
            on_attach(client, bufnr)
        end
    })
    require'lspconfig'.vimls.setup {capabilities = capabilities, handlers = handlers, on_attach = on_attach}

    require"lspconfig".efm.setup {
        init_options = {documentFormatting = true},
        filetypes = {"lua"},
        settings = {
            rootMarkers = {".git/"},
            languages = {
                lua = {
                    {
                        formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb",
                        formatStdin = true
                    }
                }
            }
        }
    }

    require'lspconfig'.gopls.setup {}

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = {'pyright', 'rust_analyzer', 'cssmodules_ls', 'graphql', 'html', 'intelephense', 'jsonls', 'yamlls', 'bashls'}
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            flags = {
                -- This will be the default in neovim 0.7+
                debounce_text_changes = 150
            }
        }
    end

    require('lspconfig').tailwindcss.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {tailwindCSS = {classAttributes = {'class', 'className', 'classList'}}}
    }

    require('lspconfig').stylelint_lsp.setup {settings = {stylelintplus = {autoFixOnSave = true, autoFixOnFormat = true}}}
end

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint_d, -- eslint or eslint_d
        null_ls.builtins.code_actions.eslint_d, -- eslint or eslint_d
        null_ls.builtins.formatting.prettierd -- prettier, eslint, eslint_d, or prettierd
    }
})

lsp.init()
