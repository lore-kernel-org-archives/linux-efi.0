From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 18:32:56 -0400
Message-ID: <53D82118.6090202@redhat.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729222932.GA17481-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 07/29/2014 06:29 PM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
>> The current debug print in EFI does
>>
>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
>>
>> and rounds off the size to 0MB and isn't very useful.  We should print this in
>> Kib.  After applying this patch we get better info with
>>
>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
> 
> Turning this into kiB unconditionally won't always work ok:
> 
> First of all, there might be something which parses that output so I'd
> make sure I'm not breaking that. Maybe fwts... Matt will know.
> 
> Then, I have an UEFI region which is > 13G:
> 
> [    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13568MB)
> 
> 
> With your patch it is even worse:
> 
> [    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x0000000450000000) (13893632kiB)
> 
> 
> I'd guess you'll have to go all out and do this properly. :-)
> 
> Something like showing the highest unit which is still > 1. In the above
> case, this should be (13GB) or maybe even introduce fractions.
> 
> Depends on how involved this output should be.

Yeah, I thought about doing something like that but figured if I'm at this level
I can do some math ;), and it was best to keep the code simple with a KiB.

Matt -- will anything be broken here if we change the output?

P.

> 
