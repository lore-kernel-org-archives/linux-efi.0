From: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Wed, 16 Oct 2013 13:14:16 -0700
Message-ID: <20131016201416.GG7456@tassilo.jf.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1381931460-6999-6-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> +	  It should be noted that enabling this opton will pass a capsule
> +	  to the firmware on every boot. Some firmware will not allow a
> +	  user to enter the BIOS setup when a capsule has been registered
> +	  on the previous boot.

That sounds like a problem. Can this be fixed to only do it on demand?

> +
> +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> +	  runtime service. This option will enable code that may not function
> +	  correctly with your firmware.

Do we need white/black lists? 

Controlling such things form CONFIG is not very good.

-Andi
