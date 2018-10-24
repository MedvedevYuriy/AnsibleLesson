<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
$status = "OK";
$code = 0;
$result = 0;
$a = $_GET['a'];
$b = $_GET['b'];
if ($a == null) {
    $status = "param A is missing";
    $code = 1;
} else if (!is_numeric($a)) {
    $status = "param A is not a number";
    $code = 2;
}
if ($b == null) {
    $status = "param B is missing";
    $code = 3;
} else if (!is_numeric($b)) {
    $status = "param B is not a number";
    $code = 4;
}
if ($code == 0) $result = $a - $b;
echo json_encode(array('Status'=>$status,'Code'=>$code,'Result'=>$result)), "\n";
?>
