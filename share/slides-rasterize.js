var page = new WebPage(),
    address, output, size;

function renderNextSlide(head, slidenum, total) {
    var nstr = slidenum+'';
    var tstr = total+'';
    while(nstr.length < tstr.length)
        nstr = '0'+nstr
    window.setTimeout(function () {
        if(slidenum >= total) phantom.exit();
        console.log("Generating Slide "+slidenum+": "+head+nstr+"."+ext);
        page.render(head+nstr+"."+ext);
        page.release
        page.evaluate(function() { nextStep(); });
        renderNextSlide(head,slidenum+1, total);
    }, 1000);
}

if (phantom.args.length < 3) {
    console.log('Usage: slides-rasterize.js slides.html fileheader imgtype [slidenum]');
    phantom.exit();
} else {
    var address = phantom.args[0];
    var head = phantom.args[1];
    var ext = phantom.args[2];
    var snum = -1;
    if (phantom.args.length == 4) {
        snum = parseInt(phantom.args[3]);
    }

    if(ext=='pdf') {
        page.viewportSize = { width: 90*11, height: 90*8.5 };
        //page.vieportSize = { width: '11in', height: '8.5in'}
        //page.paperSize = { width: '792pt', height: '612pt',orientation:'landscape',border:'72pt'}
        page.paperSize = {format:'letter',orientation:'landscape',border:'0'}
    } else {
        page.viewportSize = { width: 1024, height: 768 };
    }

    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
        } else {
            page.evaluate(function() { setupPreso(false,'./') });
            window.setTimeout(function () {
                if(snum > 0) {
                    page.evaluate(function(snum) { gotoSlide(snum-1); });
                    window.setTimeout(function() {
                        //page.evaluate(function(snum) { gotoSlide(snum); });
                        renderNextSlide(head,snum,snum+1);
                    }, 1000);
                } else {
                    page.evaluate(function() { gotoSlide(0); });
                    var slideTotal = page.evaluate(function() { return slideTotal; });
                    renderNextSlide(head,1,slideTotal);
                }
            }, 2000);
        }
    });
}

