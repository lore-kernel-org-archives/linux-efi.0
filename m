From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 13:42:19 +0000
Message-ID: <20161123134219.GH24624@leverpostej>
References: <20161123104757.GE24624@leverpostej>
 <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
 <18007.1479900357@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18007.1479900357@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: lukas@wunner.de, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 11:25:57AM +0000, David Howells wrote:
> Mark Rutland <mark.rutland@arm.com> wrote:
> 
> > 	int secure_boot = efi_get_secureboot(sys_table);
> > 
> > 	if (secure_boot > 0)
> > 		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
> > 	if (secure_boot < 0)
> > 		pr_efi_err(sys_table,
> > 			"could not determine UEFI Secure Boot status.\n");
> 
> In which case, should this be moved into efi_get_secureboot() and it return a
> bool?

That would make sense to me, provided we're only likely to call that
once (and only log once).

I guess it would also make sense to change the latter case to soemthing
like:
	
	Could not determine UEFI Secure Boot status. Assuming enabled.

... so as to make it clear what the effect is.

Thanks,
Mark.
