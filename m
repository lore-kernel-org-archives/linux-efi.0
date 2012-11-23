From: joeyli <jlee@suse.com>
Subject: Re: [PATCH RFC v2 1/4] firmware: Add the firmware signing support
 to scripts/sign-file
Date: Fri, 23 Nov 2012 14:51:33 +0800
Message-ID: <1353653493.21227.737.camel@linux-s257.site>
References: <s5hhap49den.wl%tiwai@suse.de>
	 <1352396109-3989-1-git-send-email-tiwai@suse.de>
	 <1352396109-3989-2-git-send-email-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1352396109-3989-2-git-send-email-tiwai@suse.de>
Sender: linux-security-module-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2012-11-08 =E6=96=BC 18:35 +0100=EF=BC=8CTa=
kashi Iwai =E6=8F=90=E5=88=B0=EF=BC=9A
> Add -f option to sign-file script for generating a firmware signature
> file.
>=20
> A firmware signature file contains a pretty similar structure like a
> signed module but in a different order (because it's a separate file
> while the module signature is embedded at the tail of unsigned module
> contents).  The file consists of
>  - the magic string
>  - the signature information, which is identical with the module
>    signature
>  - signer's name
>  - key id
>  - signature bytes
>=20
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Tested-by: Chun-Yi Lee <jlee@suse.com>

Joey Lee

> ---
>  scripts/sign-file | 48 +++++++++++++++++++++++++++++++++++----------=
---
>  1 file changed, 35 insertions(+), 13 deletions(-)
>=20
> diff --git a/scripts/sign-file b/scripts/sign-file
> index 87ca59d..5b9d44d 100755
> --- a/scripts/sign-file
> +++ b/scripts/sign-file
> @@ -4,30 +4,40 @@
>  #
>  # Format:
>  #
> -#	./scripts/sign-file [-v] <key> <x509> <module> [<dest>]
> +#	./scripts/sign-file [-v] [-f] <key> <x509> <module> [<dest>]
>  #
>  #
>  use strict;
>  use FileHandle;
>  use IPC::Open2;
> +use Getopt::Long;
> =20
> -my $verbose =3D 0;
> -if ($#ARGV >=3D 0 && $ARGV[0] eq "-v") {
> -    $verbose =3D 1;
> -    shift;
> +sub usage()
> +{
> +    print "Format: ./scripts/sign-file [options] <key> <x509> <modul=
e> [<dest>]
> +    -v       verbose output
> +    -f       create a firmware signature file
> +";
> +    exit;
>  }
> =20
> -die "Format: ./scripts/sign-file [-v] <key> <x509> <module> [<dest>]=
\n"
> -    if ($#ARGV !=3D 2 && $#ARGV !=3D 3);
> +my $verbose =3D 0;
> +my $sign_fw =3D 0;
> +
> +GetOptions(
> +    'v|verbose' =3D> \$verbose,
> +    'f|firmware' =3D> \$sign_fw) || usage();
> +usage() if ($#ARGV !=3D 2 && $#ARGV !=3D 3);
> =20
>  my $private_key =3D $ARGV[0];
>  my $x509 =3D $ARGV[1];
>  my $module =3D $ARGV[2];
> -my $dest =3D ($#ARGV =3D=3D 3) ? $ARGV[3] : $ARGV[2] . "~";
> +my $dest =3D $ARGV[3] ? $ARGV[3] : $ARGV[2] . ($sign_fw ? ".sig" : "=
~");
> +my $mode_name =3D $sign_fw ? "firmware" : "module";
> =20
>  die "Can't read private key\n" unless (-r $private_key);
>  die "Can't read X.509 certificate\n" unless (-r $x509);
> -die "Can't read module\n" unless (-r $module);
> +die "Can't read $mode_name\n" unless (-r $module);
> =20
>  #
>  # Read the kernel configuration
> @@ -393,7 +403,9 @@ die "openssl rsautl died: $?" if ($? >> 8);
>  #
>  my $unsigned_module =3D read_file($module);
> =20
> -my $magic_number =3D "~Module signature appended~\n";
> +my $magic_number =3D $sign_fw ?
> +    "~Linux firmware signature~\n" :
> +    "~Module signature appended~\n";
> =20
>  my $info =3D pack("CCCCCxxxN",
>  		$algo, $hash, $id_type,
> @@ -402,7 +414,7 @@ my $info =3D pack("CCCCCxxxN",
>  		length($signature));
> =20
>  if ($verbose) {
> -    print "Size of unsigned module: ", length($unsigned_module), "\n=
";
> +    print "Size of unsigned $mode_name: ", length($unsigned_module),=
 "\n";
>      print "Size of signer's name  : ", length($signers_name), "\n";
>      print "Size of key identifier : ", length($key_identifier), "\n"=
;
>      print "Size of signature      : ", length($signature), "\n";
> @@ -414,7 +426,16 @@ if ($verbose) {
> =20
>  open(FD, ">$dest") || die $dest;
>  binmode FD;
> -print FD
> +if ($sign_fw) {
> +    print FD
> +    $magic_number,
> +    $info,
> +    $signers_name,
> +    $key_identifier,
> +    $signature
> +    ;
> +} else {
> +    print FD
>      $unsigned_module,
>      $signers_name,
>      $key_identifier,
> @@ -422,8 +443,9 @@ print FD
>      $info,
>      $magic_number
>      ;
> +}
>  close FD || die $dest;
> =20
> -if ($#ARGV !=3D 3) {
> +if (!$sign_fw && $#ARGV !=3D 3) {
>      rename($dest, $module) || die $module;
>  }


--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
