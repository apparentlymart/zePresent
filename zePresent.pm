
package zePresent;

use Carp;
use GD;
use S2;
use zePresent::S2Builtins;
use zePresent::S2Core;

sub bulletlist(@) {
    my $list;
    if (ref $_[0] eq 'ARRAY') {
        $list = $_[0];
    }
    else {
        $list = \@_;
    }
    return {
        '_type' => 'BulletListObject',
        'items' => $list,
    };
}

sub imageobject($) {
    my $fn = shift;
    return undef unless -f $fn;
    return {
        '_type' => 'ImageObject',
        'img' => S2::Builtin::loadImage(undef, $fn),
    };
}

sub vertsplit($$@) {
    my ($left, $right, $splitpos) = @_;
    $splitpos ||= 50;
    return {
        '_type' => 'SideBySideObject',
        'leftobj' => $left,
        'rightobj' => $right,
        'splitpercent' => $splitpos,
    };
}

sub horizsplit($$@) {
    my ($top, $bottom, $splitpos) = @_;
    $splitpos ||= 50;
    return {
        '_type' => 'TwoUpObject',
        'topobj' => $top,
        'bottomobj' => $bottom,
        'splitpercent' => $splitpos,
    };
}

package zePresent::Presentation;

sub new {
    my ($class) = @_;
    
    return bless({
        'slides' => [],
        'title' => '',
        'subtitle' => '',
        'author' => '',
    }, $class);
}

sub add_titleslide() {
    my $self = shift;
    push @{$self->{slides}}, {
        '_type' => 'TitleSlide',
    };
}

sub add_titledslide($$) {
    my ($self, $title, $obj) = @_;
    push @{$self->{slides}}, {
        '_type' => 'TitledSlide',
        'title' => "$title",
        'body' => $obj,
    };
}

sub slide_count {
    my $self = shift;
    
    return scalar(@{$self->{slides}});
}

sub slide_as_png {
    my ($self, $slidenum, $opts) = @_;
    
    my $slidedat = $self->{slides}->[$slidenum];
    croak("No slide numbered $slidenum") unless defined $slidedat;
    my $slide = {};
    $slide->{$_} = $slidedat->{$_} foreach (keys %$slidedat);
    $slide->{presentation} = { '_type' => 'Presentation' };
    $slide->{presentation}->{$_} = $self->{$_} foreach (keys %$self);
    
    my $ctx = $opts->{s2ctx} || S2::make_context([1]);
    
    # A previous run would have left junk in object properties, so we must clean
    foreach $k (keys %{$ctx->[S2::PROPS]}) {
        my $v = $ctx->[S2::PROPS]->{$k};
        next unless ref $v eq 'HASH';
        if ($v->{_type} eq 'Color') {
            delete $v->{_gdindex};
        }
    }
    
    my $width = $opts->{width} || 800;
    my $height = $opts->{height} || 600;
    
    my $img = new GD::Image($width, $height);
    my $gfx = {
        '_type' => 'Graphics',
        'width' => $width,
        'height' => $height,
        '_ofsx' => 0,
        '_ofsy' => 0,
        '_gdimg' => $img,
    };
    
    my $bgclr = $ctx->[S2::PROPS]->{'clr_background'};
    my $fgclr = $ctx->[S2::PROPS]->{'clr_foreground'};
    
    $bgclr->{_gdindex} = $img->colorAllocate($bgclr->{r}, $bgclr->{g}, $bgclr->{b});
    $fgclr->{_gdindex} = $img->colorAllocate($fgclr->{r}, $fgclr->{g}, $fgclr->{b});
    
    S2::run_code($ctx, $slide->{'_type'}.'::draw(Graphics)', $slide, $gfx);
    
    return $img->png();
}

package zePresent::S2;


1;
