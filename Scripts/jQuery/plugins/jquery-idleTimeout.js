//######
//## This work is licensed under the Creative Commons Attribution-Share Alike 3.0 
//## United States License. To view a copy of this license, 
//## visit http://creativecommons.org/licenses/by-sa/3.0/us/ or send a letter 
//## to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
//######

(function ($) {
    $.fn.idleTimeout = function (options) {
        var defaults = {
            inactivity: 1200000, //20 Minutes
            noconfirm: 10000, //10 Seconds
            sessionAlive: 600000, //10 Minutes
            redirect_url: '/js_sandbox/',
            click_reset: true,
            key_reset: true,
            scroll_reset: true,
            alive_url: '/js_sandbox/',
            //killSession_url: '/js_sandbox/',
            logout_url: '/js_sandbox/',
            showDialog: true,
            dialogTitle: 'Auto Logout',
            dialogText: 'You are about to be signed out due to inactivity.',
            dialogButton: 'Stay Logged In',
            showDisplayLimit: true
        }

        //##############################
        //## Private Variables
        //##############################
        var opts = $.extend(defaults, options);
        var liveTimeout, confTimeout, sessionTimeout, remainingTimer;
        var modal = "";
        var fecha_ant = new Date();

        //##############################
        //## Private Functions
        //##############################
        var start_liveTimeout = function () {
            clearTimeout(liveTimeout);
            clearTimeout(confTimeout);
            liveTimeout = setTimeout(logout, opts.inactivity);

            var fecha_act = new Date();

            if ((fecha_act - fecha_ant) > opts.sessionAlive) {
                keep_session();
            }

            //if (opts.sessionAlive) {
            //        //alert(1)
            //    clearTimeout(sessionTimeout);
            //    sessionTimeout = setTimeout(keep_session, opts.sessionAlive);
            //}
            //alert('start_liveTimeout')
        }

        var logout = function () {
            var my_dialog;
            var buttonsOpts = {};

            confTimeout = setTimeout(redirect, opts.noconfirm);
            //confTimeout = setTimeout(redirect, 10000);

            buttonsOpts[opts.dialogButton] = function () {
                my_dialog.dialog('close');
                stopDialogTimer();
                stay_logged_in();
            }

            if (opts.showDialog) {
                if (opts.showDisplayLimit) {
                    if ($("#divCountdownDisplay") != undefined) {
                        $("#divCountdownDisplay").remove();
                    }
                }
                if ($("#modal_pop") != undefined) {
                    $("#modal_pop").remove();
                }
                modal = ""
                modal = opts.dialogText;

                my_dialog = $(modal).dialog({
                    buttons: buttonsOpts,
                    modal: true,
                    resizable: false,
                    width: 350,
                    closeOnEscape: false,
                    open: function (event, ui) {
                        $(this).dialog("widget").find(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                        //$(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                    },
                    title: opts.dialogTitle,
                    draggable: false,
                    resizable: false
                });

                $(document).unbind('click');
                $(document).unbind('keyup');
                $(document).unbind('mousewheel');

                // start the countdown display  
                countdownDisplay();
            }
        }

        // display remaining time on warning dialog
        var countdownDisplay = function () {

            var _idleSecondsCounter = 0;
            var dialogDisplayLimit = ((opts.noconfirm - 1000) / 1000) //time to display the warning dialog in seconds.
            var dialogDisplaySeconds = dialogDisplayLimit, mins, secs;

            remainingTimer = setInterval(function () {
                mins = Math.floor(dialogDisplaySeconds / 60); // minutes
                if (mins < 10) { mins = '0' + mins; }
                secs = dialogDisplaySeconds - (mins * 60); // seconds
                if (secs < 10) { secs = '0' + secs; }

                if (opts.showDisplayLimit) {
                    if (mins == 0) {
                        $('#divCountdownDisplay').html('<span style="color:red">' + secs + '</span>' + ' segundos');
                    }
                    if (secs == 0) {
                        $('#divCountdownDisplay').html('<span style="color:red">' + mins + '</span>' + ' minutos');
                    }
                    if (mins > 0 && secs > 0) {
                        $('#divCountdownDisplay').html('<span style="color:red">' + mins + '</span>' + ' minutos ' + '<span style="color:red">' + secs + '</span>' + ' segundos');
                    }
                }

                dialogDisplaySeconds -= 1;
                _idleSecondsCounter++;
            }, 1000);
        }

        var stopDialogTimer = function () {
            clearInterval(remainingTimer);
        }

        var redirect = function () {

            if (opts.logout_url) {

                $.ajax({
                    "url": opts.logout_url,
                    "data": "",
                    "dataType": 'json',
                    "contentType": "application/json; charset=utf-8",
                    "type": "POST",
                    "success": function (response) {
                        var Record = jQuery.parseJSON(response.d);
                    },
                    "error": function (xhr, status, msg) {
                        //window.location.href = baseUrl + msg;
                    }
                });
            }

            //Cuando finaliza el tiempo, muestra alerta con boton que al presionar envia al login..
            custom_alert();
        }

        var custom_alert = function () {
            $("<div title='Aviso' class='ui-state-error'><span class='ui-icon ui-icon-alert' style='margin: 0.9em 0.3em 0.2em 0.2em; float: left;'></span><p id='alert-message-content'></p></div>").html('Su sesi&oacute;n ha expirado.').dialog({
                resizable: false,
                modal: true,
                width: 350,
                closeOnEscape: false,
                open: function (event, ui) {
                    $(this).dialog("widget").find(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                    //$(".ui-dialog-titlebar-close", ui.dialog | ui).hide();

                    boInputChanged = false;
                    clearTimeout(sessionTimeout);
                },
                buttons: {
                    "Ok": function () {
                        window.location.href = opts.redirect_url;
                    }
                },
                draggable: false,
                resizable: false
            });
            //killSesion();
        }

        //var killSesion = function () {
        //    $.ajax({
        //        "url": opts.killSession_url,
        //        "data": "",
        //        "dataType": 'json',
        //        "contentType": "application/json; charset=utf-8",
        //        "type": "POST",
        //        "success": function (response) {

        //        },
        //        "error": function (xhr, status, msg) {
        //            //window.location.href = baseUrl + msg;
        //        }
        //    });

        //}
        var stay_logged_in = function (el) {
            start_live();

            //start_liveTimeout();
            //if (opts.alive_url) {

            //    $.ajax({
            //        "url": opts.alive_url,
            //        "data": "",
            //        "dataType": 'json',
            //        "contentType": "application/json; charset=utf-8",
            //        "type": "POST",
            //        "success": function (response) {
            //            var Record = jQuery.parseJSON(response.d);
            //        },
            //        "error": function (xhr, status, msg) {
            //            window.location.href = baseUrl + msg;
            //        }
            //    });

            //}
        }

        var keep_session = function () {
            fecha_ant = new Date();
            if (opts.alive_url) {
                $.ajax({
                    cache: false,
                    url: opts.alive_url,
                    data: "",
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    type: "POST",
                    success: function (response) {
                        var Record = jQuery.parseJSON(response.d);
                        $('#contenidoalerta').val(Record["d"]["__contenido"]);
                        if ($("#contenidoalerta").val() != "") {
                            $("#Alerta_BO").html($('#contenidoalerta').val());
                                $("#alerta").dialog("open");
                        }
                    },
                    error: function (xhr, status, msg) {
                        //window.location.href = baseUrl + msg;
                    }
                });
            }

            clearTimeout(sessionTimeout);
            sessionTimeout = setTimeout(keep_session, opts.sessionAlive);
        }

        var start_live = function () {
            //alert("pase")
            //obj = $(this);
            start_liveTimeout();
            if (opts.click_reset) {
                $(document).bind('click', start_liveTimeout);
            }
            if (opts.key_reset) {
                $(document).bind('keyup', start_liveTimeout);
            }
            if (opts.scroll_reset) {
                $(document).bind('mousewheel', start_liveTimeout);
            }

        }

        //###############################
        //Build & Return the instance of the item as a plugin
        // This is basically your construct.
        //###############################
        return this.each(function () {
            start_live();
            if (opts.sessionAlive) {
                keep_session();
            }
            //obj = $(this);
            //start_liveTimeout();
            //if (opts.click_reset) {
            //    $(document).bind('click', start_liveTimeout);
            //}
            //if (opts.key_reset) {
            //    $(document).bind('keyup', start_liveTimeout);
            //}
            //if (opts.scroll_reset) {
            //    $(document).bind('mousewheel', start_liveTimeout);
            //}
            //if (opts.sessionAlive) {
            //    keep_session();
            //}
        });

    };
})(jQuery);
