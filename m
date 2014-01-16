From: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
Date: Wed, 15 Jan 2014 18:41:29 -0800
Message-ID: <52D746D9.7030206@linux.intel.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com> <52D6970D.3050701@zytor.com> <20140116014457.GA3807@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140116014457.GA3807-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1/15/2014 5:44 PM, Dave Young wrote:
> On 01/15/14 at 06:11am, H. Peter Anvin wrote:
>> On 01/14/2014 05:16 PM, Dave Young wrote:
>>>>
>>>> Why the [Finnish] do you feel that information needs to be in a
>>>> different form because it is (currently!) not available as a module?
>>>
>>> I think moving them to comment can avoid including extra linux/module.h
>>>
>>
>> And that matters, why?
>
> At least the code will be cleaner and kernel size will be a bit smaller?
>

making something harder to grep and less standardized is hardly cleaner
and these things compile to nothing for non-modules.
