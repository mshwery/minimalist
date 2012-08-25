(function($) {
  $.fn.dbltap = function(doubleTapCallback) {
    return this.each(function(){
      var elm = this;
      var lastTap = 0;
      $(elm).bind('mousedown', function (e) {
        var now = (new Date()).valueOf();
        var diff = (now - lastTap);
        lastTap = now ;
        if (diff < 250) {
          if($.isFunction( doubleTapCallback )){
            doubleTapCallback.call(elm);
          }
        }      
      });
    });
  }
})(jQuery);

//based on blog post that I saw here: http://www.sanraul.com/2010/08/01/implementing-doubletap-on-iphones-and-ipads/
(function($){
    $.fn.doubletap = function(fn) {
        return fn ? this.bind('doubletap', fn) : this.trigger('doubletap');
    };

    $.attrFn.doubletap = true;

    $.event.special.doubletap = {
        setup: function(data, namespaces){
            $(this).bind('touchend', $.event.special.doubletap.handler);
        },

        teardown: function(namespaces){
            $(this).unbind('touchend', $.event.special.doubletap.handler);
        },

        handler: function(event){
            var action;

            clearTimeout(action);

            var now       = new Date().getTime();
            //the first time this will make delta a negative number
            var lastTouch = $(this).data('lastTouch') || now + 1;
            var delta     = now - lastTouch;
            var delay     = delay == null? 500 : delay;

            if(delta < delay && delta > 0){
                // After we detct a doubletap, start over
                $(this).data('lastTouch', null);

                // set event type to 'doubletap'
                event.type = 'doubletap';

                // let jQuery handle the triggering of "doubletap" event handlers
                $.event.handle.apply(this, arguments);
            }else{
                $(this).data('lastTouch', now);

                action = setTimeout(function(evt){
                    // set event type to 'doubletap'
                    event.type = 'tap';

                    // let jQuery handle the triggering of "doubletap" event handlers
                    $.event.handle.apply(this, arguments);

                    clearTimeout(action); // clear the timeout
                }, delay, [event]);
            }
        }
    };
})(jQuery);
