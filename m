From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Date: Mon, 30 Sep 2013 10:22:07 +0100
Message-ID: <20130930092207.GN21381@console-pimps.org>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
 <20130925125840.GK21381@console-pimps.org>
 <20130925224541.GT13098@oranje.fc.hp.com>
 <20130926113400.GM21381@console-pimps.org>
 <20130927234607.GA17867@oranje.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130927234607.GA17867-QpTgeCMhooRo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 27 Sep, at 05:46:07PM, Linn Crosetto wrote:
> Given that we have already successfully called exit_boot_services, can
> we still make this call to free_pool?

Urgh, good point. The answer is "no, not really".

I'll add your change verbatim and push out the 'next' branch again.

-- 
Matt Fleming, Intel Open Source Technology Center
