$(function () {
    // Bind the resize event. When any test element's size changes, update its
    // corresponding info div.
    $('.test').resize(function () {
        var elem = $(this);

        // Update the info div width and height - replace this with your own code
        // to do something useful!
        elem.closest('.container').find('.info')
      .text(this.tagName + ' width: ' + elem.width() + ', height: ' + elem.height());
    });

    // Update all info divs immediately.
    $('.test').resize();

    // Add text after inline "add text" links.
    $('.add_text').click(function (e) {
        e.preventDefault();
        $(this).parent().append(' Adding some more text, to grow the parent container!');
    });

    // Resize manually when the link is clicked, but only for the first paragraph.
    $('.add_text:first').click(function () {
        $(this).parent().resize();
    });
});