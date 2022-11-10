<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../include/header.jsp"%>
<!-- ${pageContext.request.contextPath} -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script src="https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>


<%
	if (loginID == null) {
%>
<script>
	alert("세션값이 만료되어 로그인 페이지로 이동합니다.");
	location.href = "/main/login";
</script>
<%
	}
%>


<!-- ======== for 썸머노트 ============== -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#summernote').summernote({
			height : 300, // 에디터 높이
			width : 1000,
			minHeight : null, // 최소 높이
			maxHeight : null, // 최대 높이
			focus : true, // 에디터 로딩후 포커스를 맞출지 여부
			lang : "ko-KR", // 한글 설정
			placeholder : '최대 2048자까지 쓸 수 있습니다' //placeholder 설정
		});
	});
</script>
<script src="${pageContext.request.contextPath}/resources/js/summernote/summernote-lite.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/summernote/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/summernote/summernote-lite.css">
<!-- ======== for 썸머노트 끝 ============== -->



<!-- ======= for 댓글,, comment.js 파일 추가 및 ajax, jquery 작업 ======= -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/comment.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	// 계속 쓸 놈들 ---------------------
	var loginID = '<c:out value="${loginID}"/>';
	var bnoValue = '<c:out value="${vo.bno}"/>';
	var nick = '<c:out value="${nick}"/>';
	
	
	// 댓글 목록 출력 ----------------------------
	var cmtUL = $('#cmtUL');

	showCmtList(1);
	
	function showCmtList(page){
// 		alert("showCmtList 작동 성공");

		// 댓글 목록 출력 함수 2.getCmtList
		cmtService.getCmtList({bno:bnoValue, page:page||1}, function(list){
			var str="";
			
			if( list == null || list.length == 0 ) {
				cmtUL.html("");
				return;
			}
			
			// 반복문 돌면서 댓글 list 채우기
			for (var i = 0, len = list.length||0; i < len; i++) {
				str += "<li id='cmtLI' data-cno='"+list[i].cno+"' class='mb-5'>";
				str += "<div id='cmt-body'><div id='cmt-header'><strong>" + list[i].nick +" /cno: " + list[i].cno + "</strong>&nbsp;&nbsp;&nbsp;";
					// 수정 날짜 null이면 regdate로 표시, 수정 날짜 null 아니면 updatedate로 표시
					if (list[i].c_updatedate == null){
						str += "<span><small> "+cmtService.displayTime(list[i].c_regdate)+"</small></span><span>";
					} else { 
						str += "<span><small> "+cmtService.displayTime(list[i].c_updatedate)+"</small></span><span>";
					}
					
					// id가 admin이거나 본인일 때만 -> 답글, 수정, 삭제 버턴 나오게 제어
					if (list[i].id == loginID || loginID == 'admin') {
						str += "<button id='cmt_btn_del' style='border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;'>삭제</button>";
						str += "<button id='cmt_btn_mod' style='border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;'>수정</button>";
						str += "<button id='cmt_btn_re' style='border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;'> 답글</button>";
						str += "<input type='hidden' value='"+list[i].cno+"' id='cnoValue'></span></div>";
					}
				str += "<div id='c_contentDIV'>" + list[i].c_content+"</div>";
				str += "</div></li>";
				
			} // for
			
			cmtUL.html(str);
			
		}); // 2.getCmtList()
	}// showCmtList()
	// 댓글 목록 출력 끝 ----------------------------
	
	
	// 댓글 작성 -------------------------------
	var cmtRegisterBtn = $("#add_cmt_btn");
	
	cmtRegisterBtn.on("click", function(e){
		
		if($('#c_content').val() == null || $('#c_content').val() == ''){
			alert("댓글 내용을 작성해주세요");
			$('#c_content').focus();
			return false;
		}
		
		var cmt = {
			c_content: $('#c_content').val(),
			id: loginID,
			bno: bnoValue,
			nick: nick
		};
		
		
		// 댓글 등록 함수 1.add(cmt, callback, error) 호출
		cmtService.add(
				// cmt
				cmt, 
				// callback
				function(addResult){
					console.log("addResult: " + addResult);
					
					if(addResult === "success") {
						alert("댓글이 등록되었습니다 👍 ");
					}
					
					showCmtList(1);
					
		}); // 1.add()
		
		// 작성 후에 빈칸으로
		$('#c_content').val("");
		
	});// cmtRegisterBtn on click
	// 댓글 작성 끝 -------------------------------
	
	
	// 댓글 삭제 -------------------------------
// 	cmtDelBtn.on("click", function(e){ // 버턴이 먹지를 않노 ㄱ-
	$(document).on("click", "#cmt_btn_del", function(){
// 		alert("삭제 버턴 클릭됨");
		// cno는?  삭제 버턴(this) -> 다음 다음 다음 요소의 value값.. 이게 최선?ㅠ
		var cnoValue = $(this).next().next().next().val();
		console.log("삭제할 cnoValue: " + cnoValue);
		alert("삭제할 cnoValue: " + cnoValue);
		
		// 삭제 버튼 클릭했을 때~ 
		// 댓글 삭제 함수 3. deleteCmt(cno, callback, error) 호출
		cmtService.deleteCmt(
			// cno
			cnoValue,
			// callback
			function(deleteResult){
				console.log("deleteResult: " + deleteResult);
		
				if(deleteResult === "success") {
					alert("댓글이 삭제되었습니다 👍 ");
				}
				
				showCmtList(1);
			}, 
			// error
			function(error){
				alert("삭제 실패...... ");
			}
		);// 3.deleteCmt()
	}); // cmtDelBtn on click
	// 댓글 삭제 끝 -------------------------------
	
	
	// 댓글 수정 -------------------------------
	function updateCmtForm(cnoValue, c_content){
// 		alert("updateCmtForm 함수 실행됨 /// 클릭한 cno: " + cnoValue + " / 기존 c_content: " + c_content);
		
		var commentsView = "";
		
		commentsView += "<textarea class='form-control' id='c_content_MOD'>"+c_content+"</textarea>";
		commentsView += "<div><button class='btn' id='real_mod_btn' style='background-color: #5107B0; color: white; float: right; width: 60px; margin: 5px; font-size: 16px;'><span class='btn-inner-text' style='color: white;'> 수정 </span> ";
		commentsView += "</button></div>";
		
// 		$('#c_contentDIV').replaceWith(commentsView); // 에바
		$("[data-cno="+cnoValue+"]").find('#c_contentDIV').replaceWith(commentsView); // 오케이~!~!~!~! 나이서!~!~! 
		
	}// updateCmtForm()
	
	
	// 버튼 클릭 이벤트
	$(document).on("click", "#cmt_btn_mod", function(){
// 		alert("수정 버턴 클릭");
		var cnoValue = $(this).next().next().val();
		var c_content = $("[data-cno="+cnoValue+"]").find('#c_contentDIV').text();

// 		alert("cnoValue: " + cnoValue + " / c_content: " + c_content);
		
		// 함수 호출
		updateCmtForm(cnoValue, c_content);
		
		// 수정 버튼 클릭 -> div li data-cno [i] 에 해당하는 div가 -> 입력할 수 있는 form으로 replace됨
		// 그 입력폼에서 수정 내용 적고 수정 버튼 또 클릭 -> cno, bno, c_content(수정한 내용) 받아감
		// -> DB 가서 수정 반영하고, 목록 갱신 함 해서 수정한 내용으로 보이도록..
		
		// 문제!!! 수정 누르면 해당 cno 폼이 바뀌는 게 아니라 젤 위에 애가 바뀐다 + 내용도 젤 위에 cno 내용으로 뜸
		//  --> 근데,, 수정 반영은 클릭한 cno한테 잘 들어감 ㄱ-
		
		$('#real_mod_btn').click(function(){
// 			alert("찐 수정버턴 클릭됨");
// 			alert("cnoValue: " + cnoValue + " / bnoValue: " + bnoValue + " / c_content_MOD: " +  $('#c_content_MOD').val());
			//4. updateCmt(cmtVO, callback, error)
			cmtService.updateCmt(
					// cmtVO
					{ cno : cnoValue,
					  bno : bnoValue,
					  c_content : $('#c_content_MOD').val()},
					  	// 이모티콘은 안 되네 ㄱ- 
					
					// callback
					function(rData){
						alert("댓글 수정 완");
						
						showCmtList(1);
					}
			);// updateCmt()
			
		});// 찐 수정버튼 click
		
	});// on click
	// 댓글 수정 끝 -------------------------------
	
	
}); // jquery ready

</script>
<!-- ======= for 댓글,, comment.js 파일 추가 및 ajax, jquery 작업 끝 ======= -->





		<!-- 수정, 삭제 시 필요한 글 번호(bno) 저장하는 폼태그 =====================-->
		<form role="bno_form" method="post">
			<input type="hidden" name="bno" value="${vo.bno }">
		</form>
		<!-- 수정, 삭제 시 필요한 글 번호(bno) 저장하는 폼태그 껏 =====================-->
			<input type="hidden" name="id" value="${vo.id}" readonly>

<div class="container mt-5 ">
	<div class="row" style="justify-content: center; align-items: center;">
		<div class="col-lg-8">
			<!-- Post content-->
			<article>
				<!-- Post header-->
				<header class="mb-4">
					<!-- Post title-->
					<h2 class="fw-bolder mb-1"> <span style="font-size: medium;">[ ${vo.b_ctgr} ]</span> ${vo.b_title }</h2>
					<!-- Post meta content-->
					<div class="text-muted fst-italic mb-2">
						<b>작성일시: </b>  ${vo.b_regdate } &nbsp;&nbsp;&nbsp; <b>작성자: </b> ${vo.nick }</div>
				</header>
				<!-- Preview image figure-->
				<figure class="mb-4">
<!-- 					<img class="img-fluid rounded" src="https://dummyimage.com/900x400/ced4da/6c757d.jpg" alt="..." /> -->
				</figure>
				<!-- Post content-->
				<section class="mb-5">
					<p class="fs-5 mb-4">${vo.b_content }</p>
				</section>
				<button class="btn_mod"
					style="border: none; margin: 2px; background-color: #5107B0; color: white; border-radius: 5px;">수정</button>
				<button class="btn_del"
					style="border: none; margin: 2px; background-color: #5107B0; color: white; border-radius: 5px;">삭제</button>
				<button class="btn_list"
					style="border: none; margin: 2px; background-color: #5107B0; color: white; border-radius: 5px;">목록</button>
			</article>
			<br>

			<!-- 							파일 -->
			<!-- 							<div> -->
			<%-- 								<input type="text" name="b_file" value="${vo.b_file }" readonly> --%>
			<!-- 							</div> -->

			<!-- 							<input type="button" value="수정" class="btn_mod"> <input -->
			<!-- 								type="button" value="삭제" class="btn_del"> <input -->
			<!-- 								type="button" value="목록" class="btn_list"> -->



			<!-- Comments section-->
			<section class="mb-5">
				<div class="card bg-light">
					<div class="card-body">
						<!-- 댓글입력창 !-->
						<form class="mb-4">
							<textarea class="form-control" rows="3" name="content"
								id="c_content" placeholder="댓글을 입력해주세요 !"></textarea>
							<button type="button" class="btn" id="add_cmt_btn"
								style="background-color: #5107B0; float: right; width: 80px; margin: 10px; font-size: 16px;">
								<span class="btn-inner-text" style="color: white;">등 록</span>
							</button>
						</form>
						<br> <br>
						<!-- 댓글입력창 !-->

						<!-- Single comment-->
						<div class="">
							<div class=""></div>
							<ul id="cmtUL" >
								<li data-cno="" class="mb-4">
									<div id="cmt-body" class="ms-3">
										<div id="cmt-header" class="fw-bold">
											<strong> 닉네임 </strong> 
											<span> <small> c_regdate </small> </span>
											<span align="right";>
												<button id="cmt_btn_re" 
													style="border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;">답글</button>
												<button id="cmt_btn_mod"
													style="border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;">수정</button>
												<button id="cmt_btn_del"
													style="border: none; margin: 2px; background-color: #ecdffd; border-radius: 5px; float: right;">삭제</button>
												<input type="hidden" value="" id="cnoValue">
											</span>
										</div>
										<div id='c_contentDIV'>c_content</div>
									</div>
								</li>
							</ul>
						</div>
						<!-- 댓글 리스트 구간 끝 -->
					</div>
					<!-- class="card-body" -->
				</div>
			</section>


		</div>
    </div>
  </div>

						<!-- ----------------------- 댓글 리스트 구간 --------------------------------- -->
<!-- 						<div style="border: 1px solid black"> -->
<!-- 							<div> -->
<!-- 								<h3>댓글</h3> -->
<!-- 							</div> -->
<!-- 							<ul id="cmtUL"> -->
<!-- 								<li data-cno=""> -->
<!-- 									<div id="cmt-body"> -->
<!-- 										<div id="cmt-header"> -->
<!-- 											<strong> id,, 말고 nick </strong> <small> c_regdate </small> <input -->
<!-- 												type="button" value="답글" class="btn" id="cmt_btn_re"> -->
<!-- 											<input type="button" value="수정" class="btn" id="cmt_btn_mod"> -->
<!-- 											<input type="button" value="삭제" class="btn" id="cmt_btn_del"> -->
<!-- 											<input type="hidden" value="" id="cnoValue"> -->
<!-- 										</div> -->
<!-- 										<p>c_content</p> -->
<!-- 									</div> -->
<!-- 								</li> -->
<!-- 							</ul> -->
<!-- 						</div> -->
						<!-- ----------------------- 댓글 리스트 구간 끝^^ --------------------------------- -->




						<!-- ----------------------- 댓글 작성 구간^^ --------------------------------- -->
						<!-- 						<div style="border: 1px solid black;"> -->
						<!-- 							<h3>댓글을 남겨주세요 👇👇</h3> -->
						<!-- 							<div class="form-group"> -->
						<!-- 								<label for="message">내용</label> -->
						<!-- 								<textarea name="content" id="c_content" cols="30" rows="5" -->
						<!-- 									class=""></textarea> -->
						<!-- 							</div> -->
						<!-- 							<div class="btn btn-primary"> -->
						<!-- 								<input type="button" value="댓글 달기😘" class="btn btn-primary" -->
						<!-- 									id="add_cmt_btn"> -->
						<!-- 							</div> -->
						<!-- 						</div> -->

						<!-- ----------------------- 댓글 작성 구간 끝^^ --------------------------------- -->







						<script type="text/javascript">

	// jQuery 구간 시작~ =================================================
	$(document).ready(function() {
		// 	  alert('jQuery 실행🎊🎊');
		// 버턴들 제어할 거!!!!!!!!!!!!

		// 글번호 정보를 포함하는 폼태그에 접근
		var fr = $('form[role="bno_form"]'); // role이 form인 폼태그에 접근해서 그걸 fr 변수에 담기

		$(".btn_mod").click(function() {
			// 		  alert('정상 동작 중');
			// bno폼태그 속성 바꿀 거!!
			fr.attr("action", "/board/update");
			fr.attr("method", "get"); // get방식으로 바꿔서 전달 
			fr.submit(); // 클릭하면? 속성 바꾸고 -> submit 되게~~
		});// 수정 버턴 click

		
		$(".btn_list").click(function() {
			// 목록 버턴 클릭했을 때
			history.back();
		});// 목록 버턴 click

		
		$(".btn_del").click(function() {
			// 삭제 버턴 클릭했을 때~~
			alert('삭제 버턴 클릭됨');
			fr.attr("action", "/board/delete");
			fr.submit(); // 클릭하면? 속성 바꾸고 -> submit 되게~~
		});// 삭제 버튼 click

	});// jQuery ready
</script>

						<%@ include file="../include/footer.jsp"%>