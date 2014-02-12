From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
Date: Wed, 12 Feb 2014 01:00:44 +0100
Message-ID: <2489572.ETmt2OD4Ee@vostro.rjw.lan>
References: <8738jr5t3e.fsf@redhat.com> <87lhxh69u0.fsf@redhat.com> <20140211141846.GA1725@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20140211141846.GA1725@console-pimps.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Triplett <josh@joshtriplett.org>, Lv Zheng <lv.zheng@intel.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <len.brown@intel.com>, Robert Moore <robert.moore@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tuesday, February 11, 2014 02:18:46 PM Matt Fleming wrote:
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

Firmware bug, but I guess we'll need to work around it.

Adding more CCs.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
