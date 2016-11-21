From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Mon, 21 Nov 2016 11:46:51 +0000
Message-ID: <29898.1479728811@warthog.procyon.org.uk>
References: <20161117123731.GA11573@wunner.de> <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk> <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161117123731.GA11573@wunner.de>
Content-ID: <29897.1479728811.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Lukas Wunner <lukas@wunner.de> wrote:

> We already have the efi_call_early() macro to call boot services
> in a manner that works across all arches and bitness variants.
> 
> In 4.10 there will be an efi_call_proto() macro to allow the same
> for protocol calls:
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=efi/core&id=3552fdf29f01
> 
> I suggest adding an efi_call_runtime() macro for arch- and bitness-
> agnostic runtime services calls, like this:
> 
> #define efi_call_runtime(f, ...)					\
> 	__efi_early()->call(efi_table_attr(efi_runtime_services, f,	\
> 		__efi_early()->runtime_services), __VA_ARGS__)
> 
> For this to work you need to add a runtime_services attribute to struct
> efi_config, this requires modifying head_32.S and head_64.S, use commit
> 0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")
> as a template.
> 
> If you define corresponding efi_call_runtime() macros for ARM, you
> should indeed be able to share this function across arches.

I'm not sure why I need to do this if I replace get_secure_boot() from my
patch with a call to efi_get_secureboot().

David
