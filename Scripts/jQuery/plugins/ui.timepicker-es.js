/* Inicialización en español para la extensión 'UI date picker' para jQuery. */
/* Traducido por Vester (xvester@gmail.com). */
jQuery(function($){
        $.timepicker.regional['es'] = {
                timeOnlyTitle: 'Horario',
                timeText: 'Horario',
                hourText: 'Horas',
                minuteText: 'Minutos',
                secondText: 'Segundos',
                millisecText: 'Milisegundos',
                timezoneText: 'Zona horaria',
                currentText: 'Actual',
                closeText: 'OK',
                timeFormat: 'H:mm',
                amNames: ['AM', 'A'],
                pmNames: ['PM', 'P'],
                isRTL: false
            };
            $.timepicker.setDefaults($.timepicker.regional['es']);
});