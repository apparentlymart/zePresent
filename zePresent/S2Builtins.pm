
package S2::Builtin;

use strict;
use GD;

### Graphics class functions

# Not really a builtin; just here because it's easier
sub gdPaletteIndex {
    my ($gfx, $clr) = @_;
    return $clr->{_gdindex} if defined $clr->{_gdindex};
    return $clr->{_gdindex} = $gfx->{_gdimg}->colorAllocate($clr->{r}, $clr->{g}, $clr->{b});
}



sub loadFont {
    my ($ctx, $fn, $ptsize) = @_;

    return undef unless -f $fn;
    
    my @corners = GD::Image->stringTTF(0, $fn, $ptsize, 0, 0, 0, "A");
    return undef unless @corners;
    
    return {
        '_type' => 'Font',
        '_ttffile' => $fn,
        '_size' => $ptsize,
        '_baselinepos' => $corners[7] * -1,
        '_height' => $corners[3] - $corners[7],
    };

}

sub loadImage {
    my ($ctx, $filename) = @_;

    return undef unless -f $filename;
    my $gdi = GD::Image->newFromPng($filename) ||
              GD::Image->newFromJpeg($filename);
              
    return undef unless $gdi;
    
    my ($width, $height) = $gdi->getBounds();
    
    return {
        '_type' => 'Image',
        '_gdi' => $gdi,
        'width' => $width,
        'height' => $height,
    };
}

sub makeColor {
    my ($ctx, $r, $g, $b) = @_;

    return {
        'r' => $r,
        'g' => $g,
        'b' => $b,
    };

}

# FIXME: This is currently wrong since it will, in most cases, only deal with
#      ASCII characters. Maybe under Perl 5.8 it'll do the right thing, but
#      I'm only testing on 5.6 right now.
sub character {
    my ($ctx, $cp) = @_;

    return chr($cp);
}

sub Font__Font {
    my ($s) = @_;

    my $fn; my $size; 


    if ($s eq ':default') {
        $fn = "/home/mart/tre.ttf";
        $size = 24;
    } else {
        ($fn, $size) = split('\n', $s);
    }

    return undef unless -f $fn;
    
    my @corners = GD::Image->stringTTF(0, $fn, $size, 0, 0, 0, "A");
    return undef unless @corners;
    
    
    return {
        '_type' => 'Font',
        '_ttffile' => $fn,
        '_size' => $size,
        '_baselinepos' => $corners[7] * -1,
        '_height' => $corners[3] - $corners[7],
    };

}

sub Font__getWidth {
    my ($ctx, $this, $text) = @_;
    
    my @corners = GD::Image->stringTTF(0, $this->{_ttffile}, $this->{_size}, 0, 0, 0, $text);
    return $corners[2] - $corners[0];
}

sub Font__getHeight { # FIXME: Finish this to support extra params
    my ($ctx, $this, $str, $width, $lineheight) = @_;
    
    return $this->{_height};
}

sub Font__getBaseLine {
    my ($ctx, $this, ) = @_;

    return $this->{_baselinepos};
}

sub Font__scale {
    my ($ctx, $this, $percent) = @_;

    my $newsize = int($this->{_size} * ($percent / 100));
    
    my $ret = loadFont($ctx, $this->{_ttffile}, $newsize);
    
    return loadFont($ctx, $this->{_ttffile}, $newsize);
}

sub Graphics__drawArc {
    my ($ctx, $this, $x, $y, $w, $h, $startAngle, $stopAngle, $clr) = @_;

    $this->{_gdimg}->arc($x+$this->{_ofsx}, $y+$this->{_ofsy}, $w, $h, $startAngle, $stopAngle, gdPaletteIndex($this,$clr));
}

sub Graphics__drawEllipse {
    my ($ctx, $this, $x, $y, $w, $h, $clr) = @_;

    $this->{_gdimg}->ellipse($x+$this->{_ofsx}, $y+$this->{_ofsy}, $w, $h, 0, 360, gdPaletteIndex($this,$clr));
}

sub Graphics__drawImage {
    my ($ctx, $this, $img, $x1, $y1, $x2, $y2) = @_;
    
    if (defined $x2) {
        $this->{_gdimg}->copyResized($img->{_gdi},$x1+$this->{_ofsx},$y1+$this->{_ofsy},0,0,$x2-$x1,$y2-$y1,$img->{width},$img->{height});
    }
    else {
        $this->{_gdimg}->copy($img->{_gdi},$x1+$this->{_ofsx},$y1+$this->{_ofsy},0,0,$img->{width},$img->{height});
    }
}

sub Graphics__drawLine {
    my ($ctx, $this, $x1, $y1, $x2, $y2, $clr) = @_;

    $this->{_gdimg}->line($x1 + $this->{_ofsx}, $y1 + $this->{_ofsy},
                          $x2 + $this->{_ofsx}, $y2 + $this->{_ofsy},
                          gdPaletteIndex($this,$clr));
}

sub Graphics__drawObject {
    my ($ctx, $this, $obj, $x1, $y1, $x2, $y2) = @_;

    return unless defined $obj;

    # Find and call the draw method of the right class.
    my $fnum = S2::get_func_num($obj->{_type}."::draw(Graphics)");
    my $code = $ctx->[S2::VTABLE]->{$fnum};

    # Make a new graphics object describing the given box
    my $gfx = {
        '_type' => 'Graphics',
        'width' => $x2 - $x1,
        'height' => $y2 - $y1,
        '_ofsx' => $x1 + $this->{_ofsx},
        '_ofsy' => $y1 + $this->{_ofsy},
        '_gdimg' => $this->{_gdimg},
    };
    $code->($ctx, $obj, $gfx);

}

sub Graphics__drawParagraph {
    my ($ctx, $this, $text, $x1, $y1, $x2, $y2, $font, $clr, $lineheight) = @_;

    # TODO: Implement drawParagraph
}

sub Graphics__drawPolygon {
    my ($ctx, $this, $coords, $clr) = @_;

    my $poly = new GD::Polygon;
    
    for (my $i = 0; $i < scalar(@$coords); $i += 2) {
        $poly->addPt($coords->[$i] + $this->{_ofsx},
                     $coords->[$i+1] + $this->{_ofsy});
    }

    $this->{_gdimg}->polygon($poly,
                             gdPaletteIndex($this,$clr));

}

sub Graphics__drawRect {
    my ($ctx, $this, $x1, $y1, $x2, $y2, $clr) = @_;

    $this->{_gdimg}->rectangle($x1 + $this->{_ofsx}, $y1 + $this->{_ofsy},
                               $x2 + $this->{_ofsx}, $y2 + $this->{_ofsy},
                               gdPaletteIndex($this,$clr));
}

sub Graphics__drawText {
    my ($ctx, $this, $text, $x, $y, $font, $clr) = @_;

    $this->{_gdimg}->stringTTF(gdPaletteIndex($this,$clr),
                               $font->{_ttffile}, $font->{_size},
                               0, # angle (bah)
                               $x + $this->{_ofsx},
                               $y + $this->{_ofsy},
                               $text);
}

sub Graphics__drawTextCentered {
    my ($ctx, $this, $text, $x1, $y1, $x2, $y2, $font, $clr) = @_;
    
    my $twid = Font__getWidth($ctx, $font, $text);
    my $thei = Font__getHeight($ctx, $font);
    
    my $bwid = $x2 - $x1;
    my $bhei = $y2 - $y1;
    
    my $x = $this->{_ofsx} + (($bwid / 2) - ($twid / 2)) + $x1;
    my $y = $this->{_ofsy} + $font->{_baselinepos} + (($bhei / 2) - ($thei / 2)) + $y1;

    $this->{_gdimg}->stringTTF(gdPaletteIndex($this,$clr),
                               $font->{_ttffile}, $font->{_size},
                               0, # angle (bah)
                               $x, $y,
                               $text);

}

sub Graphics__fill {
    my ($ctx, $this, $x1, $y1, $fillclr, $stopclr) = @_;

    if (defined $stopclr) {
        $this->{_gdimg}->fill($x1 + $this->{_ofsx}, $y1 + $this->{_ofsy},
                              gdPaletteIndex($this,$stopclr), gdPaletteIndex($this,$fillclr));
    } else {
        $this->{_gdimg}->fill($x1 + $this->{_ofsx}, $y1 + $this->{_ofsy},
                              gdPaletteIndex($this,$fillclr));
    }
}

sub Graphics__fillPolygon {
    my ($ctx, $this, $coords, $clr) = @_;

    my $poly = new GD::Polygon;
    
    for (my $i = 0; $i < scalar(@$coords); $i += 2) {
        $poly->addPt($coords->[$i] + $this->{_ofsx},
                     $coords->[$i+1] + $this->{_ofsy});
    }

    $this->{_gdimg}->filledPolygon($poly,
                             gdPaletteIndex($this,$clr));

}

sub Graphics__fillRect {
    my ($ctx, $this, $x1, $y1, $x2, $y2, $clr) = @_;

    $this->{_gdimg}->filledRectangle($x1 + $this->{_ofsx}, $y1 + $this->{_ofsy},
                                     $x2 + $this->{_ofsx}, $y2 + $this->{_ofsy},
                                     gdPaletteIndex($this,$clr));
}

sub Graphics__mergeImage {
    my ($ctx, $this, $img, $x, $y, $alpha) = @_;

    $this->{_gdimg}->copyMerged($img->{_gdi},$x+$this->{_ofsx},$y+$this->{_ofsy},0,0,$img->{width},$img->{height}, $alpha);
}

sub Graphics__setPixel {
    my ($ctx, $this, $x, $y, $clr) = @_;

    $this->{_gdimg}->setPixel($x + $this->{_ofsx}, $y + $this->{_ofsy},
                              gdPaletteIndex($this,$clr));
}

sub Image__scale {
    my ($ctx, $this, $percent) = @_;
    
    my $oimg = $this->{_gdi};
    my $ow = $this->{width};
    my $oh = $this->{height};
    my $nw = ($ow * $percent) / 100;
    my $nh = ($oh * $percent) / 100;
    
    my $nimg = new GD::Image($nw, $nh);
    $nimg->copyResized($oimg, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
    
    return {
        '_type' => 'Image',
        'width' => $nw,
        'height' => $nh,
        '_gdi' => $nimg,
    };
}

sub Image__scaleToFillRect {
    my ($ctx, $this, $nw, $nh) = @_;
    
    my $oimg = $this->{_gdi};
    my $ow = $this->{width};
    my $oh = $this->{height};
    
    my $nimg = new GD::Image($nw, $nh);
    $nimg->copyResized($oimg, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
    
    return {
        '_type' => 'Image',
        'width' => $nw,
        'height' => $nh,
        '_gdi' => $nimg,
    };
}

sub Image__scaleToRect {
    my ($ctx, $this, $nw, $nh) = @_;

    my $ow = $this->{width};
    my $oh = $this->{height};
    my $aspect = $oh / $ow;

    # FIXME: Scale to width or height?!
    
    if (($oh / $nh) > ($ow / $nw)) {
        return Image__scaleToHeight($ctx, $this, $nh);
    } else {
        return Image__scaleToWidth($ctx, $this, $nw);
    }
}

sub Image__scaleToHeight {
    my ($ctx, $this, $nh) = @_;
    
    my $oimg = $this->{_gdi};
    my $ow = $this->{width};
    my $oh = $this->{height};
    my $aspect = $oh / $ow;
    my $nw = int($nh / $aspect);
    
    my $nimg = new GD::Image($nw, $nh);
    $nimg->copyResized($oimg, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
    
    return {
        '_type' => 'Image',
        'width' => $nw,
        'height' => $nh,
        '_gdi' => $nimg,
    };
}

sub Image__scaleToWidth {
    my ($ctx, $this, $nw) = @_;
    
    my $oimg = $this->{_gdi};
    my $ow = $this->{width};
    my $oh = $this->{height};
    my $aspect = $oh / $ow;
    my $nh = int($nw * $aspect);
    
    my $nimg = new GD::Image($nw, $nh);
    $nimg->copyResized($oimg, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
    
    return {
        '_type' => 'Image',
        'width' => $nw,
        'height' => $nh,
        '_gdi' => $nimg,
    };
}


### Fundamental stuff

sub Color__update_hsl
{
    my ($this, $force) = @_;
    return if $this->{'_hslset'}++;
    ($this->{'_h'}, $this->{'_s'}, $this->{'_l'}) =
        LJ::Color::rgb_to_hsl($this->{'r'}, $this->{'g'}, $this->{'b'});
    $this->{$_} = int($this->{$_} * 255 + 0.5) foreach qw(_h _s _l);
}

sub Color__update_rgb
{
    my ($this) = @_;

    ($this->{'r'}, $this->{'g'}, $this->{'b'}) = 
        LJ::Color::hsl_to_rgb( map { $this->{$_} / 255 } qw(_h _s _l) );
    Color__make_string($this);
}

sub Color__make_string
{
    my ($this) = @_;
    $this->{'as_string'} = sprintf("\#%02x%02x%02x",
                                  $this->{'r'},
                                  $this->{'g'},
                                  $this->{'b'});
}

# public functions
sub Color__Color
{
    my ($s) = @_;
    $s =~ s/^\#//;
    $s =~ s/^(\w)(\w)(\w)$/$1$1$2$2$3$3/s;  #  'c30' => 'cc3300'
    return if $s =~ /[^a-fA-F0-9]/ || length($s) != 6;

    my $this = { '_type' => 'Color' };
    $this->{'r'} = hex(substr($s, 0, 2));
    $this->{'g'} = hex(substr($s, 2, 2));
    $this->{'b'} = hex(substr($s, 4, 2));
    $this->{$_} = $this->{$_} % 256 foreach qw(r g b);

    Color__make_string($this);
    return $this;
}

sub Color__clone
{
    my ($ctx, $this) = @_;
    return { %$this };
}

sub Color__set_hsl
{
    my ($this, $h, $s, $l) = @_;
    $this->{'_h'} = $h % 256;
    $this->{'_s'} = $s % 256;
    $this->{'_l'} = $l % 256;
    $this->{'_hslset'} = 1;
    Color__update_rgb($this);
}

sub Color__red {
    my ($ctx, $this, $r) = @_;
    if (defined $r) { 
        $this->{'r'} = $r % 256;
        delete $this->{'_hslset'};
        Color__make_string($this); 
    }
    $this->{'r'};
}

sub Color__green {
    my ($ctx, $this, $g) = @_;
    if (defined $g) {
        $this->{'g'} = $g % 256;
        delete $this->{'_hslset'};
        Color__make_string($this);
    }
    $this->{'g'};
}

sub Color__blue {
    my ($ctx, $this, $b) = @_;
    if (defined $b) {
        $this->{'b'} = $b % 256;
        delete $this->{'_hslset'};
        Color__make_string($this);
    }
    $this->{'b'};
}

sub Color__hue {
    my ($ctx, $this, $h) = @_;

    if (defined $h) {
        $this->{'_h'} = $h % 256;
        $this->{'_hslset'} = 1;
        Color__update_rgb($this);
    } elsif (! $this->{'_hslset'}) {
        Color__update_hsl($this);
    }
    $this->{'_h'};
}

sub Color__saturation {
    my ($ctx, $this, $s) = @_;
    if (defined $s) { 
        $this->{'_s'} = $s % 256;
        $this->{'_hslset'} = 1;
        Color__update_rgb($this);
    } elsif (! $this->{'_hslset'}) {
        Color__update_hsl($this);
    }
    $this->{'_s'};
}

sub Color__lightness {
    my ($ctx, $this, $l) = @_;

    if (defined $l) {
        $this->{'_l'} = $l % 256;
        $this->{'_hslset'} = 1;
        Color__update_rgb($this);
    } elsif (! $this->{'_hslset'}) {
        Color__update_hsl($this);
    }

    $this->{'_l'};
}

sub Color__inverse {
    my ($ctx, $this) = @_;
    my $new = {
        '_type' => 'Color',
        'r' => 255 - $this->{'r'},
        'g' => 255 - $this->{'g'},
        'b' => 255 - $this->{'b'},
    };
    Color__make_string($new);
    return $new;
}

sub Color__average {
    my ($ctx, $this, $other) = @_;
    my $new = {
        '_type' => 'Color',
        'r' => int(($this->{'r'} + $other->{'r'}) / 2 + .5),
        'g' => int(($this->{'g'} + $other->{'g'}) / 2 + .5),
        'b' => int(($this->{'b'} + $other->{'b'}) / 2 + .5),
    };
    Color__make_string($new);
    return $new;
}

sub Color__lighter {
    my ($ctx, $this, $amt) = @_;
    $amt = defined $amt ? $amt : 30;

    Color__update_hsl($this);

    my $new = {
        '_type' => 'Color',
        '_hslset' => 1,
        '_h' => $this->{'_h'},
        '_s' => $this->{'_s'},
        '_l' => ($this->{'_l'} + $amt > 255 ? 255 : $this->{'_l'} + $amt),
    };

    Color__update_rgb($new);
    return $new;
}

sub Color__darker {
    my ($ctx, $this, $amt) = @_;
    $amt = defined $amt ? $amt : 30;

    Color__update_hsl($this);

    my $new = {
        '_type' => 'Color',
        '_hslset' => 1,
        '_h' => $this->{'_h'},
        '_s' => $this->{'_s'},
        '_l' => ($this->{'_l'} - $amt < 0 ? 0 : $this->{'_l'} - $amt),
    };

    Color__update_rgb($new);
    return $new;
}

# FIXME: need to add string and int subs from LiveJournal, albeit with
#      slightly different names.

1;
