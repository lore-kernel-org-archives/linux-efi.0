From: David Herrmann <dh.herrmann@gmail.com>
Subject: [REGRESSION] boot-screen override by "34db50e55656 efifb: Copy the
 ACPI BGRT"
Date: Mon, 3 Sep 2018 15:23:38 +0200
Message-ID: <CANq1E4QwNg0VuAZZtatOTXspv7Y-z_HSa-9CHzK2Y28CGK8W4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org, linux-efi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, dri-devel@lists.freedesktop.org
List-Id: linux-efi@vger.kernel.org

Hey

Since this commit:

    34db50e55656 efifb: Copy the ACPI BGRT

the kernel will override boot-splashs unasked. This breaks the
graphical boot-process on our setups. In particular, we have a setup
where an efi-boot-entry draws the early boot-splash on-screen, then
hands-over to the linux-kernel + initrd. The boot-splash daemon in the
initrd then takes over control of possible animations.

With the mentioned commit compiled in, the kernel will redraw the
firmware logo on screen at a random time without any way to intervene.

What is the intention of this commit? Why is the kernel re-drawing the
firmware logo unasked? If someone during the boot-process draws
content on the screen, I would prefer if the kernel does not clear
that on driver load.

Can we either provide an option to disable this feature, or revert the commit?

Thanks
David
