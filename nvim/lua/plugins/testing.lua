-- Kotlin test support for neotest (JUnit / kotest / kotlin.test on Gradle & Maven).
-- Java tests don't go through neotest: the LazyVim java extra runs them via jdtls
-- (java-test + java-debug-adapter Mason bundles, pulled in by the dap.core extra)
-- and binds the same <leader>t keys in java buffers.
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "codymikol/neotest-kotlin" },
    opts = {
      adapters = {
        ["neotest-kotlin"] = {},
      },
    },
  },
}
