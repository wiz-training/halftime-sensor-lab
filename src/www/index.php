<?php
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wizards Landing Page</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap");

        body {
            margin: 0;
            padding: 0;
            font-family: "Roboto", sans-serif;
            color: #fff;
            background: #000;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .stars {
            width: 2px;
            height: 2px;
            background: transparent;
            box-shadow: 0 0 3px #fff;
            animation: star-animation 100s linear infinite;
        }
        @keyframes star-animation {
            from { transform: translateY(0); }
            to { transform: translateY(-2000px); }
        }
        .starfield {
            width: 100%;
            height: 2000px;
            position: absolute;
            top: 0;
            left: 0;
            overflow: hidden;
            z-index: -1;
        }
        .container {
            position: relative;
            text-align: center;
            padding: 20px;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 0.5em;
            color: #ffcc00;
            text-shadow: 0 0 10px #ffcc00;
        }
        p {
            font-size: 1.2em;
            max-width: 600px;
            margin: 20px auto;
            text-shadow: 0 0 5px #999;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 1em;
            color: #000;
            background-color: #ffcc00;
            border: 2px solid #ffcc00;
            text-decoration: none;
            margin-top: 20px;
            transition: all 0.3s ease;
        }
        .button:hover {
            background-color: #333;
            color: #ffcc00;
        }
        .footer {
            margin-top: 50px;
            font-size: 1em;
            text-shadow: 0 0 5px #999;
        }
    </style>
</head>
<body>
    <div class="starfield">';
        for ($i = 0; $i < 500; $i++) {
            echo '<div class="stars" style="top: ' . rand(0, 2000) . 'px; left: ' . rand(0, 100) . 'vw;"></div>';
        }
    echo '</div>
    <div class="container">
        <h1>Welcome to the Wizarding World</h1>
        <p>Unleash your magical potential and explore the secrets of the arcane. Join our community of wizards and embark on an enchanting journey like no other.</p>
        <a href="#" class="button">Join the Magic</a>
        <div class="footer">
            &copy; ' . date("Y") . ' Wizarding World. All rights reserved.
        </div>
    </div>
</body>
</html>';
?>
