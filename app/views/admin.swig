{% extends 'layout.swig' %}

{% block content %}
<h1 class="ui teal dividing header">Admin</h1>
{% if message %}
<div class="ui positive message">
  <div class="header">
    {{ message }}
  </div>
</div>
{% endif %}
{% if error %}
<div class="ui negative message">
  <div class="header">
    {{ error }}
  </div>
</div>
{% endif %}
<div class="ui aligned grid segment">
  <h2 class="ui teal dividing header">Participants</h2>
  <div class="row">
    <div class="ui column accordion">
      <div class="title">
        <i class="dropdown icon"></i>
         Add a new user
      </div>
      <div class="content">
        <form class="ui form column" method="post" action="/admin">
          <input type="hidden" name="submit" value="response" />
          <div class="field">
            <div class="ui action input">
              <input type="text" name="userId" id="userId" placeholder="Add participant user ID">
              <button class="ui button" id="generateId" type="button">Generate a User ID</button>
            </div>
            <button class="ui button" type="submit">Add</button>
          </div>
        </form>
        <div class="ui divider"></div>
      </div>
    </div>
  </div>
  <div class="ui row">
    <table class="ui column celled striped collapsing table">
      <thead>
        <tr>
          <th>User ID</th>
          <th>Status</th>
          <th>Rounds Completed</th>
          <th>Delete</th>
        </tr>
      </thead>
      <tbody>
        {% for user in responses %}
        <tr>
          <td>{{ user.userId }}</td>
          {% if user.complete %}
          <td class="positive">Complete</td>
          {% else %}
          <td class="warning">In Progress</td>
          {% endif %}
          <td>{{ user.responses.length }}</td>
          <td><i class="ui red trash icon" data-type="user" data-id="{{ user.userId }}"></i></td>
        </tr>
        {% endfor %}
      </tbody>
    </table>
  </div>
  <div class="row">
    <div class="ui column">
      <span>Download all responses as: <a href="/admin/download">CSV</a></span>
    </div>
  </div>
</div>
<div class="ui aligned grid segment">
  <h2 class="ui teal dividing header">Rounds</h2>
  <div class="row">
    <div class="ui column accordion">
      <div class="title">
        <i class="dropdown icon"></i>
         Add a new round
      </div>
      <div class="content">
        <form class="ui form column" method="post" action="/admin" enctype="multipart/form-data">
          <input type="hidden" name="submit" value="round" />
          <div class="two fields">
            <div class="field">
              <input type="number" name="roundNumber" value="{{ rounds.length + 1 }}" required />
            </div>
            <div class="field">
              <input type="text" name="itemName" placeholder="Item Name" required />
            </div>
          </div>
          <div class="field">
            <input type="text" name="q1type" placeholder="Question 1 Type" required />
          </div>
          <div class="two fields">
            <div class="field">
              <textarea name="q1text" placeholder="Question 1 Text" required></textarea>
            </div>
            <div class="field">
              <textarea name="q1answer" placeholder="Question 1 Answer" required></textarea>
            </div>
          </div>
          <div class="field">
            <input type="text" name="q2type" placeholder="Question 2 Type" required />
          </div>
          <div class="two fields">
            <div class="field">
              <textarea name="q2text" placeholder="Question 2 Text" required></textarea>
            </div>
            <div class="field">
              <textarea name="q2answer" placeholder="Question 2 Answer" required></textarea>
            </div>
          </div>
          <div class="field">
            <input type="file" name="image" required />
          </div>
          <button class="ui button">Add</button>
        </form>
        <div class="ui divider"></div>
      </div>
    </div>
  </div>
  <div class="ui row">
    <table class="ui column celled striped collapsing table">
      <thead>
        <tr>
          <th>Round Number</th>
          <th>Item</th>
          <th>Question 1 Text</th>
          <th>Question 1 Type</th>
          <th>Question 1 Answer</th>
          <th>Question 2 Text</th>
          <th>Question 2 Type</th>
          <th>Question 2 Answer</th>
          <th>Delete</th>
        </tr>
      </thead>
      <tbody>
      {% for round in rounds %}
        <tr>
          <td>{{ round.roundNumber }}</td>
          <td>{{ round.itemName }}</td>
          {% for question in round.questions %}
          <td>{{ question.text }}</td>
          <td>{{ question.type }}</td>
          <td>{{ question.answer }}</td>
          {% endfor %}
          <td><i class="ui red trash icon" data-type="round" data-id="{{ round.roundNumber }}"></i></td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>


<script>
$('.ui.accordion').accordion();

$('#generateId').click(makeid);
function makeid() {
    var id = [];
    var chars = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";

    for(var i = 0; i < 7; i++) {
      id[i] = chars.charAt(Math.floor(Math.random() * chars.length));
    }
    $('#userId').val(id.join(""));
}

$('.trash').click(function(e) {
  $.post('/admin/delete', {
    deleteType: e.target.dataset.type,
    id: e.target.dataset.id
  }, function(res) {
    alert(res);
    var node = e.target.parentNode.parentNode;
    node.parentNode.removeChild(node);
  })
});
</script>

{% endblock %}
