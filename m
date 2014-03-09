From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 16:31:41 +0000
Message-ID: <20140309163141.GA18824@srcf.ucam.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140309161946.GA10262@console-pimps.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Nathan Zimmer <nzimmer@sgi.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
List-Id: linux-efi@vger.kernel.org

On Sun, Mar 09, 2014 at 04:20:20PM +0000, Matt Fleming wrote:

> We have tried to use the time functions before, with little success
> because of various bugs in the runtime implementations, e.g. see commit
> bacef661acdb ("x86-64/efi: Use EFI to deal with platform wall clock")
> and commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall
> clock (again)").

I'd naively expected that these would be more reliable after the 1:1 
mapping patches, so it might actually be time to give them another go.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
