<?php

  $name = $_POST['name'];
  $email = $_POST['email'];
  $message = $_POST['body'];

  $to = "info@claudetech.com";
  $subject = "[Claude Tech]　コンタクトフォームからのお問い合わせです。";
  $message = "FROM:\r\n$name\r\n\r\nEmail:\r\n$email\r\n\r\nMessage:\r\n$message";
  $headers = 'From: no-reply@claudetech.com' . "\r\n";

  if (filter_var($email, FILTER_VALIDATE_EMAIL)) { // this line checks that we have a valid email address
    mail($to, $subject, $message, $headers); //This method sends the mail.
    echo "Your email was sent!"; // success message
  }else{
    echo "Invalid Email, please provide an correct email.";
  }

?>
