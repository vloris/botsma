package Botsma::Encoding;

use strict;
use utf8;

my %encode = ();

sub encoding_exists
{
	my ($code) = @_;

	return ($code ne '' and defined($encode{$code}));
}

sub encode
{
	my ($code, $reply) = @_;

	if (encoding_exists($code))
	{
		$reply = $encode{$code}( $reply );
	}

	return $reply;
}

$encode{ali} = sub
{
	($_) = @_;

	s/\b(een|'n|de)\b\s*//ig;
	s/\b(d)eze\b/$1it/gi;
	s/\bIk\b/Ikke/g; s/\bik\b/ikke/g;
	s/\bhet\b/de/g; s/\bHet\b/De/g;

	s/(s)([^aeiou]|$)/$1j$2/ig;
	s/(z)/$1j/ig;
	s/([^eu]|^)(i)(?!([je]|kke))/$1$2e$3/ig;
	s/[eu]i/ai/g; s/[EU]i/Ai/ig;
	s/uu|eu|u/oe/g; s/Uu|Eu|U/Oe/ig;
	s/(aa)([^aeiou])/$1h$2/g;
	s/(oo)([^aeiou])/$1h$2/g;
	
	return( $_ );
};

$encode{chef} = sub
{
	($_) = @_;

        # Change 'e' at the end of a word to 'e-a', but don't mess with the word
        # "the".
        s{(\w+)e(\b)}{
                if (lc($1) ne 'th') {
                        "$1e-a$2"
                }
                else {
                        "$1e$2"
                }
        }eg;

        # Stuff that happens at the end of a word.
        s/en(\b)/ee$1/g;
        s/th(\b)/t$1/g;

        # Stuff that happens if not the first letter of a word.
        s/(\w)f/$1ff/g;

        # Change 'o' to 'u' and at the same time, change 'u' to 'oo'. But only
        # if it's not the first letter of the word.
        tr/ou/uo/;
        s{(\b)([uo])}{
                $1 . $2 eq 'o' ? 'u' : 'o'
        }eg;
        # Note that this also handles doubling "oo" at the beginning of words.
        s/o/oo/g;
        # Have to double "Oo" seperatly.
        s/(\b)O(\w)/$1Oo$2/g;
        # Fix the word "bork", which will have been mangled to "burk"
        # by above commands. Note that any occurence of "burk" in the input
        # gets changed to "boork", so it's completly safe to do this:
        s/\b([Bb])urk\b/$1ork/g;

        # Stuff to do to letters that are the first letter of any word.
        s/\be/i/g;
        s/\bE/I/g;

        # Stuff that always happens.
        s/tiun/shun/g; # this actually has the effect of changing "tion" to "shun".

        s/the/zee/g;
        s/The/Zee/g;
        tr/vVwW/fFvV/;

        # Stuff to do to letters that are not the last letter of a word.
        s/a(?!\b)/e/g;
        s/A(?!\b)/E/g;
        s/en/un/g; # this actually has the effect of changing "an" to "un".
        s/En/Un/g; # this actually has the effect of changing "An" to "Un".
        s/eoo/oo/g; # this actually has the effect of changing "au" to "oo".
        s/Eoo/Oo/g; # this actually has the effect of changing "Au" to "Oo".

        # Change "ow" to "oo".
        s/uv/oo/g;

        # Change 'i' to 'ee', but not at the beginning of a word,
        # and only affect the first 'i' in each word.
        s/(\b\w[a-hj-zA-HJ-Z]*)i/$1ee/g;

        # Special punctuation of the end of sentances but only at end of lines.
        s/([.?!])$/$1 Bork Bork Bork!/g;

        return( $_ );
};

$encode{l33t} = sub
{
        my( $a, $b );
        $_=shift;chomp;s/a/4/g;s/e/3/g;s/t/7/g;s/i/1/g;s/o/0/g;
        s/s/z/g;foreach $b (split "",$_){$b=~s/(.)/uc($1)/e
        if((int rand 2) % 2);$a.=$b;}
        return( $a );
	# FIXME: \n characters seem to be removed...
};

1;
