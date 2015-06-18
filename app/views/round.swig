{% extends 'layout.swig' %}

{% block content %}
<div class="ui center aligned vertically divided grid">
  <div class="four wide column">
    <div class="row">
      <h1 class="ui center algined header">
        {{ question.itemName }}
      </h1>
      <img src="/img/rounds/{{ question.image }}" />
    </div>
  </div>
  <div class="twelve wide column">
    <div class="ui center aligned grid">
      <div class="six wide column">
        <div class="ui styled fluid accordion question" id="q1">
          <div class="ui header title" data-question="1" data-questiontype="{{ question.questions[0].type }}" data-qtype="{{ question.questions[0].qType }}">
            {{ question.questions[0].text }}
          </div>
          <div class="content">
            <p>{{ question.questions[0].answer }}</p>
          </div>
        </div>
      </div>
      <div class="four wide column">
        <img class="ui large image" src="/img/central.jpg">
      </div>
      <div class="six wide column">
        <div class="ui styled fluid accordion question" id="q2">
          <div class="ui header title" data-question="2" data-questiontype="{{ question.questions[1].type }}" data-qtype="{{ question.questions[1].qType }}">
            {{ question.questions[1].text }}
          </div>
          <div class="content">
            <p>{{ question.questions[1].answer }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>


</div>
<div class="ui stackable center aligned grid segment">
  <div class="four wide column"></div>
  <div class="four wide column">
    <div class="ui huge green button" data-choice="keep">Keep</div>
  </div>
  <div class="ui vertical divider">or</div>
  <div class="four wide column">
    <div class="ui huge red button" data-choice="discard">Discard</div>
  </div>
  <div class="four wide column"></div>
</div>



<form class="round-form" name="answers" method="post" action="./round">
  <input type="text" name="userId" value="{{ question.userId }}" />
  <input type="number" name="roundNumber" value="{{ question.roundNumber }}" />
  <input type="text" name="questionTypePicked" />
  <input type="text" name="qTypePicked" />
  <input type="number" name="questionTime" />
  <input type="text" name="decision" />
  <input type="number" name="decisionTime" />

  <input type="submit" id="submit-form" />
</form>

<script>
var start,
  choiceQuestion = 0,
  decision,
  questionTime = 0,
  decisionTime = 0,
  questionTypePicked = 'neither',
  qTypePicked = 'neither';
var f = document.forms[0];

$(document).ready(function() {
  start = new Date();
});

function reveal(e) {
  questionTypePicked = e.target.dataset.questiontype;
  qTypePicked = e.target.dataset.qtype;
  questionTime = e.timeStamp - start;
  $(e.target).accordion('open');
  $('.question').off('click');

  var other;
  choiceQuestion == '1' ? other = $('#q2') : other = $('#q1');
  other.children('.header.title').addClass('disabled');
};

$('.question').click(reveal);

function submit(e) {
  decision = e.target.dataset.choice;
  decisionTime = e.timeStamp - start;

  f.questionTime.value = questionTime;
  f.questionTypePicked.value = questionTypePicked;
  f.qTypePicked.value = qTypePicked;

  f.decision.value = decision;
  f.decisionTime.value = decisionTime;
  $('.question').off('click').children('.header.title').addClass('disabled');
  $('.button').off('click').addClass('disabled');
  f.submit();
}

$('.button').click(submit);
</script>

{% endblock %}
