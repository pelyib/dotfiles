return {
    "rcarriga/nvim-dap-ui",
    tag = "v3.9.1",
    requires = {
        "mfussenegger/nvim-dap"
    },
    config = function ()
        require("dapui").setup()
    end
}
