From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH v4] efi: split efisubsystem from efivars
Date: Thu, 21 Feb 2013 13:31:57 +0100
Message-ID: <CAG-2HqWG342WsqGH-YGM4TASa8QSU3+9tbwwfGEk3437w7fwvw@mail.gmail.com>
References: <1361041300-3760-1-git-send-email-teg@jklm.no> <1361445421.2842.3.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361445421.2842.3.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tobias Powalowski <tpowa-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 21, 2013 at 12:17 PM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, 2013-02-16 at 20:01 +0100, Tom Gundersen wrote:
>>  #
>> +obj-$(CONFIG_EFI)                    += efi.o
>
> The $(CONFIG_EFI) part is redundant. We only build things in
> drivers/firmware/efi/ if CONFIG_EFI=y.

Ah, good point.

>> +     /* We register the efi directory at /sys/firmware/efi */
>> +     efi_kobj = kobject_create_and_add("efi", firmware_kobj);
>> +     if (!efi_kobj) {
>> +             pr_err("efi: Firmware registration failed.\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
>> +     if (error) {
>> +             pr_err("efi: Sysfs attribute export failed with error %d.\n",
>> +                    error);
>> +     }
>> +
>> +#if defined(CONFIG_EFIVAR_FS) || defined(CONFIG_EFIVAR_FS_MODULE)
>> +     /* and the standard mountpoint for efivarfs */
>> +     efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
>> +     if (!efivars_kobj) {
>> +             pr_err("efivars: Subsystem registration failed.\n");
>> +             kobject_put(efi_kobj);
>> +             return -ENOMEM;
>> +     }
>> +#endif /* CONFIG_EFIVAR_FS */
>
> Does it make sense to hide the efivarfs mount point? I'm not crazy about
> sprinkling more #ifdef's around. If the efivarfs code isn't compiled
> into the kernel/built as a module then mounting will fail anyway.

I was 50/50 on that, so if you prefer to remove the ifdef that's fine with me.

I'll send out a new version soon, unless you prefer to just fix it up
as you apply it?

Cheers,

Tom
