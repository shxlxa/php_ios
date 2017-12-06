<?php 

  
$handle = opendir('videos');
while( ($filename = readdir($handler)) !== false ) 
{
      3、目录下都会有两个文件，名字为’.'和‘..’，不要对他们进行操作
      if($filename != “.” && $filename != “..”)
      {
      4、进行处理
      //这里简单的用echo来输出文件名
      echo $filename;
      }
}
closedir($handle);

?>