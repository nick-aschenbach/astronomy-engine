$(document).ready(function () {
  $.ajax({
    url: 'categories',
    type: 'GET',
    success: function (data) {
      categories = $('#categories');
      for (var i in data) {
        var elem = $('<a href="#" class="list-group-item">' + data[i] + '</a>');
        categories.append(elem);
      }
    }
  });

  $('#categories').on('click', function(event) {
    var category = $(event.target).text();
    $.ajax({
      url: 'categories/' + category + '/topics',
      type: 'GET',
      success: function (data) {
        displayTopics(data);
      }
    });
  })

  $('#topics').on('click', function(event) {
    var target = $(event.target);
    $('#topic').fadeIn();
    $('#topic-title').text(target.data('name'));
    var images = '<div>';
    for(var i in target.data('images')) {
      var keyinfo = "key=AIzaSyAbwKdX2k3t5M6hpAwDpcDCWHTBxtfRvMg";
      var image = target.data('images')[i] + "?" + keyinfo;
      images += '<img src="' + image + '&maxheight=200" class="image-padding">';
    }
    images += '</div>';
    var description = addLineBreaks(target.data('description'));
    $('#topic-body').html(images + description);
  });

  $('#search-box').on('keyup blur', $.debounce(function(event) {
    var search_term = $(event.target).val();

    var topics = $('#topics');
    if(search_term == '') {
      topics.empty();
      topics.fadeOut();
      return;
    }

    $.ajax({
      url: 'topics?q=' + search_term,
      type: 'GET',
      success: function (data) {
        displayTopics(data);
      }
    });
  }, 300));
});

function displayTopics(data) {
  topics = $('#topics');
  topics.empty();
  for (var i in data) {
    var elem = $('<a href="#" class="list-group-item">' + data[i].name + '</a>');
    elem.data('name', data[i].name);
    elem.data('description', data[i].description);
    elem.data('images', data[i].images);
    topics.append(elem);
  }
  topics.fadeIn();
}

function addLineBreaks(text) {
  return text.replace(/(?:\r\n|\r|\n)/g, '<div class="space-above"></div>');
}