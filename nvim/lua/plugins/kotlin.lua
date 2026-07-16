-- kotlin-language-server tweaks on top of the LazyVim kotlin extra.
--
-- Like jdtls, kls embeds a Kotlin compiler that breaks on very new JDKs
-- (JDK 26: "IllegalArgumentException: 26.0.1"). Pin its runtime to the
-- Brewfile-managed openjdk@21 when present.
local jdk21 = (vim.env.HOMEBREW_PREFIX or "/opt/homebrew") .. "/opt/openjdk@21"

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if vim.uv.fs_stat(jdk21 .. "/bin/java") then
        opts.servers = opts.servers or {}
        opts.servers.kotlin_language_server = vim.tbl_deep_extend("force",
          opts.servers.kotlin_language_server or {},
          { cmd_env = { JAVA_HOME = jdk21 } })
      end
    end,
  },
}
