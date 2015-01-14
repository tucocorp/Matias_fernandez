moment.locale('es', {
  calendar: {
    sameDay: '[hoy]',
    nextDay: '[mañana]',
    nextWeek: 'dddd',
    lastDay: '[ayer]',
    lastWeek: function () {
      return '[el] dddd [pasado a la' + ((this.hours() !== 1) ? 's' : '') + '] LT';
    },
    sameElse : 'L'
  }
});

Handlebars.registerHelper('nl2br', function(text) {
  text = Handlebars.Utils.escapeExpression(text);
  text = text.toString();
  text = text.replace(/(\r\n|\n|\r)/gm, '<br>');
  return new Handlebars.SafeString(text);
});

Handlebars.registerHelper('shortWord', function(word, maxLength){
  if(word == null) return '';
  if( word.length >= maxLength ){
    word = word.substr(0, maxLength) + '...';
  }
  return word;
});

Handlebars.registerHelper('htmlSafe', function(text){
  return new Handlebars.SafeString(text);
});

Handlebars.registerHelper('round', function(number, decimals, transform){
  var result = number;
  if( number !== null ){
    result = number.toFixed(decimals);
  }else{
    result = number;
  }

  if( result !== null && transform === 1 ){
    result = result.toString().replace('.', ',');
  }

  return result;
});

Handlebars.registerHelper('if_lteq', function(context, options) {
  if (context <= options.hash.compare)
    return options.fn(this);
  return options.inverse(this);
});

//  format an ISO date using Moment.js
//  http://momentjs.com/
//  moment syntax example: moment(Date("2011-07-18T15:50:52")).format("MMMM YYYY")
//  usage: {{dateFormat creation_date format="MMMM YYYY"}}
Handlebars.registerHelper('dateFormat', function(context, block) {
  if (window.moment) {
    var f = block.hash.format || "MMM Do, YYYY";
    return moment(context).format(f);
  }else{
    return context;   //  moment plugin not available. return data as is.
  };
});

// Handlebars.registerHelper('expirationLapse', function(context, block) {
//   var elapsed = app.helpers.expirationLapse(context);

//   if(block.hash['duration'] == true){
//     var duration = 'duración: ' + moment.duration(app.helpers.durationDays(context), 'days').humanize();
//   }else{
//     var duration = ''
//   }

//   var str = "<span class=' date " + elapsed.style + "'>(" + elapsed.elapsed + ", "+ duration +")</span>";
//   return new Handlebars.SafeString(str);
// });

// Handlebars.registerHelper('durationDays', function(context, block) {
//   var duration = app.helpers.durationDays(context);
//   return moment.duration(duration, 'days').humanize()
// });
