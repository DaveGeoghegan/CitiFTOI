// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require_tree .


if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function(suffix) {
        return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
}
/*global $, window*/
console.log("Loaded it ")
$.fn.editableTableWidget = function (options) {
    'use strict';
    return $(this).each(function () {
        var buildDefaultOptions = function () {
                var opts = $.extend({}, $.fn.editableTableWidget.defaultOptions);
                opts.editor = opts.editor.clone();
                return opts;
            },
            activeOptions = $.extend(buildDefaultOptions(), options),
            ARROW_LEFT = 37, ARROW_UP = 38, ARROW_RIGHT = 39, ARROW_DOWN = 40, ENTER = 13, ESC = 27, TAB = 9,
            element = $(this),
            editor = activeOptions.editor.css('position', 'absolute').hide().appendTo(element.parent()),
            active,
            showEditor = function (select) {
                console.log("In show Editor ");
                console.log(select)
                active = element.find('.editable:focus');
                if (active.length) {
                    console.log("OK We're changing one!")
                    editor.val(active.text())
                        .removeClass('error')
                        .show()
                        .offset(active.offset())
                        .css(active.css(activeOptions.cloneProperties))
                        .width(active.width())
                        .height(active.height())
                        .focus();
                    if (select) {
                        editor.select();
                    }
                }
            },
            setActiveText = function () {
                console.log("Set Active Text");
                window.is_dirty = true;
                recalculate_form();
                var text = editor.val(),
                    evt = $.Event('change'),
                    originalContent;
                text = text.trim();
                originalContent = active.html();
                if (active.hasClass("restrict-change")) {
                    console.log("Old " + active.text());
                    console.log("New " + editor.val());
                    console.log(active);
                    var old_value = parseFloat(active.attr('previous_round_value'));
                    var new_value = parseFloat(editor.val());
                    console.log("NewVal " + new_value + " Old " + old_value)
                    var percent_diff = Math.abs(old_value - new_value );

                    console.log("Percent Diff is " + percent_diff)
                    if (percent_diff > 3.0) {
                        $.toaster({ priority : 'danger', title : 'Input Error', message : 'Capital allocations for each business unit cannot be increased or decreased by more than 3% from the previous round. Please edit your decision.'});
                        active.html = originalContent;
                        return true;
                    }
                }

                text = remove_whitespace_and_percent(text)
                if (!is_valid_entry(text)) {
                    active.html = originalContent;
                    $.toaster({ priority : 'danger', title : 'Input Error', message : 'This Field Must be a Number'});
                    return true;
                }
                text = make_sure_has_ending_percent(text)
                console.log("Text is " + text);
                if (active.text() === text || editor.hasClass('error')) {
                    console.log("No Change Needed");
                    return true;
                }
                console.log("Original Content " + originalContent)
                active.text(text).trigger(evt, text);
                if (evt.result === false) {
                    console.log("Setting..");
                    active.html(originalContent);
                }
            },
            movement = function (element, keycode) {
                if (keycode === ARROW_RIGHT) {
                    return element.next('td');
                } else if (keycode === ARROW_LEFT) {
                    return element.prev('td');
                } else if (keycode === ARROW_UP) {
                    return element.parent().prev().children().eq(element.index());
                } else if (keycode === ARROW_DOWN) {
                    return element.parent().next().children().eq(element.index());
                }
                return [];
            };
        editor.blur(function () {
            console.log("Blur")
            setActiveText();
            editor.hide();
            recalculate_form();
        }).keydown(function (e) {
            if (e.which === ENTER) {
                console.log("Hit Enter");
                var el = $(active).get(0);
                console.log(active.hasClass("restrict-change"));
                var text = remove_whitespace_and_percent(editor.val())
                if (is_valid_entry(text)) {
                    var out_of_range = false;
                    if (active.hasClass("restrict-change")) {
                        console.log("Old " + active.text());
                        console.log("New " + editor.val());
                        var old_value = parseFloat(active.text());
                        var new_value = parseFloat(text);
                        console.log("NewVal " + new_value + " Old " + old_value)
                        var percent_diff = Math.abs(old_value - new_value);

                        console.log("Percent Diff is " + percent_diff)
                        if (percent_diff > 3.0) {
                            out_of_range = true;
                        }
                    }
                    if (!out_of_range) {
                        setActiveText();
                        editor.hide();
                        active.focus();
                    }
                    else {
                        $.toaster({ priority : 'danger', title : 'Input Error', message : 'Capital allocations for each business unit cannot be increased or decreased by more than 3% from the previous round. Please edit your decision.'});
                        editor.val(active.text().trim());
                    }

                }
                else {
                    $.toaster({ priority : 'danger', title : 'Input Error', message : 'This Field Must be a Number'});
                }
                e.preventDefault();
                e.stopPropagation();
            } else if (e.which === ESC) {
                editor.val(active.text());
                e.preventDefault();
                e.stopPropagation();
                editor.hide();
                active.focus();
            } else if (e.which === TAB) {
                console.log(active.text());
                console.log(editor.text());
                active.focus();
            } else if (this.selectionEnd - this.selectionStart === this.value.length) {
                var possibleMove = movement(active, e.which);
                if (possibleMove.length > 0) {
                    possibleMove.focus();
                    e.preventDefault();
                    e.stopPropagation();
                }
            }
        })
            .on('input paste', function () {
                var evt = $.Event('validate');
                active.trigger(evt, editor.val());
                if (evt.result === false) {
                    editor.addClass('error');
                } else {
                    editor.removeClass('error');
                }
            });
        element.on('click keypress dblclick', showEditor)
            .css('cursor', 'pointer')
            .keydown(function (e) {
                var prevent = true,
                    possibleMove = movement($(e.target), e.which);
                if (possibleMove.length > 0) {
                    possibleMove.focus();
                } else if (e.which === ENTER) {
                    console.log("enter is hit");
                    showEditor(false);
                } else if (e.which === 17 || e.which === 91 || e.which === 93) {
                    showEditor(true);
                    prevent = false;
                } else {
                    prevent = false;
                }
                if (prevent) {
                    e.stopPropagation();
                    e.preventDefault();
                }
            });

        element.find('.editable').prop('tabindex', 1);

        $(window).on('resize', function () {
            if (editor.is(':visible')) {
                editor.offset(active.offset())
                    .width(active.width())
                    .height(active.height());
            }
        });
    });

};
$.fn.editableTableWidget.defaultOptions = {
    cloneProperties: ['padding', 'padding-top', 'padding-bottom', 'padding-left', 'padding-right',
        'text-align', 'font', 'font-size', 'font-family', 'font-weight',
        'border', 'border-top', 'border-bottom', 'border-left', 'border-right'],
    editor: $('<input>')
};

function recalculate_form() {
    $.each($('.additive-result'), function(idx,val) {
     //       console.log("Found One");
     //       console.log(val);
            fields_to_add = val.getAttribute('data-add-fields');
    //        console.log("Fields to Add are");
    //        console.log(fields_to_add);
            total = 0;
            $.each(fields_to_add.split(","), function(i,v){
      //          console.log("OK Adding")
      //          console.log(v);
                theEl = $('#'+v)[0];
        //        console.log(theEl);
                theVal = parseFloat(theEl.innerText);
  //              console.log("The Val is ");
    //            console.log(theVal);
                total = total + theVal;
            });
            theOutputString = total + "%"
            val.innerText = theOutputString;
        }

    )
}
function make_sure_has_ending_percent(str) {
    str = str.replace(/%/g, "").trim();
    str  = str + "%";
    return str;
}

function remove_whitespace_and_percent(str) {
    console.log("Remove Whitespace " + str);
    str = str.replace(/[^0-9.]/g, "").trim();
    console.log("Out is " + str);
    return str
}


function is_valid_entry(txt) {
    txt = remove_whitespace_and_percent(txt);
    console.log("Looking for a number");
    console.log(txt);
    theVal = parseFloat(txt);
    if (isNaN(theVal)) {
        console.log("NAN");
        return false;
    }
    if (theVal < 0 || theVal > 100) {
        console.log("Range Exceed");
        return false;
    }
    return true;
}


// $('.input-screen-table').editableTableWidget();



/***********************************************************************************
 * Add Array.indexOf                                                                *
 ***********************************************************************************/
(function ()
{
    if (typeof Array.prototype.indexOf !== 'function')
    {
        Array.prototype.indexOf = function(searchElement, fromIndex)
        {
            for (var i = (fromIndex || 0), j = this.length; i < j; i += 1)
            {
                if ((searchElement === undefined) || (searchElement === null))
                {
                    if (this[i] === searchElement)
                    {
                        return i;
                    }
                }
                else if (this[i] === searchElement)
                {
                    return i;
                }
            }
            return -1;
        };
    }
})();
/**********************************************************************************/

(function ($,undefined)
{
    var toasting =
    {
        gettoaster : function ()
        {
            var toaster = $('#' + settings.toaster.id);

            if(toaster.length < 1)
            {
                toaster = $(settings.toaster.template).attr('id', settings.toaster.id).css(settings.toaster.css).addClass(settings.toaster['class']);

                if ((settings.stylesheet) && (!$("link[href=" + settings.stylesheet + "]").length))
                {
                    $('head').appendTo('<link rel="stylesheet" href="' + settings.stylesheet + '">');
                }

                $(settings.toaster.container).append(toaster);
            }

            return toaster;
        },

        notify : function (title, message, priority)
        {
            var $toaster = this.gettoaster();
            var $toast  = $(settings.toast.template.replace('%priority%', priority)).hide().css(settings.toast.css).addClass(settings.toast['class']);

            $('.title', $toast).css(settings.toast.csst).html(title);
            $('.message', $toast).css(settings.toast.cssm).html(message);

            if ((settings.debug) && (window.console))
            {
                console.log(toast);
            }

            $toaster.append(settings.toast.display($toast));

            if (settings.donotdismiss.indexOf(priority) === -1)
            {
                var timeout = (typeof settings.timeout === 'number') ? settings.timeout : ((typeof settings.timeout === 'object') && (priority in settings.timeout)) ? settings.timeout[priority] : 3500;
                setTimeout(function()
                {
                    settings.toast.remove($toast, function()
                    {
                        $toast.remove();
                    });
                }, timeout);
            }
        }
    };

    var defaults =
    {
        'toaster'         :
        {
            'id'        : 'toaster',
            'container' : 'body',
            'template'  : '<div></div>',
            'class'     : 'toaster',
            'css'       :
            {
                'position' : 'fixed',
                'top'      : '10px',
                'right'    : '10px',
                'width'    : '300px',
                'zIndex'   : 50000
            }
        },

        'toast'       :
        {
            'template' :
            '<div class="alert alert-%priority% alert-dismissible" role="alert">' +
            '<button type="button" class="close" data-dismiss="alert">' +
            '<span aria-hidden="true">&times;</span>' +
            '<span class="sr-only">Close</span>' +
            '</button>' +
            '<span class="title"></span>: <span class="message"></span>' +
            '</div>',

            'defaults' :
            {
                'title'    : 'Notice',
                'priority' : 'success'
            },

            'css'      : {},
            'cssm'     : {},
            'csst'     : { 'fontWeight' : 'bold' },

            'fade'     : 'slow',

            'display'    : function ($toast)
            {
                return $toast.fadeIn(settings.toast.fade);
            },

            'remove'     : function ($toast, callback)
            {
                return $toast.animate(
                    {
                        opacity : '0',
                        padding : '0px',
                        margin  : '0px',
                        height  : '0px'
                    },
                    {
                        duration : settings.toast.fade,
                        complete : callback
                    }
                );
            }
        },

        'debug'        : false,
        'timeout'      : 3500,
        'stylesheet'   : null,
        'donotdismiss' : []
    };

    var settings = {};
    $.extend(settings, defaults);

    $.toaster = function (options)
    {
        if (typeof options === 'object')
        {
            if ('settings' in options)
            {
                settings = $.extend(true, settings, options.settings);
            }
        }
        else
        {
            var values = Array.prototype.slice.call(arguments, 0);
            var labels = ['message', 'title', 'priority'];
            options = {};

            for (var i = 0, l = values.length; i < l; i += 1)
            {
                options[labels[i]] = values[i];
            }
        }

        var title    = (('title' in options) && (typeof options.title === 'string')) ? options.title : settings.toast.defaults.title;
        var message  = ('message' in options) ? options.message : null;
        var priority = (('priority' in options) && (typeof options.priority === 'string')) ? options.priority : settings.toast.defaults.priority;

        if (message !== null)
        {
            toasting.notify(title, message, priority);
        }
    };

    $.toaster.reset = function ()
    {
        settings = {};
        $.extend(settings, defaults);
    };
})(jQuery);
