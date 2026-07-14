-- Inline mermaid + plantuml rendering in markdown.
-- snacks.image only supports mermaid, so we disable it and use
-- image.nvim + diagram.nvim as the single graphics stack.
-- Requires: Ghostty (kitty graphics protocol), tmux allow-passthrough,
-- and the mmdc / plantuml / magick CLIs (see Brewfile).
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = false },
    },
  },
  {
    "3rd/image.nvim",
    ft = { "markdown" },
    opts = {
      processor = "magick_cli", -- CLI processor: no luarocks/magick rock needed
      integrations = {
        markdown = {
          enabled = true,
          only_render_image_at_cursor = false,
        },
      },
    },
  },
  {
    "3rd/diagram.nvim",
    ft = { "markdown" },
    dependencies = { "3rd/image.nvim" },
    opts = function()
      return {
        integrations = {
          require("diagram.integrations.markdown"),
        },
        renderers = {
          mermaid = { theme = "dark", background = "transparent" },
          plantuml = { charset = "utf-8" },
        },
      }
    end,
  },
}
