From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 09:12:45 +0000
Message-ID: <20140310091245.GF10262@console-pimps.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <531D7786020000780012230D@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <531D7786020000780012230D@nat28.tlf.novell.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Carpenter <dan.carpenter@oracle.com>, Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>, kernel-janitors@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 10 Mar, at 07:27:50AM, Jan Beulich wrote:
> 
> Is it such a bad thing to be prepared for this sort of machine to
> arrive even if likely there are none so far?

I think it's a bad thing for us to carry code in the kernel that has no
users, yes.

If someone wants it in the future, they can pull it out of git.

-- 
Matt Fleming, Intel Open Source Technology Center
