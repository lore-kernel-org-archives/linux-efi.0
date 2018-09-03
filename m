From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [REGRESSION] boot-screen override by "34db50e55656 efifb: Copy
 the ACPI BGRT"
Date: Mon, 3 Sep 2018 16:47:57 +0200
Message-ID: <dc7f08d7-77fc-92ca-b6ec-f9d5a8f24cf3@redhat.com>
References: <CGME20180903132353epcas4p373e876f1b52dbed6df7bd3acc73fcdf4@epcas4p3.samsung.com>
 <CANq1E4QwNg0VuAZZtatOTXspv7Y-z_HSa-9CHzK2Y28CGK8W4Q@mail.gmail.com>
 <1982440.Fn0LzJ7a3l@amdc3058>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1982440.Fn0LzJ7a3l@amdc3058>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-efi@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-efi@vger.kernel.org

Hi,

On 03-09-18 16:16, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday, September 03, 2018 03:23:38 PM David Herrmann wrote:
>> Hey
>>
>> Since this commit:
>>
>>      34db50e55656 efifb: Copy the ACPI BGRT
>>
>> the kernel will override boot-splashs unasked. This breaks the
>> graphical boot-process on our setups. In particular, we have a setup
>> where an efi-boot-entry draws the early boot-splash on-screen, then
>> hands-over to the linux-kernel + initrd. The boot-splash daemon in the
>> initrd then takes over control of possible animations.
>>
>> With the mentioned commit compiled in, the kernel will redraw the
>> firmware logo on screen at a random time without any way to intervene.
> 
> You have CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER=y (the deferred
> console takeover support introduced in v4,19-rc1). I assume that this
> is intended?
> 
>> What is the intention of this commit? Why is the kernel re-drawing the
>> firmware logo unasked? If someone during the boot-process draws
>> content on the screen, I would prefer if the kernel does not clear
>> that on driver load.
> 
> +/*
> + * If fbcon deffered console takeover is configured, the intent is for the
> + * framebuffer to show the boot graphics (e.g. vendor logo) until there is some
> + * (error) message to display. But the boot graphics may have been destroyed by
> + * e.g. option ROM output, detect this and restore the boot graphics.
> + */
> +#if defined CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER && \
> +    defined CONFIG_ACPI_BGRT
> ...
> +static void efifb_show_boot_graphics(struct fb_info *info)
> ...
> +#else
> +static inline void efifb_show_boot_graphics(struct fb_info *info) {}
> +#endif
> 
>> Can we either provide an option to disable this feature, or revert the commit?
> 
> Hans?

We use the ACPI bgrt extension to get the logo to draw and then
draw it since some devices rely on the OS to draw it and otherwise we
just end up with a blackscreen when doing silent / flickerfree boot.

Ideally you would be able to get your vendor to put the logo in firmware
in the ACPI bgrt extension, then you also do not need to play any tricks
with an EFI binary drawing your own logo. But I can understand if you don't
have control over this, so you need to do this with the EFI binary trick.

I can also understand that you want to use deferred console takeover
in a setup like yours to avoid fbcon messing up what is on the display
during boot, that is exactly what it is for. So I think a reasonable
approach here is to add a kernel commandline option, say:

video=efifb:nobgrt

David, would that work for you?

Regards,

Hans
