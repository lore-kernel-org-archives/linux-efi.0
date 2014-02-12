From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Date: Wed, 12 Feb 2014 09:15:03 -0700
Message-ID: <1392221703.5612.164.camel@misato.fc.hp.com>
References: <8738jr5t3e.fsf@redhat.com>
	 <20140210175246.GB2887@console-pimps.org> <87mwhy8iaj.fsf@redhat.com>
	 <20140211131640.GD2887@console-pimps.org> <87lhxh69u0.fsf@redhat.com>
	 <20140211141846.GA1725@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211141846.GA1725-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-02-11 at 14:18 +0000, Matt Fleming wrote:
> (Entering the realm of ACPI, pulling in more folks)
> 
> On Tue, 11 Feb, at 09:47:57PM, Madper Xie wrote:
> > Thanks for your reply. I attached the all the dmesg outputs for you.
> > [    0.000000] ACPI: BGRT 00000000d9bb5100 00003C (v00 HPQOEM SLIC-BPC 01072009 AMI  00010013)
>  
> Your BGRT table has an extra 4 bytes for some reason, (0x3C should be
> 0x38) and doesn't match the defintion in include/acpi/actbl3.h,
> 
> 
> struct acpi_table_bgrt {
> 	struct acpi_table_header header;	/* Common ACPI table header */
> 	u16 version;
> 	u8 status;
> 	u8 image_type;
> 	u64 image_address;
> 	u32 image_offset_x;
> 	u32 image_offset_y;
> };
> 
> 
> which explains why when we dereference ->image_address we don't get a
> sensible value.
> 
> Guys, what do you make of this? Firmware bug? Full thread here,
> 
>   http://article.gmane.org/gmane.linux.kernel.efi/3499
> 

Hi Matt,

Yes, I agree that the table size should be 0x38.  However, ACPI spec
states that bit0 of status indicates if the boot image graphic is valid.
This bit is set to 0 (invalid) on the system.  Can you check this bit
and return when invalid? 

Thanks,
-Toshi
