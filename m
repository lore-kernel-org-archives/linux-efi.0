From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 29 Sep 2015 23:58:05 +0200
Message-ID: <560B096D.6000303@redhat.com>
References: <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
 <E40EBF14-FD9E-49C0-A7FB-951958F72F79@zytor.com>
 <CAKv+Gu8i4KuXYQZA5noTomj6-chZcuuDEQubOJznyP1DR=+VTw@mail.gmail.com>
 <0568D1D7-B6AA-437C-ADCE-A86D7A2E4722@zytor.com>
 <20150926195755.GC3144@codeblueprint.co.uk>
 <BFDFFBC6-C6CA-4035-8E29-C7220533A787@linaro.org>
 <F1F37F57-7D03-4FC2-955E-7E8C82540A24@zytor.com>
 <CALCETrUA6k-oHzuWA54VzEA1v63b5--JPCCuBoOxLisOtjUn+g@mail.gmail.com>
 <20150927180633.GA29466@srcf.ucam.org> <20150928061646.GA21690@gmail.com>
 <20150928064143.GA7380@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928064143.GA7380-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, "Jordan Justen (Intel address)" <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/28/15 08:41, Matthew Garrett wrote:
> On Mon, Sep 28, 2015 at 08:16:46AM +0200, Ingo Molnar wrote:
>
>> So the question is, what does Windows do?
>
> It's pretty trivial to hack OVMF to dump the SetVirtualAddressMap()
> arguments to the qemu debug port. Unfortunately I'm about to drop
> mostly  offline for a week, otherwise I'd give it a go...

In order to enable the properties table feature in OVMF, two conditions
have to be satisfied:

(a) set gEfiMdeModulePkgTokenSpaceGuid.PcdPropertiesTableEnable to TRUE
(b) build DXE_RUNTIME_DRIVER modules with 4KB section alignment

(a) used to be possible only statically (ie. at build time), but since
edk2 commit ab081a50e5 [1] it can be done dynamically too, on the qemu
command line. See that edk2 commit for details.

This OVMF feature depends on QEMU commit 81b2b81062 [2]. Another patch
from Gabriel is under review that enables such simple settings without
host-side files [3].

(b) is satisfied by the edk2 patch that Ard posted today [4].

Because I know how much people like building OVMF, I uploaded a fresh
OVMF binary (which includes a number of other patches from my personal
tree, but those are irrelevent here), with a matching varstore template,
to [5]. The relevant edk2 patches (ie. the one from Ard [4], and a debug
patch like you mention above) can also be found under [5].

(

I recommend to start QEMU like this:

  # Create a new (empty) varstore for the virtual machine, from the
  # varstore template.

  cp OVMF_VARS.fd my-vars.fd

  # Start the VM, with direct kernel boot.

  qemu-system-x86_64 \
  -m 2048 \
  -M pc,accel=kvm \
  \
  -device qxl-vga \
  \
  -drive if=pflash,format=raw,unit=0,file=OVMF_CODE.fd,readonly=on \
  -drive if=pflash,format=raw,unit=1,file=my-vars.fd \
  \
  -debugcon file:debug.log \
  -global isa-debugcon.iobase=0x402 \
  \
  -chardev stdio,signal=off,mux=on,id=char0 \
  -mon chardev=char0,mode=readline,default \
  -serial chardev:char0 \
  \
  -kernel vmlinuz... \
  -initrd initramfs... \
  -append "root=..." \
  \
  ...

The guest will have 2GB of RAM, it will use KVM, the virtual video card
will be QXL; the OVMF debug log will be written to "debug.log". The key
combination [Control-A C] will switch between the QEMU monitor prompt
and the serial port of the guest. The above should be suitable for rapid
testing of kernels built on the host.

)

Then I booted my Windows Server 2012 R2, Windows 8.1, and Windows 10
guests, with the properties table feature enabled vs. disabled in the
firmware. (All three Windows guests were updated first though.)

All three Windows OSes adapt their SetVirtualAddressMap() calls, when
the feature is enabled in the firmware. However, Windows 8.1 crashes
nonetheless (BSOD, I forget the fault details, sorry). Windows Server
2012 R2 and Windows 10 boot fine.

I uploaded the verbose OVMF log files from all six guest boots to [5].
The tables you might be interested in are dumped at the ends of the log
files.

All three guests had 2GB of RAM. They had different VM configurations,
but between disabling and enabling the properties table feature, no
other knob was tweaked. Therefore the two log files of the same guest
should be comparable against each other, for each guest. For example:

$ colordiff -u ovmf.win10.prop.{disabled,enabled}.log

Because stuff hosted on the web privately tends to go away, I'll quote
that diff here, for posterity:

> --- ovmf.win10.prop.disabled.log	2015-09-29 22:01:45.252126086 +0200
> +++ ovmf.win10.prop.enabled.log	2015-09-29 21:50:54.579475078 +0200
> @@ -24,7 +24,7 @@
>  QemuFwCfg interface is supported.
>  Platform PEIM Loaded
>  CMOS:
> -00: 38 00 01 00 22 00 03 29 09 15 26 02 00 80 00 00
> +00: 48 00 50 00 21 00 03 29 09 15 26 02 00 80 00 00
>  10: 00 00 00 00 06 80 02 FF FF 00 00 00 00 00 00 00
>  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  30: FF FF 20 00 00 7F 00 20 30 00 00 00 00 12 00 00
> @@ -1110,6 +1110,17 @@
>  InstallProtocolInterface: 4CF5B200-68B8-4CA5-9EEC-B23E3F50029A 7F271568
>  [Variable]END_OF_DXE is signaled
>  Initialize variable error flag (FF)
> +MemoryProtectionAttribute - 0x0000000000000001
> +Total Image Count - 0x8
> +Dump ImageRecord:
> +  Image[0]: 0x000000007EC26000 - 0x000000000000A000
> +  Image[1]: 0x000000007EC35000 - 0x0000000000008000
> +  Image[2]: 0x000000007EC65000 - 0x000000000000C000
> +  Image[3]: 0x000000007ED76000 - 0x00000000000A3000
> +  Image[4]: 0x000000007FE9E000 - 0x0000000000009000
> +  Image[5]: 0x000000007FEA7000 - 0x000000000000A000
> +  Image[6]: 0x000000007FEB1000 - 0x000000000000C000
> +  Image[7]: 0x000000007FEBD000 - 0x000000000000C000
>  S3Ready!
>  SaveLockBox: Guid=DEA652B0-D587-4C54-B5B4-C682E7A0AA3D Buffer=7FEEE000 Length=0xA
>  SetLockBoxAttributes: Guid=DEA652B0-D587-4C54-B5B4-C682E7A0AA3D Attributes=0x1
> @@ -1822,18 +1833,29 @@
>  InstallProtocolInterface: 5B1B31A1-9562-11D2-8E3F-00A0C969723B 7F0EBA00
>  Loading driver at 0x00010000000 EntryPoint=0x00010014790 bootmgfw.efi
>  InstallProtocolInterface: BC62157E-3E33-4FEC-9920-2D3B36D750DF 7F0B8898
> -RuntimeDriverSetVirtualAddressMap: 12 descriptors
> +RuntimeDriverSetVirtualAddressMap: 23 descriptors
>   # Memory Type  PhysicalStart 0x  VirtualStart 0x          Size 0x Attributes
>  -- ------------ ---------------- ---------------- ---------------- --------------------------------------
> - 0 RuntimeData  000000007EC21000 FFFFFFFFFF7E4000 0000000000005000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 1 RuntimeCode  000000007EC26000 FFFFFFFFFF7E9000 000000000000A000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 2 RuntimeData  000000007EC30000 FFFFFFFFFF7F3000 0000000000005000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 3 RuntimeCode  000000007EC35000 FFFFFFFFFF7F8000 0000000000008000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 4 RuntimeData  000000007EC60000 FFFFFFFFFF800000 0000000000005000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 5 RuntimeCode  000000007EC65000 FFFFFFFFFF805000 000000000000C000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 6 RuntimeData  000000007EC9E000 FFFFFFFFFF811000 00000000000D8000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 7 RuntimeCode  000000007ED76000 FFFFFFFFFF8E9000 00000000000A3000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 8 RuntimeCode  000000007FE99000 FFFFFFFFFF98C000 0000000000030000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> - 9 RuntimeData  000000007FEC9000 FFFFFFFFFF9BC000 0000000000024000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> -10 RuntimeData  000000007FFD0000 FFFFFFFFFF9E0000 0000000000020000 [UC|WC|WT|WB|   |  |  |  |  |  |  |RT]
> -11 RuntimeData  00000000FFE00000 FFFFFFFFFFA00000 0000000000200000 [UC|  |  |  |   |  |  |  |  |  |  |RT]
> + 0 RuntimeData  000000007EC21000 FFFFFFFFFF7E4000 0000000000006000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 1 RuntimeCode  000000007EC27000 FFFFFFFFFF7EA000 0000000000007000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> + 2 RuntimeData  000000007EC2E000 FFFFFFFFFF7F1000 0000000000007000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 3 RuntimeData  000000007EC35000 FFFFFFFFFF7F8000 0000000000001000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 4 RuntimeCode  000000007EC36000 FFFFFFFFFF7F9000 0000000000005000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> + 5 RuntimeData  000000007EC3B000 FFFFFFFFFF7FE000 0000000000002000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 6 RuntimeData  000000007EC60000 FFFFFFFFFF800000 0000000000006000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 7 RuntimeCode  000000007EC66000 FFFFFFFFFF806000 0000000000009000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> + 8 RuntimeData  000000007EC6F000 FFFFFFFFFF80F000 0000000000002000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> + 9 RuntimeData  000000007EC9E000 FFFFFFFFFF811000 00000000000D9000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +10 RuntimeCode  000000007ED77000 FFFFFFFFFF8EA000 0000000000097000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> +11 RuntimeData  000000007EE0E000 FFFFFFFFFF981000 000000000000B000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +12 RuntimeData  000000007FE99000 FFFFFFFFFF98C000 0000000000006000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +13 RuntimeCode  000000007FE9F000 FFFFFFFFFF992000 0000000000006000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> +14 RuntimeData  000000007FEA5000 FFFFFFFFFF998000 0000000000003000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +15 RuntimeCode  000000007FEA8000 FFFFFFFFFF99B000 0000000000007000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> +16 RuntimeData  000000007FEAF000 FFFFFFFFFF9A2000 0000000000003000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +17 RuntimeCode  000000007FEB2000 FFFFFFFFFF9A5000 0000000000009000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> +18 RuntimeData  000000007FEBB000 FFFFFFFFFF9AE000 0000000000003000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +19 RuntimeCode  000000007FEBE000 FFFFFFFFFF9B1000 0000000000009000 [UC|WC|WT|WB|   |  |  |  |RO|  |  |RT]
> +20 RuntimeData  000000007FEC7000 FFFFFFFFFF9BA000 0000000000026000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +21 RuntimeData  000000007FFD0000 FFFFFFFFFF9E0000 0000000000020000 [UC|WC|WT|WB|   |  |  |XP|  |  |  |RT]
> +22 RuntimeData  00000000FFE00000 FFFFFFFFFFA00000 0000000000200000 [UC|  |  |  |   |  |  |XP|  |  |  |RT]

Thanks
Laszlo

[1] https://github.com/tianocore/edk2/commit/ab081a50e5
[2] https://github.com/qemu/qemu/commit/81b2b81062
[3] http://news.gmane.org/find-root.php?message_id=%3C1443544141-26568-1-git-send-email-somlo-D+Gtc/HYRWM@public.gmane.org%3E
[4] http://thread.gmane.org/gmane.comp.bios.edk2.devel/2640
[5] http://people.redhat.com/~lersek/ovmf_prop_table/
