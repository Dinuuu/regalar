$('a[data-toggle="tab"]').on('show.bs.tab', function(e) {
    localStorage.setItem('active', $(e.target).attr('href'));
});
var activeTab = localStorage.getItem('active');
if (activeTab) {
   $('#navtab-container a[href="' + activeTab + '"]').tab('show');
}