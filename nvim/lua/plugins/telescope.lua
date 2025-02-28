return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "cljoly/telescope-repo.nvim",
  },
  init = function()
    local telescope = require("telescope")
    telescope.load_extension("fzf")
    telescope.load_extension("repo")
  end,
  keys = {
    {
      "<leader>ff",
      "<cmd>Telescope find_files<CR>",
      mode = { "n" },
      desc = "Fuzzy find files in cwd",
    },
    {
      "<leader>fg",
      "<cmd>Telescope git_files<CR>",
      mode = { "n" },
      desc = "Fuzzy find git files in cwd",
    },
    {
      "<leader>fr",
      "<cmd>Telescope oldfiles<CR>",
      mode = { "n" },
      desc = "Fuzzy find recent files",
    },
    {
      "<leader>fs",
      "<cmd>Telescope live_grep<CR>",
      mode = { "n" },
      desc = "Find string in cwd",
    },
    {
      "<leader>fc",
      "<cmd>Telescope grep_string<CR>",
      mode = { "n" },
      desc = "Find string under cursor in cwd",
    },
    {
      "<leader>gh",
      "<cmd>Neogit<CR>",
      mode = { "n" },
      desc = "Open Neogit",
    },
    {
      "<leader>gp",
      "<cmd>Telescope repo list<CR>",
      mode = { "n" },
      desc = "Find git repositories",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-k>"] = "move_selection_previous",
          ["<C-j>"] = "move_selection_next",
        },
      },
      preview = {
        treesitter = {
          disable = { "gitcommit" },
        },
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = { "png", "jpg" } -- Supported image formats
            local split_path = vim.split(filepath:lower(), ".", { plain = true })
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _)
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d .. "\r\n")
              end
            end
            vim.fn.jobstart({
              "chafa",
              filepath, -- Terminal image viewer command
            }, { on_stdout = send_output, stdout_buffered = true, pty = true })
          else
            require("telescope.previewers.utils").set_preview_message(
              bufnr,
              opts.winid,
              "Binary cannot be previewed"
            )
          end
        end,
      },
    },
    extensions = {
      fzf = {},
      repo = {
        list = {
          search_dirs = {
            "~/git",
          },
        },
        cached_list = {
          file_ignore_patterns = { "/%.local/", "/%.cache/" },
        },
      },
    },
  },
}
