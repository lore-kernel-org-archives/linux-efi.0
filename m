From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] efi: Document #define FOO_PROTOCOL_GUID layout
Date: Mon, 27 Jun 2016 04:14:18 -0700
Message-ID: <1467026058.1847.95.camel@perches.com>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
	 <1466839230-12781-3-git-send-email-matt@codeblueprint.co.uk>
	 <20160627104920.GA9099@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160627104920.GA9099@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2016-06-27 at 12:49 +0200, Ingo Molnar wrote:
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
[]
> > + * EFI Configuration Table and GUID definitions
> > + *
> > + * These should be formatted roughly like the ones in the UEFI SPE=
C has
> > + * them.=A0=A0It makes them easier to grep for, and they look the =
same when
> > + * you're staring at them.
[]
> Btw., another possible way to organize the GUIDs would be to ignore c=
heckpatch (we=A0
> should ignore checkpatch when it's wrong)

Completely agree.  checkpatch is brainless.

> and go for a nice table format:
>=A0
> #define NULL_GUID				EFI_GUID(0x00000000, 0x0000, 0x0000,=A0=A00x00, =
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)

Much nicer.

There are a few more files that use EFI_GUID.
It'd be good to standardize.

$ git grep --name-only -w EFI_GUID
arch/ia64/include/asm/sal.h
arch/ia64/kernel/esi.c
arch/x86/platform/efi/quirks.c
block/partitions/efi.h
drivers/infiniband/hw/hfi1/efivar.c
drivers/scsi/isci/probe_roms.h
include/linux/efi.h

Maybe a checkpatch line-length exclusion:
---
=A0scripts/checkpatch.pl | 4 ++++
=A01 file changed, 4 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4904ced..cc787e6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2764,6 +2764,10 @@ sub process {
=A0				=A0$line =3D~ /^\+\s*#\s*define\s+\w+\s+$String$/) {
=A0				$msg_type =3D "";
=A0
+			# EFI_GUID is another special case
+			} elsif ($line =3D~ /^\+.*\bEFI_GUID\s*\(/) {
+				$msg_type =3D "";
+
=A0			# Otherwise set the alternate message types
=A0
=A0			# a comment starts before $max_line_length
