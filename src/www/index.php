<?php
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ollivanders Online - Wand Shop</title>
    <link rel="icon" href="images/logo.png" type="image/png">
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap");

        body {
            margin: 0;
            padding: 0;
            font-family: "Roboto", sans-serif;
            color: #ffffff;
            background-color: #1f1f1f;
            overflow-x: hidden;
        }
        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            background-color: #333;
            padding: 10px 20px;
            z-index: 1000;
            display: none; /* Hidden by default */
            justify-content: center;
            align-items: center;
            transition: opacity 0.5s ease-in-out;
        }
        .navbar a {
            color: #ffffff;
            text-decoration: none;
            margin: 0 15px;
            font-size: 1.2em;
        }
        .logo {
            max-width: 200px;
            transition: all 0.5s ease;
            position: fixed;
            left: 50%;
            top: 20px;
            transform: translateX(-50%);
            z-index: 1001;
        }
        .container {
            text-align: center;
            padding: 200px 20px 20px 20px;
        }
        h1 {
            font-size: 3em;
            color: #00d4ff;
            text-shadow: 0 0 10px #00d4ff;
            margin: 20px 0;
        }
        .wand-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .wand {
            background-color: #333;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            text-align: center;
            transition: transform 0.3s;
        }
        .wand:hover {
            transform: scale(1.05);
        }
        .wand img {
            max-width: 100%;
            height: auto;
            margin-bottom: 15px;
        }
        .wand h2 {
            font-size: 1.5em;
            color: #00d4ff;
        }
        .wand p {
            font-size: 1.1em;
            color: #cccccc;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 1em;
            color: #ffffff;
            background-color: #00d4ff;
            border: 2px solid #00d4ff;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 10px;
            transition: background-color 0.3s;
        }
        .button:hover {
            background-color: #007a99;
            border-color: #007a99;
        }
        .footer {
            margin-top: 50px;
            font-size: 1em;
            color: #cccccc;
            text-shadow: 0 0 5px #999999;
            padding-bottom: 20px;
        }
        /* Hidden by default */
        .wand-grid.hidden {
            opacity: 0;
            transform: translateY(50px);
            transition: opacity 0.5s ease-out, transform 0.5s ease-out;
        }
        /* Visible when scrolled */
        .wand-grid.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
    <script>
        window.addEventListener("scroll", function() {
            var logo = document.querySelector(".logo");
            var navbar = document.querySelector(".navbar");
            var hiddenGrid = document.querySelector(".wand-grid.hidden");
            var scrollPosition = window.scrollY;

            if (scrollPosition > 50) {
                logo.style.maxWidth = "75px";
                logo.style.left = "99%";
                logo.style.transform = "translateX(-99%)";
                navbar.style.display = "flex";
                navbar.style.opacity = "1";
            } else {
                logo.style.maxWidth = "200px";
                logo.style.left = "50%";
                logo.style.transform = "translateX(-50%)";
                navbar.style.opacity = "0";
                navbar.style.display = "none";
            }

            if (scrollPosition > 300) {
                hiddenGrid.classList.add("visible");
            }
        });
    </script>
</head>
<body>
    <img src="images/logo.png" alt="Ollivanders Online" class="logo">

    <div class="navbar">
        <a href="#">Home</a>
        <a href="#">Products</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
    </div>

    <div class="container">
        <h1>Welcome to Ollivanders Online</h1>
        <p>Your one-stop shop for magical wands, crafted with precision and enchanted with power. Choose your wand and unleash your magic!</p>

        <div class="wand-grid">
            <div class="wand">
                <img src="images/wand1.png" alt="Elder Wand">
                <h2>Elder Wand</h2>
                <p>The most powerful wand in existence, crafted from elder wood and a Thestral tail core.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand2.png" alt="Phoenix Feather Wand">
                <h2>Phoenix Feather Wand</h2>
                <p>Made from holly wood with a core of phoenix feather, known for its versatility and loyalty.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand3.png" alt="Dragon Heartstring Wand">
                <h2>Dragon Heartstring Wand</h2>
                <p>Powerful and temperamental, made from yew wood and a dragon heartstring core.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand4.png" alt="Unicorn Hair Wand">
                <h2>Unicorn Hair Wand</h2>
                <p>Reliable and faithful, made from willow wood with a unicorn hair core.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
        </div>

        <!-- New row of wands -->
        <div class="wand-grid hidden">
            <div class="wand">
                <img src="images/wand5.png" alt="Veela Hair Wand">
                <h2>Veela Hair Wand</h2>
                <p>Crafted from rosewood with a core of Veela hair, known for its delicate and unpredictable magic.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand6.png" alt="Acromantula Web Wand">
                <h2>Acromantula Web Wand</h2>
                <p>Spun from black walnut wood with a core of Acromantula web, offering a strong and sinister power.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand7.png" alt="Basilisk Horn Wand">
                <h2>Basilisk Horn Wand</h2>
                <p>Powerful and rare, made from ebony wood with a core of basilisk horn, ideal for Dark Arts.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
            <div class="wand">
                <img src="images/wand8.png" alt="Thestral Hair Wand">
                <h2>Thestral Hair Wand</h2>
                <p>Crafted from pine wood with a core of Thestral hair, offering powerful yet enigmatic magic.</p>
                <a href="#" class="button">Buy Now</a>
            </div>
        </div>

        <div class="footer">
            &copy; ' . date("Y") . ' Ollivanders Online. All rights reserved.
        </div>
    </div>
</body>
</html>';
?>
