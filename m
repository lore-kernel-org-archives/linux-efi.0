From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/8] efi/capsule: Add support for Quark security header
Date: Tue, 18 Apr 2017 15:55:08 +0300
Message-ID: <CAHp75VdqSim86_B=h9vu6veT3t8T8FAdOBfGDov-W9B5GNENwg@mail.gmail.com>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
 <20170405092317.27921-9-ard.biesheuvel@linaro.org> <20170418124853.GH24360@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170418124853.GH24360-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 3:48 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 05 Apr, at 10:23:17AM, Ard Biesheuvel wrote:

>> The firmware for Quark X102x prepends a security header to the capsule
>> which is needed to support the mandatory secure boot on this processor.
>> The header can be detected by checking for the "_CSH" signature and -
>> to avoid any GUID conflict - validating its size field to contain the
>> expected value. Then we need to look for the EFI header right after the
>> security header and pass the real header to __efi_capsule_setup_info.
>>
>> To be minimally invasive and maximally safe, the quirk version of
>> efi_capsule_identify_image is only effective on Quark processors.

>> +#ifdef CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH
>> +
>> +static const struct x86_cpu_id quark_ids[] = {
>> +     { X86_VENDOR_INTEL, 5, 9 },     /* Intel Quark X1000 */
>> +     { }
>> +};
>> +
>> +int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
>> +                        size_t hdr_bytes)
>> +{
>> +     struct quark_security_header *csh = kbuff;
>> +
>> +     cap_info->total_size = 0;
>> +
>> +     if (!x86_match_cpu(quark_ids))
>> +             goto fallback;
>> +
>
> I'd prefer to see the quark quirk pulled out into its own function and
> referenced from the __weak efi_capsule_setup_info() function, which
> makes it easier to people to read the EFI capsule code flow if they're
> not interested in the Quark quick.
>
> Something like this,
>
> int efi_capsule_setup_info(...)
> {
>         ...
>
>         if (x86_match_cpu(quark_ids))
>                 return efi_capsule_quark_setup_quirk(cap_info, kbuff, hdr_bytes);

Previously I had proposed to use driver_data field

Something like

struct _info {
int(*setup)(...);
}; <<< this is optional, might be useful in the future, otherwise just
simple typedef.

int efi_capsule_quark_setup_quirk(...)
{
}

struct _info efi_capsule_quark_info = {
 .setup = ..._setup_quirk,
};

#define ICPU(family, model, ddata) ...

static const struct x86_cpu_id quark_ids[] = {
 ICPU(5, 9, efi_capsule_quark_info),
 {}
};

Though didn't hear back on it.
-- 
With Best Regards,
Andy Shevchenko
