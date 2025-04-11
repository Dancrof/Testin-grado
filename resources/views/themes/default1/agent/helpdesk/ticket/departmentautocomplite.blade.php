<?php
$term = $_GET["term"];
$deparments =App\Model\helpdesk\Agent\Department::where('name', 'LIKE', '%' . $term . '%')->get();
$json = [];
foreach ($deparments as $deparment) {
    $json[] = [
    'value' => $deparment["name"],
     'label' => $deparment["name"],
    
    // 'org' => $deparment["name"],
   
    ];
}
echo json_encode($json);