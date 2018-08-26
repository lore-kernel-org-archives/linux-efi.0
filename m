From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Sat, 25 Aug 2018 19:30:53 -0700
Message-ID: <c2e61e43-6cd5-567a-8c3c-3cc3ff456c31@roeck-us.net>
References: <20171215092305.994559179@linuxfoundation.org>
 <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <1535129126.2902.36.camel@codethink.co.uk>
 <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
 <20180824191749.GA15489@kroah.com>
 <CAL1RGDXUx-frpWuuYyc-VrAEoOU2+irGQPRWvoBzO2ZxEPGrww@mail.gmail.com>
 <35e0f79b-6fac-5027-6377-67dbe2a293b9@roeck-us.net>
 <20180825150723.GA10230@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180825150723.GA10230@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roland Dreier <roland@purestorage.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

On 08/25/2018 08:07 AM, Greg Kroah-Hartman wrote:
> On Sat, Aug 25, 2018 at 06:52:32AM -0700, Guenter Roeck wrote:
>> Hi Roland,
>>
>> On 08/24/2018 01:04 PM, Roland Dreier wrote:
>>>> Ok, so what patch should be reverted?  I'm seeing other reports of
>>>> problems all around this same area, but I can't figure out exactly what
>>>> to do.
>>>
>>> Are any of those reports public?  If so can you point me at them, I'm
>>> curious if the symptoms match up.
>>>
>>> I don't think we want to revert anything.  I think you should pull in
>>> edc3b9129cec and at least the first three patches that Ben listed:
>>>
>>> 21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs
>>> b61a76f8850d x86/efi: Map RAM into the identity page table for mixed mode
>>> 753b11ef8e92 x86/efi: Setup separate EFI page tables in kexec paths
>>>
>>> the first patch takes a bit of massaging (mostly because some of it is
>>> already touched by 02ff2769edbc, which keeps the changes from
>>> edc3b9129cec, and so we can drop a good bit when applying).  The other
>>> three apply cleanly.
>>>
>>> I'm currently testing that and can send you the state of my tree in a bit.
>>>
>>
>> Have you made any progress ? On my side I am still out of luck since I can not
>> reproduce the problem.
> 
> Perhaps just the patch that Andi posted to the stable list helps out
> here?
> 

For reference:

https://www.spinics.net/lists/stable/msg253357.html

That would be the most straightforward and simple fix, so I would prefer
to go with it if it works.

Guenter
