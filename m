From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: lower log level of efi-bgrt / handle status 0
Date: Mon, 29 Jun 2015 10:17:40 +0100
Message-ID: <20150629091740.GD28334@codeblueprint.co.uk>
References: <CAGnHSEnBNr-HVaUMjRqPK104mV1r16uDsktob+9WADr84fBh0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEnBNr-HVaUMjRqPK104mV1r16uDsktob+9WADr84fBh0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 29 Jun, at 01:10:52AM, Tom Yan wrote:
> My motherboard is ASUS H87-PRO which has UEFI BIOS. The kernel gives
> the following error on every boot:
> 
> Ignoring BGRT: invalid status 0 (expected 1)
> 
> This happens when the "Boot Logo" BIOS option is set to "Auto" (AND
> using a PCI-E display card, IIRC). According to the mobo's manual,
> "Auto" means:
> 
> "Automatically adjust the boot logo size according to Windows requirements."
> 
> while the error will be gone if I set it to "Full Screen" (which makes
> the boot logo look huge and ugly) or "Disabled" instead.
> 
> The thing is nothing really goes wrong when I choose "Auto" except
> from keep seeing that error. So could you make it accept/handle status
> 0, or at least lower the log level of messages in efi-bgrt? I can see
> that all of them make use of pr_err() and I wonder how important is
> this BGRT thing.

The rest of the error messages are quite important because they signal
that the BGRT is somehow invalid, even though the firmware thinks it
*is* valid. They are intended to catch buggy firmware and aid kernel
developers in debugging.

However, it probably does make sense to drop the pr_err() for ->status
being zero though, because the firmware is explicitly telling us "The
BGRT image is not being displayed".

Josh, Matthew? Can you think of a reason that something like this
wouldn't make sense?

---

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index d7f997f7c26d..480f3911228e 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -51,8 +51,8 @@ void __init efi_bgrt_init(void)
 		return;
 	}
 	if (bgrt_tab->status != 1) {
-		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
-		       bgrt_tab->status);
+		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
+			 bgrt_tab->status);
 		return;
 	}
 	if (bgrt_tab->image_type != 0) {

-- 
Matt Fleming, Intel Open Source Technology Center
