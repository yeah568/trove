{% extends 'layout.swig' %}

{% block content %}
  <!-- this is where the quesiton stuff goes-->
  Round {{ question.roundNumber }} <br>
  Item: {{ question.itemName }}<br>
  Question 1: {{ question.question1.text }}, {{ question.question1.type }}, {{ question.question1.answer }}<br>
  Question 2: {{ question.question2.text }}, {{ question.question2.type }}, {{ question.question2.answer }}
{% endblock %}
