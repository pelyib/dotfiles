return {
    "rcarriga/nvim-dap-ui",
    enabled = true,
    tag = "v3.9.1",
    requires = {
        "mfussenegger/nvim-dap"
    },
    config = function ()
        require("dapui").setup()
    end
}
