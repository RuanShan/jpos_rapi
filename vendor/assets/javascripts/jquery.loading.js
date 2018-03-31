/**
 * 2012, ParkMe Inc. - Keith Hackbarth
 *
 **/

(function( $ ) {
    $.fn.loading = function () {

        // create loading element
        var loadingElement = document.createElement('div');
        loadingElement.id = 'loading';
        loadingElement.className = 'loading';
        loadingElement.innerHTML = 'Loading...';

        // apply styles
        loadingElement.style.position = 'fixed';
        loadingElement.style.background = 'gray';
        loadingElement.style.opacity = 0.3;
        loadingElement.style.width = '100%';
        loadingElement.style.textAlign = 'center';
        loadingElement.style.zIndex = '10000';
        loadingElement.style.padding = '4px';
        loadingElement.style.border = 'grey solid 1px';
        loadingElement.style.display = 'none';

        // attach it to DOM
        $(this).append(loadingElement);

        // position element
        $("#loading").position({
            my: "center top",
            at: "center top",
            of: window
        });

        // every time ajax is called
        $(document).ajaxSend(function () {
            $(loadingElement).show();
        })

        // every time ajax is completed
        $(document).ajaxComplete(function () {
            self.setTimeout(function (){
                $(loadingElement).hide();
            }, 100);
        });
    };

})(jQuery);

$(document).ready(function () {
    $('body').loading();
});
