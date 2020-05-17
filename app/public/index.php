<?php
define('ROOT',dirname(__FILE__,2));
var_dump(ROOT);

file_put_contents(ROOT.'/test','44444444');
var_dump(__FILE__);

phpinfo();