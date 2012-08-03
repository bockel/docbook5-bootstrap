/* ShowOff JS Logic */

var ShowOff = {};

var preso_started = false
var slidenum = 0
var slideTotal = 0
var slides
var currentSlide
var totalslides = 0
var slidesLoaded = false
var incrSteps = 0
var incrElem
var incrCurr = 0
var incrCode = false
var debugMode = false
var gotoSlidenum = 0
var shiftKeyActive = false

var loadSlidesBool
var loadSlidesPrefix

function setupPreso(load_slides, prefix) {
    if (preso_started)
    {
        alert("already started")
        return
    }
    preso_started = true


        // Load slides fetches images
    loadSlidesBool = load_slides
    loadSlidesPrefix = prefix
    loadSlides(loadSlidesBool, loadSlidesPrefix)

    doDebugStuff()

    // bind event handlers
    document.onkeydown = keyDown
    document.onkeyup = keyUp
    /* window.onresize  = resized; */
    /* window.onscroll = scrolled; */
    /* window.onunload = unloaded; */

    $('body').addSwipeEvents().
        bind('tap', swipeLeft).         // next
        bind('swipeleft', swipeLeft).   // next
        bind('swiperight', swipeRight); // prev
}

function loadSlides(load_slides, prefix) {
    //load slides offscreen, wait for images and then initialize
    if (load_slides) {
        $("#slides").load(loadSlidesPrefix + "slides", false, function(){
            $("#slides img").batchImageLoad({
            loadingCompleteCallback: initializePresentation(prefix)
        })
        })
    } else {
    $("#slides img").batchImageLoad({
        loadingCompleteCallback: initializePresentation(prefix)
    })
    }
}

function initializePresentation(prefix) {
    // unhide for height to work in static mode
        $("#slides").show();

    //center slides offscreen
    //only center title slides
    centerSlides($('#slides > .titleslide'))

    //copy into presentation area
    $("#preso").empty()
    $('#slides > .slide').appendTo($("#preso"))

    //populate vars
    slides = $('#preso > .slide')
    slideTotal = slides.size()

    //setup manual jquery cycle
    $('#preso').cycle({
        timeout: 0
    })

    setupMenu()
    if (slidesLoaded) {
        showSlide()
    } else {
        showFirstSlide();
        slidesLoaded = true
    }
    setupSlideParamsCheck();
    $("#preso").trigger("showoff:loaded");
}

function centerSlides(slides) {
    slides.each(function(s, slide) {
        centerSlide(slide)
    })
}

function centerSlide(slide) {
    var slide_content = $(slide).find(".content").first()
    var height = slide_content.height()
    var mar_top = (0.5 * parseFloat($(slide).height())) - (0.5 * parseFloat(height))
    if (mar_top < 0) {
        mar_top = 0
    }
    slide_content.css('margin-top', mar_top)
}

function setupMenu() {
    $('#navmenu').hide();

    var currSlide = 0
    var menu = new ListMenu()

    slides.each(function(s, elem) {
        content = $(elem).find(".content")
        shortTxt = $(content).find(".title").text().substr(0, 20)
        path = $(content).attr('ref').split('/')
        currSlide += 1
        menu.addItem(path, shortTxt, currSlide)
    })

    $('#navigation').html(menu.getList())
    $('#navmenu').menu({
        content: $('#navigation').html(),
        flyOut: true
    });
}

function checkSlideParameter() {
    if (slideParam = currentSlideFromParams()) {
        slidenum = slideParam;
    }
}

function currentSlideFromParams() {
    var result;
    if (result = window.location.hash.match(/#([0-9]+)/)) {
        return result[result.length - 1] - 1;
    }
}

function setupSlideParamsCheck() {
    var check = function() {
        var currentSlide = currentSlideFromParams();
        if (slidenum != currentSlide) {
            slidenum = currentSlide;
            showSlide();
        }
        setTimeout(check, 100);
    }
    setTimeout(check, 100);
}

function gotoSlide(slideNum) {
    slidenum = parseInt(slideNum)
    if (!isNaN(slidenum)) {
        showSlide()
    }
}

function showFirstSlide() {
    slidenum = 0
    checkSlideParameter();
    showSlide()
}

function showSlide(back_step) {

    if(slidenum < 0) {
        slidenum = 0
        return
    }

    if(slidenum > (slideTotal - 1)) {
        slidenum = slideTotal - 1
        return
    }

    currentSlide = slides.eq(slidenum)

    var transition = currentSlide.attr('data-transition')
    var fullPage = currentSlide.find(".content").is('.full-page');

    if (back_step || fullPage) {
        transition = 'none'
    }
    //transition = 'none'

    $('#preso').cycle(slidenum, transition)

    if (fullPage) {
        $('#preso').css({'width' : '100%', 'overflow' : 'visible'});
        currentSlide.css({'width' : '100%', 'text-align' : 'center', 'overflow' : 'visible'});
    } else {
        $('#preso').css({'width' : '', 'overflow' : ''});
    }

    percent = getSlidePercent()
    $("#slideInfo").text((slidenum + 1) + '/' + slideTotal + '  - ' + percent + '%')

    if(!back_step) {
        // determine if there are incremental bullets to show
        // unless we are moving backward
        determineIncremental()
    } else {
        incrCurr = 0
        incrSteps = 0
    }
    location.hash = slidenum + 1;

    removeResults();

  var currentContent = $(currentSlide).find(".content")
    currentContent.trigger("showoff:show");

    var ret = getCurrentNotes();

  // Update presenter view, if we spawned one
    if ('presenterView' in window) {
    var pv = window.presenterView;
        pv.slidenum = slidenum;
    pv.incrCurr = incrCurr
    pv.incrSteps = incrSteps
        pv.showSlide(true);
        pv.postSlide();
    }

    return ret;
}

function getSlideProgress()
{
    return (slidenum + 1) + '/' + slideTotal
}

function getCurrentNotes()
{
  var notes = currentSlide.find("p.notes").text()
  $('#notesInfo').text(notes)
    return notes
}

function getSlidePercent()
{
    return Math.ceil(((slidenum + 1) / slideTotal) * 100)
}

function determineIncremental()
{
    incrCurr = 0
    incrCode = false
    incrElem = currentSlide.find(".incremental > ul > li")
    incrSteps = incrElem.size()
    if(incrSteps == 0) {
        // also look for commandline
        incrElem = currentSlide.find(".incremental > pre > code > code")
        incrSteps = incrElem.size()
        incrCode = true
    }
    incrElem.each(function(s, elem) {
        $(elem).css('visibility', 'hidden');
    })
}

function showIncremental(incr)
{
        elem = incrElem.eq(incrCurr)
        if (incrCode && elem.hasClass('command')) {
            incrElem.eq(incrCurr).css('visibility', 'visible').jTypeWriter({duration:1.0})
        } else {
            incrElem.eq(incrCurr).css('visibility', 'visible')
        }
}

function prevStep()
{

    var event = jQuery.Event("showoff:prev");
    $(currentSlide).find(".content").trigger(event);
    if (event.isDefaultPrevented()) {
            return;
    }

    slidenum--
    return showSlide(true) // We show the slide fully loaded
}

function nextStep()
{
    var event = jQuery.Event("showoff:next");
    $(currentSlide).find(".content").trigger(event);
    if (event.isDefaultPrevented()) {
            return;
    }

    if (incrCurr >= incrSteps) {
        slidenum++
        return showSlide()
    } else {
        showIncremental(incrCurr);
        var incrEvent = jQuery.Event("showoff:incr");
        incrEvent.slidenum = slidenum;
        incrEvent.incr = incrCurr;
        $(currentSlide).find(".content").trigger(incrEvent);
        incrCurr++;
    }
}

function doDebugStuff()
{
    if (debugMode) {
        $('#debugInfo').show()
        debug('debug mode on')
    } else {
        $('#debugInfo').hide()
    }
}

var notesMode = false
function toggleNotes()
{
  notesMode = !notesMode
    if (notesMode) {
        $('#notesInfo').show()
        debug('notes mode on')
    } else {
        $('#notesInfo').hide()
    }
}

function debug(data)
{
    $('#debugInfo').text(data)
}

//  See e.g. http://www.quirksmode.org/js/keys.html for keycodes
function keyDown(event)
{
    var key = event.keyCode;

    if (event.ctrlKey || event.altKey || event.metaKey)
        return true;

    debug('keyDown: ' + key)

    if (key >= 48 && key <= 57) // 0 - 9
    {
        gotoSlidenum = gotoSlidenum * 10 + (key - 48);
        return true;
    }

    if (key == 13) {
        if (gotoSlidenum > 0) {
            debug('go to ' + gotoSlidenum);
            slidenum = gotoSlidenum - 1;
            showSlide(true);
            gotoSlidenum = 0;
        }
    }


    //if (key == 16) // shift key
    //{
        //shiftKeyActive = true;
    //}
    if (key == 32) // space bar
    {
        if (shiftKeyActive) {
            prevStep()
        } else {
            nextStep()
        }
    }
    //else if (key == 68) // 'd' for debug
    //{
        //debugMode = !debugMode
        //doDebugStuff()
    //}
    else if (key == 37 || key == 33 || key == 38) // Left arrow, page up, or up arrow
    {
        prevStep()
    }
    else if (key == 39 || key == 34 || key == 40) // Right arrow, page down, or down arrow
    {
        nextStep()
    }
    else if (key == 82) // R for reload
    {
        if (confirm('Really reload slides?')) {
            window.location.reload(true);
            //loadSlides(loadSlidesBool, loadSlidesPrefix)
            //showSlide()
        }
    }
    else if (key == 84 || key == 67)  // T or C for table of contents
    {
        $('#navmenu').toggle().trigger('click')
    }
    else if (key == 90 || key == 191) // z or ? for help
    {
        $('#help').toggle()
    }
    else if (key == 66 || key == 70) // f for footer (also "b" which is what kensington remote "stop" button sends
    {
        toggleFooter()
    }
    else if (key == 78) // 'n' for notes
    {
        toggleNotes()
    }
    else if (key == 27) // esc
    {
        removeResults();
    }
    else if (key == 80) // 'p' for print layout, 'P' for pause
    {
    if (shiftKeyActive) {
      togglePause();
    }
    else {
      togglePrint();
    }
    }
    return true
}

var printMode = false
function togglePrint()
{
    printMode = !printMode;
    if(printMode) {
        $('.slide').css({
        display: 'block',
        opacity: 1,
        position: 'relative'
        });
        $('body').css('overflow', 'auto');
        $('#preso').css('overflow', 'visible');
        $('.slide').after('<div class="page-break"></div>');

        centerSlides($('.slide.vertically-centered'));

        alert("Now you can print using the browser's normal print option\nDon't forget to check the print backgrounds option, and preferrably use landscape mode.");
    } else {
        window.location.reload(true);
    }
}

function toggleFooter()
{
    $('#footer').toggle()
}

function keyUp(event) {
    var key = event.keyCode;
    debug('keyUp: ' + key);
    if (key == 16) // shift key
    {
        shiftKeyActive = false;
    }
}

function swipeLeft() {
  nextStep();
}

function swipeRight() {
  prevStep();
}

function ListMenu(s)
{
    this.slide = s
    this.typeName = 'ListMenu'
    this.itemLength = 0;
    this.items = new Array();
    this.addItem = function (key, text, slide) {
        if (key.length > 1) {
            thisKey = key.shift()
            if (!this.items[thisKey]) {
                this.items[thisKey] = new ListMenu(slide)
            }
            this.items[thisKey].addItem(key, text, slide)
        } else {
            thisKey = key.shift()
            this.items[thisKey] = new ListMenuItem(text, slide)
        }
    }
    this.getList = function() {
        var newMenu = $("<ul>")
        for(var i in this.items) {
            var item = this.items[i]
            var domItem = $("<li>")
            if (item.typeName == 'ListMenu') {
                choice = $("<a rel=\"" + (item.slide - 1) + "\" href=\"#\">" + i + "</a>")
                domItem.append(choice)
                domItem.append(item.getList())
            }
            if (item.typeName == 'ListMenuItem') {
                choice = $("<a rel=\"" + (item.slide - 1) + "\" href=\"#\">" + item.slide + '. ' + item.textName + "</a>")
                domItem.append(choice)
            }
            newMenu.append(domItem)
        }
        return newMenu
    }
}

function ListMenuItem(t, s)
{
    this.typeName = "ListMenuItem"
    this.slide = s
    this.textName = t
}

var removeResults = function() {
    $('.results').remove();
};

var print = function(text) {
    removeResults();
    var _results = $('<div>').addClass('results').html($.print(text, {max_string:500}));
    $('body').append(_results);
    _results.click(removeResults);
};

function togglePause() {
  $("#pauseScreen").toggle();
}
