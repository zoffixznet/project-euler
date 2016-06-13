use strict;
use warnings;

                        # A sanity check.
                        if (0)
                        {
                            foreach my $row (@{$self->grid})
                            {
                                foreach my $c (@$row)
                                {
                                    if ($c->gray)
                                    {
                                        foreach my $dir (qw(x y))
                                        {
                                            my $hint_meth = $dir . '_hint';
                                            if (defined(my $hint = $c->$hint_meth))
                                            {
                                                if ($hint->sum =~ /$letter/)
                                                {
                                                    die "Foobar";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            $self->_out("Sanity check ok.\n");
                        }
