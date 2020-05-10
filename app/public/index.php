<?php
require __DIR__.'/../vendor/autoload.php';

Predis\Autoloader::register();
$client = new Predis\Client();
$client->connect('redis');
$client->set('foo', 'bar');
$value = $client->get('foo');

echo $value;

$redis = new Redis();
//Connecting to Redis
$redis->connect('redis', 6379);

if ($redis->ping()) {
    echo "PONG\n";
}