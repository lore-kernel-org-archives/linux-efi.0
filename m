From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Wed, 19 Jun 2013 12:38:24 -0500
Message-ID: <51C1EC90.9030802@zytor.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de> <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <51C1E996.9070209@zytor.com> <20130619173721.GI28300@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130619173721.GI28300-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/19/2013 12:37 PM, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 12:25:42PM -0500, H. Peter Anvin wrote:
>> On 06/19/2013 08:02 AM, Borislav Petkov wrote:
>>>
>>> And yet there are the Macs which reportedly cannot stomach this.
>>>
>> No, the reports are that if you use the 1:1 map as the primary address
>> on Macs the drivers fail... not that you can't have a 1:1 map.
> 
> That's what I meant: ... cannot stomach when the 1:1 map is shoved down
> SetVirtualAddressMap.
> 
> The thing is, if we want to have both the 1:1 map and the high map
> during an EFI runtime call, we would need to *always* switch the
> pagetable for an EFI runtime call and establish both mappings in
> ->trampoline_pgd beforehand.
> 

I thought that was the plan?

	-hpa
