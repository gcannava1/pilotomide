<%@ Page Language="VB" AutoEventWireup="false" Inherits="PlataformaDocente.LoginP" CodeBehind="LoginP.aspx.vb" %>

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
            $('#tr_browser').hide()

            $(".blockArrastre").on('dragstart', function (e) { e.preventDefault(); });

            $('.soloCarRut').keydown(function (e) {

                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 189, 109, 190, 75]) !== -1 ||
                    (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    (e.keyCode >= 35 && e.keyCode <= 40) || (e.ctrlKey && e.keyCode == 86)) {
                    return;
                }
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });


            $('#loginUser').Rut({
                on_error: function () {
                    //setTimeout('fnLoginClearMessage()', 2000),
                    $("#loginLabel").text("Rut inválido");
                    $("#btnLogin").prop("disabled", true);//SPALMA 12-05-2016 Si rut invalido bloquea ingreso
                },
                on_success: function () {
                    $('#loginLabel').text("");
                    $("#btnLogin").prop("disabled", false); //SPALMA 12-05-2016 Si rut valido permite ingreso
                },
            });

            $('#txtLoginRecupera').Rut({
                on_error: function () {
                    $("#rut_valido").val("N");
                },
                on_success: function () {
                    $("#rut_valido").val("S");
                },
            });

            $('#btnLogin')
                .button()
                .removeClass('ui-button-text-only')
                .addClass('BotonLoginOFF')
                .mouseover(function () {
                    $('#btnLogin').addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $('#btnLogin').removeClass('PortadaSeleccion')
                })
                .click(function (event) {
                    event.preventDefault();
                });

            $('input').keypress(function (event) {
                if (event.which == 13) {
                    event.preventDefault();
                    if ($(this).context.id == 'loginUser') {
                        $('#loginPassword').focus();
                    }
                    else {
                        if ($(this).context.id == 'loginPassword' && $("#loginLabel").text() != "Rut inválido") {
                            $('#btnLogin').focus();
                            $('#btnLogin').trigger('click');
                        }
                    }
                }
                else if (event.which == 9) {
                    event.preventDefault();
                    if ($(this).context.id == 'loginPassword') {
                        $('#btnLogin').trigger('click');
                    }
                }
            });

            $("#btnOlvido").click(function (event) {
                event.preventDefault();
            });

            $('input[type=text]').addClass('text ui-widget-content ui-corner-all');
            $('input[type=password]').addClass('text ui-widget-content ui-corner-all');


            $("#btnAyuda").click(function (event) {
                event.preventDefault();

                $("#info-message2").dialog("option", "title", "Ayuda para el primer ingreso");
                $("#info-message-content2").html()
                $("#info-message2").dialog("open");

            });


            $("#btnOlvido").click(function (event) {
                var arrForm = '';
                var methodURL = '';

                methodURL = 'Login.aspx/fnValidarFechaRecuperarPass';
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
                        if (Record["d"]["__error"] != '') {
                            $("#alert-message").dialog("option", "title", "Aviso");
                            $("#alert-message-content").html(Record["d"]["__error"]);
                            $("#alert-message").dialog("open");
                        } else {
                            event.preventDefault();
                            $("#info-message3").dialog("option", "title", "Recuperar contraseña");
                            $("#info-message-content3").html()
                            $("#info-message3").dialog("open");

                            $("#txtLoginRecupera").val($("#loginUser").val());
                        }
                    },
                    error: function (xhr, msg, err) {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html(err);
                        $("#alert-message").dialog("open");
                    }
                });
            });

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

            $("#info-message2").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: "auto",
                buttons: {

                }
            });

            $("#info-message3").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400,
                buttons: {
                    Recuperar: function (event) {
                        event.preventDefault();
                        var arrForm = '';
                        var methodURL = '';
                        if ($('#txtLoginRecupera').val() != "" && $('#rut_valido').val() == "S") {
                            arrForm = '{user: "' + $('#txtLoginRecupera').val() + '"}';
                            methodURL = 'Login.aspx/RecuperarClave';
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
                                        $("#info-message").dialog("option", "title", "Información");
                                        $("#info-message-content").html(Record["d"]["__message"]);
                                        $("#info-message").dialog("open");
                                        $("#info-message3").dialog("close");
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

                        } else {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Rut invalido.");
                            $("#alert-message").dialog("open");
                        }

                    }
                }
            });

        });

        $(window).load(function () {
            //setTimeout('fnLoginClearMessage()', 2000);
            //$('#loginUser').focus();
            if (detectBrowser() == false) {
                $('#tr_login').hide()
                $('#tr_browser').show()
            }
        });

        function fnLoginClearMessage() {
            $('#loginLabel').text("");
        };

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
                        </td>
                    <td style="width: 59px;"></td>
                    <td align="center" style="width: 677px;">
                        <img src="Imagenes/imagesP/encabezado.png" alt="" class="blockArrastre" />
                    </td>
                    <td></td>
                    <td style="width: 163px;"></td>

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
                                <td style="background: url('Imagenes/imagesP/login_sup.png')  no-repeat;"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="tr_login">
                    <td colspan="6" align="center">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; background: url('Imagenes/imagesP/login_cen.png');" border="0">
                            <tr>
                                <td align="center">
                                    <table border="0" cellpadding="3">
                                        <tr>
                                            <td style="height: 10px;" colspan="2"></td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td align="center" valign="bottom" colspan="2">
                                                <input type="text" id="loginUser" placeholder="Usuario (RUT)" style="text-align: center; width: 20em;" name="loginUser" runat="server" maxlength="20" tabindex="1" class="soloCarRut" />
                                            </td>
                                        </tr>
                                        <tr class="ui-widget">
                                            <td align="center" colspan="2">
                                                <input type="password" id="loginPassword" placeholder="Contraseña" style="text-align: center; width: 20em;" name="loginPassword" runat="server" maxlength="20" tabindex="2" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="height: 40px;" colspan="2">
                                                <button id="btnLogin" name="btnLogin" style="width: 8em; height: 2em;" runat="server" onserverclick="btnLoginClick" tabindex="3">
                                                    INGRESAR</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ui-widget" style="height: 30px;" colspan="2"><b>
                                                <label id="loginLabel" runat="server" style="text-align: center">
                                                </label>
                                            </b></td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="3" style="width: 300px;">
                                        <tr class="ui-widget">
                                            <td align="center"><a id="btnAyuda" href="#" onclick="">¿Cuál es mi usuario?</a></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="tr_banner" runat="server">
                                <td align="center">
                                    <table align="center">
                                        <tr>
                                            <td>
                                                <div class="TextoBanner" id="banner_login" runat="server">
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="tr_browser">
                    <td colspan="6" align="center">
                        <table cellpadding="0" cellspacing="0" style="width: 618px; background: url('Imagenes/imagesP/login_cen.png');" border="0">
                            <tr class="ui-widget">
                                <td>
                                    <table align="center" border="0" cellpadding="3">
                                        <tr>
                                            <td colspan="3">Los navegadores habilitados para ingresar a la plataforma son:
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10px"></td>
                                            <td style="width: 50px">
                                                <img src="imagenes/imagesP/br_chrome.png" width="40" alt="" /></td>
                                            <td>Google Chrome</td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <img src="imagenes/imagesP/br_firefox.png" width="40" alt="" /></td>
                                            <td>Firefox</td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <img src="imagenes/imagesP/br_ie.png" width="40" alt="" /></td>
                                            <td>Internet Explorer 10 en adelante</td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <img src="imagenes/imagesP/br_edge.png" width="40" alt="" /></td>
                                            <td>Edge</td>
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
                                <td style="background: url('Imagenes/imagesP/login_inf.png');"></td>
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
                                    <div  class="pdTexto1" id="banner_cllamados" runat="server">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <%--<tr>
                    <td></td>
                    <td colspan="5" class="pdTexto1">Centro de Llamados: 600-222-0011<br /> Atención de lunes a viernes (excepto festivos), entre 9 y  22 hrs.<br /> (horario de Chile continental)
                    </td>
                </tr>--%>
                <tr>
                    <td></td>
                    <td colspan="5" class="pdTextoBrowser">
                        <br />
                        Esta plataforma puede ser utilizada con los siguiente navegadores: Chrome, Firefox, Internet Explorer 10 en adelante y Microsoft Edge.
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
        <div id="info-message" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content">
            </p>
        </div>
        <div id="info-message2" style="background: #ffffff;">
            <p id="info-message-content2">
                <img alt="" src="Imagenes/imagesP/ayuda_ingreso.jpg" />
            </p>

        </div>
        <div id="info-message3">
            <table align="center" border="0">
                <tr>
                    <td style="height: 40px;">
                        <asp:Label ID="Label1" runat="server" Text="Ingresa Rut: "></asp:Label>
                        <input type="text" id="txtLoginRecupera" style="width: 10em;" name="txtLoginRecupera" runat="server" maxlength="20" tabindex="1" class="soloCarRut" />
                    </td>
                </tr>
            </table>
        </div>
    </form>

    <input type="hidden" id="rut_valido" name="rut_valido" runat="server" />
</body>
</html>
