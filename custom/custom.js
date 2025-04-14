require(["base/js/namespace", "base/js/events"], function(Jupyter, events) {
    events.on("kernel_ready.Kernel", function() {
        Jupyter.notebook.execute_cells([0, 1, 2, 3, 4, 5]);
    });
});