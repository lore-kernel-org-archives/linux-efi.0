From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v9 1/1] efi: a misc char interface for user to update efi
 firmware
Date: Tue, 3 Nov 2015 20:59:34 +0100
Message-ID: <20151103195934.GC3620@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C4A879BFE@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A879BFE-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Anvin, H Peter" <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 02, 2015 at 06:47:29AM +0000, Kweh, Hock Leong wrote:
> By looking at your dmesg log, the above print out message seem that
> someone has called the flush() after the write(2). In my environment, flush()
> only being called in 2 places which are before write(2) and during close(2).
> The dmesg log seems that your environment is running write(2) and flush() in
> different threads and are parallel. Could you help me to double confirm this and it 
> would be good if you could told me when the flush() is exactly being called in
> your environment. The info really help me on debugging.

I don't know what you mean: I simply do

cat /bin/ls > /dev/efi_capsule_loader

as root in an SMP kvm guest. And it explodes. Nothing special, just this
one command.

I guess you could try to reproduce it, here's how I start it:

qemu-system-x86_64
-enable-kvm
-gdb tcp::1234
-cpu Opteron_G5
-m 2048
-hda /home/boris/kvm/debian/sid-x86_64.img
-hdb /home/boris/kvm/swap.img
-boot menu=off,order=c
-localtime
-net nic,model=rtl8139
-net user,hostfwd=tcp::1235-:22
-usbdevice tablet
-kernel /home/boris/kernel/linux-2.6/arch/x86/boot/bzImage
-append "root=/dev/sda1 resume=/dev/sdb1 debug ignore_loglevel log_buf_len=16M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0"
-monitor pty
-virtfs local,path=/tmp,mount_tag=tmp,security_model=none
-serial file:/home/boris/kvm/test-x86_64-1235.log
-snapshot
-smp 8

HTH.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
