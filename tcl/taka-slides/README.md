Simple plaintext presentation compiller (plain text -> html).

 - one slide per paragraph;
 - line started with # ignored;
 - image slige: @FILE.png
 - empty slide: just use a \ as a paragraph;

Not need latex, libreoffice or any other fancy file format, it uses plaintext files to describe the slides and can also display images. Every paragraph represents a slide in the presentation. Especially for presentations using the Takahashi method this is very nice and allows you to write down the presentation for a quick lightning talk within a few minutes.

Compillation:

`taka-slides.tcl source.txt > compiled.html`
