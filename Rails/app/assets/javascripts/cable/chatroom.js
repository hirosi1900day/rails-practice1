$(function() {
    if($("#chatroom").length > 0) {
        const chatroomId = $("#chatroom").data("chatroomId")
        const currentUserId = $("#chatroom").data("currentUserId")
        App.chatrooms = App.cable.subscriptions.create({ channel: "ChatroomChannel", chatroom_id: chatroomId }, {
            connected: function() {
                console.log("connected")
            },
            disconnected: function() {
                console.log("disconnected")
            },
            received: function(data) {
                switch(data.type) {
                    case "create":
                        $('#message-box').append(data.html);
                        console.log(data.html)
                        // Vueなどを使えばもっとスマートにできる...
                        if($(`#message-${data.message.id}`).data("senderId") != currentUserId) {
                            // 自分の投稿じゃない場合は編集・削除ボタンを非表示にする
                            $(`#message-${data.message.id}`).find('.crud-area').hide()
                        }
                        $('.input-message-body').val('');
                        break;
                    case "update":
                        $(`#message-${data.message.id}`).replaceWith(data.html);
                        // Vueなどを使えばもっとスマートにできる...
                        if($(`#message-${data.message.id}`).data("senderId") != currentUserId) {
                            // 自分の投稿じゃない場合は編集・削除ボタンを非表示にする
                            $(`#message-${data.message.id}`).find('.crud-area').hide()
                        }
                        $("#message-edit-modal").modal('hide');
                        break;
                    case "delete":
                        $(`#message-${data.message.id}`).remove();
                        break;
                }
            },
        });
    }
})