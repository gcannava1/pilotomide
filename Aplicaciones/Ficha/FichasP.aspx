<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FichasP.aspx.vb" Inherits="PlataformaDocente.FichasP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <link rel="SHORTCUT ICON" href="~/Imagenes/favicon.ico" type="image/x-icon" />
    <link rel="ICON" href="~/Imagenes/favicon.ico" type="image/ico" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title></title>
    <script src="../../Scripts/jQuery/jquery.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/jquery-ui.custom.min.js" type="text/javascript"></script>
    <link href="../../Scripts/jQuery/themes/00current/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="../../StyleFrameworkSolex.css?v=1" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>

    <script src="../../Scripts/jQuery/plugins/FileUpload/jquery.fileupload.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/FileUpload/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/FileDownload/jQuery.download.js" type="text/javascript"></script>

    <script src="../../Scripts/jQuery/plugins/maxlength/jquery.plugin.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/maxlength/jquery.maxlength.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/maxlength/jquery.maxlength-es.js" type="text/javascript"></script>

    <link href="../../Scripts/jQuery/plugins/maxlength/jquery.maxlength.css" rel="stylesheet" />
    <script src="../../Scripts/jQuery/plugins/printThis/printThis.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/print/jQuery.print.js" type="text/javascript"></script>
    <script src="../../Scripts/jQuery/plugins/jquery-idleTimeout.js?v=1" type="text/javascript"></script>

    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';
        var boInputChanged = false;
        var boDescargaDoc = false;


        $.fn.ready(function () {

            // AGS 06-05-2013. Inicializa timer de logout (en milisegundos), fin de tiempo de autentificación.
            $(document).idleTimeout({
                inactivity: $('#iTimeOut').val() - 180000, //Tiempo de inactividad es por tiempo de sesión restante menos 3 minutos
                noconfirm: 180000, // Aviso se muestra por 3min. (Mismo tiempo de showDisplayLimit)
                sessionAlive: 30000, // Cada 5 minutos va al servidor al método de KeepSessionAlive
                alive_url: baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/CheckSession",
                //killSession_url: baseUrl + "Framework/__serverCommon/webmethodsCommon.asmx/KillSession",
                redirect_url: "../../inicio.aspx?cerrar=1",
                logout_url: "",
                click_reset: true, // Al hacer click mouse se resetea el timer.
                key_reset: true, // Al presionar teclas se resetea el timer.
                scroll_reset: true, // Scroll se resetea el timer.
                dialogTitle: "Expiración de sesión",
                dialogText: "<div id='modal_pop'>Su sesi&oacute;n finalizar&aacute; en <div style='display:inline;' id='divCountdownDisplay'><span style='color:red'> 03 </span> minutos</div>.<br>Presione continuar si desea seguir trabajando en la Plataforma Docente.</div>",
                dialogButton: "Continuar",
                showDisplayLimit: true // Muestra contador con el tiempo restante antes que se cierre popup. (Si es False, en dialogText no incluir <div id='divCountdownDisplay'></div>).
            });

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

            $('#divApplication').height($(window).height() - 140)

            //Deshabilitar arrastre de imagenes
            $("#imgPortada").on('dragstart', function (e) { e.preventDefault(); });
            $("#imgLogo").on('dragstart', function (e) { e.preventDefault(); });
            $("#imgCerrar").on('dragstart', function (e) { e.preventDefault(); });

            $("#uploadCargando").hide();

            $("#dialog-info-desempeno").dialog({
                modal: true,
                autoOpen: false,
                position: 'center',
                width: 700,
                height: 600,
                buttons: {

                }
            });

            //Control de refresco de pagina
            window.addEventListener('beforeunload', function (event) {
                if (boInputChanged == true && boDescargaDoc == false) {
                    event.returnValue = "Hay cambios que no se han guardado. Presione Cancelar para volver y guardar los cambios.";
                };
                boDescargaDoc = false;
            });


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

            $("#alerta").dialog({
                modal: true,
                autoOpen: false,
                position: 'center',
                height: "auto",
                create: function () {
                    $(this).css("maxHeight", 400);
                },
                width: 450,
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
                width: 450,
                buttons: {
                    Ok: function () {
                        $(this).dialog("close");
                    }
                }
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
            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 450,
            });

            $("#lookup-dialog").dialog({
                modal: true,
                autoOpen: false
            });

            $("#uploadfile-dialog").dialog({
                modal: true,
                autoOpen: false
            });

            $("#action-dialog").dialog({
                modal: true,
                autoOpen: false,
                resizable: false
            });

            //Este se utiliza para subir archivos.
            $('#dialog-uploadDocumento').dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400,
                buttons: {
                    'Seleccionar archivo': function () {
                        $('#fileupload').trigger('click');
                        //$(this).dialog("close");
                    },
                    'Volver': function () {
                        $(this).dialog("close");
                    }
                }
            });

            $("#autoevaluacionf").hide();
            if ($("#dependencia").val() == "PS" || $("#dependencia").val() == "AD") {
                //$("#AE").hide()
                $("#autoevaluacionf").hide();

                $("#btn_manual_ae").hide();
                $("#btn_avance_ae").hide();
                //.button()
                //.text("")
                //.removeAttr("onclick")
                //.removeClass('PortadaSeleccion')
                //.attr("disabled", "disabled")
            } else {
                //mostrar_autoevaluacion();
                $("#autoevaluacionf").hide();
                $("#AE")
                    .button()
                    .removeClass('ui-button-text-only')
                    .addClass('PortadaAE')
                    .mouseover(function () {
                        $('#AE').addClass('PortadaSeleccion')
                    })
                    .mouseout(function () {
                        $('#AE').removeClass('PortadaSeleccion')
                        Marcar_Seleccionada($('#tipo_ficha').val())
                    })
                   .click(function (event) {
                       if ($("#tipo_ficha").val() == "AE") {
                           event.preventDefault();
                       }
                       else {
                           event.preventDefault();
                           Verificar_Cambios(function () {
                               Cambiar_Seleccionada($('#tipo_ficha').val(), "AE");
                               //fnGotoApp("Aplicaciones/Ficha/Autoevaluacion.aspx");
                               Validar_fecha_ingreso("AE", "AE");
                           }, function () {
                               /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */
                           });
                       }

                   });
            }

            $("#T1")
                .button()
                .click(function (event) {
                    if ($("#tipo_ficha").val() == "T1") {
                        event.preventDefault();
                    }
                    else {
                        event.preventDefault();
                        if ($("#modo").val() == 'PilotoEE') {

                            Verificar_Cambios(function () {
                                Cambiar_Seleccionada($('#tipo_ficha').val(), "T1");
                                Validacion_Articulo_70("T1")
                                //fnGotoApp("Aplicaciones/Ficha/Tarea1.aspx");
                            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ });
                        }
                    }
                });

            $("#T2")
                .button()
                .click(function (event) {
                    if ($("#tipo_ficha").val() == "T2") {
                        event.preventDefault();
                    }
                    else {
                        event.preventDefault();
                        if ($("#modo").val() == 'PilotoEE') {

                            Verificar_Cambios(function () {
                                Cambiar_Seleccionada($('#tipo_ficha').val(), "T2");
                                Validacion_Articulo_70("T2")
                                //fnGotoApp("Aplicaciones/Ficha/Tarea2.aspx");
                            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ });
                        }
                    }
                });


            $("#T3")
                .button()
                .click(function (event) {
                    if ($("#tipo_ficha").val() == "T3") {
                        event.preventDefault();
                    }
                    else {
                        event.preventDefault();
                        if ($("#modo").val() == 'PilotoEE') {

                            Verificar_Cambios(function () {
                                Cambiar_Seleccionada($('#tipo_ficha').val(), "T3");
                                Validacion_Articulo_70("T3")
                                //fnGotoApp("Aplicaciones/Ficha/Tarea3.aspx");
                            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
                        }
                    }
                });


            $("#T4")
                .button()
                .click(function (event) {
                    if ($("#tipo_ficha").val() == "T4") {
                        event.preventDefault();
                    }
                    else {
                        event.preventDefault();
                        if ($("#modo").val() == 'PilotoCG') {

                            Verificar_Cambios(function () {
                                Cambiar_Seleccionada($('#tipo_ficha').val(), "T4");
                                Validacion_Articulo_70("T4")
                                //fnGotoApp("Aplicaciones/Ficha/Tarea4.aspx");
                            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
                        }
                    }

                });

            $("#T5").button()
            .click(function (event) {
                if ($("#tipo_ficha").val() == "T5") {
                    event.preventDefault();
                }
                else {
                    event.preventDefault();
                    if ($("#modo").val() == 'PilotoEE') {

                        Verificar_Cambios(function () {
                            Cambiar_Seleccionada($('#tipo_ficha').val(), "T5");
                            Validacion_Articulo_70("T5")
                            //fnGotoApp("Aplicaciones/Ficha/Tarea5.aspx");
                        }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
                    }
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
                    Marcar_Seleccionada($('#tipo_ficha').val())
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
                    Marcar_Seleccionada($('#tipo_ficha').val())
                });

            if ($('#tipo_ficha').val() == "AE") {
                fnGotoApp("Aplicaciones/Ficha/Autoevaluacion.aspx")
            }
            if ($('#tipo_ficha').val() == "T1") {
                fnGotoApp("Aplicaciones/Ficha/Tarea1.aspx")
            }
            if ($('#tipo_ficha').val() == "T2") {
                fnGotoApp("Aplicaciones/Ficha/Tarea2.aspx")
            }
            if ($('#tipo_ficha').val() == "T3") {
                fnGotoApp("Aplicaciones/Ficha/Tarea3.aspx")
            }
            if ($('#tipo_ficha').val() == "T4") {
                fnGotoApp("Aplicaciones/Ficha/Tarea4.aspx")
            }
            if ($('#tipo_ficha').val() == "T5") {
                fnGotoApp("Aplicaciones/Ficha/Tarea5.aspx")
            }
            if ($('#tipo_ficha').val() == "AvancePortafolio") {
                fnGotoApp("Aplicaciones/Ficha/AvancePortafolio.aspx")
            }
            if ($('#tipo_ficha').val() == "AvanceAutoEvaluacion") {
                fnGotoApp("Aplicaciones/Ficha/AvanceAutoEvaluacion.aspx")
            }
            Marcar_Seleccionada($('#tipo_ficha').val());
        });


        function fnGotoApp(urlApp) {
            if (validar_evaluacion() == true) {
                $('#divApplication').empty();

                if (urlApp.indexOf("?") < 0) {
                    rnd = '?rnd='
                }
                else {
                    rnd = '&rnd='
                }

                $('#divApplication').load(baseUrl + urlApp + rnd + Math.random(), function (responseTxt, statusTxt, xhr) {
                    if (xhr.status == 419) {
                        window.location.href = baseUrl + statusTxt; // AGS 28-03-2013 Sesión expirada, redirección a página de inicio.
                    } else if (xhr.status != 200) {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo cargar acción desde el servidor: " + statusTxt + ": " + responseTxt);
                        $("#alert-message").dialog("open");
                    }
                });
            }
            //else {
            //    $("#alert-message").dialog("option", "title", "Error");
            //    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
            //    $("#alert-message").dialog("open");
            //}


        }
        //SPALMA 26-04-2016 Se agrega verificacion de existencia para liberar carga en SP de insercion.
        function Portada() {
            if (validar_evaluacion() == true) {
                Verificar_Cambios(function () {
                    window.location.replace(baseUrl + "portada/homeP.aspx");
                }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })

            }
            //else {
            //    $("#alert-message").dialog("option", "title", "Error");
            //    $("#alert-message-content").html("Error: Esta sesión expiró. Existe una sesión activa en otra pestaña.");
            //    $("#alert-message").dialog("open");
            //}
        }
        function MisDatos() {
            Verificar_Cambios(function () {
                window.location.replace(baseUrl + "DocentePrimeraVez.aspx");
            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
        }
        function CerrarSesion() {
            Verificar_Cambios(function () {
                top.document.location = '../../Inicio.aspx?cerrar=1';
            }, function () { /*TODO: AGREGAR CODIGO SI SE CANCELA Y SE DESEA EJECUTAR UN EVENTO */ })
        }

        function Marcar_Seleccionada(tipo_ficha) {
            $('#' + tipo_ficha).addClass('PortadaSeleccion');
        }
        function Cambiar_Seleccionada(tipo_ficha_ant, tipo_ficha_act) {
            $('#' + tipo_ficha_ant).removeClass('PortadaSeleccion');
            $("#tipo_ficha").val(tipo_ficha_act);
            Marcar_Seleccionada(tipo_ficha_act);
        }
        function Verificar_Cambios(success, cancel) {
            if (boInputChanged == true) {
                if (!jQuery("#confirm-dialog").dialog('isOpen')) {

                    $("#confirm-dialog").dialog("option", "title", "Advertencia");
                    $("#confirm-dialog-content").html("<center><b>Hay cambios que no se han guardado. </br>Presione Volver para guardar los cambios.</b></center>");
                    $("#confirm-dialog").dialog("option", "buttons", {
                        "Volver para guardar": function () {
                            if (cancel)
                                cancel();
                            $(this).dialog("close");
                        },
                        "Abandonar sin guardar": function () {
                            boInputChanged = false;
                            if (success)
                                success();
                            $(this).dialog("close");
                        },
                    });
                    $("#confirm-dialog").dialog("open");
                }
            }
            else {
                success();
            }
        }
        //Subir archivos al servidor.
        function upload_Documento(tipomaterial, success) {
            $('#fileupload').fileupload({
                options: { headers: { "cache-control": "no-cache" } },
                replaceFileInput: true,
                dataType: 'json',
                formData: [
                    { name: 'Mimetypes', value: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/msword,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel,image/jpeg,application/pdf' },
                    { name: 'NombreTabla', value: $('#rec_NOMBRE_TABLA').val() },
                    { name: 'IdTabla', value: $('#rec_ID_TABLA').val() },
                    { name: 'NombreCampo', value: $('#rec_NOMBRE_CAMPO').val() },
                    { name: 'TipoMaterial', value: tipomaterial },
                     { name: 'idEvaluacion', value: $('#rec_ID_EVALUACION').val() },
                    { name: 'idDocumento', value: $('#rec_ID_DOCUMENTO').val() },
                    { name: 'IdAplicacion', value: $('#Id_Aplicacion').val() },
                ],
                url: baseUrl + 'Aplicaciones/Ficha/uploadDocumento.ashx',
                add: function (e, data) {

                    var strError = "";

                    if (data.originalFiles[0].name.substring(0, data.originalFiles[0].name.lastIndexOf(".")).length > 70) {
                        strError = "El nombre del archivo es muy largo, cámbielo por un nombre más corto.";
                    }

                    if (data.originalFiles[0]['size'] > 7340032) {
                        strError = "El archivo que intenta subir excede el tamaño máximo permitido de 7 MB.";
                    }
                    if (strError != "") {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html(strError);
                        $("#alert-message").dialog("open");
                    } else {
                        $(".ui-dialog-buttonpane button:contains('Seleccionar archivo')").attr("disabled", true);
                        $(".ui-dialog-buttonpane button:contains('Volver')").attr("disabled", true);

                        $("#uploadTitulo").hide();
                        $("#uploadCargando").show();

                        data.submit();
                    }
                },
                done: function (e, data) {

                    $(".ui-dialog-buttonpane button:contains('Seleccionar archivo')").attr("disabled", false);
                    $(".ui-dialog-buttonpane button:contains('Volver')").attr("disabled", false);

                    $("#uploadCargando").hide();
                    $("#uploadTitulo").show();

                    $('#dialog-uploadDocumento').dialog("close");

                    if (data.result.d.__error != '') {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html(data.result.d.__error);
                        $("#alert-message").dialog("open");
                    } else {
                        $("#info-message").dialog("option", "title", "Información");
                        $("#info-message-content").html(data.result.d.__nombre);
                        $("#info-message").dialog("open");

                        success();
                    }
                },
                fail: function (xhr, status) {
                    if (status.errorThrown == "inicio.htm") {
                        window.location.href = '<%= ResolveUrl("~/") %>' + status.errorThrown;
                } else {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo guardar datos en el servidor: " + status.errorThrown);
                    $("#alert-message").dialog("open");
                }
                }
            });
    }
    //Metodo para reemplazar un documento.
    function cargar_documento(idDocumento, tipomaterial, success) {
        $('#rec_ID_DOCUMENTO').val(idDocumento);
        upload_Documento(tipomaterial, success);
        if (tipomaterial == "PAUA") {
            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la lista, escala o rúbrica.</span></p>");
            $("#dialog-uploadDocumento").dialog("option", "title", "subir lista, escala o rúbrica.");
        }
        else if (tipomaterial == "PAUB") {
            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la pauta de correccion.</span></p>");
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir pauta de corrección");
        }
        else if (tipomaterial == "RRA") {
            $("#uploadTitulo").html("<p><span>Seleccione el archivo recurso de aprendizaje.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir recurso de aprendizaje");
        }
        else if (tipomaterial == "GPE") {
            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la prueba o guía.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir prueba o guía");
        }
        else if (tipomaterial == "ADJ") {
            $("#uploadTitulo").html("<p><span>Seleccione el archivo.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir archivo");
        }
        $('#dialog-uploadDocumento').dialog('open');

    }

    //Metodo para descargar un documento segun su idDocumento.
    function descargar_documento(idDocumento) {
        var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/DescargaDocumento';
        var parameters = '{idDocumento: "' + idDocumento + '"}';

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
                    if (Record["d"]["__error"] != '') {
                        $("#alert-message").dialog("option", "title", "Error");
                        $("#alert-message-content").html(Record["d"]["__error"]);
                        $("#alert-message").dialog("open");
                    } else {
                        var cliente = Record["d"]["__cliente"];
                        cliente = cliente.replace(",", "_")
                        parameters = 'Tipo=0';
                        parameters += '&Ano=' + Record["d"]["__ano"];
                        parameters += '&Evaluacion=' + Record["d"]["__eval"];
                        parameters += '&NombreCliente=' + cliente;
                        parameters += '&NombreServidor=' + Record["d"]["__servidor"];
                        parameters += '&r=' + Math.random();
                        boDescargaDoc = true;
                        $.download(baseUrl + 'Aplicaciones/Ficha/BosetToFileDownload.aspx', parameters);
                    }
                }
                , error: function (xhr, err) {
                    $("#alert-message").dialog("option", "title", "Error");
                    $("#alert-message-content").html(err);
                    $("#alert-message").dialog("open");
                }
        });
    }
    //Metodo para Eliminar un documento segun su idDocumento.
    function eliminar_documento(idDocumento, idTabla, Tabla, idAplicacion, tipomaterial, success) {
        var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/EliminarDocumento';
        var parameters = '{idDocumento: "' + idDocumento + '",idTabla: "' + idTabla + '",Tabla: "' + Tabla + '",idApliccion: "' + idAplicacion + '"}';

        $('#dialog-confirm-uploadDocumento').css('display', 'block');
        if (tipomaterial == "PAUA") {
            $('#dialog-confirm-uploadDocumento-content').html("¿Está seguro que desea eliminar esta lista, escala o rúbrica?");
        }
        else if (tipomaterial == "PAUB") {
            $('#dialog-confirm-uploadDocumento-content').html("¿Está seguro que desea eliminar esta pauta de corrección?");
        }
        else if (tipomaterial == "RRA") {
            $('#dialog-confirm-uploadDocumento-content').html("¿Está seguro que desea eliminar este recurso de aprendizaje?");
        }
        else if (tipomaterial == "GPE") {
            $('#dialog-confirm-uploadDocumento-content').html("¿Está seguro que desea eliminar esta prueba o guía?");
        }
        else if (tipomaterial == "ADJ") {
            $('#dialog-confirm-uploadDocumento-content').html("¿Está seguro que desea eliminar este archivo adjunto?");
        }
        $('#dialog-confirm-uploadDocumento').dialog({
            modal: true,
            height: "auto",
            width: 400,
            buttons: {
                "Sí": function () {
                    $.ajax({
                        cache: false,
                        async: true,
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        url: methodURL,
                        data: parameters,
                        success: function (response) {
                            var Record = jQuery.parseJSON(response.d);
                            if (Record["d"]["__error"] != '') {
                                $("#alert-message").dialog("option", "title", "Error");
                                $("#alert-message-content").html(Record["d"]["__error"]);
                                $("#alert-message").dialog("open");
                            } else {
                                $("#info-message").dialog("option", "title", "Información");
                                $("#info-message-content").html(Record["d"]["__message"]);
                                $("#info-message").dialog("open");
                                success();
                            }
                        },
                        error: function (xhr, err) {
                            $("#alert-message").dialog("option", "title", "Error");
                            $("#alert-message-content").html(err);
                            $("#alert-message").dialog("open");
                        }
                    });
                    $(this).dialog("close");
                },
                "No": function () {
                    $(this).dialog("close");
                }
            }
        });
    }

    function MostrarDesempeno(ancho, alto) {
        if ($("#DesEsp").val() != "") {
            $("#DesempenoEsperado").attr("src", $("#DesEsp").val() + '?r=' + Math.random);

            //$("#dialog-info-desempeno").dialog("option", "title", "Desempeño Esperado.");
            $('#dialog-info-desempeno').dialog({
                position: 'center',
                height: alto,
                width: ancho
            });
            $("#dialog-info-desempeno").dialog("open");

        }
        else {
            $("#alert-message").dialog("option", "title", "Error");
            $("#alert-message-content").html("No se ha encontrado una imagen.");
            $("#alert-message").dialog("open");
        }
    }

    //FUNCIÓN QUE VALIDA EL INGRESO A LAS TAREAS CON RESPECTO AL CAMPO ART_70 (BO_EVALUACION_DOCENTE)
    function Validacion_Articulo_70(Opcion) {
        if ($("#Art_70").val() == 1) {
            $("#info-message").dialog("option", "title", "Información");
            $("#info-message-content").html("Estimado Docente, usted no tiene acceso a los módulos del Portafolio, pues según nuestros registros se acogió al artículo 70 ter de la ley 20.903.");
            $("#info-message").dialog("open");
        }
        else {
            switch (Opcion) {
                case Opcion = "T1":
                    Validar_fecha_ingreso("T1", "PF");
                    //fnGotoApp("Aplicaciones/Ficha/Tarea1.aspx");
                    break;
                case Opcion = "T2":
                    //fnGotoApp("Aplicaciones/Ficha/Tarea2.aspx");
                    Validar_fecha_ingreso("T2", "PF");
                    break;
                case Opcion = "T3":
                    //fnGotoApp("Aplicaciones/Ficha/Tarea3.aspx");
                    Validar_fecha_ingreso("T3", "PF");
                    break;
                case Opcion = "T4":
                    //fnGotoApp("Aplicaciones/Ficha/Tarea4.aspx");
                    Validar_fecha_ingreso("T4", "PF");
                    break;
                case Opcion = "T5":
                    //fnGotoApp("Aplicaciones/Ficha/Tarea5.aspx");
                    Validar_fecha_ingreso("T5", "PF");
                    break;
            }
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
                                fnGotoApp("Aplicaciones/Ficha/Autoevaluacion.aspx");
                                break;
                            case Opcion = "T1":
                                fnGotoApp("Aplicaciones/Ficha/Tarea1.aspx");
                                break;
                            case Opcion = "T2":
                                fnGotoApp("Aplicaciones/Ficha/Tarea2.aspx");
                                break;
                            case Opcion = "T3":
                                fnGotoApp("Aplicaciones/Ficha/Tarea3.aspx");
                                break;
                            case Opcion = "T4":
                                fnGotoApp("Aplicaciones/Ficha/Tarea4.aspx");
                                break;
                            case Opcion = "T5":
                                fnGotoApp("Aplicaciones/Ficha/Tarea5.aspx");
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
    </script>
</head>
<body style="background-color: rgb(232, 232, 232);" onload="fnCommon_nobackbutton();">
    <form id="form1" runat="server">
        <div id="encabezado">
            <table align="center" cellpadding="0" cellspacing="0" style="padding-top: 0.1em; background: #dce6f2" border="0">
                <tr>
                    <td style="height: 100px;" colspan="6">
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td style="width: 300px;">
                                    <table align="center">
                                        <tr>
                                            <td>
                                                <img id="imgPortada" alt="cerrar" src="../../Imagenes/ImagesP/btn_portada_OFF.png" onmouseover="this.src='../../Imagenes/ImagesP/btn_portada_ON.png'"
                                                    onmouseout="this.src='../../Imagenes/ImagesP/btn_portada_OFF.png'" onclick="Portada()" style="cursor: pointer" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 672px;">
                                    <table>
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
                                <td style="width: 300px;">
                                    <table align="center">
                                        <tr>
                                            <td>
                                                <img id="imgCerrar" alt="cerrar" src="../../Imagenes/ImagesP/cerrar_sesion_OFF.png" onmouseover="this.src='../../Imagenes/ImagesP/cerrar_sesion_ON.png'"
                                                    onmouseout="this.src='../../Imagenes/ImagesP/cerrar_sesion_OFF.png'" onclick="CerrarSesion()" style="cursor: pointer" /></td>
                                            <%-- top.document.location='../../Inicio.aspx?cerrar=1'--%>
                                        </tr>

                                    </table>
                                </td>

                            </tr>
                        </table>
                        <table align="center" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <table id="autoevaluacionf" align="center" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="height: 54px; width: 6px; background: url('../../Imagenes/ImagesP/botonera_izq_f.png') no-repeat"></td>
                                            <td style="width: 100px; background: #f6f6f6">
                                                <table border="0">
                                                    <tr>
                                                        <td>
                                                            <button id="AE" runat="server" style="width: 9em; height: 2em;">
                                                                Autoevaluación</button></td>
                                                    </tr>
                                                </table>

                                            </td>
                                            <td style="width: 6px; background: url('../../Imagenes/ImagesP/botonera_der_f.png') no-repeat"></td>
                                            <td style="width: 30px;"></td>
                                        </tr>
                                    </table>
                                </td>

                                <td style="width: 6px; background: url('../../Imagenes/ImagesP/botonera_izq_f.png') no-repeat"></td>
                                <td style="background: #f6f6f6">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td style="height: 54px; padding: 0px 1px 0px 1px">
                                                <button id="T1" class="botonEE" runat="server" style="width: 8em; height: 2em;">
                                                    Planificación</button></td>
                                            <td style="height: 54px; padding: 0px 1px 0px 1px">
                                                <button id="T2" class="botonEE" runat="server" style="width: 8em; height: 2em;">
                                                    Evaluación
                                                </button>
                                            </td>
                                            <td style="height: 54px; padding: 0px 1px 0px 1px">
                                                <button id="T3" class="botonEE" runat="server" style="width: 8em; height: 2em;">
                                                    Reflexión</button>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 36px; background: url('../../Imagenes/ImagesP/botonera_cen_pf_f.png') no-repeat"></td>
                                <td style="background: #f6f6f6">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <button id="T4" class="botonCG" runat="server" style="width: 8em; height: 2em;">
                                                    Clase Grabada</button></td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 36px; background: url('../../Imagenes/ImagesP/botonera_cen_pf_f.png') no-repeat"></td>
                                <td style="background: #f6f6f6">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <button id="T5" class="botonEE" runat="server" style="width: 10.5em; height: 2em;">
                                                    Módulo 3</button>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 6px; background: url('../../Imagenes/ImagesP/botonera_der_f.png') no-repeat"></td>
                            </tr>
                            <tr>
                                <td style="height: 3px;"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divApplication" style="width: 1280px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;" runat="server">
        </div>

        <div id="alert-message" class="ui-state-error">
            <span class="ui-icon ui-icon-alert" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="alert-message-content">
            </p>
        </div>

        <div id="info-message" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content"></p>
        </div>

        <div id="info-message-bold" class=" ui-state-highlight ">
            <span class="ui-icon ui-icon-info" style="margin: 0.9em 0.3em 0.2em 0.2em; float: left;"></span>
            <p id="info-message-content-bold" style="font-family: 'Segoe UI'; font-weight: bold; color: black;"></p>
        </div>

        <div id="confirm-dialog" class="ui-state-error" style="background: red; color: yellow; font-weight: bold;">
            <p id="confirm-dialog-content"></p>
        </div>

        <div id="lookup-dialog">
            <p id="lookup-dialog-content">
            </p>
        </div>

        <div id="uploadfile-dialog">
            <p id="uploadfile-dialog-content">
            </p>
        </div>

        <div id="action-dialog">
        </div>

        <div id="dialog-info-desempeno" style="background-color: white; overflow-x: hidden">
            <img alt="" id="DesempenoEsperado" width="100%" src="" />
        </div>

        <div id="dialog-uploadDocumento" class=" ui-state-highlight ">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center">
                        <div id="uploadTitulo">
                            <p>
                                <span>Seleccione el archivo del Recurso de Aprendizaje.</span>
                            </p>
                        </div>
                        <div id="uploadCargando">
                            <p>
                                <span>
                                    <img src='../../Imagenes/ajax-loader_small.gif' />Subiendo Archivo.</span>
                            </p>
                        </div>
                    </td>
                </tr>
            </table>
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

        <div id="dialog-confirm-uploadDocumento" class="ui-state-highlight" title="Advertencia" style="display: none;">
            <p id="dialog-confirm-uploadDocumento-content">
            </p>
        </div>

        <input type="file" id="fileupload" name="fileupload" style="width: 250px; float: left; display: none;" />
        <input type="hidden" id="dependencia" name="dependencia" runat="server" />
        <input type="hidden" id="tipo_ficha" runat="server" />
        <input type="hidden" id="Art_70" runat="server" />
        <input type="hidden" id="idEvaluacion" runat="server" />
        <input type="hidden" id="iTimeOut" runat="server" />
        <input type="hidden" id="fecha_alerta" runat="server" />
        <input type="hidden" id="contenidoalerta" runat="server" />
        <input type="hidden" id="modo" name="modo" runat="server" />
    </form>
</body>
</html>
