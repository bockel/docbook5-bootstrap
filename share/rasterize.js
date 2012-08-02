var page = new WebPage(),
    address, output, size;

if (phantom.args.length < 3) {
    console.log('Usage: rasterize.js URL fileheader outname');
    phantom.exit();
} else {
    var address = phantom.args[0];
    var outname = phantom.args[1];

    page.viewportSize = { width: 1024, height: 768 };

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

