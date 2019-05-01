From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: UEFI Fast Boot or Quick Boot for MS Windows also for Linux?
Date: Wed, 1 May 2019 12:53:55 +0200
Message-ID: <082b8964-7173-3a4e-b67d-24df13945617@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Dear Linux folks,


According to `systemd-analyze` the UEFI firmware on several systems, for 
example the laptop Dell Latitude E7250 and the desktop board MSI B350M 
MORTAR, take over ten seconds to initialize.

     $ systemd-analyze
     Startup finished in 11.193s (firmware) + 1.558s (loader) + 4.155s 
(kernel) + 2.007s (userspace) = 18.914s
     graphical.target reached after 1.983s in userspace

Talking to other people, I heard, Microsoft Windows since version 8 can 
activate some fast/quick boot mode in the firmware.

I haven’t even found the specification for that mode. It could be 
something like [1], but I do not think it is:

> Fast Boot is a feature in BIOS that reduces your computer boot time. If
> Fast Boot is enabled:
> 
> •   Boot from Network, Optical, and Removable Devices are disabled.
> •   Video and USB devices (keyboard, mouse, drives) won't be available
>     until the operating system loads.

Some other sources [2] say, that MS Windows just uses hibernation to 
boot quicker, but I do not think this is it, because with hibernation 
there should be also a ten seconds delay, right?

Do you know more about this mode, and how it works? Could it be 
implemented for Linux?


Kind regards,

Paul


[1]: 
https://www.intel.com/content/www/us/en/support/articles/000006699/mini-pcs.html
