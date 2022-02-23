<?php

use TelegramBot\Api\BotApi;
use TelegramBot\Api\Types\ReplyKeyboardMarkup;

require_once '../vendor/autoload.php';

define('TELEGRAM_TOKEN', '5057361105:AAEbpC_hW8wZEtAkpN29T-PKdz2X1nGu_1Y');

$rawInput = file_get_contents('php://input');
$request = json_decode($rawInput);
file_put_contents(__DIR__ . '/../test.json', $rawInput, FILE_APPEND);

$chatId = $request->message->from->id;
$messageText = $chatId;

try {
    $bot = new \TelegramBot\Api\Client(TELEGRAM_TOKEN);
    // or initialize with botan.io tracker api key
    // $bot = new \TelegramBot\Api\Client('YOUR_BOT_API_TOKEN', 'YOUR_BOTAN_TRACKER_API_KEY');


    //Handle /ping command
    $bot->command('ping', function($message) use ($bot) {
        $bot->sendMessage($message->getChat()->getId(), 'pong!');
    });

    $bot->command('start', function($message) use ($bot) {
        $answer = 'Добро пожаловать!';
        $bot->sendMessage($message->getChat()->getId(), $answer);
    });
    // команда для помощи
    $bot->command('help', function($message) use ($bot) {
        $answer = 'Команды:
/help - вывод справки';
        $bot->sendMessage($message->getChat()->getId(), $answer);
    });
    //Handle text messages
    $bot->on(function(\TelegramBot\Api\Types\Update $update) use ($bot) {
        $message = $update->getMessage();
        $id = $message->getChat()->getId();

        $keyboard = new ReplyKeyboardMarkup(array(array("one", "two", "three")), true); // true for one-time keyboard

//        $bot->sendMessage($id, 'Your message: ' . $message->getText());
        $bot->sendMessage($id, 'Your message: ' . $message->getText(), null, false, null, $keyboard);

        $keyboard = new \TelegramBot\Api\Types\Inline\InlineKeyboardMarkup(
            [
                [
                    ['text' => 'link', 'url' => 'https://core.telegram.org']
                ]
            ]
        );

        $bot->sendMessage($id, 'Your message: ' . $message->getText(), null, false, null, $keyboard);

    }, function() {
        return true;
    });

    $bot->run();

} catch (\TelegramBot\Api\Exception $e) {
    $bot->sendMessage($e->getMessage());
}

$bot = new BotApi(TELEGRAM_TOKEN);
//
$bot->getMe($chatId, $messageText);


// Set telegram webhook key
//https://api.telegram.org/bot5057361105:AAEbpC_hW8wZEtAkpN29T-PKdz2X1nGu_1Y/setWebhook?url=https://df2e-185-38-209-29.ngrok.io/
