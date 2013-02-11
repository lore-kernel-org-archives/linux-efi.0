From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] Chainsaw efivars.c
Date: Mon, 11 Feb 2013 14:49:58 +0000
Message-ID: <20130211144958.GL6197@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Feb, at 08:59:11PM, Matt Fleming wrote:
> 
> This patch series introduces the new efivar_entry API, and splits out
> the major parts of efivars.c into new files. There's more work TODO,
> but this is at least a start.
> 
> The series is also available on the 'chainsaw' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux.git

I posted some new version of these patches and updated the above
branch based on feedback from Seiji. Thanks Seiji.

I hadn't realised that there were already some efivars pstore patches
queued up in linux-next, so I'll respin this series once they've been
merged into Linus' tree.

In the meantime, further feedback is welcome.

-- 
Matt Fleming, Intel Open Source Technology Center
