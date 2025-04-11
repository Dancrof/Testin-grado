<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Database Connection error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" integrity="sha512-SzlrxWUlpfuzQ+pcUCosxcglQRNAq/DZjVsC0lE40xsADsfeQoEypE+enwcOiGjk/bSuGGKHEyjSoQ1zVisanQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        *{
            font-family: "Helvetica";
        }

        body{
            background: #E9ECEF;
        }
        .container{
                width: 50%;
        }
        li{
            font-size: 15px;
        }
        p{
            font-size: 15px;
        }

     .buttonfav{
        background-color: #00AEEF;
         color:white;
         border:none;
         height: 35px;
         width:100%;
         border-radius: 5px;
         font-size: large;

        }
     button a {
         text-decoration: none;
         color:white;

     }
     i{
         margin-right: 10px;
     }
    </style>
</head>

<body>
<div class="container">
<div class="d-flex justify-content-center align-items-center" style="height: 100vh;">
    <div class="card">
        <div class="card-header" style="background: white">
           <h3 style="font-size: 20.8px; margin: 1px;">Error establishing a database connection</h3>
        </div>
        <div class="card-body">
            <p>This either means that database information in your .env file is incorrect or we can't contact the database server. This could mean your host database server is down.</p>
            <p>Can you please validate below information.</p>
            <ul>
                <li>Are you sure you have entered correct database username and password?</li>
                <li>Are you sure you have entered correct database name and host name?</li>
                <li>Are you sure that database server is running?</li>
            </ul>

            <p>If you are unsure what these terms means, you can probably contact your administrator.</p>

        <div  class="d-grid gap-2 ">
          <?php  echo (isWhiteLabelEnabled()) ? "":"<a  href='https://support.faveohelpdesk.com/create-ticket'><button class='buttonfav' > <i class='fa fa-refresh '></i>Contact Support</button></a>";?>
        </div>
        </div>

    </div>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN" crossorigin="anonymous"></script>
</body>
</html>


