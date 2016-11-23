From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/6] efi: Add EFI_SECURE_BOOT bit [ver #2]
Date: Wed, 23 Nov 2016 10:09:30 +0000
Message-ID: <10465.1479895770@warthog.procyon.org.uk>
References: <3710.1479895641@warthog.procyon.org.uk> <20161123092735.GA2071@wunner.de> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986059202.13790.3471243422582131819.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3710.1479895641@warthog.procyon.org.uk>
Content-ID: <10464.1479895770.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: dhowells@redhat.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > +#ifdef CONFIG_EFI
> > > +	if (boot_params.secure_boot) {
> > > +		set_bit(EFI_SECURE_BOOT, &efi.flags);
> > > +		pr_info("Secure boot enabled\n");
> > > +	}
> > > +#endif
> > > +
> > 
> > Section 20 of Documentation/CodingStyle recommends IS_ENABLED()
> > instead of #ifdef.
> 
> The problem is this:
> 
> 	arch/x86/include/asm/bitops.h:75: undefined reference to `efi'
> 
> To quote section 20: "... Thus, you still have to use an #ifdef if the code
> inside the block references symbols that will not exist if the condition is
> not met."

Okay, I take that back - it does actually work.  However, should I follow the
scheme of the rest of the file?

David
