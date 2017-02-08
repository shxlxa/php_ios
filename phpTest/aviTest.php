<?php
	
	//request 请求既可以执行 POST 也可以执行 GET 请求
    //$data = $_GET;
    //$data = $_POST;

    define('DB_HOST','localhost');
    define('DB_USER','root');
    define('DB_PWD','19890301');
    define('DB_NAME','Person');

    $data = $_REQUEST;
    
    $name = $data["name"];
    $password = $data["password"];
    $array = array();
    //登录服务器数据库 第一个参数：数据库服务器地址，第二个参数：服务器用户名；第三个参数：密码
    $connect = mysqli_connect(DB_HOST,DB_USER,DB_PWD);
    if($connect){
//         echo('连接服务器成功');
        $array["status"] = 1;

    }else{
//        echo("连接失败");
        die;
        $array["status"] = 0;
    }
    //选择数据库
    mysqli_select_db($connect,DB_NAME);

    $_clean = array();
    $_clean['name'] = $name;
    $_query = mysqli_query($connect,"SELECT * FROM register WHERE name='{$_clean['name']}'");
    if (mysqli_fetch_array($_query,MYSQLI_ASSOC)){
        $array["result"] = "注册失败:该用户已经被注册";
    } else{
        //将用户名、密码插入到数据库中
        if(mysqli_query($connect,"INSERT INTO register(name, password) VALUES('$name','$password')")){
            //echo("插入成功");
            $array["result"] = "success";
        }else{
            //echo("插入失败");
            $array["result"] = "insert error:".mysqli_error($connect);
        }
    }
    echo(json_encode($array));

?>