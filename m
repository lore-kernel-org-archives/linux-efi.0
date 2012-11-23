From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH RFC v2 2/4] firmware: Add -a option to scripts/sign-file
Date: Fri, 23 Nov 2012 14:51:04 +0800
Message-ID: <1353653464.21227.736.camel@linux-s257.site>
References: <s5hhap49den.wl%tiwai@suse.de>
	 <1352396109-3989-1-git-send-email-tiwai@suse.de>
	 <1352396109-3989-3-git-send-email-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352396109-3989-3-git-send-email-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2012-11-08 =E6=96=BC 18:35 +0100=EF=BC=8CTa=
kashi Iwai =E6=8F=90=E5=88=B0=EF=BC=9A
> Add a new option -a to sign-file for specifying the hash algorithm
> to sign a file, to make it working without .config file.
> This will be useful signing external module or firmware files.
>=20
> Signed-off-by: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>

Tested-by: Chun-Yi Lee<jlee-IBi9RG/b67k@public.gmane.org>

Joey Lee

> ---
>  scripts/sign-file | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>=20
> diff --git a/scripts/sign-file b/scripts/sign-file
> index 5b9d44d..581cdcd 100755
> --- a/scripts/sign-file
> +++ b/scripts/sign-file
> @@ -4,7 +4,7 @@
>  #
>  # Format:
>  #
> -#	./scripts/sign-file [-v] [-f] <key> <x509> <module> [<dest>]
> +#	./scripts/sign-file [-v] [-f] [-a algo] <key> <x509> <module> [<de=
st>]
>  #
>  #
>  use strict;
> @@ -17,16 +17,19 @@ sub usage()
>      print "Format: ./scripts/sign-file [options] <key> <x509> <modul=
e> [<dest>]
>      -v       verbose output
>      -f       create a firmware signature file
> +    -a algo  specify hash algorithm
>  ";
>      exit;
>  }
> =20
>  my $verbose =3D 0;
> +my $hashalgo =3D "";
>  my $sign_fw =3D 0;
> =20
>  GetOptions(
>      'v|verbose' =3D> \$verbose,
> -    'f|firmware' =3D> \$sign_fw) || usage();
> +    'f|firmware' =3D> \$sign_fw,
> +    'a|algo=3Ds' =3D> \$hashalgo) || usage();
>  usage() if ($#ARGV !=3D 2 && $#ARGV !=3D 3);
> =20
>  my $private_key =3D $ARGV[0];
> @@ -42,10 +45,7 @@ die "Can't read $mode_name\n" unless (-r $module);
>  #
>  # Read the kernel configuration
>  #
> -my %config =3D (
> -    CONFIG_MODULE_SIG_SHA512 =3D> 1
> -    );
> -
> +my %config;
>  if (-r ".config") {
>      open(FD, "<.config") || die ".config";
>      while (<FD>) {
> @@ -56,6 +56,22 @@ if (-r ".config") {
>      close(FD);
>  }
> =20
> +if ($hashalgo eq "") {
> +    if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
> +	$hashalgo=3D"sha1";
> +    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA224"}) {
> +	$hashalgo=3D"sha224";
> +    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA256"}) {
> +	$hashalgo=3D"sha256";
> +    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA384"}) {
> +	$hashalgo=3D"sha384";
> +    } elsif (exists $config{"CONFIG_MODULE_SIG_SHA512"}) {
> +	$hashalgo=3D"sha512";
> +    } else {
> +	die "Can't determine hash algorithm";
> +    }
> +}
> +
>  #
>  # Function to read the contents of a file into a variable.
>  #
> @@ -332,35 +348,35 @@ my $id_type =3D 1;	# Identifier type: X.509
>  # Digest the data
>  #
>  my ($dgst, $prologue) =3D ();
> -if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
> +if ($hashalgo eq "sha1") {
>      $prologue =3D pack("C*",
>  		     0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
>  		     0x2B, 0x0E, 0x03, 0x02, 0x1A,
>  		     0x05, 0x00, 0x04, 0x14);
>      $dgst =3D "-sha1";
>      $hash =3D 2;
> -} elsif (exists $config{"CONFIG_MODULE_SIG_SHA224"}) {
> +} elsif ($hashalgo eq "sha224") {
>      $prologue =3D pack("C*",
>  		     0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
>  		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
>  		     0x05, 0x00, 0x04, 0x1C);
>      $dgst =3D "-sha224";
>      $hash =3D 7;
> -} elsif (exists $config{"CONFIG_MODULE_SIG_SHA256"}) {
> +} elsif ($hashalgo eq "sha256") {
>      $prologue =3D pack("C*",
>  		     0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
>  		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
>  		     0x05, 0x00, 0x04, 0x20);
>      $dgst =3D "-sha256";
>      $hash =3D 4;
> -} elsif (exists $config{"CONFIG_MODULE_SIG_SHA384"}) {
> +} elsif ($hashalgo eq "sha384") {
>      $prologue =3D pack("C*",
>  		     0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
>  		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
>  		     0x05, 0x00, 0x04, 0x30);
>      $dgst =3D "-sha384";
>      $hash =3D 5;
> -} elsif (exists $config{"CONFIG_MODULE_SIG_SHA512"}) {
> +} elsif ($hashalgo eq "sha512") {
>      $prologue =3D pack("C*",
>  		     0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
>  		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
> @@ -368,7 +384,7 @@ if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
>      $dgst =3D "-sha512";
>      $hash =3D 6;
>  } else {
> -    die "Can't determine hash algorithm";
> +    die "Invalid hash algorithm $hashalgo";
>  }
> =20
>  #
