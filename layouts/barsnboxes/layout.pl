#!/usr/bin/perl
# auto-generated Perl code from input S2 code
package S2;
use strict;
use constant VTABLE => 0;
use constant STATIC => 1;
use constant PROPS => 2;
register_layer(2);
set_layer_info(2,"type","layout");
set_layer_info(2,"name","Bars and Boxes");
register_property(2,"clr_titlebar",{
    "type"=>"Color",
    "des"=>"Color of the title bar",
});
register_property(2,"clr_title",{
    "type"=>"Color",
    "des"=>"Color of the title text",
});
register_property(2,"clr_boxes",{
    "type"=>"Color",
    "des"=>"Color of the little rectangles at the side",
});
register_set(2,"clr_titlebar",S2::Builtin::Color__Color("#BABED6"));
register_set(2,"clr_title",S2::Builtin::Color__Color("#000000"));
register_set(2,"clr_boxes",S2::Builtin::Color__Color("#125C8D"));
register_set(2,"clr_background",S2::Builtin::Color__Color("#DDDDDD"));
register_set(2,"clr_foreground",S2::Builtin::Color__Color("#000000"));
register_global_function(2,"sidebar(Graphics g)","void", "", "");
register_function(2, ["sidebar(Graphics)", ], sub {
    return sub {
        my ($_ctx, $g) = @_;
        S2::Builtin::Graphics__fillRect($_ctx, $g, 0, 0, 40, $g->{'height'} - 1, $_ctx->[PROPS]->{'clr_titlebar'});
        S2::Builtin::Graphics__fillRect($_ctx, $g, 0, 0, 20, 75, $_ctx->[PROPS]->{'clr_boxes'});
        S2::Builtin::Graphics__fillRect($_ctx, $g, 0, 100, 20, 175, $_ctx->[PROPS]->{'clr_boxes'});
        S2::Builtin::Graphics__fillRect($_ctx, $g, 0, 200, 20, 275, $_ctx->[PROPS]->{'clr_boxes'});
    };
});
register_function(2, ["TitleSlide::draw(Graphics)", ], sub {
    my @_l2g_func = ( undef, 
        get_func_num("sidebar(Graphics)"),
    );
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $titlefont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 150);
        my $th = S2::Builtin::Font__getHeight($_ctx, $titlefont, ) + 10;
        my $ty = (int($g->{'height'} / 2)) - (int($th / 2));
        $_ctx->[VTABLE]->{$_l2g_func[1]}->($_ctx, $g);
        if ($this->{'presentation'}->{'subtitle'} ne "") {
            S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'subtitle'}, 40, $ty + $th, $g->{'width'} - 1, $ty + $th + S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
            $ty = $ty - (int((S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10) / 2));
            if ($this->{'presentation'}->{'author'} ne "") {
                my $authorfont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 75);
                S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'author'}, 40, $g->{'height'} - S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) - 50, $g->{'width'} - 1, $g->{'height'} - 1, $authorfont, $_ctx->[PROPS]->{'clr_foreground'});
            }
        } elsif ($this->{'presentation'}->{'author'} ne "") {
            S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'author'}, 40, $ty + $th, $g->{'width'} - 1, $ty + $th + S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10, $_ctx->[PROPS]->{'font_base'}, $_ctx->[PROPS]->{'clr_foreground'});
            $ty = $ty - (int((S2::Builtin::Font__getHeight($_ctx, $_ctx->[PROPS]->{'font_base'}, ) + 10) / 2));
        }
        S2::Builtin::Graphics__fillRect($_ctx, $g, 40, 0, $g->{'width'} - 1, $ty + $th + 10, $_ctx->[PROPS]->{'clr_titlebar'});
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'presentation'}->{'title'}, 40, $ty, $g->{'width'} - 1, $ty + $th, $titlefont, $_ctx->[PROPS]->{'clr_foreground'});
    };
});
register_function(2, ["TitledSlide::draw(Graphics)", ], sub {
    my @_l2g_func = ( undef, 
        get_func_num("sidebar(Graphics)"),
    );
    return sub {
        my ($_ctx, $this, $g) = @_;
        my $titlefont = S2::Builtin::Font__scale($_ctx, $_ctx->[PROPS]->{'font_base'}, 150);
        my $th = S2::Builtin::Font__getHeight($_ctx, $titlefont, ) + 20;
        $_ctx->[VTABLE]->{$_l2g_func[1]}->($_ctx, $g);
        S2::Builtin::Graphics__fillRect($_ctx, $g, 40, 0, $g->{'width'} - 1, $th + 20, $_ctx->[PROPS]->{'clr_titlebar'});
        S2::Builtin::Graphics__drawTextCentered($_ctx, $g, $this->{'title'}, 40, 0, $g->{'width'} - 1, $th + 20, $titlefont, $_ctx->[PROPS]->{'clr_foreground'});
        S2::Builtin::Graphics__drawObject($_ctx, $g, $this->{'body'}, 50, $th + 30, $g->{'width'} - 11, $g->{'height'} - 11);
    };
});
1;
# end.
