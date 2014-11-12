From: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Wed, 12 Nov 2014 23:22:43 +0800
Message-ID: <CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415799312.14686.332.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 12, 2014 at 9:35 PM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> (Pulling sparse list in)
>
> On Wed, 2014-11-12 at 11:31 +0100, Ard Biesheuvel wrote:
>> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
>> >>> arch/x86/boot/compressed/eboot.c:26:16: sparse: incorrect type in return expression (different modifiers)
>> >    arch/x86/boot/compressed/eboot.c:26:16:    expected struct efi_config const [pure] *
>> >    arch/x86/boot/compressed/eboot.c:26:16:    got struct efi_config *static [toplevel] efi_early
>> >
>>
>> This smells like a sparse bug: __pure applies to functions only, so
>> there is no way we could ever return something with the __pure
>> modifier attached.

That make sense.

>
> Yes, that warning does look a little strange.
>
> Christopher, Fengguang, what do you guys think?
>

Do you get me a small test function that reproduce the error with sparse?

We can even add a test case for it.

Thanks

Chris
