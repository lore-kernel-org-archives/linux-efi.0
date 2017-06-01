From: Dave Young <dyoung@redhat.com>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Thu, 1 Jun 2017 09:57:31 +0800
Message-ID: <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Maniaxx <tripleshiftone@gmail.com>
Cc: linux-efi@vger.kernel.org, rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Cc ACPI people for thoughts..

On 06/01/17 at 03:17am, Maniaxx wrote:
> On 27.05.2017 at 07:34 wrote Dave Young:
> >> Can you double check it works before the commit of below? 
> linux-git-4.10rc5.r115.gc4c39c70c5fe is fine (1 commit back)
> linux-git-4.10rc5.r116.g7b0a911478c7 is not (early init BGRT patch)
> 
> >> If machine
> >> boots fine then check /sys/firmware/acpi/bgrt/image see if it exists or
> >> not. 
> Not sure. /sys/firmware/acpi/bgrt/ doesn't exist here but i have
> /sys/firmware/acpi/tables/ that contains all tables. BGRT is 60 bytes
> and holds the same binary content as pr_info hex_dump (in dmesg log below).

This means the efi_bgrt_init failed out originally before the early init BGRT
patch. Checking the code the only difference is current code we have no
below code:

        status = acpi_get_table("BGRT", 0,
                                (struct acpi_table_header **)&bgrt_tab);
        if (ACPI_FAILURE(status))
                return;

So probably acpi_get_table has some more sanity checking and it failed
early. Can you add a printk before above return to confirm it? Just test
the old kernel without early init BGRT patch.

> 
> >> if you can manange to save full kernel log it would be also helpful.
> Here is a log of linux-git-4.10rc5.r115.gc4c39c70c5fe with Sabrina
> Dubroca's test code applied:
> https://pastebin.com/ZkBNejrC
> 
> This is how i applied the patch. I hope its correct:
> https://pastebin.com/see6V0Bk
> 

Thanks
Dave
