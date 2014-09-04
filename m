From: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Date: Thu, 04 Sep 2014 13:24:39 +0200
Message-ID: <54084BF7.8090900@canonical.com>
References: <5405E186.2080406@canonical.com> <20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com> <5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com> <54073409.6030004@canonical.com> <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com> <20140903175948.GH3001@console-pimps.org> <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com> <54084376.8090002@canonical.com> <BA3DE6F4-93D9-4CDE-90D7-280360929ABD@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BA3DE6F4-93D9-4CDE-90D7-280360929ABD-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Op 04-09-14 om 13:19 schreef Ard Biesheuvel:
>
>> On 4 sep. 2014, at 12:48, Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>>
>> Op 03-09-14 om 21:57 schreef Ard Biesheuvel:
>>> On 3 September 2014 19:59, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>>>> On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
>>>>> Will do, thanks.
>>>>>
>>>>> @Matt: so there is two ways to fix this, the patch above addressing
>>>>> this single instance, and alternatively, adding a #pragma GCC
>>>>> visiblilty push(hidden) to all .c files under libstub/, *before* the
>>>>> #includes. The latter would catch future problems regarding newly
>>>>> introduced global variables, but it may be a bit overkill in this
>>>>> case, as libstub is not expected to be in flux in the foreseeable
>>>>> future.
>>>>>
>>>>> Any preferences?
>>>> Any reason we can't reuse the existing GOT fixup code in the early x86
>>>> boot code? We're not executing it before the EFI boot stub atm, which is
>>>> the reason Maarten is hitting these difficulties.
>>> I guess that is likely to work, I just wasn't aware it existed :-)
>>> I think adding another visibility(hidden) attribute or 2 would
>>> complete eliminate the need for GOT fixups, but I guess that is more
>>> sensitive to compiler versions being recent enough etc.
>>> The attached (build tested only) patch eliminates all GOT relocations
>>> under boot/compressed for a 64-bit EFI stub build.
>>>
>>>> Maarten, does the following help?
>>>>
>>>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>>>> done the single __attribute__() hacks in other projects and someone
>>>> (usually me) always eventually forgets to tag some instance.
>>> It appears we just got lucky on arm64, since we don't have any global
>>> variables, but the issue does exist there as well.
>> FWIW, visibility pushing doesn't seem to work for functions declared with extern.
> Are you sure you are seeing GOT entries being generated for functions? Normally, these are resolved via PLT entries, and those usually don't result in GOT entries to be allocated unless the branch target is unknown at link time.
>
No not really, I was just looking at GOTPCREL for the .o files, no idea if they resulted in any actual relocations or not.

~Maarten
