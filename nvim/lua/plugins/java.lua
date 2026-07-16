-- jdtls tweaks on top of the LazyVim java extra.
--
-- jdtls needs Java 17+ to RUN, independently of the JDK your projects build
-- with. Pin it to the Brewfile-managed openjdk@21 so every machine launches
-- jdtls the same way regardless of what JAVA_HOME the shell inherited.
-- Falls back to the wrapper's own java discovery if openjdk@21 is missing.
local jdtls_java = (vim.env.HOMEBREW_PREFIX or "/opt/homebrew") .. "/opt/openjdk@21/bin/java"

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      if vim.uv.fs_stat(jdtls_java) then
        table.insert(opts.cmd, 2, "--java-executable=" .. jdtls_java)
      end
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          -- Fetch source jars so gd into library classes (Flink, Kafka, ...)
          -- shows real code + javadoc instead of a decompiled skeleton.
          maven = { downloadSources = true },
          eclipse = { downloadSources = true },
        },
      })
    end,
  },
}
