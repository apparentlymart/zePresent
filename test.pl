#!/usr/bin/perl

use zePresent;

require "layouts/barsnboxes/layout.pl";

my $present = new zePresent::Presentation();
$present->{title} = "NWin";
$present->{subtitle} = "A Network-transparent GUI System";
$present->{author} = "By Martin Atkins";

$present->add_titleslide();

$present->add_titledslide( 'The NWin System' ,
    zePresent::bulletlist(
        'A Standard for Modern Centralised Computing',
        'Platform-agnostic',
        'Object-oriented Application Design',
        'Integration With a Local System',
    )
);



$present->add_titledslide( 'Hybrid Centralised Computing' ,
    zePresent::horizsplit(
        zePresent::imageobject('thinclients-general.png'),
        zePresent::bulletlist(
            'A Compromise',
            'Server and Client Share Load',
            'Server Runs More Demanding Applications',
            'Client Runs Supporting Applications',
        ),
        50,
    ),
);

$present->add_titledslide( 'The X Window System' ,
    zePresent::horizsplit(
        zePresent::bulletlist(
            'One of the first "network-transparent" GUI systems',
            'Originally intended for low-spec terminals',
            'Now retasked to modern remote computing',
            'Applications communicate graphics primitives',
            'Little integration into the local system',
            'Main inspiration behind NWin',
        ),
        zePresent::imageobject('xnotbelong.png'),
        30,
    ),
);

$present->add_titledslide( 'The Vision' ,
    zePresent::bulletlist(
        'Applications can display on any popular OS',
        'Interface matches local UI conventions',
        'As responsive as local applications',
        'NWin applications interact with local applications',
    )
);

$present->add_titledslide( 'The Current Implementation' ,
    zePresent::horizsplit(
        zePresent::bulletlist(
            'Server only runs on Windows systems',
            'Current Class Library is Windows-specific',
            'No interaction between applications',
        ),
        zePresent::bulletlist(
            'The "core" of the system is complete',
            'It performs well; Applications are very responsive!',
            'Clear Progress Paths For Remainder of System',
            'Much of the server is portable',
        ),
        35
    ),
);

$present->add_titledslide( 'Design Overview' ,
    zePresent::imageobject('components.png'),
);

$present->add_titledslide( 'Object Model' ,
    zePresent::bulletlist(
        'Single inheritance',
        'Integrated event model',
        'Properties and methods inherit',
        'Events do not inherit',
        'Constructors and destructors sometimes inherit',
        'Method and constructor overloading is supported',
    ),
);

$present->add_titledslide( 'Where To From Here?' ,
    zePresent::bulletlist(
        'Design a full abstract UI API',
        'Create client libraries for other languages',
        'Port server to MacOS and UNIX',
        'Need a development team...',
    )
);

$present->add_titledslide( 'Demonstration' ,
    zePresent::horizsplit(
        zePresent::bulletlist(
            'The university network is already set up as per the diagram:',
        ),
        zePresent::imageobject('thinclients-uni.png'),
        10,
    ),
);

$present->add_titledslide( 'Demonstration' ,
    zePresent::bulletlist(
        'No big applications yet',
        'Some simple programs will hopefully suffice',
    ),
);



my $comment = <<EOCOMMENT;
push @{$present->{slides}}, {
    '_type' => 'TitleSlide',
};

push @{$present->{slides}}, {
    '_type' => 'TitledSlide',
    'title' => 'A Simple Slide',
    'body' => {
        '_type' => 'BulletListObject',
        'items' => [
            'zePresent is',
            'pretty much ready',
            'to do my CC301 presentation.',
        ],
    }

};

push @{$present->{slides}}, {
    '_type' => 'TitledSlide',
    'title' => 'Thin Clients, Baby',
    'body' => {
        '_type' => 'ImageObject',
        'img' => S2::Builtin::loadImage(undef, "thinclients-general.png"),
    }

};
EOCOMMENT


#for (2 .. 10) {
#    push @{$present->{slides}}, {
#        '_type' => 'TitledSlide',
#        'title' => 'Test Slide',
#        'body' => {
#            '_type' => 'SideBySideObject',
#            'splitpercent' => 50,
#            'leftobj' => {
#                '_type' => 'BulletListObject',
#                'items' => [
#                    "Yo yo yo!",
#                    "Hey hey hey!",
#                    "Here I go again.",
#                ],
#            },
#            'rightobj' => {
#                '_type' => 'TwoUpObject',
#                'splitpercent' => 50,
#                'topobj' => {
#                    '_type' => 'BulletListObject',
#                    'items' => [
#                        "Yo yo yo!",
#                        "Hey hey hey!",
#                        "Here I go again.",
#                    ],
#                },
#                'bottomobj' => {
#                    '_type' => 'ImageObject',
#                    'img' => S2::Builtin::loadImage(undef, "smile.png"),
#                },
#            },
#        },
#    };
#}

my $maxi = $#{$present->{slides}};
my $zeropad = length($maxi);
$zeropad = 2 if $zeropad < 2;

for (my $i = 0; $i <= $maxi; $i++) {

    my $s2ctx = S2::make_context([1,2]);
    open(OUT, ">slide".zeropad($i).".png");
    binmode(OUT);
    print OUT $present->slide_as_png($i, { width => 1024, height => 768, s2ctx => $s2ctx });
    close(OUT);

}

sub zeropad {
    if (length($_[0]) < $zeropad) {
        return ("0" x ($zeropad - length($_[0]))).$_[0];
    }
    else {
        return $_[0];
    }
}
