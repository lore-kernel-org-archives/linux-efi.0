From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Mon, 10 Nov 2014 12:58:39 -0800
Message-ID: <546126FF.3070600@zytor.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <20141109182231.GA29337@pd.tnic> <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com> <201411101723.49197@pali> <5460EB92.1090501@gmail.com> <20141110170417.GA17286@srcf.ucam.org> <5461220E.20605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5461220E.20605-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/10/2014 12:37 PM, Austin S Hemmelgarn wrote:
> On 2014-11-10 12:04, Matthew Garrett wrote:
>> On Mon, Nov 10, 2014 at 11:45:06AM -0500, Austin S Hemmelgarn wrote:
>>
>>> I agree, without it you need PC CMOS RTC support to access the RTC
>>> on most systems, which in turn means that you have to enable the CSM
>>> in the EFI firmware, which is annoying cause you can't easily dual
>>> boot windows with secure boot when the CSM is enabled.
>>
>> CMOS RTC support doesn't depend on the CSM.
>>
> That's really interesting, because with it compiled in, I can't boot on
> my EFI based thinkpad laptop without telling EFI to launch the CSM, and
> with it compiled out, I can boot fine without the CSM.  I'll have to
> look further into the options I have set in my kernel build, I may have
> changed something else without remembering between booting with and
> without the CSM enabled.
> 

It could also be that the non-CSM BIOS somehow remaps the CMOS registers.

	-hpa
