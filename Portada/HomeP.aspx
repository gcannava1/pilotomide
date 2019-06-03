<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="HomeP.aspx.vb" Inherits="PlataformaDocente.HomeP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <link rel="SHORTCUT ICON" href="~/Imagenes/favicon.ico" type="image/x-icon" />
    <link rel="ICON" href="~/Imagenes/favicon.ico" type="image/ico" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title></title>
    <script src="../Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/FileDownload/jQuery.download.js" type="text/javascript"></script>
    <script src="../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <!--NMM. 11.12.17 RS27390-->
    <script src="../Scripts/jQuery/plugins/Touch/jquery_ui_touch-punch.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/Datatables/jquery.dataTables.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/Datatables/plugins/dataTables.fnSetFilteringDelay.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/Datatables/plugins/FixedColumns25.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/diff_match_patch.js" type="text/javascript"></script>
    <script src="../Scripts/jQuery/plugins/jquery-idleTimeout.js?v=1" type="text/javascript"></script>
    <style type="text/css" title="currentStyle">
        @import "../Scripts/jQuery/plugins/Datatables/css/jquery.dataTables_themeroller.css";
    </style>

    <link href="../Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../StyleFrameworkSolex.css?v=1" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';
        var dmp = new diff_match_patch();
        //NMM. 11.12.17 RS27390
        var iDisplayLength;
        var isTablet = navigator.userAgent.match(/iPad/i) != null;
        var isIE = navigator.userAgent.match(/MSIE/i) != null;
        if ($(window).height() <= 600) {
            iDisplayLength = 15
        }
        if (($(window).height() > 600) && ($(window).height() <= 700)) {
            iDisplayLength = 20
        }
        if (($(window).height() > 700) && ($(window).height() <= 1000)) {
            iDisplayLength = 25
        }
        if ($(window).height() > 1000) {
            iDisplayLength = 30
        }
        var boInputChanged = false;
        //NMM. 11.12.17 RS27390
        var oTable;
        var columns = [];
        $.fn.ready(function () {

            $(document).ajaxError(function (event, jqxhr, settings, exception) {
                if (jqxhr.status == 419) {
                    window.location.href = '<%= ResolveUrl("~/") %>' + exception;
                } else {
                    //Not connect: Verify Network.
                    if (jqxhr.status == 0) { strMsg = "Error de conexión a internet." }
                    else { strMsg = "Error ajax call no controlado: " + jqxhr.status + ": " + exception }

                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html(strMsg);
                    $("#alert-message").dialog("open");
                }
            });
            $("#alerta").dialog({
                modal: true,
                autoOpen: false,
                position: 'center',
                height: "auto",
                create: function () {
                    $(this).css("maxHeight", 400);
                },
                show: {
                    effect: "blind",
                    duration: 100
                },
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });


            fnCommon_analytics();
            mostrar_alerta();
            mostrar_atencion();

            $("#alert-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
            });


            $("#info-message").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $('input[name*="rdAutorizar"]').bind('change', function () {
                boInputChanged = true;
            });

            $("#info-message-bold").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 470,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#info-bienvenida").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 550,
                resizable: false,
                position: {
                    my: "center",
                    at: "center",
                    of: window,
                    collision: "none"
                },
                create: function (e, ui) {
                    $(this).dialog('widget')
                        .find('.ui-dialog-titlebar')
                        .removeClass('ui-corner-all')
                        .addClass('ui-corner-top');
                    $(e.target).parent().css('position', 'fixed');
                },
                buttons: {
                    Aceptar: function () {
                        $(this).dialog("close");
                    }
                },
                open: function (event, ui) {
                    $(this).css('overflow', 'hidden');
                }
            });

            $("#info-cierrePortafolio").dialog({
                modal: true,
                autoOpen: false,
                height: 300,
                width: 540,
                create: function (e, ui) {
                    $(this).dialog('widget')
                        .find('.ui-dialog-titlebar')
                        .removeClass('ui-corner-all')
                        .addClass('ui-corner-top');
                },
                buttons: {
                },
                open: function (event, ui) {
                    $(this).css('overflow', 'hidden');
                }
            });


            //SPH - Declaracion de Dialogo que se abre cuando se cumple la condicion de modificación del registro del docente(Nivel,Sub,Esta)
            $("#info-mod").dialog({
                modal: true,
                autoOpen: false,
                height: 300,
                width: 400,
                create: function (e, ui) {
                    $(this).dialog('widget')
                        .find('.ui-dialog-titlebar')
                        .removeClass('ui-corner-all')
                        .addClass('ui-corner-top');
                },
                buttons: {
                },
                open: function (event, ui) {
                    $(this).css('overflow', 'hidden');
                }
            });

            $("#dialog-info-obj").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 500,
                buttons: {

                }
            });
            //NMM. RS27390 06.12.17 
            $("#informeCopia").dialog({
                modal: true,
                autoOpen: false,
                height: 800,
                width: 1000
            });

            $("#autoevaluacion").hide();

            $(".blockArrastre").on('dragstart', function (e) { e.preventDefault(); });

            if ($("#dependencia").val() == "PS" || $("#dependencia").val() == "AD") {
                //$("#AE").hide()
                $("#autoevaluacion").hide();
                $("#calendario").attr("src", "../Imagenes/ImagesP/bannerhomePSAD.png?t=");
                $("#btn_manual_ae").hide();
                $("#btn_avance_ae").hide();
                $("#bienvenida").attr("src", "../Imagenes/ImagesP/Bienvenida 2018PSAD.png");
                //.button()
                //.text("")
                //.removeAttr("onclick")
                //.removeClass('PortadaSeleccion')
                //.attr("disabled", "disabled")
            } else {
                $("#autoevaluacion").hide();
                $("#calendario").attr("src", "../Imagenes/ImagesP/bannerhome.png?t=");
                $("#bienvenida").attr("src", "../Imagenes/ImagesP/Bienvenida 2018.png");
                //mostrar_autoevaluacion();
                $("#AE")
                .button()
                .addClass('PortadaAE')
                .mouseover(function () {
                    $('#AE').addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $('#AE').removeClass('PortadaSeleccion')
                })
                .click(function (event) {
                    event.preventDefault();
                    Validar_fecha_ingreso("AE", "AE");
                });
            }

            //$('input[name*="rec_"]').bind('change paste keyup keydown keypress', function () {
            //    boInputChanged = true;
            //});

            //$('select[name*="rec_"]').bind('change paste keyup keydown keypress', function () {
            //    boInputChanged = true;
            //});

            //$('textarea[name*="rec_"]').bind('change paste keyup keydown keypress', function () {
            //    boInputChanged = true;
            //});

            //Control de refresco de pagina
            window.addEventListener('beforeunload', function (event) {
                if (boInputChanged == true && $('input[name=rdAutorizar]:checked').val() != $("#uso_datos").val()) {
                    event.returnValue = "Hay cambios que no se han guardado. Presione Cancelar para volver y guardar los cambios.";
                };
            });

            $("#T1")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoEE') {
                        Validar_fecha_ingreso("T1", "PF");
                    }
                });

            $("#T2")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoEE') {
                        Validar_fecha_ingreso("T2", "PF");
                    }
                });

            $("#T3")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoEE') {
                        Validar_fecha_ingreso("T3", "PF");
                    }
                });

            $("#T4")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoCG') {
                        Validar_fecha_ingreso("T4", "PF");
                    }
                });

            $("#T5")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoEE') {
                        Validar_fecha_ingreso("T5", "PF");
                    }
                });

            $("#btnContinuar")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    HideFormAutoriz();
                    var RDB_VAL_SELECT = '';
                    var RDB_CHECK = $("input[name$='rdAutorizar']");
                    for (var i = 0; i < RDB_CHECK.length; i++) {
                        if (RDB_CHECK[i].checked == true) {
                            SaveAutorizacion();
                        }
                    }
                });
            //$("#btnContinuar").attr('disabled', true);
            $("#btnFormAutorizacion")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if (validar_evaluacion() == true) {
                        if ($("#MostrarFormAutorizacion").val() == 1) {
                            $("#imgPortadaAut").hide();
                        } else {
                            $("#imgPortadaAut").show();
                        }

                        LoadFormAutorizacion();
                    }
                });
            $("#tdBtnAutorizacion").hide();
            //NMM. RS27390 04.12.17 
            $("#btnInformeCopia")
                .button()
                .click(function (event) {
                    event.preventDefault();
                    if (validar_evaluacion() == true) {
                        LoadInformeCopia();
                    }
                });
            $("#tdBtnInformeCopia").hide();

            $("#btnDescargaPDF")
                .button()
            .click(function (event) {
                event.preventDefault();
                if (validar_evaluacion() == true) {
                    descarga_informe_copia_pdf();
                }
            });

            $("#desc_avance_pf")
             .button()
             .click(function (event) {
                 event.preventDefault();
                 if (validar_evaluacion() == true) {
                     window.location.replace(baseUrl + "Aplicaciones/Ficha/fichas.aspx?ficha=AvancePortafolio");
                 }
             });

            $("#dialog_copia").dialog(
                {
                    modal: true,
                    autoOpen: false,
                    height: 800,
                    width: 1000,
                });

            $("#desc_avance_ae")
             .button()
             .click(function (event) {
                 event.preventDefault();
                 if (validar_evaluacion() == true) {
                     window.location.replace(baseUrl + "Aplicaciones/Ficha/fichas.aspx?ficha=AvanceAutoEvaluacion");
                 }
             });

            $(".botonEE")
                .removeClass('ui-button-text-only')
                .addClass('PortadaPF')
                .mouseover(function () {
                    if ($("#modo").val() == 'PilotoEE') {
                        $(this).addClass('PortadaSeleccion')
                    }
                    else {
                        $(this).addClass('PortadaSeleccion2')
                    }
                })
                .mouseout(function () {
                    $(this).removeClass('PortadaSeleccion')
                });

            $(".botonCG")
                .removeClass('ui-button-text-only')
                .addClass('PortadaPF')
                .mouseover(function () {
                    if ($("#modo").val() == 'PilotoCG') {
                        $(this).addClass('PortadaSeleccion')
                    }
                    else {
                        $(this).addClass('PortadaSeleccion2')
                    }
                })
                .mouseout(function () {
                    $(this).removeClass('PortadaSeleccion')
                });

            // botones de Autoevaluación 
            $(".btn_ae")
                .removeClass('ui-button-text-only')
                .addClass('BotonPortadaAE2')
                .mouseover(function () {
                    $(this).addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $(this).removeClass('PortadaSeleccion')
                });

            $("#btn_manual_ae")
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if (validar_evaluacion() == true) {
                        //validar fecha disponibilidad descarga archivo
                        var methodURL = 'Home.aspx/DescargarManuales';
                        var parameters = '{}';
                        $("#Vidrio").show();
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
                                        $("#info-message-bold").dialog("option", "title", "Información");
                                        $("#info-message-content-bold").html(Record["d"]["__error"]);
                                        $("#info-message-bold").dialog("open");
                                    } else {
                                        //keypath, nombre_servidor, nombre_cliente
                                        DescargarArchivo('pathArchivo', $("#manual_AE_Serv").val() + '.pdf', $("#manual_AE_Cli").val() + '.pdf');
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
                                    $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                                    $("#alert-message").dialog("open");
                                }
                            },
                            complete: function () {
                                $("#Vidrio").hide();
                            }
                        });
                    }
                });

            $("#btn_avance_ae")
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if (validar_evaluacion() == true) {
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichas.aspx?ficha=AvanceAutoEvaluacion");
                    }

                });
            //-----------------------------------------

            // botones de Portafolio
            $(".btn_pf")
                .removeClass('ui-button-text-only')
                .addClass('BotonPortadaPF2')
                .mouseover(function () {
                    $(this).addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $(this).removeClass('PortadaSeleccion')
                });

            $("#btn_manual_pf")
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if (validar_evaluacion() == true) {
                        //validar fecha disponibilidad descarga archivo
                        var methodURL = 'Home.aspx/DescargarManuales';
                        var parameters = '{}';
                        $("#Vidrio").show();
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
                                        $("#info-message-bold").dialog("option", "title", "Información");
                                        $("#info-message-content-bold").html(Record["d"]["__error"]);
                                        $("#info-message-bold").dialog("open");
                                    } else {
                                        //keypath, nombre_servidor, nombre_cliente
                                        DescargarArchivo('pathArchivo', $("#manual_PF_Serv").val() + '.pdf', $("#manual_PF_Cli").val() + '.pdf');
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
                                    $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                                    $("#alert-message").dialog("open");
                                }
                            },
                            complete: function () {
                                $("#Vidrio").hide();
                            }
                        });
                    }

                });

            $("#btn_obj_curr")
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if (validar_evaluacion() == true) {
                        if ($("#nivel").val() == "EA") {
                            $("#dialog-info-obj").dialog("option", "title", "Objetivos Curriculares");
                            $("#dialog-info-obj").html("<p style='text-align:justify'>En el caso de Educación de Adultos NO hay opciones predeterminadas de objetivos para realizar la unidad del Módulo 1.</br></br><u>Usted puede elegir cualquier Objetivo Fundamental del Marco Curricular vigente</u>, mientras corresponda al nivel y asignatura por los que está siendo evaluado/a (vea la página 11 de su Manual Portafolio). </p>");
                            $("#dialog-info-obj").dialog("open");
                        }
                        else if ($("#nivel").val() == "EE") {
                            $("#dialog-info-obj").dialog("option", "title", "Objetivos Curriculares");
                            $("#dialog-info-obj").html("<p style='text-align:justify'>En el caso de Educación Especial NO hay opciones predeterminadas de objetivos para realizar la unidad el Módulo 1.</br></br><u>Usted puede elegir cualquier Objetivo o Aprendizaje Esperado del Currículum vigente</u> (vea las páginas 11 y 12 de su Manual Portafolio).</p>");
                            $("#dialog-info-obj").dialog("open");
                        }
                        else if ($("#nivel").val() == "EMTP") {
                            $("#dialog-info-obj").dialog("option", "title", "Objetivos Curriculares");
                            $("#dialog-info-obj").html("<p style='text-align:justify'>En el caso de Educación Media Técnico Profesional NO hay opciones predeterminadas de objetivos para realizar la tarea “Planificación”.</br></br><u>Usted debe elegir un Objetivo de aprendizaje para desarrollar esta tarea</u>, siguiendo las indicaciones de su Manual Portafolio (página 13).</p>");
                            $("#dialog-info-obj").dialog("open");
                        } else {
                            var methodURL = 'Home.aspx/DescargarManuales';
                            var parameters = '{}';
                            $("#Vidrio").show();
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
                                            $("#info-message-bold").dialog("option", "title", "Información");
                                            $("#info-message-content-bold").html(Record["d"]["__error"]);
                                            $("#info-message-bold").dialog("open");
                                        } else {

                                            DescargarArchivo('pathArchivo', $("#Obj_curr_Serv").val() + '.pdf', $("#Obj_curr_Cli").val() + '.pdf');
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
                                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                                        $("#alert-message").dialog("open");
                                    }
                                },
                                complete: function () {
                                    $("#Vidrio").hide();
                                }
                            });
                        }
            }
                });

            $("#btn_avance_pf")
                .button()
                .click(function (event) {
                    event.preventDefault();

                    if (validar_evaluacion() == true) {
                        Validacion_Articulo_70("PF")
                    }
                });
            //-----------------------------------------------

            $("#btn_ayuda")
                .button()
                .removeClass('ui-button-text-only')
                .addClass('BotonAyuda')
                .mouseover(function () {
                    $(this).addClass('PortadaSeleccion')
                })
                .mouseout(function () {
                    $(this).removeClass('PortadaSeleccion')
                })
                .click(function (event) {
                    event.preventDefault();
                    if (validar_evaluacion() == true) {
                        window.location.replace(baseUrl + "Ayuda.aspx");
                    }
                });

            //Bienvenida();

            //if ($("#MostarBotonFormulario").val() == 1) {
            //    $("#tdBtnAutorizacion").show();
            //}
            //if ($("#MostrarFormAutorizacion").val() == 1) {
            //    LoadFormAutorizacion();
            //    $("#imgPortadaAut").hide();
            //} else {
            //HideFormAutoriz();
            //}
            ////NMM. RS27390 04.12.17
            //if ($("#MostrarBotonCopia").val() == 1) {
            //    $("#tdBtnInformeCopia").show();
            //}
            //$("#informeCopia").hide();
        });

    function Bienvenida() {
        //SPH - Diferencia si es la primera vez y muestra bienvenida , si entra nuevamente no se alertara
        //ya que solo se debe alertar cuando inicie por primera vez luego de una modificacion distinta a la primera vez
        if ($("#primeraVez").val() == 1) {
            $("#info-bienvenida").dialog("open");
        }
        else if ($("#primeraVezMod").val() == 1) {
            $("#info-mod").dialog("open");
        }

    }

    function MisDatos() {
        if (validar_evaluacion() == true) {
            primeraVez.value = 0;
            Verificar_Cambiosh(function () {
                window.location.replace(baseUrl + "DocentePrimeraVezP.aspx");
            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
        }
    }

    function CerrarSesion() {
        Verificar_Cambiosh(function () {
            top.document.location = '../Inicio.aspx?cerrar=1';
        }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
    }

    function DescargarArchivo(keypath, nombre_servidor, nombre_cliente) {
        var methodURL = 'Home.aspx/DescargarArchivo';
        var parameters = '{keypath: "' + keypath + '", nombre_servidor :"' + nombre_servidor + '"}';
        $("#Vidrio").show();
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
                        parameters = 'Path=' + keypath;
                        parameters += '&NombreCliente=' + nombre_cliente;
                        parameters += '&NombreServidor=' + nombre_servidor;
                        parameters += '&r=' + Math.random();
                        $.download('../FileDownload.aspx', parameters);
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
                    $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                    $("#alert-message").dialog("open");
                }
            },
            complete: function () {
                $("#Vidrio").hide();
            }
        });
    }

    //FUNCIÓN QUE VALIDA EL INGRESO A LAS TAREAS CON RESPECTO AL CAMPO ART_70 (BO_EVALUACION_DOCENTE)
    function Validacion_Articulo_70(Opcion) {
        if (validar_evaluacion() == true) {
            if ($("#Art_70").val() == 1) {
                $("#info-message").dialog("option", "title", "Información");
                $("#info-message-content").html("Estimado Docente, usted no tiene acceso a los módulos del Portafolio, pues según nuestros registros se acogió al artículo 70 ter de la ley 20.903.");
                $("#info-message").dialog("open");
            }
            else {
                switch (Opcion) {
                    case Opcion = "T1":
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichasP.aspx?ficha=T1");
                        break;
                    case Opcion = "T2":
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichasP.aspx?ficha=T2");
                        break;
                    case Opcion = "T3":
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichasP.aspx?ficha=T3");
                        break;
                    case Opcion = "T4":
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichasP.aspx?ficha=T4");
                        break;
                    case Opcion = "T5":
                        window.location.replace(baseUrl + "Aplicaciones/Ficha/fichasP.aspx?ficha=T5");
                        break;
                }
            }
        }

    }

    function Validar_fecha_ingreso(Opcion, FechaValidar) {
        var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/fnValidarIngreso';
        var parameters = '{_Ficha: "' + FechaValidar + '"}';
        $("#Vidrio").show();
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
                        $("#info-message-bold").dialog("option", "title", "Información");
                        $("#info-message-content-bold").html(Record["d"]["__error"]);
                        $("#info-message-bold").dialog("open");
                    } else {
                        switch (Opcion) {
                            case Opcion = "AE":
                                if (validar_evaluacion() == true) {
                                    window.location.replace(baseUrl + "Aplicaciones/Ficha/fichas.aspx?ficha=AE");
                                }
                                //else {
                                //    $("#alert-message").dialog("option", "title", "Error");
                                //    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                                //    $("#alert-message").dialog("open");
                                //}
                                break;
                            case Opcion = "T1":
                                Validacion_Articulo_70("T1");
                                break;
                            case Opcion = "T2":
                                Validacion_Articulo_70("T2");
                                break;
                            case Opcion = "T3":
                                Validacion_Articulo_70("T3");
                                break;
                            case Opcion = "T4":
                                Validacion_Articulo_70("T4");
                                break;
                            case Opcion = "T5":
                                Validacion_Articulo_70("T5");
                                break;
                        }
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
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo obtener datos desde el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
            },
            complete: function () {
                $("#Vidrio").hide();
            }
        });
        }

        //WT. RS25283. Formulario de Autorización 2017
        function habilitarBtnFormAutoriz() {
            $("#btnContinuar").attr('disabled', false);
            boInputChanged = true;
        }
        function ShowFormAutoriz() {
            $("#encabezado").hide();
            $("#FormAutorizacion").show();
            if ($("#uso_datos").val() == 1) {
                $("#rdAutorizo").prop("checked", true);
                habilitarBtnFormAutoriz();
            } else if ($("#uso_datos").val() == 2) {
                $("#rdNoAutorizo").prop("checked", true);
                habilitarBtnFormAutoriz();
            } else {
                $("#rdAutorizo").prop("checked", false);
                $("#rdNoAutorizo").prop("checked", false);
            }
        }
        function HideFormAutoriz() {
            $("#encabezado").show();
            $("#FormAutorizacion").hide();
            if ($("#MostrarAlertaCierrePortafolio").val() == 1) {
                $("#info-cierrePortafolio").dialog("open");
                $("#MostrarAlertaCierrePortafolio").val(0);
            }
        }
        function SaveAutorizacion() {

            var value = $('input[name=rdAutorizar]:checked').val();
            methodURL = baseUrl + "Portada/Home.aspx/SaveDataFormAutorizacion";
            var arForm = '{ autoriza:' + value + '}';
            $("#Vidrio").show();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                data: arForm,
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
                            $("#MostrarFormAutorizacion").val(0);
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
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo guardar datos en el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
                },
                complete: function () {
                    $("#Vidrio").hide();
                }
            });
        }
        function LoadFormAutorizacion() {
            methodURL = baseUrl + "Portada/Home.aspx/showFormAutorizacion";
            var arForm = '{}';
            $("#Vidrio").show();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                data: arForm,
                dataType: "json",
                async: false,
                success: function (response) {
                    try {
                        var Record = jQuery.parseJSON(response.d);
                        if (Record["d"]["__error"] != "") {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                            $("#alert-message").dialog("open");
                            HideFormAutoriz();
                        } else {
                            $('#uso_datos').val(Record["d"]["__Marca"]);
                            $('#lblformAutor_Fecha').html(Record["d"]["__Fecha"]);
                            $('#lblformAutor_Mes').html(Record["d"]["__Mes"]);
                            $('#lblformAutor_Nombre').html(Record["d"]["__Nombre"]);
                            $('#lblformAutor_Rut').html(Record["d"]["__Rut"]);
                            if ($("#MostrarFormAutorizacion").val() == 1) {
                                $("#btnContinuar").attr('disabled', true);
                            } else {
                                $("#btnContinuar").attr('disabled', false);
                            }
                            ShowFormAutoriz();
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
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo guardar datos en el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
                },
                complete: function () {
                    $("#Vidrio").hide();
                }
            });
        }

        function mostrar_autoevaluacion() {
            var methodURL = baseUrl + "Portada/Home.aspx/BtnAutoevaluacion";
            $.ajax(
                {
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: methodURL,
                    //data: parameters,
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        try {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != "") {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            }
                            else {
                                if (Record["d"]["__body"] == "") {
                                    $("#alert-message").dialog("option", "title", "Información");
                                    $("#alert-message-content").html("No hay información para ver.");
                                    $("#alert-message").dialog("open");

                                }
                                else {
                                    $('#divdependencia').empty();
                                    $('#divdependencia').html(Record["d"]["__body"]);

                                }
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
                            $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo marcar fila seleccionada en el servidor: " + msg);
                            $("#alert-message").dialog("open");
                        }
                    }
                });
            }

            //NMM. RS27390 06.12.17
            function LoadInformeCopia() {
                $("#informeCopia").dialog("open");
                methodURL = baseUrl + "Portada/Home.aspx/showInformeCopia";
                $(document).ready(function () {
                    oTable = $('#table_results').dataTable({
                        'bJQueryUI': true,
                        'sDom': '<"toolbar ui-widget-header ui-corner-tl ui-corner-tr ui-helper-clearfix">t',
                        'bDestroy': true,
                        'bRetrieve': false,
                        'bAutoWidth': false,
                        'bProcessing': false,
                        'bServerSide': true,
                        "bPaginate": false,
                        "bInfo": false,
                        //"sScrollX": "500px",
                        "bSort": false,
                        "iDisplayLength": iDisplayLength,
                        "bLengthChange": false,
                        "sPaginationType": "two_button",
                        'sAjaxSource': methodURL,
                        "oLanguage": {
                            "sZeroRecords": "No hay datos que mostrar",
                            "sInfo": "Registros _START_ al _END_ de _TOTAL_",
                            "sInfoEmpty": "Registros 0 a 0 de 0",
                            "sInfoFiltered": "(encontrados en _MAX_ registros totales)",
                            "sSearch": "Buscar",
                            "sProcessing": "Procesando...",
                            "sInfoThousands": ".",
                            "oPaginate": {
                                "sPrevious": "Anterior",
                                "sNext": "Siguiente"
                            }
                        },
                        //"aoColumns": columns,

                        //"aaSorting": [[0, "asc"]],
                        //"sScrollX": "100%",
                        "sScrollY": "250px",
                        //"sScrollX": true,
                        //"bScrollCollapse": true,
                        //"paging": false,
                        //"fnInitComplete": function () {
                        //    //new FixedColumns(oTable, {
                        //    //    "iLeftColumns": 7
                        //    //    //"iLeftColumns": 1,
                        //    //    //"iReftColumns": 1
                        //    //});
                        //},
                        "fnServerData": function (sSource, aoData, fnCallback) {
                            aoData.push({ "name": "stRefrescarBoset", "value": $("#stRefrescarBoset").val() });
                            aoData.push({ "name": "LISTA_CAMPOS_SELECT", "value": $("#LISTA_CAMPOS_SELECT").val() });
                            aoData.push({ "name": "LISTA_CAMPOS_FORMATOS", "value": $("#LISTA_CAMPOS_FORMATOS").val() });
                            aoData.push({ "name": "LISTA_CAMPOS_LARGOS", "value": $("#LISTA_CAMPOS_LARGOS").val() });
                            aoData.push({ "name": "LISTA_CAMPOS_ALINEACION", "value": $("#LISTA_CAMPOS_ALINEACION").val() });
                            aoData.push({ "name": "iLinkColum", "value": $("#iLinkColum").val() });
                            aoData.push({ "name": "bOnlySelectedIds", "value": $("#chkOnlySelectedIds").is(':checked') });
                            aoData.push({ "name": "stPreFilter", "value": $("#stPreFilter").val() });
                            $("#Vidrio").show();
                            $.ajax({
                                "dataType": "json",
                                "contentType": "application/json; charset=utf-8",
                                "type": "POST",
                                "url": sSource,
                                "data": JSON.stringify({ gridParams: aoData }),
                                "async": true,
                                //"timeout": 20000,
                                "success": function (responseJson) {
                                    var response = JSON.parse(responseJson["d"]);
                                    try {
                                        if (response["d"]["__error"] != "") {
                                            $("#alert-message").dialog("option", "title", "Error");
                                            $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo cargar datos desde el servidor para la grilla: " + response["d"]["__error"]);
                                            $("#alert-message").dialog("open");
                                        } else {
                                            if (response["iTotalRecords"] > 0) {
                                                if ($("#iCurrentRow").val() == 0) {
                                                    $("#iCurrentRow").val(1);
                                                }
                                            } else {
                                                $("#iCurrentRow").val(0);
                                                $("#btnDescargaPDF").attr('disabled', true);
                                            }
                                            fnCallback(response);
                                            //$("#informeCopia").dialog("open");
                                        }
                                    }
                                    catch (e) {
                                        $("#alert-message").dialog("option", "title", "Error");
                                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo parsear datos Json desde el servidor para grilla: " + e.toString());
                                        $("#alert-message").dialog("open");
                                    }
                                },
                                "error": function (xhr, status, msg) {
                                    if (xhr.status == 419) {
                                        window.location.href = '<%= ResolveUrl("~/") %>' + msg;
                                    } else {
                                        if (status === 'timeout') {
                                            msg = 'Tiempo agotado. Se ha perdido la conexión con el servidor.'
                                        }
                                        $("#alert-message").dialog("option", "title", "Error");
                                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo cargar grilla de resultados desde el servidor: " + msg);
                                        $("#alert-message").dialog("open");
                                    }
                                },
                                "complete": function () {
                                    $("#Vidrio").hide();
                                    if (($("#stMode").val() == "U") && ($("#stPreFilter").val() != "")) {
                                        fnSelectRowLink(1, true);
                                    }
                                    $("#stMode").val("N")
                                }
                            });
                        }
                    });
                    $('#table_results').unbind('sort')
                    $('#table_results').unbind('filter')
                    $('#table_results').unbind('page')
                    $('#table_results').unbind('draw')
                    $('#table_results tbody').unbind('click')
                    $('#table_results').bind('sort', function () {
                        $("#stRefrescarBoset").val("S");
                        $("#iCurrentRow").val(1);
                    })
                    $('#table_results').bind('filter', function () {
                        $("#stRefrescarBoset").val("S");
                        $("#iCurrentRow").val(1);
                    })
                    $('#table_results').bind('page', function () {
                        $("#iCurrentRow").val(1);
                    })
                    $('#table_results').bind('draw', function () {
                        $("#stRefrescarBoset").val("N");
                    })
                    oTable.fnSetFilteringDelay();
                });
            }

            function descarga_informe_copia_pdf() {
                if (validar_evaluacion() == true) {
                    var methodURL = 'Home.aspx/descargaPDFCOPIA';
                    $("#Vidrio").show();
                    $("body").css("cursor", "progress");
                    $.ajax(
                        {
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: methodURL,
                            dataType: "json",
                            async: true,
                            success: function (response) {
                                var Record = jQuery.parseJSON(response.d);
                                if (Record["d"]["__error"] != "") {
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                    $("#alert-message").dialog("open");
                                }
                                else {
                                    parameters = 'Path=pathDescargarPDFCOPIA';
                                    parameters += '&NombreCliente=' + Record["d"]["__NombreServidor"];
                                    parameters += '&NombreServidor=' + Record["d"]["__NombreServidor"];
                                    parameters += '&r=' + Math.random();
                                    $.download('../FileDownload.aspx', parameters);
                                }
                            },
                            error: function (xhr, err) {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Hubo un error al momento de guardar el archivo.");
                                $("#alert-message").dialog("open");
                            },
                            complete: function () {
                                $("#Vidrio").hide();
                                $("body").css("cursor", "default");
                            }
                        });
                }
                else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                    $("#alert-message").dialog("open");
                }
            }

            function mostrar_copia(idEva, numTarea, nomTarea1, nomTarea2, periodo) {
                if (validar_evaluacion() == true) {
                    var methodURL = baseUrl + "Portada/Home.aspx/InformeCopia";
                    var campo1;
                    var campo2;
                    var parameters = '{idEva: "' + idEva + '",Tarea:"' + numTarea + '",NomTarea1:"' + nomTarea1 + '",NomTarea2:"' + nomTarea2 + '",Periodo:"' + periodo + '"}';
                    $.ajax(
                        {
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
                                    }
                                    else {
                                        if (Record["d"]["__body"] == "") {
                                            $("#alert-message").dialog("option", "title", "Información");
                                            $("#alert-message-content").html("No hay información para ver.");
                                            $("#alert-message").dialog("open");
                                        }
                                        else {
                                            $('#body_copia').empty();
                                            $("#body_copia").html(Record["d"]["__body"]);
                                            //SPALMA DICIEMBRE 2017 - RS27390
                                            $('#C1_1').val(Record["d"]["__T" + numTarea + "C1_1"]);
                                            $('#C2_1').val(Record["d"]["__T" + numTarea + "C2_1"]);
                                            $('#C1_2').val(Record["d"]["__T" + numTarea + "C1_2"]);
                                            $('#C2_2').val(Record["d"]["__T" + numTarea + "C2_2"]);
                                            $('#dialog_copia').dialog("open");
                                            $('#dialog_copia').animate({ scrollTop: 0 }, 0);
                                            launch(1, $('#C1_1').val(), $('#C2_1').val(), $('#C1_2').val(), $('#C2_2').val(), nomTarea1, nomTarea2);
                                        }
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
                                $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo marcar fila seleccionada en el servidor: " + msg);
                                $("#alert-message").dialog("open");
                            }
                            }
                        });
                }
                else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                    $("#alert-message").dialog("open");
                }
            }

            function Portadah() {
                if (validar_evaluacion() == true) {
                    Verificar_Cambiosh(function () {
                        HideFormAutoriz();
                    }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })

                }
            }

            function validar_evaluacion() {
                var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/validar_evaluacion';
                var parameters = '{idEvaluacion: "' + $('#idEvaluacion').val() + '"}';
                var estado = false
                $.ajax({
                    cache: false
                        , async: false
                        , type: "POST"
                        , dataType: "json"
                        , contentType: "application/json; charset=utf-8"
                        , url: methodURL
                        , data: parameters
                        , success: function (response) {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__Estado"] == 'S') {
                                estado = true;
                            }
                            else {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
                                $("#alert-message").dialog("open");
                            }
                        }
                });
                return estado;
            }
            function Verificar_Cambiosh(success, cancel) {
                var value = $('input[name=rdAutorizar]:checked').val();
                if (boInputChanged == true && $('input[name=rdAutorizar]:checked').val() != $("#uso_datos").val()) {
                    $("#confirm-dialog").dialog("option", "title", "Advertencia");
                    $("#confirm-dialog-content").html("<center><b>Ha seleccionado una opción. </br> Vuelva y presione el botón Continuar para guardar.</b></center>");
                    $("#confirm-dialog").dialog("option", "buttons", {
                        "Volver": function () {
                            if (cancel)
                                cancel();
                            $(this).dialog("close");
                        },
                        "Abandonar": function () {
                            boInputChanged = false;
                            if (success)
                                success();
                            if ($("#uso_datos").val() == 1) {
                                $("#rdAutorizo").prop("checked", true);
                            } else if ($("#uso_datos").val() == 2) {
                                $("#rdNoAutorizo").prop("checked", true);
                            } else {
                                $("#rdAutorizo").prop("checked", false);
                                $("#rdNoAutorizo").prop("checked", false);
                            }
                            $(this).dialog("close");
                        },
                    });
                    $("#confirm-dialog").dialog("open");
                }
                else {
                    success();
                }
            }

            //Spalma 8-11-2017 Funcion que pinta las igualdades entre 2 docentes
            // RS27390
            function launch(op, C1_1, C2_1, C1_2, C2_2, TAREA1, TAREA2) {

                var t1 = C1_1;
                var t2 = C1_2;
                var t3 = C2_1;
                var t4 = C2_2;
                t1 = t1.toLowerCase();
                t2 = t2.toLowerCase();
                t3 = t3.toLowerCase();
                t4 = t4.toLowerCase();
                var text1 = t1
                var text2 = t2
                var text3 = t3
                var text4 = t4

                dmp.Diff_Timeout = parseFloat($("#timeout").val());
                dmp.Diff_EditCost = parseFloat($("#editcost").val());

                var ms_start = (new Date()).getTime();
                var d = dmp.diff_main(text1, text3);
                var e = dmp.diff_main(text2, text4);
                var ms_end = (new Date()).getTime();

                if ($("#semantic").checked) {
                    dmp.diff_cleanupSemantic(d);
                }
                if ($("#efficiency").checked) {
                    dmp.diff_cleanupEfficiency(d);
                }

                var ds1 = dmp.diff_prettyHtml(d, 1);
                var ds2 = dmp.diff_prettyHtml(e, 1);
                var ds3 = dmp.diff_prettyHtml(d, 2);
                var ds4 = dmp.diff_prettyHtml(e, 2);
                $('#' + TAREA1 + '1').html(ds1);
                $('#' + TAREA2 + '1').html(ds2);
                $('#' + TAREA1 + '2').html(ds3);
                $('#' + TAREA2 + '2').html(ds4);
                //$('#outputdiv').css('border', '1px solid #c4c4c4');
            }

            function mostrar_atencion() {
                var methodURL = baseUrl + "Portada/Home.aspx/msjeAtencion";
                $.ajax(
                    {
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: methodURL,
                        //data: parameters,
                        dataType: "json",
                        async: false,
                        success: function (response) {
                            try {
                                var Record = jQuery.parseJSON(response.d);
                                if (Record["d"]["__error"] != "") {
                                    $("#alert-message").dialog("option", "title", "Error");
                                    $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                    $("#alert-message").dialog("open");
                                }
                                else {
                                    if (Record["d"]["__body"] == "") {
                                        $("#alert-message").dialog("option", "title", "Información");
                                        $("#alert-message-content").html("No hay información para ver.");
                                        $("#alert-message").dialog("open");
                                    }
                                    else {
                                        $('#info-mod').empty();
                                        $("#info-mod").html(Record["d"]["__body"]);
                                    }
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
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo marcar fila seleccionada en el servidor: " + msg);
                        $("#alert-message").dialog("open");
                    }
                        }
                    });
        }

        function mostrar_alerta() {
            var methodURL = baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/CheckSession";
            $.ajax(
                {
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: methodURL,
                    //data: parameters,
                    dataType: "json",
                    async: false,
                    success: function (response) {
                        try {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != "") {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html("Error: " + Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            }
                            else {
                                $('#contenidoalerta').val(Record["d"]["__contenido"]);
                                if ($("#contenidoalerta").val() != "") {
                                    $("#Alerta_BO").html($('#contenidoalerta').val());
                                    $("#alerta").dialog("open");
                                }
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
                            $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo marcar fila seleccionada en el servidor: " + msg);
                            $("#alert-message").dialog("open");
                        }
                    }
                });
            }

    </script>
</head>
<body onload="fnCommon_nobackbutton();">
    <form id="form1" runat="server">
        <div id="encabezado">
            <table align="center" cellpadding="0" cellspacing="0" style="background: url('../Imagenes/ImagesP/Encabezado_fondo.png') repeat-x" border="0">
                <tr>
                    <td style="height: 280px;" valign="top">
                        <table cellpadding="0" cellspacing="0" style="padding-top: 0.1em;" border="0">
                            <tr>
                                <td style="width: 125px;"></td>
                                <td align="right" style="width: 100px;"></td>
                                <td style="width: 63px;"></td>
                                <td align="center" style="width: 672px;">
                                    <img src="../Imagenes/ImagesP/encabezado.png" alt="" class="blockArrastre" />
                                </td>
                                <td style="width: 163px;"></td>
                                <td style="width: 125px;"></td>
                            </tr>
                            <tr>
                                <td colspan="3"></td>
                                <td>
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <label id="label_bienvenido" class="pdBienvenida" runat="server"></label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label id="label_evidencia" class="pdEvidencia" runat="server"></label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td colspan="2">
                                    <table align="center">
                                        <tr>
                                            <td>
                                                <img alt="cerrar" src="../Imagenes/ImagesP/datos_OFF.png" onmouseover="this.src='../Imagenes/ImagesP/datos_ON.png'"
                                                    onmouseout="this.src='../Imagenes/ImagesP/datos_OFF.png'" onclick="MisDatos()" class="blockArrastre" /></td>
                                            <td>
                                                <img alt="cerrar" src="../Imagenes/ImagesP/cerrar_sesion_OFF.png" onmouseover="this.src='../Imagenes/ImagesP/cerrar_sesion_ON.png'"
                                                    onmouseout="this.src='../Imagenes/ImagesP/cerrar_sesion_OFF.png'" onclick="CerrarSesion()" class="blockArrastre" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 100px;" colspan="6">
                                    <table align="center" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <table id="autoevaluacion" align="center" cellpadding="0" cellspacing="0" border="0" style="display: none">
                                                    <tr>
                                                        <td style="width: 8px; height: 120px; background: url('../Imagenes/ImagesP/botonera_izq_ae.png') no-repeat"></td>
                                                        <td valign="top" style="width: 100px; background: #f6f6f6">
                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                    <td style="height: 92px;">
                                                                        <table>
                                                                            <tr>
                                                                                <td class="pdTitulo2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <button id="AE" runat="server" style="width: 9em; height: 2.5em;">
                                                                                        Autoevaluación</button></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>

                                                        <td style="width: 8px; background: url('../Imagenes/ImagesP/botonera_der_ae.png') no-repeat"></td>
                                                        <td style="width: 30px;"></td>
                                                    </tr>
                                                </table>
                                            </td>

                                            <td style="width: 8px; background: url('../Imagenes/ImagesP/botonera_izq_pf.png') no-repeat"></td>
                                            <td valign="top" style="background: url('../Imagenes/ImagesP/botonera_cen2_pf.png') repeat-x">
                                                <table align="center" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td style="height: 92px; background: #b9d7ea">
                                                            <table border="0">
                                                                <tr>
                                                                    <td align="center" class="pdTitulo2" colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <button id="T1" class="botonEE" runat="server" style="width: 8em; height: 2.5em;">
                                                                            Planificación</button></td>
                                                                    <td>
                                                                        <button id="T2" class="botonEE" runat="server" style="width: 8em; height: 2.5em;">
                                                                            Evaluación
                                                                        </button>
                                                                    </td>
                                                                    <td>
                                                                        <button id="T3" class="botonEE" runat="server" style="width: 8em; height: 2.5em;">
                                                                            Reflexión</button></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width: 39px; background: url('../Imagenes/ImagesP/botonera_cen_pf.png') no-repeat"></td>
                                                        <td style="background: #b9d7ea">
                                                            <table border="0">
                                                                <tr>
                                                                    <td align="center" class="pdTitulo2">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <button id="T4" class="botonCG" runat="server" style="width: 8em; height: 2.5em;">
                                                                            Clase Grabada</button></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td style="width: 39px; background: url('../Imagenes/ImagesP/botonera_cen_pf.png') no-repeat"></td>
                                                        <td style="background: #b9d7ea">
                                                            <table border="0">
                                                                <tr>
                                                                    <td align="center" class="pdTitulo2">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <button id="T5" class="botonEE" runat="server" style="width: 10.5em; height: 2.5em;">
                                                                            Módulo 3</button></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" class="pdTitulo2" colspan="5" style="height: 28px;"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td style="width: 10px; background: url('../Imagenes/ImagesP/botonera_der_pf.png') no-repeat"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table align="center" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="width: 500px;">
                                                <table align="center" cellpadding="2" cellspacing="2" border="0">
                                                    <tr>
                                                        <td class="estiloBanner">
                                                            <table align="center" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <div class="TextoBanner" id="banner6" runat="server"></div>

                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td style="width: 200px;">
                                                <table align="center" cellpadding="2" cellspacing="2" border="0">
                                                    <tr>
                                                        <td>
                                                            <button id="btn_manual_pf" class="btn_pf" runat="server" style="width: 12em; height: 5em;" onclick="ga('send', 'event',  'ManualPF', 'click', 'ManualPortafolio');">
                                                                INSTRUCCIONES</button></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <button id="btn_obj_curr" class="btn_pf" runat="server" style="width: 12em; height: 5em;">
                                                                OBJETIVOS</button></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td style="width: 500px;">
                                                <table align="center" cellpadding="2" cellspacing="2" border="0">
                                                    <tr>
                                                        <td class="estiloBanner">
                                                            <table align="center">
                                                                <tr>
                                                                    <td>
                                                                        <div class="TextoBanner" id="banner2" runat="server">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="estiloBanner">
                                                            <table align="center" border="0">
                                                                <tr>
                                                                    <td>
                                                                        <div class="TextoBanner" id="banner3" runat="server">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>

        <div id="informeCopia">
            <div>
                <table cellspacing="0" cellpadding="2" width="100%" border="0">
                    <tr>
                        <td style="text-align: center" class="pdTitulo1">INFORME COMPARATIVO DE EVIDENCIAS
                        </td>
                    </tr>
                </table>
                <div>
                    <p style="text-align: justify;" class="pdTituloHome">
                        Estimado/a Docente,
                    </p>
                    <p style="text-align: justify;" class="pdTituloHome">
                        Este reporte muestra los/as docentes con los cuales se detectó copia en su Portafolio para 
                        cada tarea. Se destacará con color amarillo las respuestas identificadas como idénticas.
                    </p>
                    <p style="text-align: justify;" class="pdTituloHome">
                        <u>IMPORTANTE:</u> Le recordamos que los datos que se han puesto a su disposición corresponden a información
                        personal de los/as involucrados/as, en los términos previstos en las leyes Nº 19.628 y Nº 20.285, y en el
                        artículo 3º del decreto supremo Nº 192 de 2004, del Ministerio de Educación, en virtud de lo cual se le 
                        solicita discreción y reserva en el uso de ésta.<br />
                        Le hacemos presente que el incumplimiento de los deberes que la ley impone a este respecto, 
                        origina las responsabilidades administrativas, civiles y criminales que correspondan.
                    </p>
                </div>
                <table cellspacing="0" cellpadding="2" width="100%" border="0">
                    <tr>
                        <td align="right">
                            <input runat="server" type="button" id="btnDescargaPDF" name="btnDescargaPDF" value="Descargar en PDF" role="button" />
                        </td>
                    </tr>
                </table>
                <fieldset class="ui-widget ui-widget-content">
                    <table id="table_results" style="font-size: 85%;">
                        <thead>
                            <tr>
                                <th style="width: 250px;">Docente</th>
                                <th>Período</th>
                                <th>Planificación</th>
                                <th>Evaluación</th>
                                <th>Reflexión</th>
                                <th>Clase Grabada</th>
                                <th>Módulo 3</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="7" class="dataTables_empty">Cargando datos desde el servidor...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </fieldset>
            </div>
        </div>
        <div id="dialog_copia" title="Informe comparativo de evidencias" style="overflow: scroll">
            <table cellspacing="0" cellpadding="2" width="100%" style="font-family: Segoe UI; font-size: 13px" border="0" id="tablaImprimir">
                <tr>
                    <td id="body_copia"></td>
                </tr>
            </table>
        </div>
        <div id="alert-message" class="ui-state-error">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="alert-message-content">
            </p>
        </div>
        <div id="confirm-dialog" class="ui-state-highlight">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="confirm-dialog-content"></p>
        </div>
        <div id="info-message" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content"></p>
        </div>

        <div id="info-message-bold" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content-bold" style="font-family: 'Segoe UI'; font-weight: bold; color: black;"></p>
        </div>

        <div id="info-bienvenida" style="background: #7BD7B0;" title="¡Bienvenida/o a la Plataforma Docentemás!">
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <%--nueva version bienvenida2018!--%>
                <tr>
                    <td align="center">
                        <img alt="" src="../Imagenes/ImagesP/Bienvenida 2018.png" style="align-self: center; width: 100%" id="bienvenida" /></td>
                </tr>
            </table>
        </div>
        <div id="info-cierrePortafolio" style="background-color: rgb(230, 185, 184);">
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center" class="pdTituloBv">Estimado/a docente, el período de elaboración de Portafolio ha finalizado</td>
                </tr>
                <tr>
                    <td class="pdTextoBv">
                        <p style="text-align: justify">Usted puede descargar y guardar un respaldo de su Portafolio desde “Mi Avance en Portafolio” opción “Descargar mi avance PDF”.</p>
                    </td>
                </tr>
            </table>
        </div>
        <div id="info-mod" style="background: #a7eeb8;">
            <%--<table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center" class="pdTituloBv">¡Atención!</td>
                </tr>
                <tr>
                    <td>
                        <p style="text-align: center"><b>De acuerdo a nuestros registros el Coordinador Comunal modificó el Nivel y/o Asignatura y/o RBD en el que se evaluará.</b></p>
                        <p style="text-align: center"><b>Por favor verifique sus datos y tenga en cuenta que si su nivel fue modificado, la información de sus formularios puede haber cambiado.</b></p>
                    </td>
                </tr>
            </table>--%>
        </div>
        <div id="alerta" class=" ui-state-highlight ">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center">
                        <div id="Alerta_BO" runat="server">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <div id="dialog-info-obj" style="background-color: white;">
        <img alt="" id="obj_curr" src="" />
    </div>
    <input type="hidden" id="LISTA_CAMPOS_SELECT" name="LISTA_CAMPOS_SELECT" runat="server"
        value="DOCENTE,PERIODO,T1,T2,T3,T4,T5" />
    <%--
Sobre formatos de string, referencia en: http://msdn.microsoft.com/es-es/library/fht0f5be(v=vs.80).aspx
    --%>
    <input type="hidden" id="LISTA_CAMPOS_FORMATOS" name="LISTA_CAMPOS_FORMATOS" runat="server"
        value=",,,,,," />
    <input type="hidden" id="LISTA_CAMPOS_LARGOS" name="LISTA_CAMPOS_LARGOS" runat="server"
        value=",,,,,," />
    <input type="hidden" id="LISTA_CAMPOS_ALINEACION" name="LISTA_CAMPOS_ALINEACION"
        runat="server" value=",center,center,center,center,center,center" />
    <input type="hidden" id="iCurrentRow" runat="server" value="0" />
    <input type="hidden" id="iLinkColum" runat="server" value="1" />
    <input type="hidden" id="stRefrescarBoset" runat="server" value="S" />
    <input type="hidden" id="stPreFilter" runat="server" value="" />
    <input type="hidden" id="stMode" runat="server" value="N" />
    <input type="hidden" id="iTimeOut" runat="server" />
    <input type="hidden" id="stServerPageLoadError" runat="server" value="" />
    <input type="hidden" id="stReturnURL" runat="server" value="" />
    <input type="hidden" id="onDialog" runat="server" value="" />
    <input type="hidden" id="primeraVez" name="primeraVez" runat="server" />
    <input type="hidden" id="primeraVezMod" name="primeraVezMod" runat="server" /><%-- SPH - Value almacenado para saber si levanto la alerta de modificacion de registro del docente --%>
    <input type="hidden" id="manual_PF_Cli" name="manual_PF_Cli" runat="server" />
    <input type="hidden" id="manual_PF_Serv" name="manual_PF_Serv" runat="server" />
    <input type="hidden" id="manual_AE_Cli" name="manual_AE_Cli" runat="server" />
    <input type="hidden" id="manual_AE_Serv" name="manual_AE_Serv" runat="server" />
    <input type="hidden" id="Obj_curr_Cli" name="Obj_curr_Cli" runat="server" />
    <input type="hidden" id="Obj_curr_Serv" name="Obj_curr_Serv" runat="server" />
    <input type="hidden" id="nivel" name="nivel" runat="server" />
    <input type="hidden" id="C1_1" name="C1_1" runat="server" />
    <input type="hidden" id="C1_2" name="C1_2" runat="server" />
    <input type="hidden" id="C2_1" name="C2_1" runat="server" />
    <input type="hidden" id="C2_2" name="C2_2" runat="server" />
    <input type="hidden" id="Art_70" name="Art_70" runat="server" />
    <input type="hidden" id="idEvaluacion" runat="server" />
    <input type="hidden" id="uso_datos" name="uso_datos" runat="server" />
    <input type="hidden" id="dependencia" name="dependencia" runat="server" />
    <input type="hidden" id="mostrarInfoCierrePF" name="mostrarInfoCierrePF" runat="server" />
    <input type="hidden" id="MostrarAlertaCierrePortafolio" name="MostrarAlertaCierrePortafolio" runat="server" />
    <input type="hidden" id="MostrarFormAutorizacion" name="MostrarFormAutorizacion" runat="server" />
    <input type="hidden" id="MostarBotonFormulario" name="MostarBotonFormulario" runat="server" />
    <input type="hidden" id="MostrarBotonCopia" name="MostrarBotonCopia" runat="server" />
    <input type="hidden" id="MostrarBotonCopiaPSAD" name="MostrarBotonCopiaPSAD" runat="server" />
    <%-- alerta0--%>
    <input type="hidden" id="contenidoalerta" runat="server" />
    <input type="hidden" id="modo" name="modo" runat="server" />
</body>
</html>
