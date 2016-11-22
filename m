From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status
Date: Tue, 22 Nov 2016 21:30:58 +0100
Message-ID: <20161122203058.GA1844@wunner.de>
References: <20161122104401.GC1552@wunner.de>
 <20161117123731.GA11573@wunner.de>
 <147977472115.6360.13015228230799369019.stgit@warthog.procyon.org.uk>
 <7199.1479826047@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7199.1479826047@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 22, 2016 at 02:47:27PM +0000, David Howells wrote:
> Lukas Wunner <lukas@wunner.de> wrote:
> > The "out_efi_err" portion differs from the previous version of this
> > patch.  Setting a __u8 to a negative value, is this really what you
> > want?
> 
> Eh?  efi_get_secureboot() returns an int as before.  The out_efi_err:
> portions are exactly the same:

By "the previous version of this patch" I was referring to your
submission of Nov 16, not the existing code in the kernel.
Your patch didn't contain the out_efi_err portion.

You're assigning a negative value to boot_params->secure_boot
(which is declared __u8).

In the next patch you're just checking if the value isn't 0
and you're considerung secure boot to be enabled even though
GetVariable failed.  Hence my question above, is this what
you want?  Likely not, perhaps this is what you really want:

	boot_params->secure_boot = (efi_get_secureboot() == 1);

Best regards,

Lukas
