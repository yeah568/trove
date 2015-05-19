{% extends 'layout.swig' %}

{% block content %}
<div class="ui column stackable page grid">
  <div class="four wide column"></div>
  <div class="eight wide centered column">
    <h1 class="ui header">Survey complete</h1>
    {% if error %}
    <div class="ui negative message">
      <div class="header">
        {{ error }}
      </div>
    </div>
    {% endif %}
    You may close this window.
  </div>
</div>

{% endblock %}
