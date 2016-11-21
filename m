From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Mon, 21 Nov 2016 20:58:38 +0100
Message-ID: <20161121195838.GA1417@wunner.de>
References: <20161117123731.GA11573@wunner.de>
 <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
 <29898.1479728811@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <29898.1479728811@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 21, 2016 at 11:46:51AM +0000, David Howells wrote:
> Lukas Wunner <lukas@wunner.de> wrote:
> > We already have the efi_call_early() macro to call boot services
> > in a manner that works across all arches and bitness variants.
> > 
> > In 4.10 there will be an efi_call_proto() macro to allow the same
> > for protocol calls:
> > http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=efi/core&id=3552fdf29f01
> > 
> > I suggest adding an efi_call_runtime() macro for arch- and bitness-
> > agnostic runtime services calls, like this:
> > 
> > #define efi_call_runtime(f, ...)					\
> > 	__efi_early()->call(efi_table_attr(efi_runtime_services, f,	\
> > 		__efi_early()->runtime_services), __VA_ARGS__)
> > 
> > For this to work you need to add a runtime_services attribute to struct
> > efi_config, this requires modifying head_32.S and head_64.S, use commit
> > 0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")
> > as a template.
> > 
> > If you define corresponding efi_call_runtime() macros for ARM, you
> > should indeed be able to share this function across arches.
> 
> I'm not sure why I need to do this if I replace get_secure_boot() from my
> patch with a call to efi_get_secureboot().

You need to do this to make the code run correctly in mixed mode
(64 bit CPU, but 32-bit EFI).

This dereferences efi_system_table_t *sys_table_arg as well as
efi_runtime_services_t *runtime:

	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;

The problem is that efi_system_table_t and efi_runtime_services_t
uses 64-bit wide elements when compiled on 64-bit (unsigned long
or void *).  They need to be cast to efi_system_table_32_t and
efi_runtime_services_32_t at runtime if EFI is 32-bit.

The efi_call_early() and efi_call_proto() macros do this
automatically.  I suggest that you add efi_call_runtime() for
symmetry.

Thanks,

Lukas
