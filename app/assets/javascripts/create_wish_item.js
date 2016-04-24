$(document).ready(function(){
    $('#org_id').change(function() {
    	document.getElementById('select-organization-modal-link').href = "/organizations/" + $(this).val() + "/wish_items/new"; 
    });
})