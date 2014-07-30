From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Wed, 30 Jul 2014 13:04:31 -0400
Message-ID: <53D9259F.5050307@redhat.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <20140730144803.GB15082@console-pimps.org> <53D909C3.9050205@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53D909C3.9050205-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 07/30/2014 11:05 AM, Colin Ian King wrote:
> On 30/07/14 15:48, Matt Fleming wrote:
>> On Wed, 30 Jul, at 12:29:32AM, Borislav Petkov wrote:
>>> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
>>>> The current debug print in EFI does
>>>>
>>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
>>>>
>>>> and rounds off the size to 0MB and isn't very useful.  We should print this in
>>>> Kib.  After applying this patch we get better info with
>>>>
>>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
>>>
>>> Turning this into kiB unconditionally won't always work ok:
>>>
>>> First of all, there might be something which parses that output so I'd
>>> make sure I'm not breaking that. Maybe fwts... Matt will know.
>>
>> I'm not aware of anything that parses the dmesg output, but I'm
>> including Colin in case he has any insight.
>>
> That won't break fwts.

Matt -- could you make a decision on whether or not this should be strictly in
KiB or if it should be a rolling KiB, Mib, and GiB?

My issue is simply that I'd like to know *exactly* how big each range is and not
have it rounded off.  Others think that it is easier to read Mib & Gib ...

P.

> 
> Colin
> 
