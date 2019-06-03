<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Tarea3.aspx.vb" Inherits="PlataformaDocente.Tarea3" %>

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

        $.fn.ready(function () {
            $('#divDetalle').height($(window).height() - 190)
            $('#divDetalleTP').height($(window).height() - 190)

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });

            $('#rec_T3_CARACT_ALUMNOS').maxlength({ max: 3600, feedbackTarget: '#tf_T3_CARACT_ALUMNOS', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_CONTEX_ERROR').maxlength({ max: 500, feedbackTarget: '#tf_T3_CONTEX_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_DESCRIP_ERROR').maxlength({ max: 3600, feedbackTarget: '#tf_T3_DESCRIP_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_RETRO_ERROR').maxlength({ max: 3600, feedbackTarget: '#tf_T3_RETRO_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });


            $('#rec_T3_TP_CARACT_ALUMNOS').maxlength({ max: 3600, feedbackTarget: '#tf_T3_TP_CARACT_ALUMNOS', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_TP_CONTEX_ERROR').maxlength({ max: 500, feedbackTarget: '#tf_T3_TP_CONTEX_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_TP_DESCRIP_ERROR').maxlength({ max: 3600, feedbackTarget: '#tf_T3_TP_DESCRIP_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_T3_TP_RETRO_ERROR').maxlength({ max: 3600, feedbackTarget: '#tf_T3_TP_RETRO_ERROR', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });

            //$("#dialog-info-desempeno").dialog({
            //    height: $("#DesEspHeight").val(),
            //    width: $("#DesEspWidth").val()
            //});

            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno(1260, 510);
            });

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

            //En el caso del acceso ser V solo se podra ver el formulario.
            if ($("#acceso").val() == "V") {
                $(".guardar").hide();
                $('#rec_T3_CARACT_ALUMNOS').prop('readonly', true);
                $('#rec_T3_CONTEX_ERROR').prop('readonly', true);
                $('#rec_T3_DESCRIP_ERROR').prop('readonly', true);
                $('#rec_T3_CONTEX_ERROR').prop('readonly', true);
                $('#rec_T3_DESCRIP_ERROR').prop('readonly', true);
                $('#rec_T3_RETRO_ERROR').prop('readonly', true);
                $('#rec_T3_TP_CARACT_ALUMNOS').prop('readonly', true);
                $('#rec_T3_TP_CONTEX_ERROR').prop('readonly', true);
                $('#rec_T3_TP_DESCRIP_ERROR').prop('readonly', true);
                $('#rec_T3_TP_CONTEX_ERROR').prop('readonly', true);
                $('#rec_T3_TP_DESCRIP_ERROR').prop('readonly', true);
                $('#rec_T3_TP_RETRO_ERROR').prop('readonly', true);

                //ELEMENTOS CORRESPONDIENTES A LOS DOCENTES TP
            }

            if ($("#Cod_Nivel").val() == "EMTP") {
                $("#divDetalleTP").show();
                $("#divDetalle").hide();

            } else {
                $("#divDetalleTP").hide();
                $("#divDetalle").show();

            }

            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
        });


        //Guardar la Tarea 3
        function Guardar() {
            if (boInputChanged == true) {
                SaveDataViaAjax();
            } else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Tarea3.aspx/SaveData";
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
                                //spalma 06-05-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_T3.
                                $("#rec_ID_TABLA").val(Record["d"]["__ID_T3"]);
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
//SPALMA 06-05-2016 - Modificacion del html para mostrar T3
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
                    <td align="center" class="pdTitulo1">REFLEXIÓN
                    </td>
                    <td align="right" style="width: 20%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar1" runat="server"/>
                    </td>
                    <td style="width: 15px;"></td>
                </tr>
                <tr>
                    <%--<td align="center" class="pdSubTitulo1" colspan="3"><b>Revise las instrucciones de su Manual Portafolio para desarrollar esta tarea</b>--%>
                    <td align="center" class="pdSubTitulo1" colspan="3"><b>Revise las instrucciones de su Manual Portafolio para responder cada pregunta</b>
                    </td>
                </tr>
            </table>
            <div id="divDetalle" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT3">
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>A. Análisis a partir de las características de los y las estudiantes</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>A.1  ¿Cómo<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><%--TEXTO_FALTANTE--%>
                                        <br />
                                        A.2 Escoja dos de las<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><%--TEXTO_FALTANTE--%>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_CARACT_ALUMNOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_CARACT_ALUMNOS" name="rec_T3_CARACT_ALUMNOS" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>B. Uso del error para el aprendizaje</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.1 ¿En qué<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                        <%--TEXTO_FALTANTE--%>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_CONTEX_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_CONTEX_ERROR" name="rec_T3_CONTEX_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.2 Describa<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br />
                                        <%--TEXTO_FALTANTE--%>
                                        - ¿Cuál fue<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br /> <%--TEXTO_FALTANTE--%>
                                        - ¿Qué cree que<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_DESCRIP_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_DESCRIP_ERROR" name="rec_T3_DESCRIP_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.3 Describa y analice<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br />
                                        <%--TEXTO_FALTANTE--%>
                                        - ¿A través de<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br /> <%--TEXTO_FALTANTE--%>
                                        - ¿Por qué<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_RETRO_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_RETRO_ERROR" name="rec_T3_RETRO_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer"/>
                        </td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
            </div>
            <%--*****************************************************************
            *****************INICIO DIV TP--%>
            <%--ANDRES ZAMORANO 15-05-2017
            CAMPOS CORRESPONDIENTES A LOS DOCENTES TECNICO PROFESIONAL--%>
            <div id="divDetalleTP" style="width: 750px; height: 100px; border: 0px; overflow-y: auto;" runat="server">
                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <fieldset class="pdFondoT3">
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>A. Análisis a partir de las características de los y las estudiantes</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>A.1  ¿Cómo<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><%--TEXTO_FALTANTE--%>
                                        <br />
                                        A.2 Escoja dos de las<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><%--TEXTO_FALTANTE--%>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_TP_CARACT_ALUMNOS"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_TP_CARACT_ALUMNOS" name="rec_T3_TP_CARACT_ALUMNOS" runat="server" class="ui-widget-content ui-corner-all" rows="36" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <table class="ui-widget" style="width: 100%; padding-right: 5px" border="0">
                        <tr>
                            <td class="TituloPregG">
                                <label>
                                    <b>B. Uso del error para el aprendizaje</b></label></td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.1 ¿En qué<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                        <%--TEXTO_FALTANTE--%>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_TP_CONTEX_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_TP_CONTEX_ERROR" name="rec_T3_TP_CONTEX_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="500" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.2 Describa<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br />
                                        <%--TEXTO_FALTANTE--%>
                                        - ¿Cuál fue<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br /> <%--TEXTO_FALTANTE--%>
                                        - ¿Qué cree que<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_TP_DESCRIP_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea id="rec_T3_TP_DESCRIP_ERROR" name="rec_T3_TP_DESCRIP_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloPreg">
                                <label>
                                    <b>B.3 Describa y analice<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br />
                                        <%--TEXTO_FALTANTE--%>
                                        - ¿A través de<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label><br /> <%--TEXTO_FALTANTE--%>
                                        - ¿Por qué<label class="popupAyudaPF" data-title="Revise la instrucción en su Manual">...?
                                            <img src="../../Imagenes/Images/tooltipPF.png" alt="tooltip" style="display:inline"/></label>
                                    </b>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label id="tf_T3_TP_RETRO_ERROR"></label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">

                                <textarea id="rec_T3_TP_RETRO_ERROR" name="rec_T3_TP_RETRO_ERROR" runat="server" class="ui-widget-content ui-corner-all" rows="20" cols="100" maxlength="3600" style="width: 100%; overflow-y: auto"></textarea>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" style="cursor:pointer" id="guardar2" runat="server"/>
                        </td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
            </div>
            <%-- *****************FIN DIV TP
            **************************************************************--%>
        </div>
        <input type="hidden" id="rec_ID_PERIODO" runat="server" />
        <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
        <input type="hidden" id="rec_ID_EVALUACION" runat="server" />

        <input type="hidden" id="boRegistryMode" runat="server" value="new" />
        <input type="hidden" id="ErrorMessage" runat="server" value="" />
        <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />
    </form>


    <span id="msgSaved"></span>
    <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="T3" runat="server" />
    <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
    <input type="hidden" id="DesEsp" name="DesEsp" value="" runat="server" />
    <input type="hidden" id="DesEspWidth" name="DesEspWidth" value="800" runat="server" />
    <input type="hidden" id="DesEspHeight" name="DesEspHeight" value="800" runat="server" />
    <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
    <input type="hidden" id="Cod_Nivel" name="Cod_Nivel" runat="server" />
</body>
</html>
