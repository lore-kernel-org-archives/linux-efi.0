From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function symbol
Date: Wed, 07 Oct 2015 09:27:05 +0100
Message-ID: <5614D759.8020405@nexus-software.ie>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com> <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com> <20151005131350.GA26329@nazgul.tnic> <F54AEECA5E2B9541821D670476DAE19C4A864613@PGSMSX102.gar.corp.intel.com> <5612EB38.2050209@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C4A864B5D@PGSMSX102.gar.corp.intel.com> <5613E076.20508@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C4A864DCF@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A864DCF@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On 07/10/15 03:01, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>> Sent: Tuesday, October 06, 2015 10:54 PM
>>>>
>>>> Aside from that, I'm curious which types of capsules you've used here
>>>> too - does it include the MFH header ? Keep in mind the initial
>>>> firmware that shipped with Galileo will depend on that MFH being
>> present.
>>>>
>>>>
>> http://download.intel.com/support/processors/quark/sb/quark_secureboo
>>>> t
>>>> prm_330234_001.pdf
>>>> - Section A1 - table 7 ?
>>>>
>>>> So if we boot a 4.x kernel with that initial firmware version 0.75 if
>>>> memory serves - it's important that the capsule.c code handles the MFH.
>>>>
>>>
>>> Already got agreement with Matt that Quark Security Header patch will
>>> not be upstream to mainline as it is not a standard header. So Intel
>>> will carry this patch ourselves.
>>
>> Right... so what sort of capsule are you testing with ?
>
> I am testing on Intel Galileo Gen 1 with bios version v0.7.5, v0.8.0, v1.0.1 & v1.0.2.
>
> Thanks & Regards,
> Wilson
>

Hmm.

That's pretty confusing.

The 0.75 BIOS requires the MFH as far as I remember. If the capsule you 
are using doesn't have the MFH - how is this working ?
