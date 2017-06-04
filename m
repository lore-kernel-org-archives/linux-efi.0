From: Maniaxx <tripleshiftone@gmail.com>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Sun, 4 Jun 2017 02:11:36 +0200
Message-ID: <4b651aea-0fcc-4f70-cf39-3a46393d2e28@gmail.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
 <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
 <e6d656c0-c76b-42c3-8413-0198efb8a33a@gmail.com>
 <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
 <c1505b0e-8136-86d3-e6ab-019c17106e5b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <c1505b0e-8136-86d3-e6ab-019c17106e5b@gmail.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

New kernel (with early_init panic):
In contrast to old kernel early_memremap is successful and
"Ignoring BGRT: failed to map image header memory" condition
isn't triggered.
https://github.com/torvalds/linux/blob/v4.11-rc1/arch/x86/platform/efi/efi-bgrt.c#L65

The next memcpy is the culprit for the panic. I've checked that with printk.
https://github.com/torvalds/linux/blob/v4.11-rc1/arch/x86/platform/efi/efi-bgrt.c#L71

This leads to this commit:
https://github.com/torvalds/linux/commit/66dbe99cfe30e113d2e571e68b9b6a1a8985a157

My u64 image address might be complete garbage (0A08E01800000001). Rather looks like 
2x u32. Here is another BGRT image address that looks much more valid than mine 
(on boundary, lower mem area).
https://ubuntuforums.org/showthread.php?t=2264380

If so, we are poking in invalid memory areas.

Reverting the commit until a better way is found to identify a valid
image address should fix the problem.




