From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: lower log level of efi-bgrt / handle status 0
Date: Mon, 29 Jun 2015 03:15:18 -0700
Message-ID: <20150629101518.GA21291@x>
References: <CAGnHSEnBNr-HVaUMjRqPK104mV1r16uDsktob+9WADr84fBh0w@mail.gmail.com>
 <20150629091740.GD28334@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150629091740.GD28334@codeblueprint.co.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Tom Yan <tom.ty89@gmail.com>, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 29, 2015 at 10:17:40AM +0100, Matt Fleming wrote:
> On Mon, 29 Jun, at 01:10:52AM, Tom Yan wrote:
> > My motherboard is ASUS H87-PRO which has UEFI BIOS. The kernel gives
> > the following error on every boot:
> > 
> > Ignoring BGRT: invalid status 0 (expected 1)
> > 
> > This happens when the "Boot Logo" BIOS option is set to "Auto" (AND
> > using a PCI-E display card, IIRC). According to the mobo's manual,
> > "Auto" means:
> > 
> > "Automatically adjust the boot logo size according to Windows requirements."
> > 
> > while the error will be gone if I set it to "Full Screen" (which makes
> > the boot logo look huge and ugly) or "Disabled" instead.

Odd that the firmware makes the image invalid if you set it to "auto".

> > The thing is nothing really goes wrong when I choose "Auto" except
> > from keep seeing that error. So could you make it accept/handle status
> > 0, or at least lower the log level of messages in efi-bgrt? I can see
> > that all of them make use of pr_err() and I wonder how important is
> > this BGRT thing.
> 
> The rest of the error messages are quite important because they signal
> that the BGRT is somehow invalid, even though the firmware thinks it
> *is* valid. They are intended to catch buggy firmware and aid kernel
> developers in debugging.
> 
> However, it probably does make sense to drop the pr_err() for ->status
> being zero though, because the firmware is explicitly telling us "The
> BGRT image is not being displayed".
> 
> Josh, Matthew? Can you think of a reason that something like this
> wouldn't make sense?

Only the low bit of the status field indicates validity; the remaining 7
bits are reserved and must be zero.  So, please keep a message at pr_err
or at least pr_warn if (bgrt_tab->status & 0xfe).  However, I agree that
a value of 0 shouldn't be an error or warning; info or debug seems fine
for that.

- Josh Triplett

> ---
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index d7f997f7c26d..480f3911228e 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -51,8 +51,8 @@ void __init efi_bgrt_init(void)
>  		return;
>  	}
>  	if (bgrt_tab->status != 1) {
> -		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
> -		       bgrt_tab->status);
> +		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
> +			 bgrt_tab->status);
>  		return;
>  	}
>  	if (bgrt_tab->image_type != 0) {
> 
