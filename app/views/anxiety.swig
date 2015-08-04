{% extends 'layout.swig' %}

{% block content %}
<div class="ui center aligned vertically divided grid">
  <div class="ui row">
    <div class="eight wide column">
      <h1 class="ui header">
        {% if anxietyType == "preAnxiety" %}Please rate your anxiety/distress from 0 to 100.
        {% elseif anxietyType == "postAnxiety" %}Please rate <strong>the highest</strong> anxiety/distress you experienced during this task from 0 to 100.{% endif %}
      </h1>
      0 = Totally relaxed
      <br>
      50 = Moderate anxiety/distress, uncomfortable but can continue to perform
      <br>
      100 = Highest distress/fear/anxiety/discomfort that you have ever felt
    </div>
  </div>
  <div class="eight wide column">
    <div class="ui form">
      <div class="field">
        <input style="width:100%;" type="range" min="0" max="100" value="50" step="1" id="range">
        <div for="range" id="anxietyvalue">50</div>
    </div>
  </div>
</div>


<div class="ui stackable center aligned grid segment">
  <div class="four wide column"></div>
  <div class="eight wide column">
    <div class="ui huge green accept button">Continue</div>
  </div>
  <div class="four wide column"></div>
</div>



<form class="round-form" name="anxiety-form" method="post" action="./round">
  <input type="hidden" name="submitType" value="{{ anxietyType }}" />
  <input type="text" name="userId" value="{{ userId }}" />
  <input type="number" name="roundNumber" value="{{ roundNumber }}" />
  <input type="number" name="anxiety" value="50" />
</form>

<script>
function submitForm() {
  document.forms[0].submit();
}

$('input[type=range]')
  .change(function() {
    document.forms[0].anxiety.value = this.value;
    $('#anxietyvalue').text(this.value);
  });

$('.accept').click(submitForm);

$('.decline').click(function() {
  alert('You must accept to continue.')
});
</script>

{% endblock %}
