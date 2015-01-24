From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFD] efi assisted kdump
Date: Sat, 24 Jan 2015 21:26:37 +0800
Message-ID: <20150124132637.GB2139@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

Kdump has several limitations currently such as kdump kernel reboot will bypass
device shutdown path so device drivers should reset during initialization.

* One of such problem we encounter now is the iommu
issue, 1st kernel's on fly DMA requests cause 2nd kernel hang. There's some effort
on this area, Zhenhua Li posted patches to resolve the intel iommu issue which is
under review. But that is just one case there's other possible problems in the future.

* There's no serial console on most machines in the market especially for desktop
machines and laptops. kms enabled kernel need drm layer driver for framebuffer
console, after kernel crashing we need a console to see the 2nd kernel output
ideally a serial console because we can not switch back to VGA mode.

ppc64 has a feature "firmware assisted kdump", see below documentation:
Documentation/powerpc/firmware-assisted-dump.txt

In case UEFI machines I wonder if we can do similar things, basic idea is doing
minimum thing based on original kdump process.

kernel reserve crashkernel memory during early boot
 -> user (kdump service) save necessary informations in some way so that second
    kernel boot can access ie. efi runtime variables or in reserved memory
    * crashkernel memory ranges infomation
    * collect infomations and save elf notes for 2nd kernel vmcore initialization
    -> crashing
       * call efi warm reboot
       -> 2nd kernel boot
          -> efi stub checking if this is a warm reboot and if this is a crashed boot
             -> if this is not a crashed boot then
                    do nothing more than original logic
                else
                    boot kernel with limited memory which was reserved in previous kernel
                    -> 2nd kernel boot
                       vmcore intializing

There's several things I need to ask for help from EFI gurus to see if it is doable:

* Make sure in case EFI warm reboot the memory of previous kernel can be retained.

* How to determine if kernel is boot with EFI warm reboot in stub

* What is the right way to pass informations from 1st kernel to 2nd kernel.
  Is it ok for saving something with efi variables? 

* Other possible problems what I missed

Thanks
Dave
