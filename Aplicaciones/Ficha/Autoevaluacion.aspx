<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Autoevaluacion.aspx.vb" Inherits="PlataformaDocente.Autoevaluacion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="google" content="notranslate" />
    <script src="../../Scripts/Framework/__jsCommon/jsCommon.js" type="text/javascript"></script>
    <title></title>
    <script type="text/javascript">
        var baseUrl = '<%= ResolveUrl("~/") %>';

        $.fn.ready(function () {
            if ($('#OpSN').val() == "S") {
                $('#dialog_vol').css('display', 'block');
            } else {
                $('#dialog_vol').css('display', 'none');
            };

            $('#divDetalle').height($(window).height() - 190)

            //Deshabilitar arrastre de imagenes
            $(".guardar").on('dragstart', function (e) { e.preventDefault(); });

            ////Contadores de Caracteres
            $('#rec_AE_FUND_APORTE').maxlength({ max: 1200, feedbackTarget: '#tf_AE_FUND_APORTE', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });
            $('#rec_AE_FUND_CONS_CONTEXT').maxlength({ max: 1500, feedbackTarget: '#tf_AE_FUND_CONS_CONTEXT', feedbackText: 'Máximo {m} caracteres. {r} disponibles' });

            $("#dialog-info-desempeno").dialog({
                height: $("#DesEspHeight").val(),
                width: $("#DesEspWidth").val()
            });

            $("#confirm-dialog").dialog({
                modal: true,
                autoOpen: false,
                height: "auto",
                width: 400
            });

            $("#info-auto").dialog({
                modal: true,
                autoOpen: false,
                height: 480,
                width: 650,
                closeOnEscape: true,
                resizable: false,
                create: function (e, ui) {
                    $(this).dialog('widget')
                        .find('.ui-dialog-titlebar')
                        .removeClass('ui-corner-all')
                        .addClass('ui-corner-top');
                },
                buttons: {
                    Aceptar: function () {
                        $(this).dialog("close");
                    }
                },
                open: function (event, ui) {
                    $(this).css('overflow', 'hidden');
                    $(this).css("background-color", "white");
                }
            });

            $("#desempeno").button().click(function (event) {
                event.preventDefault();
                MostrarDesempeno();
            });

            $('input[name*="rec_"]').bind('change', function () {
                boInputChanged = true;
            });
            $('.PreguntasAE_Down2').addClass("DropDown2");
            $('select[name*="rec_"]').bind('change', function () {
                boInputChanged = true;
                var drop = $(this).val()
                this.blur();
                $('.PreguntasAE_Down2').bind('change', function () {
                    tdColorSelect("#" + $(this).attr("id"), drop);
                });
                this.focus();
                //colorSelect("#" + $(this).attr("id"), $(this).val());
            });

            $('textarea[name*="rec_"]').bind('change paste', function () {
                boInputChanged = true;
            });

            $('select[name*="rec_"]').bind('mousewheel DOMMouseScroll', function (e) {
                this.blur();
            });

            //Recorre por las preguntas.
            leeRegistro();
            cargaTD();
            //cargaCombos(); sph.- respaldo texto por si hay cambios

            //En el caso del acceso ser V solo se podra ver el formulario.
            if ($("#acceso").val() == "V") {
                $(".guardar").hide();
                for (var i = 1; i <= 12; i++) {
                    $("#rec_AE_P" + i).attr('disabled', true);
                    for (var f = 1; f <= 4; f++) {
                        $("input[name$='rec_AE_P" + i + "_" + f + "']").attr("disabled", true);
                    }
                }
                $('#radio_si').attr("disabled", true);
                $('#radio_no').attr("disabled", true);

                $('#rec_AE_FUND_APORTE').prop('readonly', true);
                $('#rec_AE_FUND_CONS_CONTEXT').prop('readonly', true);

                //$("#info-auto").dialog("open");
                $("#alert-messageAE").dialog("option", "title", "¡Advertencia!");
                $("#alert-messageAE").dialog("open");
            } else {
                $("#info-auto").dialog("open");
            };

            if ($("#ErrorMessage").val() != "") {
                $("#alert-message").dialog("option", "title", "Error");
                $("#alert-message-content").html($("#ErrorMessage").val());
                $("#alert-message").dialog("open");
            }
            //NMM. 14.06.2017 Mensajes popup de los Indicadores que aparece en todo el encabezado.
            var msgIndicadores = "Recuerde: estos indicadores NO incidirán en su puntaje en la Autoevaluación. Lea el Manual.";
            $(".popupAyudaIndicador").attr("data-title", msgIndicadores)
            $(".popupAyudaIndicador2").attr("data-title", msgIndicadores)
            //NMM. 14.06.2017 Mensajes popup de las preguntas de reflexión.
            var msgPreg = "Sus respuestas a estas preguntas no tendrán ningún efecto en su puntaje y serán conocidas por su Director/a y su Jefe/a de UTP a través de la Plataforma Docentemás.";
            $("#text1").attr("data-title", msgPreg)
            $("#text2").attr("data-title", msgPreg)



        });

        //Guardar la AE
        function Guardar() {
            if (boInputChanged == true) {
                guardaRegistro();
                SaveDataViaAjax();
            }
            else {
                $("#info-message").dialog("option", "title", "Guardar registro");
                $("#info-message-content").html("No hay cambios pendientes de guardar.");
                $("#info-message").dialog("open");
            }
        }

        function SaveDataViaAjax() {
            methodURL = baseUrl + "Aplicaciones/Ficha/Autoevaluacion.aspx/SaveData";
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

                            if (Record["d"]["__datefinal"] == 'N') {
                                $("#alert-messageAE").dialog("option", "title", "¡Advertencia!");
                                $("#alert-messageAE").dialog("open");
                            } else {
                                $('#MyRowstamp').val(Record["d"]["ROWSTAMP"]);
                                $("#iCurrentRow").val(Record["d"]["__rowindex"]);

                                boInputChanged = false;

                                if ($("#boRegistryMode").val() == 'new') {
                                    //RBORLONE 05-04-2016 Cuando se esta insertando un registro le asignamos un nuevo ID_AE%.
                                    $("#rec_ID_TABLA").val(Record["d"]["__ID_AE"]);
                                    $("#boRegistryMode").val("update");
                                }
                                else {
                                    $("#info-message").dialog("option", "title", "Aviso");
                                    $("#info-message-content").html("Sus cambios han sido guardados con éxito.");
                                    $("#info-message").dialog("open");
                                }

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

//NMM. 24.05.2017 Lectura de valores correspondiente a dropdownlist(s) y radio(s) en el formulario de preguntas.
function leeRegistro() {
    for (var p = 1; p <= 12; p++) {
        var cadena = $('#rec_AE_P' + p + '_T').val(); //ej. : rec_AE_P1_T
        if (cadena != '') {
            //Recorre por las 4 sub preguntas.
            for (var f = 1; f <= 4; f++) {
                if (cadena.charAt(f - 1) != " ") {
                    $('#rec_AE_P' + p + '_' + f + '_' + cadena.charAt(f - 1)).click()  //ej. : rec_AE_P1_1_1
                }
            }
            $('#rec_AE_P' + p).val(cadena.charAt(4));
        } else {
            $('#rec_AE_P' + p).val(" ");
        }
    }
    boInputChanged = false;
}

//NMM. 24.05.2017 Recopilación de valores correspondiente a dropdownlist(s) y radio(s) en el formulario de preguntas.
function guardaRegistro() {
    for (var p = 1; p <= 12; p++) {
        var Valor = '';
        for (var f = 1; f <= 4; f++) {
            var RDB_CHECK = $("input[name$='rec_AE_P" + p + "_" + f + "']");
            var Valor_Opcion = '_';
            for (var i = 0; i < RDB_CHECK.length; i++) {
                if (RDB_CHECK[i].checked == true) {
                    Valor_Opcion = $('#rec_AE_P' + p + '_' + f + '_' + (i + 1)).val();
                }
            }
            Valor = Valor + Valor_Opcion;
        }
        Valor = Valor + $('#rec_AE_P' + p).val();
        $('#rec_AE_P' + p + '_T').val(Valor);
    }
}

function colorSelect(campo, valor) {
    if (valor == " ") {
        $(campo).addClass("DropDown2");
        $(campo + " option").each(function () {
            $(this).addClass("DropDown1");
        });
    }
    else {
        $(campo).removeClass("DropDown2");
    }
}

function tdColorSelect(campo, valor) {
    if (valor == " ") {
        $(campo).addClass("DropDown2");
    }
    else {
        $(campo).removeClass("DropDown2");
    }
}

//function cargaCombos() {
//    for (var i = 1; i <= 12; i++) {
//        colorSelect("#rec_AE_P" + i, $("#rec_AE_P" + i + " option:selected").val());
//    }
//}

function cargaTD() {
    for (var i = 1; i <= 12; i++) {
        colorTD("#drop_AE_P" + i, $("#rec_AE_P" + i + " option:selected").val());
    }
}

function colorTD(campo, valor) {
    if (valor == " ") {
        $(campo).addClass("DropDown2");
    }
    else {
        $(campo).removeClass("DropDown2");
    }
}

function OpS() {
    $('#dialog_vol').css('display', 'block');
    $('#radio_no').prop('checked', false);
    boInputChanged = true;
};

function OpN() {
    $('#dialog_vol').css('display', 'none');
    $('#radio_si').prop('checked', false);
    boInputChanged = true;
};

    </script>
</head>
<body onload="fnCommon_nobackbutton()">
    <form id="frmRegistry" runat="server">
        <div style="width: 950px; border: 0px; margin-top: 0px; margin-left: auto; margin-right: auto;">
            <table style="width: 100%;" border="0">
                <tr>
                    <td align="left" style="width: 10%;"></td>
                    <td align="center" class="pdTitulo1">AUTOEVALUACIÓN
                    </td>
                    <td align="right" style="width: 10%;">
                        <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                            onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" id="guardar1" runat="server" /></td>
                    <td style="width: 15px;"></td>
                </tr>
                <tr>
                    <td align="center" class="pdSubTitulo1" colspan="3"><b>Revise su Manual de Autoevaluación</b>
                    </td>
                </tr>
            </table>
            <div id="divDetalle" style="width: 950px; height: 100px; border: 0px; overflow-y: scroll;" runat="server">

                <%--======================= FRAMEWORK rec fields declaration =======================--%>
                <%--======================= Encabezados =======================--%>
                <fieldset class="pdFondoAE">
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td colspan="4" class="TituloPregAE">
                                <label>Tenga presente que para todas las preguntas que responderá a continuación debe indicar su nivel de desempeño de acuerdo a lo siguiente:</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="TituloRubricaAE" style="width: 20%;">
                                <label>
                                    <b>Insatisfactorio</b></label>
                            </td>
                            <td class="TituloRubricaAE" style="width: 20%;">
                                <label>
                                    <b>Básico</b></label>
                            </td>
                            <td class="TituloRubricaAE" style="width: 25%;">
                                <label>
                                    <b>Competente</b></label>
                            </td>
                            <td class="TituloRubricaAE" style="width: 35%;">
                                <label>
                                    <b>Destacado</b></label>
                            </td>
                        </tr>
                        <tr>
                            <td class="RubricaAE">
                                <label>
                                    Los indicadores <b>no forman parte</b> de mi práctica habitual.</label>
                            </td>
                            <td class="RubricaAE">
                                <label>
                                    Los indicadores se evidencian <b>ocasionalmente</b> en mi práctica habitual.</label>
                            </td>
                            <td class="RubricaAE">
                                <label>
                                    Los indicadores se evidencian <b>frecuentemente</b> en mi práctica habitual.</label>
                            </td>
                            <td class="RubricaAE">
                                <label>
                                    Los indicadores se evidencian <b>frecuentemente</b> en mi práctica habitual,  y además <b>llevo a cabo otras prácticas que hacen sobresaliente mi desempeño.</b></label>
                            </td>
                        </tr>
                    </table>
                    <%--======================= Titulo Dominio =======================--%>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Dominio A: Preparación de la enseñanza</label>
                            </td>
                        </tr>
                    </table>
                    <%--======================= Preguntas Dominio A =======================--%>

                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio A.2</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>1</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Conozco las características, conocimientos y experiencias de mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 1--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En mi trabajo <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Preparo mis clases considerando las fortalezas y debilidades de mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_1_1" name="rec_AE_P1_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_1_2" name="rec_AE_P1_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_1_3" name="rec_AE_P1_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_1_4" name="rec_AE_P1_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Establezco relaciones entre los contenidos abordados y el contexto familiar y cultural de mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_2_1" name="rec_AE_P1_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_2_2" name="rec_AE_P1_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_2_3" name="rec_AE_P1_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_2_4" name="rec_AE_P1_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Pueden aportar desde sus experiencias en las actividades propuestas.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_3_1" name="rec_AE_P1_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_3_2" name="rec_AE_P1_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_3_3" name="rec_AE_P1_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_3_4" name="rec_AE_P1_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Pueden comprender los contenidos e involucrarse en las actividades, independiente de sus distintos ritmos de aprendizaje.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_4_1" name="rec_AE_P1_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_4_2" name="rec_AE_P1_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_4_3" name="rec_AE_P1_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P1_4_4" name="rec_AE_P1_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 1--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Conozco las características, conocimientos y experiencias de mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P1" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P1" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio A.4</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>2</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Tengo en cuenta las características de mis estudiantes y el marco curricular cuando planifico mis clases?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 2--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Selecciono actividades y recursos variados para involucrar a todos mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_1_1" name="rec_AE_P2_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_1_2" name="rec_AE_P2_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_1_3" name="rec_AE_P2_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_1_4" name="rec_AE_P2_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Planifico actividades que abordan los contenidos y habilidades desde distintas perspectivas.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_2_1" name="rec_AE_P2_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_2_2" name="rec_AE_P2_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_2_3" name="rec_AE_P2_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_2_4" name="rec_AE_P2_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Se motivan con las actividades propuestas, realizándolas con interés.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_3_1" name="rec_AE_P2_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_3_2" name="rec_AE_P2_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_3_3" name="rec_AE_P2_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_3_4" name="rec_AE_P2_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Logran comprender un mismo contenido desde distintas perspectivas.<label class="popupAyuda" data-title="Ej.: incorporan visiones de distintos autores, toman en cuenta distintos puntos de vista, reconocen su opinión personal, etc.">
                                            <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_4_1" name="rec_AE_P2_4" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_4_2" name="rec_AE_P2_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_4_3" name="rec_AE_P2_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P2_4_4" name="rec_AE_P2_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 2--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Tengo en cuenta las características de mis estudiantes y el marco curricular cuando planifico mis clases?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P2" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P2" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio A.5</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>3</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Mis evaluaciones son coherentes con lo planificado y permiten a todos mis estudiantes demostrar lo aprendido?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 3--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                <b>Durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Diseño estrategias de evaluación coherentes con lo trabajado en clases.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_1_1" name="rec_AE_P3_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_1_2" name="rec_AE_P3_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_1_3" name="rec_AE_P3_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_1_4" name="rec_AE_P3_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Diseño diversas instancias de evaluación para que todos mis estudiantes puedan demostrar lo aprendido.

                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_2_1" name="rec_AE_P3_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_2_2" name="rec_AE_P3_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_2_3" name="rec_AE_P3_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_2_4" name="rec_AE_P3_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Las <b>evaluaciones que aplico</b> (formativas y/o sumativas)...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Me permiten hacer adecuaciones durante el proceso de aprendizaje.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_3_1" name="rec_AE_P3_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_3_2" name="rec_AE_P3_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_3_3" name="rec_AE_P3_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_3_4" name="rec_AE_P3_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Me permiten conocer el nivel de logro de mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_4_1" name="rec_AE_P3_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_4_2" name="rec_AE_P3_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_4_3" name="rec_AE_P3_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P3_4_4" name="rec_AE_P3_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <%--Pregunta con opciones dropdownlist 3--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Mis evaluaciones son coherentes con lo planificado y permiten a todos mis estudiantes demostrar lo aprendido?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P3" style="width: 150px; padding-top: 5px; padding-bottom: 5px">
                                <asp:DropDownList ID="rec_AE_P3" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <%--======================= Titulo Dominio =======================--%>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Dominio B: Creación de un ambiente propicio para el aprendizaje</label>
                            </td>
                        </tr>
                    </table>
                    <%--======================= Preguntas Dominio B =======================--%>

                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio B.1</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>4</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Promuevo un clima de aceptación, confianza y respeto entre mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 4--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Genero un espacio de confianza donde todos pueden plantear sus puntos de vista.
                                                <label class="popupAyuda" data-title="Ej.: los escucho con atención, acojo sus intervenciones con interés y respeto, trato de enriquecer sus comentarios, etc.">
                                                    <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_1_1" name="rec_AE_P4_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_1_2" name="rec_AE_P4_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_1_3" name="rec_AE_P4_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_1_4" name="rec_AE_P4_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Estimulé que mis estudiantes se conozcan y valoren sus diferencias.
                                    <label class="popupAyuda" data-title="Ej.: establezco equipos de trabajo, los cambio de puesto para que se conozcan, doy espacios para intercambiar opiniones, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_2_1" name="rec_AE_P4_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_2_2" name="rec_AE_P4_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_2_3" name="rec_AE_P4_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_2_4" name="rec_AE_P4_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Participan y aportan en las actividades sin miedo a equivocarse.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_3_1" name="rec_AE_P4_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_3_2" name="rec_AE_P4_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_3_3" name="rec_AE_P4_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_3_4" name="rec_AE_P4_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Escuchan atentamente las intervenciones de sus compañeros y las mías.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_4_1" name="rec_AE_P4_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_4_2" name="rec_AE_P4_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_4_3" name="rec_AE_P4_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P4_4_4" name="rec_AE_P4_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 4--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Promuevo un clima de aceptación, confianza y respeto entre mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P4" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P4" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio B.2</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>5</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Tengo altas expectativas de todos mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 5--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Estimulé el esfuerzo y la perseverancia para realizar trabajos de alta calidad.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_1_1" name="rec_AE_P5_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_1_2" name="rec_AE_P5_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_1_3" name="rec_AE_P5_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_1_4" name="rec_AE_P5_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Me preocupo de estimular su curiosidad y vincularla con lo que estamos viendo en clases.
                                    <label class="popupAyuda" data-title="Ej.: realizo preguntas y les ayudo a cuestionarse, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_2_1" name="rec_AE_P5_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_2_2" name="rec_AE_P5_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_2_3" name="rec_AE_P5_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_2_4" name="rec_AE_P5_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Trabajan de manera autónoma, opinan y buscan sus propias soluciones.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_3_1" name="rec_AE_P5_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_3_2" name="rec_AE_P5_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_3_3" name="rec_AE_P5_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_3_4" name="rec_AE_P5_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Saben que creo en ellos y confío en que pueden desarrollar al máximo su potencial.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_4_1" name="rec_AE_P5_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_4_2" name="rec_AE_P5_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_4_3" name="rec_AE_P5_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P5_4_4" name="rec_AE_P5_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 5--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Tengo altas expectativas de todos mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P5" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P5" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio B.3</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>6</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Promuevo normas de convivencia en el aula?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 6--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Genero acuerdos y normas de convivencia junto a mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_1_1" name="rec_AE_P6_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_1_2" name="rec_AE_P6_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_1_3" name="rec_AE_P6_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_1_4" name="rec_AE_P6_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Abordo los quiebres de convivencia (ej. peleas, interrupciones a la clase, etc.) como una oportunidad de aprendizaje.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_2_1" name="rec_AE_P6_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_2_2" name="rec_AE_P6_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_2_3" name="rec_AE_P6_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_2_4" name="rec_AE_P6_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Entienden que las normas y acuerdos favorecen el aprendizaje de todos.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_3_1" name="rec_AE_P6_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_3_2" name="rec_AE_P6_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_3_3" name="rec_AE_P6_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_3_4" name="rec_AE_P6_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Trabajan en un ambiente organizado que les permite concentrarse en las actividades.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_4_1" name="rec_AE_P6_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_4_2" name="rec_AE_P6_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_4_3" name="rec_AE_P6_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P6_4_4" name="rec_AE_P6_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 6--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Promuevo normas de convivencia en el aula?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P6" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P6" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <%--======================= Titulo Dominio =======================--%>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Dominio C: Enseñanza para el aprendizaje de todos los estudiantes</label>
                            </td>
                        </tr>
                    </table>
                    <%--======================= Preguntas Dominio C =======================--%>

                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio C.2</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>7</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Suelo utilizar estrategias de enseñanza que son desafiantes y significativas para mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 7--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Utilizo variados recursos para lograr un aprendizaje que sea significativo.
                                    <label class="popupAyuda" data-title="Ej.: experimentación, análisis de casos, contexto de mis estudiantes, analogías, TICS, u otros.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_1_1" name="rec_AE_P7_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_1_2" name="rec_AE_P7_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_1_3" name="rec_AE_P7_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_1_4" name="rec_AE_P7_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Propongo a mis estudiantes que apliquen lo aprendido a situaciones nuevas.
                                    <label class="popupAyuda" data-title="Ej.: que resuelvan problemas de la vida cotidiana, que lo apliquen a otras asignaturas, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_2_1" name="rec_AE_P7_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_2_2" name="rec_AE_P7_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_2_3" name="rec_AE_P7_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_2_4" name="rec_AE_P7_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Se mantienen interesados en las actividades y contenidos que les planteo.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_3_1" name="rec_AE_P7_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_3_2" name="rec_AE_P7_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_3_3" name="rec_AE_P7_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_3_4" name="rec_AE_P7_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Buscan activamente distintas soluciones a los desafíos que les planteo.
                                            <label class="popupAyuda" data-title="Ej.: consultan distintas fuentes, piensan en conjunto, hacen preguntas, etc.">
                                                <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_4_1" name="rec_AE_P7_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_4_2" name="rec_AE_P7_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_4_3" name="rec_AE_P7_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P7_4_4" name="rec_AE_P7_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 7--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Suelo utilizar estrategias de enseñanza que son desafiantes y significativas para mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P7" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P7" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio C.4</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>8</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Aprovecho el tiempo disponible en mis clases, dedicándolo al aprendizaje de mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 8--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Ocupo el tiempo de la clase en actividades que contribuyen directamente al aprendizaje.
                                            <label class="popupAyuda" data-title="Ej.: evito gastar tiempo ordenando a los alumnos, repartiendo materiales, etc.">
                                                <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_1_1" name="rec_AE_P8_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_1_2" name="rec_AE_P8_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_1_3" name="rec_AE_P8_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_1_4" name="rec_AE_P8_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Voy adaptando los tiempos planificados de acuerdo a los avances y dificultades que observo en mis estudiantes.
                                    <label class="popupAyuda" data-title="Ej.: si el contenido es muy complejo, o bien, muy fácil, si los alumnos se interesan o involucran especialmente en una actividad, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_2_1" name="rec_AE_P8_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_2_2" name="rec_AE_P8_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_2_3" name="rec_AE_P8_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_2_4" name="rec_AE_P8_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                La mayor parte del tiempo se encuentran activos y ocupados en las actividades propias de la clase.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_3_1" name="rec_AE_P8_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_3_2" name="rec_AE_P8_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_3_3" name="rec_AE_P8_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_3_4" name="rec_AE_P8_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Pueden realizar las actividades de acuerdo a sus ritmos de aprendizaje.
                                    <label class="popupAyuda" data-title="Ej.: no les falta ni les sobra demasiado tiempo para realizar las actividades.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_4_1" name="rec_AE_P8_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_4_2" name="rec_AE_P8_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_4_3" name="rec_AE_P8_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P8_4_4" name="rec_AE_P8_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 8--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Aprovecho el tiempo disponible en mis clases, dedicándolo al aprendizaje de mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P8" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P8" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio C.5</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>9</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Suelo utilizar estrategias que promueven el desarrollo del pensamiento de mis estudiantes?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 9--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En las clases que he realizado <b>durante este semestre...</b>
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Realizo actividades que favorecen el pensamiento crítico y reflexivo de mis estudiantes y no solo la transmisión de contenidos.
                                    <label class="popupAyuda" data-title="Ej.: hago debates, análisis de textos u obras de arte, investigación sobre diversos temas, intercambio de opiniones, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_1_1" name="rec_AE_P9_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_1_2" name="rec_AE_P9_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_1_3" name="rec_AE_P9_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_1_4" name="rec_AE_P9_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Aprovecho los errores de mis estudiantes como oportunidades para enriquecer su aprendizaje.
                                <label class="popupAyuda" data-title="Ej.: les pido que expliquen su pensamiento, los oriento para que ellos mismos reconozcan la fuente de su error, construimos en conjunto una nueva respuesta, etc.">
                                    <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_2_1" name="rec_AE_P9_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_2_2" name="rec_AE_P9_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_2_3" name="rec_AE_P9_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_2_4" name="rec_AE_P9_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Demuestran una actitud curiosa, crítica y reflexiva.
                                    <label class="popupAyuda" data-title="Ej.: plantean preguntas que van más allá de los contenidos, proponen nuevos puntos de vista, etc.">
                                        <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_3_1" name="rec_AE_P9_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_3_2" name="rec_AE_P9_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_3_3" name="rec_AE_P9_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_3_4" name="rec_AE_P9_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Son capaces de plantear opiniones o hacer propuestas autónomas y/o creativas.
                                <label class="popupAyuda" data-title="Ej.: comparten sus ideas sin miedo a equivocarse, muestran confianza en sus capacidades y juicios, etc.">
                                    <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_4_1" name="rec_AE_P9_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_4_2" name="rec_AE_P9_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_4_3" name="rec_AE_P9_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P9_4_4" name="rec_AE_P9_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 9--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Suelo utilizar estrategias que promueven el desarrollo del pensamiento de mis estudiantes?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P9" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P9" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <%--======================= Titulo Dominio =======================--%>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;Dominio D: Responsabilidades profesionales</label>
                            </td>
                        </tr>
                    </table>
                    <%--======================= Preguntas Dominio D =======================--%>

                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio D.1</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>10</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Analizo y reflexiono regularmente sobre mi práctica?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 10--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="4" class="ItemPregAE_SubPreg">
                                            <label>
                                                En <b>mi práctica</b> como docente... 
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">Converso con colegas para ayudarme a reflexionar sobre mi quehacer como docente.
                                <label class="popupAyuda" data-title="Ej.: sobre estrategias para un contenido difícil, actualización de contenidos, motivación de los alumnos, etc.">
                                    <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_1_1" name="rec_AE_P10_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_1_2" name="rec_AE_P10_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_1_3" name="rec_AE_P10_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_1_4" name="rec_AE_P10_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">Busco activamente oportunidades para desarrollar áreas en las que necesito mayor información o apoyo.
                                <label class="popupAyuda" data-title="Ej.: busco material didáctico o fuentes bibliográficas, consulto a otros colegas, directivos o coordinadores, asisto a cursos o capacitaciones, etc.">
                                    <img src="../../Imagenes/Images/tooltip.png" alt="tooltip" /></label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_2_1" name="rec_AE_P10_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_2_2" name="rec_AE_P10_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_2_3" name="rec_AE_P10_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_2_4" name="rec_AE_P10_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Ajusto mis planificaciones a partir de los aprendizajes que están logrando mis alumnos.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_3_1" name="rec_AE_P10_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_3_2" name="rec_AE_P10_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_3_3" name="rec_AE_P10_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_3_4" name="rec_AE_P10_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Analizo el nivel de participación e interés de mis estudiantes para adaptar mis metodologías.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_4_1" name="rec_AE_P10_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_4_2" name="rec_AE_P10_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_4_3" name="rec_AE_P10_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P10_4_4" name="rec_AE_P10_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 10--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Analizo y reflexiono regularmente sobre mi práctica?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P10" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P10" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio D.2</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>11</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Construyo relaciones colaborativas y de equipo con mis colegas?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 11--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En <b>mi práctica</b> como docente...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Pido opiniones o consejos a colegas, coordinadores o directivos cuando enfrento un problema.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_1_1" name="rec_AE_P11_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_1_2" name="rec_AE_P11_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_1_3" name="rec_AE_P11_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_1_4" name="rec_AE_P11_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Trabajo en colaboración con otros colegas, diseñando o implementando ideas o proyectos.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_2_1" name="rec_AE_P11_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_2_2" name="rec_AE_P11_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_2_3" name="rec_AE_P11_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_2_4" name="rec_AE_P11_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en la percepción que tienen <b>mis colegas</b> de mi...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Mis colegas consideran que estoy disponible para escucharlos y apoyarlos en su práctica pedagógica.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_3_1" name="rec_AE_P11_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_3_2" name="rec_AE_P11_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_3_3" name="rec_AE_P11_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_3_4" name="rec_AE_P11_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Mis colegas consideran que soy un aporte en instancias de reflexión y trabajo grupal.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_4_1" name="rec_AE_P11_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_4_2" name="rec_AE_P11_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_4_3" name="rec_AE_P11_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P11_4_4" name="rec_AE_P11_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 11--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Construyo relaciones colaborativas y de equipo con mis colegas?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P11" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P11" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="EspaciosPreg"></div>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE PregCriterioAE" style="width: 50px;" align="center">
                                <label>Preg.</label>
                            </td>
                            <td colspan="2" class="PreguntasAE PregCriterioAE" align="right">
                                <label>Criterio D.3</label>
                            </td>
                        </tr>
                        <tr>
                            <td class="PreguntasAE TituloPregG" align="center">
                                <label>12</label>
                            </td>
                            <td colspan="2" class="PreguntasAE">
                                <label>
                                    &nbsp;&nbsp;&nbsp;¿Me preocupo por orientar y apoyar a mis alumnos en su desarrollo personal?
                                </label>
                            </td>
                        </tr>
                        <%--Preguntas con opciones radio 12--%>
                        <tr>
                            <td colspan="3">
                                <table class="AE_Tabla">
                                    <tr>
                                        <td class="DetallePregAE_SubTitulo" style="width: 230px;">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;</label>
                                        </td>
                                        <td class="DetallePregAE_SubTitulo">
                                            <label class="popupAyudaIndicador">
                                                &nbsp;Indicadores :
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Inicial</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                En<br />
                                                desarrollo</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">Instalado</label>
                                        </td>
                                        <td class="DetallePregAE_Radio">
                                            <label class="popupAyudaIndicador2">
                                                No sé/<br />
                                                No aplica</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                En <b>mi práctica</b> como docente...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Identifico y destaco las fortalezas y logros de mis estudiantes.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_1_1" name="rec_AE_P12_1" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_1_2" name="rec_AE_P12_1" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_1_3" name="rec_AE_P12_1" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_1_4" name="rec_AE_P12_1" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Busco cómo apoyar a mis estudiantes de acuerdo a las necesidades que veo en ellos, ya sea directamente o a través de otros.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_2_1" name="rec_AE_P12_2" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_2_2" name="rec_AE_P12_2" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_2_3" name="rec_AE_P12_2" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_2_4" name="rec_AE_P12_2" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2" class="ItemPregAE_SubPreg">
                                            <label>
                                                Cuando pienso en <b>mis estudiantes</b>, he observado que...
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Mis estudiantes han compartido conmigo sus intereses y motivaciones.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_3_1" name="rec_AE_P12_3" runat="server" value="1" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_3_2" name="rec_AE_P12_3" runat="server" value="2" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_3_3" name="rec_AE_P12_3" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_3_4" name="rec_AE_P12_3" runat="server" value="4" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="DetallePregAE_SubPreg">
                                            <label>
                                                Mis estudiantes han compartido conmigo sus necesidades de apoyo o dificultades.
                                            </label>
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_4_1" name="rec_AE_P12_4" runat="server" value="1" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_4_2" name="rec_AE_P12_4" runat="server" value="2" />

                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_4_3" name="rec_AE_P12_4" runat="server" value="3" />
                                        </td>
                                        <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                            <input type="radio" id="rec_AE_P12_4_4" name="rec_AE_P12_4" runat="server" value="4" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%--Pregunta con opciones dropdownlist 12--%>
                        <tr>
                            <td colspan="2" class="PreguntasAE_Down">
                                <label class="popupAyuda" data-title="Recuerde: seleccione un nivel de desempeño para esta pregunta.">
                                    &nbsp;¿Me preocupo por orientar y apoyar a mis alumnos en su desarrollo personal?
                                </label>
                            </td>
                            <td class="PreguntasAE_Down2" id="drop_AE_P12" style="width: 150px; padding-top: 10px; padding-bottom: 10px">
                                <asp:DropDownList ID="rec_AE_P12" runat="server" Width="100%" CssClass="ui-widget-content ui-corner-all">
                                    <asp:ListItem Value=" ">Seleccione</asp:ListItem>
                                    <asp:ListItem Value="I">Insatisfactorio</asp:ListItem>
                                    <asp:ListItem Value="B">Básico</asp:ListItem>
                                    <asp:ListItem Value="C">Competente</asp:ListItem>
                                    <asp:ListItem Value="D">Destacado</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>

                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE" align="center">
                                <label>
                                    <b>Consideraciones contextuales</b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE_Down">
                                <label>
                                    Si usted estima que existen situaciones o condiciones de la escuela o del estudiantado que afectan positiva o negativamente su labor docente y que deben ser consideradas en la evaluación de su desempeño profesional, por favor descríbalas brevemente en el siguiente recuadro
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <table class="ui-widget" style="width: 100%;" border="0">
                                    <tr>
                                        <td colspan="2" style="padding-right: 5px">
                                            <textarea id="rec_AE_FUND_CONS_CONTEXT" name="rec_AE_FUND_CONS_CONTEXT" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1500" style="width: 100%; overflow-y: auto" placeholder="Escriba aquí su respuesta:"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label id="tf_AE_FUND_CONS_CONTEXT"></label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <%--======================= Titulo Reflexión =======================--%>
                    <table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE" align="center">
                                <label>
                                    <%--<b>Aquí terminan las preguntas que determinarán su puntaje en la Autoevaluación.</b>--%>
                                    <b>Usted ha terminado su Autoevaluación.</b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <fieldset class="pdFondoT1">
                        <table class="ui-widget" style="width: 100%;">
                            <tr>
                                <td class="TituloPregG_AE" align="center">
                                    <label>
                                        <b>Diálogo Profesional (sección voluntaria)</b>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-size: 1.1em;">
                                    <p style="text-align: center">La sección que sigue es voluntaria y <u>no tendrá incidencia</u> en su puntaje. Su propósito es
                                        <br />
                                        generar una posibilidad de dialogo entre usted y sus directivos. </p>
                                </td>
                            </tr>
                        </table>
                        <table class="ui-widget" style="width: 100%;">
                            <tr>
                                <td rowspan="2" style="background: #3e7ac4; color: white; font-size: 1.3em; padding: 1.0em .5em;">
                                    <label>¿Desea completarla?</label>
                                </td>
                                <td class="DetallePregAE_SubTitulo">
                                    <label style="text-align: center">&nbsp;Sí</label>
                                </td>
                                <td class="DetallePregAE_SubTitulo">
                                    <label style="text-align: center">&nbsp;No</label>
                                </td>
                            </tr>
                            <tr>
                                <td class="DetallePregAE_SubPreg" style="text-align: center; font-size: 1.3em">
                                    <input type="radio" id="radio_si" name="radio_si" runat="server" value="OpS" onclick="OpS();" />
                                </td>
                                <td class="DetallePregAE_SubPreg" style="text-align: center;">
                                    <input type="radio" id="radio_no" name="radio_no" runat="server" value="OpN" onclick="OpN();" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <%--<fieldset class="pdFondoT1" id="dialog_vol" runat="server">--%>
                                    <table class="ui-widget" style="width: 100%;" border="0" id="dialog_vol">
                                        <tr>
                                            <td style="font-size: 1.1em;">
                                                <p style="text-align: justify">Clave en el desarrollo profesional es la capacidad de <b>mirar críticamente la práctica cotidiana.</b> Este ejercicio se ve enriquecido cuando podemos <b>compartir con docentes y directivos</b> distintos puntos de vista sobre la manera en que enseñamos, las concepciones sobre cómo aprenden los estudiantes, las metodologías empleadas, entre otros.</p>
                                                <p style="text-align: justify">Este diálogo abre un espacio de crecimiento para todos los que participan, docentes y directivos. En esta sección le invitamos a plantear una temática sobre la cual le gustaría conversar con sus directivos:</p>
                                            </td>

                                        </tr>
                                        <tr>
                                            <td style="background: #3e7ac4; color: white; font-size: 1.1em; padding: 1.0em .5em">
                                                <label>
                                                    Plantee a sus directivos una inquietud, pregunta o idea, que usted encuentra importante para su práctica pedagógica o para el aprendizaje de sus estudiantes.
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="font-size: 1.1em;">
                                                <p style="text-align: justify"><b>Lo que plantee será entregado (tal como usted lo ingresó) a sus directivos</b> a través de la Plataforma Docentemás, y se les pedirá que lo retroalimenten. <b>Usted recibirá esa retroalimentación en su Informe de Evaluación Individual</b>.</p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table class="ui-widget" style="width: 100%;" border="0">
                                                    <tr>
                                                        <td colspan="2" style="padding-right: 5px">
                                                            <textarea id="rec_AE_FUND_APORTE" name="rec_AE_FUND_APORTE" runat="server" class="ui-widget-content ui-corner-all" rows="9" cols="100" maxlength="1200" style="width: 100%; overflow-y: auto;" placeholder="Escriba aquí a sus directivos:"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <label id="tf_AE_FUND_APORTE"></label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
<%--                                        <tr>
                                            <td colspan="2">
                                                <label style="text-align: justify"><b>Su respuesta será entregada a sus directivos</b> a través de la Plataforma Docentemás, y se les pedirá que la retroalimente. <b>Usted recibirá esa retroalimentación en su Informe de Evaluación Individual</b>.</label>
                                            </td>
                                        </tr>--%>
                                        <tr>
                                            <td align="center">
                                                <br />
                                                <br />
                                                <table style="width: 750px; border: black 1px solid;" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <img src="../../Imagenes/Images/PAAE02.jpg" />
                                                        </td>
                                                        <td style="font-size: 1.1em; padding: 0.5em; text-align: left" valign="top">
                                                            <label><b>Recuerde, sus directivos conocerán su respuesta. </b>Antes de terminarla, revise si:</label>
                                                            <%--<br />
                                                            <label>Antes de terminarla, revise si:</label>--%>
                                                            <ul style="list-style: disc">
                                                                <li>¿Es clara, se entiende lo central?<br /></li>
                                                                <li>¿Da pie para conversar con su director/a o jefe de UTP?<br /></li>
                                                                <li>¿Refleja una preocupación importante para usted? <br /></li>
                                                            </ul>
                                                            <label>Si aún tiene dudas, los ejemplos que siguen podrían ayudarle a pensar en una temática importante para usted y cómo plantearla.</label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <img style="width: 750px" src="../../Imagenes/Images/AE_Imagen_Plataforma_Docente.png" />
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                    <%--</fieldset>--%>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                    <br />
                    <br />
                    <%--======================= Titulo Consideraciones Contextuales =======================--%>
                    <%--<table class="ui-widget" style="width: 100%;" border="0">
                        <tr>
                            <td class="TituloPregG_AE" align="center">
                                <label>
                                    <b>Consideraciones contextuales</b>
                                </label>
                            </td>
                        </tr>
                    </table>
                    <table class="ui-widget AE_Tabla" style="width: 100%;" border="0">
                        <tr>
                            <td class="PreguntasAE_Down">
                                <label>
                                    Si usted estima que existen situaciones o condiciones de la escuela o del estudiantado que afectan positiva o negativamente su labor docente y que deben ser consideradas en la evaluación de su desempeño profesional, por favor descríbalas brevemente en el siguiente recuadro
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <table class="ui-widget" style="width: 100%;" border="0">
                                    <tr>
                                        <td colspan="2" style="padding-right: 5px">
                                            <textarea id="rec_AE_FUND_CONS_CONTEXT" name="rec_AE_FUND_CONS_CONTEXT" runat="server" class="ui-widget-content ui-corner-all" rows="5" cols="100" maxlength="1500" style="width: 100%; overflow-y: auto" placeholder="Escriba aquí su respuesta:"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label id="tf_AE_FUND_CONS_CONTEXT"></label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>--%>
                </fieldset>
                <table style="width: 100%;" border="0">
                    <tr>
                        <td align="right">
                            <img alt="Guardar" src="../../Imagenes/Images/guardar-off.jpg" onmouseover="this.src='../../Imagenes/Images/guardar-on.jpg'"
                                onmouseout="this.src='../../Imagenes/Images/guardar-off.jpg'" onclick="Guardar()" class="guardar" id="guardar2" runat="server" /></td>
                    </tr>
                </table>
                <%--======================= Fin FRAMEWORK rec fields declaration ======================= --%>
                <input type="hidden" id="rec_ID_PERIODO" runat="server" />
                <input type="hidden" id="rec_RUT_DOCENTE" runat="server" />
                <input type="hidden" id="rec_ID_EVALUACION" runat="server" />
                <input type="hidden" id="boRegistryMode" runat="server" value="new" />
                <input type="hidden" id="ErrorMessage" runat="server" value="" />
                <input type="hidden" id="MyRowstamp" name="MyRowstamp" runat="server" />
                <input type="hidden" id="rec_AE_P1_T" runat="server" />
                <input type="hidden" id="rec_AE_P2_T" runat="server" />
                <input type="hidden" id="rec_AE_P3_T" runat="server" />
                <input type="hidden" id="rec_AE_P4_T" runat="server" />
                <input type="hidden" id="rec_AE_P5_T" runat="server" />
                <input type="hidden" id="rec_AE_P6_T" runat="server" />
                <input type="hidden" id="rec_AE_P7_T" runat="server" />
                <input type="hidden" id="rec_AE_P8_T" runat="server" />
                <input type="hidden" id="rec_AE_P9_T" runat="server" />
                <input type="hidden" id="rec_AE_P10_T" runat="server" />
                <input type="hidden" id="rec_AE_P11_T" runat="server" />
                <input type="hidden" id="rec_AE_P12_T" runat="server" />
                <input type="hidden" id="OpSN" runat="server" />
                <span id="msgSaved"></span>
            </div>
        </div>
        <div id="info-auto">
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td align="center">
                        <img alt="" src="../../Imagenes/Images/AEVentanaInicial.png" />
                    </td>
                </tr>
            </table>
        </div>
        <input type="hidden" id="acceso" name="acceso" value="V" runat="server" />
    </form>
    <input type="hidden" id="rec_NOMBRE_TABLA" name="rec_NOMBRE_TABLA" value="AE" runat="server" />
    <input type="hidden" id="rec_ID_TABLA" name="rec_ID_TABLA" value="" runat="server" />
    <input type="hidden" id="Cod_Nivel" name="Cod_Nivel" runat="server" />
    <input type="hidden" id="fechaAccceso" name="Cod_Nivel" runat="server" />
    <input type="hidden" id="datefinal" name="datefinal" runat="server" />
</body>
</html>
