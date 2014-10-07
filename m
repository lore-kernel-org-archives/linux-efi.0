From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Capsule update support
Date: Tue, 7 Oct 2014 15:47:03 +0100
Message-ID: <20141007144703.GL14343@console-pimps.org>
References: <1412692886-25306-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412692886-25306-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 07 Oct, at 03:41:26PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The EFI capsule mechanism allows data blobs to be passed to the EFI
> firmware. This patch just introduces the main infrastruture for
> interacting with the firmware.
> 
> Once a capsule has been passed to the firmware, the next reboot will
> always be performed using the ResetSystem() EFI runtime service, which
> may involve overriding the reboot type specified by reboot=. This
> ensures the reset value returned by QueryCapsuleCapabilities() is used
> to reset the system, which is required for the capsule to be processed.
> 
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Bah, sorry. Ignore this one, it was supposed to be part of a series.
I'll resend.

-- 
Matt Fleming, Intel Open Source Technology Center
