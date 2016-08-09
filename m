From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Tue, 9 Aug 2016 15:38:16 +0200
Message-ID: <20160809133816.GA6571@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
 <20160804145710.GL3636@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160804145710.GL3636@codeblueprint.co.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, x86@kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 04, 2016 at 03:57:10PM +0100, Matt Fleming wrote:
> On Thu, 28 Jul, at 02:25:41AM, Lukas Wunner wrote:
> > Specifically, is the following okay:
> > efi_early->call((unsigned long)sys_table->boottime->locate_protocol, ...)
> 
> This probably isn't going to work with EFI mixed mode because you
> can't jump through pointers at runtime - that's the whole point of the
> setup_boot_services*bits() code.
> 
> > It would be convenient to have LocateProtocol or LocateHandleBuffer in
> > struct efi_config so that they can be called with efi_call_early().
> > Would a patch to add those be entertained? Right now we only offer
> > LocateHandle and HandleProtocol, which is somewhat cumbersome and
> > needs more code as the setup_pci() functions show.
> 
> Yes, go for it. Doing this would make it work with EFI mixed mode too.

As an alternative to just adding LocateProtocol and LocateHandleBuffer
to struct efi_config, I've reworked the efi_call_early() macro to allow
invocation of arbitrary boot services by making the distinction between
64 bit and 32 bit in the macro itself using a ternary operator (see
patch below). Works fine on my 64 bit machine and looking at the
disassembled eboot.o I'm under the impression that it should work on
32 bit and mixed mode platforms as well.

Separate efi_call_early() macros could be defined for the CONFIG_X86_32
and for the (CONFIG_X86_64 && !CONFIG_EFI_MIXED) cases which omit the
ternary operator to speed things up.

And a similar macro could be defined for invocation of protocol
functions, e.g. efi_call_proto(efi_pci_io_protocol, get_location,
pci, ...), and that macro would resolve this to the get_location
element of "pci" cast to the appropriate efi_pci_io_protocol_32
or _64 struct.

You've sort of gone in the other direction with commit c116e8d60ada
("x86/efi: Split the boot stub into 32/64 code paths") by duplicating
functions, so I'm not sure if you welcome the below patch's approach.
If you'd prefer me to simply add LocateProtocol and LocateHandleBuffer
to struct efi_config just shout. :-)

Thanks,

Lukas

-- >8 --
Subject: [PATCH] x86/efi: Allow arbitrary boot services for efi_call_early()

We currently allow invocation of 8 boot services with efi_call_early().
In particular, LocateHandleBuffer and LocateProtocol are not among them.
To retrieve PCI ROMs and Apple device properties (upcoming) we're thus
forced to use the LocateHandle + HandleProtocol combo, which is
cumbersome and needs more code.

However rather than adding just LocateHandleBuffer and LocateProtocol to
struct efi_config, let's rework efi_call_early() to allow invocation of
arbitrary boot services by selecting the 64 bit vs 32 bit code path in
the macro itself. This adds one compare operation to each invocation of
a boot service and, on 32 bit platforms, two jump operations. Since this
is not a hot path, the minuscule performance penalty is arguably
outweighed by the attainable simplification of the C code.

The 8 boot services can thus be removed from struct efi_config.

No functional change intended (for now).

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 arch/x86/boot/compressed/eboot.c   | 13 +------------
 arch/x86/boot/compressed/head_32.S |  6 +++---
 arch/x86/boot/compressed/head_64.S |  8 ++++----
 arch/x86/include/asm/efi.h         | 14 +++++---------
 4 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ec6d2ef..2e0189c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -29,22 +29,11 @@ __pure const struct efi_config *__efi_early(void)
 static void setup_boot_services##bits(struct efi_config *c)		\
 {									\
 	efi_system_table_##bits##_t *table;				\
-	efi_boot_services_##bits##_t *bt;				\
 									\
 	table = (typeof(table))sys_table;				\
 									\
+	c->boot_services = table->boottime;				\
 	c->text_output = table->con_out;				\
-									\
-	bt = (typeof(bt))(unsigned long)(table->boottime);		\
-									\
-	c->allocate_pool = bt->allocate_pool;				\
-	c->allocate_pages = bt->allocate_pages;				\
-	c->get_memory_map = bt->get_memory_map;				\
-	c->free_pool = bt->free_pool;					\
-	c->free_pages = bt->free_pages;					\
-	c->locate_handle = bt->locate_handle;				\
-	c->handle_protocol = bt->handle_protocol;			\
-	c->exit_boot_services = bt->exit_boot_services;			\
 }
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1038524..fd0b6a2 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -82,7 +82,7 @@ ENTRY(efi_pe_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 32(%eax)
 	pushl	%eax
 
 	call	make_boot_params
@@ -108,7 +108,7 @@ ENTRY(efi32_stub_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 88(%eax)
+	add	%esi, 32(%eax)
 	pushl	%eax
 2:
 	call	efi_main
@@ -264,7 +264,7 @@ relocated:
 #ifdef CONFIG_EFI_STUB
 	.data
 efi32_config:
-	.fill 11,8,0
+	.fill 4,8,0
 	.long efi_call_phys
 	.long 0
 	.byte 0
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 0d80a7a..efdfba2 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -265,7 +265,7 @@ ENTRY(efi_pe_entry)
 	/*
 	 * Relocate efi_config->call().
 	 */
-	addq	%rbp, efi64_config+88(%rip)
+	addq	%rbp, efi64_config+32(%rip)
 
 	movq	%rax, %rdi
 	call	make_boot_params
@@ -285,7 +285,7 @@ handover_entry:
 	 * Relocate efi_config->call().
 	 */
 	movq	efi_config(%rip), %rax
-	addq	%rbp, 88(%rax)
+	addq	%rbp, 32(%rax)
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -457,14 +457,14 @@ efi_config:
 #ifdef CONFIG_EFI_MIXED
 	.global efi32_config
 efi32_config:
-	.fill	11,8,0
+	.fill	4,8,0
 	.quad	efi64_thunk
 	.byte	0
 #endif
 
 	.global efi64_config
 efi64_config:
-	.fill	11,8,0
+	.fill	4,8,0
 	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 6b06939..306203c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -192,14 +192,7 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 struct efi_config {
 	u64 image_handle;
 	u64 table;
-	u64 allocate_pool;
-	u64 allocate_pages;
-	u64 get_memory_map;
-	u64 free_pool;
-	u64 free_pages;
-	u64 locate_handle;
-	u64 handle_protocol;
-	u64 exit_boot_services;
+	u64 boot_services;
 	u64 text_output;
 	efi_status_t (*call)(unsigned long, ...);
 	bool is64;
@@ -208,7 +201,10 @@ struct efi_config {
 __pure const struct efi_config *__efi_early(void);
 
 #define efi_call_early(f, ...)						\
-	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
+	__efi_early()->call(__efi_early()->is64 ?			\
+	((efi_boot_services_64_t *)__efi_early()->boot_services)->f :	\
+	((efi_boot_services_32_t *)__efi_early()->boot_services)->f,	\
+						       __VA_ARGS__);
 
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
-- 
2.8.1
