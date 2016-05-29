From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Sun, 29 May 2016 06:09:01 +0200
Message-ID: <574A6B5D.60200@moshe.nl>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
 <20160528222531.GA10687@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160528222531.GA10687@x>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/29/2016 12:25 AM, Josh Triplett wrote:
> On Sat, May 28, 2016 at 01:46:07PM -0700, Andy Lutomirski wrote:
>> My garbage workstation splats like this on boot:
>>
>> [    0.160523] ioremap: invalid physical address d0c801800000001
>>
>> This was fixed for a while, but I think the problem was reintroduced=
 by:
>>
>> commit 66dbe99cfe30e113d2e571e68b9b6a1a8985a157
>> Author: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
>> Date:   Mon Feb 1 22:07:03 2016 +0000
>>
>>     x86/efi/bgrt: Don't ignore the BGRT if the 'valid' bit is 0
>>
>> Is there any good way to fix this again?

Is it sensible for efi-bgrt.c to use phys_addr_valid from arch/x86/mm?
That way efi-bgrt.c can choose a noise level on its own. I added a patc=
h
to show what I mean, but is this even allowed by kernel coding
conventions?

> This was the kind of concern I had about ignoring the valid bit.  I
> supported this patch based on the statement that Windows 10 ignores t=
he
> valid bit as well.  Presumably either Windows has some way of detecti=
ng
> this kind of problem, or it would break on that system.  If the forme=
r,
> does anyone know what algorithm Windows uses to safely check for BGRT=
?

I don't know the exact steps Windows takes here, but I would also like
to point to the ACPI specification. The way I read it, the valid bit
really is not any indication about having a valid physical address. It
is about having a valid screen state and a better name would perhaps
have been 'onscreen' or 'screenstatenotchanged' etc. To my eyes this is
unintuitive, but it is actually documented this way.
Quoting from the specification:

"It should be set to 1 when the table is written, and invalidated if
there is reason to expect that the screen state has been changed."

The BGRT introduction text also gives a bit more information:

"The table is written when the image is drawn on the screen. This
should be done after it is expected that any firmware components that
may write to the screen are done doing so and it is known that the imag=
e
is the only thing on the screen. If the boot path is interrupted (e.g.
by a key press), the valid bit within the status field should be change=
d
to 0 to indicate to the OS that the current image is invalidated."

On 2 machines I was able to test this on, this matches the behavior I
observed: A normal boot provides valid=3D=3D1, but booting with a bootm=
enu
provides valid=3D=3D0. On the third machine I tested the bit was simply
always 0, with or without bootmenu. On those 3 machines the physical
address was valid and usable in any situation.

> I can see two possible ways to fix this.  If we can detect in advance
> that the address in the BGRT looks bogus (pointing to physical memory
> that doesn't exist, for instance), then we could ignore it entirely
> (without any warning if valid=3D=3D0, or with a warning if valid=3D=3D=
1).  If we
> can't detect that in advance, then we need to revert this patch and g=
o
> back to respecting the valid bit.  (However, trying to check the addr=
ess
> in advance seems preferable given that some BIOS might have a bogus
> address even with valid=3D=3D1.)

How do you interpret those words from the specification? I think the
absence of a valid physical address should give the same warning,
unrelated to the valid bit, because I don't think the bit is about that
fact at all.

---
 arch/x86/platform/efi/efi-bgrt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/e=
fi-bgrt.c
index 6a2f569..a7fdb61 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -19,6 +19,8 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
=20
+#include "../../mm/physaddr.h"
+
 struct acpi_table_bgrt *bgrt_tab;
 void *__initdata bgrt_image;
 size_t __initdata bgrt_image_size;
@@ -67,6 +69,11 @@ void __init efi_bgrt_init(void)
 		return;
 	}
=20
+	if (!phys_addr_valid(bgrt_tab->image_address)) {
+		pr_notice("Ignoring BGRT: image address is bogus\n");
+		return;
+	}
+
 	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMRE=
MAP_WB);
 	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image header memory\n");
--=20
2.4.3
