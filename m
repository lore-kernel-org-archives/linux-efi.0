From: Maniaxx <tripleshiftone-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Thu, 1 Jun 2017 03:17:41 +0200
Message-ID: <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170527053457.GB3492-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: public-linux-efi-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 27.05.2017 at 07:34 wrote Dave Young:
>> Can you double check it works before the commit of below? 
linux-git-4.10rc5.r115.gc4c39c70c5fe is fine (1 commit back)
linux-git-4.10rc5.r116.g7b0a911478c7 is not (early init BGRT patch)

>> If machine
>> boots fine then check /sys/firmware/acpi/bgrt/image see if it exists or
>> not. 
Not sure. /sys/firmware/acpi/bgrt/ doesn't exist here but i have
/sys/firmware/acpi/tables/ that contains all tables. BGRT is 60 bytes
and holds the same binary content as pr_info hex_dump (in dmesg log below).

>> if you can manange to save full kernel log it would be also helpful.
Here is a log of linux-git-4.10rc5.r115.gc4c39c70c5fe with Sabrina
Dubroca's test code applied:
https://pastebin.com/ZkBNejrC

This is how i applied the patch. I hope its correct:
https://pastebin.com/see6V0Bk
