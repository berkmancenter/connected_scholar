function markCommentAsRead(doc_id, comment_id) {
    var commentElement = $("#comment_"+comment_id);
    if (commentElement.hasClass("unread")) {
        commentElement.removeClass("unread");
        $.post("/documents/"+doc_id+"/comments/"+comment_id+"/read", function() { });
    }
    return false;
}
