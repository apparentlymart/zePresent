#!/usr/bin/perl
# auto-generated Perl code from input S2 code
package S2;
use strict;
use constant VTABLE => 0;
use constant STATIC => 1;
use constant PROPS => 2;
register_layer(1);
set_layer_info(1,"type","core");
set_layer_info(1,"name","zePresent Core Layer");
set_layer_info(1,"majorversion","1");
register_class(1, "int", {
    'docstring' => "An integer number.  This isn't really a class, as suggested by its lower-case name.  Parameters of type int pass by value, unlike all variables of real object types, which pass by reference.  Instead, this is just a pseudo-class which provides convenience methods on instances of integers.  The other pseudo-class is [class[string]].",
    'vars' => {
    },
    'funcs' => {
        "zeroPad(int digits)" => { 'returntype' => "string", 'docstring' => "Return the integer as a string formatted at least \$digits characters long, left-padded with zeroes.", 'attrs' => "builtin" },
    },
});
register_class(1, "string", {
    'docstring' => "A series of characters.  This isn't really a class, as suggested by its lower-case name.  Parameters of type string pass by value, unlike all variables of real object types, which pass by reference.  Instead, this is just a pseudo-class which provides convenience methods on instances of strings.  The other pseudo-class is [class[int]].",
    'vars' => {
    },
    'funcs' => {
        "subString(int start, int length)" => { 'returntype' => "string", 'docstring' => "Returns up to \$length characters from string, skipping \$start characters from the beginning.", 'attrs' => "builtin" },
        "endsWith(string sub)" => { 'returntype' => "bool", 'docstring' => "Returns true if string ends in \$sub", 'attrs' => "builtin" },
        "startsWith(string sub)" => { 'returntype' => "bool", 'docstring' => "Returns true if string begins with \$sub", 'attrs' => "builtin" },
        "contains(string sub)" => { 'returntype' => "bool", 'docstring' => "Return true if string contains \$sub", 'attrs' => "builtin" },
        "lower()" => { 'returntype' => "string", 'docstring' => "Returns string in lower case.", 'attrs' => "builtin" },
        "upper()" => { 'returntype' => "string", 'docstring' => "Returns string in upper case", 'attrs' => "builtin" },
        "upperFirst()" => { 'returntype' => "string", 'docstring' => "Return string with the first character capitalized.", 'attrs' => "builtin" },
        "length()" => { 'returntype' => "int", 'docstring' => "Return the number of characters in the string.", 'attrs' => "builtin" },
        "repeat(int n)" => { 'returntype' => "string", 'docstring' => "Returns the string repeated n times", 'attrs' => "builtin" },
    },
});
register_class(1, "bool", {
    'vars' => {
    },
    'funcs' => {
    },
});
register_class(1, "Color", {
    'docstring' => "Represents a color.",
    'vars' => {
        "r" => { 'type' => "int", 'readonly' => 1, 'docstring' => "Red value, 0-255." },
        "g" => { 'type' => "int", 'readonly' => 1, 'docstring' => "Green value, 0-255." },
        "b" => { 'type' => "int", 'readonly' => 1, 'docstring' => "Blue value, 0-255." },
        "as_string" => { 'type' => "string", 'docstring' => "HTML hex encoded: #rrggbb" },
    },
    'funcs' => {
        "Color(string s)" => { 'returntype' => "Color", 'docstring' => "Constructor for color class.  Lets you make a Color object from a string of form #rrggbb", 'attrs' => "builtin" },
        "set_hsl(int h, int s, int v)" => { 'returntype' => "void", 'docstring' => "Set a color by hue, saturation and lightness.", 'attrs' => "builtin" },
        "red(int r)" => { 'returntype' => "void", 'docstring' => "Set the red value. (0-255)", 'attrs' => "builtin" },
        "green(int g)" => { 'returntype' => "void", 'docstring' => "Set the green value. (0-255)", 'attrs' => "builtin" },
        "blue(int b)" => { 'returntype' => "void", 'docstring' => "Set the blue value. (0-255)", 'attrs' => "builtin" },
        "red()" => { 'returntype' => "int", 'docstring' => "Get the red value.", 'attrs' => "builtin" },
        "green()" => { 'returntype' => "int", 'docstring' => "Get the green value.", 'attrs' => "builtin" },
        "blue()" => { 'returntype' => "int", 'docstring' => "Get the blue value.", 'attrs' => "builtin" },
        "hue(int h)" => { 'returntype' => "void", 'docstring' => "Set the hue value. (0-255)", 'attrs' => "builtin" },
        "saturation(int s)" => { 'returntype' => "void", 'docstring' => "Set the saturation value. (0-255)", 'attrs' => "builtin" },
        "lightness(int v)" => { 'returntype' => "void", 'docstring' => "Set the lightness value. (0-255)", 'attrs' => "builtin" },
        "hue()" => { 'returntype' => "int", 'docstring' => "Get the hue value. (0-255)", 'attrs' => "builtin" },
        "saturation()" => { 'returntype' => "int", 'docstring' => "Get the saturation value. (0-255)", 'attrs' => "builtin" },
        "lightness()" => { 'returntype' => "int", 'docstring' => "Get the lightness value. (0-255)", 'attrs' => "builtin" },
        "clone()" => { 'returntype' => "Color", 'docstring' => "Returns identical color.", 'attrs' => "builtin" },
        "lighter()" => { 'returntype' => "Color", 'docstring' => "Returns a new color with lightness increased by 30.", 'attrs' => "builtin" },
        "lighter(int amt)" => { 'returntype' => "Color", 'docstring' => "Returns a new color with lightness increased by amount given.", 'attrs' => "builtin" },
        "darker()" => { 'returntype' => "Color", 'docstring' => "Returns a new color with lightness decreased by 30.", 'attrs' => "builtin" },
        "darker(int amt)" => { 'returntype' => "Color", 'docstring' => "Returns a new color with lightness decreased by amount given.", 'attrs' => "builtin" },
        "inverse()" => { 'returntype' => "Color", 'docstring' => "Returns inverse of color.", 'attrs' => "builtin" },
        "average(Color other)" => { 'returntype' => "Color", 'docstring' => "Returns color averaged with \$other color.", 'attrs' => "builtin" },
    },
});
register_class(1, "Font", {
    'vars' => {
    },
    'funcs' => {
        "Font(string fontspec)" => { 'returntype' => "Font", 'docstring' => "Internal constructor allowing font properties to be initialized from strings.", 'attrs' => "builtin" },
        "scale(int percent)" => { 'returntype' => "Font", 'docstring' => "Scale this font to obtain a new font.", 'attrs' => "builtin" },
        "getWidth(string str)" => { 'returntype' => "int", 'docstring' => "Get the width of the given string in this font, in pixels.", 'attrs' => "builtin" },
        "getHeight()" => { 'returntype' => "int", 'docstring' => "Get the height of this font in pixels, including descenders.", 'attrs' => "builtin" },
        "getHeight(string str, int width, int lineheight)" => { 'returntype' => "int", 'docstring' => "Measure the height of the string when word-wrapped into a box of the given width with the given line height, in pixels.", 'attrs' => "builtin" },
        "getBaseLine()" => { 'returntype' => "int", 'docstring' => "Returns the number of pixels between the top of the font and its baseline.", 'attrs' => "builtin" },
    },
});
register_class(1, "Image", {
    'vars' => {
        "width" => { 'type' => "int", 'readonly' => 1 },
        "height" => { 'type' => "int", 'readonly' => 1 },
    },
    'funcs' => {
        "scaleToHeight(int height)" => { 'returntype' => "Image", 'attrs' => "builtin" },
        "scaleToWidth(int width)" => { 'returntype' => "Image", 'attrs' => "builtin" },
        "scaleToRect(int width, int height)" => { 'returntype' => "Image", 'attrs' => "builtin" },
        "scaleToFillRect(int width, int height)" => { 'returntype' => "Image", 'attrs' => "builtin" },
        "scale(int percent)" => { 'returntype' => "Image", 'attrs' => "builtin" },
    },
});
register_class(1, "Graphics", {
    'vars' => {
        "width" => { 'type' => "int", 'readonly' => 1 },
        "height" => { 'type' => "int", 'readonly' => 1 },
    },
    'funcs' => {
        "setPixel(int x, int y, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawLine(int x1, int y1, int x2, int y2, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawArc(int x, int y, int w, int h, int startAngle, int stopAngle, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawEllipse(int x, int y, int w, int h, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawRect(int x1, int y1, int x2, int y2, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "fillRect(int x1, int y1, int x2, int y2, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawPolygon(int[] coords, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "fillPolygon(int[] coords, Color clr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "fill(int x1, int y1, Color fillclr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "fill(int x1, int y1, Color fillclr, Color stopclr)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawImage(Image img, int x, int y)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawImage(Image img, int x1, int y1, int x2, int y2)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "mergeImage(Image img, int x, int y, int alpha)" => { 'returntype' => "void", 'attrs' => "builtin" },
        "drawObject(ContentObject obj, int x1, int y1, int x2, int y2)" => { 'returntype' => "void", 'docstring' => "Draw a child [class[ContentObject]] in the given rectangle.", 'attrs' => "builtin" },
        "drawText(string text, int x, int y, Font font, Color clr)" => { 'returntype' => "void", 'docstring' => "Draw a single line of text with no wrapping.", 'attrs' => "builtin" },
        "drawTextCentered(string text, int x1, int y1, int x2, int y2, Font font, Color clr)" => { 'returntype' => "void", 'docstring' => "Draw a single line of text centered in the given box coordinates.", 'attrs' => "builtin" },
        "drawParagraph(string text, int x1, int y1, int x2, int y2, Font font, Color clr)" => { 'returntype' => "void", 'docstring' => "Draw a paragraph of text wrapped to fit into the given box coordinates with a default line height.", 'attrs' => "builtin" },
        "drawParagraph(string text, int x1, int y1, int x2, int y2, Font font, Color clr, int lineheight)" => { 'returntype' => "void", 'docstring' => "Draw a paragraph of text wrapped to fit into the given box coordinates with the given line height.", 'attrs' => "builtin" },
    },
});
register_class(1, "Presentation", {
    'vars' => {
        "title" => { 'type' => "string" },
        "subtitle" => { 'type' => "string" },
        "author" => { 'type' => "string" },
        "logo" => { 'type' => "Image" },
    },
    'funcs' => {
    },
});
register_class(1, "ContentObject", {
    'vars' => {
    },
    'funcs' => {
        "draw(Graphics g)" => { 'returntype' => "void" },
        "getPreferredSize()" => { 'returntype' => "int[]" },
        "getMinimumSize()" => { 'returntype' => "int[]" },
        "getMaximumSize()" => { 'returntype' => "int[]" },
    },
});
register_class(1, "ImageObject", {
    'parent' => "ContentObject",
    'vars' => {
        "img" => { 'type' => "Image" },
    },
    'funcs' => {
    },
});
register_class(1, "BulletListObject", {
    'parent' => "ContentObject",
    'vars' => {
        "items" => { 'type' => "string[]" },
    },
    'funcs' => {
    },
});
register_class(1, "SideBySideObject", {
    'parent' => "ContentObject",
    'vars' => {
        "splitpercent" => { 'type' => "int" },
        "leftobj" => { 'type' => "ContentObject" },
        "rightobj" => { 'type' => "ContentObject" },
    },
    'funcs' => {
    },
});
register_class(1, "TwoUpObject", {
    'parent' => "ContentObject",
    'vars' => {
        "splitpercent" => { 'type' => "int" },
        "topobj" => { 'type' => "ContentObject" },
        "bottomobj" => { 'type' => "ContentObject" },
    },
    'funcs' => {
    },
});
register_class(1, "Slide", {
    'vars' => {
        "presentation" => { 'type' => "Presentation" },
    },
    'funcs' => {
        "draw(Graphics g)" => { 'returntype' => "void" },
    },
});
register_class(1, "TitledSlide", {
    'parent' => "Slide",
    'vars' => {
        "title" => { 'type' => "string" },
        "body" => { 'type' => "ContentObject" },
    },
    'funcs' => {
    },
});
register_class(1, "AnonymousSlide", {
    'parent' => "Slide",
    'vars' => {
        "body" => { 'type' => "ContentObject" },
    },
    'funcs' => {
    },
});
register_class(1, "TitleSlide", {
    'parent' => "Slide",
    'vars' => {
    },
    'funcs' => {
    },
});
register_global_function(1,"loadImage(string filename)","Image", "Load an image from a file stored on disk. Returns a null Image if the given file could not be loaded for some reason.", "builtin");
register_global_function(1,"loadFont(string filename, int ptsize)","Font", "Create a Font object using a font file stored on disk and the desired point size. If the given font or size is unavailable, an alternative may be substituted. A null Font may also be returned if the given font cannot be loaded.", "builtin");
register_global_function(1,"makeColor(int r, int g, int b)","Color", "Make a new [class[Color]] object based on the given RGB values, where each component ranges from 0 to 255.", "builtin");
register_global_function(1,"character(int codepoint)","string", "Get the character with the given unicode codepoint.", "builtin");
register_property(1,"clr_background",{
    "type"=>"Color",
    "des"=>"Main slide background color",
});
register_set(1,"clr_background",S2::Builtin::Color__Color("#ffffff"));
register_property(1,"clr_foreground",{
    "type"=>"Color",
    "des"=>"Main slide foreground color",
});
register_set(1,"clr_foreground",S2::Builtin::Color__Color("#000000"));
register_property(1,"font_base",{
    "type"=>"Font",
    "des"=>"Slideshow Base Font",
});
register_set(1,"font_base",S2::Builtin::Font__Font(":default"));
register_property(1,"LAYOUTDIR",{
    "type"=>"string",
    "des"=>"The directory that the layout was loaded from",
    "note"=>"Layouts can use this to find other data such as images and fonts.",
    "noui"=>"1",
});
register_function(1, ["AnonymousSlide::draw(Graphics)", "Slide::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, "No draw implementation for this slide!", 0, 0, $g->{'width'} - 1, $g->{'height'} - 1, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
    };
});
register_function(1, ["ContentObject::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        S2::Builtin::Graphics__drawRect($_ctx, $g, 0, 0, $g->{'width'} - 1, $g->{'height'} - 1, $_ctx->[PROPS]->{'clr_foreground'});
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, "No draw implementation for this object!", 0, 0, $g->{'width'} - 1, $g->{'height'} - 1, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
    };
});
register_function(1, ["BulletListObject::getPreferredSize()", "ContentObject::getPreferredSize()", "ImageObject::getPreferredSize()", "SideBySideObject::getPreferredSize()", "TwoUpObject::getPreferredSize()", ], sub {
    return sub {
        my ($_ctx, $this) = @_;
        return [
            1,
            1,
        ];
    };
});
register_function(1, ["BulletListObject::getMinimumSize()", "ContentObject::getMinimumSize()", "ImageObject::getMinimumSize()", "SideBySideObject::getMinimumSize()", "TwoUpObject::getMinimumSize()", ], sub {
    return sub {
        my ($_ctx, $this) = @_;
        return [
            1,
            1,
        ];
    };
});
register_function(1, ["BulletListObject::getMaximumSize()", "ContentObject::getMaximumSize()", "ImageObject::getMaximumSize()", "SideBySideObject::getMaximumSize()", "TwoUpObject::getMaximumSize()", ], sub {
    return sub {
        my ($_ctx, $this) = @_;
        return [
            1,
            1,
        ];
    };
});
register_function(1, ["BulletListObject::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $cy = S2::Builtin::Font__getBaseLine($_ctx, $_ctx->[PROPS]->{'font_base'}, );
        my $sp = S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) * 2;
        foreach my $s (@{$this->{'items'}}) {
            S2::Builtin::Graphics__drawText($_ctx, $g, S2::Builtin::character($_ctx, 149) . " " . $s, 0, $cy, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
            $cy = $cy + $sp;
        }
    };
});
register_function(1, ["SideBySideObject::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $splitpos = int(($g->{'width'} * $this->{'splitpercent'}) / 100);
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'leftobj'}, 0, 0, $splitpos - 5, $g->{'height'} - 1);
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'rightobj'}, $splitpos + 5, 0, $g->{'width'} - 1, $g->{'height'} - 1);
    };
});
register_function(1, ["TwoUpObject::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $splitpos = int(($g->{'width'} * $this->{'splitpercent'}) / 100);
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'topobj'}, 0, 0, $g->{'width'} - 1, $splitpos - 5);
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'bottomobj'}, 0, $splitpos + 5, $g->{'width'} - 1, $g->{'height'} - 1);
    };
});
register_function(1, ["ImageObject::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $i;
        if ($this->{'img'}->{'width'} > $g->{'width'} || $this->{'img'}->{'height'} > $g->{'height'}) {
            $i = S2::Builtin::Image__scaleToRect($_ctx, $this->{'img'}, $g->{'width'}, $g->{'height'});
        } else {
            $i = $this->{'img'};
        }
        my $ix = (int($g->{'width'} / 2)) - (int($i->{'width'} / 2));
        my $iy = (int($g->{'height'} / 2)) - (int($i->{'height'} / 2));
        S2::Builtin::Graphics__drawImage($_ctx, $g, $i, $ix, $iy);
    };
});
register_function(1, ["TitleSlide::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $titlefont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 150);
        my $th = S2::Builtin::Font__getHeight($_ctx, $titlefont, ) + 10;
        my $ty = (int($g->{'height'} / 2)) - (int($th / 2));
        if ($this->{'presentation'}->{'subtitle'} ne "") {
            S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'subtitle'}, 0, $ty + $th, $g->{'width'} - 1, $ty + $th + S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
            $ty = $ty - (int((S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10) / 2));
            if ($this->{'presentation'}->{'author'} ne "") {
                my $authorfont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 75);
                S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'author'}, 0, $g->{'height'} - S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) - 50, $g->{'width'} - 1, $g->{'height'} - 1, $authorfont, $_ctx->[PROPS]->{'clr_foreground'});
            }
        } elsif ($this->{'presentation'}->{'author'} ne "") {
            S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'author'}, 0, $ty + $th, $g->{'width'} - 1, $ty + $th + S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
            $ty = $ty - (int((S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10) / 2));
        }
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'title'}, 0, $ty, $g->{'width'} - 1, $ty + $th, $titlefont, $_ctx->[PROPS]->{'clr_foreground'});
        $S2::pout->(("\$th = " . $th . "\n\$ty = " . $ty . "\ntfh = ") . S2::Builtin::Font__getHeight($_ctx, $titlefont, ) . "\n");
    };
});
register_function(1, ["TitledSlide::draw(Graphics)", ], sub {
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $titlefont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 150);
        my $th = S2::Builtin::Font__getHeight($_ctx, $titlefont, ) + 20;
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'title'}, 0, 0, $g->{'width'} - 1, $th, $titlefont, $_ctx->[PROPS]->{'clr_foreground'});
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'body'}, 0, $th, $g->{'width'} - 1, $g->{'height'} - 1);
    };
});
1;
# end.
