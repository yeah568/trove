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
          <div class="two fields">
            <div class="field">
              <input type="text" name="q1type" placeholder="Question 1 I-Type" required />
            </div>
            <div class="field">
              <input type="text" name="q1qtype" placeholder="Question 1 Q-Type" requierd />
            </div>
          </div>
          <div class="two fields">
            <div class="field">
              <textarea name="q1text" placeholder="Question 1 Text" required></textarea>
            </div>
            <div class="field">
              <textarea name="q1answer" placeholder="Question 1 Answer" required></textarea>
            </div>
          </div>
          <div class="two fields">
            <div class="field">
              <input type="text" name="q2type" placeholder="Question 2 I-Type" required />
            </div>
            <div class="field">
              <input type="text" name="q2qtype" placeholder="Question 2 Q-Type" required />
            </div>
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
          <th>Question 1 I-Type</th>
          <th>Question 1 Q-Type</th>
          <th>Question 1 Answer</th>
          <th>Question 2 Text</th>
          <th>Question 2 I-Type</th>
          <th>Question 2 Q-Type</th>
          <th>Question 2 Answer</th>
          <th>Delete</th>
          <th>Move</th>
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
          <td>{{ question.qType }}</td>
          <td>{{ question.answer }}</td>
          {% endfor %}
          <td><i class="ui red trash icon" data-type="round" data-id="{{ round.roundNumber }}"></i></td>
          <td>
            <span class="move up" data-id="{{ round.roundNumber }}" data-move="up">Up</span>
            <span class="move down" data-id="{{ round.roundNumber }}" data-move="down">Down</span>
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>

<div class="ui aligned grid segment">
  <h2 class="ui teal dividing header">Consent/Completion Screen Text</h2>
  <div class="row">
    <div class="ui column accordion">
      <div class="title">
        <i class="dropdown icon"></i>
         Formatting guide
      </div>
      <div class="content">
        <p>
        To insert a link, use <pre>&lt;a href="URL GOES HERE"&gt;TEXT TO BE DISPLAYED GOES HERE&lt;/a&gt;</pre>
        To insert a line break, use <pre>&lt;br /&gt;</pre>
        </p>
        <div class="ui divider"></div>
      </div>
    </div>
  </div>
  <div class="ui row">
    <form class="ui form column" method="post" action="/admin" enctype="multipart/form-data">
      <input type="hidden" name="submit" value="text" />
      <div class="field">
        <textarea name="endtext" required>{{ endText }}</textarea>
      </div>
      <div class="field">
        <textarea name="consenttext" required>{{ consentText }}</textarea>
      </div>
      <button class="ui button">Save</button>
    </form>
  </div>
</div>

<div class="ui aligned grid segment">
  <h2 class="ui teal dividing header">Admin Account</h2>
  <div class="ui row">
    <form class="ui form column" method="post" action="/admin">
      <input type="hidden" name="submit" value="account" />
      <div class="two fields">
        <div class="field">
          <input type="text" name="username" value="{{ username }}" required />
        </div>
        <div class="field">
          <input type="password" name="password" placeholder="Password" required />
        </div>
      </div>
      <button class="ui button">Save</button>
    </form>
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

$('.move').click(function(e) {
  $.post('/admin/move', {
    direction: e.target.dataset.move,
    id: e.target.dataset.id
  }, function(res) {
    if (res === 'Moved! Refreshing...') {
      location.reload();
    } else {
      alert(res);
    }
  });
})
</script>

{% endblock %}
