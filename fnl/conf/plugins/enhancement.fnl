(import-macros {: pack} :themis.pack.lazy)

[;; Keybind discoverability
 (pack "folke/which-key.nvim" {:config true})
 ;; Create directories when necessary
 "jghauser/mkdir.nvim"
 ;; Sorting
 (pack "sQVe/sort.nvim" {:config true})
 ;; Sync spell files
 "micarmst/vim-spellsync"
 ;; Support OSC52 on yank to system clipboard
 (pack "ojroques/nvim-osc52" {:config #(do (import-macros {: augroup!
                                                           : clear!
                                                           : autocmd!} :themis.event)
                                         (local osc52 (require :osc52))
                                         (osc52.setup {:silent true})
                                         (augroup! osc52-system-clipboard
                                           (clear!)
                                           (autocmd! TextYankPost *
                                                     #(case vim.v.event.regname
                                                        "+" (osc52.copy_register "+")
                                                        "*" (osc52.copy_register "*")))))})
 ;; Undofile
 (pack "kevinhwang91/nvim-fundo" {:build #(let [fundo (require :fundo)] (fundo.install))
                                  :config true})
 ;; Remove bad habits
 (pack "m4xshen/hardtime.nvim" {:dependencies ["MunifTanjim/nui.nvim"
                                               "nvim-lua/plenary.nvim"]
                                :config true})]
