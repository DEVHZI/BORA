<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="../include/header.jsp"%>
<!-- ${pageContext.request.contextPath} -->
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
<script src="https://cdn.jsdelivr.net/npm/promise-polyfill@7.1.0/dist/promise.min.js"></script>
<%
if(loginID==null) {%>
<!-- 세션값(로그인) 확인 -->
<script>
// 세션값 여부
	alert("세션값이 만료되어 로그인 페이지로 이동합니다.");
	location.href="/main/login";
	
	$(document).ready(function() {
	    let message = "${msg}";
	    if (message != "") {
	        alert(message);
	    }
	})
</script>
<%} %>
<!-- 비밀번호 회원정보 수정 시 alert -->
<script>
$(document).ready(function() {
    let message = "${msg}";
    if (message != "") {
        alert(message);
    }
});
</script>

<!-- 태그 적는 곳 -->
<div class="container">
			
<!-- DB값으로 미리 선택해놓기 -->
<script>
$(document).ready(function(){
	// 항목
	$('input:radio[name=bk_iow]:input[value="${book.detail.bk_iow}"]').attr("checked", true);
	// 자산
	$("#group").val("${book.detail.bk_group}").attr("selected","selected");
	// 날짜
	$("#year").val("${book.bk_year}").attr("selected","selected");
	$("#month").val("${book.bk_month}").attr("selected","selected");
	$("#day").val("${book.detail.bk_day}").attr("selected","selected");
});//document
</script>

<form action="/book/update" method="post">
	<input type="hidden" name="bk_num" value="${book.bk_num }">
	<input type="hidden" name="bk_detail_num" value="${book.detail.bk_detail_num }">
	<input type="hidden" name="id" value=${sessionScope.loginID }><br>
			
항목 :		수입<input type="radio" name="bk_iow" class="iow" value="수입" required="required"> 
			지출<input type="radio" name="bk_iow" class="iow" value="지출" required="required"> 
			이체<input type="radio" name="bk_iow" class="iow" value="이체" required="required">	<br>
자산 :      <select id="group" name="bk_group"  required="required">
				<option value="">자산 선택</option>
				<option value="체크카드">체크카드</option>
				<option value="현금">현금</option>
				<option value="은행">은행</option>
				<option value="신용카드">신용카드</option>
				<option value="기타">기타</option>
			</select> <br>

일자 : 		<select name="bk_year" id="year" required="required">				
				<option value="">연도</option>
				<option value="2022">2022</option>
				<option value="2020">2020</option>
				<option value="2021">2021</option>
				<option value="2023">2023</option>
			</select> 년
	
			<select name="bk_month" id="month" required="required">	
				<option value="">월</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
			</select> 월
		
			<select name="bk_day" id="day" required="required">
				<option value="">일</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="15">15</option>
				<option value="16">16</option>
				<option value="17">17</option>
				<option value="18">18</option>
				<option value="19">19</option>
				<option value="20">20</option>
				<option value="21">21</option>
				<option value="22">22</option>
				<option value="23">23</option>
				<option value="24">24</option>
				<option value="25">25</option>
				<option value="26">26</option>
				<option value="27">27</option>
				<option value="28">28</option>
				<option value="29">29</option>
				<option value="30">30</option>
				<option value="31">31</option>
			</select> 일 <br>

카테고리 : 	<select name="bk_category" id="category" required="required">
				<option value="식비">식비</option>
				<option value="">카테고리</option>
				<option value="교통비">교통비</option>
				<option value="편의점/마트">편의점/마트</option>
				<option value="통신비">통신비</option>
				<option value="여가비">여가비</option>
				<option value="뷰티/쇼핑">뷰티/쇼핑</option>
				<option value="저축">저축</option>
				<option value="기타">기타</option>
			</select> <br>
금액 : <input type="number" name="bk_money" value="${book.detail.bk_money }" required="required"><br>
메모 : <textarea rows="5" cols="20" name="bk_memo" required="required">${book.detail.bk_memo }</textarea> <br>
<input type="submit" value="수정">

</form>
	</div>







<!-- 태그 적는 곳 -->


<%@ include file="../include/footer.jsp"%>