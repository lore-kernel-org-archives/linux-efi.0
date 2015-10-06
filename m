From: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function symbol
Date: Tue, 06 Oct 2015 15:53:42 +0100
Message-ID: <5613E076.20508@nexus-software.ie>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com> <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com> <20151005131350.GA26329@nazgul.tnic> <F54AEECA5E2B9541821D670476DAE19C4A864613@PGSMSX102.gar.corp.intel.com> <5612EB38.2050209@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C4A864B5D@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A864B5D-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/10/15 11:53, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Bryan O'Donoghue [mailto:pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org]
>> Sent: Tuesday, October 06, 2015 5:27 AM
>>
>> Wilson - trying to test this out on a Galileo Gen2 - which branch are you doing
>> this against ?
>>
>> I can apply the first patch you're proposing to squash your commit into
>>
>> https://lkml.org/lkml/diff/2014/10/7/390/1
>>
>> but then trying to apply the first in your series on top of that patch I get
>>
>> deckard@aineko:~/Development/linux$ git
>> apply ../patches/capsule_wilson/1_2.eml
>> ../patches/capsule_wilson/1_2.eml:72: trailing whitespace.
>> EXPORT_SYMBOL_GPL(efi_capsule_supported);
>> error: drivers/firmware/efi/capsule.c: No such file or directory
>>
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/mfleming/efi/+/
>> capsule/drivers/firmware/efi/capsule.c
>>
>>
>> ??
>
> If you are applying Matt's patch https://lkml.org/lkml/diff/2014/10/7/390/1 which
> had been created 1 year ago to mainline vanilla kernel (Linux 4.3-rc4), you are not
> able to direct patch in due to the Makefile error below:
>
> ~/MyWorks/linux_mainline$ git apply .git/rebase-apply/0001 --reject
> Checking patch arch/x86/kernel/reboot.c...
> Hunk #1 succeeded at 527 (offset 11 lines).
> Checking patch drivers/firmware/efi/Makefile...
> error: while searching for:
> #
> # Makefile for linux kernel
> #
> obj-$(CONFIG_EFI)                       += efi.o vars.o reboot.o
> obj-$(CONFIG_EFI_VARS)                  += efivars.o
> obj-$(CONFIG_EFI_VARS_PSTORE)           += efi-pstore.o
> obj-$(CONFIG_UEFI_CPER)                 += cper.o
>
> error: patch failed: drivers/firmware/efi/Makefile:1
> Checking patch drivers/firmware/efi/capsule.c...
> Checking patch drivers/firmware/efi/reboot.c...
> Checking patch include/linux/efi.h...
> Hunk #1 succeeded at 122 (offset 3 lines).
> Hunk #2 succeeded at 983 (offset 23 lines).
> Hunk #3 succeeded at 1235 (offset 23 lines).
> Hunk #4 succeeded at 1317 (offset 23 lines).
> Applied patch arch/x86/kernel/reboot.c cleanly.
> Applying patch drivers/firmware/efi/Makefile with 1 rejects...
> Rejected hunk #1.
> Applied patch drivers/firmware/efi/capsule.c cleanly.
> Applied patch drivers/firmware/efi/reboot.c cleanly.
> Applied patch include/linux/efi.h cleanly.
>
> You should resolve the Makefile error and then git add 5 files below:
> - arch/x86/kernel/reboot.c
> - drivers/firmware/efi/Makefile
> - drivers/firmware/efi/reboot.c
> - include/linux/efi.h
> - drivers/firmware/efi/capsule.c
>
> then you are able to patch in my patchset.
>
>>
>> If so - then why not use the interface here ?
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/mfleming/efi/+/
>> capsule
>>
>> (Sorry I know I'm coming to this thread late)
>>
>> Aside from that, I'm curious which types of capsules you've used here too -
>> does it include the MFH header ? Keep in mind the initial firmware that
>> shipped with Galileo will depend on that MFH being present.
>>
>> http://download.intel.com/support/processors/quark/sb/quark_secureboot
>> prm_330234_001.pdf
>> - Section A1 - table 7 ?
>>
>> So if we boot a 4.x kernel with that initial firmware version 0.75 if memory
>> serves - it's important that the capsule.c code handles the MFH.
>>
>
> Already got agreement with Matt that Quark Security Header patch will not
> be upstream to mainline as it is not a standard header. So Intel will carry this
> patch ourselves.

Right... so what sort of capsule are you testing with ?
