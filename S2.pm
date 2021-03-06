#!/usr/bin/perl
#

package S2;

use strict;
use vars qw($pout $pout_s %Domains $CurrentDomain);  # public interface:  sub refs to print and print safely

$pout = sub { print @_; };
$pout_s = sub { print @_; };

## array indexes into $_ctx (which shows up in compiled S2 code)
use constant VTABLE => 0;
use constant STATICS => 1;
use constant PROPS => 2;
use constant SCRATCH => 3;  # embedder-defined use
use constant LAYERLIST => 4;  # arrayref of layerids which made the context

%Domains = ();
$CurrentDomain = 'unset';

sub set_domain
{
    my $name = shift;
    $Domains{ $name } ||= {
        layer               => undef, # time()
        layercomp           => undef, # compiled time (when loaded from database)
        layerinfo           => undef, # key -> value
        layerset            => undef, # key -> value
        layerprop           => undef, # prop -> { type/key => "string"/val }
        layerprops          => undef, # arrayref of hashrefs
        layerprophide       => undef, # prop -> 1
        layerfunc           => undef, # funcnum -> sub{}
        layerclass          => undef, # classname -> hashref
        layerglobal         => undef, # signature -> hashref
        layerpropgroups     => undef, # [ group_ident* ]
        layerpropgroupname  => undef, # group_ident -> text_name
        layerpropgroupprops => undef, # group_ident -> [ prop_ident* ]
        funcnum             => undef, # funcID -> funcnum
        funcnummax          => 0, # maxnum in use already by funcnum, above.
    };

    $CurrentDomain = $name;
}

sub get_layer_all
{
    my $lid = shift;
    my $domain = $Domains{$CurrentDomain};

    return undef unless $domain->{layer}{$lid};
    return {
        layer          => $domain->{layer}{$lid},
        info           => $domain->{layerinfo}{$lid},
        set            => $domain->{layerset}{$lid},
        prop           => $domain->{layerprop}{$lid},
        class          => $domain->{layerclass}{$lid},
        global         => $domain->{layerglobal}{$lid},
        propgroupname  => $domain->{layerpropgroupname}{$lid},
        propgroups     => $domain->{layerpropgroups}{$lid},
        propgroupprops => $domain->{layerpropgroupprops}{$lid},
    };
}

# compatibility functions
sub pout   { $pout->(@_);   }
sub pout_s { $pout_s->(@_); }

sub get_property_value
{
    my ($ctx, $k) = @_;
    return $ctx->[PROPS]->{$k};
}

sub get_lang_code
{
    return get_property_value($_[0], 'lang_current');
}

sub make_context
{
    my (@lids) = @_;
    if (ref $lids[0] eq "ARRAY") { @lids = @{$lids[0]}; } # 1st arg can be array ref
    my $ctx = [];
    undef $@;

    my $domain = $Domains{$CurrentDomain};

    die "First layer in S2 context must be a core layer"
        unless $domain->{layerinfo}{$lids[0]}{type} eq 'core';

    ## load all the layers & make the vtable
    foreach my $lid (0, @lids)
    {
        ## build the vtable
        foreach my $fn (keys %{$domain->{layerfunc}{$lid}}) {
            $ctx->[VTABLE]->{$fn} = $domain->{layerfunc}{$lid}->{$fn};
        }

        ## ignore further stuff for layer IDs of 0
        next unless $lid;

        ## FIXME: load the layer if not loaded, using registered
        ## loader sub.

        ## setup the property values
        foreach my $p (keys %{$domain->{layerset}{$lid}}) {
            my $v = $domain->{layerset}{$lid}->{$p};

            # this was the old format, but only used for Color constructors,
            # so we can change it to the new format:
            $v = S2::Builtin::Color__Color($v->[0])
                if (ref $v eq "ARRAY" && scalar(@$v) == 2 &&
                    ref $v->[1] eq "CODE");

            $ctx->[PROPS]->{$p} = $v;
        }
    }

    $ctx->[LAYERLIST] = [ @lids ];
    return $ctx;
}

sub get_style_modtime
{
    my $ctx = shift;

    my $high = 0;
    foreach (@{$ctx->[LAYERLIST]}) {
        $high = $Domains{$CurrentDomain}{layercomp}{$_}
            if $Domains{$CurrentDomain}{layercomp}{$_} > $high;
    }
    return $high;
}

sub register_class
{
    my ($lid, $classname, $info) = @_;
    $Domains{$CurrentDomain}{layerclass}{$lid}{$classname} = $info;
}

sub register_layer
{
    my ($lid) = @_;
    unregister_layer($lid) if $Domains{$CurrentDomain}{layer}{$lid};
    $Domains{$CurrentDomain}{layer}{$lid} = time();
}

sub unregister_layer
{
    my ($lid) = @_;
    my $domain = $Domains{$CurrentDomain};

    delete $domain->{layer}{$lid};
    delete $domain->{layercomp}{$lid};
    delete $domain->{layerinfo}{$lid};
    delete $domain->{layerset}{$lid};
    delete $domain->{layerprop}{$lid};
    delete $domain->{layerprops}{$lid};
    delete $domain->{layerprophide}{$lid};
    delete $domain->{layerfunc}{$lid};
    delete $domain->{layerclass}{$lid};
    delete $domain->{layerglobal}{$lid};
    delete $domain->{layerpropgroups}{$lid};
    delete $domain->{layerpropgroupprops}{$lid};
    delete $domain->{layerpropgroupname}{$lid};
}

sub load_layer
{
    my ($lid, $comp, $comptime) = @_;

    eval $comp;
    if ($@) {
        my $err = $@;
        unregister_layer($lid);
        die "Layer \#$lid: $err";
    }
    $Domains{$CurrentDomain}{layercomp}{$lid} = $comptime;
    return 1;
}

sub load_layers_from_db
{
    my ($db, @layers) = @_;
    my $maxtime = 0;
    my @to_load;
    my $domain = $Domains{$CurrentDomain};

    foreach my $lid (@layers) {
        $lid += 0;
        if (exists $domain->{layer}{$lid}) {
            $maxtime = $domain->{layercomp}{$lid} if $domain->{layercomp}{$lid} > $maxtime;
            push @to_load, "(s2lid=$lid AND comptime>$domain->{layercomp}{$lid})";
        } else {
            push @to_load, "s2lid=$lid";
        }
    }
    return $maxtime unless @to_load;
    my $where = join(' OR ', @to_load);
    my $sth = $db->prepare("SELECT s2lid, compdata, comptime FROM s2compiled WHERE $where");
    $sth->execute;
    while (my ($id, $comp, $comptime) = $sth->fetchrow_array) {
        eval $comp;
        if ($@) {
            my $err = $@;
            unregister_layer($id);
            die "Layer \#$id: $err";
        }
        $domain->{layercomp}{$id} = $comptime;
        $maxtime = $comptime if $comptime > $maxtime;
    }
    return $maxtime;
}

sub layer_loaded
{
    my ($id) = @_;
    return $Domains{$CurrentDomain}{layercomp}{$id};
}

sub set_layer_info
{
    my ($lid, $key, $val) = @_;
    $Domains{$CurrentDomain}{layerinfo}{$lid}->{$key} = $val;
}

sub get_layer_info
{
    my ($lid, $key) = @_;
    return undef unless $Domains{$CurrentDomain}{layerinfo}{$lid};
    return $key
        ? $Domains{$CurrentDomain}{layerinfo}{$lid}->{$key}
        : %{$Domains{$CurrentDomain}{layerinfo}{$lid}};
}

sub register_property
{
    my ($lid, $propname, $props) = @_;
    $props->{'name'} = $propname;
    $Domains{$CurrentDomain}{layerprop}{$lid}->{$propname} = $props;
    push @{$Domains{$CurrentDomain}{layerprops}{$lid}}, $props;
}

sub register_property_use
{
    my ($lid, $propname) = @_;
    push @{$Domains{$CurrentDomain}{layerprops}{$lid}}, $propname;
}

sub register_property_hide
{
    my ($lid, $propname) = @_;
    $Domains{$CurrentDomain}{layerprophide}{$lid}->{$propname} = 1;
}

sub register_propgroup_name
{
    my ($lid, $gname, $name) = @_;
    $Domains{$CurrentDomain}{layerpropgroupname}{$lid}->{$gname} = $name;
}

sub register_propgroup_props
{
    my ($lid, $gname, $list) = @_;
    $Domains{$CurrentDomain}{layerpropgroupprops}{$lid}->{$gname} = $list;
    push @{$Domains{$CurrentDomain}{layerpropgroups}{$lid}}, $gname;
}

sub is_property_hidden
{
    my ($lids, $propname) = @_;
    foreach (@$lids) {
        return 1 if $Domains{$CurrentDomain}{layerprophide}{$_}->{$propname};
    }
    return 0;
}

sub get_property
{
    my ($lid, $propname) = @_;
    return $Domains{$CurrentDomain}{layerprop}{$lid}->{$propname};
}

sub get_properties
{
    my ($lid) = @_;
    return () unless $Domains{$CurrentDomain}{layerprops}{$lid};
    return @{$Domains{$CurrentDomain}{layerprops}{$lid}};
}

sub get_property_groups
{
    my $lid = shift;
    return @{$Domains{$CurrentDomain}{layerpropgroups}{$lid} || []};
}

sub get_property_group_props
{
    my ($lid, $group) = @_;
    return () unless $Domains{$CurrentDomain}{layerpropgroupprops}{$lid};
    return @{$Domains{$CurrentDomain}{layerpropgroupprops}{$lid}->{$group} || []};
}

sub get_property_group_name
{
    my ($lid, $group) = @_;
    return unless $Domains{$CurrentDomain}{layerpropgroupname}{$lid};
    return $Domains{$CurrentDomain}{layerpropgroupname}{$lid}->{$group};
}

sub register_set
{
    my ($lid, $propname, $val) = @_;
    $Domains{$CurrentDomain}{layerset}{$lid}->{$propname} = $val;
}

sub get_set
{
    my ($lid, $propname) = @_;
    my $v = $Domains{$CurrentDomain}{layerset}{$lid}->{$propname};
    return undef unless defined $v;
    return $v;
}

# the whole point here is just to get the docstring.
# attrs is a comma-delimited list of attributes
sub register_global_function
{
    my ($lid, $func, $rtype, $docstring, $attrs) = @_;

    # need to make the signature:  foo(int a, int b) -> foo(int,int)
    return unless
        $func =~ /^(.+?\()(.*)\)$/;
    my ($signature, @args) = ($1, split(/\s*\,\s*/, $2));
    foreach (@args) { s/\s+\w+$//; } # strip names
    $signature .= join(",", @args) . ")";
    $Domains{$CurrentDomain}{layerglobal}{$lid}->{$signature} = {
        'returntype' => $rtype,
        'docstring' => $docstring,
        'args' => $func,
        'attrs' => $attrs,
    };
}

sub register_function
{
    my ($lid, $names, $code) = @_;

    # run the code to get the sub back with its closure data filled.
    my $closure = $code->();

    # now, remember that closure.
    foreach my $fi (@$names) {
        my $num = get_func_num($fi);
        $Domains{$CurrentDomain}{layerfunc}{$lid}->{$num} = $closure;
    }
}

sub set_output
{
    $pout = shift;
}

sub set_output_safe
{
    $pout_s = shift;
}

sub function_exists
{
    my ($ctx, $func) = @_;
    my $fnum = get_func_num($func);
    my $code = $ctx->[VTABLE]->{$fnum};
    return 1 if ref $code eq "CODE";
    return 0;
}

sub run_code
{
    my ($ctx, $entry, @args) = @_;
    run_function($ctx, $entry, @args);
    return 1;
}

sub run_function
{
    my ($ctx, $entry, @args) = @_;
    my $fnum = get_func_num($entry);
    my $code = $ctx->[VTABLE]->{$fnum};
    unless (ref $code eq "CODE") {
        die "S2::run_code: Undefined function $entry ($fnum $code)\n";
    }
    my $val;
    eval {
        local $SIG{__DIE__} = undef;
        local $SIG{ALRM} = sub { die "Style code didn't finish running in a timely fashion.  ".
                                     "Possible causes: <ul><li>Infinite loop in style or layer</li>\n".
                                     "<li>Database busy</li></ul>\n" };
        #alarm 4;
        $val = $code->($ctx, @args);
        #alarm 0;
    };
    if ($@) {
        die "Died in S2::run_code running $entry: $@\n";
    }
    return $val;
}

sub get_func_num
{
    my $name = shift;
    my $domain = $Domains{$CurrentDomain};

    return $domain->{funcnum}{$name}
        if exists $domain->{funcnum}{$name};
    return $domain->{funcnum}{$name} = ++$domain->{funcnummax};
}

sub get_object_func_num
{
    my ($type, $inst, $func, $s2lid, $s2line, $is_super, $ctx) = @_;
    if (ref $inst ne "HASH" || $inst->{'_isnull'}) {
        die "Method called on null $type object in ".layer_name($ctx,$s2lid).", line $s2line.\n";
    }
    
    # Identify the object's current type so we can do late binding
    if ($is_super) {
        # Old versions of s2compile didn't pass context in, so for old
        # layers we just assume the old behavior where the type is
        # given in $type by the compiler (static binding)
        if (defined $ctx) {
        
            my $cla = $Domains{$CurrentDomain}{layerclass}{$ctx->[LAYERLIST]->[0]}{$inst->{'_type'}};

            # There should always be a valid parent or else the compiler
            # would have rejected it, but things could go awry if core is
            # changed in some way which breaks existing layers so let's
            # play safe.
            unless ($type = $cla->{parent}) {
                die "\$super used in non-child class method in ".layer_name($ctx,$s2lid).", line $s2line.\n";
            }
        }
    } else {
        $type = $inst->{'_type'};
    }
    
    my $fn = get_func_num("${type}::$func");
    return $fn;
}

# Called by NodeForeachStmt
sub get_characters
{
    my $string = shift;
    use utf8;
    return split(//,$string);
}

sub check_defined {
    my $obj = shift;
    return ref $obj eq "HASH" && ! $obj->{'_isnull'};
}

sub check_elements {
    my $obj = shift;
    if (ref $obj eq "ARRAY") {
        return @$obj ? 1 : 0;
    } elsif (ref $obj eq "HASH") {
        return %$obj ? 1 : 0;
    }
    return 0;
}

sub interpolate_object {
    my ($ctx, $cname, $obj, $method) = @_;
    return "" unless ref $obj eq "HASH" && ! $obj->{'_isnull'};
    return $ctx->[VTABLE]->{get_object_func_num($cname,$obj,$method)}->($ctx, $obj);
}

sub layer_name {
    my ($ctx, $layerid) = @_;
    my $name = $Domains{$CurrentDomain}{layerinfo}{$layerid}{name};
    return ($name ? "'$name' (\#$layerid)" : "layer \#$layerid");
}

sub downcast_object {
    my ($ctx, $obj, $toclass, $layerid, $line) = @_;
    
    # If the object is null, just return it
    return $obj unless ref $obj eq "HASH" && ! $obj->{'_isnull'};
    
    my $fromclass = $obj->{_type};

    die "Invalid typecast: can't cast object of type '$fromclass' to type '$toclass'".
        (defined $layerid ? " in ".layer_name($ctx,$layerid).", line $line" : "")
        unless object_isa($ctx, $obj, $toclass);
    
    # After all that, we just return the same object that was passed in! ;)
    return $obj;
}

sub object_isa {
    my ($ctx, $obj, $qclass) = @_;

    my $actclass = $obj->{_type};

    my $classes = $Domains{$CurrentDomain}{layerclass}{$ctx->[LAYERLIST]->[0]};

    my $tc = $actclass;
    my $okay = 0;
    while ($tc) {
        if ($tc eq $qclass) {
            $okay = 1;
            last;
        }
        my $ntc = $classes->{$tc};
        $tc = $ntc ? $ntc->{parent} : undef;
    }

    return $okay;
}

sub notags {
    my $a = shift;
    $a =~ s/</&lt;/g;
    $a =~ s/>/&gt;/g;
    return $a;
}

package S2::Builtin;

# generic S2 has no built-in functionality

1;

