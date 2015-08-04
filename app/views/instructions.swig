{% extends 'layout.swig' %}

{% block content %}
<div class="ui center aligned vertically divided grid">
  <div class="eight wide column">
    <p>You are about to be a participant in the first study to use this decision-making task. That means we need your help to develop this task into an accurate measure of how people make decisions about their possessions. All you have to do to help us with this goal is try to make decisions in this task like you would at home. Knowledge of how people make these decisions has important implications for consumer behavior, social psychology, and mental health. Thank you for your help!</p>
    <p>Imagine that you no longer have enough space for all of your possessions and have set aside time to conduct a ‘spring cleaning’ of your home. You will be going though many of your possessions, one at a time, and deciding whether they are worth keeping. In order to figure out what possessions are worth keeping and what possessions are simply taking up space, you will be able to access different kinds of information about each possession. However, you will only be able to access one piece of information before making each decision, so chose carefully.</p>
    <p>On each trial, read both questions and then click on the one you would like answered. After reading the answer, decide whether you wish to keep or discard the possession.</p>
  </div>
</div>


<div class="ui stackable center aligned grid segment">
  <div class="four wide column"></div>
  <div class="eight wide column">
    <div class="ui huge green accept button">Continue</div>
  </div>
  <div class="four wide column"></div>
</div>



<form class="round-form" name="consent" method="post" action="./round">
  <input type="hidden" name="submitType" value="instructions" />
  <input type="text" name="userId" value="{{ userId }}" />
  <input type="number" name="roundNumber" value="0" />
</form>

<script>
function submitForm() {
  document.forms[0].submit();
}

$('.accept').click(submitForm);
</script>
{% endblock %}
