function fnCommon_Quit() {

    var methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/CheckSession"
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: "",
        dataType: "json",
        async: false,
        success: function (response) {
            try {
                if (typeof boInputChanged != 'undefined') {
                    if (boInputChanged == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("Hay cambios que no se han guardado.<br>¿Desea perderlos y cerrar la sesión?");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () { $(this).dialog("close"); window.location.replace(baseUrl + "Inicio.aspx?cerrar=1"); },
                            "No": function () { $(this).dialog("close"); }
                        }
                                    );
                        $("#confirm-dialog").dialog("open");
                    } else {
                        window.location.replace(baseUrl + "Inicio.aspx?cerrar=1");
                    }
                } else {
                    window.location.replace(baseUrl + "Inicio.aspx?cerrar=1");
                }

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("CheckSession: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("CheckSession: " + msg);
                $("#alert-message").dialog("open");
            }
        }
    });


}

function fnCommon_CloseWindow() {

    var methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/CheckSession"
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: "",
        dataType: "json",
        async: false,
        success: function (response) {
            try {
                if (typeof boInputChanged != 'undefined') {
                    if (boInputChanged == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("Hay cambios que no se han guardado.<br>¿Desea perderlos y cerrar la ventana?");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () { $(this).dialog("close"); window.close(); },
                            "No": function () { $(this).dialog("close"); }
                        }
                                    );
                        $("#confirm-dialog").dialog("open");
                    } else {
                        window.close();
                    }
                } else {
                    window.close();
                }

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("CheckSession: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("CheckSession: " + msg);
                $("#alert-message").dialog("open");
            }
        }
    });


}

function fnCommon_AccessToApplication(id_aplication) {

    // var baseUrl = '<%= ResolveUrl("~/") %>';
    var boolHasAccess = false;

    var methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/AccessToApplication";
    var parameters = '{"id_aplication":' + id_aplication + '}'

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: parameters,
        dataType: "json",
        async: false,
        success: function (response) {
            try {
                var Record = jQuery.parseJSON(response.d);

                if (Record["d"]["__error"] != "") {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("fnCommon_AccessToApplication: " + Record["d"]["__error"]);
                    $("#alert-message").dialog("open");
                }

                if (Record["d"]["__access"] == 'true') {
                    boolHasAccess = true;
                } else {
                    boolHasAccess = false;
                };

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("fnCommon_AccessToApplication: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("fnCommon_AccessToApplication: " + msg);
                $("#alert-message").dialog("open");
            }
        },
        complete: function () {

            // AGS 14-03-2013 ¿Algo más que hacer....? No por el momento.

        }

    });

    return boolHasAccess
}


function fnCommon_AccessToAction(id_aplication, id_action) {

    // var baseUrl = '<%= ResolveUrl("~/") %>';
    var boolHasAccess = false;

    var methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/AccessToAction";
    var parameters = '{"id_aplication":' + id_aplication
    parameters += ',"id_action":' + id_action + '}'

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: parameters,
        dataType: "json",
        async: false,
        success: function (response) {
            try {
                var Record = jQuery.parseJSON(response.d);

                if (Record["d"]["__error"] != "") {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("fnCommon_AccessToAction: " + Record["d"]["__error"]);
                    $("#alert-message").dialog("open");
                }

                if (Record["d"]["__access"] == 'true') {
                    boolHasAccess = true;
                } else {
                    boolHasAccess = false;
                };

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("fnCommon_AccessToAction: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("fnCommon_AccessToAction: " + msg);
                $("#alert-message").dialog("open");
            }
        },
        complete: function () {

            // AGS 14-03-2013 ¿Algo más que hacer....? No por el momento.

        }

    });

    return boolHasAccess
}

function fnCommon_DownloadFile(file_url) {

    var boolContinue = false;

    if (fnCommon_AccessToAction(66, 20003) == false) {

        $("#info-message").dialog("option", "title", "Control de acceso");
        $("#info-message-content").html("Su perfil de usuario no tiene acceso a esta acción.");
        $("#info-message").dialog("open");
        boolContinue = false;

    } else {
        boolContinue = true;
    }
    if (boolContinue == true) {
        window.open(baseUrl + file_url);
    }

}

function fnCommon_GotoApp(stFilter, st_app_url, mode, id_aplication, bool_withreturn, return_url, bool_newwindow) {
    var boolContinue = true;
    var param;

    if ('undefined' !== typeof id_aplication) {
        if (fnCommon_AccessToApplication(id_aplication) == false) {

            $("#info-message").dialog("option", "title", "Control de acceso");
            $("#info-message-content").html("Su perfil de usuario no tiene acceso a esta aplicación.");
            $("#info-message").dialog("open");
            boolContinue = false;

        }
    }

    if (boolContinue == true) {
        if ('undefined' !== typeof boInputChanged) {
            if (boInputChanged == true) {

                $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                $("#confirm-dialog-content").html("Hay cambios que no se han guardado.<br>¿Desea perderlos y continuar?");
                $("#confirm-dialog").dialog("option", "buttons", {
                    "Sí": function () {

                        param = baseUrl + st_app_url;

                        if (stFilter != "") {

                            param += "?";
                            param += "prefilter=" + stFilter;
                        }

                        if (mode == 'U') { param += "&mode=U"; }
                        if (mode == 'I') { param += "?mode=I"; }

                        if ('undefined' !== typeof bool_withreturn) {
                            if (bool_withreturn == true) {
                                if ('undefined' !== typeof return_url) {
                                    //param += "&returnUrl=" + return_url;
                                    fnCommon_StoreReturnUrl(return_url);
                                }
                            }
                        }

                        if ('undefined' !== typeof bool_newwindow) {
                            if (bool_newwindow == true) {
                                window.open(param);

                            } else {
                                window.location.replace(param);
                            }
                        } else {
                            window.location.replace(param + "&onStack=true");
                        }
                        $(this).dialog("close");
                    },
                    "No": function () {
                        $(this).dialog("close");
                    }
                }
                );
                $("#confirm-dialog").dialog("open");
            } else {
                param = baseUrl + st_app_url;

                if (stFilter != "") {

                    param += "?";
                    param += "prefilter=" + stFilter;
                }

                if (mode == 'U') { param += "&mode=U"; }
                if (mode == 'I') { param += "?mode=I"; }

                if ('undefined' !== typeof bool_withreturn) {
                    if (bool_withreturn == true) {
                        if ('undefined' !== typeof return_url) {

                            //param += "&returnUrl=" + return_url;
                            fnCommon_StoreReturnUrl(return_url);
                        }
                    }
                }

                if ('undefined' !== typeof bool_newwindow) {
                    if (bool_newwindow == true) {
                        window.open(param);

                    } else {
                        window.location.replace(param + "&onStack=true");
                    }
                } else {
                    window.location.replace(param);
                }
            }
        } else {
            param = baseUrl + st_app_url;


            if (stFilter != "") {

                param += "?";
                param += "prefilter=" + stFilter;
            }

            if (mode == 'U') { param += "&mode=U"; }

            if (mode == 'I') { param += "?mode=I"; }

            if ('undefined' !== typeof bool_withreturn) {
                if (bool_withreturn == true) {
                    if ('undefined' !== typeof return_url) {

                        //param += "&returnUrl=" + return_url;
                        fnCommon_StoreReturnUrl(return_url);
                    }
                }
            }

            if ('undefined' !== typeof bool_newwindow) {
                if (bool_newwindow == true) {

                    window.open(param);

                } else {

                    window.location.replace(param + "&onStack=true");
                }
            } else {

                window.location.replace(param);
            }
        }

    }

}


function fnCommon_GotoAppDialog(stFilter, st_app_url, mode, id_aplication) {

    var boolContinue = true;
    var param;

    if ($('#onDialog').val() == "true") {
        $("#info-message").dialog("option", "title", "Control de acceso");
        $("#info-message-content").html("No puede navegar desde una aplicación que ya está en drill-down.");
        $("#info-message").dialog("open");
        boolContinue = false;
    }

    if ('undefined' !== typeof id_aplication) {
        if (fnCommon_AccessToApplication(id_aplication) == false) {

            $("#info-message").dialog("option", "title", "Control de acceso");
            $("#info-message-content").html("Su perfil de usuario no tiene acceso a esta aplicación.");
            $("#info-message").dialog("open");
            boolContinue = false;

        }
    }



    if (boolContinue == true) {
        param = st_app_url;

        if (stFilter != "") {

            param += "?";
            param += "prefilter=" + stFilter;
        }

        if (mode == 'U') { param += "&mode=U"; }
        if (mode == 'I') { param += "?mode=I"; }

        param += "&onDialog=true"
        param += '&rnd=' + Math.random()
        $("#otherApp-dialog").empty();
        $("#otherApp-dialog").append("<iframe id='otherApp' src=''></iframe>");
        $("#otherApp-dialog").dialog({
            open: function () {
                $(this).parent().promise().done(function () {
                    $('#otherApp').attr('src', param); $(this).addClass('maximized');
                });
            }
        });


    }


}


function fnCommon_ServerNextId(recField, id_correlativo) {

    methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/ServerNextId";

    parameters = '{';
    parameters += '"id_correlativo":"' + id_correlativo + '"';
    parameters += '}'

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: parameters,
        dataType: "json",
        async: false,
        success: function (response) {

            try {
                var Record = jQuery.parseJSON(response.d);

                if (Record["d"]["__error"] != "") {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                    $("#alert-message").dialog("open");
                } else {

                    $("#" + recField).val(Record["d"]["__nextid"]);

                }
            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }

        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = '<%= ResolveUrl("~/") %>' + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo acceder a método en el servidor: " + xhr.status);
                $("#alert-message").dialog("open");
            }
        },
        complete: function () {

        }
    });

}


function fnCommon_StoreReturnUrl(stReturnUrl) {

    var arr_return_urls = [];
    var arr_return_urls = JSON.parse(sessionStorage["return_urls"]);
    arr_return_urls.push(stReturnUrl);
    sessionStorage["return_urls"] = JSON.stringify(arr_return_urls);

}

function fnCommon_PopReturnURL() {
    var stReturnUrl
    var arr_return_urls = [];
    var arr_return_urls = JSON.parse(sessionStorage["return_urls"]);
    stReturnUrl = baseUrl + arr_return_urls.pop() + "&mode=U";
    if (arr_return_urls.length > 1) {
        stReturnUrl += "&onStack=true";
    }

    sessionStorage["return_urls"] = JSON.stringify(arr_return_urls);
    return stReturnUrl;
}

function fnCommon_ClearAndInitReturnUrls() {
    sessionStorage.clear();
    var arr_return_urls = new Array();
    arr_return_urls.push("Init");
    sessionStorage["return_urls"] = JSON.stringify(arr_return_urls);

}

function fnCommon_SetMsgSave(obj) {
    obj.html("<label class='ui-widget-content ui-corner-all msgSaved'>Registro guardado OK</label>");
}

function fnCommon_ClearMsgSave(obj) {
    obj.html("");
}


// AGS 26-03-2013 Limpia los parámetros del lookup para que no se confundan entre un lookup y otro. Esta función debe ser 
// llamada en cada lookup del formulario antes de parametrizarlo.



function fnCommon_fnPrepareLookupParameters() {

    //var stLookupHeaders;
    //var stLookupColumns;
    //var stLookupTable;
    //var inLookupMaxRows;
    //var inLookupIncrementRows = 50;
    //var inLookupHeight = 400;
    //var inLookupWidth = 400;
    //var stLookupKeyColumn;
    //var stLookupReturnColumn;
    //var stLookupOptionalReturnColumns
    //var stLookupOrderBy;
    //var boLookupUserFilter;
    //var boMultiSelect = false;
    //var boConcat = false;
    //var stLookupSql;
    //var stLookupParentColumn;
    //var objLookupInputKeyField;
    //var objLookupReturnField;
    //var objLookupParentInputKeyField;
    //var objLookupOptionalReturnFields = [];
    //var objLookupInputChildFields = [];
    //var boCleanChildFirst = false;

    stLookupHeaders = "";
    stLookupColumns = "";
    stLookupTable = "";
    inLookupMaxRows = "100"; // Por defecto
    inLookupIncrementRows = 50;
    inLookupHeight = 400; // Por defecto
    inLookupWidth = 400; // Por defecto
    stLookupKeyColumn = "";
    stLookupReturnColumn = "";
    stLookupOptionalReturnColumns = ""
    stLookupOrderBy = "";
    boLookupUserFilter = true; // Por defecto
    boMultiSelect = false; // Por defecto
    stLookupSql = "";
    stLookupParentColumn = "";
    objLookupInputKeyField = "";
    objLookupReturnField = "";
    boConcat = false;
    stConcatSeparator = ""
    boCleanChildsFirst = false;
    objLookupParentInputKeyField = "";
    objLookupOptionalReturnFields = [];
    objLookupInputChildFields = [];
    inScrollY = -1;

}

function fnCommon_fnUpdateGaugeData(gauge, datasourceURL, objGaugeContainer) {

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: datasourceURL,
        data: "",
        dataType: "json",
        async: false,
        success: function (response) {
            try {

                //if (objGaugeContainer.is(":visible")) {

                    gauge.beginUpdate();
                    gauge.option("title", response.__title);

                    gauge.option("subtitle", response.__subtitle);

                    gauge.option("scale.startValue", response.__startValue);
                    gauge.option("scale.majorTick.tickInterval", response.__mayorTickInterval);

                    gauge.option("scale.endValue", response.__endValue);
                    gauge.option("scale.minorTick.tickInterval", response.__minorTickInterval);
                    gauge.option("scale.label", response.__scaleformat);

                    gauge.option("rangeContainer.ranges", response.__ranges);

                    gauge.option("tooltip.format", response.__tooltipFormat);
                    gauge.option("tooltip.precision", response.__tooltipPrecision);

                    gauge.option("value", response.__value);

                    gauge.subvalues(response.__subvalues);

                    gauge.endUpdate();

                    ///gauge.render();
                //}
                

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("UpdateGaugeData: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("UpdateGaugeData: " + msg);
                $("#alert-message").dialog("open");
            }
        }
    });

}


function fnCommon_fnUpdateResultSetData(chart, datasourceURL, objFiltro, objUrl, inChartType) {

    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: datasourceURL,
        data: "",
        dataType: "json",
        async: false,
        success: function (response) {
            try {

                objFiltro.val(response.__filtro);
                objUrl.val(response.__url);

                chart.beginUpdate();

                chart.option("title.text", response.__title);

                chart.option("legend.visible", response.__legendvisible);

                if (inChartType == 1) {

                } else {
                    chart.option("rotated", response.__rotated);
                    chart.option("series", response.__series);
                }

                chart.option("dataSource", response.__dataSource);

                chart.endUpdate();
                chart.render();

            }
            catch (e) {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("UpdateResultSetData: Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor: " + e.toString());
                $("#alert-message").dialog("open");
            }
        },
        error: function (xhr, status, msg) {
            if (xhr.status == 419) {
                window.location.href = baseUrl + msg;
            } else {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html("UpdateResultSetData: " + msg);
                $("#alert-message").dialog("open");
            }
        }
    });

}

function fnCommon_fnEnterTab() {

    $("input").bind("keydown", function (e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            $('input,select,textarea')[$('input,select,textarea').index(this) + 1].focus();
        }
    });
}
//bloqueo de boton atras y F5
function fnCommon_nobackbutton() {//boton atras
    window.location.hash = "backbutton";
    window.location.hash = "Backbutton" //chrome
    window.onhashchange = function () { window.location.hash = ""; }
   
    function checkKeyCode(evt) {//tecla F5

        var evt = (evt) ? evt : ((event) ? event : null);
        var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
        if (event.keyCode == 116) {
            evt.keyCode = 0;
            return false
        }
    }
    document.onkeydown = checkKeyCode;
}

function fnCommon_analytics() {
    (function (i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r; i[r] = i[r] || function () {
            (i[r].q = i[r].q || []).push(arguments)
        }, i[r].l = 1 * new Date(); a = s.createElement(o),
        m = s.getElementsByTagName(o)[0]; a.async = 1; a.src = g; m.parentNode.insertBefore(a, m)
    })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

    ga('create', 'UA-99314972-1', 'auto'); //UA-99314972-1 Leandro //UA-99578671-3 SOLEX
    ga('send', 'pageview');
}


