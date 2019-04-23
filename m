From: James Hilliard <james.hilliard1@gmail.com>
Subject: Re: [PATCH 8/8] fbdev/efifb: honour UEFI memory map attributes when
 mapping the fb
Date: Tue, 23 Apr 2019 14:21:23 +0200
Message-ID: <CADvTj4q5y0A_7VLYYvs-srnPk875e0S3W_OEsnsZFU75bjwOtQ@mail.gmail.com>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
 <20180711094040.12506-9-ard.biesheuvel@linaro.org> <CADvTj4rmxgxoJMR4ehZuhHHP3s2KCqO=Vp2igf3-ev_o=+_Duw@mail.gmail.com>
 <CAKv+Gu-tdB=2ep3MQY2iYteeupKhPHBzi6vouQhmmwy8bRfXDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-tdB=2ep3MQY2iYteeupKhPHBzi6vouQhmmwy8bRfXDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 23, 2019 at 8:50 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Sat, 20 Apr 2019 at 21:03, James Hilliard <james.hilliard1@gmail.com> wrote:
> >
> > This patch appears to introduce a regression on my
> > system(https://www.jetwaycomputer.com/NF9B.html).
> > My board uses an Intel gma3650 GPU.
> > It causes a complete failure of all video output.
> > With it reverted I get:
> > [ 1.169444] efifb: probing for efifb
> > [ 1.169499] efifb: framebuffer at 0xcf800000, using 1876k, total 1875k
> > [ 1.169511] efifb: mode is 800x600x32, linelength=3200, pages=1
> > [ 1.169519] efifb: scrolling: redraw
> > [ 1.169528] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> > Without it reverted I get:
> > [ 1.173368] efifb: probing for efifb
> > [ 1.173386] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
> > [ 1.173395] Trying to free nonexistent resource
> > <00000000cf800000-00000000cf9d4bff>
> > [ 1.173413] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5
> >
>
> Could you please reboot with efi=debug passed on the kernel command
> line and share the entire dmesg kernel log output?
[    0.000000] Linux version 5.0.7 (buildroot@james-x399) (gcc version
8.3.0 (Buildroot 2019.05-git-02152-gfec2e72139)) #1 SMP Tue Apr 23
06:00:01 MDT 2019
[    0.000000] Command line:
root=PARTUUID=bb5b7fe8-ef29-43f7-b7ac-79020523c726 rootwait
console=tty1 efi=debug
[    0.000000] Disabled fast string operations
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf32ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf330000-0x00000000cf377fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf378000-0x00000000cf388fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf389000-0x00000000cf390fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf391000-0x00000000cf3b5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf3b6000-0x00000000cf3b6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf3b7000-0x00000000cf3c6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf3c7000-0x00000000cf3d2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf3d3000-0x00000000cf3f7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf3f8000-0x00000000cf43afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf43b000-0x00000000cf5bafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf5bb000-0x00000000cf6e6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf6e7000-0x00000000cf6effff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf6f0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x021b4018-0x021c4057] usable ==> usable
[    0.000000] e820: update [mem 0x021b4018-0x021c4057] usable ==> usable
[    0.000000] e820: update [mem 0x021e6018-0x021f2857] usable ==> usable
[    0.000000] e820: update [mem 0x021e6018-0x021f2857] usable ==> usable
[    0.000000] e820: update [mem 0x021f3018-0x021ff857] usable ==> usable
[    0.000000] e820: update [mem 0x021f3018-0x021ff857] usable ==> usable
[    0.000000] e820: update [mem 0x020b8018-0x020c0057] usable ==> usable
[    0.000000] e820: update [mem 0x020b8018-0x020c0057] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem
0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem
0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] reserve setup_data: [mem
0x0000000000100000-0x00000000020b8017] usable
[    0.000000] reserve setup_data: [mem
0x00000000020b8018-0x00000000020c0057] usable
[    0.000000] reserve setup_data: [mem
0x00000000020c0058-0x00000000021b4017] usable
[    0.000000] reserve setup_data: [mem
0x00000000021b4018-0x00000000021c4057] usable
[    0.000000] reserve setup_data: [mem
0x00000000021c4058-0x00000000021e6017] usable
[    0.000000] reserve setup_data: [mem
0x00000000021e6018-0x00000000021f2857] usable
[    0.000000] reserve setup_data: [mem
0x00000000021f2858-0x00000000021f3017] usable
[    0.000000] reserve setup_data: [mem
0x00000000021f3018-0x00000000021ff857] usable
[    0.000000] reserve setup_data: [mem
0x00000000021ff858-0x00000000cf32ffff] usable
[    0.000000] reserve setup_data: [mem
0x00000000cf330000-0x00000000cf377fff] ACPI NVS
[    0.000000] reserve setup_data: [mem
0x00000000cf378000-0x00000000cf388fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000cf389000-0x00000000cf390fff] ACPI data
[    0.000000] reserve setup_data: [mem
0x00000000cf391000-0x00000000cf3b5fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000cf3b6000-0x00000000cf3b6fff] ACPI NVS
[    0.000000] reserve setup_data: [mem
0x00000000cf3b7000-0x00000000cf3c6fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000cf3c7000-0x00000000cf3d2fff] ACPI NVS
[    0.000000] reserve setup_data: [mem
0x00000000cf3d3000-0x00000000cf3f7fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000cf3f8000-0x00000000cf43afff] ACPI NVS
[    0.000000] reserve setup_data: [mem
0x00000000cf43b000-0x00000000cf5bafff] usable
[    0.000000] reserve setup_data: [mem
0x00000000cf5bb000-0x00000000cf6e6fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000cf6e7000-0x00000000cf6effff] usable
[    0.000000] reserve setup_data: [mem
0x00000000cf6f0000-0x00000000cfffffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000fed14000-0x00000000fed19fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000fed1c000-0x00000000fed8ffff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] reserve setup_data: [mem
0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem
0x0000000100000000-0x000000012fffffff] usable
[    0.000000] efi: EFI v2.00 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xcf389000  SMBIOS=0xf0480
ACPI=0xcf389000  MPS=0xfcb20
[    0.000000] efi: mem00: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000007fff] (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000000008000-0x000000000000cfff] (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000000d000-0x000000000006efff] (0MB)
[    0.000000] efi: mem03: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000006f000-0x000000000007ffff] (0MB)
[    0.000000] efi: mem04: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000000080000-0x000000000009ffff] (0MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000000ffffff] (15MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001000000-0x00000000010fffff] (1MB)
[    0.000000] efi: mem07: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001100000-0x00000000013d9fff] (2MB)
[    0.000000] efi: mem08: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013da000-0x00000000013defff] (0MB)
[    0.000000] efi: mem09: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013df000-0x00000000013eafff] (0MB)
[    0.000000] efi: mem10: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013eb000-0x00000000013ebfff] (0MB)
[    0.000000] efi: mem11: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013ec000-0x00000000013fcfff] (0MB)
[    0.000000] efi: mem12: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013fd000-0x00000000013fdfff] (0MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000013fe000-0x0000000001895fff] (4MB)
[    0.000000] efi: mem14: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001896000-0x0000000001897fff] (0MB)
[    0.000000] efi: mem15: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001898000-0x000000000189cfff] (0MB)
[    0.000000] efi: mem16: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000189d000-0x00000000018a6fff] (0MB)
[    0.000000] efi: mem17: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018a7000-0x00000000018a8fff] (0MB)
[    0.000000] efi: mem18: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018a9000-0x00000000018acfff] (0MB)
[    0.000000] efi: mem19: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018ad000-0x00000000018aefff] (0MB)
[    0.000000] efi: mem20: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018af000-0x00000000018affff] (0MB)
[    0.000000] efi: mem21: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018b0000-0x00000000018b1fff] (0MB)
[    0.000000] efi: mem22: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018b2000-0x00000000018b2fff] (0MB)
[    0.000000] efi: mem23: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018b3000-0x00000000018c4fff] (0MB)
[    0.000000] efi: mem24: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018c5000-0x00000000018cbfff] (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018cc000-0x00000000018cefff] (0MB)
[    0.000000] efi: mem26: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018cf000-0x00000000018d1fff] (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018d2000-0x00000000018d2fff] (0MB)
[    0.000000] efi: mem28: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018d3000-0x00000000018d3fff] (0MB)
[    0.000000] efi: mem29: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018d4000-0x00000000018dbfff] (0MB)
[    0.000000] efi: mem30: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018dc000-0x00000000018dcfff] (0MB)
[    0.000000] efi: mem31: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018dd000-0x00000000018dffff] (0MB)
[    0.000000] efi: mem32: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018e0000-0x00000000018e0fff] (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018e1000-0x00000000018e1fff] (0MB)
[    0.000000] efi: mem34: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018e2000-0x00000000018e7fff] (0MB)
[    0.000000] efi: mem35: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018e8000-0x00000000018effff] (0MB)
[    0.000000] efi: mem36: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018f0000-0x00000000018f1fff] (0MB)
[    0.000000] efi: mem37: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018f2000-0x00000000018f7fff] (0MB)
[    0.000000] efi: mem38: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018f8000-0x00000000018fafff] (0MB)
[    0.000000] efi: mem39: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018fb000-0x00000000018fdfff] (0MB)
[    0.000000] efi: mem40: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000018fe000-0x0000000001900fff] (0MB)
[    0.000000] efi: mem41: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001901000-0x0000000001904fff] (0MB)
[    0.000000] efi: mem42: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001905000-0x0000000001907fff] (0MB)
[    0.000000] efi: mem43: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001908000-0x000000000190afff] (0MB)
[    0.000000] efi: mem44: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190b000-0x000000000190bfff] (0MB)
[    0.000000] efi: mem45: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190c000-0x000000000190cfff] (0MB)
[    0.000000] efi: mem46: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190d000-0x000000000190efff] (0MB)
[    0.000000] efi: mem47: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190f000-0x000000000190ffff] (0MB)
[    0.000000] efi: mem48: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001910000-0x0000000001910fff] (0MB)
[    0.000000] efi: mem49: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001911000-0x0000000001911fff] (0MB)
[    0.000000] efi: mem50: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001912000-0x0000000001912fff] (0MB)
[    0.000000] efi: mem51: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001913000-0x000000000191dfff] (0MB)
[    0.000000] efi: mem52: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000191e000-0x0000000001920fff] (0MB)
[    0.000000] efi: mem53: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001921000-0x0000000001927fff] (0MB)
[    0.000000] efi: mem54: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001928000-0x0000000001928fff] (0MB)
[    0.000000] efi: mem55: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001929000-0x000000000192cfff] (0MB)
[    0.000000] efi: mem56: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000192d000-0x0000000001932fff] (0MB)
[    0.000000] efi: mem57: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001933000-0x0000000001935fff] (0MB)
[    0.000000] efi: mem58: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001936000-0x0000000001938fff] (0MB)
[    0.000000] efi: mem59: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001939000-0x000000000193cfff] (0MB)
[    0.000000] efi: mem60: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000193d000-0x0000000001949fff] (0MB)
[    0.000000] efi: mem61: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000194a000-0x0000000001952fff] (0MB)
[    0.000000] efi: mem62: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001953000-0x0000000001953fff] (0MB)
[    0.000000] efi: mem63: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001954000-0x000000000195cfff] (0MB)
[    0.000000] efi: mem64: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000195d000-0x0000000001968fff] (0MB)
[    0.000000] efi: mem65: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001969000-0x000000000196bfff] (0MB)
[    0.000000] efi: mem66: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000196c000-0x0000000001970fff] (0MB)
[    0.000000] efi: mem67: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001971000-0x0000000001972fff] (0MB)
[    0.000000] efi: mem68: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001973000-0x0000000001974fff] (0MB)
[    0.000000] efi: mem69: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001975000-0x0000000001976fff] (0MB)
[    0.000000] efi: mem70: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001977000-0x0000000001984fff] (0MB)
[    0.000000] efi: mem71: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001985000-0x0000000001a31fff] (0MB)
[    0.000000] efi: mem72: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a32000-0x0000000001a34fff] (0MB)
[    0.000000] efi: mem73: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a35000-0x0000000001a35fff] (0MB)
[    0.000000] efi: mem74: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a36000-0x0000000001a3cfff] (0MB)
[    0.000000] efi: mem75: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a3d000-0x0000000001a40fff] (0MB)
[    0.000000] efi: mem76: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a41000-0x0000000001a44fff] (0MB)
[    0.000000] efi: mem77: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a45000-0x0000000001a4efff] (0MB)
[    0.000000] efi: mem78: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a4f000-0x0000000001a56fff] (0MB)
[    0.000000] efi: mem79: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a57000-0x0000000001f18fff] (4MB)
[    0.000000] efi: mem80: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f19000-0x0000000001f1bfff] (0MB)
[    0.000000] efi: mem81: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f1c000-0x0000000001f28fff] (0MB)
[    0.000000] efi: mem82: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f29000-0x0000000001f29fff] (0MB)
[    0.000000] efi: mem83: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f2a000-0x0000000001f2afff] (0MB)
[    0.000000] efi: mem84: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f2b000-0x0000000001f30fff] (0MB)
[    0.000000] efi: mem85: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f31000-0x0000000001f3bfff] (0MB)
[    0.000000] efi: mem86: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f3c000-0x0000000001f61fff] (0MB)
[    0.000000] efi: mem87: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f62000-0x0000000001f63fff] (0MB)
[    0.000000] efi: mem88: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f64000-0x0000000001f65fff] (0MB)
[    0.000000] efi: mem89: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f66000-0x0000000001f66fff] (0MB)
[    0.000000] efi: mem90: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f67000-0x0000000001f6bfff] (0MB)
[    0.000000] efi: mem91: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f6c000-0x0000000001f6ffff] (0MB)
[    0.000000] efi: mem92: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f70000-0x0000000001f71fff] (0MB)
[    0.000000] efi: mem93: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f72000-0x0000000001f73fff] (0MB)
[    0.000000] efi: mem94: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f74000-0x0000000001f75fff] (0MB)
[    0.000000] efi: mem95: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f76000-0x0000000001f7cfff] (0MB)
[    0.000000] efi: mem96: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f7d000-0x0000000001f7efff] (0MB)
[    0.000000] efi: mem97: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f7f000-0x0000000001f8afff] (0MB)
[    0.000000] efi: mem98: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f8b000-0x0000000001f8dfff] (0MB)
[    0.000000] efi: mem99: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f8e000-0x0000000001f8ffff] (0MB)
[    0.000000] efi: mem100: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001f90000-0x0000000001f96fff] (0MB)
[    0.000000] efi: mem101: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001f97000-0x0000000001fb0fff] (0MB)
[    0.000000] efi: mem102: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fb1000-0x0000000001fbafff] (0MB)
[    0.000000] efi: mem103: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fbb000-0x0000000001fd5fff] (0MB)
[    0.000000] efi: mem104: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fd6000-0x0000000001fd8fff] (0MB)
[    0.000000] efi: mem105: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fd9000-0x0000000001fdafff] (0MB)
[    0.000000] efi: mem106: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fdb000-0x0000000001fdcfff] (0MB)
[    0.000000] efi: mem107: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fdd000-0x0000000001fddfff] (0MB)
[    0.000000] efi: mem108: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fde000-0x0000000001fdefff] (0MB)
[    0.000000] efi: mem109: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fdf000-0x0000000001ffdfff] (0MB)
[    0.000000] efi: mem110: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001ffe000-0x0000000001ffefff] (0MB)
[    0.000000] efi: mem111: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001fff000-0x0000000001ffffff] (0MB)
[    0.000000] efi: mem112: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002000000-0x000000000200efff] (0MB)
[    0.000000] efi: mem113: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000200f000-0x00000000020a5fff] (0MB)
[    0.000000] efi: mem114: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020a6000-0x00000000020acfff] (0MB)
[    0.000000] efi: mem115: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020ad000-0x00000000020affff] (0MB)
[    0.000000] efi: mem116: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020b0000-0x00000000020b1fff] (0MB)
[    0.000000] efi: mem117: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020b2000-0x00000000020b7fff] (0MB)
[    0.000000] efi: mem118: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020b8000-0x00000000020c0fff] (0MB)
[    0.000000] efi: mem119: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020c1000-0x00000000020c1fff] (0MB)
[    0.000000] efi: mem120: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000020c2000-0x00000000021b3fff] (0MB)
[    0.000000] efi: mem121: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000021b4000-0x00000000021cafff] (0MB)
[    0.000000] efi: mem122: [Loader Code        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000021cb000-0x00000000021e5fff] (0MB)
[    0.000000] efi: mem123: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000021e6000-0x00000000021fffff] (0MB)
[    0.000000] efi: mem124: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002200000-0x000000000221cfff] (0MB)
[    0.000000] efi: mem125: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000221d000-0x000000000223cfff] (0MB)
[    0.000000] efi: mem126: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000223d000-0x0000000002240fff] (0MB)
[    0.000000] efi: mem127: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002241000-0x000000000226afff] (0MB)
[    0.000000] efi: mem128: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000226b000-0x000000000243ffff] (1MB)
[    0.000000] efi: mem129: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002440000-0x0000000002614fff] (1MB)
[    0.000000] efi: mem130: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002615000-0x0000000002cbcfff] (6MB)
[    0.000000] efi: mem131: [Loader Code        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000002cbd000-0x0000000004cbcfff] (32MB)
[    0.000000] efi: mem132: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000004cbd000-0x0000000004dfffff] (1MB)
[    0.000000] efi: mem133: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000004e00000-0x0000000006dfffff] (32MB)
[    0.000000] efi: mem134: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000006e00000-0x00000000cf32efff]
(3205MB)
[    0.000000] efi: mem135: [Loader Data        |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf32f000-0x00000000cf32ffff] (0MB)
[    0.000000] efi: mem136: [ACPI Memory NVS    |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf330000-0x00000000cf377fff] (0MB)
[    0.000000] efi: mem137: [Reserved           |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf378000-0x00000000cf388fff] (0MB)
[    0.000000] efi: mem138: [ACPI Reclaim Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf389000-0x00000000cf390fff] (0MB)
[    0.000000] efi: mem139: [Reserved           |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf391000-0x00000000cf393fff] (0MB)
[    0.000000] efi: mem140: [Runtime Code       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf394000-0x00000000cf397fff] (0MB)
[    0.000000] efi: mem141: [Reserved           |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf398000-0x00000000cf3aafff] (0MB)
[    0.000000] efi: mem142: [Runtime Code       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3ab000-0x00000000cf3aefff] (0MB)
[    0.000000] efi: mem143: [Runtime Data       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3af000-0x00000000cf3affff] (0MB)
[    0.000000] efi: mem144: [Runtime Code       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3b0000-0x00000000cf3b4fff] (0MB)
[    0.000000] efi: mem145: [Runtime Data       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3b5000-0x00000000cf3b5fff] (0MB)
[    0.000000] efi: mem146: [ACPI Memory NVS    |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3b6000-0x00000000cf3b6fff] (0MB)
[    0.000000] efi: mem147: [Reserved           |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3b7000-0x00000000cf3c6fff] (0MB)
[    0.000000] efi: mem148: [ACPI Memory NVS    |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3c7000-0x00000000cf3d2fff] (0MB)
[    0.000000] efi: mem149: [Runtime Code       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3d3000-0x00000000cf3d4fff] (0MB)
[    0.000000] efi: mem150: [Runtime Data       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3d5000-0x00000000cf3e6fff] (0MB)
[    0.000000] efi: mem151: [Runtime Code       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3e7000-0x00000000cf3f4fff] (0MB)
[    0.000000] efi: mem152: [Runtime Data       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3f5000-0x00000000cf3f7fff] (0MB)
[    0.000000] efi: mem153: [ACPI Memory NVS    |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf3f8000-0x00000000cf43afff] (0MB)
[    0.000000] efi: mem154: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf43b000-0x00000000cf5b0fff] (1MB)
[    0.000000] efi: mem155: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf5b1000-0x00000000cf5b3fff] (0MB)
[    0.000000] efi: mem156: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf5b4000-0x00000000cf5bafff] (0MB)
[    0.000000] efi: mem157: [Runtime Data       |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf5bb000-0x00000000cf6e6fff] (1MB)
[    0.000000] efi: mem158: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000cf6e7000-0x00000000cf6effff] (0MB)
[    0.000000] efi: mem159: [Conventional Memory|   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000012fffffff]
(768MB)
[    0.000000] efi: mem160: [Reserved           |RUN|  |  |  |  |  |
|   |  |  |  |  ] range=[0x00000000000a0000-0x00000000000fffff] (0MB)
[    0.000000] efi: mem161: [Reserved           |RUN|  |  |  |  |  |
|   |  |  |  |  ] range=[0x00000000cf6f0000-0x00000000cfffffff] (9MB)
[    0.000000] efi: mem162: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000e0000000-0x00000000efffffff]
(256MB)
[    0.000000] efi: mem163: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000fec00000-0x00000000fec00fff] (0MB)
[    0.000000] efi: mem164: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000fed00000-0x00000000fed00fff] (0MB)
[    0.000000] efi: mem165: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000fed14000-0x00000000fed19fff] (0MB)
[    0.000000] efi: mem166: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed8ffff] (0MB)
[    0.000000] efi: mem167: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000fee00000-0x00000000fee00fff] (0MB)
[    0.000000] efi: mem168: [Memory Mapped I/O  |RUN|  |  |  |  |  |
|   |  |  |  |UC] range=[0x00000000ffe00000-0x00000000ffffffff] (2MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:  /, BIOS 4.6.4 11/19/2012
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1862.311 MHz processor
[    0.002142] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.002147] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.002171] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.002178] MTRR default type: uncachable
[    0.002179] MTRR fixed ranges enabled:
[    0.002182]   00000-9FFFF write-back
[    0.002184]   A0000-BFFFF uncachable
[    0.002186]   C0000-D7FFF write-protect
[    0.002188]   D8000-E7FFF uncachable
[    0.002190]   E8000-FFFFF write-protect
[    0.002191] MTRR variable ranges enabled:
[    0.002194]   0 base 000000000 mask F00000000 write-back
[    0.002197]   1 base 100000000 mask FE0000000 write-back
[    0.002199]   2 base 120000000 mask FF0000000 write-back
[    0.002202]   3 base 0CF700000 mask FFFF00000 write-through
[    0.002204]   4 base 0CF800000 mask FFF800000 uncachable
[    0.002206]   5 base 0D0000000 mask FF0000000 uncachable
[    0.002209]   6 base 0E0000000 mask FE0000000 uncachable
[    0.002419] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT
[    0.002556] last_pfn = 0xcf6f0 max_arch_pfn = 0x400000000
[    0.008429] found SMP MP-table at [mem 0x000fce60-0x000fce6f]
mapped at [(____ptrval____)]
[    0.008644] check: Scanning 1 areas for low memory corruption
[    0.008652] Base memory trampoline at [(____ptrval____)] 97000 size 24576
[    0.008661] BRK [0x36201000, 0x36201fff] PGTABLE
[    0.008665] BRK [0x36202000, 0x36202fff] PGTABLE
[    0.008667] BRK [0x36203000, 0x36203fff] PGTABLE
[    0.008784] BRK [0x36204000, 0x36204fff] PGTABLE
[    0.008791] BRK [0x36205000, 0x36205fff] PGTABLE
[    0.009808] BRK [0x36206000, 0x36206fff] PGTABLE
[    0.010065] BRK [0x36207000, 0x36207fff] PGTABLE
[    0.010412] Secure boot disabled
[    0.010421] ACPI: Early table checksum verification disabled
[    0.010431] ACPI: RSDP 0x00000000CF389000 000024 (v02 _     )
[    0.010439] ACPI: XSDT 0x00000000CF389068 00004C (v01 _      _
  01072009 AMI  00010013)
[    0.010451] ACPI: FACP 0x00000000CF390538 0000F4 (v04 _      _
  01072009 AMI  00010013)
[    0.010464] ACPI: DSDT 0x00000000CF389140 0073F2 (v02 _      _
  00000A03 INTL 20051117)
[    0.010473] ACPI: FACS 0x00000000CF3D0F80 000040
[    0.010479] ACPI: APIC 0x00000000CF390630 000072 (v03 _      _
  01072009 AMI  00010013)
[    0.010487] ACPI: MCFG 0x00000000CF3906A8 00003C (v01 _      _
  01072009 MSFT 00000097)
[    0.010496] ACPI: HPET 0x00000000CF3906E8 000038 (v01 _      _
  01072009 AMI. 00000004)
[    0.010504] ACPI: SSDT 0x00000000CF390720 000655 (v01 PmRef  CpuPm
  00003000 INTL 20051117)
[    0.010521] ACPI: Local APIC address 0xfee00000
[    0.010886] No NUMA configuration found
[    0.010890] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.010902] NODE_DATA(0) allocated [mem 0x12fff8000-0x12fffbfff]
[    0.010964] Zone ranges:
[    0.010967]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.010971]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.010975]   Normal   [mem 0x0000000100000000-0x000000012fffffff]
[    0.010978] Movable zone start for each node
[    0.010981] Early memory node ranges
[    0.010984]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.010987]   node   0: [mem 0x0000000000100000-0x00000000cf32ffff]
[    0.010990]   node   0: [mem 0x00000000cf43b000-0x00000000cf5bafff]
[    0.010993]   node   0: [mem 0x00000000cf6e7000-0x00000000cf6effff]
[    0.010996]   node   0: [mem 0x0000000100000000-0x000000012fffffff]
[    0.011135] Zeroed struct page in unavailable ranges: 2984 pages
[    0.011138] Initmem setup node 0 [mem 0x0000000000001000-0x000000012fffffff]
[    0.011144] On node 0 totalpages: 1045592
[    0.011146]   DMA zone: 64 pages used for memmap
[    0.011147]   DMA zone: 41 pages reserved
[    0.011149]   DMA zone: 3999 pages, LIFO batch:0
[    0.011431]   DMA32 zone: 13203 pages used for memmap
[    0.011433]   DMA32 zone: 844985 pages, LIFO batch:63
[    0.071381]   Normal zone: 3072 pages used for memmap
[    0.071383]   Normal zone: 196608 pages, LIFO batch:63
[    0.084915] ACPI: PM-Timer IO Port: 0x408
[    0.084921] ACPI: Local APIC address 0xfee00000
[    0.084933] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.084949] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.084954] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.084959] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.084963] ACPI: IRQ0 used by override.
[    0.084965] ACPI: IRQ9 used by override.
[    0.084969] Using ACPI (MADT) for SMP configuration information
[    0.084973] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.084985] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.085073] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.085080] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.085087] PM: Registered nosave memory: [mem 0x020b8000-0x020b8fff]
[    0.085094] PM: Registered nosave memory: [mem 0x020c0000-0x020c0fff]
[    0.085101] PM: Registered nosave memory: [mem 0x021b4000-0x021b4fff]
[    0.085109] PM: Registered nosave memory: [mem 0x021c4000-0x021c4fff]
[    0.085116] PM: Registered nosave memory: [mem 0x021e6000-0x021e6fff]
[    0.085123] PM: Registered nosave memory: [mem 0x021f2000-0x021f2fff]
[    0.085126] PM: Registered nosave memory: [mem 0x021f3000-0x021f3fff]
[    0.085133] PM: Registered nosave memory: [mem 0x021ff000-0x021fffff]
[    0.085141] PM: Registered nosave memory: [mem 0xcf330000-0xcf377fff]
[    0.085144] PM: Registered nosave memory: [mem 0xcf378000-0xcf388fff]
[    0.085146] PM: Registered nosave memory: [mem 0xcf389000-0xcf390fff]
[    0.085149] PM: Registered nosave memory: [mem 0xcf391000-0xcf3b5fff]
[    0.085152] PM: Registered nosave memory: [mem 0xcf3b6000-0xcf3b6fff]
[    0.085155] PM: Registered nosave memory: [mem 0xcf3b7000-0xcf3c6fff]
[    0.085158] PM: Registered nosave memory: [mem 0xcf3c7000-0xcf3d2fff]
[    0.085161] PM: Registered nosave memory: [mem 0xcf3d3000-0xcf3f7fff]
[    0.085163] PM: Registered nosave memory: [mem 0xcf3f8000-0xcf43afff]
[    0.085171] PM: Registered nosave memory: [mem 0xcf5bb000-0xcf6e6fff]
[    0.085178] PM: Registered nosave memory: [mem 0xcf6f0000-0xcfffffff]
[    0.085181] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.085184] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.085187] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.085190] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.085193] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.085196] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.085198] PM: Registered nosave memory: [mem 0xfed01000-0xfed13fff]
[    0.085201] PM: Registered nosave memory: [mem 0xfed14000-0xfed19fff]
[    0.085204] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.085207] PM: Registered nosave memory: [mem 0xfed1c000-0xfed8ffff]
[    0.085210] PM: Registered nosave memory: [mem 0xfed90000-0xfedfffff]
[    0.085212] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.085215] PM: Registered nosave memory: [mem 0xfee01000-0xffdfffff]
[    0.085218] PM: Registered nosave memory: [mem 0xffe00000-0xffffffff]
[    0.085223] [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.085236] clocksource: refined-jiffies: mask: 0xffffffff
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.520079] random: get_random_bytes called from
start_kernel+0x8a/0x475 with crng_init=0
[    0.520107] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64
nr_cpu_ids:4 nr_node_ids:1
[    0.523217] percpu: Embedded 44 pages/cpu @(____ptrval____) s139288
r8192 d32744 u524288
[    0.523245] pcpu-alloc: s139288 r8192 d32744 u524288 alloc=1*2097152
[    0.523248] pcpu-alloc: [0] 0 1 2 3
[    0.523330] Built 1 zonelists, mobility grouping on.  Total pages: 1029212
[    0.523334] Policy zone: Normal
[    0.523339] Kernel command line:
root=PARTUUID=bb5b7fe8-ef29-43f7-b7ac-79020523c726 rootwait
console=tty1 efi=debug
[    0.586910] Calgary: detecting Calgary via BIOS EBDA area
[    0.586914] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.670424] Memory: 4000176K/4182368K available (14340K kernel
code, 1367K rwdata, 3460K rodata, 1264K init, 1064K bss, 182192K
reserved, 0K cma-reserved)
[    0.670618] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.670856] rcu: Hierarchical RCU implementation.
[    0.670861] rcu:     RCU event tracing is enabled.
[    0.670865] rcu:     RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    0.670869] rcu: RCU calculated value of scheduler-enlistment delay
is 100 jiffies.
[    0.670872] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.671398] NR_IRQS: 4352, nr_irqs: 456, preallocated irqs: 16
[    0.671835] Console: colour dummy device 80x25
[    0.673844] printk: console [tty1] enabled
[    0.673894] ACPI: Core revision 20181213
[    0.674226] clocksource: hpet: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 133484882848 ns
[    0.674250] hpet clockevent registered
[    0.674259] APIC: Switch to symmetric I/O mode setup
[    0.674786] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.679261] clocksource: tsc-early: mask: 0xffffffffffffffff
max_cycles: 0x35b0313571d, max_idle_ns: 881590752934 ns
[    0.679288] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3724.62 BogoMIPS (lpj=1862311)
[    0.679301] pid_max: default: 32768 minimum: 301
[    0.679782] efi: EFI runtime memory map:
[    0.679797] efi: mem00: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000ffe00000-0x00000000ffffffff] (2MB)
[    0.679811] efi: mem01: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000fee00000-0x00000000fee00fff] (0MB)
[    0.679824] efi: mem02: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed8ffff] (0MB)
[    0.679837] efi: mem03: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000fed14000-0x00000000fed19fff] (0MB)
[    0.679851] efi: mem04: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000fed00000-0x00000000fed00fff] (0MB)
[    0.679864] efi: mem05: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000fec00000-0x00000000fec00fff] (0MB)
[    0.679877] efi: mem06: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |
  |  |  |  |UC] range=[0x00000000e0000000-0x00000000efffffff] (256MB)
[    0.679891] efi: mem07: [Reserved           |RUN|  |  |  |  |  |  |
  |  |  |  |  ] range=[0x00000000cf6f0000-0x00000000cfffffff] (9MB)
[    0.679904] efi: mem08: [Reserved           |RUN|  |  |  |  |  |  |
  |  |  |  |  ] range=[0x00000000000a0000-0x00000000000fffff] (0MB)
[    0.679918] efi: mem09: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf6e7000-0x00000000cf6effff] (0MB)
[    0.679931] efi: mem10: [Runtime Data       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf5bb000-0x00000000cf6e6fff] (1MB)
[    0.679944] efi: mem11: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf5b4000-0x00000000cf5bafff] (0MB)
[    0.679957] efi: mem12: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf5b1000-0x00000000cf5b3fff] (0MB)
[    0.679971] efi: mem13: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf43b000-0x00000000cf5b0fff] (1MB)
[    0.679984] efi: mem14: [Runtime Data       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3f5000-0x00000000cf3f7fff] (0MB)
[    0.679997] efi: mem15: [Runtime Code       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3e7000-0x00000000cf3f4fff] (0MB)
[    0.680010] efi: mem16: [Runtime Data       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3d5000-0x00000000cf3e6fff] (0MB)
[    0.680024] efi: mem17: [Runtime Code       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3d3000-0x00000000cf3d4fff] (0MB)
[    0.680037] efi: mem18: [Runtime Data       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3b5000-0x00000000cf3b5fff] (0MB)
[    0.680050] efi: mem19: [Runtime Code       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3b0000-0x00000000cf3b4fff] (0MB)
[    0.680063] efi: mem20: [Runtime Data       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3af000-0x00000000cf3affff] (0MB)
[    0.680076] efi: mem21: [Runtime Code       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf3ab000-0x00000000cf3aefff] (0MB)
[    0.680090] efi: mem22: [Runtime Code       |RUN|  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000cf394000-0x00000000cf397fff] (0MB)
[    0.680103] efi: mem23: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000002440000-0x0000000002614fff] (1MB)
[    0.680116] efi: mem24: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000002241000-0x000000000226afff] (0MB)
[    0.680129] efi: mem25: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000221d000-0x000000000223cfff] (0MB)
[    0.680142] efi: mem26: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000020c2000-0x00000000021b3fff] (0MB)
[    0.680155] efi: mem27: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000020b2000-0x00000000020b7fff] (0MB)
[    0.680168] efi: mem28: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000020ad000-0x00000000020affff] (0MB)
[    0.680182] efi: mem29: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x00000000020a6000-0x00000000020acfff] (0MB)
[    0.680195] efi: mem30: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000200f000-0x00000000020a5fff] (0MB)
[    0.680208] efi: mem31: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000002000000-0x000000000200efff] (0MB)
[    0.680221] efi: mem32: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fff000-0x0000000001ffffff] (0MB)
[    0.680234] efi: mem33: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fdf000-0x0000000001ffdfff] (0MB)
[    0.680247] efi: mem34: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fdb000-0x0000000001fdcfff] (0MB)
[    0.680282] efi: mem35: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fd9000-0x0000000001fdafff] (0MB)
[    0.680295] efi: mem36: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fd6000-0x0000000001fd8fff] (0MB)
[    0.680308] efi: mem37: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fbb000-0x0000000001fd5fff] (0MB)
[    0.680321] efi: mem38: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001fb1000-0x0000000001fbafff] (0MB)
[    0.680334] efi: mem39: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f97000-0x0000000001fb0fff] (0MB)
[    0.680347] efi: mem40: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f90000-0x0000000001f96fff] (0MB)
[    0.680361] efi: mem41: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f8e000-0x0000000001f8ffff] (0MB)
[    0.680374] efi: mem42: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f8b000-0x0000000001f8dfff] (0MB)
[    0.680387] efi: mem43: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f7f000-0x0000000001f8afff] (0MB)
[    0.680400] efi: mem44: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f7d000-0x0000000001f7efff] (0MB)
[    0.680413] efi: mem45: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f76000-0x0000000001f7cfff] (0MB)
[    0.680426] efi: mem46: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f74000-0x0000000001f75fff] (0MB)
[    0.680439] efi: mem47: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f72000-0x0000000001f73fff] (0MB)
[    0.680453] efi: mem48: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f70000-0x0000000001f71fff] (0MB)
[    0.680466] efi: mem49: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f6c000-0x0000000001f6ffff] (0MB)
[    0.680479] efi: mem50: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f67000-0x0000000001f6bfff] (0MB)
[    0.680492] efi: mem51: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f66000-0x0000000001f66fff] (0MB)
[    0.680505] efi: mem52: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f64000-0x0000000001f65fff] (0MB)
[    0.680518] efi: mem53: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f62000-0x0000000001f63fff] (0MB)
[    0.680531] efi: mem54: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f3c000-0x0000000001f61fff] (0MB)
[    0.680544] efi: mem55: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f31000-0x0000000001f3bfff] (0MB)
[    0.680558] efi: mem56: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f2b000-0x0000000001f30fff] (0MB)
[    0.680571] efi: mem57: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f2a000-0x0000000001f2afff] (0MB)
[    0.680584] efi: mem58: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f29000-0x0000000001f29fff] (0MB)
[    0.680597] efi: mem59: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f1c000-0x0000000001f28fff] (0MB)
[    0.680610] efi: mem60: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001f19000-0x0000000001f1bfff] (0MB)
[    0.680623] efi: mem61: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a57000-0x0000000001f18fff] (4MB)
[    0.680636] efi: mem62: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a4f000-0x0000000001a56fff] (0MB)
[    0.680650] efi: mem63: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a45000-0x0000000001a4efff] (0MB)
[    0.680663] efi: mem64: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a41000-0x0000000001a44fff] (0MB)
[    0.680676] efi: mem65: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a3d000-0x0000000001a40fff] (0MB)
[    0.680689] efi: mem66: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a36000-0x0000000001a3cfff] (0MB)
[    0.680702] efi: mem67: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a35000-0x0000000001a35fff] (0MB)
[    0.680715] efi: mem68: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001a32000-0x0000000001a34fff] (0MB)
[    0.680728] efi: mem69: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001985000-0x0000000001a31fff] (0MB)
[    0.680741] efi: mem70: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001977000-0x0000000001984fff] (0MB)
[    0.680755] efi: mem71: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001975000-0x0000000001976fff] (0MB)
[    0.680768] efi: mem72: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001973000-0x0000000001974fff] (0MB)
[    0.680781] efi: mem73: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001971000-0x0000000001972fff] (0MB)
[    0.680794] efi: mem74: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000196c000-0x0000000001970fff] (0MB)
[    0.680807] efi: mem75: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001969000-0x000000000196bfff] (0MB)
[    0.680820] efi: mem76: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000195d000-0x0000000001968fff] (0MB)
[    0.680833] efi: mem77: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001954000-0x000000000195cfff] (0MB)
[    0.680847] efi: mem78: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001953000-0x0000000001953fff] (0MB)
[    0.680860] efi: mem79: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000194a000-0x0000000001952fff] (0MB)
[    0.680873] efi: mem80: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000193d000-0x0000000001949fff] (0MB)
[    0.680886] efi: mem81: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001939000-0x000000000193cfff] (0MB)
[    0.680899] efi: mem82: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001936000-0x0000000001938fff] (0MB)
[    0.680912] efi: mem83: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001933000-0x0000000001935fff] (0MB)
[    0.680925] efi: mem84: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000192d000-0x0000000001932fff] (0MB)
[    0.680939] efi: mem85: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001929000-0x000000000192cfff] (0MB)
[    0.680952] efi: mem86: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001928000-0x0000000001928fff] (0MB)
[    0.680965] efi: mem87: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001921000-0x0000000001927fff] (0MB)
[    0.680978] efi: mem88: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000191e000-0x0000000001920fff] (0MB)
[    0.680991] efi: mem89: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001913000-0x000000000191dfff] (0MB)
[    0.681004] efi: mem90: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001912000-0x0000000001912fff] (0MB)
[    0.681017] efi: mem91: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001911000-0x0000000001911fff] (0MB)
[    0.681030] efi: mem92: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001910000-0x0000000001910fff] (0MB)
[    0.681044] efi: mem93: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190f000-0x000000000190ffff] (0MB)
[    0.681057] efi: mem94: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190d000-0x000000000190efff] (0MB)
[    0.681070] efi: mem95: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190c000-0x000000000190cfff] (0MB)
[    0.681083] efi: mem96: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x000000000190b000-0x000000000190bfff] (0MB)
[    0.681096] efi: mem97: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001908000-0x000000000190afff] (0MB)
[    0.681109] efi: mem98: [Boot Code          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001905000-0x0000000001907fff] (0MB)
[    0.681122] efi: mem99: [Boot Data          |   |  |  |  |  |  |  |
  |WB|WT|WC|UC] range=[0x0000000001901000-0x0000000001904fff] (0MB)
[    0.681136] efi: mem100: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018fe000-0x0000000001900fff] (0MB)
[    0.681149] efi: mem101: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018fb000-0x00000000018fdfff] (0MB)
[    0.681162] efi: mem102: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018f8000-0x00000000018fafff] (0MB)
[    0.681175] efi: mem103: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018f2000-0x00000000018f7fff] (0MB)
[    0.681188] efi: mem104: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018f0000-0x00000000018f1fff] (0MB)
[    0.681202] efi: mem105: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018e8000-0x00000000018effff] (0MB)
[    0.681215] efi: mem106: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018e2000-0x00000000018e7fff] (0MB)
[    0.681228] efi: mem107: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018e1000-0x00000000018e1fff] (0MB)
[    0.681241] efi: mem108: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018e0000-0x00000000018e0fff] (0MB)
[    0.681254] efi: mem109: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018dd000-0x00000000018dffff] (0MB)
[    0.681279] efi: mem110: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018dc000-0x00000000018dcfff] (0MB)
[    0.681293] efi: mem111: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018d4000-0x00000000018dbfff] (0MB)
[    0.681306] efi: mem112: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018d3000-0x00000000018d3fff] (0MB)
[    0.681319] efi: mem113: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018d2000-0x00000000018d2fff] (0MB)
[    0.681332] efi: mem114: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018cf000-0x00000000018d1fff] (0MB)
[    0.681346] efi: mem115: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018cc000-0x00000000018cefff] (0MB)
[    0.681359] efi: mem116: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018c5000-0x00000000018cbfff] (0MB)
[    0.681372] efi: mem117: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018b3000-0x00000000018c4fff] (0MB)
[    0.681385] efi: mem118: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018b2000-0x00000000018b2fff] (0MB)
[    0.681398] efi: mem119: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018b0000-0x00000000018b1fff] (0MB)
[    0.681412] efi: mem120: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018af000-0x00000000018affff] (0MB)
[    0.681425] efi: mem121: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018ad000-0x00000000018aefff] (0MB)
[    0.681438] efi: mem122: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018a9000-0x00000000018acfff] (0MB)
[    0.681451] efi: mem123: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000018a7000-0x00000000018a8fff] (0MB)
[    0.681464] efi: mem124: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000189d000-0x00000000018a6fff] (0MB)
[    0.681477] efi: mem125: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001898000-0x000000000189cfff] (0MB)
[    0.681491] efi: mem126: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001896000-0x0000000001897fff] (0MB)
[    0.681504] efi: mem127: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013fe000-0x0000000001895fff] (4MB)
[    0.681517] efi: mem128: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013fd000-0x00000000013fdfff] (0MB)
[    0.681530] efi: mem129: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013ec000-0x00000000013fcfff] (0MB)
[    0.681543] efi: mem130: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013eb000-0x00000000013ebfff] (0MB)
[    0.681557] efi: mem131: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013df000-0x00000000013eafff] (0MB)
[    0.681570] efi: mem132: [Boot Code          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x00000000013da000-0x00000000013defff] (0MB)
[    0.681583] efi: mem133: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000001100000-0x00000000013d9fff] (2MB)
[    0.681596] efi: mem134: [Boot Code          |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000000080000-0x000000000009ffff] (0MB)
[    0.681609] efi: mem135: [Boot Data          |   |  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x000000000006f000-0x000000000007ffff] (0MB)
[    0.681623] efi: mem136: [Boot Code          |RUN|  |  |  |  |  |
|   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000007fff] (0MB)
[    0.699886] LSM: Security Framework initializing
[    0.699901] SELinux:  Initializing.
[    0.703127] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.704762] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.704864] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.704911] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.705361] Disabled fast string operations
[    0.705386] mce: CPU supports 5 MCE banks
[    0.705409] mce: CPU0: Thermal monitoring enabled (TM1)
[    0.705418] process: using mwait in idle threads
[    0.705429] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.705436] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8, 1GB 0
[    0.705645] Freeing SMP alternatives memory: 40K
[    0.707271] smpboot: CPU0: Intel(R) Atom(TM) CPU D2550   @ 1.86GHz
(family: 0x6, model: 0x36, stepping: 0x1)
[    0.707271] Performance Events: PEBS fmt0+, Atom events, 8-deep
LBR, Intel PMU driver.
[    0.707271] ... version:                3
[    0.707271] ... bit width:              40
[    0.707271] ... generic registers:      2
[    0.707271] ... value mask:             000000ffffffffff
[    0.707271] ... max period:             000000007fffffff
[    0.707271] ... fixed-purpose events:   3
[    0.707271] ... event mask:             0000000700000003
[    0.707271] rcu: Hierarchical SRCU implementation.
[    0.707271] smp: Bringing up secondary CPUs ...
[    0.707388] x86: Booting SMP configuration:
[    0.707399] .... node  #0, CPUs:      #1
[    0.003513] Disabled fast string operations
[    0.708271] TSC synchronization [CPU#0 -> CPU#1]:
[    0.708271] Measured 3444 cycles TSC warp between CPUs, turning off
TSC clock.
[    0.708271] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.708558]  #2
[    0.003513] Disabled fast string operations
[    0.709528]  #3
[    0.003513] Disabled fast string operations
[    0.709650] smp: Brought up 1 node, 4 CPUs
[    0.709650] smpboot: Max logical packages: 1
[    0.709650] smpboot: Total of 4 processors activated (14898.48 BogoMIPS)
[    0.710883] devtmpfs: initialized
[    0.711613] PM: Registering ACPI NVS region [mem
0xcf330000-0xcf377fff] (294912 bytes)
[    0.711613] PM: Registering ACPI NVS region [mem
0xcf3b6000-0xcf3b6fff] (4096 bytes)
[    0.711613] PM: Registering ACPI NVS region [mem
0xcf3c7000-0xcf3d2fff] (49152 bytes)
[    0.711613] PM: Registering ACPI NVS region [mem
0xcf3f8000-0xcf43afff] (274432 bytes)
[    0.711626] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.711662] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.711744] kworker/u8:0 (31) used greatest stack depth: 14224 bytes left
[    0.712326] RTC time: 12:16:35, date: 2019-04-23
[    0.712553] NET: Registered protocol family 16
[    0.712848] audit: initializing netlink subsys (disabled)
[    0.712879] audit: type=2000 audit(1556021795.038:1):
state=initialized audit_enabled=0 res=1
[    0.713531] cpuidle: using governor menu
[    0.713582] ACPI: bus type PCI registered
[    0.714303] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.714303] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.714303] pmd_set_huge: Cannot satisfy [mem
0xe0000000-0xe0200000] with a huge-page mapping due to MTRR override.
[    0.714804] PCI: Using configuration type 1 for base access
[    0.734430] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.734632] ACPI: Added _OSI(Module Device)
[    0.734632] ACPI: Added _OSI(Processor Device)
[    0.734632] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.734632] ACPI: Added _OSI(Processor Aggregator Device)
[    0.734632] ACPI: Added _OSI(Linux-Dell-Video)
[    0.734632] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.734632] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.744003] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.747354] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.748062] ACPI: Dynamic OEM Table Load:
[    0.748084] ACPI: SSDT 0xFFFF9F6E2A610000 0006D5 (v01 PmRef
Cpu0Cst  00003001 INTL 20051117)
[    0.749314] ACPI: Dynamic OEM Table Load:
[    0.749329] ACPI: SSDT 0xFFFF9F6E2A8A63C0 00008D (v01 PmRef  ApCst
  00003000 INTL 20051117)
[    0.751741] ACPI: Interpreter enabled
[    0.751793] ACPI: (supports S0 S1 S4 S5)
[    0.751801] ACPI: Using IOAPIC for interrupt routing
[    0.751904] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.752658] ACPI: Enabled 12 GPEs in block 00 to 1F
[    0.775327] ACPI: Power Resource [FN00] (off)
[    0.777264] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.777289] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.777402] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.777800] PCI host bridge to bus 0000:00
[    0.777816] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.777829] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.777842] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff window]
[    0.777857] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff window]
[    0.777871] pci_bus 0000:00: root bus resource [mem
0x000e0000-0x000effff window]
[    0.777881] pci_bus 0000:00: root bus resource [mem
0x000f0000-0x000fffff window]
[    0.777891] pci_bus 0000:00: root bus resource [mem
0xcf800000-0xcfffffff window]
[    0.777901] pci_bus 0000:00: root bus resource [mem
0xd0000000-0xfebfffff window]
[    0.777911] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.777932] pci 0000:00:00.0: [8086:0bf3] type 00 class 0x060000
[    0.778281] pci 0000:00:02.0: [8086:0be2] type 00 class 0x030000
[    0.778281] pci 0000:00:02.0: reg 0x10: [mem 0xdfa00000-0xdfafffff]
[    0.778281] pci 0000:00:02.0: reg 0x14: [io  0xf0f0-0xf0f7]
[    0.778509] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.778541] pci 0000:00:1b.0: reg 0x10: [mem 0xdff00000-0xdff03fff 64bit]
[    0.778641] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.778869] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.779000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.779285] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.779363] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.779585] pci 0000:00:1c.2: [8086:27d4] type 01 class 0x060400
[    0.779709] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.779939] pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
[    0.780065] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.780326] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.780362] pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
[    0.780595] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.780661] pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
[    0.780901] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.780967] pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
[    0.781324] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.781324] pci 0000:00:1d.3: reg 0x20: [io  0xf020-0xf03f]
[    0.781514] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.781552] pci 0000:00:1d.7: reg 0x10: [mem 0xdff05000-0xdff053ff]
[    0.781665] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.781876] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.782327] pci 0000:00:1f.0: [8086:27bc] type 00 class 0x060100
[    0.782497] pci 0000:00:1f.2: [8086:27c0] type 00 class 0x01018f
[    0.782528] pci 0000:00:1f.2: reg 0x10: [io  0xf0e0-0xf0e7]
[    0.782543] pci 0000:00:1f.2: reg 0x14: [io  0xf0d0-0xf0d3]
[    0.782554] pci 0000:00:1f.2: reg 0x18: [io  0xf0c0-0xf0c7]
[    0.782567] pci 0000:00:1f.2: reg 0x1c: [io  0xf0b0-0xf0b3]
[    0.782578] pci 0000:00:1f.2: reg 0x20: [io  0xf0a0-0xf0af]
[    0.782591] pci 0000:00:1f.2: reg 0x24: [mem 0xdff04000-0xdff043ff]
[    0.782643] pci 0000:00:1f.2: PME# supported from D3hot
[    0.782842] pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
[    0.782910] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.783352] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.783397] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.783443] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.783486] pci 0000:02:00.0: reg 0x18: [mem 0xdfe04000-0xdfe04fff 64bit]
[    0.783509] pci 0000:02:00.0: reg 0x20: [mem 0xdfe00000-0xdfe03fff
64bit pref]
[    0.783648] pci 0000:02:00.0: supports D1 D2
[    0.783652] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.783879] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.783895] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.783903] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff]
[    0.784313] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.784313] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.784313] pci 0000:03:00.0: reg 0x18: [mem 0xdfd04000-0xdfd04fff 64bit]
[    0.784313] pci 0000:03:00.0: reg 0x20: [mem 0xdfd00000-0xdfd03fff
64bit pref]
[    0.784313] pci 0000:03:00.0: supports D1 D2
[    0.784313] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.784522] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.784541] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.784549] pci 0000:00:1c.2:   bridge window [mem 0xdfd00000-0xdfdfffff]
[    0.784666] pci 0000:04:00.0: [1b21:0612] type 00 class 0x010601
[    0.784711] pci 0000:04:00.0: reg 0x10: [io  0xc050-0xc057]
[    0.784732] pci 0000:04:00.0: reg 0x14: [io  0xc040-0xc043]
[    0.784751] pci 0000:04:00.0: reg 0x18: [io  0xc030-0xc037]
[    0.784768] pci 0000:04:00.0: reg 0x1c: [io  0xc020-0xc023]
[    0.784785] pci 0000:04:00.0: reg 0x20: [io  0xc000-0xc01f]
[    0.784804] pci 0000:04:00.0: reg 0x24: [mem 0xdfc00000-0xdfc001ff]
[    0.784955] pci 0000:04:00.0: 2.000 Gb/s available PCIe bandwidth,
limited by 2.5 GT/s x1 link at 0000:00:1c.3 (capable of 4.000 Gb/s
with 5 GT/s x1 link)
[    0.785273] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.785273] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.785273] pci 0000:00:1c.3:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    0.785273] pci_bus 0000:05: extended config space not accessible
[    0.785311] pci 0000:05:01.0: [9710:9865] type 00 class 0x070002
[    0.785311] pci 0000:05:01.0: reg 0x10: [io  0xb030-0xb037]
[    0.785311] pci 0000:05:01.0: reg 0x14: [mem 0xdfb05000-0xdfb05fff]
[    0.785339] pci 0000:05:01.0: reg 0x20: [mem 0xdfb04000-0xdfb04fff]
[    0.785410] pci 0000:05:01.0: supports D1 D2
[    0.785413] pci 0000:05:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.785538] pci 0000:05:01.1: [9710:9865] type 00 class 0x070002
[    0.785562] pci 0000:05:01.1: reg 0x10: [io  0xb020-0xb027]
[    0.785577] pci 0000:05:01.1: reg 0x14: [mem 0xdfb03000-0xdfb03fff]
[    0.785608] pci 0000:05:01.1: reg 0x20: [mem 0xdfb02000-0xdfb02fff]
[    0.785676] pci 0000:05:01.1: supports D1 D2
[    0.785680] pci 0000:05:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.785792] pci 0000:05:01.2: [ffff:9865] type 00 class 0x070103
[    0.785817] pci 0000:05:01.2: reg 0x10: [io  0xb010-0xb017]
[    0.785832] pci 0000:05:01.2: reg 0x14: [io  0xb000-0xb007]
[    0.785846] pci 0000:05:01.2: reg 0x18: [mem 0xdfb01000-0xdfb01fff]
[    0.785870] pci 0000:05:01.2: reg 0x20: [mem 0xdfb00000-0xdfb00fff]
[    0.785938] pci 0000:05:01.2: supports D1 D2
[    0.785942] pci 0000:05:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.786274] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.786274] pci 0000:00:1e.0:   bridge window [mem 0xdfb00000-0xdfbfffff]
[    0.786274] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7
window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff
window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0x000c0000-0x000dffff window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0x000e0000-0x000effff window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0x000f0000-0x000fffff window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0xcf800000-0xcfffffff window] (subtractive decode)
[    0.786274] pci 0000:00:1e.0:   bridge window [mem
0xd0000000-0xfebfffff window] (subtractive decode)
[    0.788504] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.788669] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    0.788829] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.788986] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.789140] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.789306] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.789463] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.789621] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    0.790552] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.790552] pci 0000:00:02.0: vgaarb: VGA device added:
decodes=io+mem,owns=io+mem,locks=none
[    0.790552] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.790552] vgaarb: loaded
[    0.790647] SCSI subsystem initialized
[    0.791390] libata version 3.00 loaded.
[    0.791614] ACPI: bus type USB registered
[    0.791737] usbcore: registered new interface driver usbfs
[    0.791799] usbcore: registered new interface driver hub
[    0.791895] usbcore: registered new device driver usb
[    0.791930] media: Linux media interface: v0.10
[    0.791930] videodev: Linux video capture interface: v2.00
[    0.791930] pps_core: LinuxPPS API ver. 1 registered
[    0.791930] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.791930] PTP clock support registered
[    0.792394] EDAC MC: Ver: 3.0.0
[    0.792711] Registered efivars operations
[    0.851555] Advanced Linux Sound Architecture Driver Initialized.
[    0.851743] PCI: Using ACPI for IRQ routing
[    0.860193] PCI: pci_cache_line_size set to 64 bytes
[    0.860291] e820: reserve RAM buffer [mem 0x020b8018-0x03ffffff]
[    0.860295] e820: reserve RAM buffer [mem 0x021b4018-0x03ffffff]
[    0.860298] e820: reserve RAM buffer [mem 0x021e6018-0x03ffffff]
[    0.860300] e820: reserve RAM buffer [mem 0x021f3018-0x03ffffff]
[    0.860303] e820: reserve RAM buffer [mem 0xcf330000-0xcfffffff]
[    0.860306] e820: reserve RAM buffer [mem 0xcf5bb000-0xcfffffff]
[    0.860309] e820: reserve RAM buffer [mem 0xcf6f0000-0xcfffffff]
[    0.860693] NetLabel: Initializing
[    0.860703] NetLabel:  domain hash size = 128
[    0.860708] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.860747] NetLabel:  unlabeled traffic allowed by default
[    0.861278] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.861278] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.863324] clocksource: Switched to clocksource hpet
[    1.109608] VFS: Disk quotas dquot_6.6.0
[    1.109659] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.109792] pnp: PnP ACPI init
[    1.110200] system 00:00: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.110231] system 00:00: Plug and Play ACPI device, IDs PNP0103
PNP0c01 (active)
[    1.110406] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.110417] system 00:01: [io  0xffff] has been reserved
[    1.110426] system 00:01: [io  0xffff] has been reserved
[    1.110434] system 00:01: [io  0xffff] has been reserved
[    1.110443] system 00:01: [io  0x0400-0x047f] has been reserved
[    1.110451] system 00:01: [io  0x0500-0x057f] has been reserved
[    1.110459] system 00:01: [io  0x0600-0x061f] has been reserved
[    1.110479] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.110615] system 00:02: [io  0x06a0-0x06af] has been reserved
[    1.110625] system 00:02: [io  0x06b0-0x06ef] has been reserved
[    1.110649] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.110727] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.111090] system 00:04: [io  0x0a00-0x0a1f] has been reserved
[    1.111101] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    1.111124] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.111247] pnp 00:05: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    1.111420] pnp 00:06: Plug and Play ACPI device, IDs PNP0f03
PNP0f13 (active)
[    1.112058] pnp 00:07: [dma 3]
[    1.112322] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.112798] pnp 00:08: [dma 0 disabled]
[    1.112925] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.113418] pnp 00:09: [dma 0 disabled]
[    1.113535] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.113692] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.114224] ACPI: IRQ 10 override to edge, high
[    1.114243] pnp 00:0b: [dma 0 disabled]
[    1.114432] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.114894] ACPI: IRQ 10 override to edge, high
[    1.114907] pnp 00:0c: [dma 0 disabled]
[    1.115066] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.115545] ACPI: IRQ 10 override to edge, high
[    1.115557] pnp 00:0d: [dma 0 disabled]
[    1.115713] pnp 00:0d: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.116170] ACPI: IRQ 10 override to edge, high
[    1.116182] pnp 00:0e: [dma 0 disabled]
[    1.116358] pnp 00:0e: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.116515] system 00:0f: [io  0x04d0-0x04d1] has been reserved
[    1.116544] system 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.116823] system 00:10: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.116835] system 00:10: [mem 0x00000000-0x00003fff] could not be reserved
[    1.116845] system 00:10: [mem 0x00000000-0x00000fff] could not be reserved
[    1.116854] system 00:10: [mem 0x00000000-0x00000fff] could not be reserved
[    1.116863] system 00:10: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.116886] system 00:10: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.117385] system 00:11: [mem 0xfed14000-0xfed19fff] has been reserved
[    1.117397] system 00:11: [mem 0xe0000000-0xefffffff] has been reserved
[    1.117420] system 00:11: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.117796] system 00:12: [io  0x0400-0x047f] has been reserved
[    1.117807] system 00:12: [io  0x0500-0x053f] has been reserved
[    1.117817] system 00:12: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.117826] system 00:12: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.117835] system 00:12: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.117844] system 00:12: [mem 0xfed20000-0xfed8ffff] could not be reserved
[    1.117853] system 00:12: [mem 0xffe00000-0xffffffff] has been reserved
[    1.117873] system 00:12: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.117879] pnp: PnP ACPI: found 19 devices
[    1.129338] clocksource: acpi_pm: mask: 0xffffff max_cycles:
0xffffff, max_idle_ns: 2085701024 ns
[    1.129379] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
[bus 01] add_size 1000
[    1.129385] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
add_align 100000
[    1.129395] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff] to [bus 01] add_size 200000 add_align 100000
[    1.129409] pci 0000:00:1c.1: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
add_align 100000
[    1.129423] pci 0000:00:1c.2: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
add_align 100000
[    1.129436] pci 0000:00:1c.3: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
add_align 100000
[    1.129470] pci 0000:00:1c.0: BAR 8: assigned [mem 0xd0000000-0xd01fffff]
[    1.129491] pci 0000:00:1c.0: BAR 9: assigned [mem
0xd0200000-0xd03fffff 64bit pref]
[    1.129510] pci 0000:00:1c.1: BAR 9: assigned [mem
0xd0400000-0xd05fffff 64bit pref]
[    1.129529] pci 0000:00:1c.2: BAR 9: assigned [mem
0xd0600000-0xd07fffff 64bit pref]
[    1.129548] pci 0000:00:1c.3: BAR 9: assigned [mem
0xd0800000-0xd09fffff 64bit pref]
[    1.129560] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    1.129571] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.129581] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.129592] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff]
[    1.129603] pci 0000:00:1c.0:   bridge window [mem
0xd0200000-0xd03fffff 64bit pref]
[    1.129617] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    1.129626] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    1.129638] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff]
[    1.129648] pci 0000:00:1c.1:   bridge window [mem
0xd0400000-0xd05fffff 64bit pref]
[    1.129662] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    1.129671] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    1.129682] pci 0000:00:1c.2:   bridge window [mem 0xdfd00000-0xdfdfffff]
[    1.129693] pci 0000:00:1c.2:   bridge window [mem
0xd0600000-0xd07fffff 64bit pref]
[    1.129707] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    1.129715] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    1.129726] pci 0000:00:1c.3:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    1.129737] pci 0000:00:1c.3:   bridge window [mem
0xd0800000-0xd09fffff 64bit pref]
[    1.129753] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    1.129761] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    1.129773] pci 0000:00:1e.0:   bridge window [mem 0xdfb00000-0xdfbfffff]
[    1.129790] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.129793] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.129797] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.129800] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff window]
[    1.129804] pci_bus 0000:00: resource 8 [mem 0x000e0000-0x000effff window]
[    1.129807] pci_bus 0000:00: resource 9 [mem 0x000f0000-0x000fffff window]
[    1.129811] pci_bus 0000:00: resource 10 [mem 0xcf800000-0xcfffffff window]
[    1.129814] pci_bus 0000:00: resource 11 [mem 0xd0000000-0xfebfffff window]
[    1.129818] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    1.129821] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd01fffff]
[    1.129825] pci_bus 0000:01: resource 2 [mem 0xd0200000-0xd03fffff
64bit pref]
[    1.129828] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    1.129831] pci_bus 0000:02: resource 1 [mem 0xdfe00000-0xdfefffff]
[    1.129835] pci_bus 0000:02: resource 2 [mem 0xd0400000-0xd05fffff
64bit pref]
[    1.129838] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.129842] pci_bus 0000:03: resource 1 [mem 0xdfd00000-0xdfdfffff]
[    1.129845] pci_bus 0000:03: resource 2 [mem 0xd0600000-0xd07fffff
64bit pref]
[    1.129849] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    1.129852] pci_bus 0000:04: resource 1 [mem 0xdfc00000-0xdfcfffff]
[    1.129855] pci_bus 0000:04: resource 2 [mem 0xd0800000-0xd09fffff
64bit pref]
[    1.129859] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    1.129862] pci_bus 0000:05: resource 1 [mem 0xdfb00000-0xdfbfffff]
[    1.129866] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7 window]
[    1.129869] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff window]
[    1.129873] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.129876] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff window]
[    1.129880] pci_bus 0000:05: resource 8 [mem 0x000e0000-0x000effff window]
[    1.129883] pci_bus 0000:05: resource 9 [mem 0x000f0000-0x000fffff window]
[    1.129887] pci_bus 0000:05: resource 10 [mem 0xcf800000-0xcfffffff window]
[    1.129890] pci_bus 0000:05: resource 11 [mem 0xd0000000-0xfebfffff window]
[    1.130096] NET: Registered protocol family 2
[    1.130492] tcp_listen_portaddr_hash hash table entries: 2048
(order: 3, 32768 bytes)
[    1.130557] TCP established hash table entries: 32768 (order: 6,
262144 bytes)
[    1.130786] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.131091] TCP: Hash tables configured (established 32768 bind 32768)
[    1.131281] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.131398] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.131579] NET: Registered protocol family 1
[    1.131982] RPC: Registered named UNIX socket transport module.
[    1.131994] RPC: Registered udp transport module.
[    1.131999] RPC: Registered tcp transport module.
[    1.132005] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.132419] pci 0000:00:02.0: Video device with shadowed ROM at
[mem 0x000c0000-0x000dffff]
[    1.159423] pci 0000:00:1d.7: quirk_usb_early_handoff+0x0/0x67e
took 25405 usecs
[    1.159486] PCI: CLS 64 bytes, default 64
[    1.159611] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.159621] software IO TLB: mapped [mem 0xcb330000-0xcf330000] (64MB)
[    1.161198] check: Scanning for low memory corruption every 60 seconds
[    1.162861] Initialise system trusted keyrings
[    1.163041] workingset: timestamp_bits=56 max_order=20 bucket_order=0
[    1.171650] NFS: Registering the id_resolver key type
[    1.171679] Key type id_resolver registered
[    1.171686] Key type id_legacy registered
[    1.171697] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.177975] Key type asymmetric registered
[    1.177988] Asymmetric key parser 'x509' registered
[    1.178030] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 249)
[    1.178046] io scheduler mq-deadline registered
[    1.178055] io scheduler kyber registered
[    1.179468] efifb: probing for efifb
[    1.179491] efifb: abort, cannot remap video memory 0x1d5000 @ 0xcf800000
[    1.179504] Trying to free nonexistent resource
<00000000cf800000-00000000cf9d4bff>
[    1.179527] efi-framebuffer: probe of efi-framebuffer.0 failed with error -5
[    1.179772] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.179848] ACPI: Power Button [PWRB]
[    1.179984] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    1.180012] ACPI: Sleep Button [SLPB]
[    1.180116] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.180158] ACPI: Power Button [PWRF]
[    1.181591] Monitor-Mwait will be used to enter C-1 state
[    1.184237] thermal LNXTHERM:00: registered as thermal_zone0
[    1.184250] ACPI: Thermal Zone [THRM] (30 C)
[    1.184599] thermal LNXTHERM:01: registered as thermal_zone1
[    1.184610] ACPI: Thermal Zone [TZ00] (27 C)
[    1.185423] thermal LNXTHERM:02: registered as thermal_zone2
[    1.185433] ACPI: Thermal Zone [TZ01] (27 C)
[    1.185705] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.206526] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    1.227386] 00:09: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200)
is a 16550A
[    1.248234] 00:0b: ttyS2 at I/O 0x4e0 (irq = 10, base_baud =
115200) is a 16550A
[    1.269070] 00:0c: ttyS3 at I/O 0x4e8 (irq = 10, base_baud =
115200) is a 16550A
[    1.269624] serial 0000:05:01.0: enabling device (0000 -> 0003)
[    1.269818] serial 0000:05:01.0: Couldn't register serial port
b030, irq 17, type 0, error -28
[    1.269884] serial 0000:05:01.1: enabling device (0000 -> 0003)
[    1.270050] serial 0000:05:01.1: Couldn't register serial port
b020, irq 18, type 0, error -28
[    1.270830] Non-volatile memory driver v1.3
[    1.271021] Linux agpgart interface v0.103
[    1.277537] loop: module loaded
[    1.277699] ACPI Warning: SystemIO range
0x0000000000000428-0x000000000000042F conflicts with OpRegion
0x0000000000000400-0x000000000000042F (\SWC1) (20181213/utaddress-213)
[    1.277724] ACPI Warning: SystemIO range
0x0000000000000428-0x000000000000042F conflicts with OpRegion
0x0000000000000400-0x000000000000047F (\PMIO) (20181213/utaddress-213)
[    1.277744] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    1.277755] ACPI Warning: SystemIO range
0x0000000000000530-0x000000000000053F conflicts with OpRegion
0x0000000000000500-0x000000000000053B (\GPIO) (20181213/utaddress-213)
[    1.277773] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    1.277783] ACPI Warning: SystemIO range
0x0000000000000500-0x000000000000052F conflicts with OpRegion
0x0000000000000500-0x000000000000053B (\GPIO) (20181213/utaddress-213)
[    1.277800] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    1.277809] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.278202] ahci 0000:04:00.0: version 3.0
[    1.278541] ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
[    1.278604] ahci 0000:04:00.0: AHCI 0001.0200 32 slots 2 ports 6
Gbps 0x3 impl SATA mode
[    1.278616] ahci 0000:04:00.0: flags: 64bit ncq sntf stag led clo
pmp pio slum part ccc sxs
[    1.279538] scsi host0: ahci
[    1.280037] scsi host1: ahci
[    1.280348] ata1: SATA max UDMA/133 abar m512@0xdfc00000 port
0xdfc00100 irq 24
[    1.280373] ata2: SATA max UDMA/133 abar m512@0xdfc00000 port
0xdfc00180 irq 24
[    1.280534] ata_piix 0000:00:1f.2: version 2.13
[    1.280693] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.434375] scsi host2: ata_piix
[    1.434709] scsi host3: ata_piix
[    1.434859] ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 19
[    1.434875] ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 19
[    1.435539] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.435558] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.435626] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.435642] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.435716] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.435727] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.435804] sky2: driver version 1.30
[    1.437050] libphy: r8169: probed
[    1.437676] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl,
00:30:18:04:2c:09, XID 2c9, IRQ 25
[    1.437696] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    1.438729] libphy: r8169: probed
[    1.439410] r8169 0000:03:00.0 eth1: RTL8168evl/8111evl,
00:30:18:04:2c:08, XID 2c9, IRQ 26
[    1.439424] r8169 0000:03:00.0 eth1: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    1.439817] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.439831] ehci-pci: EHCI PCI platform driver
[    1.440087] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.440264] ehci-pci 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    1.440326] ehci-pci 0000:00:1d.7: debug port 1
[    1.444251] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    1.444299] ehci-pci 0000:00:1d.7: irq 23, io mem 0xdff05000
[    1.451302] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.451404] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 5.00
[    1.451416] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.451425] usb usb1: Product: EHCI Host Controller
[    1.451432] usb usb1: Manufacturer: Linux 5.0.7 ehci_hcd
[    1.451439] usb usb1: SerialNumber: 0000:00:1d.7
[    1.451770] hub 1-0:1.0: USB hub found
[    1.451797] hub 1-0:1.0: 8 ports detected
[    1.452463] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.452498] ohci-pci: OHCI PCI platform driver
[    1.452582] uhci_hcd: USB Universal Host Controller Interface driver
[    1.452771] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.452926] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    1.452978] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[    1.453105] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0001, bcdDevice= 5.00
[    1.453117] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.453126] usb usb2: Product: UHCI Host Controller
[    1.453133] usb usb2: Manufacturer: Linux 5.0.7 uhci_hcd
[    1.453140] usb usb2: SerialNumber: 0000:00:1d.0
[    1.453481] hub 2-0:1.0: USB hub found
[    1.453508] hub 2-0:1.0: 2 ports detected
[    1.453998] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.454141] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    1.454191] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[    1.454345] usb usb3: New USB device found, idVendor=1d6b,
idProduct=0001, bcdDevice= 5.00
[    1.454357] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.454366] usb usb3: Product: UHCI Host Controller
[    1.454373] usb usb3: Manufacturer: Linux 5.0.7 uhci_hcd
[    1.454380] usb usb3: SerialNumber: 0000:00:1d.1
[    1.454692] hub 3-0:1.0: USB hub found
[    1.454719] hub 3-0:1.0: 2 ports detected
[    1.455146] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.455309] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    1.455385] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[    1.455512] usb usb4: New USB device found, idVendor=1d6b,
idProduct=0001, bcdDevice= 5.00
[    1.455524] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.455533] usb usb4: Product: UHCI Host Controller
[    1.455540] usb usb4: Manufacturer: Linux 5.0.7 uhci_hcd
[    1.455547] usb usb4: SerialNumber: 0000:00:1d.2
[    1.455847] hub 4-0:1.0: USB hub found
[    1.455878] hub 4-0:1.0: 2 ports detected
[    1.456344] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.456493] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    1.456565] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020
[    1.456695] usb usb5: New USB device found, idVendor=1d6b,
idProduct=0001, bcdDevice= 5.00
[    1.456707] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.456715] usb usb5: Product: UHCI Host Controller
[    1.456723] usb usb5: Manufacturer: Linux 5.0.7 uhci_hcd
[    1.456730] usb usb5: SerialNumber: 0000:00:1d.3
[    1.457025] hub 5-0:1.0: USB hub found
[    1.457049] hub 5-0:1.0: 2 ports detected
[    1.457585] usbcore: registered new interface driver usblp
[    1.457678] usbcore: registered new interface driver usb-storage
[    1.457767] usbcore: registered new interface driver ftdi_sio
[    1.457806] usbserial: USB Serial support registered for FTDI USB
Serial Device
[    1.458044] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    1.458550] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.458649] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.459572] usbcore: registered new interface driver usbtouchscreen
[    1.459644] rtc_cmos 00:03: RTC can wake from S4
[    1.459923] rtc_cmos 00:03: registered as rtc0
[    1.460006] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    1.460194] i801_smbus 0000:00:1f.3: enabling device (0000 -> 0001)
[    1.460483] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    1.463133] usbcore: registered new interface driver uvcvideo
[    1.463150] USB Video Class driver (1.1.1)
[    1.463713] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03)
initialised: dm-devel@redhat.com
[    1.463811] EFI Variables Facility v0.08 2004-May-17
[    1.526761] hidraw: raw HID events driver (C) Jiri Kosina
[    1.527590] usbcore: registered new interface driver usbhid
[    1.527610] usbhid: USB HID core driver
[    1.528315] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    1.529710] Initializing XFRM netlink socket
[    1.530235] NET: Registered protocol family 10
[    1.530884] Segment Routing with IPv6
[    1.531125] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    1.531641] NET: Registered protocol family 17
[    1.531702] Key type dns_resolver registered
[    1.532440] microcode: sig=0x30661, pf=0x4, revision=0x10d
[    1.536618] hdaudio hdaudioC0D0: Unable to bind the codec
[    1.537095] hdaudio hdaudioC0D1: Unable to bind the codec
[    1.537114] microcode: Microcode Update Driver: v2.2.
[    1.537661] registered taskstats version 1
[    1.537679] Loading compiled-in X.509 certificates
[    1.546062] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.546554] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    1.546775] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.546787] [drm] No driver support for vblank timestamp query.
[    1.745326] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.745989] ata1.00: ATA-9: WDC WD5000LPLX-00ZNTT0, 01.01A01, max UDMA/133
[    1.746002] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    1.746714] ata1.00: configured for UDMA/133
[    1.747103] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD5000LPLX-0 1A01 PQ: 0 ANSI: 5
[    1.747758] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.747906] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
(500 GB/466 GiB)
[    1.747928] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.747977] sd 0:0:0:0: [sda] Write Protect is off
[    1.747990] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.748068] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.771300] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.901365] usb 1-1: New USB device found, idVendor=13fe,
idProduct=6300, bcdDevice= 1.10
[    1.901378] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.901386] usb 1-1: Product: USB DISK 3.0
[    1.901393] usb 1-1: Manufacturer:
[    1.901400] usb 1-1: SerialNumber: 070A91367166D270
[    1.901819] usb-storage 1-1:1.0: USB Mass Storage device detected
[    1.902093] scsi host4: usb-storage 1-1:1.0
[    1.993854] [drm] Initialized gma500 1.0.0 20140314 for
0000:00:02.0 on minor 0
[    1.993984]   Magic number: 15:706:279
[    1.994033] usb usb1-port7: hash matches
[    1.994082] event_source tracepoint: hash matches
[    1.994117] tty tty16: hash matches
[    1.994214] printk: console [netcon0] enabled
[    1.994221] netconsole: network logging started
[    1.994566] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[    1.996584] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    1.996606] Unstable clock detected, switching default tracing
clock to "global"
               If you want to keep using the local clock, then add:
                 "trace_clock=local"
               on the kernel command line
[    1.996715] platform regulatory.0: Direct firmware load for
regulatory.db failed with error -2
[    1.996735] cfg80211: failed to load regulatory.db
[    1.996774] ALSA device list:
[    1.996782]   No soundcards found.
[    2.054637] ata2: SATA link down (SStatus 0 SControl 300)
[    2.111965]  sda: sda1 sda2 sda3
[    2.112601] kworker/u8:0 (1407) used greatest stack depth: 13920 bytes left
[    2.113161] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.113216] md: Waiting for all devices to be available before autodetect
[    2.113224] md: If you don't use raid, use raid=noautodetect
[    2.113681] md: Autodetecting RAID arrays.
[    2.113692] md: autorun ...
[    2.113696] md: ... autorun DONE.
[    2.113733] Waiting for root device
PARTUUID=bb5b7fe8-ef29-43f7-b7ac-79020523c726...
[    2.946411] scsi 4:0:0:0: Direct-Access              USB DISK 3.0
  PMAP PQ: 0 ANSI: 6
[    2.946926] sd 4:0:0:0: Attached scsi generic sg1 type 0
[    2.947646] sd 4:0:0:0: [sdb] 241827840 512-byte logical blocks:
(124 GB/115 GiB)
[    2.948504] sd 4:0:0:0: [sdb] Write Protect is off
[    2.948514] sd 4:0:0:0: [sdb] Mode Sense: 45 00 00 00
[    2.949254] sd 4:0:0:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    2.951726] random: fast init done
[    5.791390] Alternate GPT is invalid, using primary GPT.
[    5.791423]  sdb: sdb1 sdb2
[    5.794261] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    5.801997] EXT4-fs (sdb2): mounted filesystem with ordered data
mode. Opts: (null)
[    5.802034] VFS: Mounted root (ext4 filesystem) readonly on device 8:18.
[    5.803787] devtmpfs: mounted
[    5.804746] Freeing unused kernel image memory: 1264K
[    5.813308] Write protecting the kernel read-only data: 20480k
[    5.815255] Freeing unused kernel image memory: 2008K
[    5.815898] Freeing unused kernel image memory: 636K
[    5.815949] Run /sbin/init as init process
[    6.158806] modprobe (1429) used greatest stack depth: 13336 bytes left
[    6.825441] systemd[1]: systemd 241 running in system mode. (-PAM
-AUDIT -SELINUX -IMA -APPARMOR -SMACK +SYSVINIT +UTMP -LIBCRYPTSETUP
+GCRYPT -GNUTLS -ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN2
-IDN -PCRE2 default-hierarchy=hybrid)
[    6.837452] systemd[1]: Detected architecture x86-64.
[    6.841189] systemd[1]: Set hostname to <buildroot>.
[    6.847174] random: systemd: uninitialized urandom read (16 bytes read)
[    6.847221] systemd[1]: Initializing machine ID from random generator.
[    6.847373] systemd[1]: Installed transient /etc/machine-id file.
[    7.370745] systemd[1]:
/usr/lib/systemd/system/rpc-statd.service:13: PIDFile= references path
below legacy directory /var/run/, updating /var/run/rpc.statd.pid
\xe2\x86\x92 /run/rpc.statd.pid; please update the unit file
accordingly.
[    7.478704] random: systemd: uninitialized urandom read (16 bytes read)
[    7.484759] random: systemd: uninitialized urandom read (16 bytes read)
[    7.485151] systemd[1]: Listening on udev Control Socket.
[    7.485870] systemd[1]: Listening on initctl Compatibility Named Pipe.
[    7.486878] systemd[1]: Created slice system-getty.slice.
[    7.487520] systemd[1]: Listening on Journal Socket (/dev/log).
[    7.522245] mount (1442) used greatest stack depth: 13272 bytes left
[    7.522446] mount (1441) used greatest stack depth: 13200 bytes left
[    7.599860] systemd-tmpfile (1446) used greatest stack depth: 13152
bytes left
[    7.688501] EXT4-fs (sdb2): re-mounted. Opts: (null)
[    7.856094] random: crng init done
[    7.856117] random: 7 urandom warning(s) missed due to ratelimiting
[    7.887102] systemd-journald[1444]: Received request to flush
runtime journal from PID 1
[   12.496576] r8169 0000:02:00.0 enp2s0: renamed from eth0
[   12.510771] r8169 0000:03:00.0 enp3s0: renamed from eth1
[   98.260481] RTL8211E Gigabit Ethernet r8169-200:00: attached PHY
driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=r8169-200:00,
irq=IGNORE)
[   98.457724] r8169 0000:02:00.0 enp2s0: Link is Down
[   98.458179] ip (2283) used greatest stack depth: 12368 bytes left
[   98.607572] audit: type=1325 audit(1556021892.932:2): table=filter
family=2 entries=4
[   98.614924] audit: type=1325 audit(1556021892.939:3): table=mangle
family=2 entries=6
[   98.712170] audit: type=1325 audit(1556021893.036:4): table=nat
family=2 entries=0
[   98.713102] audit: type=1325 audit(1556021893.037:5): table=nat
family=2 entries=5
[   98.782444] RTL8211E Gigabit Ethernet r8169-300:00: attached PHY
driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=r8169-300:00,
irq=IGNORE)
[   98.963963] r8169 0000:03:00.0 enp3s0: Link is Down
[  101.826648] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full -
flow control rx/tx
[  101.826675] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready

>
>
>
> > On Wed, Jul 11, 2018 at 11:40 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > If the framebuffer address provided by the Graphics Output Protocol
> > > (GOP) is covered by the UEFI memory map, it will tell us which memory
> > > attributes are permitted when mapping this region. In some cases,
> > > (KVM guest on ARM), violating this will result in loss of coherency,
> > > which means that updates sent to the framebuffer by the guest will
> > > not be observeable by the host, and the emulated display simply does
> > > not work.
> > >
> > > So if the memory map contains such a description, take the attributes
> > > field into account, and add support for creating WT or WB mappings of
> > > the framebuffer region.
> > >
> > > Cc: Peter Jones <pjones@redhat.com>
> > > Tested-by: Laszlo Ersek <lersek@redhat.com>
> > > Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  drivers/video/fbdev/efifb.c | 51 +++++++++++++++++++++++++++++--------
> > >  1 file changed, 41 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> > > index 46a4484e3da7..c6f78d27947b 100644
> > > --- a/drivers/video/fbdev/efifb.c
> > > +++ b/drivers/video/fbdev/efifb.c
> > > @@ -20,7 +20,7 @@
> > >  #include <drm/drm_connector.h>  /* For DRM_MODE_PANEL_ORIENTATION_* */
> > >
> > >  static bool request_mem_succeeded = false;
> > > -static bool nowc = false;
> > > +static u64 mem_flags = EFI_MEMORY_WC | EFI_MEMORY_UC;
> > >
> > >  static struct fb_var_screeninfo efifb_defined = {
> > >         .activate               = FB_ACTIVATE_NOW,
> > > @@ -68,8 +68,12 @@ static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
> > >
> > >  static void efifb_destroy(struct fb_info *info)
> > >  {
> > > -       if (info->screen_base)
> > > -               iounmap(info->screen_base);
> > > +       if (info->screen_base) {
> > > +               if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> > > +                       iounmap(info->screen_base);
> > > +               else
> > > +                       memunmap(info->screen_base);
> > > +       }
> > >         if (request_mem_succeeded)
> > >                 release_mem_region(info->apertures->ranges[0].base,
> > >                                    info->apertures->ranges[0].size);
> > > @@ -104,7 +108,7 @@ static int efifb_setup(char *options)
> > >                         else if (!strncmp(this_opt, "width:", 6))
> > >                                 screen_info.lfb_width = simple_strtoul(this_opt+6, NULL, 0);
> > >                         else if (!strcmp(this_opt, "nowc"))
> > > -                               nowc = true;
> > > +                               mem_flags &= ~EFI_MEMORY_WC;
> > >                 }
> > >         }
> > >
> > > @@ -164,6 +168,7 @@ static int efifb_probe(struct platform_device *dev)
> > >         unsigned int size_remap;
> > >         unsigned int size_total;
> > >         char *option = NULL;
> > > +       efi_memory_desc_t md;
> > >
> > >         if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
> > >                 return -ENODEV;
> > > @@ -272,12 +277,35 @@ static int efifb_probe(struct platform_device *dev)
> > >         info->apertures->ranges[0].base = efifb_fix.smem_start;
> > >         info->apertures->ranges[0].size = size_remap;
> > >
> > > -       if (nowc)
> > > -               info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
> > > -       else
> > > -               info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
> > > +       if (!efi_mem_desc_lookup(efifb_fix.smem_start, &md)) {
> > > +               if ((efifb_fix.smem_start + efifb_fix.smem_len) >
> > > +                   (md.phys_addr + (md.num_pages << EFI_PAGE_SHIFT))) {
> > > +                       pr_err("efifb: video memory @ 0x%lx spans multiple EFI memory regions\n",
> > > +                              efifb_fix.smem_start);
> > > +                       err = -EIO;
> > > +                       goto err_release_fb;
> > > +               }
> > > +               /*
> > > +                * If the UEFI memory map covers the efifb region, we may only
> > > +                * remap it using the attributes the memory map prescribes.
> > > +                */
> > > +               mem_flags |= EFI_MEMORY_WT | EFI_MEMORY_WB;
> > > +               mem_flags &= md.attribute;
> > > +       }
> > > +       if (mem_flags & EFI_MEMORY_WC)
> > > +               info->screen_base = ioremap_wc(efifb_fix.smem_start,
> > > +                                              efifb_fix.smem_len);
> > > +       else if (mem_flags & EFI_MEMORY_UC)
> > > +               info->screen_base = ioremap(efifb_fix.smem_start,
> > > +                                           efifb_fix.smem_len);
> > > +       else if (mem_flags & EFI_MEMORY_WT)
> > > +               info->screen_base = memremap(efifb_fix.smem_start,
> > > +                                            efifb_fix.smem_len, MEMREMAP_WT);
> > > +       else if (mem_flags & EFI_MEMORY_WB)
> > > +               info->screen_base = memremap(efifb_fix.smem_start,
> > > +                                            efifb_fix.smem_len, MEMREMAP_WB);
> > >         if (!info->screen_base) {
> > > -               pr_err("efifb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
> > > +               pr_err("efifb: abort, cannot remap video memory 0x%x @ 0x%lx\n",
> > >                         efifb_fix.smem_len, efifb_fix.smem_start);
> > >                 err = -EIO;
> > >                 goto err_release_fb;
> > > @@ -371,7 +399,10 @@ static int efifb_probe(struct platform_device *dev)
> > >  err_groups:
> > >         sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
> > >  err_unmap:
> > > -       iounmap(info->screen_base);
> > > +       if (mem_flags & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> > > +               iounmap(info->screen_base);
> > > +       else
> > > +               memunmap(info->screen_base);
> > >  err_release_fb:
> > >         framebuffer_release(info);
> > >  err_release_mem:
> > > --
> > > 2.17.1
> > >
> > >
> > >
> > >
