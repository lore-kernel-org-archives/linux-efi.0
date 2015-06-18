From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Thu, 18 Jun 2015 23:02:41 +0100
Message-ID: <20150618220241.GA2776@codeblueprint.co.uk>
References: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
 <loom.20150615T232724-11@post.gmane.org>
 <55804C91.4030000@fensystems.co.uk>
 <20150616173725.GE13153@oranje.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150616173725.GE13153-QpTgeCMhooRo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 16 Jun, at 11:37:25AM, Linn Crosetto wrote:
> 
> I have been reverting this patch as a workaround. The fields need to be changed,
> but I am not that familiar with the code. Maybe there is a way to use a
> heuristic to calculate the best values based on init_sz?

Linn, could you please provide some details of the system that you're
booting this kernel on? EDK2 does not include any checks for this
alignment requirement, which probably explains why no one else ever
caught this issue.

I can't think of any way to fix this without simply doing a revert of
commit aeffc4928ea2 ("x86/efi: Request desired alignment via the PE/COFF
headers"). Especially since that patch was an optimisation and not a bug
fix.

-- 
Matt Fleming, Intel Open Source Technology Center
