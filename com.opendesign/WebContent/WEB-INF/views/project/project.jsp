<%-- 화면ID : OD03-01-01 --%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.opendesign.vo.ProjectVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.opendesign.utils.CmnUtil"%>
<%@page import="com.opendesign.vo.ProjectGroupVO"%>
<%@page import="com.opendesign.utils.CmnConst"%>
<%@page import="com.opendesign.utils.StringUtil"%><%
	/* 로그인 여부 */
	boolean isLogin = CmnUtil.isUserLogin(request);
	
	/* 로그인 유저 그룹 */
	List<ProjectGroupVO> myPGroupList = (List<ProjectGroupVO>)request.getAttribute("myPGroupList");
	List<ProjectVO> myProjectList = (List<ProjectVO>)request.getAttribute("myProjectList");

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@include file="/WEB-INF/views/common/head.jsp"%>
</head>
<body>
<div class="wrap">
	<!-- header -->
	<jsp:include page="/WEB-INF/views/common/header.jsp"> 
		<jsp:param name="headerCategoryYN" value="Y" />
	</jsp:include>
	<!-- //header -->

	<!-- content -->
	<div class="project-content">
		<div class="inner">
			<h2 id="project_all_cnt" class="title">프로젝트 (0건)</h2>
			<div class="btn-area">
			<!-- 로그인후 보여줌 -->
				<% if(isLogin) { %>
				<div id="sch_my_group" class="select-area project-select custom-select">
					<input type="text" name="txt_select_name" ><i class="fa fa-caret-down" aria-hidden="true"></i>
					<select name="" >
						<option value="">내그룹(<%=myPGroupList.size()%>)</option>
					<%if( isLogin && myPGroupList.size() > 0 ){ %>
					<%
						for(ProjectGroupVO aPGroup : myPGroupList){
					%>
						<option value="<%=aPGroup.getSeq()%>"><%=aPGroup.getGroupName()%></option>
					<%
						}
					%>
					<%} %>
					</select>
				</div>
				<%} %>
				
			
				<a class="btn-red" href="javascript:goPage('/project/projectGroup.do', true);">그룹 등록 및 관리</a>
				<%
				if( isLogin && myProjectList.size() > 0 ) {
				%>
				<a class="btn-red" href="javascript:goPage('/project/projectManage.do', true);">프로젝트 관리</a>
				<%
				}
				%>
				<a class="btn-red" href="javascript:goPage('/project/projectRegi.do', true);" class="btn-product">프로젝트 등록</a>
				<button class="btn-help btn-red" type="button" onclick="javascript:modalShow('#help-modal-project');">도움말</button>
			</div>
		</div>

		<div class="tab-wrap">
			<ul class="tab">
				<li class="ing active btn-red"><a href="#ing-project">프로젝트</a></li>
				<!-- <li class="done btn-red"><a href="#complete-project">완료된 프로젝트</a></li>  -->
				<li class="complete btn-red"><a href="#group-tab">프로젝트 그룹</a></li>
			</ul>
			<div class="sorting" id="sortingProj">
				<a id="psort1" href="javascript:sortProduct();" class="btn-red active">최신순</a>
				<a id="psort2" href="javascript:sortProduct('LIKE');" class="btn-red">인기순</a>
				<a id="psort3" href="javascript:sortProduct('MEMBER');" class="btn-red">멤버순</a>
			</div>
			<div class="sorting" id="sortingGroup" style="display: none">
				<a id="gsort1" href="javascript:sortProject();" class="btn-red active">최신순</a>
				<a id="gsort2" href="javascript:sortProject('NAME');" class="btn-red">이름순</a>
			</div>
			<div class="clear"></div>
		</div>
		<div class="tab-con project-con">
			<div id="ing-project" class="active">
				<ul id="ing-project-list" class="project-list"></ul>
			</div>
			<!-- <div id="complete-project">
				<ul id="done-project-list" class="project-list"></ul>
			</div>  -->
			<div id="group-tab">
				<div class="project-list-head" style="display: block;">
					<p class="head-groupName">그룹명</p>
					<p class="head-writtenDate">등록날짜</p>
					<!-- <p class="head-updateDate">최신업데이트 날짜</p>  -->
					<p class="head-leader">개설자</p>
					<p class="head-projectNum">프로젝트 수</p>
					<p class="head-memberNum">멤버수</p>
					<div class="clear"></div>
				</div>
				<ul id="groupListView" class="project-list"></ul>
			</div>
		</div>
	</div>
	<!-- //content -->

	<!-- footer -->
	<%@include file="/WEB-INF/views/common/footer.jsp"%>
	<!-- //footer -->
</div>
<!-- modal -->
<%@include file="/WEB-INF/views/common/modal.jsp"%>
<!-- //modal -->
<%
	//카테고리
	String schCate = request.getParameter("schCate");
	//진행중인 프로젝트 페이지 인덱스
	String schPPage = request.getParameter("schPPage");
	//완료된 프로젝트 페이지 인덱스
	String schCPage = request.getParameter("schCPage");
	//내 그룹
	String schMyGroup = request.getParameter("schMyGroup");
	//sorting
	String schSort = request.getParameter("schSort");
	//그룹 이름 가져오기
	String schMyGroupName = request.getParameter("schMyGroupName");
%>
<form id="listParamForm" name="listParamForm" method="GET" action="" >
	<input type="hidden" name="schCate" value="<%=StringUtil.nullToBlank(schCate) %>" />
	<input type="hidden" name="schPPage" value="" /> 
	<input type="hidden" name="schCPage" value="" />
	<input type="hidden" name="schMyGroup" value="<%=StringUtil.nullToBlank(schMyGroup) %>" />
	<input type="hidden" name="schMyGroupName" value="" />
	<input type="hidden" name="schProgressStatus" value="" />
	<input type="hidden" name="projectSeq" value="" />
	<input type="hidden" name="schSort" value="<%=schSort %>" />
	<input type="hidden" name="schLimitCount" value="30" />
</form>
<script id="tmpl-listView" type="text/x-jsrender">
	<li><a href="javascript:goProject({{:seq}});" >
        <div class="img-area">
        	<img src="{{:fileUrlM}}" onerror="setDefaultImg(this, 5);" alt="" >
		</div>
    	<dl>
        	<dt>{{:projectName}}</dt>
			<dd>{{:ownerName}}님의 프로젝트</dd>
		</dl>
        <div class="project-info">
        	<div class="member">
            	<i class="fa fa-user" aria-hidden="true"></i>
                <span>{{:projectMemberCntF}}</span>
			</div>
            <div class="bbs">
            	<i class="fa fa-window-restore" aria-hidden="true"></i>
                <span>{{:projectWorkCntF}}</span>
			</div>
			<div class="member">
            	<i class="fa fa-heart-o" aria-hidden="true" style="font-weight: bold"></i>
                <span>{{:likeCnt}}</span>
			</div>
            <!--<div class="file-num">
            	<i></i>
                <span>파일 : {{:projectWorkFileCntF}}</span>
			</div>-->
			<span class="update">{{:displayTime}}</span>
		</div>
	</a></li>
</script>
<script type="text/javascript">
	
	/* project list 탬플릿 */
	var projectLitTemplete = $('#tmpl-listView').html();

	/* list form 객체 */
	var listForm = null;
	/* 진행중인 프로젝트 객체 */
	var designProjectIngView = null;
	/* 완료된 프로젝트 객체 */
	var designProjectComView = null;
	
	/* 초기화 */
	$(function(){
		
		/* 진행중인 프로젝트 객체 생성 */
		designProjectIngView = new ListView({
			id : 'designProjectIngView'
			, htmlElement : $('#ing-project-list')
			, data : {progressStatus:'<%=CmnConst.ProjectProgressStatus.PROGRESS%>'}
		});
		
		/* 완료된 프로젝트 객체 생성 */
		designProjectComView = new ListView({
			id : 'designProjectComView'
			, htmlElement : $('#done-project-list')
			, data : {progressStatus:'<%=CmnConst.ProjectProgressStatus.COMPLETE%>'}
		}); 
		
		/* 프로젝트목록 조건 form */
		listForm = $('#listParamForm');
		/* 파라미터 초기화 */
		initParam();
		
		/* 이벤트 : 사용자 그룹 변경 */
		
		$('#sch_my_group select').on('change', function(){
			var val = $(this).find('option:selected').val();
			var text = $(this).find('option:selected').text();
			listForm.find('input[name="schMyGroup"]').val(val);
			listForm.find('input[name="schMyGroupName"]').val(text);
			listForm.find('input[name="schPPage"]').val('1');
			listForm.find('input[name="schCPage"]').val('1');
			listForm.find('input[name="schProgressStatus"]').val('');
			listForm.prop('action', '/project/project.do');
			listForm.submit();
			
		});
		
		
		/* 데이터 로드: 탭 click시  */
		
		var projectTab = $('.tab-wrap li.ing');
		$(projectTab).click(function(){
			initParam();
			designProjectIngView.clear(); 
			loadProject(designProjectIngView); 
		});
		
		//var projectDoneTab = $('.tab-wrap li.done');
		//$(projectDoneTab).click(function(){
			//initParam();
			//designProjectComView.clear();
			//loadProject(designProjectComView);
		//});
		
		
		/* 윈도우 스크롤 이벤트 : 프로젝트 로드 */
		$(window).on('scroll', function(e){
			/* 스크롤이 최하단일 경우 프로젝트 로드 */
        	if ( $(window).scrollTop() > $(document).height() - $(window).height() - 10) {
				console.log("work");
        		var targetView = $('#ing-project').hasClass('active') ? designProjectIngView : null;
        		if( !targetView || ! targetView.data('existList') ){
        			return;
        		}
        		
        		loadProject(targetView, true);
            }
		});
		
		
	});
	
	/**
	 * 검색 파라미터 초기화
	 */
	function initParam(){
		var from = listForm;
		from.find('input[name="projectSeq"]').val('');
		
		/* 첫번째 option 선택 */
		$('#sch_my_group select > option[value=""]').prop('selected', true);
		var name = $('#sch_my_group select > option:selected').text();
		$('#sch_my_group input:text').val(name);
		
		from.find('input[name="schPPage"]').val('<%=StringUtil.emptyToString(schPPage, "1") %>');
		from.find('input[name="schCPage"]').val('<%=StringUtil.emptyToString(schCPage, "1") %>');
		
	}
	
	// sorting
    function sortProduct(sortType){
    	listForm.find('input[name="schMyGroup"]').val('');
    	
        sortType = sortType || '';
        var from = listForm;
        from.find('input[name="seq"]').val('');
        from.find('input[name="schPPage"]').val('<%=StringUtil.emptyToString(schPPage, "1") %>');
        from.find('input[name="schSort"]').val(sortType);
        from.submit();
        
    }
	
    function sortProject(sortType){
    	sortType = sortType || '';
    	$.ajax({
            url : "/project/selectGroupList.ajax",
            type: "GET",
            cache: false,
            data : {'sortType':sortType},
            success : function(_data){
                console.log('>>> _data: ');
                console.log(_data);
                var listData = _data.list;
                var listCount = listData.length;
                var existList = listCount > 0;
                var allCount = _data.all_count;
                groupListView.putData('existList', existList);
                if( ! existList ){
                    return;
                }
                groupListView.addAll({keyName:'seq', data:listData, htmlTemplate: groupListTemplete});
            }
        });
        groupListView.clear();
        groupLoadPage(groupListView);
        
        if(sortType == ""){
            $("#gsort1").addClass("active");
            $("#gsort2").removeClass("active");
        }else if(sortType =="NAME"){
            $("#gsort2").addClass("active");
            $("#gsort1").removeClass("active");
        }
    }
	
	</script>
	

	
	
<script>
	/**
	 * 프로젝트 상세 화면 이동
	 */
	function goProject(projectSeq){
		listForm.find('input[name="projectSeq"]').val(projectSeq);
		listForm.prop('action', '/project/openProjectDetail.do');
		listForm.submit();
		
	}
	
	/* scroll 데이터 로드 여부 */
	var flagScrollLoad = false;
	/**
	 * 프로젝트 데이터 로드
	 */
	function loadProject( targetView, flagScroll ){
		
		/* sorting 버튼 처리 */
		$('#sortingGroup').css('display', 'none');
		targetView.id == 'designProjectIngView' ? $('#sortingProj').css('display', 'block') : $('#sortingProj').css('display', 'none');
		
		var schSort = $('#listParamForm input[name="schSort"]').val();
		 $("#sortingProj > .btn-red").removeClass("active");
		if (schSort == 'null' || schSort == ''){
			$('#psort1').addClass("active");
		} else if (schSort == "LIKE") {
			$('#psort2').addClass("active");
		} else if (schSort == "MEMBER"){
			$('#psort3').addClass("active");
		} 
		
		/* 스크롤 */
		if( flagScroll ){
			if( flagScrollLoad ){
				return;
			}
			
			flagScrollLoad = true;		
		}
		var schProgressStatus = targetView.data('progressStatus');
		
		var from = listForm;
		var pageTarget = targetView.id == 'designProjectIngView' ? from.find('input[name="schPPage"]') : from.find('input[name="schCPage"]');
		from.find('input[name="schProgressStatus"]').val(schProgressStatus);
		
		$.ajax({
			url : "/project/projectList.ajax",
	        type: "GET",
	        cache: false,
			data : from.serializeArray(),
			success : function(_data){
				console.log(_data);
				if( flagScroll ) flagScrollLoad = false;		
				
				var allCount = _data.all_count;
				var item = _data.item;
				
				if(item.thirdCategoryNm != null && item.thirdCategoryNm != "") {
					$('#project_all_cnt').html('프로젝트 > ' + item.firstCategoryNm + ' > ' + item.secondCategoryNm + ' > ' + item.thirdCategoryNm + '(' + formatNumberCommaSeparate(allCount) + '건)');	
				} else if(item.secondCategoryNm != null && item.secondCategoryNm != "") {
					$('#project_all_cnt').html('프로젝트 > ' + item.firstCategoryNm + ' > ' + item.secondCategoryNm + '(' + formatNumberCommaSeparate(allCount) + '건)');
				} else if(item.firstCategoryNm != null && item.firstCategoryNm != "") {
					$('#project_all_cnt').html('프로젝트 > ' + item.firstCategoryNm + '(' + formatNumberCommaSeparate(allCount) + '건)');
				} else {
					$('#project_all_cnt').html('프로젝트 (' + formatNumberCommaSeparate(allCount) + '건)');
				}

				var listData = _data.list;
				var listCount = listData.length;				
				var existList = listCount > 0; 
				targetView.putData('existList', existList);
				if( ! existList ){
					return;
					
				}
				
				//var totalCount = _data.total_count;			
				var intPageCount = parseInt(pageTarget.val(), 10);
				intPageCount++;
				pageTarget.val(intPageCount);
				
								
				targetView.addAll({keyName:'seq', data:listData, htmlTemplate:projectLitTemplete });
				
			},
			error : function(req){
				if( flagScroll ) flagScrollLoad = false;
				console.log("fail to loadProject processing!");
			}
		});
	}
</script>







<!-- ################# 그룹 탭  ###################### -->
<%
	//그룹 페이지 인덱스
	String schPage = request.getParameter("schPage");
%>
<form id="groupListForm" name="groupListForm" method="GET" action="" >
	<input type="hidden" name="schPage" value="" /> 	<!-- 페이지번호 --> 
	<input type="hidden" name="schLimitCount" value="100" />
</form>
<script id="tmpl-groupListView" type="text/x-jsrender">
	<li class="group-list-li"><a href="javascript:void(0);" onclick="goGroupDetailView(this, {{:seq}});" data-nm="{{:groupName}}" >
		<div class="project-info">
			<div class="head-groupName">
				<span>{{:groupName}}</span>
			</div>
			<div class="head-writtenDate">
				<span>{{:registerTime.substr(0, 4)+'-'+registerTime.substr(4, 2)+'-'+registerTime.substr(6, 2)}}</span>
			</div>
			<!-- <div class="head-updateDate">
				<span>{{:updateTime.substr(0, 4)+'-'+updateTime.substr(4, 2)+'-'+updateTime.substr(6, 2)}}</span>
			</div> -->
			<div class="head-leader">
				<span>{{:memberName}}</span>
			</div>
			<div class="head-projectNum">
				<span>{{:projectCntF}}</span>
			</div>
			<div class="head-memberNum">
				<span>{{:memberCntF}}</span>
			</div>
			<!--div class="bbs">
				<i>{{:workCntF}}</i>
				<span>게시물</span>
			</div-->
		</div>
	</a></li>
</script>


<script type="text/javascript">
	
	/* list 탬플릿 */
	var groupListTemplete = $("#tmpl-groupListView").html();
	/* list form 객체 */
	var groupListForm = null;
	/* view 객체 */
	var groupListView = null;
	
	/* 초기화 */
	$(function(){
		/* 뷰 객체 생성 */
		groupListView = new ListView({
			htmlElement : $('#groupListView')
		});
		
		/* 프로젝트목록 조건 form */
		groupListForm = $('#groupListForm');
		/* 파라미터 초기화 */
		groupInitParam();
		
		/* 데이터 로드: 탭 click시  */
		//groupLoadPage(groupListView);
		$('.tab-wrap li.complete').click(function(){
			groupInitParam();
			groupListView.clear();
			groupLoadPage(groupListView);
			$('.project-list-head').css('display', 'block');
			
			/* sorting 버튼 처리 */
			$('#sortingProj').css('display', 'none');
			$('#sortingGroup').css('display', 'block');
		});
		
		/* 윈도우 스크롤 이벤트 : 프로젝트 로드 */
		$(window).on('mousewheel', function(e){
			if( e.originalEvent.wheelDelta / 120 > 0 ) {
				// to do nothing...
	        } else {
	        	/* 스크롤이 최하단일 경우 프로젝트 로드 */
	        	if ( $(window).scrollTop() == $(document).height() - $(window).height()) {
	        		var targetView = $('#group-tab').hasClass('active') ? groupListView : null;
	        		if( ! targetView || ! targetView.data('existList') ){
	        			return;
	        		}
	        		
	        		groupLoadPage(targetView, true);
	            }
	        }
		});
	});
	
	/**
	 * 검색 파라미터 초기화
	 */
	function groupInitParam(){
		var from = groupListForm;
		from.find('input[name="schPage"]').val('<%=StringUtil.emptyToString(schPage, "1") %>');

		var from = listForm;
		from.find('input[name="projectSeq"]').val('');
		
		/* 첫번째 option 선택 */
		$('#sch_my_group select > option[value=""]').prop('selected', true);
		
		/* 파라미터 option 선택 */
		var val = listForm.find('input[name="schMyGroup"]').val();
		$('#sch_my_group select > option[value="' + val + '"]').prop('selected', true);
		
		var name = $('#sch_my_group select > option:selected').text();
		if (name.length > 9){
			name = name.substr(0, 9) + "...";
		}
		$('#sch_my_group input:text').val(name);
		
	}
	
	
	/* scroll 데이터 로드 여부 */
	var flagScrollLoadGroupDetail = false;
	/**
	 * 프로젝트 데이터 로드
	 */
	function groupLoadPage( targetView, flagScroll ){
		/* 스크롤 */
		if( flagScroll ){
			if( flagScrollLoadGroupDetail ){
				return;
			}
			
			flagScrollLoadGroupDetail = true;		
		}
		
		var from = groupListForm;
		var pageTarget = from.find('input[name="schPage"]');
		
		$.ajax({
			url : "/project/selectGroupList.ajax",
	        type: "GET",
	        cache: false,
			data : from.serializeArray(),
			success : function(_data){
				console.log('>>> _data: ');
				console.log(_data);
				if( flagScroll ) { flagScrollLoadGroupDetail = false; }		
				
				var listData = _data.list;
				var listCount = listData.length;
				var existList = listCount > 0;
				
				var allCount = _data.all_count;
				$('#project_all_cnt').html('그룹 (' + formatNumberCommaSeparate(allCount) + '건)');
				
				targetView.putData('existList', existList);				
				if( ! existList ){					
					return;
					
				}
				
				var intPageCount = parseInt(pageTarget.val(), 10);
				intPageCount++;
				pageTarget.val(intPageCount);
				
				targetView.addAll({keyName:'seq', data:listData, htmlTemplate: groupListTemplete });
				
			},
			error : function(req){
				if( flagScroll ) {flagScrollLoadGroup = false;}
				console.log("fail to groupLoadPage processing!");
			}
		});
	}
</script>

<!-- ########## 그룹 상세 ########## -->
<script>
/**
 * group 상세 페이지
 */
function goGroupDetailView(_this, seq) {
	var name = $(_this).attr("data-nm");
	window.location.href='/project/project.do?schMyGroup=' + seq + '&schMyGroupName=' + name;
}
</script>


<!-- 공개일때만 상세조회 가능 -->
<script id="tmpl-groupDetail" type="text/x-jsrender">
	{{if publicYn !== 'N' }} 
	<li><a href="javascript:goProject({{:seq}});" >
	{{else}}
		{{if isProjectMember }}
		<li><a href="javascript:goProject({{:seq}});" >
		{{else}}
		<li style="display: none">
		{{/if}}
	{{/if}}
 		<div class="img-area">
        	<img src="{{:fileUrlM}}" onerror="setDefaultImg(this, 5);" alt="">
		</div>
    	<dl>
        	<dt>{{:projectName}}</dt>
			<dd>{{:ownerName}}님의 프로젝트</dd>
		</dl>
       
        <div class="project-info">
			<div class="member">
            	<i class="fa fa-user" aria-hidden="true"></i>
                <span>{{:projectMemberCntF}}</span>
			</div>
            <div class="bbs">
            	<i class="fa fa-window-restore" aria-hidden="true"></i>
                <span>{{:projectWorkCntF}}</span>
			</div>
			<div class="member">
            	<i class="fa fa-heart-o" aria-hidden="true" style="font-weight: bold"></i>
               	<span>{{:likeCnt}}</span>
			</div>

            <!-- <div class="file-num">
            	<i>{{:projectWorkFileCntF}}</i>
                <span>파일</span>
			</div> -->
			<span class="update">{{:displayTime}}</span>
		</div>
	</a></li>
</script>
<script>
	var groupDetailTemplate = $('#tmpl-groupDetail').html();
	/** 그룹 상세 */
	function groupDetailLoadPage(schMyGroup, schMyGroupName){
		$.ajax({
			url : "/project/selectGroupDetail.ajax",
	        type: "GET",
	        cache: false,
			data : {schMyGroup : schMyGroup, schMyGroupName: schMyGroupName},
			success : function(_data){
				console.log('>>> _data2: ');
				console.log(_data);
				
				groupListView.clear();
				
				var listData = _data.list;
				var listCount = listData.length;
				var allCount = _data.all_count;

				$('#project_all_cnt').html(schMyGroupName+'(' + formatNumberCommaSeparate(allCount) + '건)');
				groupListView.addAll({keyName:'seq', data:listData, htmlTemplate: groupDetailTemplate });
				
			},
			error : function(req){
				console.log("fail to groupDetailLoadPage processing!");
			}
		});
		
		$('.project-list-head').css('display', 'none');
		$('#sortingProj').css('display', 'none');
	}

</script>


<script>

/** 탭 페이지 init */
$(function(){
	var schMyGroup = '<%=StringUtils.stripToEmpty(schMyGroup)%>';
	var schMyGroupName = '<%=StringUtils.stripToEmpty(schMyGroupName)%>';
	console.log('>>> schMyGroup=' + schMyGroup);
	if(schMyGroup != '') {
		// tab ui 처리 :
		changeTabActiveUI('.tab-wrap li.complete');
		groupDetailLoadPage(schMyGroup, schMyGroupName);
	} else {
		changeTabActiveUI('.tab-wrap li.ing');
		$('.tab-wrap li.ing').trigger('click');
	}
});

function changeTabActiveUI(tabLiObjSel) {
	var tabAObj = $(tabLiObjSel).find('a'); 
	var target = tabAObj.attr('href');
	tabAObj.parent().addClass('active').siblings().removeClass('active');
	$(target).addClass('active').siblings().removeClass('active');
}


</script>
<!-- ################# ]]그룹 탭  ###################### -->



<!-- 도움말 모달 -->

	<div class="modal" id="help-modal-project">
		<div class="bg"></div>
		<div class="modal-inner helpModal">
			<div class="modal-body">
				<h3 align="center">함께하는 디자인</h3>
				<div class="row">
					<h4>1. 프로젝트</h4>
					<p>상단 메뉴에서 프로젝트 버튼을 눌러 프로젝트 페이지로 넘어갑니다.</p>
					<img src="/resources/image/help/pro1.png">
					<p>프로젝트 등록 버튼을 클릭하여 새로운 프로젝트를 등록합니다.</p>
					<img src="/resources/image/help/proprocess1.png">
					<p>프로젝트 등록 페이지에서 양식에 맞추어 프로젝트 등록을 진행합니다.</p>
					<p>멤버를 검색해 프로젝트 멤버로 초대할 수 있습니다.</p>
					<p>프로젝트 서비스를 통해 여러 사람이 공동으로 디자인 프로젝트를 진행 할 수 있습니다.</p>
					<img src="/resources/image/help/proprocess2.png">

					<p>세부 프로젝트 주제를 추가하고, 각 주제에 맞는 작품을 추가하며 프로젝트를 진행해 나갑니다.</p>
					<img src="/resources/image/help/pro4.png">
					<p>또한 주제 추가를 프로젝트 성격에 맞추어 주차별, 기능별, 프로젝트에 참여한 사람의 이름명으로 하여 자유롭게 프로젝트를 진행할 수 있습니다.</p>
					<img src="/resources/image/help/pro5.png">
					<img src="/resources/image/help/pro6.png">
					<img src="/resources/image/help/pro7.png">
					<h4>2. 그룹</h4>
					<p>프로젝트 그룹 기능을 이용하여 학교나 기업체 같은 조직에서 프로젝트 팀들을 편리하게 관리할 수 있습니다.</p>
					<img src="/resources/image/help/grpro1.png">
					<img src="/resources/image/help/grpro2.png">
				</div>
			</div>
			<button type="button" class="btn-close"><i class="fa fa-times fa-2x" aria-hidden="true"></i></button>
		</div>
	</div>
	


</body>
</html>