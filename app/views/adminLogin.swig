{% extends 'layout.swig' %}

{% block content %}

<div class="ui center aligned grid">
  <div class="row">
    <h1 class="ui header">Admin Login</h1>
  </div>
  <div class="centered row">
    {% if error %}
    <h3 class="ui header">{{ error }}</h3>
    {% endif %}
    <form class="ui four wide column form segment" method="post" action="/start">
       <div class="ui left icon input">
          <input type="text" name="username" placeholder="Username">
          <i class="user icon"></i>
        </div>
        <div class="ui left icon input">
          <input type="password" name="password" placeholder="Password">
          <i class="privacy icon"></i>
        </div>
        <div class="ui fluid green button" type="submit">Login</div>
    </form>
  </div>
</div>


{% endblock %}
