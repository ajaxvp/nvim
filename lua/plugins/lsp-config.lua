-- This file contains all of the LSP configurations
return {
	{
		"mason-org/mason.nvim",
		opts = {},
		event = "VeryLazy",
	},
	-- Define which LSPs should be autoinstalled here
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				"lua_ls",
				"clangd",
				"ts_ls",
				"html",
				"cssmodules_ls",
				"css_variables",
				"cssls",
				"jsonls",
				"bashls",
				"lemminx",
                "basedpyright@1.39.9",
                "ruff",
                "jdtls",
			},
			handlers = nil,
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {},
	},
	-- completition library
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			-- local util = require("lspconfig/util")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- use vsnip
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" }, -- For vsnip users.
					{ name = "crates" },
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = {
							menu = 50,
							abbr = 50,
						},
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"mrcjkb/rustaceanvim",
			"aznhe21/actions-preview.nvim",
		},
		config = function(_, _)
			-- Set up lspconfig.
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
				-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
				vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
				vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, {})
                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
				vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

				-- inline type hints
				local caps = client.server_capabilities
				if vim.lsp.inlay_hint and (caps.inlayHintProvider or caps.inlayHintsProvider) then
					if vim.bo[bufnr].filetype ~= "cabal" then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end
			end

			local default_config_servers = {
				"basedpyright",
				"clangd",
				"html",
				"cssmodules_ls",
				"cssls",
				"jsonls",
				"bashls",
				"lua_ls",
				"lemminx",
                "jdtls",
			}

			-- setup servers that just have the default config
			for _, server in ipairs(default_config_servers) do
				vim.lsp.config(server, { on_attach = on_attach, capabilities = capabilities })
			end

			-- ruff provides formatting/linting for python; basedpyright has no formatter,
			-- so ruff is the client that <leader>f dispatches to for python buffers
			vim.lsp.config("ruff", {
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
					vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr })
				end,
				capabilities = capabilities,
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		opts = {},
	},
}
