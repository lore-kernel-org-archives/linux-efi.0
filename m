From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [REGRESSION] boot-screen override by
 "34db50e55656 efifb: Copy the ACPI BGRT"
Date: Mon, 03 Sep 2018 16:16:06 +0200
Message-ID: <1982440.Fn0LzJ7a3l@amdc3058>
References: <CGME20180903132353epcas4p373e876f1b52dbed6df7bd3acc73fcdf4@epcas4p3.samsung.com>
        <CANq1E4QwNg0VuAZZtatOTXspv7Y-z_HSa-9CHzK2Y28CGK8W4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CANq1E4QwNg0VuAZZtatOTXspv7Y-z_HSa-9CHzK2Y28CGK8W4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-efi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, dri-devel@lists.freedesktop.org
List-Id: linux-efi@vger.kernel.org


Hi,

On Monday, September 03, 2018 03:23:38 PM David Herrmann wrote:
> Hey
> 
> Since this commit:
> 
>     34db50e55656 efifb: Copy the ACPI BGRT
> 
> the kernel will override boot-splashs unasked. This breaks the
> graphical boot-process on our setups. In particular, we have a setup
> where an efi-boot-entry draws the early boot-splash on-screen, then
> hands-over to the linux-kernel + initrd. The boot-splash daemon in the
> initrd then takes over control of possible animations.
> 
> With the mentioned commit compiled in, the kernel will redraw the
> firmware logo on screen at a random time without any way to intervene.

You have CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER=y (the deferred
console takeover support introduced in v4,19-rc1). I assume that this
is intended?

> What is the intention of this commit? Why is the kernel re-drawing the
> firmware logo unasked? If someone during the boot-process draws
> content on the screen, I would prefer if the kernel does not clear
> that on driver load.

+/*
+ * If fbcon deffered console takeover is configured, the intent is for the
+ * framebuffer to show the boot graphics (e.g. vendor logo) until there is some
+ * (error) message to display. But the boot graphics may have been destroyed by
+ * e.g. option ROM output, detect this and restore the boot graphics.
+ */
+#if defined CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER && \
+    defined CONFIG_ACPI_BGRT
...
+static void efifb_show_boot_graphics(struct fb_info *info)
...
+#else
+static inline void efifb_show_boot_graphics(struct fb_info *info) {}
+#endif

> Can we either provide an option to disable this feature, or revert the commit?

Hans?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
