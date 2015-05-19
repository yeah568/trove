{% extends 'layout.swig' %}

{% block content %}
<div class="ui column stackable page grid">
  <div class="four wide column"></div>
  <div class="eight wide centered column">
    <h1 class="ui header">Please enter your ID to begin.</h1>
    {% if error %}
    <div class="ui negative message">
      <div class="header">
        {{ error }}
      </div>
    </div>
    {% endif %}
    <form class="ui form segment" method="post" action="/start">
       <div class="ui action input">
        <input type="text" name="userId" placeholder="User ID">
        <button class="ui teal button">
          Start
        </button>
      </div>
    </form>
  </div>
</div>

{% endblock %}
