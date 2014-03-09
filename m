From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 19:00:53 +0000
Message-ID: <20140309190053.GA29555@srcf.ucam.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140309185028.GB10262@console-pimps.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 09, 2014 at 06:50:28PM +0000, Matt Fleming wrote:

> Is there any value in that? Do machines exist where we absolutely must
> have access to the EFI time services? Either because there's no other
> method or no other working one?

In theory we get timezones, which we otherwise only get if we have an 
ACPI TAD device.

> I can check again, but I'm pretty sure this ASUS machine under my desk
> always returns a vendor-specific error code when invoked, even with
> Borislav's 1:1 patches. Enabling EFI services just because they exist
> hasn't worked out well for us in the past.

Returning an error doesn't seem like a problem, as long as it's not 
actually killing the machine in the process...

> And of course, the GPF_KERNEL alloc under spinlock bug that started this
> thread needs to be fixed.

Losing phys_efi_get_time() doesn't seem like it ought to be much of a 
problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
