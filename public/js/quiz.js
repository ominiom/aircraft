$(document).ready(function() {

  var Quiz = {
    questions: $('.section.question'),
    score: {
      possible: $('.section.question').length,
      current: 0,
      attempted: 0
    },
    answer: function(answer) {
      Quiz.score.attempted++;
      if( $(answer).hasClass('correct') ) Quiz.score.current++;
      $(answer).parents('.section.question').slideUp();
      if( Quiz.score.attempted == Quiz.score.possible ) {
        $('#heading-1').slideUp(500, function() {
          $('#heading-2').slideDown();
          $('.score span:first').text(Quiz.score.current)
          $('.score span:last').text(Quiz.score.possible)
          $('.score').slideDown()
        })
      }
    }
  };

  $('.question .answers li a').click(function() {
    Quiz.answer($(this).parent('li'))
  })

});