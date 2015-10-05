From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function symbol
Date: Mon, 05 Oct 2015 22:27:20 +0100
Message-ID: <5612EB38.2050209@nexus-software.ie>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com> <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com> <20151005131350.GA26329@nazgul.tnic> <F54AEECA5E2B9541821D670476DAE19C4A864613@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A864613@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On 05/10/15 16:19, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Borislav Petkov [mailto:bp@alien8.de]
>> Sent: Monday, October 05, 2015 9:14 PM
>>
>> So this one is still a separate patch.
>>
>> If you're going to ignore review comments, maybe I should stop wasting my
>> time reviewing your stuff...
>>
>> --
>> Regards/Gruss,
>>      Boris.
>
> Already follow what you have suggested, put a note under --- line:
> https://lkml.org/lkml/2015/10/5/230 (at line 25 - 27)
>
> Thanks for the review comments.

Wilson - trying to test this out on a Galileo Gen2 - which branch are 
you doing this against ?

I can apply the first patch you're proposing to squash your commit into

https://lkml.org/lkml/diff/2014/10/7/390/1

but then trying to apply the first in your series on top of that patch I get

deckard@aineko:~/Development/linux$ git apply 
../patches/capsule_wilson/1_2.eml
../patches/capsule_wilson/1_2.eml:72: trailing whitespace.
EXPORT_SYMBOL_GPL(efi_capsule_supported);
error: drivers/firmware/efi/capsule.c: No such file or directory

https://kernel.googlesource.com/pub/scm/linux/kernel/git/mfleming/efi/+/capsule/drivers/firmware/efi/capsule.c 


??

If so - then why not use the interface here ?
https://kernel.googlesource.com/pub/scm/linux/kernel/git/mfleming/efi/+/capsule

(Sorry I know I'm coming to this thread late)

Aside from that, I'm curious which types of capsules you've used here 
too - does it include the MFH header ? Keep in mind the initial firmware 
that shipped with Galileo will depend on that MFH being present.

http://download.intel.com/support/processors/quark/sb/quark_securebootprm_330234_001.pdf 
- Section A1 - table 7 ?

So if we boot a 4.x kernel with that initial firmware version 0.75 if 
memory serves - it's important that the capsule.c code handles the MFH.

--
BOD
