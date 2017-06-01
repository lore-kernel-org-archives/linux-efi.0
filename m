From: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Thu, 1 Jun 2017 21:13:20 +0200
Message-ID: <e6d656c0-c76b-42c3-8413-0198efb8a33a@gmail.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
 <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170601015621.GA4306-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Content-Language: de-DE
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01.06.2017 at 03:57 wrote Dave Young:
> This means the efi_bgrt_init failed out originally before the early init BGRT
> patch. Checking the code the only difference is current code we have no
> below code:
> 
>         status = acpi_get_table("BGRT", 0,
>                                 (struct acpi_table_header **)&bgrt_tab);
>         if (ACPI_FAILURE(status))
>                 return;
> 
> So probably acpi_get_table has some more sanity checking and it failed
> early. Can you add a printk before above return to confirm it? Just test
> the old kernel without early init BGRT patch.

Doesn't fail early. I can see the printk.
