$(function() {

  $("#category-btn,.category__box__parent--list").hover(function() {
    $("#parent_ul").show();
  },function() {
    var judgement = false;
    var hover_ids = [];
    jQuery(":hover").each(function () {
        hover_ids.push($(this).attr("id"));
        if ($.inArray("parent_ul", hover_ids) == -1) {
            judgement = "out";
        }
    });
    if (judgement == "out") {
        $("#parent_ul").hide();
    }
  });
  // 親カテhover
  $(".category__box__parent--list").hover(function() {
    $("#child_ul").show();
    $("#grandchild_ul").hide();
  
    $(this).find("a").css({"background":"red","color":"white"});
  },function() {
    var judgement = false;
    var hover_ids = [];
    jQuery(":hover").each(function () {
        hover_ids.push($(this).attr("id"));
        if (hover_ids.length-1 == $.inArray("child_ul", hover_ids)) {
            judgement = true;
        }
    });
    if (judgement == true) {
        $(this).find("a").css({"background":"red","color":"white"});
        $("#parent_ul").show();
    } else {
        $(this).find("a").css({"background":"white","color":"#333"});
        $("#parent_ul").hide();
        $("#child_ul").hide();
    }
  });
  // 子カテhover
  $(document).on({
    'mouseenter':function() {
        $("#grandchild_ul").show();
        $(this).find("a").css({"background":"#f5f5f5"});
    },
    'mouseleave':function() {
        var judgement = false;
        var hover_ids = [];
        jQuery(":hover").each(function() {
            hover_ids.push($(this).attr("id"));
            if (hover_ids.length-1 == $.inArray("grandchild_ul", hover_ids)) { 
                judgement = true;
            }
            if ($.inArray("child_ul", hover_ids) == -1 && $.inArray("grandchild_ul", hover_ids) == -1) {
                judgement = "out";
            }
            else if (hover_ids.length-1 == $.inArray("child_ul", hover_ids)) {
                judgement = "silde"
            }
        });
        if (judgement) {
            $("#child_ul").show();
            $(this).find("a").css({"background":"#f5f5f5"});
        } else {
            $(this).find("a").css({"background":"white"});
            $("#grandchild_ul").hide();
        }
        if (judgement == "silde") {
            $(this).find("a").css({"background":"white"});
        }
        if (judgement == "out") {
            $("#parent_ul").hide();
            $("#child_ul").hide();
            $("#grandchild_ul").hide();
            $(".category__box__child--list").find("a").css({"background":"white","color":"#333"});
            $(".category__box__parent--list").find("a").css({"background":"white","color":"#333"});
        }
    }
  },".category__box__child--list");
  // 孫カテhover
  $(document).on({
    'mouseenter':function() {
        $(this).find("a").css({"background":"#f5f5f5"});
    },
    'mouseleave':function() {
        var judgement = false;
        var hover_ids = [];
        jQuery(":hover").each(function() {
            hover_ids.push($(this).attr("id"));
     
            if (hover_ids.length-1 == $.inArray("grandchild_ul", hover_ids)) {
                judgement = "silde";
            }
            if ($.inArray("child_ul", hover_ids) == -1 && $.inArray("grandchild_ul", hover_ids) == -1) {
                judgement = "out";
            }
            if (hover_ids.length-1 == $.inArray("child_ul", hover_ids)) {
                judgement = "back";
            }
        });
        if (judgement == "silde") {
            $(this).find("a").css({"background":"white"});
        }
        if (judgement == "back") {
            $(this).find("a").css({"background":"white"});
            $(".category__box__child--list").find("a").css({"background":"white","color":"#333"});
        }
        if (judgement == "out") {
            $("#parent_ul").hide();
            $("#child_ul").hide();
            $("#grandchild_ul").hide();
            $(".category__box__parent--list").find("a").css({"background":"white","color":"#333"});
            $(".category__box__child--list").find("a").css({"background":"white","color":"#333"});
            $(".category__box__grandchild--list").find("a").css({"background":"white","color":"#333"});
        }
  
    }
  },'.category__box__grandchild--list');
  
  // ここからカテゴリの非同期
  // childカテゴリを表示
  var buildHtmlChild = function(category) {
    var child_html = `
                <li class="category__box__child--list">
                    <h3><a href="/category/${category.id}", data-id=${category.id}>${category.name}</a></h3>
                </li>
                `
    return child_html
  }
  $(".category__box__parent--list").hover(function() {
  
    var parent_id = $(this).find("a").data("id");
    $.ajax({
        type: 'GET',
        url: '/api/sell/child',
        data: {id: parent_id},
        dataType: 'json'
    })
    .done(function(categories) {
        $("#child_ul").empty();
        setTimeout(function() {
            categories.forEach(function(category) {
                var child_html = buildHtmlChild(category);
                $("#child_ul").append(child_html);
            })
        })
    })
    .fail(function() {
    });
  });
  
  var buildHtmlGrandchild = function(category) {
    var grandchild_html = `
                <li class="category__box__grandchild--list">
                    <a href="/category/${category.id}", data-id=${category.id}>${category.name}</a>
                </li>
                `
    return grandchild_html
  }
  $(document).on("mouseover",".category__box__child--list",function() { 
    var child_id = $(this).find("a").data("id");
    $.ajax({
        type: 'GET',
        url: '/api/sell/grand_child',
        data: {id: child_id},
        dataType: 'json'
    })
    .done(function(categories) {
        $("#grandchild_ul").empty();
        setTimeout(function() {
            categories.forEach(function(category) {
                var grandchild_html = buildHtmlGrandchild(category);
                $("#grandchild_ul").append(grandchild_html);
            });
        })
    })
    .fail(function() {
    });
  })
  
  $(".user_devise__signin").on({
    'mouseenter': function() {
        $(this).find(".mypage-item").removeClass("display-none"); 
    },
    'mouseleave': function() {
        $(this).find(".mypage-item").addClass("display-none"); 
    }
  });
});