From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
Date: Thu, 13 Feb 2014 21:40:36 +0800
Message-ID: <87k3czdtbf.fsf@redhat.com>
References: <8738jr5t3e.fsf@redhat.com> <20140210175246.GB2887@console-pimps.org> <87mwhy8iaj.fsf@redhat.com> <20140211131640.GD2887@console-pimps.org> <87lhxh69u0.fsf@redhat.com> <20140211141846.GA1725@console-pimps.org> <1392221703.5612.164.camel@misato.fc.hp.com> <20140213105547.GC20717@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20140213105547.GC20717-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org writes:

> On Wed, 12 Feb, at 09:15:03AM, Toshi Kani wrote:
>> 
>> Hi Matt,
>> 
>> Yes, I agree that the table size should be 0x38.  However, ACPI spec
>> states that bit0 of status indicates if the boot image graphic is valid.
>> This bit is set to 0 (invalid) on the system.  Can you check this bit
>> and return when invalid? 
>
> Madper, could you try out this patch?
>
Thanks Matt. This patch fix the panic. And ioremap warning disappeared
after apply your patch.
> ---
>
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index 4df9591eadad..f15103dff4b4 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -42,7 +42,7 @@ void __init efi_bgrt_init(void)
>  
>  	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
>  		return;
> -	if (bgrt_tab->version != 1)
> +	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
>  		return;
>  	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
>  		return;

-- 
Madper
