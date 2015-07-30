From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 19:09:59 +0800
Message-ID: <20150730110959.GJ15651@linux-rxt1.site>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
 <20150730101131.GB2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730101131.GB2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 11:11:31AM +0100, Matt Fleming wrote:
> On Thu, 30 Jul, at 10:03:23AM, Borislav Petkov wrote:
> > On Thu, Jul 30, 2015 at 12:53:42AM -0700, H. Peter Anvin wrote:
> > > This changelog is at least partially incomprehensive. It also seems
> > > more than a bit aggressive to expect that 1 GB will be sufficient
> > > forever.
> > 
> > Right, before we do anything, I'd like for us to figure out first why
> > this is a problem all of a sudden. And why should we even keep boot
> > code/data, if it is fair game, once runtime services get enabled.
> > 
> > Matt, can you please chime in first before we even talk about a
> > solution...
> 
> Yeah, I do not understand the issue properly.
> 
> Why do we care about EfiBoot* regions after hibernate? Surely we've
> already freed those regions in efi_free_boot_services() during boot and
> nobody should be touching them again? If the firmware does, that's a
> whole new bug we've never encountered before.
> 
> And we obviously can't allow the runtime regions to move around during
> hibernate/resume because we've already informed the firmware where those
> regions live during SetVirtualAddressMap() at boot.
> 
> I admit that I haven't looked at the hibernate code paths. Let me go do
> that now.
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

In efi_map_regions(), kernel mapping EFI_MEMORY_RUNTIME and
EFI_BOOT_SERVICES_CODE/DATA regions to trampoline_pgd.

UEFI keeps the physical address of Runtime Code/Data were not changed in
hibernate cycle. But the changes of Boot regions causes Runtime Code/Data
mapping to different virtual address in trampoline_pgd.

The following is a case from Intel DQ57TM.

Boot:
[    0.036509] efi: mem11: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b7f7e000-0x00000000b7f9e000) va=[0xfffffffefff7e000-0xfffffffefff9e000) (0MB)
[    0.051393] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b8b4f000-0x00000000b8b50000) va=[0xfffffffefff4f000-0xfffffffefff50000) (0MB)
[    0.066271] efi: mem19: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b8c2f000-0x00000000b9135000) va=[0xfffffffeffa2f000-0xfffffffefff35000) (5MB)
[    0.081152] efi: mem21: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b9138000-0x00000000baf7d000) va=[0xfffffffefdb38000-0xfffffffeff97d000) (30MB)
[    0.096120] efi: mem23: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb04b000-0x00000000bb385000) va=[0xfffffffefd64b000-0xfffffffefd985000) (3MB)
[    0.111002] efi: mem24: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb385000-0x00000000bb3e5000) va=[0xfffffffefd585000-0xfffffffefd5e5000) (0MB)
[    0.125883] efi: mem25: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb3e5000-0x00000000bb445000) va=[0xfffffffefd3e5000-0xfffffffefd445000) (0MB)
[    0.140764] efi: mem29: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb7ff000-0x00000000bb800000) va=[0xfffffffefd1ff000-0xfffffffefd200000) (0MB)

Hibernate resumed:
[    0.036486] efi: mem11: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b7f7e000-0x00000000b7f9e000) va=[0xfffffffefff7e000-0xfffffffefff9e000) (0MB)
[    0.051375] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b8c0d000-0x00000000b9113000) va=[0xfffffffeffa0d000-0xfffffffefff13000) (5MB)	<=== order of Boot Data changed
[    0.066253] efi: mem20: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b9132000-0x00000000b9133000) va=[0xfffffffeff932000-0xfffffffeff933000) (0MB)
[    0.081135] efi: mem22: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000b9138000-0x00000000baf7d000) va=[0xfffffffefd938000-0xfffffffeff77d000) (30MB)
[    0.096103] efi: mem24: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb04b000-0x00000000bb385000) va=[0xfffffffefd44b000-0xfffffffefd785000) (3MB)
[    0.110984] efi: mem25: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb385000-0x00000000bb3e5000) va=[0xfffffffefd385000-0xfffffffefd3e5000) (0MB)	<=== va changed
[    0.125865] efi: mem26: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb3e5000-0x00000000bb445000) va=[0xfffffffefd1e5000-0xfffffffefd245000) (0MB)
[    0.140747] efi: mem30: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] pa=[0x00000000bb7ff000-0x00000000bb800000) va=[0xfffffffefcfff000-0xfffffffefd000000) (0MB)

Look at the origin va of Runtime Code is 0xfffffffefd585000, but after hibernate
result boot, the new va is 0xfffffffefd385000.

Issue machine's UEFI keeps the PA of Runtime regions unchanged, but Boot regions
moved. That causes Runtime regions mapping to different VA.



Regards
Joey Lee
