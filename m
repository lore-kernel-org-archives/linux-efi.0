From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
Date: Fri, 04 Jan 2013 08:17:51 -0800
Message-ID: <0adaa194-413d-497e-aecf-3ac7c16c9134@email.android.com>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org> <1357219085-4312-2-git-send-email-matt@console-pimps.org> <50E6F086.5020209@gmail.com> <1357316128.8203.33.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357316128.8203.33.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Tim Gardner <rtg.canonical-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, tim.gardner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Well, *I* am confused as heck.  They look like bitmasks, we normally use decimal numbers for bit numbers as a matter of style.

Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:

>On Fri, 2013-01-04 at 08:08 -0700, Tim Gardner wrote:
>> On 01/03/2013 06:18 AM, Matt Fleming wrote:
>> > From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > 
>> 
>> snip
>> 
>> >  /*
>> > - * We play games with efi_enabled so that the compiler will, if
>possible, remove
>> > - * EFI-related code altogether.
>> > + * We play games with efi_enabled so that the compiler will, if
>> > + * possible, remove EFI-related code altogether.
>> >   */
>> > +#define EFI_BOOT		0x00000001 /* Were we booted from EFI? */
>> > +#define EFI_SYSTEM_TABLES	0x00000002 /* Can we use EFI system
>tables? */
>> > +#define EFI_CONFIG_TABLES	0x00000004 /* Can we use EFI config
>tables? */
>> > +#define EFI_RUNTIME_SERVICES	0x00000004 /* Can we use runtime
>services? */
>> > +#define EFI_MEMMAP		0x00000008 /* Can we use EFI memory map? */
>> > +#define EFI_64BIT		0x00000010 /* Is the firmware 64-bit? */
>> > +
>> 
>> Your use of test_bit() and set_bit() imply that these macros should
>be
>> bit numbers, not bit masks. It'll work until you define a mask with
>an
>> integer value greater then 31.
>
>They're not intended to be bitmasks in the sense that no two bits are
>set in each constant (and I am aware of the upper limit).
>
>I have no problem changing the above values to bit numbers if that
>would
>be less confusing.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
