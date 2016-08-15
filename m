From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 0/6] Apple device properties
Date: Mon, 15 Aug 2016 18:13:58 +0200
Message-ID: <20160815161358.GA9603@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
 <20160804145710.GL3636@codeblueprint.co.uk>
 <20160809133816.GA6571@wunner.de>
 <20160815115414.GE30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160815115414.GE30909@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, x86@kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 15, 2016 at 12:54:14PM +0100, Matt Fleming wrote:
> On Tue, 09 Aug, at 03:38:16PM, Lukas Wunner wrote:
> > @@ -208,7 +201,10 @@ struct efi_config {
> >  __pure const struct efi_config *__efi_early(void);
> >  
> >  #define efi_call_early(f, ...)					\
> > -	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
> > +	__efi_early()->call(__efi_early()->is64 ?			\
> > +	((efi_boot_services_64_t *)__efi_early()->boot_services)->f :	\
> > +	((efi_boot_services_32_t *)__efi_early()->boot_services)->f,	\
> > +						       __VA_ARGS__);
> >  
> 
> You cannot use pointers from the firmware directly in mixed mode
> because the kernel is compiled for 64-bits but the firmware is using
> 32-bit addresses, so dereferencing a pointer causes a 64-bit load.

Please behold the resulting binary code, which uses a 32-bit load,
not a 64-bit load (note the "mov edi, dword [ds:rax+0x2c]").

This is a call to AllocatePool *with* my patch:

0x22c1         mov        rax, qword [ds:efi_early]
0x22c8         add        rdx, 0x10                  ; buffer size argument
0x22cc         cmp        byte [ds:rax+0x28], 0x0    ; !efi_early->is64 ?
0x22d0         mov        r8, qword [ds:rax+0x20]    ; efi_early->call()
0x22d4         mov        rax, qword [ds:rax+0x10]   ; efi_early->boot_services
0x22d8         je         0x2410
0x22de         mov        rdi, qword [ds:rax+0x40]   ; allocate_pool (64 bit)
0x22e2         xor        eax, eax
0x22e4         mov        rcx, r13                   ; buffer argument
0x22e7         mov        esi, 0x2                   ; EfiLoaderData argument
0x22ec         call       r8
...
0x2410         mov        edi, dword [ds:rax+0x2c]   ; allocate_pool (32 bit)
0x2413         jmp        0x22e2

The same *without* my patch:

0x1d41         mov        r8, qword [ds:efi_early]
0x1d48         add        r15, 0x40
0x1d4c         mov        rcx, qword [ss:rsp-0x10+arg_20] ; buffer argument
0x1d51         mov        rdx, r15                   ; buffer size argument
0x1d54         mov        esi, 0x2                   ; EfiLoaderData argument
0x1d59         mov        rdi, qword [ds:r8+0x10]    ; allocate_pool
0x1d5d         call       qword [ds:r8+0x58]         ; efi_early->call

So it looks to me like my patch should work just fine on 32-bit,
even though I cannot verify it through testing.

The ARM folks afford invocation of arbitrary boot services, it just
seemed natural to me to allow the same for x86. The portion of the
stub code which is shared between arches cannot use more than the
8 boot services supported by x86 even though ARM would be capable
of using all of them.

Of course the binary code with my patch is longer, less readable,
and needs to follow multiple indirections and I can understand if
you would rather stay with the current approach for these reasons.

But I would like to understand the "cannot jump through pointers at
runtime" argument because the binary code looks to me like it should
work on 32 bit. I guess I must be missing something obvious?

Thanks,

Lukas
