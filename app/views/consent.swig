{% extends 'layout.swig' %}

{% block content %}
<div class="ui center aligned vertically divided grid">
  <div class="eight wide column">
  {% autoescape false %}{{ consentText }}{% endautoescape %}
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



<form class="round-form" name="consent" method="post" action="./round">
  <input type="hidden" name="submitType" value="consent" />
  <input type="text" name="userId" value="{{ userId }}" />
  <input type="number" name="roundNumber" value="0" />
</form>

<script>
function submitForm() {
  document.forms[0].submit();
}

$('.accept').click(submitForm);

$('.decline').click(function() {
  alert('You must accept to continue.')
});
</script>

{% endblock %}
