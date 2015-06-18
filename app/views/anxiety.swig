{% extends 'layout.swig' %}

{% block content %}
<div class="ui center aligned vertically divided grid">
  <div class="ui row">
    <div class="eight wide column">
      <h1 class="ui header">How anxious are you right now?</h1>
      1 is least anxious, 5 is most anxious.
    </div>
  </div>
  <div class="eight wide column">
    <div class="ui form">
      <div class="five fields">
        <div class="field">
          <label>1<br><input type="radio" name="anxietyLevel" value="1"/></label>
        </div>
        <div class="field">
          <label>2<br><input type="radio" name="anxietyLevel" value="2"/></label>
        </div>
        <div class="field">
          <label>3<br><input type="radio" name="anxietyLevel" value="3"/></label>
        </div>
        <div class="field">
          <label>4<br><input type="radio" name="anxietyLevel" value="4"/></label>
        </div>
        <div class="field">
          <label>5<br><input type="radio" name="anxietyLevel" value="5"/></label>
        </div>
      </div>
    </div>
  </div>
</div>


<div class="ui stackable center aligned grid segment">
  <div class="four wide column"></div>
  <div class="four wide column">
    <div class="ui huge green accept button">Accept</div>
  </div>
  <div class="ui vertical divider">or</div>
  <div class="four wide column">
    <div class="ui huge red decline button">Decline</div>
  </div>
  <div class="four wide column"></div>
</div>



<form class="round-form" name="anxiety-form" method="post" action="./round">
  <input type="hidden" name="submitType" value="{{ anxietyType }}" />
  <input type="text" name="userId" value="{{ userId }}" />
  <input type="number" name="roundNumber" value="{{ roundNumber }}" />
  <input type="number" name="anxiety" value="-1" />
</form>

<script>
function submitForm() {
  if (document.forms[0].anxiety.value === -1) {
    alert('You must choose an option before continuing.');
  } else {
    document.forms[0].submit();
  }
}
$('input[type=radio][name=anxietyLevel]')
  .change(function() {
    document.forms[0].anxiety.value = this.value;
  });

$('.accept').click(submitForm);

$('.decline').click(function() {
  alert('You must accept to continue.')
});
</script>

{% endblock %}
