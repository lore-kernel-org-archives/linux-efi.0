From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Wed, 4 May 2016 12:46:05 +0100
Message-ID: <20160504114605.GH2839@codeblueprint.co.uk>
References: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
 <20160503090229.GC27540@pd.tnic>
 <20160503141201.GW2839@codeblueprint.co.uk>
 <20160504093031.GA4074@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504093031.GA4074-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 04 May, at 11:30:31AM, Borislav Petkov wrote:
> 
> Hmmm, so panic() does bust_spinlocks() and efi_capsule_pending() could
> look at oops_in_progress which is set by bust_spinlocks() and that would
> probably solve the panic case but maybe the normal reboot case would
> still hang...
 
But emergency_restart() is called after bust_spinlocks(0) which can
reset oops_in_progress, so can't even use that to solve the panic
case.
