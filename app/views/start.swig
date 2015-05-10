{% extends 'layout.swig' %}

{% block content %}
<div class="ui column stackable center page grid">
  <div class="four wide column"></div>
  <div class="eight wide centered column">
    <h1 class="ui header">Lorem ipsum</h1>
    {% if error %}
    <h3 class="ui header">{{ error }}</h3>
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
