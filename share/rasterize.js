var page = new WebPage(),
    address, output, size;

if (phantom.args.length < 2) {
    console.log('Usage: rasterize.js input.html output');
    phantom.exit();
} else {
    var address = phantom.args[0];
    var outname = phantom.args[1];

    // assume 90 dpi
    page.viewportSize = { width: 90*8.5, height: 90*11 };
    page.paperSize = { format:'letter',orientation:'portrait',border:'1in' };

    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
        } else {
            window.setTimeout(function () {
                page.render(outname);
                phantom.exit();
            }, 2000);
        }
    });
}

