return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  -- event = { "VeryLazy" },
  -- lazy = "true",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      event = "BufRead",
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        aerial = {
          -- Display symbols as <root>.<parent>.<symbol>
          show_nesting = {
            ["_"] = false, -- This key will be the default
            json = true,   -- You can set the option for specific filetypes
            yaml = true,
          },
        },
      },
      defaults = {
        path_display = { "smart" },
        sort_mru = true,
        sorting_strategy = 'ascending',
        layout_config = { prompt_position = 'top' },
        borderchars = {
          prompt = { '▔', '▕', ' ', '▏', '🭽', '🭾', '▕', '▏' },
          -- results = U.get_border_chars 'telescope',
          -- preview = U.get_border_chars 'telescope',
        },
        border = true,
        multi_icon = '',
        entry_prefix = '   ',
        prompt_prefix = '   ',
        selection_caret = '  ',
        hl_result_eol = true,
        results_title = '',
        winblend = 0,
        wrap_results = false,
        mappings = {
          i = {
            ["<A-k>"] = actions.move_selection_previous, -- move to prev result
            ["<A-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<A-o>", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<A-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in current buffer" })
    keymap.set("n", "<A-S-f>", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<A-S-o>", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
  end,
}
