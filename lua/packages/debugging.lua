---@type table<string, Adapter>
local adapters = {}
---@type table<string, Configuration[]>
local configs = {}

adapters.lldb = {
  type = "executable",
  command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
  name = "lldb",
}

configs.lldb = {
  {
    name = "Launch LLDB",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      -- Configure adapters
      dap.adapters = adapters
      -- Configure configurations
      dap.configurations.c = configs.lldb
      dap.configurations.cpp = configs.lldb
      dap.configurations.rust = configs.lldb
      -- Define signs
      define_sign("DapBreakpoint", icons.debug.breakpoint)
      define_sign("DapBreakpointCondition", icons.debug.condition)
      define_sign("DapLogPoint", icons.debug.log)
      define_sign("DapStopped", icons.debug.stopped)
      define_sign("DapBreakpointRejected", icons.debug.rejected)
      -- Define command for toggling breakpoints
      vim.api.nvim_create_user_command("Breakpoint", function(opts)
        if opts.bang then
          dap.toggle_breakpoint(nil, nil, opts.fargs[1])
        else
          dap.set_breakpoint(nil, nil, opts.fargs[1])
        end
      end, { nargs = "?", bang = true, desc = "Set or toggle a breakpoint" })
      -- Keybinds
      vim.keymap.set("n", "<localleader>gc", dap.continue)
      vim.keymap.set("n", "<localleader>go", dap.step_over)
      vim.keymap.set("n", "<localleader>gi", dap.step_into)
      vim.keymap.set("n", "<localleader>gO", dap.step_out)
      vim.keymap.set("n", "<localleader>tb", dap.toggle_breakpoint)
      vim.keymap.set("n", "<localleader>tl", function()
        dap.toggle_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end)
      vim.keymap.set("n", "<localleader>Rl", dap.run_last)
      vim.keymap.set("n", "<localleader>Rc", dap.run_to_cursor)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      vim.keymap.set({ "n", "v" }, "<localleader>K", '<cmd>lua require("dapui").eval()<cr>')

      dap.listeners.before.attach.dapui = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui = function()
        dapui.close()
      end
    end,
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
    config = true,
    build = ":TSUpdate dap_repl",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
