From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Wed, 11 Jan 2017 15:27:23 +0000
Message-ID: <7948.1484148443@warthog.procyon.org.uk>
References: <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170111143304.GA29649@codeblueprint.co.uk>
Content-ID: <7947.1484148443.1@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@codeblueprint.co.uk> wrote:

> > +	movb	$0, BP_secure_boot(%rsi)
> >  #ifdef CONFIG_EFI_STUB
> >  	/*
> >  	 * The entry point for the PE/COFF executable is efi_pe_entry, so
> 
> Is clearing ::secure_boot really necessary? Any code path that goes
> via efi_main() will set it correctly and all other code paths should
> get it cleared in sanitize_boot_params(), no?

No.

The boot_params->secure_boot parameter exists whether or not efi_main() is
traversed (ie. if EFI isn't enabled or CONFIG_EFI_STUB=n) and, if not cleared,
is of uncertain value.

Further, sanitize_boot_params() has to be modified by this patch so as not to
clobber the secure_boot flag.

> What's the distinction between the unset and unknown enums?

unset -> The flag was cleared by head.S and efi_get_secureboot() was never
called.

unknown -> efi_get_secureboot() tried and failed to access the EFI variables
that should give the state.

David
