<%@ Page Language="VB" AutoEventWireup="false" Inherits="PlataformaDocente.cambiarcontrasena" CodeBehind="cambiarcontrasena.aspx.vb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Plataforma Docente</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <script src="Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="Scripts/jQuery/plugins/Rut/jquery.Rut.min.js" type="text/javascript"></script>
    <script src="Scripts/Framework/__jsCommon/jsCommon.js?v=150720151107" type="text/javascript"></script>
    <link href="Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="StyleFrameworkSolex.css" rel="stylesheet" type="text/css" />
    <link rel="SHORTCUT ICON" href="Imagenes/favicon.ico" type="image/x-icon" />
    <link rel="ICON" href="Imagenes/favicon.ico" type="image/ico" />
    <script type="text/javascript">
        $.fn.ready(function () {
            $('#btn_ACEPTAR')
                .button()
                .removeClass('ui-button-text-only')
                .addClass('BotonLoginOFF')
                .mouseover(function () {
                    $('#btn_ACEPTAR').addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $('#btn_ACEPTAR').removeClass('PortadaSeleccion')
                })
                .click(function (event) {
                    event.preventDefault();
                });

            $('#btn_CANCELAR')
                .button()
                .removeClass('ui-button-text-only')
                .addClass('BotonLoginOFF')
                .mouseover(function () {
                    $('#btn_CANCELAR').addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $('#btn_CANCELAR').removeClass('PortadaSeleccion')
                })
                .click(function (event) {
                    event.preventDefault();
                    $("#dialog-cancelar").dialog("option", "title", "No recuperar contraseña");
                    $("#dialog-cancelar-content").html("¿Está seguro de que no desea ingresar una nueva contraseña?");
                    $("#dialog-cancelar").dialog("open");
                });

            $("#btn_ACEPTAR")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    var arrForm = '';
                    var methodURL = '';
                    debugger;
                    arrForm = '{password: "' + $('#in_CONTRASENA1').val() + '",repassword: "' + $('#in_CONTRASENA2').val() + '",correo: "' + $('#correo').val()
                    arrForm += '",nombredocente: "' + $('#in_NOMBRE').val() + '",aux: "' + $('#aux').val() + '",ap: "' + $('#ap').val() + '"}';
                    methodURL = 'cambiarcontrasena.aspx/SavePass';
                        $.ajax({
                            cache: false,
                            async: false,
                            type: "POST",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            url: methodURL,
                            data: arrForm,
                            success: function (response) {

                                var Record = jQuery.parseJSON(response.d);
                                if (Record["d"]["__message"] != '') {
                                    $("#info-message-redirect").dialog("option", "title", "Información");
                                    $("#info-message-redirect-content").html(Record["d"]["__message"]);
                                    $("#info-message-redirect").dialog("open");
                                } else {
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html(Record["d"]["__error"]);
                                    $("#alert-message").dialog("open");
                                }
                            },
                            error: function (xhr, msg, err) {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html(err);
                                $("#alert-message").dialog("open");
                            }
                        });
                });

            $('tr.Mostrar_Tabla').click(function () {
                $trOcultar = $(this).next('tr[id^="Tabla_Mostrar"]');

                if ($trOcultar.is(":visible")) {
                    //$trOcultar.css('display', 'none');
                }
                else {
                    $trOcultar.css('display', '');
                }
            });

            $('input[type=text]').addClass('text ui-widget-content ui-corner-all');
            $('input[type=password]').addClass('text ui-widget-content ui-corner-all');

            $("#alert-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 500,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#dialog-cancelar").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 500,
                buttons: {
                    "Sí, lo estoy": function () {
                        $(location).attr('href', $('#localurl').val());
                    },
                    Cancelar: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#info-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 500,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#info-message-redirect").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 500,
                closeOnEscape: false,
                open: function(event, ui) {
                    $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
                },
                buttons: {
                    Ok: function () {
                        $(location).attr('href', $('#localurl').val());
                    }
                }
            });



        }); //FIN DOCUMENT READY

        $(window).load(function () {
            if (detectBrowser() == false) {
                $('#tr_login').hide()
                $('#tr_browser').show()
            }
        });

        function detectBrowser() {
            var ua = window.navigator.userAgent;
            //alert(ua);
            var msie = ua.indexOf('MSIE ');
            if (msie > 0) {
                // IE 10 
                return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10) == 10;
            }

            var trident = ua.indexOf('Trident/');
            if (trident > 0) {
                // IE 11 
                var rv = ua.indexOf('rv:');
                return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10) == 11;
            }

            var edge = ua.indexOf('Edge/');
            if (edge > 0) {
                // Edge 
                return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10) >= 12;
            }

            var CriOS = ua.indexOf('CriOS/');//nuevo chrome iphone60.
            if (CriOS > 0) {
                return parseInt(ua.substring(CriOS + 6, ua.indexOf('.', CriOS)), 10) >= 40;
            }

            var chrome = ua.indexOf('Chrome/');
            if (chrome > 0) {
                return parseInt(ua.substring(chrome + 7, ua.indexOf('.', chrome)), 10) >= 40;
            }

            var firefox = ua.indexOf('Firefox/');
            if (firefox > 0) {
                return parseInt(ua.substring(firefox + 8, ua.indexOf('.', firefox)), 10) >= 38;
            }
            // other browser
            return false;
        };
    </script>
</head>
<body class="slxloginbody" onload="fnCommon_nobackbutton()">
    <form id="frmLogin" runat="server">
        <div>
            <table align="center" cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                <tr>
                    <td style="width: 100px;"></td>
                    <td rowspan="2" align="right">
                        <img src="Imagenes/Images/LogoGob.jpg" alt="" class="blockArrastre" /></td>
                    <td style="width: 59px;"></td>
                    <td align="center" style="width: 677px;">
                        <img src="Imagenes/Images/encabezado.png" alt="" class="blockArrastre" />
                    </td>
                    <td>
                        <img src="Imagenes/Images/LogoDM.png" alt="" class="blockArrastre" />
                    </td>
                    <td style="width: 100px;"></td>

                </tr>
                <tr>
                    <td style="height: 10px; background: #f6f6f6;"></td>
                    <td colspan="4" style="height: 10px; background: #f6f6f6;"></td>
                </tr>
                <tr>
                    <td colspan="6" align="center" style="height: 50px; background: #f6f6f6;" class="pdTitulo1"></td>
                </tr>
                <tr>
                    <td colspan="6" align="center" style="background: #f6f6f6;">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; height: 30px;">
                            <tr>
                                <td style="background: url('Imagenes/images/login_sup.png')  no-repeat;"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="tr_login">
                    <td colspan="6" align="center">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; background: url('Imagenes/images/login_cen.png');" border="0">
                            <tr>
                                <td align="center">
                                    <table border="0" cellpadding="3" id="new_pass" runat="server">
                                        <tr>
                                            <td style="height: 10px;" colspan="2"></td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td>
                                                <label><b>RUT:</b></label>
                                            </td>
                                            <td align="center" valign="bottom" colspan="2">
                                                <input type="text" id="in_RUT" name="in_RUT" style="text-align: left; width: 20em;" runat="server" maxlength="20" readonly="readonly"/>
                                            </td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td>
                                                <label><b>NOMBRE:</b></label>
                                            </td>
                                            <td align="center" colspan="2" class="auto-style1">
                                                <input type="text" id="in_NOMBRE" name="in_NOMBRE" style="text-align: left; width: 20em;" runat="server" maxlength="20" readonly="readonly" />
                                            </td>
                                        </tr>
                                        <tr class="ui-widget" align="center">
                                            <td colspan="2">
                                                <label><i><b>
                                                    Registre su nueva contraseña
                                                </b></i></label>
                                            </td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td>
                                                <label>Ingrese su nueva contraseña:</label>
                                            </td>
                                            <td align="center" valign="bottom" colspan="2">
                                                <input type="password" id="in_CONTRASENA1" name="in_CONTRASENA1" placeholder="Mínimo 4 caracteres" style="text-align: center; width: 20em;" runat="server" maxlength="20" tabindex="1"/>
                                            </td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td>
                                                <label>Reingrese su nueva contraseña:</label>
                                            </td>
                                            <td align="center" colspan="2">
                                                <input type="password" id="in_CONTRASENA2" name="in_CONTRASENA2" placeholder="Mínimo 4 caracteres" style="text-align: center; width: 20em;" runat="server" maxlength="20" tabindex="2" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="height: 40px;">
                                                <button id="btn_ACEPTAR" name="btn_ACEPTAR" style="width: 8em; height: 2em;" runat="server" tabindex="3">
                                                    ACEPTAR</button>
                                            </td>
                                            <td align="right" style="height: 40px;">
                                                <button id="btn_CANCELAR" name="btn_CANCELAR" style="width: 8em; height: 2em;" runat="server" tabindex="3">
                                                    CANCELAR</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ui-widget" style="height: 30px;" colspan="2"><b>
                                                <label id="loginLabel" runat="server" style="text-align: center">
                                                </label>
                                            </b></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="center">
                                    <table border="0" cellpadding="3" id="no_pass" runat="server">
                                        <tr class="ui-widget" align="center">
                                            <td>
                                                <p><b>Este link ha caducado, haga clic nuevamente en recuperar contraseña <br />para obtener un nuevo link.</b></p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" align="center">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; height: 10px;" border="0">
                            <tr>
                                <td style="background: url('Imagenes/images/login_inf.png');"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="ui-widget">
                    <td colspan="6" style="height: 6em"></td>
                </tr>
                <tr id="tr_banner2" runat="server">
                    <td align="center" colspan="5">
                        <table align="center">
                            <tr>
                                <td>
                                    <div class="pdTexto1" id="banner_cllamados" runat="server">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

        </div>
        <div class="ui-widget">

            <table style="width: 100%; height: 100%; padding: 0em;" border="0">
                <tr>
                    <td colspan="3" align="right" valign="bottom" style="height: 4em; color: white;">
                        <label id="loginVersion" runat="server">
                        </label>
                    </td>
                </tr>
            </table>
        </div>
        <div id="alert-message" class="ui-state-error">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="alert-message-content">
            </p>
        </div>
        <div id="dialog-cancelar" class="ui-state-error">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="dialog-cancelar-content">
            </p>
        </div>
        <div id="info-message-redirect" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-redirect-content">
            </p>
        </div>
        <div id="info-message" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content">
            </p>
        </div>
    </form>
    <input type="hidden" id="aux" runat="server" />
    <input type="hidden" id="ap" runat="server" />
    <input type="hidden" id="correo" runat="server" />
    <input type="hidden" id="localurl" runat="server" />
</body>
</html>

