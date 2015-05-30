//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).on("ready page:change", function() {
    $('#tag-tooltip').tooltip();
});
