-- jdtls tweaks on top of the LazyVim java extra.
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          -- Fetch source jars so gd into library classes (Flink, Kafka, ...)
          -- shows real code + javadoc instead of a decompiled skeleton.
          maven = { downloadSources = true },
          eclipse = { downloadSources = true },
        },
      },
    },
  },
}
