<style type="text/css">
     @keyframes spinner {
        to {transform: rotate(360deg);}
    }
 
    .spinner:before {
        content: '';
        box-sizing: border-box;
        position: absolute;
        
        left: 50%;
        width: 20px;
        height: 20px;
        margin-top: -10px;
        margin-left: -10px;
        border-radius: 50%;
        border: 2px solid #ccc;
        border-top-color: #333;
        animation: spinner .6s linear infinite;
    }
    .scrollable-ul { min-height:100px;max-height: 550px; overflow-y: auto;overflow-x: auto; }

    .notification-time { 
        font-size: 11px !important;
        font-weight: 400;
        margin: 3px;
    }
    .img-size-50{
        width: 50px;
        height: 50px;
        border: 3px solid #eee;
    }
</style>
<li class="nav-item dropdown"  ng-controller="MainCtrl" id="MainCtrl">
    <a href="#" class="nav-link font-1" data-bs-toggle="dropdown" ng-click="fbNotify()" title="In app Notifiaction">
        <i class="fas fa-bell in-app-icon"></i>
        <span class="badge badge-warning navbar-badge" ng-bind="notiNum" style="right: 1px !important;"></span>
    </a>
    <div class="dropdown-menu dropdown-menu-xl dropdown-menu-right scrollable-ul" when-scrolled="loadApi()">
        
        <span class="dropdown-header">Notifications</span>

        <!-- inner menu: contains the actual data -->
        
        <div id=seen@{{$index}}  ng-repeat="noti in notifications.data">

            <div class="dropdown-divider"></div>

            <a href="javascript:;" class="dropdown-item" ng-click="newTab(noti.url,noti.id)">
                
                <div class="media">
                    
                    <img ng-src="@{{noti.requester.profile_pic}}" onerror="this.src='{{assetLink('image','contacthead')}}'" 
                        alt="User Avatar" class="img-size-50 mr-3 img-circle">
                    
                    <div class="media-body">
                        
                        <h3 class="dropdown-item-title">
                            @{{noti.user}}
                        </h3>
                        
                        <p class="text-sm" ng-bind-html="$sce.trustAsHtml(noti.message)"></p>
                        
                        <p class="text-sm text-muted"><i class="far fa-clock mr-1"></i> @{{noti.created_at}}</p>
                    </div>
                </div>
            </a>
        </div>
        
        <div class="spinner" ng-hide="showing" style="padding :35px;">
                 
        </div>
    </div>
</li>
@push('scripts')

<script>
    app.controller('MainCtrl', function($scope,$http, $sce,$window,$compile,$rootScope, $timeout){
        $scope.$sce=$sce;
        $scope.count=0;
        var count_api = "{!! url('notification/api/unseen/count') !!}/{{Auth::user()->id}}";
        
        $http.get(count_api).then(function(response){
            if(response.data.count>9){
                    $scope.notiNum="9+";
            } else {
                $scope.notiNum=response.data.count;
            } 
        })
    
        $scope.fbNotify=function(){
            var notification_url = "{!! url('notification/api') !!}/{{Auth::user()->id}}";

            $http.get(notification_url).then(function(response){
                $scope.showing=true;
                $scope.notifications=response.data;

                for(var i in $scope.notifications.data){
                    if ($scope.notifications.data[i].requester == null) {
                        $scope.notifications.data[i]['user']= '{!! Lang::get("lang.system") !!}';
                        var $profile_pic = "{{assetLink('image','system')}}";
                        $scope.notifications.data[i]['requester']= {'profile_pic':$profile_pic};
                    } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null&&$scope.notifications.data[i].requester.changed_by_user_name==null){
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                    } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""&&$scope.notifications.data[i].requester.changed_by_user_name==""){
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                    } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""){
                       $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                    } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null){
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                    } else if($scope.notifications.data[i].requester.changed_by_first_name==null){
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_last_name;
                    } else if($scope.notifications.data[i].requester.changed_by_last_name==null){
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name;
                    } else{
                        $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name+" "+$scope.notifications.data[i].requester.changed_by_last_name;
                    }
                }

                setTimeout(function(){ 
                    for(var i in $scope.notifications.data){
                        if($scope.notifications.data[i].seen=="0"){
                            var id='seen'+i;
                            var seenColor=document.getElementById(id);
                            seenColor.style.backgroundColor ="#edf2fa";
                        }
                    }
                }, 100);
            });
        };

        $scope.loadApi= function(){
            $scope.count++;
            $scope.showing=false; 
          
            if($scope.notifications.next_page_url==null){
                $scope.showing=true; 
            }
            
            if($scope.count==1){
                if($scope.notifications.next_page_url!=null){
            
                    $http.get($scope.notifications.next_page_url).then(function(response){
                        let data = response.data;
                        $scope.showing=true;
                        [].push.apply($scope.notifications.data, data.data);
                        $scope.notifications.next_page_url=data.next_page_url;
                
                        for(var i in $scope.notifications.data){
                  
                            if ($scope.notifications.data[i].requester == null) {
                                $scope.notifications.data[i]['user']= '{!! Lang::get("lang.system") !!}';
                                var $profile_pic = "{{assetLink('image','system')}}";
                                $scope.notifications.data[i]['requester']= {'profile_pic':$profile_pic};
                            } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null&&$scope.notifications.data[i].requester.changed_by_user_name==null){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                            } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""&&$scope.notifications.data[i].requester.changed_by_user_name==""){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                            } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                            } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                            } else if($scope.notifications.data[i].requester.changed_by_first_name==null){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_last_name;
                            } else if($scope.notifications.data[i].requester.changed_by_last_name==null){
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name;
                            } else{
                                $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name+" "+$scope.notifications.data[i].requester.changed_by_last_name;
                            }
                        }

                        setTimeout(function(){ 
                            for(var i in $scope.notifications.data){
                            
                                if($scope.notifications.data[i].seen=="0"){
                                    document.getElementById('seen'+i).style.backgroundColor ="#edf2fa";
                                }
                            }
        
                        }, 100);
                    }, function(error){
                            console.log(error);
                            // self.ResponseDetails = "Data: " + data;
                    })
                    // .error(function (data, status, header, config) {
                    //     self.ResponseDetails = "Data: " + data;
                    // });
                } else {
                    $scope.showing=true;
                }
            } else {
                setTimeout(function(){ 
                    if($scope.notifications.next_page_url!=null){
            
                        $http.get($scope.notifications.next_page_url).then(function(response){
                            let data = response.data;
                            $scope.showing=true;
                            [].push.apply($scope.notifications.data, data.data);
                            $scope.notifications.next_page_url=data.next_page_url;
              
                            for(var i in $scope.notifications.data){
                        
                                if ($scope.notifications.data[i].requester == null) {
                                    $scope.notifications.data[i]['user']= '{!! Lang::get("lang.system") !!}';
                                    var $profile_pic = "{{assetLink('image','system')}}";
                                    $scope.notifications.data[i]['requester']= {'profile_pic':$profile_pic};
                                } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null&&$scope.notifications.data[i].requester.changed_by_user_name==null){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                                } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""&&$scope.notifications.data[i].requester.changed_by_user_name==""){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].by;
                                } else if($scope.notifications.data[i].requester.changed_by_first_name==""&&$scope.notifications.data[i].requester.changed_by_last_name==""){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                                } else if($scope.notifications.data[i].requester.changed_by_first_name==null&&$scope.notifications.data[i].requester.changed_by_last_name==null){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_user_name;
                                } else if($scope.notifications.data[i].requester.changed_by_first_name==null){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_last_name;
                                } else if($scope.notifications.data[i].requester.changed_by_last_name==null){
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name;
                                } else{
                                    $scope.notifications.data[i]['user']=$scope.notifications.data[i].requester.changed_by_first_name+" "+$scope.notifications.data[i].requester.changed_by_last_name;
                                }
                            }    

                            setTimeout(function(){ 
                                for(var i in $scope.notifications.data){
                       
                                    if($scope.notifications.data[i].seen=="0"){
                                        document.getElementById('seen'+i).style.backgroundColor ="#edf2fa";
                                    }
                                }
                            }, 100);
                        }, function(error){
                            console.log(error);
                            // self.ResponseDetails = "Data: " + data;
                        });
                        // .error(function (data, status, header, config) {
                            
                        // });
                    }
                }, 5000);
            }
        };
  
        $scope.newTab=function(x,y){
            var url=x;
            var config={
                params:{
                    notification_id:y
                }
            }
            var api = "{!! url('notification/api/seen') !!}/{{Auth::user()->id}}";
            
            $http.get(api,config).then(function(response){
                //alert("success");  
            }, function(error){
                //alert("failed");
            });
             
            if(url==""||url==null){
               //alert("sorry");
            } else {
                $window.open(x, '_blank');
            }

            var count_api = "{!! url('notification/api/unseen/count') !!}/{{Auth::user()->id}}";
        
            $http.get(count_api).then(function(response){          
                if(response.data.count>9){
                        $scope.notiNum="9+";
                } else {
                    $scope.notiNum=response.data.count;
                } 
            })
        }
    });
</script>
@endpush