<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tarea2.aspx.vb" Inherits="PlataformaDocente.Tarea2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang ="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <title></title>
    <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';
        //Variables en memoria para cambios de opcion
        //Nombres cambian de la ultima version solo para textos largos

        var A_T2_P1 = "";
        var A_T2_P2 = "";
        //var A_T2_P3 = "";
        //var A_T2_P4 = "";
        var B_T2_P1 = "";
        //var B_T2_P2 = "";
        //var B_T2_P3 = "";
        var B_T2_P4 = "";
        var op = 1;

        $.fn.ready(function () {

            $('#divDetalle').height($(window).height() - 190);
            $('#divDetalleTP').height($(window).height() - 190);

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });
            $(".adjunto").on('dragstart', function (e) { e.preventDefault(); });

            $('#rec_T2_OBJ_EVALUACION').maxlength({ max: 1000, feedbackTarget: '#tf_T2_OBJ_EVALUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_ACTIVIDAD_EVALUACION').maxlength({ max: 3300, feedbackTarget: '#tf_T2_ACTIVIDAD_EVALUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_ANALISIS_RESULT').maxlength({ max: 3600, feedbackTarget: '#tf_T2_ANALISIS_RESULT', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_DESAF_ESTRATEG').maxlength({ max: 3600, feedbackTarget: '#tf_T2_DESAF_ESTRATEG', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_INSTRUCCION').maxlength({ max: 1000, feedbackTarget: '#tf_T2_INSTRUCCION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            // MaxLenght TP
            $('#rec_T2_TP_OBJ_EVALUACION').maxlength({ max: 1000, feedbackTarget: '#tf_T2_TP_OBJ_EVALUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_ACTIVIDAD_EVALUACION').maxlength({ max: 3300, feedbackTarget: '#tf_T2_TP_ACTIVIDAD_EVALUACION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_ANALISIS_RESULT').maxlength({ max: 3600, feedbackTarget: '#tf_T2_TP_ANALISIS_RESULT', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_DESAF_ESTRATEG').maxlength({ max: 3600, feedbackTarget: '#tf_T2_TP_DESAF_ESTRATEG', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_INSTRUCCION').maxlength({ max: 1000, feedbackTarget: '#tf_T2_TP_INSTRUCCION', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });

            //si es TP mostramos formulario de TP, sino mostramos formulario no TP.
            if ($("#Cod_Nivel").val() == "EMTP") {
                $("#divDetalleTP").show();
                $("#divDetalle").hide();
            } else {
                $("#divDetalleTP").hide();
                $("#divDetalle").show();
            }

            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400
            });

            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno(1260, 510);
            });

            //SPALMA 04-05-2016 IMPLEMENTACION DE SHOW AND HIDE DE DIVS SEGUN OPCIONES
            //Genericos para TP y NoTP
            $("div.Hide").hide();
            $("div.Hide2").hide();

            cambioOpciones();
            check();//SPALMA 04-05-2016 Metodo para los checks de RadioButtons

            $('input[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            $('select[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            $('textarea[name*="rec_"]').bind('change paste keyup keydown keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if ($("#acceso").val() != "V") {
                    if (keyCode != 9) {
                        boInputChanged = true;
                        return;
                    }
                }
            });

            if ($("#Cod_Nivel").val() == "EMTP") {
                cargar_tabla("PAUA", "T2A_TP_PAUTA_TABLA");
                cargar_tabla("PAUB", "T2B_TP_PAUTA_TABLA");
                cargar_tabla("GPE", "T2_TP_PRUEBA_GUIA_TABLA");
            } else {
                cargar_tabla("PAUA", "T2A_PAUTA_TABLA");
                cargar_tabla("PAUB", "T2B_PAUTA_TABLA");
                cargar_tabla("GPE", "T2_PRUEBA_GUIA_TABLA");
            }
            //En el caso del acceso ser V solo se podra ver el formulario.
            if ($("#acceso").val() == "V") {
                if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
                    $(".guardar").hide();
                    $("input[name$='op_T2_TP_TIPO_EVALUACION']").attr('disabled', true);
                    $("#rec_T2_TP_ANALISIS_RESULT").prop('readonly', true);
                    $("#rec_T2_TP_DESAF_ESTRATEG").prop('readonly', true);
                    $("#rec_T2_TP_OBJ_EVALUACION").prop('readonly', true);
                    $("#rec_T2_TP_ACTIVIDAD_EVALUACION").prop('readonly', true);
                    $("#rec_T2_TP_INSTRUCCION").prop('readonly', true);
                    $(".adjuntos").hide();
                } else {
                    $(".guardar").hide();
                    $("input[name$='op_T2_TIPO_EVALUACION']").attr('disabled', true);
                    $("#rec_T2_ANALISIS_RESULT").prop('readonly', true);
                    $("#rec_T2_DESAF_ESTRATEG").prop('readonly', true);
                    $("#rec_T2_OBJ_EVALUACION").prop('readonly', true);
                    $("#rec_T2_ACTIVIDAD_EVALUACION").prop('readonly', true);
                    $("#rec_T2_INSTRUCCION").prop('readonly', true);
                    $(".adjuntos").hide();
                }
            }

            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
        });

        //============================Funciones Respaldo=====================================\\
        //SPALMA 09-06-2016 respalda en memeoria los datos de la opcion completada antes de cambiar a la otra opcion 
        // y se encarga de recargar los datos de vuelta si el docente vuelve a seleccionar la opcion
        function respaldos_memoria(opcion) {
            if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP

                if (opcion == "OpcionB") {

                    A_T2_P1 = $('#rec_T2_TP_OBJ_EVALUACION').val();
                    A_T2_P2 = $('#rec_T2_TP_ACTIVIDAD_EVALUACION').val();
                    $('#rec_T2_TP_OBJ_EVALUACION').val(B_T2_P1);
                    $('#rec_T2_TP_INSTRUCCION').val(B_T2_P4);
                }
                else {

                    B_T2_P1 = $('#rec_T2_TP_OBJ_EVALUACION').val();
                    B_T2_P4 = $('#rec_T2_TP_INSTRUCCION').val();
                    $('#rec_T2_TP_OBJ_EVALUACION').val(A_T2_P1);
                    $('#rec_T2_TP_ACTIVIDAD_EVALUACION').val(A_T2_P2);
                }

            } else {
                if (opcion == "OpcionB") {

                    A_T2_P1 = $('#rec_T2_OBJ_EVALUACION').val();
                    A_T2_P2 = $('#rec_T2_ACTIVIDAD_EVALUACION').val();
                    $('#rec_T2_OBJ_EVALUACION').val(B_T2_P1);
                    $('#rec_T2_INSTRUCCION').val(B_T2_P4);
                }
                else {

                    B_T2_P1 = $('#rec_T2_OBJ_EVALUACION').val();
                    B_T2_P4 = $('#rec_T2_INSTRUCCION').val();
                    $('#rec_T2_OBJ_EVALUACION').val(A_T2_P1);
                    $('#rec_T2_ACTIVIDAD_EVALUACION').val(A_T2_P2);
                }
            }

        }
        //SPALMA 09-06-2016 Limpia los respaldos luego de guardar
        function limpiar_resp() {

            A_T2_P1 = ""
            A_T2_P2 = ""
            B_T2_P1 = ""
            B_T2_P4 = ""

        }

        //Subir Prueba Guia
        function SubirGPE() {
            if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("GPE", function () {
                    cargar_tabla("GPE", "T2_TP_PRUEBA_GUIA_TABLA");
                });
            } else {
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("GPE", function () {
                    cargar_tabla("GPE", "T2_PRUEBA_GUIA_TABLA");
                });
            }

            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la prueba o guía.</span></p>")
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir prueba o guía");
            $('#dialog-uploadDocumento').dialog('open');
        }
        //Subir PautaA
        function SubirPAU() {
            if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("PAUA", function () {
                    cargar_tabla("PAUA", "T2A_TP_PAUTA_TABLA");
                });
            } else {
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("PAUA", function () {
                    cargar_tabla("PAUA", "T2A_PAUTA_TABLA");
                });
            }

            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la lista, escala o rúbrica.</span></p>");
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir lista, escala o rúbrica.");
            $('#dialog-uploadDocumento').dialog('open');
        }

        //Subir PautaB
        function SubirPAUB() {
            if ($("#Cod_Nivel").val() == "EMTP") { //SE AGREGA VERIFICACION SI ES NIVEL TP
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("PAUB", function () {
                    cargar_tabla("PAUB", "T2B_TP_PAUTA_TABLA");
                });
            } else {
                $('#rec_ID_DOCUMENTO').val('0');
                upload_Documento("PAUB", function () {
                    cargar_tabla("PAUB", "T2B_PAUTA_TABLA");
                });
            }

            $("#uploadTitulo").html("<p><span>Seleccione el archivo de la pauta de corrección.</span></p>");
            $("#dialog-uploadDocumento").dialog("option", "title", "Subir pauta de corrección");
            $('#dialog-uploadDocumento').dialog('open');
        }

        //Guardar la Tarea 2
        function Guardar() {
            if (boInputChanged == true) {
                if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
                    if ($('input[name=op_T2_TP_TIPO_EVALUACION]:checked', '#frmRegistry').val() == "OpcionB" && hayDatos("OpcionB") == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("<center>Usted está cambiando el tipo de evaluación a guía o prueba, <u>perderá lo que haya ingresado en evaluación de desempeño</u> ¿Desea continuar?</center>");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () {
                                SaveDataViaAjax();
                                $('#rec_T2_TP_ACTIVIDAD_EVALUACION').val("");
                                LimpiaAdjuntosA();
                                limpiar_resp();
                                $(this).dialog("close");
                            },
                            "No": function () {
                                $(this).dialog("close");
                                if (hayDatos("OpcionB") == true) {
                                    op = 0;
                                    $("#rec_T2_TP_TIPO_EVALUACION_OPCION1").click();
                                }
                            }
                        });
                        $("#confirm-dialog").dialog("open");
                    }
                    else if ($('input[name=op_T2_TP_TIPO_EVALUACION]:checked', '#frmRegistry').val() == "OpcionA" && hayDatos("OpcionA") == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("<center>Usted está cambiando el tipo de evaluación, a evaluación de desempeño, <u> perderá lo que haya ingresado en guía o prueba</u> ¿Desea continuar?</center>");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () {
                                SaveDataViaAjax();
                                $('#rec_T2_TP_INSTRUCCION').val("");
                                LimpiaAdjuntosB();
                                limpiar_resp();
                                $(this).dialog("close");
                            },
                            "No": function () {
                                $(this).dialog("close");
                                if (hayDatos("OpcionA") == true) {
                                    op = 0;
                                    $("#rec_T2_TP_TIPO_EVALUACION_OPCION2").click();
                                }
                            }
                        });
                        $("#confirm-dialog").dialog("open");
                    }
                    else {
                        SaveDataViaAjax();
                        limpiar_resp();
                    }
                } else {
                    if ($('input[name=op_T2_TIPO_EVALUACION]:checked', '#frmRegistry').val() == "OpcionB" && hayDatos("OpcionB") == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("<center>Usted está cambiando el tipo de evaluación a guía o prueba, <u>perderá lo que haya ingresado en evaluación de desempeño</u> ¿Desea continuar?</center>");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () {
                                SaveDataViaAjax();
                                $('#rec_T2_ACTIVIDAD_EVALUACION').val("");
                                LimpiaAdjuntosA();
                                limpiar_resp();
                                $(this).dialog("close");
                            },
                            "No": function () {
                                $(this).dialog("close");
                                if (hayDatos("OpcionB") == true) {
                                    op = 0;
                                    $("#rec_T2_TIPO_EVALUACION_OPCION1").click();
                                }
                            }
                        });
                        $("#confirm-dialog").dialog("open");
                    }
                    else if ($('input[name=op_T2_TIPO_EVALUACION]:checked', '#frmRegistry').val() == "OpcionA" && hayDatos("OpcionA") == true) {
                        $("#confirm-dialog").dialog("option", "title", "Hay cambios");
                        $("#confirm-dialog-content").html("<center>Usted está cambiando el tipo de evaluación, a evaluación de desempeño, <u> perderá lo que haya ingresado en guía o prueba</u> ¿Desea continuar?</center>");
                        $("#confirm-dialog").dialog("option", "buttons", {
                            "Sí": function () {
                                SaveDataViaAjax();
                                $('#rec_T2_INSTRUCCION').val("");
                                LimpiaAdjuntosB();
                                limpiar_resp();
                                $(this).dialog("close");
                            },
                            "No": function () {
                                $(this).dialog("close");
                                if (hayDatos("OpcionA") == true) {
                                    op = 0;
                                    $("#rec_T2_TIPO_EVALUACION_OPCION2").click();
                                }
                            }
                        });
                        $("#confirm-dialog").dialog("open");
                    }
                    else {
                        SaveDataViaAjax();
                        limpiar_resp();
                    }
                }

            }
            else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }
        //SPALMA 09-06-2016 Funcion para saber si existen datos en los respaldos de ambas opciones y enviar advertencia segun sea el caso
        function hayDatos(opcion) {
            if (opcion == "OpcionB") {
                if (A_T2_P1 != "" || A_T2_P2 != "" || $('#ID_PAUA0').val() != undefined) {
                    return true;
                }
                else {
                    return false;
                }
            }
            else if (opcion == "OpcionA") {
                if (B_T2_P1 != "" || B_T2_P4 != "" || $('#ID_GPE0').val() != undefined || $('#ID_PAUB0').val() != undefined) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Tarea2.aspx/SaveData";
            var arForm = $("#frmRegistry").serializeArray();
            $("#save").button("option", "disabled", true);
            $("#iconUpdates").html("<img src='../../Imagenes/ajax-loader_small.gif' />");
            $("#Vidrio").show();
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: methodURL,
                data: JSON.stringify({ "mode": $('#boRegistryMode').val(), formVars: arForm }),
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
                            $('#MyRowstamp').val(Record["d"]["ROWSTAMP"]);
                            $("#iCurrentRow").val(Record["d"]["__rowindex"]);

                            boInputChanged = false;

                            if ($("#boRegistryMode").val() == 'new') {
                                //RBORLONE 05-04-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_T2.
                                $("#rec_ID_TABLA").val(Record["d"]["__ID_T2"]);
                                $("#boRegistryMode").val("update");
                            }
                            else {
                                $("#info-message").dialog("option", "title", "Aviso");
                                $("#info-message-content").html("Su tarea ha sido guardada con éxito.");
                                $("#info-message").dialog("open");
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
                $("#alert-message-content").html("Ocurrió un error inesperado y no se pudo guardar datos en el servidor: " + msg);
                $("#alert-message").dialog("open");
            }
                },
                complete: function () {
                    $("#iconUpdates").html("");
                    $("#save").button("option", "disabled", false);
                    $("#Vidrio").hide();
                }
            });
}

//SPALMA 09-06-2016 definicion para cambio de opcion en pantalla con mensaje
function cambioOpciones() {
    if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
        $("input[name$='op_T2_TP_TIPO_EVALUACION']").change(function () {
            boInputChanged = true;
            $("div.Hide2").hide();
            respaldos_memoria($(this).val());
            if (op == 1 && hayDatos($(this).val()) == true) {
                advertencia();
            }
            op = 1;
            if ($(this).val() == "OpcionA") {
                $("#divPregB1TP").show();
                $("#divPregC1TP").show();
            }
            else {
                $("#divPregB2TP").show();
                $("#divPregC2TP").show();
                $("#divPregD1TP").show();
            }
            $("#divPregATP").show();
            $("#divPregDTP").show();
            $('#rec_T2_TP_OBJ_EVALUACION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_ACTIVIDAD_EVALUACION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_ANALISIS_RESULT').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_DESAF_ESTRATEG').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_TP_INSTRUCCION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
        });
    } else {
        $("input[name$='op_T2_TIPO_EVALUACION']").change(function () {
            boInputChanged = true;
            $("div.Hide").hide();
            respaldos_memoria($(this).val());
            if (op == 1 && hayDatos($(this).val()) == true) {
                advertencia();
            }
            op = 1;
            if ($(this).val() == "OpcionA") {
                $("#divPregB1").show();
                $("#divPregC1").show();
            }
            else {
                $("#divPregB2").show();
                $("#divPregC2").show();
                $("#divPregD1").show();
            }
            $("#divPregA").show();
            $("#divPregD").show();
            $('#rec_T2_OBJ_EVALUACION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_ACTIVIDAD_EVALUACION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_ANALISIS_RESULT').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_DESAF_ESTRATEG').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T2_INSTRUCCION').maxlength('option', { feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
        });
    }


}
//SPALMA 09-06-2016 advertencia de cambio de tipo de evaluacion
function advertencia() {
    $("#confirm-dialog").dialog("option", "title", "Advertencia");
    $("#confirm-dialog-content").html("<center>Recuerde que debe presentar UN SOLO tipo de evaluación.</center>");
    $("#confirm-dialog").dialog("option", "buttons", {
        "Aceptar": function () {
            $(this).dialog("close");
        },
    });
    $("#confirm-dialog").dialog("open");

}
//SPALMA 04-05-2016 Metodo en modificacion para los checks de RadioButtons
function check() {
    if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
        var RDB_VAL_SELECT = '';
        var RDB_CHECK = $("input[name$='op_T2_TP_TIPO_EVALUACION']");
        for (var i = 0; i < RDB_CHECK.length; i++) {
            if (RDB_CHECK[i].checked == true) {
                boInputChanged == true;
                RDB_VAL_SELECT = RDB_CHECK[i].value;
            }
            if (RDB_VAL_SELECT != '') {
                $("#divPregATP").show();
                $("#divPregDTP").show();
                if (RDB_VAL_SELECT == 'OpcionA') {
                    $("#divPregB1TP").show();
                    $("#divPregC1TP").show();
                } else {
                    $("#divPregB2TP").show();
                    $("#divPregC2TP").show();
                    $("#divPregD1TP").show();
                }
            }
        }
    } else {
        var RDB_VAL_SELECT = '';
        var RDB_CHECK = $("input[name$='op_T2_TIPO_EVALUACION']");
        for (var i = 0; i < RDB_CHECK.length; i++) {
            if (RDB_CHECK[i].checked == true) {
                boInputChanged == true;
                RDB_VAL_SELECT = RDB_CHECK[i].value;
            }
            if (RDB_VAL_SELECT != '') {
                $("#divPregA").show();
                $("#divPregD").show();
                if (RDB_VAL_SELECT == 'OpcionA') {
                    $("#divPregB1").show();
                    $("#divPregC1").show();
                } else {
                    $("#divPregB2").show();
                    $("#divPregC2").show();
                    $("#divPregD1").show();
                }
            }
        }
    }

}
//Funcion Que Limpia los datos(Elimina) segun la Opcion seleccionada, al momento de guardar
function LimpiaAdjuntosB() {
    for (var i = 0; i < 5; i++) {
        if ($('#ID_GPE' + i).val() != undefined) {
            eliminar_documentoTipos($('#ID_GPE' + i).val());
        }
    }
    if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
        cargar_tabla("GPE", "T2_TP_PRUEBA_GUIA_TABLA");
    } else {
        cargar_tabla("GPE", "T2_PRUEBA_GUIA_TABLA");
    }

    for (var i = 0; i < 5; i++) {
        if ($('#ID_PAUB' + i).val() != undefined) {
            eliminar_documentoTipos($('#ID_PAUB' + i).val());
        }
    }
    if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
        cargar_tabla("PAUB", "T2B_TP_PAUTA_TABLA");
    } else {
        cargar_tabla("PAUB", "T2B_PAUTA_TABLA");
    }

}
//SPALMA 09-06-2016 Funcion Que Limpia los datos(Elimina) segun la Opcion seleccionada, al momento de guardar
function LimpiaAdjuntosA() {
    for (var i = 0; i < 5; i++) {
        if ($('#ID_PAUA' + i).val() != undefined) {
            eliminar_documentoTipos($('#ID_PAUA' + i).val());
        }
    }
    if ($("#Cod_Nivel").val() == "EMTP") {//SE AGREGA VERIFICACION SI ES NIVEL TP
        cargar_tabla("PAUA", "T2A_TP_PAUTA_TABLA");
    } else {
        cargar_tabla("PAUA", "T2A_PAUTA_TABLA");
    }

}
//SPALMA 09-06-2016 Funcion ajax llamada por las 2 anteriores para eliminacion de archivos en opcion no elegida
function eliminar_documentoTipos(idDocumento, tipomaterial, success) {
    var methodURL = baseUrl + 'Aplicaciones/Ficha/Fichas.aspx/EliminarDocumento';
    var parameters = '{idDocumento: "' + idDocumento + '",idTabla: "' + $('#rec_ID_TABLA').val() + '",Tabla: "T2",idApliccion: "' + $('#Id_Aplicacion').val() + '"}';

    $.ajax({
        cache: false,
        async: false,
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        url: methodURL,
        data: parameters,
        success: function (response) {
        },
        error: function (xhr, err) {
            $("#alert-message").dialog("option", "title", "Error");
            $("#alert-message-content").html(err);
            $("#alert-message").dialog("open");
        }
    });
}

function cargar_tabla(tipomaterial, tabla) {
    if ($('#rec_NOMBRE_TABLA').val() != "" && $('#rec_ID_TABLA').val() != "") {
        var methodURL = baseUrl + "Aplicaciones/Ficha/Tarea2.aspx/cargarTabla";
        var parameters = '{ nombreTabla:"' + $('#rec_NOMBRE_TABLA').val() + '", idTabla:"' + $('#rec_ID_TABLA').val() + '", tipoMaterial:"' + tipomaterial + '" }';
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
                    }
                    else {
                        $("#" + tabla).empty();
                        $("#" + tabla).html(Record["d"]["__body"]);
                        $(".adjunto").on('dragstart', function (e) { e.preventDefault(); });
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
}

//SPALMA 06-05-2016 - Modificacion del html para mostrar los campos segun opcion(Nombres opcionales de divs en modificacion)
    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="frmRegistry" runat="server">
        <div style="width: 750px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;">
            <table style="width: 100%;" border="0">
                <tr>
                    <td align="left" style="width: 30%;">
                        <button id="desempeno" runat="server">
                            Qué me evaluarán...</button></td>
                    <td align="center" class="pdTitulo1">EVALUACIÓN
                    </td>
                    <td align="right" style="width: 20%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar1" runat="server"/>
                    </td>
                    <td style="width: 15px;"></td>
                </tr>
                <tr>
                    <td align="center" class="pdSubTitulo1" colspan="3"><b>Revise las instrucciones de su Manual Portafolio para desarrollar esta tarea</b>
                    </td>
                </tr>
            </table>
            <div id="divDetalle" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT2">
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>A. Una evaluación aplicada a sus estudiantes</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg" style="color: red">
                                <label>
                                    <b>Marque el tipo de evaluación que escogió presentar:</b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <table class="ui-widget ui-widget-content ui-corner-all" style="width: 100%;">
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T2_TIPO_EVALUACION_OPCION1" runat="server" name="op_T2_TIPO_EVALUACION" value="OpcionA" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;"><b>Evaluación de algún desempeño, ejecución o producto utilizando una lista de cotejo, escala de apreciación o rúbrica.</b></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T2_TIPO_EVALUACION_OPCION2" runat="server" name="op_T2_TIPO_EVALUACION" value="OpcionB" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;"><b>Guía o prueba escrita como evaluación.</b></label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <div id="divPregA" class="Hide" style="display: none;" runat="server">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label><b>a. Escriba el(los) objetivo(s) que evaluó.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_OBJ_EVALUACION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_OBJ_EVALUACION" name="rec_T2_OBJ_EVALUACION" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregB1" class="Hide" runat="server" style="display: none;">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label><b>b. Describa detalladamente la actividad de evaluación y transcriba todas las instrucciones que entregó a sus estudiantes, paso a paso.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_ACTIVIDAD_EVALUACION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_ACTIVIDAD_EVALUACION" name="rec_T2_ACTIVIDAD_EVALUACION" runat="server" class="ui-widget-content ui-corner-all" rows="33" cols="100" maxlength="3300" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregB2" class="Hide" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>b.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirGPE" src="../../Imagenes/Images/T2_PruebaGuia_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_PruebaGuia_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_PruebaGuia_OFF.png'" onclick="SubirGPE()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2_PRUEBA_GUIA_TABLA" runat="server">
                                        <%--T2GPE--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregC1" class="Hide" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>c.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirPAU" src="../../Imagenes/Images/T2_Pauta_Boton_A_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_Pauta_Boton_A_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_Pauta_Boton_A_OFF.png'" onclick="SubirPAU()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2A_PAUTA_TABLA" runat="server">
                                        <%--T2PAU--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregC2" class="Hide" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>c.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirPAUB" src="../../Imagenes/Images/T2_Pauta_Boton_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_Pauta_Boton_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_Pauta_Boton_OFF.png'" onclick="SubirPAUB()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2B_PAUTA_TABLA" runat="server">
                                        <%--T2PAU--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <div id="divPregD1" class="Hide" runat="server" style="display: none;">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>d. Si considera necesario dar cuenta de alguna aclaración o instrucción que entregó durante la evaluación, escríbala.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_INSTRUCCION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_INSTRUCCION" name="rec_T2_INSTRUCCION" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregD" class="Hide" runat="server">
                        <table class="ui-widget" style="width: 100%;" border="0">
                            <tr>
                                <td class="TituloPregG">
                                    <label>
                                        <b>B. Análisis y uso de los resultados de la evaluación </b></label>
                                </td>
                            </tr>
                        </table>
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>B.1 Considerando<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label></b>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_ANALISIS_RESULT"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_ANALISIS_RESULT" name="rec_T2_ANALISIS_RESULT" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>B.2 ¿Qué desafíos<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label></b>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_DESAF_ESTRATEG"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_DESAF_ESTRATEG" name="rec_T2_DESAF_ESTRATEG" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right" class="guardar">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer"/>
                        </td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
            </div>
            <div id="divDetalleTP" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT2">
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>A. Una evaluación aplicada a sus estudiantes</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg" style="color: red">
                                <label>
                                    <b>Marque el tipo de evaluación que escogió presentar:</b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <table class="ui-widget ui-widget-content ui-corner-all" style="width: 100%;">
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T2_TP_TIPO_EVALUACION_OPCION1" runat="server" name="op_T2_TP_TIPO_EVALUACION" value="OpcionA" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;"><b>Evaluación de algún desempeño, ejecución o producto utilizando una lista de cotejo, escala de apreciación o rúbrica.</b></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <input type="radio" id="rec_T2_TP_TIPO_EVALUACION_OPCION2" runat="server" name="op_T2_TP_TIPO_EVALUACION" value="OpcionB" />
                                        </td>
                                        <td style="width: auto">
                                            <label style="display: inline;"><b>Guía o prueba escrita como evaluación.</b></label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <div id="divPregATP" class="Hide2" style="display: none;" runat="server">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label><b>a. Escriba el(los) aprendizaje(s) que evaluó por medio de esta evaluación.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_TP_OBJ_EVALUACION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_TP_OBJ_EVALUACION" name="rec_T2_TP_OBJ_EVALUACION" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregB1TP" class="Hide2" runat="server" style="display: none;">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label><b>b. Describa detalladamente la actividad de evaluación y transcriba todas las instrucciones que entregó a sus estudiantes, paso a paso.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_TP_ACTIVIDAD_EVALUACION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_TP_ACTIVIDAD_EVALUACION" name="rec_T2_TP_ACTIVIDAD_EVALUACION" runat="server" class="ui-widget-content ui-corner-all" rows="33" cols="100" maxlength="3300" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregB2TP" class="Hide2" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>b.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirGPE" src="../../Imagenes/Images/T2_PruebaGuia_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_PruebaGuia_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_PruebaGuia_OFF.png'" onclick="SubirGPE()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2_TP_PRUEBA_GUIA_TABLA" runat="server">
                                        <%--T2GPE--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregC1TP" class="Hide2" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>c.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirPAU" src="../../Imagenes/Images/T2_Pauta_Boton_A_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_Pauta_Boton_A_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_Pauta_Boton_A_OFF.png'" onclick="SubirPAU()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2A_TP_PAUTA_TABLA" runat="server">
                                        <%--T2PAU--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregC2TP" class="Hide2" style="display: none;" runat="server">
                        <table>
                            <tr>
                                <td class="ui-widget" style="width: 16px;" valign="top">
                                    <label><b>c.</b></label>
                                </td>
                                <td valign="top" class="adjuntos">
                                    <img alt="SubirPAUB" src="../../Imagenes/Images/T2_Pauta_Boton_OFF.png" onmouseover="this.src='../../Imagenes/Images/T2_Pauta_Boton_ON.png'"
                                        onmouseout="this.src='../../Imagenes/Images/T2_Pauta_Boton_OFF.png'" onclick="SubirPAUB()" class="adjunto" style="cursor:pointer"/>
                                </td>
                                <td valign="top">
                                    <div id="T2B_TP_PAUTA_TABLA" runat="server">
                                        <%--T2PAU--%>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="divPregD1TP" class="Hide2" runat="server" style="display: none;">
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>d. Si considera necesario dar cuenta de alguna aclaración o instrucción que entregó durante la evaluación, escríbala.</b></label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_TP_INSTRUCCION"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_TP_INSTRUCCION" name="rec_T2_TP_INSTRUCCION" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1000" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <div id="divPregDTP" class="Hide2" runat="server">
                        <table class="ui-widget" style="width: 100%;" border="0">
                            <tr>
                                <td class="TituloPregG">
                                    <label>
                                        <b>B. Análisis y uso de los resultados de la evaluación</b></label>
                                </td>
                            </tr>
                        </table>
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>B.1 Considerando<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip"/></label></b>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_TP_ANALISIS_RESULT"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_TP_ANALISIS_RESULT" name="rec_T2_TP_ANALISIS_RESULT" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                        <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                            <tr>
                                <td class="TituloPreg">
                                    <label>
                                        <b>B.2 ¿Qué desafíos<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip"/></label></b>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label id="tf_T2_TP_DESAF_ESTRATEG"></label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <textarea id="rec_T2_TP_DESAF_ESTRATEG" name="rec_T2_TP_DESAF_ESTRATEG" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right" class="guardar">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar2" runat="server"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <%--SPALMA 04-05-2016 Para la subida del archivo--%>
        <input type="hidden" id="rec_ID_PERIODO" runat="server" />
        <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
        <input type="hidden" id="rec_ID_EVALUACION" runat="server" />
        <input type="hidden" id="boRegistryMode" runat="server" value="new" />
        <input type="hidden" id="ErrorMessage" runat="server" value="" />
        <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />
        <span id="msgSaved"></span>

        <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="T2" runat="server" />
        <input type="hidden" id="rec_NOMBRE_CAMPO" name="rec_NOMBRE_CAMPO" value="" runat="server" />
        <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
        <input type="hidden" id="rec_ID_DOCUMENTO" name="rec_ID_DOCUMENTO" value="0" runat="server" />
        <input type="hidden" id="DesEsp" name="DesEsp" value="" runat="server" />
        <input type="hidden" id="DesEspWidth" name="DesEspWidth" value="800" runat="server" />
        <input type="hidden" id="DesEspHeight" name="DesEspHeight" value="800" runat="server" />
        <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
        <input type="hidden" id="Id_Aplicacion" name="Id_Aplicacion" value="292" runat="server" />
        <input type="hidden" id="Cod_Nivel" name="Cod_Nivel" runat="server" />
    </form>

</body>
</html>
