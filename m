From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 08/10] efi/x86: Move EFI BGRT init code to early init code
Date: Mon, 15 May 2017 21:18:35 +0800
Message-ID: <20170515131835.GA5708@dhcp-128-65.nay.redhat.com>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485868902-20401-9-git-send-email-ard.biesheuvel@linaro.org>
 <20170513231827.GA1068@bistromath.localdomain>
 <20170515083740.GA30363@dhcp-128-65.nay.redhat.com>
 <20170515111037.GB1068@bistromath.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170515111037.GB1068@bistromath.localdomain>
Sender: linux-acpi-owner@vger.kernel.org
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 05/15/17 at 01:10pm, Sabrina Dubroca wrote:
> 2017-05-15, 16:37:40 +0800, Dave Young wrote:
> > Hi,
> > 
> > Thanks for the report.
> > On 05/14/17 at 01:18am, Sabrina Dubroca wrote:
> > > 2017-01-31, 13:21:40 +0000, Ard Biesheuvel wrote:
> > > > From: Dave Young <dyoung@redhat.com>
> > > > 
> > > > Before invoking the arch specific handler, efi_mem_reserve() reserves
> > > > the given memory region through memblock.
> > > > 
> > > > efi_bgrt_init() will call efi_mem_reserve() after mm_init(), at which
> > > > time memblock is dead and should not be used anymore.
> > > > 
> > > > The EFI BGRT code depends on ACPI initialization to get the BGRT ACPI
> > > > table, so move parsing of the BGRT table to ACPI early boot code to
> > > > ensure that efi_mem_reserve() in EFI BGRT code still use memblock safely.
> > > > 
> > > > Signed-off-by: Dave Young <dyoung@redhat.com>
> > > > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > > > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > > Cc: Len Brown <lenb@kernel.org>
> > > > Cc: linux-acpi@vger.kernel.org
> > > > Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > 
> > > I have a box that panics in early boot after this patch. The kernel
> > > config is based on a Fedora 25 kernel + localmodconfig.
> > > 
> > > BUG: unable to handle kernel paging request at ffffffffff240001
> > > IP: efi_bgrt_init+0xdc/0x134
> > > PGD 1ac0c067
> > > PUD 1ac0e067
> > > PMD 1aee9067
> > > PTE 9380701800000163
> > > 
> > > Oops: 0009 [#1] SMP
> > > Modules linked in:
> > > CPU: 0 PID: 0 Comm: swapper Not tainted 4.10.0-rc5-00116-g7b0a911 #19
> > > Hardware name: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
> > > task: ffffffff9fc10500 task.stack: ffffffff9fc00000
> > > RIP: 0010:efi_bgrt_init+0xdc/0x134
> > > RSP: 0000:ffffffff9fc03d58 EFLAGS: 00010082
> > > RAX: ffffffffff240001 RBX: 0000000000000000 RCX: 1380701800000006
> > > RDX: 8000000000000163 RSI: 9380701800000163 RDI: 00000000000005be
> > > RBP: ffffffff9fc03d70 R08: 1380701800001000 R09: 0000000000000002
> > > R10: 000000000002d000 R11: ffff98a3dedd2fc6 R12: ffffffff9f9f22b6
> > > R13: ffffffff9ff49480 R14: 0000000000000010 R15: 0000000000000000
> > > FS:  0000000000000000(0000) GS:ffffffff9fd20000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: ffffffffff240001 CR3: 000000001ac09000 CR4: 00000000000406b0
> > > Call Trace:
> > >  ? acpi_parse_ioapic+0x98/0x98
> > >  acpi_parse_bgrt+0x9/0xd
> > >  acpi_table_parse+0x7a/0xa9
> > >  acpi_boot_init+0x3c7/0x4f9
> > >  ? acpi_parse_x2apic+0x74/0x74
> > >  ? acpi_parse_x2apic_nmi+0x46/0x46
> > >  setup_arch+0xb4b/0xc6f
> > >  ? printk+0x52/0x6e
> > >  start_kernel+0xb2/0x47b
> > >  ? early_idt_handler_array+0x120/0x120
> > >  x86_64_start_reservations+0x24/0x26
> > >  x86_64_start_kernel+0xf7/0x11a
> > >  start_cpu+0x14/0x14
> > > Code: 48 c7 c7 10 16 a0 9f e8 4e 94 40 ff eb 62 be 06 00 00 00 e8 f9 ff 00 00 48 85 c0 75 0e 48 c7 c7 40 16 a0 9f e8 31 94 40 ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 87 00 01 00 66
> > > RIP: efi_bgrt_init+0xdc/0x134 RSP: ffffffff9fc03d58
> > > CR2: ffffffffff240001
> > > ---[ end trace f68728a0d3053b52 ]---
> > > Kernel panic - not syncing: Attempted to kill the idle task!
> > > ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> > > 
> > > 
> > > That code is:
> > > 
> > > 
> > > All code
> > > ========
> > >    0:	48 c7 c7 10 16 a0 9f 	mov    $0xffffffff9fa01610,%rdi
> > >    7:	e8 4e 94 40 ff       	callq  0xffffffffff40945a
> > >    c:	eb 62                	jmp    0x70
> > >    e:	be 06 00 00 00       	mov    $0x6,%esi
> > >   13:	e8 f9 ff 00 00       	callq  0x10011
> > >   18:	48 85 c0             	test   %rax,%rax
> > >   1b:	75 0e                	jne    0x2b
> > >   1d:	48 c7 c7 40 16 a0 9f 	mov    $0xffffffff9fa01640,%rdi
> > >   24:	e8 31 94 40 ff       	callq  0xffffffffff40945a
> > >   29:	eb 45                	jmp    0x70
> > >   2b:*	66 44 8b 20          	mov    (%rax),%r12w		<-- trapping instruction
> > >   2f:	be 06 00 00 00       	mov    $0x6,%esi
> > >   34:	48 89 c7             	mov    %rax,%rdi
> > >   37:	8b 58 02             	mov    0x2(%rax),%ebx
> > >   3a:	e8 87 00 01 00       	callq  0x100c6
> > >   3f:	66                   	data16
> > > 
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0:	66 44 8b 20          	mov    (%rax),%r12w
> > >    4:	be 06 00 00 00       	mov    $0x6,%esi
> > >    9:	48 89 c7             	mov    %rax,%rdi
> > >    c:	8b 58 02             	mov    0x2(%rax),%ebx
> > >    f:	e8 87 00 01 00       	callq  0x1009b
> > >   14:	66                   	data16
> > > 
> > > 
> > > which is just after the early_memremap() call.
> > > 
> > > I enabled early_ioremap_debug and the last warning had:
> > > 
> > > __early_ioremap(1380701800001000, 00001000) [1] => 00000001 + ffffffffff240000
> > 
> > The phys addr looks odd..
> > 
> > From the kernel log, I do not see any efi messages so can you check if
> > you are booting with legacy mode or efi boot?
> 
> I don't have physical access to the machine, but even from a succesful
> boot there's no efi message. No /sys/firmware/efi as well, and
> efivarfs isn't registered despite it being compiled in
> (on kernel 4.10.14-200.fc25.x86_64):
> 
>     # mount -t efivarfs none /mnt/foo
>     mount: unknown filesystem type 'efivarfs'
> 
> So I suppose it's legacy mode and the
>     !efi_enabled(EFI_RUNTIME_SERVICES)
> check kicking in.
> 
> 
> > I suppose bgrt are efi only, if you are test with legacy boot it is odd
> > that there is BGRT table populated.
> > 
> > For debugging purpose maybe you can add some printk to dump the acpi
> > table header in efi_bgrt_init function, just print the version, status,
> > image_type, image_address.
> 
> Added:
> 
>        pr_info("%s acpi_table_bgrt.version %hu\n", __func__, bgrt->version);
>        pr_info("%s acpi_table_bgrt.status %hhu\n", __func__, bgrt->status);
>        pr_info("%s acpi_table_bgrt.image_type %hhu\n", __func__, bgrt->image_type);
>        pr_info("%s acpi_table_bgrt.image_address %llx\n", __func__, bgrt->image_address);
>        print_hex_dump(KERN_INFO, "efi_bgrt_init acpi_table_bgrt", DUMP_PREFIX_OFFSET, 16, 1, bgrt, sizeof(*bgrt), false);
> 
> efi_bgrt: efi_bgrt_init acpi_table_bgrt.version 1
> efi_bgrt: efi_bgrt_init acpi_table_bgrt.status 0
> efi_bgrt: efi_bgrt_init acpi_table_bgrt.image_type 0
> efi_bgrt: efi_bgrt_init acpi_table_bgrt.image_address 1380701800000001
> efi_bgrt_init acpi_table_bgrt: 00000000: 42 47 52 54 3c 00 00 00 00 8b 48 50 51 4f 45 4d
> efi_bgrt_init acpi_table_bgrt: 00000010: 53 4c 49 43 2d 57 4b 53 09 20 07 01 41 4d 49 20
> efi_bgrt_init acpi_table_bgrt: 00000020: 13 00 01 00 01 00 00 00 01 00 00 00 18 70 80 13
> efi_bgrt_init acpi_table_bgrt: 00000030: 00 00 00 00 ff 00 00 00
> 
> 
> > If you can prove it is a non-efi boot, then maybe you can test below
> > patch:
> 
> Yeah, that works.  I guess that makes sense, since before this patch,
> efi_bgrt_init() wasn't called on that box (because of the
> EFI_RUNTIME_SERVICES check in start_kernel()).

Ok, thanks for the testing, from your debug log, it proved this is the
root cause.

> 
> Thanks!
> 
> > diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> > index 04ca876..b986e26 100644
> > --- a/arch/x86/platform/efi/efi-bgrt.c
> > +++ b/arch/x86/platform/efi/efi-bgrt.c
> > @@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
> >  	if (acpi_disabled)
> >  		return;
> >  
> > +	if (!efi_enabled(EFI_CONFIG_TABLES))

A better version should be checking EFI_BOOT, could you retest with
below instead? If it works I can send a patch with your Tested-by:
if (!efi_enabled(EFI_BOOT))

> > +		return;
> > +
> >  	if (table->length < sizeof(bgrt_tab)) {
> >  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
> >  		       table->length, sizeof(bgrt_tab));
> > 
> 
> -- 
> Sabrina

Thanks
Dave
