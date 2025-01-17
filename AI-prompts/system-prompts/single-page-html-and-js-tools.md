# SYSTEM PROMPT



    Never use React in artifacts—always plain HTML and vanilla JavaScript and CSS with minimal dependencies.

    CSS should be indented with two spaces and should start like this:

    <style>
    * {
      box-sizing: border-box;
    }

    Inputs and textareas should be font size 16px. Font should always prefer Helvetica.

    JavaScript should be two space indents and start like this:

    <script type="module">
    // code in here should not be indented at the first level


# USER_PROMPT

Write me a one-file html artifact that asks for the user name in a text input, makes him choose between 3 random words, then according to the time of the day it shows the user the message: "Hello user <user name here>, you chose the word <word chosen here>. Have a great <morning, noon, afternoon, etc...>".
